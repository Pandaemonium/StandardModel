"""Intrinsic causal-operator metric probes from interval-volume embedding.

This Stage A4 experiment clean-room implements the lightcone part of Steven
Johnston's interval-volume embedding algorithm:

    Steven Johnston, "Embedding Causal Sets into Minkowski Spacetime",
    Class. Quantum Grav. 39 (2022) 095006, arXiv:2111.09331v2,
    especially equations (17), (20), (22)-(28), and (32)-(40).

For a finite causal interval with supplied dimension and density, inclusive
interval cardinalities estimate timelike proper times.  A marked event's past
and future then determine a rectangular matrix of spatial inner products.  Its
rank-three SVD factorization gives a four-probe subspace (one intrinsic time
probe and three spatial probes) up to spatial orthogonal gauge.  Only values on
the marked event's causal past are needed by the retarded operator row.

The experiment uses embedding coordinates only to generate known sprinklings
and to score the recovered probes after construction.  It does not derive
dimension four or the absolute density from the order.  It is an external
numerical oracle, not a proof and not yet a bare-graph GR derivation.
"""

from __future__ import annotations

import argparse
import json
import math
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_intrinsic_probe_metric import (
    affine_covariance_error,
    causal_relation_matrix,
    coordinate_pulled_metric,
    local_affine_jacobian,
    subspace_projector,
)
from causal_operator_metric import (
    MINKOWSKI_INVERSE,
    compact_coordinate_probes,
    corrected_gamma,
    finite_statistics,
    matrix_relative_error,
    project_convention_row,
    smooth_compact_cutoff,
    signature,
    smeared_bd_row,
    sprinkle_minkowski_diamond,
)


@dataclass(frozen=True)
class JohnstonLightconeEmbedding:
    probes: np.ndarray
    embedded_mask: np.ndarray
    intrinsic_time: np.ndarray
    intrinsic_radius: np.ndarray
    spatial_singular_values: np.ndarray
    spatial_rank_gap: float
    dominant_spatial_gap_rank: int | None
    pivot_index: int
    past_count: int
    future_count: int
    scale_balance_residual: float


@dataclass(frozen=True)
class JohnstonMetricSample:
    signature: tuple[int, int, int]
    eigenvalues: list[float]
    oracle_probe_signature: tuple[int, int, int]
    oracle_probe_eigenvalues: list[float]
    coordinate_pulled_relative_error: float | None
    direct_metric_relative_error: float
    oracle_probe_metric_relative_error: float
    local_affine_fit_relative_error: float
    local_jacobian_rank: int
    local_jacobian_condition: float | None
    affine_probe_covariance_relative_error: float
    relabeling_time_relative_error: float
    relabeling_spatial_subspace_relative_error: float
    spatial_singular_values: list[float]
    spatial_rank_gap: float
    dominant_spatial_gap_rank: int | None
    spatial_rank_gate: bool
    pivot_intrinsic_time: float
    pivot_intrinsic_radius: float
    pivot_oracle_time: float
    pivot_oracle_radius: float
    pivot_past_count: int
    pivot_future_count: int
    scale_balance_residual: float
    passes_operator_control_gate: bool
    passes_conditional_dimension_gate: bool
    passes_prototype_gate: bool
    intrinsic_quadratic_response: float
    count_normalization_factor: float | None
    count_normalized_signature: tuple[int, int, int] | None
    count_normalized_oracle_signature: tuple[int, int, int] | None
    count_normalized_coordinate_pulled_relative_error: float | None
    count_normalized_direct_metric_relative_error: float | None
    count_normalized_oracle_metric_relative_error: float | None
    passes_count_normalized_operator_control_gate: bool
    passes_count_normalized_conditional_dimension_gate: bool
    passes_count_normalized_prototype_gate: bool
    johnston_quadratic_response: float
    johnston_quadratic_normalization_factor: float | None
    johnston_normalized_signature: tuple[int, int, int] | None
    johnston_normalized_oracle_signature: tuple[int, int, int] | None
    johnston_normalized_coordinate_pulled_relative_error: float | None
    johnston_normalized_direct_metric_relative_error: float | None
    johnston_normalized_oracle_metric_relative_error: float | None
    passes_johnston_normalized_operator_control_gate: bool
    passes_johnston_normalized_conditional_dimension_gate: bool
    passes_johnston_normalized_prototype_gate: bool


def minkowski_interval_coefficient(dimension: int) -> float:
    """Coefficient c_d in Vol(I(p,q)) = c_d tau(p,q)^d."""

    if dimension < 2:
        raise ValueError("dimension must be at least two")
    return float(
        math.pi ** ((dimension - 1) / 2)
        / (2 ** (dimension - 1) * dimension * math.gamma((dimension + 1) / 2))
    )


def causal_interval_points(
    rng: np.random.Generator,
    events: int,
    duration: float,
) -> tuple[np.ndarray, int, int]:
    """Sprinkle an interval and include exact bottom and top endpoints."""

    if events < 3:
        raise ValueError("an interval requires at least three events")
    sprinkled, _ = sprinkle_minkowski_diamond(rng, events - 2, duration)
    bottom = np.array([[0.0, 0.0, 0.0, 0.0]])
    points = np.concatenate((bottom, sprinkled), axis=0)
    return points, 0, len(points) - 1


