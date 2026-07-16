"""Joint shared-event factorization of causal-set spatial distances.

Stage A13 showed that separately completing and embedding overlapping local
intervals produces incompatible charts.  This Stage A14 successor assigns one
spatial vector to every event in one count-derived central interval.  Johnston
time coordinates and comparable-pair spatial distances supply a partial
Euclidean distance problem.  A weighted stress fit uses only a training subset
of those distances plus noncausal separation inequalities.

Ranks are compared on held-out comparable pairs and selected by the standard
one-standard-error rule.  Sprinkling coordinates are used only after selection
for affine and causal-relation controls.  Dimension, density, global endpoints,
local interval scale, rank candidates, and thresholds remain supplied.  This
is a conditional numerical oracle, not a bare-order continuum derivation.
"""

from __future__ import annotations

import argparse
import json
import math
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np
from scipy.optimize import minimize

from causal_intrinsic_probe_metric import (
    causal_relation_matrix,
    local_affine_jacobian,
)
from causal_johnston_full_embedding import (
    all_open_interval_counts,
    binary_sensitivity_specificity,
    induced_causal_relation,
    johnston_full_embedding_from_relation,
)
from causal_johnston_multi_anchor_atlas import select_local_interval_endpoints
from causal_johnston_probe_metric import (
    causal_interval_points,
    choose_intrinsic_pivot,
    intrinsic_time_and_radius_from_relation,
    minkowski_interval_coefficient,
    proper_squared_from_open_counts,
)
from causal_operator_metric import finite_statistics


@dataclass(frozen=True)
class ConstraintSplit:
    causal_left: np.ndarray
    causal_right: np.ndarray
    causal_distance: np.ndarray
    causal_weight: np.ndarray
    causal_train: np.ndarray
    causal_heldout: np.ndarray
    noncausal_left: np.ndarray
    noncausal_right: np.ndarray
    noncausal_train: np.ndarray
    noncausal_heldout: np.ndarray


@dataclass(frozen=True)
class RankFactorization:
    spatial_rank: int
    coordinates: np.ndarray
    converged: bool
    iterations: int
    objective: float
    heldout_causal_mse: float
    heldout_causal_standard_error: float
    heldout_causal_relative_rmse: float
    heldout_noncausal_violation_fraction: float
    heldout_noncausal_margin_relative_rmse: float


@dataclass(frozen=True)
class SharedFactorizationSample:
    noncausal_penalty: float
    carrier_count: int
    causal_training_pairs: int
    causal_heldout_pairs: int
    noncausal_training_pairs: int
    noncausal_heldout_pairs: int
    selected_spatial_rank: int
    rank_selection_threshold: float
    best_heldout_causal_mse: float
    selected_heldout_causal_relative_rmse: float
    selected_heldout_noncausal_violation_fraction: float
    selected_heldout_noncausal_margin_relative_rmse: float
    selected_converged: bool
    selected_iterations: int
    selected_objective: float
    shared_affine_fit_median: float | None
    shared_affine_fit_maximum: float | None
    baseline_affine_fit_median: float | None
    shared_rank_four_fraction: float | None
    shared_condition_median: float | None
    causal_sensitivity: float
    causal_specificity: float
    rank_heldout_causal_relative_rmse: dict[str, float]
    rank_heldout_causal_mse: dict[str, float]
    passes_factorization_gate: bool
    passes_geometry_gate: bool


def penalty_key(value: float) -> str:
    """Stable JSON key for a noncausal hinge penalty."""

    return f"noncausal_penalty={value:.6f}"


