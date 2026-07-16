"""Order-only probe prototypes for the causal-operator metric gate.

This Stage-A experiment removes embedding coordinates from probe construction.
It compares two intrinsic four-probe subspaces on a marked event of a finite
causal order:

* ``profile_pca``: leading modes of predecessor/successor incidence profiles,
  with a mesoscopic window determined by profile distance from the event;
* ``operator_svd``: the four lowest right-singular modes of the concrete
  smeared four-dimensional causal operator.
* ``filtered_profile``: the profile modes after a dimensionless Tikhonov
  filter constructed from the normal operator ``B_C^* B_C``.

All selectors use only the order, interval counts, supplied scales, and a
marked event. Stage A2 uses coordinates to choose that event at a preassigned
time fraction. Stage A3 instead samples it from an exact order-defined
two-sided interior and adds a timelike retarded-shell coverage gate.
Coordinates are used only after selection, when a local affine Jacobian is
fitted and the corrected pairing is compared with the target Minkowski metric.
The benchmark also recomputes each probe subspace after a random event
relabeling and compares the resulting orthogonal projectors.

This is an external numerical experiment, not a proof.  A selector fails the
pre-registered prototype gate unless it simultaneously has stable (+---)
signature, a coordinate-pulled metric error below the requested threshold, a
sufficiently affine local four-dimensional probe map, and the requested
worst-direction support and operator-row coverage.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np
from scipy import sparse
from scipy.sparse.linalg import svds

from causal_operator_metric import (
    MINKOWSKI_INVERSE,
    corrected_gamma,
    diamond_volume_4d,
    finite_statistics,
    matrix_relative_error,
    project_convention_row,
    signature,
    smeared_kernel,
    sprinkle_minkowski_diamond,
    strictly_precedes,
)


@dataclass(frozen=True)
class ProbeSelection:
    probes: np.ndarray
    inner_mask: np.ndarray
    spectrum: np.ndarray
    relative_boundary_gap: float


@dataclass(frozen=True)
class IntrinsicProbeSample:
    selector: str
    signature: tuple[int, int, int]
    eigenvalues: list[float]
    pairing_relative_error: float
    coordinate_pulled_relative_error: float | None
    local_affine_fit_relative_error: float
    local_jacobian_rank: int
    local_jacobian_condition: float | None
    relabeling_subspace_relative_error: float
    affine_probe_covariance_relative_error: float
    relative_boundary_gap: float
    interior_count: int
    retarded_shell_count: int
    target_is_interior: bool
    minimum_support_coverage: float
    minimum_row_coverage: float
    passes_prototype_gate: bool


def causal_relation_matrix(points: np.ndarray, block_size: int = 256) -> np.ndarray:
    """Strict causal relation matrix, built blockwise from oracle coordinates."""

    if points.ndim != 2 or points.shape[1] != 4:
        raise ValueError("points must have shape (N, 4)")
    if block_size <= 0:
        raise ValueError("block_size must be positive")
    relation = np.zeros((len(points), len(points)), dtype=bool)
    for start in range(0, len(points), block_size):
        stop = min(start + block_size, len(points))
        relation[start:stop] = strictly_precedes(
            points[start:stop, None, :], points[None, :, :]
        )
    return relation


def order_profiles(relation: np.ndarray) -> np.ndarray:
    """Concatenate predecessor and successor indicators for every event."""

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be a square matrix")
    return np.concatenate((relation.T, relation), axis=1)


def profile_window(
    relation: np.ndarray,
    target_index: int,
    inner_quantile: float,
    outer_quantile: float,
) -> tuple[np.ndarray, np.ndarray]:
    """Intrinsic smooth window from causal-profile Hamming distance.

    Quantile thresholds depend only on the multiset of integer profile
    distances.  Equal-distance events receive equal weights, so ties do not
    introduce a label-based ordering rule.
    """

    if not 0.0 < inner_quantile < outer_quantile < 1.0:
        raise ValueError("require 0 < inner quantile < outer quantile < 1")
    if not 0 <= target_index < len(relation):
        raise IndexError("target index is outside the relation")
    profiles = order_profiles(relation)
    distance = np.count_nonzero(profiles != profiles[target_index], axis=1)
    inner = float(np.quantile(distance, inner_quantile, method="higher"))
    outer = float(np.quantile(distance, outer_quantile, method="higher"))
    weight = np.zeros(len(relation), dtype=float)
    weight[distance <= inner] = 1.0
    if outer > inner:
        transition = (distance > inner) & (distance < outer)
        phase = (distance[transition] - inner) / (outer - inner)
        weight[transition] = 0.5 * (1.0 + np.cos(np.pi * phase))
    return weight, distance


def _relative_gap(selected_edge: float, excluded_edge: float) -> float:
    scale = max(abs(selected_edge), abs(excluded_edge), 1.0e-15)
    return float(abs(selected_edge - excluded_edge) / scale)


def profile_pca_probes(
    relation: np.ndarray,
    target_index: int,
    probe_count: int,
    inner_quantile: float,
    outer_quantile: float,
) -> ProbeSelection:
    """Leading causal-profile modes in an intrinsic mesoscopic window."""

    if probe_count <= 0 or probe_count + 1 >= len(relation):
        raise ValueError("probe count must leave at least one excluded mode")
    weight, _ = profile_window(
        relation, target_index, inner_quantile, outer_quantile
    )
    profiles = order_profiles(relation).astype(float)
    centered = (profiles - profiles[target_index]) * weight[:, None]
    mode_count = probe_count + 1
    left, singular_values, _ = svds(
        sparse.csr_matrix(centered),
        k=mode_count,
        which="LM",
        random_state=0,
    )
    order = np.argsort(singular_values)[::-1]
    singular_values = singular_values[order]
    left = left[:, order]
    probes = left[:, :probe_count] * singular_values[:probe_count]
    probes -= probes[target_index]
    return ProbeSelection(
        probes=probes,
        inner_mask=weight == 1.0,
        spectrum=singular_values,
        relative_boundary_gap=_relative_gap(
            singular_values[probe_count - 1], singular_values[probe_count]
        ),
    )


def open_interval_count_matrix(relation: np.ndarray) -> np.ndarray:
    """All strict open-interval counts from the relation alone."""

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be a square matrix")
    relation_integer = relation.astype(np.int32)
    return relation_integer @ relation_integer


def two_sided_interior(
    relation: np.ndarray,
    interval_counts: np.ndarray,
    ell: float,
    selector_scale: float,
    band_lower: float,
    band_upper: float,
    abundance_threshold: float,
) -> np.ndarray:
    """Order-only two-sided abundance interior at one selector scale."""

    if ell <= 0.0 or selector_scale <= 0.0:
        raise ValueError("interior scales must be positive")
    if not 0.0 < band_lower < band_upper:
        raise ValueError("interior band bounds must be positive and ordered")
    if abundance_threshold <= 0.0:
        raise ValueError("abundance threshold must be positive")
    nu = (selector_scale / ell) ** 4
    count_with_endpoint = interval_counts.astype(float) + 1.0
    in_band = (
        relation
        & (count_with_endpoint >= band_lower * nu)
        & (count_with_endpoint <= band_upper * nu)
    )
    past_abundance = np.count_nonzero(in_band, axis=0)
    future_abundance = np.count_nonzero(in_band, axis=1)
    required = abundance_threshold * nu
    return (past_abundance >= required) & (future_abundance >= required)


def retarded_support_shell(
    relation: np.ndarray,
    interval_counts: np.ndarray,
    interior: np.ndarray,
    target_index: int,
    ell: float,
    selector_scale: float,
    shell_lower: float,
    shell_upper: float,
) -> np.ndarray:
    """Intrinsic timelike shell in the strict past of the marked event."""

    if ell <= 0.0 or selector_scale <= 0.0:
        raise ValueError("retarded-shell scales must be positive")
    if not 0.0 < shell_lower < shell_upper:
        raise ValueError("shell bounds must be positive and ordered")
    nu = (selector_scale / ell) ** 4
    count = interval_counts[:, target_index].astype(float) + 1.0
    return (
        relation[:, target_index]
        & interior
        & (count >= shell_lower * nu)
        & (count <= shell_upper * nu)
    )


def minimum_subspace_coverage(
    centered_probes: np.ndarray,
    numerator_weight: np.ndarray,
    denominator_weight: np.ndarray,
    relative_tolerance: float = 1.0e-10,
) -> float:
    """Worst-direction generalized coverage quotient on a probe subspace."""

    numerator = centered_probes.T @ (
        numerator_weight[:, None] * centered_probes
    )
    denominator = centered_probes.T @ (
        denominator_weight[:, None] * centered_probes
    )
    denominator = 0.5 * (denominator + denominator.T)
    values, vectors = np.linalg.eigh(denominator)
    scale = max(1.0, float(np.max(np.abs(values))))
    keep = values > relative_tolerance * scale
    if np.count_nonzero(keep) < centered_probes.shape[1]:
        return 0.0
    whitening = vectors[:, keep] / np.sqrt(values[keep])[None, :]
    quotient = whitening.T @ numerator @ whitening
    minimum = float(np.min(np.linalg.eigvalsh(0.5 * (quotient + quotient.T))))
    return float(np.clip(minimum, 0.0, 1.0))


def probe_coverage_diagnostics(
    probes: np.ndarray,
    row: np.ndarray,
    target_index: int,
    relation: np.ndarray,
    interior: np.ndarray,
    shell: np.ndarray,
) -> tuple[float, float]:
    """Worst support and retarded-row coverage over all probe combinations."""

    centered = probes - probes[target_index]
    support = minimum_subspace_coverage(
        centered,
        shell.astype(float),
        interior.astype(float),
    )
    row_squared = row**2
    row_coverage = minimum_subspace_coverage(
        centered,
        shell.astype(float) * row_squared,
        relation[:, target_index].astype(float) * row_squared,
    )
    return support, row_coverage


def full_project_smeared_operator(
    relation: np.ndarray,
    ell: float,
    nonlocality_scale: float,
    interval_counts: np.ndarray | None = None,
) -> np.ndarray:
    """Dense project-sign smeared operator from order and all interval counts."""

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be a square matrix")
    if ell <= 0.0 or nonlocality_scale <= ell:
        raise ValueError("require 0 < ell < nonlocality scale")
    if interval_counts is None:
        interval_counts = open_interval_count_matrix(relation)
    epsilon = (ell / nonlocality_scale) ** 4
    prefactor = 4.0 / (np.sqrt(6.0) * nonlocality_scale**2)
    source = np.zeros(relation.shape, dtype=float)
    past_mask_by_row = relation.T
    source[past_mask_by_row] = (
        prefactor
        * epsilon
        * smeared_kernel(interval_counts.T[past_mask_by_row], epsilon)
    )
    np.fill_diagonal(source, -prefactor)
    return project_convention_row(source)


def operator_svd_probes(
    singular_values: np.ndarray,
    right_transpose: np.ndarray,
    inner_mask: np.ndarray,
    target_index: int,
    probe_count: int,
) -> ProbeSelection:
    """Lowest right-singular probe subspace of the concrete operator."""

    if right_transpose.ndim != 2 or right_transpose.shape[0] != right_transpose.shape[1]:
        raise ValueError("right singular vectors must form a square matrix")
    if probe_count <= 0 or probe_count + 1 >= len(right_transpose):
        raise ValueError("probe count must leave at least one excluded mode")
    probes = right_transpose[-probe_count:].T.copy()
    probes -= probes[target_index]
    return ProbeSelection(
        probes=probes,
        inner_mask=inner_mask,
        spectrum=singular_values,
        relative_boundary_gap=_relative_gap(
            singular_values[-probe_count], singular_values[-probe_count - 1]
        ),
    )


def filtered_profile_probes(
    profile: ProbeSelection,
    singular_values: np.ndarray,
    right_transpose: np.ndarray,
    target_index: int,
    nonlocality_scale: float,
    filter_strength: float,
) -> ProbeSelection:
    """Smooth profile probes by ``(I + tau L^4 B^* B)^-1``."""

    if filter_strength < 0.0:
        raise ValueError("filter strength must be nonnegative")
    right = right_transpose.T
    denominator = 1.0 + filter_strength * (
        nonlocality_scale**2 * singular_values
    ) ** 2
    probes = right @ (
        (right.T @ profile.probes) / denominator[:, None]
    )
    probes -= probes[target_index]
    return ProbeSelection(
        probes=probes,
        inner_mask=profile.inner_mask,
        spectrum=profile.spectrum,
        relative_boundary_gap=profile.relative_boundary_gap,
    )


def subspace_projector(probes: np.ndarray) -> np.ndarray:
    """Orthogonal projector onto a probe column space."""

    basis, _ = np.linalg.qr(probes, mode="reduced")
    return basis @ basis.T


def relabeling_subspace_error(
    original: np.ndarray,
    relabeled: np.ndarray,
    permutation: np.ndarray,
) -> float:
    """Compare probe subspaces after pulling a relabeled carrier back."""

    inverse = np.argsort(permutation)
    pulled_back = relabeled[inverse]
    return matrix_relative_error(
        subspace_projector(pulled_back), subspace_projector(original)
    )


def local_affine_jacobian(
    points: np.ndarray,
    target_index: int,
    probes: np.ndarray,
    inner_mask: np.ndarray,
) -> tuple[np.ndarray, float, int, float | None]:
    """Fit the external coordinate Jacobian after intrinsic probe selection."""

    if np.count_nonzero(inner_mask) < 6:
        raise ValueError("intrinsic inner window has too few events")
    centered_points = points[inner_mask] - points[target_index]
    design = np.column_stack((centered_points, np.ones(len(centered_points))))
    coefficients = np.linalg.lstsq(
        design, probes[inner_mask], rcond=None
    )[0]
    jacobian = coefficients[:4].T
    fitted = design @ coefficients
    fit_error = matrix_relative_error(probes[inner_mask], fitted)
    rank = int(np.linalg.matrix_rank(jacobian))
    condition = None if rank < 4 else float(np.linalg.cond(jacobian))
    return jacobian, fit_error, rank, condition


def coordinate_pulled_metric(
    pairing: np.ndarray, jacobian: np.ndarray
) -> np.ndarray | None:
    """Pull a probe-basis pairing back through a nonsingular fitted Jacobian."""

    if np.linalg.matrix_rank(jacobian) < 4:
        return None
    left_solved = np.linalg.solve(jacobian, pairing)
    return np.linalg.solve(jacobian, left_solved.T).T


def affine_covariance_error(
    row: np.ndarray,
    probes: np.ndarray,
    target_index: int,
) -> float:
    """Check finite pairing covariance under a fixed invertible probe change."""

    count = probes.shape[1]
    transform = np.eye(count)
    transform += 0.07 * np.triu(np.ones((count, count)), k=1)
    transformed = probes @ transform.T + np.linspace(-0.3, 0.4, count)
    actual = corrected_gamma(row, transformed, target_index)
    expected = transform @ corrected_gamma(row, probes, target_index) @ transform.T
    denominator = max(
        1.0,
        float(np.linalg.norm(actual, ord="fro")),
        float(np.linalg.norm(expected, ord="fro")),
    )
    return float(np.linalg.norm(actual - expected, ord="fro") / denominator)


def score_selection(
    selector: str,
    selection: ProbeSelection,
    row: np.ndarray,
    points: np.ndarray,
    target_index: int,
    relabeling_error: float,
    maximum_metric_error: float,
    maximum_fit_error: float,
    relation: np.ndarray,
    interior: np.ndarray,
    shell: np.ndarray,
    minimum_support_coverage: float,
    minimum_row_coverage: float,
) -> IntrinsicProbeSample:
    pairing = corrected_gamma(row, selection.probes, target_index)
    jacobian, fit_error, rank, condition = local_affine_jacobian(
        points,
        target_index,
        selection.probes,
        selection.inner_mask,
    )
    expected_pairing = jacobian @ MINKOWSKI_INVERSE @ jacobian.T
    pulled = coordinate_pulled_metric(pairing, jacobian)
    pulled_error = (
        None
        if pulled is None
        else matrix_relative_error(pulled, MINKOWSKI_INVERSE)
    )
    sample_signature = signature(pairing)
    support_coverage, row_coverage = probe_coverage_diagnostics(
        selection.probes,
        row,
        target_index,
        relation,
        interior,
        shell,
    )
    passes = (
        sample_signature == (1, 3, 0)
        and pulled_error is not None
        and pulled_error <= maximum_metric_error
        and fit_error <= maximum_fit_error
        and interior[target_index]
        and support_coverage >= minimum_support_coverage
        and row_coverage >= minimum_row_coverage
    )
    return IntrinsicProbeSample(
        selector=selector,
        signature=sample_signature,
        eigenvalues=np.linalg.eigvalsh(pairing).tolist(),
        pairing_relative_error=matrix_relative_error(pairing, expected_pairing),
        coordinate_pulled_relative_error=pulled_error,
        local_affine_fit_relative_error=fit_error,
        local_jacobian_rank=rank,
        local_jacobian_condition=condition,
        relabeling_subspace_relative_error=relabeling_error,
        affine_probe_covariance_relative_error=affine_covariance_error(
            row, selection.probes, target_index
        ),
        relative_boundary_gap=selection.relative_boundary_gap,
        interior_count=int(np.count_nonzero(interior)),
        retarded_shell_count=int(np.count_nonzero(shell)),
        target_is_interior=bool(interior[target_index]),
        minimum_support_coverage=support_coverage,
        minimum_row_coverage=row_coverage,
        passes_prototype_gate=passes,
    )


def evaluate_one(
    rng: np.random.Generator,
    events: int,
    duration: float,
    nonlocality_scale: float,
    block_size: int,
    probe_count: int,
    inner_quantile: float,
    outer_quantile: float,
    maximum_metric_error: float,
    maximum_fit_error: float,
    target_time_fraction: float,
    filter_strength: float,
    target_selection: str,
    selector_scale_ratio: float,
    interior_band_lower: float,
    interior_band_upper: float,
    interior_abundance_threshold: float,
    shell_lower: float,
    shell_upper: float,
    minimum_support_coverage: float,
    minimum_row_coverage: float,
) -> list[IntrinsicProbeSample]:
    points, _ = sprinkle_minkowski_diamond(rng, events, duration)
    relation = causal_relation_matrix(points, block_size)
    interval_counts = open_interval_count_matrix(relation)
    ell = (diamond_volume_4d(duration) / events) ** 0.25
    selector_scale = selector_scale_ratio * nonlocality_scale
    interior = two_sided_interior(
        relation,
        interval_counts,
        ell,
        selector_scale,
        interior_band_lower,
        interior_band_upper,
        interior_abundance_threshold,
    )
    if target_selection == "embedding_time":
        if not 0.0 < target_time_fraction <= 1.0:
            raise ValueError("target time fraction must lie in (0, 1]")
        center = np.array(
            [target_time_fraction * duration, 0.0, 0.0, 0.0]
        )
        target_index = int(np.argmin(np.sum((points - center) ** 2, axis=1)))
    elif target_selection == "intrinsic_interior":
        candidates = np.flatnonzero(interior)
        if len(candidates) == 0:
            raise ValueError("two-sided interior contains no target candidate")
        target_index = int(rng.choice(candidates))
    else:
        raise ValueError(f"unknown target selection: {target_selection}")
    shell = retarded_support_shell(
        relation,
        interval_counts,
        interior,
        target_index,
        ell,
        selector_scale,
        shell_lower,
        shell_upper,
    )
    operator = full_project_smeared_operator(
        relation, ell, nonlocality_scale, interval_counts
    )
    row = operator[target_index]
    weight, _ = profile_window(
        relation, target_index, inner_quantile, outer_quantile
    )

    profile = profile_pca_probes(
        relation,
        target_index,
        probe_count,
        inner_quantile,
        outer_quantile,
    )
    _, singular_values, right_transpose = np.linalg.svd(
        operator, full_matrices=False
    )
    operator_modes = operator_svd_probes(
        singular_values,
        right_transpose,
        weight == 1.0,
        target_index,
        probe_count,
    )
    filtered_profile = filtered_profile_probes(
        profile,
        singular_values,
        right_transpose,
        target_index,
        nonlocality_scale,
        filter_strength,
    )

    permutation = rng.permutation(len(points))
    inverse = np.argsort(permutation)
    relabeled_relation = relation[np.ix_(permutation, permutation)]
    relabeled_target = int(inverse[target_index])
    relabeled_operator = operator[np.ix_(permutation, permutation)]
    relabeled_weight, _ = profile_window(
        relabeled_relation,
        relabeled_target,
        inner_quantile,
        outer_quantile,
    )
    relabeled_profile = profile_pca_probes(
        relabeled_relation,
        relabeled_target,
        probe_count,
        inner_quantile,
        outer_quantile,
    )
    _, relabeled_singular_values, relabeled_right_transpose = np.linalg.svd(
        relabeled_operator, full_matrices=False
    )
    relabeled_operator_modes = operator_svd_probes(
        relabeled_singular_values,
        relabeled_right_transpose,
        relabeled_weight == 1.0,
        relabeled_target,
        probe_count,
    )
    relabeled_filtered_profile = filtered_profile_probes(
        relabeled_profile,
        relabeled_singular_values,
        relabeled_right_transpose,
        relabeled_target,
        nonlocality_scale,
        filter_strength,
    )

    profile_error = relabeling_subspace_error(
        profile.probes, relabeled_profile.probes, permutation
    )
    operator_error = relabeling_subspace_error(
        operator_modes.probes, relabeled_operator_modes.probes, permutation
    )
    filtered_error = relabeling_subspace_error(
        filtered_profile.probes,
        relabeled_filtered_profile.probes,
        permutation,
    )
    return [
        score_selection(
            "profile_pca",
            profile,
            row,
            points,
            target_index,
            profile_error,
            maximum_metric_error,
            maximum_fit_error,
            relation,
            interior,
            shell,
            minimum_support_coverage,
            minimum_row_coverage,
        ),
        score_selection(
            "operator_svd",
            operator_modes,
            row,
            points,
            target_index,
            operator_error,
            maximum_metric_error,
            maximum_fit_error,
            relation,
            interior,
            shell,
            minimum_support_coverage,
            minimum_row_coverage,
        ),
        score_selection(
            "filtered_profile",
            filtered_profile,
            row,
            points,
            target_index,
            filtered_error,
            maximum_metric_error,
            maximum_fit_error,
            relation,
            interior,
            shell,
            minimum_support_coverage,
            minimum_row_coverage,
        ),
    ]


def summarize(
    samples: list[IntrinsicProbeSample],
    probe_count: int,
    minimum_support_coverage: float,
    minimum_row_coverage: float,
) -> dict[str, object]:
    signature_successes = sum(s.signature == (1, 3, 0) for s in samples)
    gate_successes = sum(s.passes_prototype_gate for s in samples)
    shell_nonempty = sum(s.retarded_shell_count > 0 for s in samples)
    shell_rank_capable = sum(
        s.retarded_shell_count >= probe_count for s in samples
    )
    support_successes = sum(
        s.minimum_support_coverage >= minimum_support_coverage for s in samples
    )
    row_successes = sum(
        s.minimum_row_coverage >= minimum_row_coverage for s in samples
    )
    order_side_successes = sum(
        s.target_is_interior
        and s.retarded_shell_count >= probe_count
        and s.minimum_support_coverage >= minimum_support_coverage
        and s.minimum_row_coverage >= minimum_row_coverage
        for s in samples
    )
    return {
        "samples": len(samples),
        "signature_successes": signature_successes,
        "signature_success_rate": signature_successes / len(samples),
        "prototype_gate_successes": gate_successes,
        "prototype_gate_success_rate": gate_successes / len(samples),
        "coordinate_pulled_relative_error": finite_statistics(
            [s.coordinate_pulled_relative_error for s in samples]
        ),
        "pairing_relative_error": finite_statistics(
            [s.pairing_relative_error for s in samples]
        ),
        "local_affine_fit_relative_error": finite_statistics(
            [s.local_affine_fit_relative_error for s in samples]
        ),
        "local_jacobian_condition": finite_statistics(
            [s.local_jacobian_condition for s in samples]
        ),
        "relabeling_subspace_relative_error": finite_statistics(
            [s.relabeling_subspace_relative_error for s in samples]
        ),
        "affine_probe_covariance_relative_error": finite_statistics(
            [s.affine_probe_covariance_relative_error for s in samples]
        ),
        "relative_boundary_gap": finite_statistics(
            [s.relative_boundary_gap for s in samples]
        ),
        "interior_count": finite_statistics(
            [float(s.interior_count) for s in samples]
        ),
        "retarded_shell_count": finite_statistics(
            [float(s.retarded_shell_count) for s in samples]
        ),
        "retarded_shell_nonempty_rate": shell_nonempty / len(samples),
        "retarded_shell_rank_capable_rate": shell_rank_capable / len(samples),
        "target_interior_rate": sum(s.target_is_interior for s in samples)
        / len(samples),
        "minimum_support_coverage": finite_statistics(
            [s.minimum_support_coverage for s in samples]
        ),
        "minimum_row_coverage": finite_statistics(
            [s.minimum_row_coverage for s in samples]
        ),
        "support_coverage_success_rate": support_successes / len(samples),
        "row_coverage_success_rate": row_successes / len(samples),
        "order_side_gate_success_rate": order_side_successes / len(samples),
    }


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    if args.realizations <= 0:
        raise ValueError("realizations must be positive")
    ell = (diamond_volume_4d(args.duration) / args.events) ** 0.25
    if args.nonlocality_scale <= ell:
        raise ValueError("nonlocality scale must be strictly greater than ell")
    seed_sequence = np.random.SeedSequence(args.seed)
    all_samples = [
        evaluate_one(
            np.random.default_rng(child),
            args.events,
            args.duration,
            args.nonlocality_scale,
            args.block_size,
            args.probe_count,
            args.inner_quantile,
            args.outer_quantile,
            args.maximum_metric_error,
            args.maximum_fit_error,
            args.target_time_fraction,
            args.filter_strength,
            args.target_selection,
            args.selector_scale_ratio,
            args.interior_band_lower,
            args.interior_band_upper,
            args.interior_abundance_threshold,
            args.shell_lower,
            args.shell_upper,
            args.minimum_support_coverage,
            args.minimum_row_coverage,
        )
        for child in seed_sequence.spawn(args.realizations)
    ]
    by_selector = {
        selector: [
            sample
            for realization in all_samples
            for sample in realization
            if sample.selector == selector
        ]
        for selector in ("profile_pca", "operator_svd", "filtered_profile")
    }
    result: dict[str, object] = {
        "status": "external intrinsic-probe prototype; not a proof",
        "probe_construction_uses_embedding_coordinates": False,
        "marked_target_selected_by_embedding_oracle": (
            args.target_selection == "embedding_time"
        ),
        "scoring_uses_embedding_coordinates": True,
        "settings": {
            "events": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "ell": ell,
            "nonlocality_scale": args.nonlocality_scale,
            "epsilon": (ell / args.nonlocality_scale) ** 4,
            "probe_count": args.probe_count,
            "target_selection": args.target_selection,
            "target_time_fraction": args.target_time_fraction,
            "filter_strength": args.filter_strength,
            "selector_scale_ratio": args.selector_scale_ratio,
            "interior_band": [
                args.interior_band_lower,
                args.interior_band_upper,
            ],
            "interior_abundance_threshold": (
                args.interior_abundance_threshold
            ),
            "retarded_shell_band": [args.shell_lower, args.shell_upper],
            "minimum_support_coverage": args.minimum_support_coverage,
            "minimum_row_coverage": args.minimum_row_coverage,
            "inner_profile_quantile": args.inner_quantile,
            "outer_profile_quantile": args.outer_quantile,
            "maximum_metric_error": args.maximum_metric_error,
            "maximum_fit_error": args.maximum_fit_error,
            "seed": args.seed,
        },
        "summary": {
            selector: summarize(
                samples,
                args.probe_count,
                args.minimum_support_coverage,
                args.minimum_row_coverage,
            )
            for selector, samples in by_selector.items()
        },
    }
    if args.include_samples:
        result["samples"] = [
            [asdict(sample) for sample in realization]
            for realization in all_samples
        ]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--events", type=int, default=400)
    parser.add_argument("--realizations", type=int, default=6)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--nonlocality-scale", type=float, default=0.18)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--probe-count", type=int, default=4)
    parser.add_argument(
        "--target-selection",
        choices=("embedding_time", "intrinsic_interior"),
        default="embedding_time",
    )
    parser.add_argument("--target-time-fraction", type=float, default=0.85)
    parser.add_argument("--filter-strength", type=float, default=0.10)
    parser.add_argument("--selector-scale-ratio", type=float, default=1.0)
    parser.add_argument("--interior-band-lower", type=float, default=0.5)
    parser.add_argument("--interior-band-upper", type=float, default=2.0)
    parser.add_argument(
        "--interior-abundance-threshold", type=float, default=0.25
    )
    parser.add_argument("--shell-lower", type=float, default=0.5)
    parser.add_argument("--shell-upper", type=float, default=4.0)
    parser.add_argument("--minimum-support-coverage", type=float, default=0.80)
    parser.add_argument("--minimum-row-coverage", type=float, default=0.70)
    parser.add_argument("--inner-quantile", type=float, default=0.08)
    parser.add_argument("--outer-quantile", type=float, default=0.30)
    parser.add_argument("--maximum-metric-error", type=float, default=0.50)
    parser.add_argument("--maximum-fit-error", type=float, default=0.25)
    parser.add_argument("--seed", type=int, default=20260715)
    parser.add_argument("--include-samples", action="store_true")
    parser.add_argument("--output", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    result = run_experiment(args)
    rendered = json.dumps(result, indent=2, sort_keys=True)
    if args.output is not None:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered + "\n", encoding="utf-8", newline="\n")
    print(rendered)


if __name__ == "__main__":
    main()