def proper_time_squared_matrix(
    relation: np.ndarray,
    interval_counts: np.ndarray,
    density: float,
    dimension: int,
) -> np.ndarray:
    """Johnston proper-time-squared estimates for all related pairs."""

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    if interval_counts.shape != relation.shape:
        raise ValueError("interval counts must match the relation")
    if density <= 0.0:
        raise ValueError("density must be positive")
    coefficient = minkowski_interval_coefficient(dimension)
    inclusive_count = interval_counts.astype(float) + 2.0
    proper_squared = np.zeros(relation.shape, dtype=float)
    proper_squared[relation] = (
        inclusive_count[relation] / (density * coefficient)
    ) ** (2.0 / dimension)
    return proper_squared


def selected_open_interval_counts(
    relation: np.ndarray,
    left_indices: np.ndarray,
    right_indices: np.ndarray,
) -> np.ndarray:
    """Open-interval counts for one selected left-by-right block.

    Optimized float32 BLAS is exact for these zero-one sums while the event
    count remains below the checked consecutive-integer bound.
    """

    if len(relation) >= 2**24:
        raise ValueError("event count exceeds exact float32 integer range")
    left = relation[left_indices, :].astype(np.float32, copy=False)
    right = relation[:, right_indices].astype(np.float32, copy=False)
    product = left @ right
    rounded = np.rint(product)
    if not np.array_equal(product, rounded):
        raise ArithmeticError("BLAS interval counts were not integral")
    return rounded.astype(np.int32)


def proper_squared_from_open_counts(
    open_counts: np.ndarray,
    density: float,
    dimension: int,
) -> np.ndarray:
    """Convert selected open counts to inclusive-volume proper times."""

    coefficient = minkowski_interval_coefficient(dimension)
    return ((open_counts.astype(float) + 2.0) / (density * coefficient)) ** (
        2.0 / dimension
    )


def intrinsic_time_and_radius_from_relation(
    relation: np.ndarray,
    density: float,
    dimension: int,
    bottom_index: int,
    top_index: int,
    duration: float,
) -> tuple[np.ndarray, np.ndarray]:
    """Endpoint-volume time and radius without an all-pairs count matrix."""

    coefficient = minkowski_interval_coefficient(dimension)
    past_count = np.count_nonzero(relation, axis=0).astype(float)
    future_count = np.count_nonzero(relation, axis=1).astype(float)
    bottom_squared = np.zeros(len(relation), dtype=float)
    top_squared = np.zeros(len(relation), dtype=float)
    after_bottom = relation[bottom_index, :]
    before_top = relation[:, top_index]
    bottom_squared[after_bottom] = (
        (past_count[after_bottom] + 1.0) / (density * coefficient)
    ) ** (2.0 / dimension)
    top_squared[before_top] = (
        (future_count[before_top] + 1.0) / (density * coefficient)
    ) ** (2.0 / dimension)
    time = duration / 2.0 + (bottom_squared - top_squared) / (2.0 * duration)
    radial_squared = np.abs(time**2 - bottom_squared)
    return time, np.sqrt(radial_squared)


def intrinsic_time_and_radius(
    proper_squared: np.ndarray,
    bottom_index: int,
    top_index: int,
    duration: float,
) -> tuple[np.ndarray, np.ndarray]:
    """Johnston time coordinate and radial heuristic inside one interval."""

    if duration <= 0.0:
        raise ValueError("duration must be positive")
    time = duration / 2.0 + (
        proper_squared[bottom_index, :] - proper_squared[:, top_index]
    ) / (2.0 * duration)
    radial_squared = np.abs(time**2 - proper_squared[bottom_index, :])
    return time, np.sqrt(radial_squared)


def intrinsic_pivot_candidates(
    relation: np.ndarray,
    intrinsic_time: np.ndarray,
    intrinsic_radius: np.ndarray,
    bottom_index: int,
    top_index: int,
    duration: float,
    dimension: int,
) -> np.ndarray:
    """Best order-side pivot candidates following Johnston's simulation guide."""

    past_count = np.count_nonzero(relation, axis=0)
    future_count = np.count_nonzero(relation, axis=1)
    normalized_time = intrinsic_time / duration
    normalized_radius = intrinsic_radius / duration
    eligible = (
        (np.arange(len(relation)) != bottom_index)
        & (np.arange(len(relation)) != top_index)
        & (normalized_time >= 0.35)
        & (normalized_time <= 0.65)
        & (normalized_radius >= 0.10)
        & (normalized_radius <= 0.40)
        & (past_count >= dimension + 1)
        & (future_count >= dimension + 1)
    )
    candidates = np.flatnonzero(eligible)
    if len(candidates) == 0:
        eligible = (
            (np.arange(len(relation)) != bottom_index)
            & (np.arange(len(relation)) != top_index)
            & (past_count >= dimension + 1)
            & (future_count >= dimension + 1)
        )
        candidates = np.flatnonzero(eligible)
    if len(candidates) == 0:
        raise ValueError("no event has enough strict past and future support")
    abundance = np.minimum(past_count[candidates], future_count[candidates])
    return candidates[abundance == np.max(abundance)]


