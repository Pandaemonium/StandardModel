"""Full-interval causal-set embedding by spatial-distance completion.

This module clean-room implements equations (2), (4), (6), (8), (12)-(20)
of Steven Johnston, "Simpler Embeddings of Causal Sets into Minkowski
Spacetime", Phys. Rev. D 111 (2025) 106020, arXiv:2502.09701.

Supplied dimension, density, and interval endpoints convert inclusive interval
counts into proper times and a global time coordinate.  Causally related pairs
then acquire Euclidean spatial distances.  The paper's one-anchor min-plus
completion supplies distances for spacelike pairs, and truncated Euclidean MDS
embeds every event at once.  No sprinkling coordinate enters construction.

This is an external numerical oracle.  It neither derives dimension or scale
from a bare order nor proves convergence to a manifold.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np
from scipy.sparse.linalg import eigsh

from causal_intrinsic_probe_metric import (
    causal_relation_matrix,
    local_affine_jacobian,
    subspace_projector,
)
from causal_johnston_probe_metric import (
    causal_interval_points,
    choose_intrinsic_pivot,
    intrinsic_time_and_radius_from_relation,
    lorentzian_quadratic_probe,
    minkowski_interval_coefficient,
)
from causal_johnston_quadratic_probe import (
    selected_correlation,
    vector_relative_error,
)
from causal_operator_metric import (
    compact_coordinate_probes,
    finite_statistics,
    matrix_relative_error,
    smooth_compact_cutoff,
)


@dataclass(frozen=True)
class JohnstonFullEmbedding:
    coordinates: np.ndarray
    intrinsic_time: np.ndarray
    spatial_distances: np.ndarray
    spatial_eigenvalues: np.ndarray
    spatial_rank_gap: float
    dominant_spatial_gap_rank: int | None
    gram_reconstruction_relative_error: float


@dataclass(frozen=True)
class FullEmbeddingSample:
    events: int
    pivot_index: int
    local_affine_fit_relative_error: float
    local_jacobian_rank: int
    local_jacobian_condition: float | None
    time_relative_error: float
    spatial_subspace_relative_error: float
    quadratic_relative_error: float
    quadratic_inner_relative_error: float
    quadratic_correlation: float | None
    causal_sensitivity: float
    causal_specificity: float
    sampled_spatial_distance_relative_error: float
    spatial_eigenvalues: list[float]
    spatial_rank_gap: float
    dominant_spatial_gap_rank: int | None
    gram_reconstruction_relative_error: float
    pivot_intrinsic_time: float
    pivot_intrinsic_radius: float


def all_open_interval_counts(relation: np.ndarray) -> np.ndarray:
    """Count strict open intervals for every ordered pair.

    Float32 matrix multiplication uses optimized BLAS.  Every summand is zero
    or one, so the result is exact while the event count stays below the
    float32 consecutive-integer bound checked here.
    """

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    if len(relation) >= 2**24:
        raise ValueError("event count exceeds exact float32 integer range")
    numeric_relation = relation.astype(np.float32, copy=False)
    product = numeric_relation @ numeric_relation
    rounded = np.rint(product)
    if not np.array_equal(product, rounded):
        raise ArithmeticError("BLAS interval counts were not integral")
    return rounded.astype(np.int32)


def causal_pair_spatial_distances(
    relation: np.ndarray,
    open_counts: np.ndarray,
    intrinsic_time: np.ndarray,
    density: float,
    dimension: int,
) -> tuple[np.ndarray, np.ndarray]:
    """Paper equation (8) on all comparable pairs.

    Returns a symmetric distance matrix with infinity on spacelike pairs and a
    symmetric proper-time-squared matrix with zero on spacelike pairs.
    """

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    if open_counts.shape != relation.shape:
        raise ValueError("interval counts must match the relation")
    if intrinsic_time.shape != (len(relation),):
        raise ValueError("intrinsic time must match the relation")
    if density <= 0.0 or dimension < 2:
        raise ValueError("density and dimension must be positive")

    coefficient = minkowski_interval_coefficient(dimension)
    directed_tau_squared = np.zeros(relation.shape, dtype=float)
    directed_tau_squared[relation] = (
        (open_counts[relation].astype(float) + 2.0) / (density * coefficient)
    ) ** (2.0 / dimension)
    tau_squared = directed_tau_squared + directed_tau_squared.T
    comparable = relation | relation.T
    delta_time_squared = (intrinsic_time[:, None] - intrinsic_time[None, :]) ** 2
    spatial = np.full(relation.shape, np.inf, dtype=float)
    spatial[comparable] = np.sqrt(
        np.abs(delta_time_squared[comparable] - tau_squared[comparable])
    )
    np.fill_diagonal(spatial, 0.0)
    return spatial, tau_squared


def min_plus_spatial_distance_completion(
    relation: np.ndarray,
    causal_distances: np.ndarray,
) -> np.ndarray:
    """Complete spacelike distances by the paper's one-anchor minimum.

    For each pair x,y, candidate anchors z must be causally related to both.
    Direct causal-pair distances are restored after completion, as prescribed
    by equations (8) and (13), rather than replaced by a shorter two-leg path.
    """

    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be square")
    if causal_distances.shape != relation.shape:
        raise ValueError("causal distances must match the relation")
    if not np.allclose(causal_distances, causal_distances.T):
        raise ValueError("causal distances must be symmetric")

    size = len(relation)
    comparable = relation | relation.T | np.eye(size, dtype=bool)
    if np.any(~np.isfinite(causal_distances[comparable])):
        raise ValueError("every comparable pair needs a finite distance")
    completed = np.full((size, size), np.inf, dtype=float)
    for anchor in range(size):
        indices = np.flatnonzero(comparable[:, anchor])
        legs = causal_distances[indices, anchor]
        candidate = legs[:, None] + legs[None, :]
        block_index = np.ix_(indices, indices)
        current = completed[block_index]
        np.minimum(current, candidate, out=current)
        completed[block_index] = current

    completed[comparable] = causal_distances[comparable]
    np.fill_diagonal(completed, 0.0)
    if np.any(~np.isfinite(completed)):
        raise ValueError(
            "distance completion failed; the interval needs common anchors"
        )
    return 0.5 * (completed + completed.T)


def spatial_gram_from_distances(
    spatial_distances: np.ndarray,
    origin_index: int,
) -> np.ndarray:
    """Paper equation (17), polarized about the interval minimum."""

    if (
        spatial_distances.ndim != 2
        or spatial_distances.shape[0] != spatial_distances.shape[1]
    ):
        raise ValueError("spatial distances must be square")
    if not 0 <= origin_index < len(spatial_distances):
        raise IndexError("origin is outside the distance matrix")
    if np.any(~np.isfinite(spatial_distances)):
        raise ValueError("spatial distances must be finite")
    radial_squared = spatial_distances[origin_index] ** 2
    gram = 0.5 * (
        radial_squared[:, None] + radial_squared[None, :] - spatial_distances**2
    )
    return 0.5 * (gram + gram.T)


def relative_eigenvalue_gaps(
    eigenvalues: np.ndarray,
    maximum_rank: int = 8,
    floor: float = 1.0e-12,
) -> np.ndarray:
    """Relative descending gaps after candidate ranks 1 through maximum."""

    stop = min(maximum_rank, len(eigenvalues) - 1)
    if stop <= 0:
        return np.empty(0, dtype=float)
    left = eigenvalues[:stop]
    right = eigenvalues[1 : stop + 1]
    return (left - right) / np.maximum(np.maximum(np.abs(left), np.abs(right)), floor)


def truncated_mds_coordinates(
    gram: np.ndarray,
    spatial_rank: int,
    eigenvalue_count: int = 9,
) -> tuple[np.ndarray, np.ndarray, float, int | None, float]:
    """Paper equations (18)-(20) using the largest positive eigenvalues."""

    if gram.ndim != 2 or gram.shape[0] != gram.shape[1]:
        raise ValueError("Gram matrix must be square")
    if spatial_rank <= 0 or spatial_rank >= len(gram):
        raise ValueError("spatial rank must be positive and below event count")
    if eigenvalue_count <= spatial_rank:
        raise ValueError("retain at least one eigenvalue beyond spatial rank")

    size = len(gram)
    retained = min(eigenvalue_count, size)
    if retained == size or size <= 64:
        values, vectors = np.linalg.eigh(gram)
        order = np.argsort(values)[::-1][:retained]
        values = values[order]
        vectors = vectors[:, order]
    else:
        values, vectors = eigsh(
            gram,
            k=retained,
            which="LA",
            v0=np.ones(size, dtype=float),
            tol=1.0e-9,
        )
        order = np.argsort(values)[::-1]
        values = values[order]
        vectors = vectors[:, order]

    if np.count_nonzero(values > 0.0) < spatial_rank:
        raise ValueError("Gram matrix has too few positive spatial modes")
    coordinates = vectors[:, :spatial_rank] * np.sqrt(values[:spatial_rank])[None, :]
    gaps = relative_eigenvalue_gaps(values)
    dominant_gap_rank = None if len(gaps) == 0 else int(np.argmax(gaps) + 1)
    rank_gap = float(gaps[spatial_rank - 1]) if len(gaps) >= spatial_rank else 1.0
    reconstructed = coordinates @ coordinates.T
    reconstruction_error = matrix_relative_error(reconstructed, gram)
    return coordinates, values, rank_gap, dominant_gap_rank, reconstruction_error


def johnston_full_embedding_from_relation(
    relation: np.ndarray,
    density: float,
    dimension: int,
    bottom_index: int,
    top_index: int,
    duration: float,
    spatial_rank: int = 3,
    eigenvalue_count: int = 9,
) -> JohnstonFullEmbedding:
    """Construct the paper's simultaneous full-interval embedding."""

    intrinsic_time, _ = intrinsic_time_and_radius_from_relation(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        duration,
    )
    counts = all_open_interval_counts(relation)
    causal_distances, _ = causal_pair_spatial_distances(
        relation, counts, intrinsic_time, density, dimension
    )
    completed = min_plus_spatial_distance_completion(relation, causal_distances)
    gram = spatial_gram_from_distances(completed, bottom_index)
    spatial, eigenvalues, rank_gap, dominant_rank, residual = truncated_mds_coordinates(
        gram, spatial_rank, eigenvalue_count=eigenvalue_count
    )
    spatial = spatial - spatial[bottom_index]
    coordinates = np.column_stack((intrinsic_time, spatial))
    return JohnstonFullEmbedding(
        coordinates=coordinates,
        intrinsic_time=intrinsic_time,
        spatial_distances=completed,
        spatial_eigenvalues=eigenvalues,
        spatial_rank_gap=rank_gap,
        dominant_spatial_gap_rank=dominant_rank,
        gram_reconstruction_relative_error=residual,
    )


