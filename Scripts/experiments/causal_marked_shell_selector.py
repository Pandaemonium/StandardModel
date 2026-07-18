"""Deterministic marked-Alexandrov shell-angular ``1+3`` selector.

This module implements the construction tripwires preregistered in
``AgentTasks/null-edge-marked-alexandrov-1plus3-selector-stage-plan-2026-07-16.md``.
It consumes only a finite strict causal order and marked ``bottom < x < top``
events. No sprinkling coordinates, target metric, dimension, or random seed
enters selection.

The returned sector is a finite diagnostic object. Its positive-time and
negative-shell corrected Gram signs are exact consequences of the project
coefficient row. The code does not claim availability on random causal sets,
continuum convergence, a canonical tetrad, or general relativity.
"""

from __future__ import annotations

from dataclasses import dataclass

import numpy as np

from causal_overlap_distance import validate_strict_order


@dataclass(frozen=True)
class MarkedShellSector:
    """One deterministic marked shell-angular selector output."""

    carrier: np.ndarray
    shell: np.ndarray
    radial: np.ndarray
    time_probe: np.ndarray
    shell_overlap: np.ndarray
    shell_affinity: np.ndarray
    shell_laplacian_eigenvalues: np.ndarray
    shell_spatial_basis: np.ndarray
    shell_spatial_projector: np.ndarray
    triplet_gap: float
    corrected_gram: np.ndarray
    corrected_inertia: tuple[int, int, int]


def source_local_4d_prefactor(ell: float) -> float:
    """Project local four-dimensional prefactor, positive for nonzero ``ell``."""

    if ell == 0.0:
        raise ValueError("ell must be nonzero")
    return float(4.0 / (np.sqrt(6.0) * ell**2))


def source_local_4d_coefficient(layer: int) -> float:
    """Project coefficient row ``(1, -9, 16, -8, 0, ...)``."""

    return float({0: 1.0, 1: -9.0, 2: 16.0, 3: -8.0}.get(layer, 0.0))


def open_interval_count_matrix(relation: np.ndarray) -> np.ndarray:
    """Return ``|{z : y < z < x}|`` for every ordered pair ``(y, x)``."""

    validate_strict_order(relation)
    integer_relation = relation.astype(np.int64, copy=False)
    return integer_relation @ integer_relation


def past_layer(
    relation: np.ndarray,
    open_counts: np.ndarray,
    evaluation: int,
    layer: int,
    allowed: np.ndarray | None = None,
) -> np.ndarray:
    """Events in the displayed strict-past interval-count layer."""

    if layer < 0:
        raise ValueError("layer must be nonnegative")
    mask = relation[:, evaluation] & (open_counts[:, evaluation] == layer)
    if allowed is not None:
        if allowed.shape != mask.shape or allowed.dtype != np.bool_:
            raise ValueError("allowed must be a Boolean event mask")
        mask &= allowed
    return np.flatnonzero(mask)


def longest_path_depths(relation: np.ndarray, source: int) -> np.ndarray:
    """Longest directed-chain edge count from ``source`` to every event."""

    validate_strict_order(relation)
    events = len(relation)
    if not 0 <= source < events:
        raise ValueError("source index out of range")
    predecessor_count = np.count_nonzero(relation, axis=0)
    topological_order = np.argsort(predecessor_count, kind="stable")
    depths = np.full(events, -1, dtype=np.int64)
    depths[source] = 0
    for event in topological_order:
        if event == source:
            continue
        reachable_predecessors = np.flatnonzero(relation[:, event] & (depths >= 0))
        if len(reachable_predecessors):
            depths[event] = int(np.max(depths[reachable_predecessors])) + 1
    return depths


def intrinsic_time_probe(
    relation: np.ndarray,
    carrier: np.ndarray,
    radial: np.ndarray,
    bottom: int,
    evaluation: int,
    top: int,
) -> np.ndarray:
    """Normalized depth-asymmetry based differences supported on ``radial``."""

    from_bottom = longest_path_depths(relation, bottom)
    to_top = longest_path_depths(relation.T.copy(), top)
    if np.any(from_bottom[carrier] < 0) or np.any(to_top[carrier] < 0):
        raise ValueError("carrier is not contained in the marked interval")
    raw_time = from_bottom - to_top
    probe = np.zeros(len(relation), dtype=float)
    probe[radial] = raw_time[radial] - raw_time[evaluation]
    norm = float(np.linalg.norm(probe))
    if not norm > 0.0:
        raise ValueError("positive-radial depth projection vanishes")
    return probe / norm