def choose_intrinsic_pivot(
    rng: np.random.Generator,
    relation: np.ndarray,
    intrinsic_time: np.ndarray,
    intrinsic_radius: np.ndarray,
    bottom_index: int,
    top_index: int,
    duration: float,
    dimension: int,
) -> int:
    """Sample uniformly from the invariant set of best pivot candidates."""

    candidates = intrinsic_pivot_candidates(
        relation,
        intrinsic_time,
        intrinsic_radius,
        bottom_index,
        top_index,
        duration,
        dimension,
    )
    return int(rng.choice(candidates))


def relative_singular_gaps(
    singular_values: np.ndarray,
    maximum_rank: int = 8,
    floor: float = 1.0e-12,
) -> np.ndarray:
    """Relative gaps after ranks 1 through maximum_rank."""

    stop = min(maximum_rank, len(singular_values) - 1)
    if stop <= 0:
        return np.empty(0, dtype=float)
    left = singular_values[:stop]
    right = singular_values[1 : stop + 1]
    return (left - right) / np.maximum(np.maximum(left, right), floor)


def _factor_johnston_lightcone_embedding(
    relation: np.ndarray,
    intrinsic_time: np.ndarray,
    intrinsic_radius: np.ndarray,
    past_indices: np.ndarray,
    future_indices: np.ndarray,
    past_to_future: np.ndarray,
    past_to_pivot: np.ndarray,
    pivot_to_future: np.ndarray,
    bottom_index: int,
    top_index: int,
    pivot_index: int,
    spatial_rank: int,
) -> JohnstonLightconeEmbedding:
    """Factor one prepared Johnston past-by-future inner-product block."""

    if bottom_index not in past_indices or top_index not in future_indices:
        raise ValueError("pivot must lie strictly between the interval endpoints")
    if min(len(past_indices), len(future_indices)) < spatial_rank:
        raise ValueError("pivot lightcone is too small for the spatial rank")

    minkowski_cross = 0.5 * (past_to_future - past_to_pivot - pivot_to_future)
    time_cross = (intrinsic_time[pivot_index] - intrinsic_time[past_indices])[
        :, None
    ] * (intrinsic_time[future_indices] - intrinsic_time[pivot_index])[None, :]
    spatial_inner_products = time_cross - minkowski_cross

    left, singular_values, right_transpose = np.linalg.svd(
        spatial_inner_products, full_matrices=False
    )
    root = np.sqrt(singular_values[:spatial_rank])
    past_vectors = left[:, :spatial_rank] * root[None, :]
    future_vectors = right_transpose[:spatial_rank, :].T * root[None, :]

    bottom_row = int(np.flatnonzero(past_indices == bottom_index)[0])
    top_row = int(np.flatnonzero(future_indices == top_index)[0])
    bottom_norm = float(np.linalg.norm(past_vectors[bottom_row]))
    top_norm = float(np.linalg.norm(future_vectors[top_row]))
    if bottom_norm <= 1.0e-12 or top_norm <= 1.0e-12:
        raise ValueError("endpoint vectors do not fix the SVD scaling")
    scale = math.sqrt(top_norm / bottom_norm)
    past_vectors = scale * past_vectors
    future_vectors = future_vectors / scale
    pivot_space = 0.5 * (past_vectors[bottom_row] - future_vectors[top_row])
    scale_residual = float(
        np.linalg.norm(past_vectors[bottom_row] + future_vectors[top_row])
        / max(
            np.linalg.norm(past_vectors[bottom_row]),
            np.linalg.norm(future_vectors[top_row]),
            1.0e-12,
        )
    )

    spatial = np.repeat(pivot_space[None, :], len(relation), axis=0)
    spatial[past_indices] = pivot_space[None, :] - past_vectors
    spatial[pivot_index] = pivot_space
    spatial[future_indices] = pivot_space[None, :] + future_vectors
    probes = np.column_stack((intrinsic_time, spatial))
    probes = probes - probes[pivot_index]
    embedded_mask = (
        relation[:, pivot_index]
        | relation[pivot_index, :]
        | (np.arange(len(relation)) == pivot_index)
    )

    gaps = relative_singular_gaps(singular_values)
    dominant_gap_rank = None if len(gaps) == 0 else int(np.argmax(gaps) + 1)
    rank_gap = float(gaps[spatial_rank - 1]) if len(gaps) >= spatial_rank else 1.0
    return JohnstonLightconeEmbedding(
        probes=probes,
        embedded_mask=embedded_mask,
        intrinsic_time=intrinsic_time,
        intrinsic_radius=intrinsic_radius,
        spatial_singular_values=singular_values,
        spatial_rank_gap=rank_gap,
        dominant_spatial_gap_rank=dominant_gap_rank,
        pivot_index=pivot_index,
        past_count=len(past_indices),
        future_count=len(future_indices),
        scale_balance_residual=scale_residual,
    )