def compact_full_embedding_probes(
    embedding: JohnstonFullEmbedding,
    pivot_index: int,
    support_radius: float,
) -> np.ndarray:
    """Center the full chart at a pivot and apply the common smooth cutoff."""

    centered = embedding.coordinates - embedding.coordinates[pivot_index]
    radius = np.linalg.norm(centered, axis=1)
    cutoff = smooth_compact_cutoff(radius, support_radius)
    return centered * cutoff[:, None]


def induced_causal_relation(coordinates: np.ndarray) -> np.ndarray:
    """Strict (+---) causal relation induced by recovered coordinates."""

    delta = coordinates[None, :, :] - coordinates[:, None, :]
    future = delta[:, :, 0] > 0.0
    interval = delta[:, :, 0] ** 2 - np.sum(delta[:, :, 1:] ** 2, axis=2)
    return future & (interval >= 0.0)


def binary_sensitivity_specificity(
    expected: np.ndarray,
    actual: np.ndarray,
) -> tuple[float, float]:
    """Sensitivity and specificity of a recovered strict relation."""

    if expected.shape != actual.shape:
        raise ValueError("relations must have equal shapes")
    off_diagonal = ~np.eye(len(expected), dtype=bool)
    positives = expected & off_diagonal
    negatives = ~expected & off_diagonal
    sensitivity = np.count_nonzero(actual & positives) / np.count_nonzero(positives)
    specificity = np.count_nonzero(~actual & negatives) / np.count_nonzero(negatives)
    return float(sensitivity), float(specificity)