def shell_overlap_matrix(
    relation: np.ndarray, bottom: int, shell: np.ndarray
) -> np.ndarray:
    """Smaller-interval common-past overlap on one marked shell."""

    validate_strict_order(relation)
    shell_size = len(shell)
    intervals: list[np.ndarray] = []
    counts: list[int] = []
    for event in shell:
        interval = relation[bottom] & relation[:, event]
        count = int(np.count_nonzero(interval))
        if count == 0:
            raise ValueError("shell event has empty interval above bottom")
        intervals.append(interval)
        counts.append(count)
    overlap = np.eye(shell_size, dtype=float)
    for left in range(shell_size):
        for right in range(left + 1, shell_size):
            common = int(np.count_nonzero(intervals[left] & intervals[right]))
            value = common / min(counts[left], counts[right])
            overlap[left, right] = value
            overlap[right, left] = value
    return overlap


def shell_normalized_laplacian(
    overlap: np.ndarray,
    epsilon_floor: float,
    sigma_quantile: float,
) -> tuple[np.ndarray, np.ndarray]:
    """Build the preregistered Gaussian affinity and normalized Laplacian."""

    if overlap.ndim != 2 or overlap.shape[0] != overlap.shape[1]:
        raise ValueError("overlap must be square")
    if not np.allclose(overlap, overlap.T):
        raise ValueError("overlap must be symmetric")
    if not 0.0 < epsilon_floor < 1.0:
        raise ValueError("epsilon_floor must lie in (0, 1)")
    if not 0.0 <= sigma_quantile <= 1.0:
        raise ValueError("sigma_quantile must lie in [0, 1]")
    size = len(overlap)
    off_diagonal = ~np.eye(size, dtype=bool)
    delta = -np.log(np.maximum(overlap, epsilon_floor))
    nonzero_delta = delta[off_diagonal & (delta > 0.0)]
    if not len(nonzero_delta):
        raise ValueError("shell has no nonzero overlap separations")
    sigma = float(np.quantile(nonzero_delta, sigma_quantile))
    if not sigma > 0.0:
        raise ValueError("overlap bandwidth is not positive")
    exponent = np.minimum((delta / sigma) ** 2, 700.0)
    affinity = np.exp(-exponent)
    np.fill_diagonal(affinity, 0.0)
    degree = np.sum(affinity, axis=1)
    if np.any(degree <= 0.0):
        raise ValueError("shell affinity has an isolated event")
    inverse_sqrt_degree = 1.0 / np.sqrt(degree)
    normalized = inverse_sqrt_degree[:, None] * affinity * inverse_sqrt_degree[None, :]
    laplacian = np.eye(size) - normalized
    return affinity, laplacian


def first_three_nonconstant_modes(
    laplacian: np.ndarray,
) -> tuple[np.ndarray, np.ndarray, np.ndarray, float]:
    """Return the first nonconstant triplet and its basis-independent projector."""

    if len(laplacian) < 5:
        raise ValueError("shell needs three modes plus one excluded control mode")
    eigenvalues, eigenvectors = np.linalg.eigh(laplacian)
    scale = float(np.max(np.abs(eigenvalues))) or 1.0
    zero_tolerance = 1e-9 * scale
    if int(np.count_nonzero(np.abs(eigenvalues) <= zero_tolerance)) != 1:
        raise ValueError("shell affinity must have exactly one constant mode")
    basis = eigenvectors[:, 1:4]
    projector = basis @ basis.T
    gap = float(eigenvalues[4] - eigenvalues[3])
    if not gap > zero_tolerance:
        raise ValueError("spatial triplet is not isolated from the next mode")
    return eigenvalues, basis, projector, gap


def project_local_weight_row(
    relation: np.ndarray,
    open_counts: np.ndarray,
    evaluation: int,
    ell: float,
) -> np.ndarray:
    """Project-sign corrected-pairing weights at the marked evaluation event."""

    prefactor = source_local_4d_prefactor(ell)
    weights = np.zeros(len(relation), dtype=float)
    for event in np.flatnonzero(relation[:, evaluation]):
        layer = int(open_counts[event, evaluation])
        weights[event] = -prefactor * source_local_4d_coefficient(layer)
    return weights