def johnston_lightcone_embedding(
    relation: np.ndarray,
    proper_squared: np.ndarray,
    bottom_index: int,
    top_index: int,
    pivot_index: int,
    duration: float,
    spatial_rank: int = 3,
) -> JohnstonLightconeEmbedding:
    """Construct Johnston coordinates from an all-pairs proper-time matrix."""

    intrinsic_time, intrinsic_radius = intrinsic_time_and_radius(
        proper_squared, bottom_index, top_index, duration
    )
    past_indices = np.flatnonzero(relation[:, pivot_index])
    future_indices = np.flatnonzero(relation[pivot_index, :])
    return _factor_johnston_lightcone_embedding(
        relation,
        intrinsic_time,
        intrinsic_radius,
        past_indices,
        future_indices,
        proper_squared[np.ix_(past_indices, future_indices)],
        proper_squared[past_indices, pivot_index][:, None],
        proper_squared[pivot_index, future_indices][None, :],
        bottom_index,
        top_index,
        pivot_index,
        spatial_rank,
    )


def johnston_lightcone_embedding_from_relation(
    relation: np.ndarray,
    density: float,
    dimension: int,
    bottom_index: int,
    top_index: int,
    pivot_index: int,
    duration: float,
    spatial_rank: int = 3,
) -> JohnstonLightconeEmbedding:
    """Construct Johnston coordinates using only selected interval blocks."""

    intrinsic_time, intrinsic_radius = intrinsic_time_and_radius_from_relation(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        duration,
    )
    return johnston_lightcone_embedding_from_intrinsic_data(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        pivot_index,
        intrinsic_time,
        intrinsic_radius,
        spatial_rank=spatial_rank,
    )


def johnston_lightcone_embedding_from_intrinsic_data(
    relation: np.ndarray,
    density: float,
    dimension: int,
    bottom_index: int,
    top_index: int,
    pivot_index: int,
    intrinsic_time: np.ndarray,
    intrinsic_radius: np.ndarray,
    spatial_rank: int = 3,
) -> JohnstonLightconeEmbedding:
    """Construct a lightcone chart from cached order-derived endpoint data."""

    if intrinsic_time.shape != (len(relation),):
        raise ValueError("intrinsic time must match the relation")
    if intrinsic_radius.shape != (len(relation),):
        raise ValueError("intrinsic radius must match the relation")
    past_indices = np.flatnonzero(relation[:, pivot_index])
    future_indices = np.flatnonzero(relation[pivot_index, :])
    past_to_future = proper_squared_from_open_counts(
        selected_open_interval_counts(relation, past_indices, future_indices),
        density,
        dimension,
    )
    past_to_pivot = proper_squared_from_open_counts(
        selected_open_interval_counts(relation, past_indices, np.array([pivot_index])),
        density,
        dimension,
    )
    pivot_to_future = proper_squared_from_open_counts(
        selected_open_interval_counts(
            relation, np.array([pivot_index]), future_indices
        ),
        density,
        dimension,
    )
    return _factor_johnston_lightcone_embedding(
        relation,
        intrinsic_time,
        intrinsic_radius,
        past_indices,
        future_indices,
        past_to_future,
        past_to_pivot,
        pivot_to_future,
        bottom_index,
        top_index,
        pivot_index,
        spatial_rank,
    )


def compact_lightcone_probes(
    embedding: JohnstonLightconeEmbedding,
    support_radius: float,
) -> np.ndarray:
    """Apply the Stage A smooth cutoff in recovered coordinate gauge."""

    compact = compact_coordinate_probes(
        embedding.probes, embedding.pivot_index, support_radius
    )
    compact[~embedding.embedded_mask] = 0.0
    return compact


def lorentzian_quadratic_probe(probes: np.ndarray) -> np.ndarray:
    """Basis-gauge-invariant (+---) quadratic of four probe fields."""

    if probes.ndim != 2 or probes.shape[1] != 4:
        raise ValueError("Lorentzian quadratic requires four probe fields")
    return probes[:, 0] ** 2 - np.sum(probes[:, 1:] ** 2, axis=1)


def intrinsic_compact_quadratic_probe(
    relation: np.ndarray,
    counts_to_pivot: np.ndarray,
    density: float,
    dimension: int,
    intrinsic_time: np.ndarray,
    pivot_index: int,
    support_radius: float,
) -> np.ndarray:
    """Count-derived compact proper-time-squared probe about one pivot.

    On the strict causal past, interval volumes estimate tau squared. Together
    with endpoint-volume time, tau squared also determines the radial distance
    needed for the same smooth compact cutoff as the coordinate oracle.
    """

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    if counts_to_pivot.shape != (len(relation),):
        raise ValueError("pivot interval counts must match the relation")
    if intrinsic_time.shape != (len(relation),):
        raise ValueError("intrinsic time must match the relation")
    if not 0 <= pivot_index < len(relation):
        raise IndexError("pivot index is outside the relation")

    past = relation[:, pivot_index]
    proper_squared = np.zeros(len(relation), dtype=float)
    proper_squared[past] = proper_squared_from_open_counts(
        counts_to_pivot[past], density, dimension
    )
    time_separation = intrinsic_time[pivot_index] - intrinsic_time
    spatial_squared = np.maximum(time_separation**2 - proper_squared, 0.0)
    radial_distance = np.sqrt(time_separation**2 + spatial_squared)
    cutoff = smooth_compact_cutoff(radial_distance, support_radius)
    # The metric trace contracts products of compact probes, hence cutoff^2.
    probe = proper_squared * cutoff**2
    probe[~past] = 0.0
    probe[pivot_index] = 0.0
    return probe