def sampled_pair_relative_error(
    actual: np.ndarray,
    expected: np.ndarray,
    rng: np.random.Generator,
    sample_count: int,
) -> float:
    """Relative Euclidean error on a reproducible sample of unordered pairs."""

    if actual.shape != expected.shape or actual.ndim != 2:
        raise ValueError("distance matrices must have equal square shapes")
    left, right = np.triu_indices(len(actual), k=1)
    if sample_count < len(left):
        chosen = rng.choice(len(left), size=sample_count, replace=False)
        left = left[chosen]
        right = right[chosen]
    expected_values = expected[left, right]
    denominator = float(np.linalg.norm(expected_values))
    if denominator <= 1.0e-14:
        return float("inf")
    return float(np.linalg.norm(actual[left, right] - expected_values) / denominator)


def reconstruct_full_embedding_sample(
    rng: np.random.Generator,
    events: int,
    duration: float,
    dimension: int,
    block_size: int,
    support_radius: float,
    affine_radius: float,
    distance_pair_samples: int,
) -> FullEmbeddingSample:
    """Construct and externally score one simultaneous full embedding."""

    points, bottom_index, top_index = causal_interval_points(rng, events, duration)
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
    embedding = johnston_full_embedding_from_relation(
        relation,
        density,
        dimension,
        bottom_index,
        top_index,
        duration,
        spatial_rank=dimension - 1,
    )
    probes = compact_full_embedding_probes(embedding, pivot_index, support_radius)
    recovered_centered = embedding.coordinates - embedding.coordinates[pivot_index]
    recovered_radius = np.linalg.norm(recovered_centered, axis=1)
    inner_mask = recovered_radius <= affine_radius
    if np.count_nonzero(inner_mask) < max(dimension + 1, 6):
        inner_mask = recovered_radius <= support_radius / 2.0
    jacobian, fit_error, rank, condition = local_affine_jacobian(
        points, pivot_index, probes, inner_mask
    )

    oracle_probes = compact_coordinate_probes(points, pivot_index, support_radius)
    recovered_quadratic = lorentzian_quadratic_probe(probes)
    oracle_quadratic = lorentzian_quadratic_probe(oracle_probes)
    oracle_centered = points - points[pivot_index]
    oracle_radius = np.linalg.norm(oracle_centered, axis=1)
    support_mask = oracle_radius < support_radius
    inner_quadratic_mask = oracle_radius <= support_radius / 2.0

    recovered_relation = induced_causal_relation(embedding.coordinates)
    sensitivity, specificity = binary_sensitivity_specificity(
        relation, recovered_relation
    )
    oracle_spatial_delta = points[:, None, 1:] - points[None, :, 1:]
    oracle_spatial_distances = np.linalg.norm(oracle_spatial_delta, axis=2)
    spatial_projector_error = matrix_relative_error(
        subspace_projector(recovered_centered[:, 1:]),
        subspace_projector(oracle_centered[:, 1:]),
    )
    return FullEmbeddingSample(
        events=events,
        pivot_index=pivot_index,
        local_affine_fit_relative_error=fit_error,
        local_jacobian_rank=rank,
        local_jacobian_condition=condition,
        time_relative_error=matrix_relative_error(
            recovered_centered[:, [0]], oracle_centered[:, [0]]
        ),
        spatial_subspace_relative_error=spatial_projector_error,
        quadratic_relative_error=vector_relative_error(
            recovered_quadratic, oracle_quadratic, support_mask
        ),
        quadratic_inner_relative_error=vector_relative_error(
            recovered_quadratic, oracle_quadratic, inner_quadratic_mask
        ),
        quadratic_correlation=selected_correlation(
            recovered_quadratic, oracle_quadratic, support_mask
        ),
        causal_sensitivity=sensitivity,
        causal_specificity=specificity,
        sampled_spatial_distance_relative_error=sampled_pair_relative_error(
            embedding.spatial_distances,
            oracle_spatial_distances,
            rng,
            distance_pair_samples,
        ),
        spatial_eigenvalues=embedding.spatial_eigenvalues.tolist(),
        spatial_rank_gap=embedding.spatial_rank_gap,
        dominant_spatial_gap_rank=embedding.dominant_spatial_gap_rank,
        gram_reconstruction_relative_error=(
            embedding.gram_reconstruction_relative_error
        ),
        pivot_intrinsic_time=float(intrinsic_time[pivot_index]),
        pivot_intrinsic_radius=float(intrinsic_radius[pivot_index]),
    )