def corrected_probe_gram(
    weights: np.ndarray,
    evaluation: int,
    time_probe: np.ndarray,
    shell: np.ndarray,
    shell_spatial_basis: np.ndarray,
) -> np.ndarray:
    """Corrected weighted-difference Gram matrix of the selected four probes."""

    probes = np.zeros((len(weights), 4), dtype=float)
    probes[:, 0] = time_probe
    probes[shell, 1:4] = shell_spatial_basis
    based = probes - probes[evaluation]
    gram = 0.5 * based.T @ (weights[:, None] * based)
    return 0.5 * (gram + gram.T)


def matrix_inertia(matrix: np.ndarray) -> tuple[int, int, int]:
    """Return ``(positive, zero, negative)`` numerical inertia."""

    eigenvalues = np.linalg.eigvalsh(matrix)
    scale = float(np.max(np.abs(eigenvalues))) or 1.0
    tolerance = 1e-9 * scale
    return (
        int(np.count_nonzero(eigenvalues > tolerance)),
        int(np.count_nonzero(np.abs(eigenvalues) <= tolerance)),
        int(np.count_nonzero(eigenvalues < -tolerance)),
    )


def select_marked_shell_sector(
    relation: np.ndarray,
    bottom: int,
    evaluation: int,
    top: int,
    *,
    ell: float = 1.0,
    epsilon_floor: float = 1e-6,
    sigma_quantile: float = 0.5,
) -> MarkedShellSector:
    """Construct one deterministic shell-angular sector and audit its signs."""

    validate_strict_order(relation)
    events = len(relation)
    if not all(0 <= event < events for event in (bottom, evaluation, top)):
        raise ValueError("marked event index out of range")
    if not relation[bottom, evaluation] or not relation[evaluation, top]:
        raise ValueError("marked events must satisfy bottom < evaluation < top")

    open_counts = open_interval_count_matrix(relation)
    carrier_mask = relation[bottom] & relation[:, top]
    carrier_mask[bottom] = True
    carrier_mask[top] = True
    carrier = np.flatnonzero(carrier_mask)
    shell = past_layer(relation, open_counts, evaluation, 0, carrier_mask)
    radial = np.union1d(
        past_layer(relation, open_counts, evaluation, 1, carrier_mask),
        past_layer(relation, open_counts, evaluation, 3, carrier_mask),
    )
    if len(shell) < 5:
        raise ValueError("immediate-predecessor shell is too small")
    if not len(radial):
        raise ValueError("positive radial support is empty")
    if np.any(relation[np.ix_(shell, shell)]):
        raise ValueError("immediate-predecessor shell failed the antichain tripwire")
    if np.intersect1d(shell, radial).size:
        raise ValueError("shell and radial supports are not disjoint")

    time_probe = intrinsic_time_probe(
        relation, carrier, radial, bottom, evaluation, top
    )
    overlap = shell_overlap_matrix(relation, bottom, shell)
    affinity, laplacian = shell_normalized_laplacian(
        overlap, epsilon_floor, sigma_quantile
    )
    eigenvalues, basis, projector, gap = first_three_nonconstant_modes(laplacian)
    weights = project_local_weight_row(relation, open_counts, evaluation, ell)
    gram = corrected_probe_gram(weights, evaluation, time_probe, shell, basis)
    inertia = matrix_inertia(gram)
    if inertia != (1, 0, 3):
        raise ValueError(f"corrected Gram inertia mismatch: {inertia}")
    if not np.allclose(gram[0, 1:], 0.0, atol=1e-10):
        raise ValueError("time-space corrected cross block is nonzero")

    return MarkedShellSector(
        carrier=carrier,
        shell=shell,
        radial=radial,
        time_probe=time_probe,
        shell_overlap=overlap,
        shell_affinity=affinity,
        shell_laplacian_eigenvalues=eigenvalues,
        shell_spatial_basis=basis,
        shell_spatial_projector=projector,
        triplet_gap=gap,
        corrected_gram=gram,
        corrected_inertia=inertia,
    )