def _pair_positions(mask: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    left, right = np.where(mask)
    return left.astype(int), right.astype(int)


def build_constraint_split(
    rng: np.random.Generator,
    relation: np.ndarray,
    open_counts: np.ndarray,
    intrinsic_time: np.ndarray,
    density: float,
    dimension: int,
    endpoint_positions: tuple[int, int],
    heldout_fraction: float,
    minimum_heldout_open_count: int,
    maximum_noncausal_pairs: int,
) -> ConstraintSplit:
    """Freeze comparable-distance and noncausal-inequality train/test sets."""

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    if open_counts.shape != relation.shape:
        raise ValueError("open counts must match the relation")
    if intrinsic_time.shape != (len(relation),):
        raise ValueError("intrinsic time must match the relation")
    if not 0.0 < heldout_fraction < 1.0:
        raise ValueError("held-out fraction must lie strictly between zero and one")
    if minimum_heldout_open_count < 0 or maximum_noncausal_pairs < 2:
        raise ValueError("pair-selection controls must be nonnegative")

    causal_left, causal_right = _pair_positions(relation)
    proper_squared = proper_squared_from_open_counts(
        open_counts, density, dimension
    )
    delta_time = intrinsic_time[causal_left] - intrinsic_time[causal_right]
    causal_distance = np.sqrt(
        np.abs(
            delta_time**2
            - proper_squared[causal_left, causal_right]
        )
    )
    inclusive_count = open_counts[causal_left, causal_right].astype(float) + 2.0
    causal_weight = np.sqrt(inclusive_count)
    causal_weight /= float(np.mean(causal_weight))

    lower, upper = endpoint_positions
    touches_endpoint = (
        (causal_left == lower)
        | (causal_left == upper)
        | (causal_right == lower)
        | (causal_right == upper)
    )
    eligible_heldout = np.flatnonzero(
        (~touches_endpoint)
        & (
            open_counts[causal_left, causal_right]
            >= minimum_heldout_open_count
        )
    )
    if len(eligible_heldout) == 0:
        eligible_heldout = np.flatnonzero(~touches_endpoint)
    if len(eligible_heldout) == 0:
        raise ValueError("central interval has no interior comparable pair to hold out")
    shuffled = rng.permutation(eligible_heldout)
    heldout_count = max(1, int(math.floor(heldout_fraction * len(shuffled))))
    causal_heldout = np.sort(shuffled[:heldout_count])
    train_mask = np.ones(len(causal_left), dtype=bool)
    train_mask[causal_heldout] = False
    causal_train = np.flatnonzero(train_mask)

    unrelated = ~(relation | relation.T | np.eye(len(relation), dtype=bool))
    noncausal_left, noncausal_right = _pair_positions(np.triu(unrelated, k=1))
    if len(noncausal_left) > maximum_noncausal_pairs:
        selected = np.sort(
            rng.choice(
                len(noncausal_left),
                size=maximum_noncausal_pairs,
                replace=False,
            )
        )
        noncausal_left = noncausal_left[selected]
        noncausal_right = noncausal_right[selected]
    noncausal_order = rng.permutation(len(noncausal_left))
    noncausal_heldout_count = max(
        1, int(math.floor(heldout_fraction * len(noncausal_order)))
    )
    noncausal_heldout = np.sort(noncausal_order[:noncausal_heldout_count])
    noncausal_train = np.sort(noncausal_order[noncausal_heldout_count:])

    return ConstraintSplit(
        causal_left=causal_left,
        causal_right=causal_right,
        causal_distance=causal_distance,
        causal_weight=causal_weight,
        causal_train=causal_train,
        causal_heldout=causal_heldout,
        noncausal_left=noncausal_left,
        noncausal_right=noncausal_right,
        noncausal_train=noncausal_train,
        noncausal_heldout=noncausal_heldout,
    )


def spatial_stress_value_and_gradient(
    flat_coordinates: np.ndarray,
    event_count: int,
    spatial_rank: int,
    intrinsic_time: np.ndarray,
    split: ConstraintSplit,
    noncausal_penalty: float,
) -> tuple[float, np.ndarray]:
    """Weighted causal stress plus a noncausal timelike-margin hinge."""

    coordinates = flat_coordinates.reshape(event_count, spatial_rank)
    train = split.causal_train
    left = split.causal_left[train]
    right = split.causal_right[train]
    target = split.causal_distance[train]
    weights = split.causal_weight[train]
    delta = coordinates[left] - coordinates[right]
    distance = np.sqrt(np.sum(delta**2, axis=1) + 1.0e-16)
    residual = distance - target
    scale = max(float(np.average(target**2, weights=weights)), 1.0e-12)
    weight_sum = float(np.sum(weights))
    objective = float(np.sum(weights * residual**2) / (weight_sum * scale))
    coefficient = 2.0 * weights * residual / (
        weight_sum * scale * distance
    )
    edge_gradient = coefficient[:, None] * delta
    gradient = np.zeros_like(coordinates)
    np.add.at(gradient, left, edge_gradient)
    np.add.at(gradient, right, -edge_gradient)

    if noncausal_penalty > 0.0 and len(split.noncausal_train) > 0:
        noncausal = split.noncausal_train
        left = split.noncausal_left[noncausal]
        right = split.noncausal_right[noncausal]
        delta = coordinates[left] - coordinates[right]
        distance = np.sqrt(np.sum(delta**2, axis=1) + 1.0e-16)
        time_margin = np.abs(intrinsic_time[left] - intrinsic_time[right])
        violation = np.maximum(time_margin - distance, 0.0)
        margin_scale = max(float(np.mean(time_margin**2)), 1.0e-12)
        objective += noncausal_penalty * float(
            np.mean(violation**2) / margin_scale
        )
        coefficient = -2.0 * noncausal_penalty * violation / (
            len(noncausal) * margin_scale * distance
        )
        edge_gradient = coefficient[:, None] * delta
        np.add.at(gradient, left, edge_gradient)
        np.add.at(gradient, right, -edge_gradient)

    return objective, gradient.ravel()


def fit_shared_spatial_coordinates(
    initial_coordinates: np.ndarray,
    intrinsic_time: np.ndarray,
    split: ConstraintSplit,
    noncausal_penalty: float,
    maximum_iterations: int,
) -> RankFactorization:
    """Fit one coordinate vector per event and score untouched constraints."""

    if initial_coordinates.ndim != 2:
        raise ValueError("initial coordinates must be a matrix")
    event_count, spatial_rank = initial_coordinates.shape
    if intrinsic_time.shape != (event_count,):
        raise ValueError("intrinsic time must match initial coordinates")
    if noncausal_penalty < 0.0 or maximum_iterations <= 0:
        raise ValueError("optimization controls must be positive")

    centered = initial_coordinates - np.mean(initial_coordinates, axis=0)
    result = minimize(
        spatial_stress_value_and_gradient,
        centered.ravel(),
        args=(
            event_count,
            spatial_rank,
            intrinsic_time,
            split,
            noncausal_penalty,
        ),
        method="L-BFGS-B",
        jac=True,
        options={
            "maxiter": maximum_iterations,
            "ftol": 1.0e-10,
            "gtol": 1.0e-7,
            "maxcor": 24,
        },
    )
    coordinates = result.x.reshape(event_count, spatial_rank)
    coordinates -= np.mean(coordinates, axis=0)
    gradient_inf = float(np.max(np.abs(result.jac)))
    converged = bool(result.success or gradient_inf <= 2.0e-5)

    heldout = split.causal_heldout
    left = split.causal_left[heldout]
    right = split.causal_right[heldout]
    target = split.causal_distance[heldout]
    weights = split.causal_weight[heldout]
    predicted = np.linalg.norm(coordinates[left] - coordinates[right], axis=1)
    scale = max(float(np.average(target**2, weights=weights)), 1.0e-12)
    normalized_squared_error = (predicted - target) ** 2 / scale
    heldout_mse = float(np.average(normalized_squared_error, weights=weights))
    if len(heldout) < 2:
        heldout_standard_error = 0.0
    else:
        centered_error = normalized_squared_error - heldout_mse
        weighted_variance = float(
            np.average(centered_error**2, weights=weights)
        )
        heldout_standard_error = math.sqrt(weighted_variance / len(heldout))

    noncausal = split.noncausal_heldout
    left = split.noncausal_left[noncausal]
    right = split.noncausal_right[noncausal]
    predicted = np.linalg.norm(coordinates[left] - coordinates[right], axis=1)
    time_margin = np.abs(intrinsic_time[left] - intrinsic_time[right])
    violation = np.maximum(time_margin - predicted, 0.0)
    margin_scale = max(float(np.mean(time_margin**2)), 1.0e-12)

    return RankFactorization(
        spatial_rank=spatial_rank,
        coordinates=coordinates,
        converged=converged,
        iterations=int(result.nit),
        objective=float(result.fun),
        heldout_causal_mse=heldout_mse,
        heldout_causal_standard_error=heldout_standard_error,
        heldout_causal_relative_rmse=math.sqrt(heldout_mse),
        heldout_noncausal_violation_fraction=float(np.mean(violation > 0.0)),
        heldout_noncausal_margin_relative_rmse=math.sqrt(
            float(np.mean(violation**2) / margin_scale)
        ),
    )


def select_rank_one_standard_error(
    fits: list[RankFactorization],
) -> tuple[RankFactorization, float, float]:
    """Choose the smallest rank statistically indistinguishable from the best."""

    if not fits:
        raise ValueError("at least one rank fit is required")
    ordered = sorted(fits, key=lambda fit: fit.spatial_rank)
    best = min(ordered, key=lambda fit: fit.heldout_causal_mse)
    threshold = best.heldout_causal_mse + best.heldout_causal_standard_error
    admissible = [fit for fit in ordered if fit.heldout_causal_mse <= threshold]
    return admissible[0], threshold, best.heldout_causal_mse


def _median(values: list[float]) -> float | None:
    return None if not values else float(np.median(values))


def _maximum(values: list[float]) -> float | None:
    return None if not values else float(np.max(values))


def _target_affine_controls(
    points: np.ndarray,
    coordinates: np.ndarray,
    pivot_position: int,
    targets: list[int],
    affine_radius: float,
) -> tuple[list[float], list[int], list[float]]:
    errors: list[float] = []
    ranks: list[int] = []
    conditions: list[float] = []
    for target in targets:
        distance = np.linalg.norm(coordinates - coordinates[target], axis=1)
        inner = distance <= affine_radius
        if np.count_nonzero(inner) < 6:
            nearest = np.argsort(distance)[: min(12, len(distance))]
            inner = np.zeros(len(distance), dtype=bool)
            inner[nearest] = True
        _, error, rank, condition = local_affine_jacobian(
            points,
            target,
            coordinates - coordinates[target],
            inner,
        )
        errors.append(error)
        ranks.append(rank)
        if condition is not None:
            conditions.append(condition)
    if pivot_position not in targets:
        raise ValueError("affine-control targets must include the pivot")
    return errors, ranks, conditions


def reconstruct_shared_factorization_realization(
    rng: np.random.Generator,
    events: int,
    duration: float,
    dimension: int,
    block_size: int,
    anchor_half_time: float,
    rank_candidates: list[int],
    noncausal_penalties: list[float],
    heldout_fraction: float,
    minimum_heldout_open_count: int,
    maximum_noncausal_pairs: int,
    maximum_iterations: int,
    affine_radius: float,
    maximum_affine_targets: int,
    minimum_lightcone_count: int,
    maximum_causal_error: float,
    maximum_noncausal_violation_fraction: float,
    maximum_affine_error: float,
    minimum_causal_sensitivity: float,
    minimum_causal_specificity: float,
) -> list[SharedFactorizationSample]:
    """Build one shared central geometry and score each hinge penalty."""

    points, bottom_index, top_index = causal_interval_points(
        rng, events, duration
    )
    relation = causal_relation_matrix(points, block_size)
    coefficient = minkowski_interval_coefficient(dimension)
    density = events / (coefficient * duration**dimension)
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
    lower, upper, _, _, _ = select_local_interval_endpoints(
        relation,
        pivot_index,
        density,
        dimension,
        anchor_half_time,
    )
    event_indices = np.arange(events)
    carrier = np.flatnonzero(
        (relation[lower, :] & relation[:, upper])
        | (event_indices == lower)
        | (event_indices == upper)
    )
    positions = {int(event): position for position, event in enumerate(carrier)}
    pivot_position = positions[pivot_index]
    local_relation = relation[np.ix_(carrier, carrier)]
    all_counts = all_open_interval_counts(relation)
    local_counts = all_counts[np.ix_(carrier, carrier)]
    local_time = intrinsic_time[carrier]
    split = build_constraint_split(
        rng,
        local_relation,
        local_counts,
        local_time,
        density,
        dimension,
        (positions[lower], positions[upper]),
        heldout_fraction,
        minimum_heldout_open_count,
        maximum_noncausal_pairs,
    )

    maximum_rank = max(rank_candidates)
    initial_embedding = johnston_full_embedding_from_relation(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        duration,
        spatial_rank=maximum_rank,
        eigenvalue_count=max(9, maximum_rank + 2),
    )
    initial_spatial = initial_embedding.coordinates[carrier, 1:]
    recovered_radius = np.linalg.norm(
        initial_embedding.coordinates[carrier]
        - initial_embedding.coordinates[pivot_index],
        axis=1,
    )
    past_counts = np.count_nonzero(local_relation, axis=0)
    future_counts = np.count_nonzero(local_relation, axis=1)
    affine_targets = [
        position
        for position in range(len(carrier))
        if position == pivot_position
        or (
            past_counts[position] >= minimum_lightcone_count
            and future_counts[position] >= minimum_lightcone_count
        )
    ]
    affine_targets.sort(key=lambda position: (recovered_radius[position], position))
    affine_targets = affine_targets[:maximum_affine_targets]
    if pivot_position not in affine_targets:
        affine_targets[-1] = pivot_position

    samples: list[SharedFactorizationSample] = []
    for penalty in noncausal_penalties:
        fits = [
            fit_shared_spatial_coordinates(
                initial_spatial[:, :rank],
                local_time,
                split,
                penalty,
                maximum_iterations,
            )
            for rank in rank_candidates
        ]
        selected, threshold, best_mse = select_rank_one_standard_error(fits)
        shared_coordinates = np.column_stack(
            (local_time, selected.coordinates)
        )
        baseline_coordinates = np.column_stack(
            (
                local_time,
                initial_spatial[:, : selected.spatial_rank],
            )
        )
        shared_errors, shared_ranks, shared_conditions = _target_affine_controls(
            points[carrier],
            shared_coordinates,
            pivot_position,
            affine_targets,
            affine_radius,
        )
        baseline_errors, _, _ = _target_affine_controls(
            points[carrier],
            baseline_coordinates,
            pivot_position,
            affine_targets,
            affine_radius,
        )
        induced = induced_causal_relation(shared_coordinates)
        sensitivity, specificity = binary_sensitivity_specificity(
            local_relation, induced
        )
        affine_median = _median(shared_errors)
        rank_four_fraction = (
            None
            if not shared_ranks
            else sum(rank == dimension for rank in shared_ranks) / len(shared_ranks)
        )
        factorization_gate = (
            selected.converged
            and selected.spatial_rank == dimension - 1
            and selected.heldout_causal_relative_rmse <= maximum_causal_error
            and selected.heldout_noncausal_violation_fraction
            <= maximum_noncausal_violation_fraction
        )
        geometry_gate = (
            factorization_gate
            and affine_median is not None
            and affine_median <= maximum_affine_error
            and rank_four_fraction == 1.0
            and sensitivity >= minimum_causal_sensitivity
            and specificity >= minimum_causal_specificity
        )
        samples.append(
            SharedFactorizationSample(
                noncausal_penalty=penalty,
                carrier_count=len(carrier),
                causal_training_pairs=len(split.causal_train),
                causal_heldout_pairs=len(split.causal_heldout),
                noncausal_training_pairs=len(split.noncausal_train),
                noncausal_heldout_pairs=len(split.noncausal_heldout),
                selected_spatial_rank=selected.spatial_rank,
                rank_selection_threshold=threshold,
                best_heldout_causal_mse=best_mse,
                selected_heldout_causal_relative_rmse=(
                    selected.heldout_causal_relative_rmse
                ),
                selected_heldout_noncausal_violation_fraction=(
                    selected.heldout_noncausal_violation_fraction
                ),
                selected_heldout_noncausal_margin_relative_rmse=(
                    selected.heldout_noncausal_margin_relative_rmse
                ),
                selected_converged=selected.converged,
                selected_iterations=selected.iterations,
                selected_objective=selected.objective,
                shared_affine_fit_median=affine_median,
                shared_affine_fit_maximum=_maximum(shared_errors),
                baseline_affine_fit_median=_median(baseline_errors),
                shared_rank_four_fraction=rank_four_fraction,
                shared_condition_median=_median(shared_conditions),
                causal_sensitivity=sensitivity,
                causal_specificity=specificity,
                rank_heldout_causal_relative_rmse={
                    str(fit.spatial_rank): fit.heldout_causal_relative_rmse
                    for fit in fits
                },
                rank_heldout_causal_mse={
                    str(fit.spatial_rank): fit.heldout_causal_mse for fit in fits
                },
                passes_factorization_gate=factorization_gate,
                passes_geometry_gate=geometry_gate,
            )
        )
    return samples


def summarize_samples(
    samples: list[SharedFactorizationSample],
) -> dict[str, dict[str, object]]:
    """Group shared-factorization samples by noncausal penalty."""

    grouped: dict[str, list[SharedFactorizationSample]] = {}
    for sample in samples:
        grouped.setdefault(penalty_key(sample.noncausal_penalty), []).append(sample)

    def summarize(group: list[SharedFactorizationSample]) -> dict[str, object]:
        def statistics(attribute: str) -> dict[str, float | int | None]:
            return finite_statistics(
                [getattr(sample, attribute) for sample in group]
            )

        def rate(attribute: str) -> float:
            return sum(bool(getattr(sample, attribute)) for sample in group) / len(
                group
            )

        rank_counts: dict[str, int] = {}
        for sample in group:
            key = str(sample.selected_spatial_rank)
            rank_counts[key] = rank_counts.get(key, 0) + 1
        return {
            "noncausal_penalty": group[0].noncausal_penalty,
            "samples": len(group),
            "carrier_count": statistics("carrier_count"),
            "causal_training_pairs": statistics("causal_training_pairs"),
            "causal_heldout_pairs": statistics("causal_heldout_pairs"),
            "noncausal_training_pairs": statistics("noncausal_training_pairs"),
            "noncausal_heldout_pairs": statistics("noncausal_heldout_pairs"),
            "selected_spatial_rank": statistics("selected_spatial_rank"),
            "selected_spatial_rank_counts": rank_counts,
            "selected_heldout_causal_relative_rmse": statistics(
                "selected_heldout_causal_relative_rmse"
            ),
            "selected_heldout_noncausal_violation_fraction": statistics(
                "selected_heldout_noncausal_violation_fraction"
            ),
            "selected_heldout_noncausal_margin_relative_rmse": statistics(
                "selected_heldout_noncausal_margin_relative_rmse"
            ),
            "selected_convergence_rate": rate("selected_converged"),
            "shared_affine_fit_median": statistics("shared_affine_fit_median"),
            "baseline_affine_fit_median": statistics("baseline_affine_fit_median"),
            "shared_rank_four_fraction": statistics("shared_rank_four_fraction"),
            "shared_condition_median": statistics("shared_condition_median"),
            "causal_sensitivity": statistics("causal_sensitivity"),
            "causal_specificity": statistics("causal_specificity"),
            "factorization_gate_success_rate": rate("passes_factorization_gate"),
            "geometry_gate_success_rate": rate("passes_geometry_gate"),
        }

    return {key: summarize(group) for key, group in sorted(grouped.items())}


def select_noncausal_penalty(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    """Select gates first, then held-out causal and noncausal errors."""

    def median(summary: dict[str, object], key: str) -> float:
        statistic = summary[key]
        if not isinstance(statistic, dict):
            raise TypeError(f"{key} must contain summary statistics")
        value = statistic["median"]
        return float("inf") if value is None else float(value)

    def score(item: tuple[str, dict[str, object]]) -> tuple[object, ...]:
        key, summary = item
        return (
            -float(summary["geometry_gate_success_rate"]),
            -float(summary["factorization_gate_success_rate"]),
            median(summary, "selected_heldout_causal_relative_rmse"),
            median(summary, "selected_heldout_noncausal_violation_fraction"),
            float(summary["noncausal_penalty"]),
            key,
        )

    if not summaries:
        raise ValueError("at least one penalty summary is required")
    return min(summaries.items(), key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Run development selection or one frozen held-out evaluation."""

    if args.dimension != 4:
        raise ValueError("this benchmark is frozen in four dimensions")
    if args.events < 4 or args.realizations <= 0:
        raise ValueError("events and realizations must be positive")
    rank_candidates = sorted(set(args.rank_candidates))
    if not rank_candidates or rank_candidates[0] <= 0:
        raise ValueError("rank candidates must be positive")
    penalties = sorted(set(args.noncausal_penalties))
    if not penalties or penalties[0] < 0.0:
        raise ValueError("noncausal penalties must be nonnegative")

    seed_sequence = np.random.SeedSequence(args.seed)
    samples = [
        sample
        for child in seed_sequence.spawn(args.realizations)
        for sample in reconstruct_shared_factorization_realization(
            np.random.default_rng(child),
            args.events,
            args.duration,
            args.dimension,
            args.block_size,
            args.anchor_half_time,
            rank_candidates,
            penalties,
            args.heldout_fraction,
            args.minimum_heldout_open_count,
            args.maximum_noncausal_pairs,
            args.maximum_iterations,
            args.affine_radius,
            args.maximum_affine_targets,
            args.minimum_lightcone_count,
            args.maximum_causal_error,
            args.maximum_noncausal_violation_fraction,
            args.maximum_affine_error,
            args.minimum_causal_sensitivity,
            args.minimum_causal_specificity,
        )
    ]
    summaries = summarize_samples(samples)
    if args.frozen_noncausal_penalty is None:
        selected_key, selected_summary = select_noncausal_penalty(summaries)
        status = "closed shared-factorization development selection"
    else:
        if len(penalties) != 1 or not np.isclose(
            penalties[0], args.frozen_noncausal_penalty
        ):
            raise ValueError("held-out mode requires one matching frozen penalty")
        selected_key = penalty_key(args.frozen_noncausal_penalty)
        selected_summary = summaries[selected_key]
        status = "frozen held-out shared-factorization evaluation"

    coefficient = minkowski_interval_coefficient(args.dimension)
    density = args.events / (coefficient * args.duration**args.dimension)
    result: dict[str, object] = {
        "status": status,
        "construction_uses_embedding_coordinates": False,
        "initialization_uses_order_derived_johnston_embedding": True,
        "rank_selection_uses_only_heldout_order_derived_distances": True,
        "affine_and_causal_controls_use_embedding_coordinates": True,
        "metric_scores_opened": False,
        "dimension_is_supplied": True,
        "density_is_supplied": True,
        "global_interval_endpoints_are_supplied": True,
        "settings": {
            "events_including_endpoints": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "density": density,
            "anchor_half_time": args.anchor_half_time,
            "rank_candidates": rank_candidates,
            "noncausal_penalties": penalties,
            "heldout_fraction": args.heldout_fraction,
            "minimum_heldout_open_count": args.minimum_heldout_open_count,
            "maximum_noncausal_pairs": args.maximum_noncausal_pairs,
            "maximum_iterations": args.maximum_iterations,
            "affine_radius": args.affine_radius,
            "maximum_affine_targets": args.maximum_affine_targets,
            "minimum_lightcone_count": args.minimum_lightcone_count,
            "maximum_causal_error": args.maximum_causal_error,
            "maximum_noncausal_violation_fraction": (
                args.maximum_noncausal_violation_fraction
            ),
            "maximum_affine_error": args.maximum_affine_error,
            "minimum_causal_sensitivity": args.minimum_causal_sensitivity,
            "minimum_causal_specificity": args.minimum_causal_specificity,
            "seed": args.seed,
        },
        "selection_rule": (
            "maximum geometry and factorization gate rates, then held-out "
            "causal error, noncausal violation, and smaller penalty"
        ),
        "selected_penalty_key": selected_key,
        "selected_penalty_summary": selected_summary,
        "summaries": summaries,
    }
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--events", type=int, default=2500)
    parser.add_argument("--realizations", type=int, default=5)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--dimension", type=int, default=4)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--anchor-half-time", type=float, default=0.25)
    parser.add_argument(
        "--rank-candidates", type=int, nargs="+", default=[1, 2, 3, 4, 5]
    )
    parser.add_argument(
        "--noncausal-penalties", type=float, nargs="+", default=[0.0, 0.1, 1.0]
    )
    parser.add_argument("--heldout-fraction", type=float, default=0.20)
    parser.add_argument("--minimum-heldout-open-count", type=int, default=2)
    parser.add_argument("--maximum-noncausal-pairs", type=int, default=6000)
    parser.add_argument("--maximum-iterations", type=int, default=400)
    parser.add_argument("--affine-radius", type=float, default=0.15)
    parser.add_argument("--maximum-affine-targets", type=int, default=12)
    parser.add_argument("--minimum-lightcone-count", type=int, default=6)
    parser.add_argument("--maximum-causal-error", type=float, default=0.25)
    parser.add_argument(
        "--maximum-noncausal-violation-fraction", type=float, default=0.05
    )
    parser.add_argument("--maximum-affine-error", type=float, default=0.25)
    parser.add_argument("--minimum-causal-sensitivity", type=float, default=0.90)
    parser.add_argument("--minimum-causal-specificity", type=float, default=0.90)
    parser.add_argument("--seed", type=int, default=20260812)
    parser.add_argument("--frozen-noncausal-penalty", type=float)
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
    else:
        print(encoded)


if __name__ == "__main__":
    main()