def summarize_samples(samples: list[FullEmbeddingSample]) -> dict[str, object]:
    """Summarize one event-count ensemble."""

    return {
        "events": samples[0].events,
        "samples": len(samples),
        "local_affine_fit_relative_error": finite_statistics(
            [sample.local_affine_fit_relative_error for sample in samples]
        ),
        "local_jacobian_condition": finite_statistics(
            [sample.local_jacobian_condition for sample in samples]
        ),
        "time_relative_error": finite_statistics(
            [sample.time_relative_error for sample in samples]
        ),
        "spatial_subspace_relative_error": finite_statistics(
            [sample.spatial_subspace_relative_error for sample in samples]
        ),
        "quadratic_relative_error": finite_statistics(
            [sample.quadratic_relative_error for sample in samples]
        ),
        "quadratic_inner_relative_error": finite_statistics(
            [sample.quadratic_inner_relative_error for sample in samples]
        ),
        "quadratic_correlation": finite_statistics(
            [sample.quadratic_correlation for sample in samples]
        ),
        "causal_sensitivity": finite_statistics(
            [sample.causal_sensitivity for sample in samples]
        ),
        "causal_specificity": finite_statistics(
            [sample.causal_specificity for sample in samples]
        ),
        "sampled_spatial_distance_relative_error": finite_statistics(
            [sample.sampled_spatial_distance_relative_error for sample in samples]
        ),
        "spatial_rank_gap": finite_statistics(
            [sample.spatial_rank_gap for sample in samples]
        ),
        "dominant_spatial_gap_rank_counts": {
            str(rank): sum(
                sample.dominant_spatial_gap_rank == rank for sample in samples
            )
            for rank in sorted(
                {
                    sample.dominant_spatial_gap_rank
                    for sample in samples
                    if sample.dominant_spatial_gap_rank is not None
                }
            )
        },
        "gram_reconstruction_relative_error": finite_statistics(
            [sample.gram_reconstruction_relative_error for sample in samples]
        ),
    }


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    """Benchmark construction on known four-dimensional sprinklings."""

    if args.dimension != 4:
        raise ValueError("this benchmark is frozen in four dimensions")
    if args.realizations <= 0 or any(events < 4 for events in args.events):
        raise ValueError("realizations and event counts must be positive")
    if args.duration <= 0.0 or args.block_size <= 0:
        raise ValueError("duration and block size must be positive")
    if args.support_radius <= 0.0 or args.affine_radius <= 0.0:
        raise ValueError("chart radii must be positive")
    if args.distance_pair_samples <= 0:
        raise ValueError("distance sample count must be positive")

    seed_sequence = np.random.SeedSequence(args.seed)
    children = seed_sequence.spawn(len(args.events) * args.realizations)
    samples: list[FullEmbeddingSample] = []
    cursor = 0
    for events in args.events:
        for _ in range(args.realizations):
            samples.append(
                reconstruct_full_embedding_sample(
                    np.random.default_rng(children[cursor]),
                    events,
                    args.duration,
                    args.dimension,
                    args.block_size,
                    args.support_radius,
                    args.affine_radius,
                    args.distance_pair_samples,
                )
            )
            cursor += 1
    summaries = {
        str(events): summarize_samples(
            [sample for sample in samples if sample.events == events]
        )
        for events in args.events
    }
    coefficient = minkowski_interval_coefficient(args.dimension)
    result: dict[str, object] = {
        "status": "full-interval embedding validation; no operator score",
        "construction_uses_embedding_coordinates": False,
        "pivot_selection_uses_embedding_coordinates": False,
        "scoring_uses_embedding_coordinates": True,
        "operator_scores_opened": False,
        "dimension_is_supplied": True,
        "density_is_supplied": True,
        "interval_endpoints_are_supplied": True,
        "spatial_rank_is_supplied": True,
        "settings": {
            "events_including_endpoints": args.events,
            "realizations_per_event_count": args.realizations,
            "duration": args.duration,
            "dimension": args.dimension,
            "density_by_event_count": {
                str(events): events / (coefficient * args.duration**args.dimension)
                for events in args.events
            },
            "support_radius": args.support_radius,
            "affine_radius": args.affine_radius,
            "distance_pair_samples": args.distance_pair_samples,
            "seed": args.seed,
        },
        "summaries": summaries,
    }
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--events", type=int, nargs="+", default=[500, 1000])
    parser.add_argument("--realizations", type=int, default=10)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--dimension", type=int, default=4)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--support-radius", type=float, default=0.65)
    parser.add_argument("--affine-radius", type=float, default=0.18)
    parser.add_argument("--distance-pair-samples", type=int, default=20000)
    parser.add_argument("--seed", type=int, default=20260729)
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