def intrinsic_quadratic_normalization(
    row: np.ndarray,
    quadratic_probe: np.ndarray,
    dimension: int,
    floor: float = 1.0e-12,
) -> tuple[float, float | None]:
    """Return B(q) and the positive factor enforcing B(q) = 2d."""

    if row.shape != quadratic_probe.shape:
        raise ValueError("operator row and quadratic probe must match")
    if dimension < 2:
        raise ValueError("dimension must be at least two")
    response = float(row @ quadratic_probe)
    if not np.isfinite(response) or response <= floor:
        return response, None
    return response, 2.0 * dimension / response


def relabeling_errors(
    relation: np.ndarray,
    density: float,
    dimension: int,
    duration: float,
    bottom_index: int,
    top_index: int,
    pivot_index: int,
    support_radius: float,
    original_probes: np.ndarray,
    permutation: np.ndarray,
) -> tuple[float, float]:
    """Time-vector and spatial-subspace covariance under event relabeling."""

    inverse = np.argsort(permutation)
    moved_relation = relation[np.ix_(permutation, permutation)]
    moved = johnston_lightcone_embedding_from_relation(
        moved_relation,
        density,
        dimension,
        int(inverse[bottom_index]),
        int(inverse[top_index]),
        int(inverse[pivot_index]),
        duration,
        spatial_rank=dimension - 1,
    )
    moved_probes = compact_lightcone_probes(moved, support_radius)[inverse]
    time_error = matrix_relative_error(original_probes[:, [0]], moved_probes[:, [0]])
    spatial_error = matrix_relative_error(
        subspace_projector(original_probes[:, 1:]),
        subspace_projector(moved_probes[:, 1:]),
    )
    return time_error, spatial_error


def reconstruct_one(
    rng: np.random.Generator,
    events: int,
    duration: float,
    nonlocality_scale: float,
    support_radius: float,
    dimension: int,
    block_size: int,
    maximum_metric_error: float,
    maximum_fit_error: float,
    minimum_rank_gap: float,
) -> JohnstonMetricSample:
    points, bottom_index, top_index = causal_interval_points(rng, events, duration)
    relation = causal_relation_matrix(points, block_size)
    coefficient = minkowski_interval_coefficient(dimension)
    density = events / (coefficient * duration**dimension)
    ell = density ** (-1.0 / dimension)
    intrinsic_time, intrinsic_radius = intrinsic_time_and_radius_from_relation(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        duration,
    )
    pivot_index = choose_intrinsic_pivot(
        rng,
        relation,
        intrinsic_time,
        intrinsic_radius,
        bottom_index,
        top_index,
        duration,
        dimension,
    )
    embedding = johnston_lightcone_embedding_from_relation(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        pivot_index,
        duration,
        spatial_rank=dimension - 1,
    )
    probes = compact_lightcone_probes(embedding, support_radius)

    past = relation[:, pivot_index]
    past_indices = np.flatnonzero(past)
    counts_to_pivot = np.zeros(events, dtype=np.int64)
    counts_to_pivot[past_indices] = selected_open_interval_counts(
        relation, past_indices, np.array([pivot_index])
    )[:, 0]
    row = project_convention_row(
        smeared_bd_row(
            past,
            counts_to_pivot,
            pivot_index,
            ell,
            nonlocality_scale,
        )
    )
    quadratic_probe = intrinsic_compact_quadratic_probe(
        relation,
        counts_to_pivot,
        density,
        dimension,
        intrinsic_time,
        pivot_index,
        support_radius,
    )
    quadratic_response, count_factor = intrinsic_quadratic_normalization(
        row, quadratic_probe, dimension
    )
    johnston_quadratic_response, johnston_factor = intrinsic_quadratic_normalization(
        row, lorentzian_quadratic_probe(probes), dimension
    )
    pairing = corrected_gamma(row, probes, pivot_index)
    oracle_probes = compact_coordinate_probes(points, pivot_index, support_radius)
    oracle_pairing = corrected_gamma(row, oracle_probes, pivot_index)

    recovered_radius = np.linalg.norm(embedding.probes, axis=1)
    inner_mask = embedding.embedded_mask & (recovered_radius <= nonlocality_scale)
    minimum_affine_events = max(dimension + 1, 6)
    if np.count_nonzero(inner_mask) < minimum_affine_events:
        inner_mask = embedding.embedded_mask
    jacobian, fit_error, rank, condition = local_affine_jacobian(
        points, pivot_index, probes, inner_mask
    )
    pulled = coordinate_pulled_metric(pairing, jacobian)
    pulled_error = (
        None if pulled is None else matrix_relative_error(pulled, MINKOWSKI_INVERSE)
    )
    count_pairing = None if count_factor is None else count_factor * pairing
    count_oracle_pairing = (
        None if count_factor is None else count_factor * oracle_pairing
    )
    count_pulled = (
        None if count_factor is None or pulled is None else count_factor * pulled
    )
    count_signature = None if count_pairing is None else signature(count_pairing)
    count_oracle_signature = (
        None if count_oracle_pairing is None else signature(count_oracle_pairing)
    )
    count_pulled_error = (
        None
        if count_pulled is None
        else matrix_relative_error(count_pulled, MINKOWSKI_INVERSE)
    )
    count_direct_error = (
        None
        if count_pairing is None
        else matrix_relative_error(count_pairing, MINKOWSKI_INVERSE)
    )
    count_oracle_error = (
        None
        if count_oracle_pairing is None
        else matrix_relative_error(count_oracle_pairing, MINKOWSKI_INVERSE)
    )
    johnston_pairing = None if johnston_factor is None else johnston_factor * pairing
    johnston_oracle_pairing = (
        None if johnston_factor is None else johnston_factor * oracle_pairing
    )
    johnston_pulled = (
        None if johnston_factor is None or pulled is None else johnston_factor * pulled
    )
    johnston_signature = (
        None if johnston_pairing is None else signature(johnston_pairing)
    )
    johnston_oracle_signature = (
        None if johnston_oracle_pairing is None else signature(johnston_oracle_pairing)
    )
    johnston_pulled_error = (
        None
        if johnston_pulled is None
        else matrix_relative_error(johnston_pulled, MINKOWSKI_INVERSE)
    )
    johnston_direct_error = (
        None
        if johnston_pairing is None
        else matrix_relative_error(johnston_pairing, MINKOWSKI_INVERSE)
    )
    johnston_oracle_error = (
        None
        if johnston_oracle_pairing is None
        else matrix_relative_error(johnston_oracle_pairing, MINKOWSKI_INVERSE)
    )

    permutation = rng.permutation(events)
    time_error, spatial_error = relabeling_errors(
        relation,
        density,
        dimension,
        duration,
        bottom_index,
        top_index,
        pivot_index,
        support_radius,
        probes,
        permutation,
    )
    sample_signature = signature(pairing)
    oracle_signature = signature(oracle_pairing)
    rank_gate = (
        embedding.dominant_spatial_gap_rank == dimension - 1
        and embedding.spatial_rank_gap >= minimum_rank_gap
    )
    operator_control_gate = (
        oracle_signature == (1, dimension - 1, 0)
        and matrix_relative_error(oracle_pairing, MINKOWSKI_INVERSE)
        <= maximum_metric_error
    )
    conditional_dimension_gate = (
        sample_signature == (1, dimension - 1, 0)
        and pulled_error is not None
        and pulled_error <= maximum_metric_error
        and fit_error <= maximum_fit_error
    )
    passes = operator_control_gate and conditional_dimension_gate and rank_gate
    count_operator_control_gate = (
        count_oracle_signature == (1, dimension - 1, 0)
        and count_oracle_error is not None
        and count_oracle_error <= maximum_metric_error
    )
    count_conditional_dimension_gate = (
        count_signature == (1, dimension - 1, 0)
        and count_pulled_error is not None
        and count_pulled_error <= maximum_metric_error
        and fit_error <= maximum_fit_error
    )
    count_passes = (
        count_operator_control_gate and count_conditional_dimension_gate and rank_gate
    )
    johnston_operator_control_gate = (
        johnston_oracle_signature == (1, dimension - 1, 0)
        and johnston_oracle_error is not None
        and johnston_oracle_error <= maximum_metric_error
    )
    johnston_conditional_dimension_gate = (
        johnston_signature == (1, dimension - 1, 0)
        and johnston_pulled_error is not None
        and johnston_pulled_error <= maximum_metric_error
        and fit_error <= maximum_fit_error
    )
    johnston_passes = (
        johnston_operator_control_gate
        and johnston_conditional_dimension_gate
        and rank_gate
    )
    oracle_centered = points[pivot_index]
    return JohnstonMetricSample(
        signature=sample_signature,
        eigenvalues=np.linalg.eigvalsh(pairing).tolist(),
        oracle_probe_signature=oracle_signature,
        oracle_probe_eigenvalues=np.linalg.eigvalsh(oracle_pairing).tolist(),
        coordinate_pulled_relative_error=pulled_error,
        direct_metric_relative_error=matrix_relative_error(pairing, MINKOWSKI_INVERSE),
        oracle_probe_metric_relative_error=matrix_relative_error(
            oracle_pairing, MINKOWSKI_INVERSE
        ),
        local_affine_fit_relative_error=fit_error,
        local_jacobian_rank=rank,
        local_jacobian_condition=condition,
        affine_probe_covariance_relative_error=affine_covariance_error(
            row, probes, pivot_index
        ),
        relabeling_time_relative_error=time_error,
        relabeling_spatial_subspace_relative_error=spatial_error,
        spatial_singular_values=embedding.spatial_singular_values[:8].tolist(),
        spatial_rank_gap=embedding.spatial_rank_gap,
        dominant_spatial_gap_rank=embedding.dominant_spatial_gap_rank,
        spatial_rank_gate=rank_gate,
        pivot_intrinsic_time=float(embedding.intrinsic_time[pivot_index]),
        pivot_intrinsic_radius=float(embedding.intrinsic_radius[pivot_index]),
        pivot_oracle_time=float(oracle_centered[0]),
        pivot_oracle_radius=float(np.linalg.norm(oracle_centered[1:])),
        pivot_past_count=embedding.past_count,
        pivot_future_count=embedding.future_count,
        scale_balance_residual=embedding.scale_balance_residual,
        passes_operator_control_gate=operator_control_gate,
        passes_conditional_dimension_gate=conditional_dimension_gate,
        passes_prototype_gate=passes,
        intrinsic_quadratic_response=quadratic_response,
        count_normalization_factor=count_factor,
        count_normalized_signature=count_signature,
        count_normalized_oracle_signature=count_oracle_signature,
        count_normalized_coordinate_pulled_relative_error=(count_pulled_error),
        count_normalized_direct_metric_relative_error=count_direct_error,
        count_normalized_oracle_metric_relative_error=count_oracle_error,
        passes_count_normalized_operator_control_gate=(count_operator_control_gate),
        passes_count_normalized_conditional_dimension_gate=(
            count_conditional_dimension_gate
        ),
        passes_count_normalized_prototype_gate=count_passes,
        johnston_quadratic_response=johnston_quadratic_response,
        johnston_quadratic_normalization_factor=johnston_factor,
        johnston_normalized_signature=johnston_signature,
        johnston_normalized_oracle_signature=(johnston_oracle_signature),
        johnston_normalized_coordinate_pulled_relative_error=(johnston_pulled_error),
        johnston_normalized_direct_metric_relative_error=(johnston_direct_error),
        johnston_normalized_oracle_metric_relative_error=(johnston_oracle_error),
        passes_johnston_normalized_operator_control_gate=(
            johnston_operator_control_gate
        ),
        passes_johnston_normalized_conditional_dimension_gate=(
            johnston_conditional_dimension_gate
        ),
        passes_johnston_normalized_prototype_gate=johnston_passes,
    )


def summarize(samples: list[JohnstonMetricSample]) -> dict[str, object]:
    signature_successes = sum(s.signature == (1, 3, 0) for s in samples)
    rank_successes = sum(s.spatial_rank_gate for s in samples)
    operator_control_successes = sum(s.passes_operator_control_gate for s in samples)
    conditional_successes = sum(s.passes_conditional_dimension_gate for s in samples)
    gate_successes = sum(s.passes_prototype_gate for s in samples)
    count_normalization_successes = sum(
        s.count_normalization_factor is not None for s in samples
    )
    count_operator_successes = sum(
        s.passes_count_normalized_operator_control_gate for s in samples
    )
    count_conditional_successes = sum(
        s.passes_count_normalized_conditional_dimension_gate for s in samples
    )
    count_gate_successes = sum(
        s.passes_count_normalized_prototype_gate for s in samples
    )
    johnston_normalization_successes = sum(
        s.johnston_quadratic_normalization_factor is not None for s in samples
    )
    johnston_operator_successes = sum(
        s.passes_johnston_normalized_operator_control_gate for s in samples
    )
    johnston_conditional_successes = sum(
        s.passes_johnston_normalized_conditional_dimension_gate for s in samples
    )
    johnston_gate_successes = sum(
        s.passes_johnston_normalized_prototype_gate for s in samples
    )
    return {
        "samples": len(samples),
        "signature_success_rate": signature_successes / len(samples),
        "spatial_rank_gate_success_rate": rank_successes / len(samples),
        "operator_control_gate_success_rate": (
            operator_control_successes / len(samples)
        ),
        "conditional_dimension_gate_success_rate": (
            conditional_successes / len(samples)
        ),
        "prototype_gate_success_rate": gate_successes / len(samples),
        "count_normalization_success_rate": (
            count_normalization_successes / len(samples)
        ),
        "count_normalized_operator_control_gate_success_rate": (
            count_operator_successes / len(samples)
        ),
        "count_normalized_conditional_dimension_gate_success_rate": (
            count_conditional_successes / len(samples)
        ),
        "count_normalized_prototype_gate_success_rate": (
            count_gate_successes / len(samples)
        ),
        "johnston_quadratic_normalization_success_rate": (
            johnston_normalization_successes / len(samples)
        ),
        "johnston_normalized_operator_control_gate_success_rate": (
            johnston_operator_successes / len(samples)
        ),
        "johnston_normalized_conditional_dimension_gate_success_rate": (
            johnston_conditional_successes / len(samples)
        ),
        "johnston_normalized_prototype_gate_success_rate": (
            johnston_gate_successes / len(samples)
        ),
        "coordinate_pulled_relative_error": finite_statistics(
            [s.coordinate_pulled_relative_error for s in samples]
        ),
        "direct_metric_relative_error": finite_statistics(
            [s.direct_metric_relative_error for s in samples]
        ),
        "oracle_probe_metric_relative_error": finite_statistics(
            [s.oracle_probe_metric_relative_error for s in samples]
        ),
        "intrinsic_quadratic_response": finite_statistics(
            [s.intrinsic_quadratic_response for s in samples]
        ),
        "count_normalization_factor": finite_statistics(
            [s.count_normalization_factor for s in samples]
        ),
        "count_normalized_coordinate_pulled_relative_error": (
            finite_statistics(
                [s.count_normalized_coordinate_pulled_relative_error for s in samples]
            )
        ),
        "count_normalized_direct_metric_relative_error": finite_statistics(
            [s.count_normalized_direct_metric_relative_error for s in samples]
        ),
        "count_normalized_oracle_metric_relative_error": finite_statistics(
            [s.count_normalized_oracle_metric_relative_error for s in samples]
        ),
        "johnston_quadratic_response": finite_statistics(
            [s.johnston_quadratic_response for s in samples]
        ),
        "johnston_quadratic_normalization_factor": finite_statistics(
            [s.johnston_quadratic_normalization_factor for s in samples]
        ),
        "johnston_normalized_coordinate_pulled_relative_error": (
            finite_statistics(
                [
                    s.johnston_normalized_coordinate_pulled_relative_error
                    for s in samples
                ]
            )
        ),
        "johnston_normalized_direct_metric_relative_error": finite_statistics(
            [s.johnston_normalized_direct_metric_relative_error for s in samples]
        ),
        "johnston_normalized_oracle_metric_relative_error": finite_statistics(
            [s.johnston_normalized_oracle_metric_relative_error for s in samples]
        ),
        "local_affine_fit_relative_error": finite_statistics(
            [s.local_affine_fit_relative_error for s in samples]
        ),
        "local_jacobian_condition": finite_statistics(
            [s.local_jacobian_condition for s in samples]
        ),
        "spatial_rank_gap": finite_statistics([s.spatial_rank_gap for s in samples]),
        "scale_balance_residual": finite_statistics(
            [s.scale_balance_residual for s in samples]
        ),
        "relabeling_time_relative_error": finite_statistics(
            [s.relabeling_time_relative_error for s in samples]
        ),
        "relabeling_spatial_subspace_relative_error": finite_statistics(
            [s.relabeling_spatial_subspace_relative_error for s in samples]
        ),
        "affine_probe_covariance_relative_error": finite_statistics(
            [s.affine_probe_covariance_relative_error for s in samples]
        ),
        "pivot_intrinsic_time": finite_statistics(
            [s.pivot_intrinsic_time for s in samples]
        ),
        "pivot_oracle_time": finite_statistics([s.pivot_oracle_time for s in samples]),
        "pivot_intrinsic_radius": finite_statistics(
            [s.pivot_intrinsic_radius for s in samples]
        ),
        "pivot_oracle_radius": finite_statistics(
            [s.pivot_oracle_radius for s in samples]
        ),
    }


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    if args.dimension != 4:
        raise ValueError("this benchmark's operator and target metric are 4D")
    if args.realizations <= 0:
        raise ValueError("realizations must be positive")
    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (coefficient * args.duration**args.dimension)
    ell = density ** (-1.0 / args.dimension)
    if args.nonlocality_scale <= ell:
        raise ValueError("nonlocality scale must be strictly greater than ell")
    seed_sequence = np.random.SeedSequence(args.seed)
    samples = [
        reconstruct_one(
            np.random.default_rng(child),
            args.events,
            args.duration,
            args.nonlocality_scale,
            args.support_radius,
            args.dimension,
            args.block_size,
            args.maximum_metric_error,
            args.maximum_fit_error,
            args.minimum_rank_gap,
        )
        for child in seed_sequence.spawn(args.realizations)
    ]
    result: dict[str, object] = {
        "status": "external Johnston-probe metric prototype; not a proof",
        "probe_construction_uses_embedding_coordinates": False,
        "pivot_selection_uses_embedding_coordinates": False,
        "scoring_uses_embedding_coordinates": True,
        "dimension_is_supplied": True,
        "density_is_supplied": True,
        "settings": {
            "events_including_endpoints": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "density": density,
            "ell": ell,
            "nonlocality_scale": args.nonlocality_scale,
            "epsilon": (ell / args.nonlocality_scale) ** args.dimension,
            "support_radius": args.support_radius,
            "maximum_metric_error": args.maximum_metric_error,
            "maximum_fit_error": args.maximum_fit_error,
            "minimum_rank_gap": args.minimum_rank_gap,
            "seed": args.seed,
        },
        "summary": summarize(samples),
    }
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--events", type=int, default=500)
    parser.add_argument("--realizations", type=int, default=10)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--dimension", type=int, default=4)
    parser.add_argument("--nonlocality-scale", type=float, default=0.16)
    parser.add_argument("--support-radius", type=float, default=0.5)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--maximum-metric-error", type=float, default=0.50)
    parser.add_argument("--maximum-fit-error", type=float, default=0.25)
    parser.add_argument("--minimum-rank-gap", type=float, default=0.15)
    parser.add_argument("--seed", type=int, default=20260719)
    parser.add_argument("--include-samples", action="store_true")
    parser.add_argument("--output", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    result = run_experiment(args)
    encoded = json.dumps(result, indent=2, sort_keys=True)
    if args.output is not None:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(encoded + "\n", encoding="utf-8", newline="\n")
    print(encoded)


if __name__ == "__main__":
    main()
