"""Stage-A metric reconstruction from a four-dimensional causal order.

This external numerical experiment implements the smeared four-dimensional
Benincasa-Dowker causal-set d'Alembertian at the top event of a Minkowski causal
diamond.  It then evaluates the corrected operator pairing

    Gamma_B(f, h) = (B(fh) - f Bh - h Bf + fh B1) / 2

on the four embedded coordinate probes.  The target is the inverse Minkowski
metric with signature (+---).

The experiment is a calibration oracle, not a proof and not an intrinsic
coordinate reconstruction: the sprinkling coordinates are used only as known
probe fields against which the order/count operator can be tested.  The causal
operator itself uses only the order relation, interval cardinalities, the
sprinkling density, and the chosen mesoscopic nonlocality scale.

Operator convention and provenance:

* D. M. T. Benincasa and F. Dowker, arXiv:1001.2725, equations (2), (8),
  and (9).
* A. Belenchia, D. M. T. Benincasa, and F. Dowker, arXiv:1510.04656,
  explicitly adopt the Hawking-Ellis (-+++) convention.  The source operator
  row is therefore multiplied by -1 before reconstruction in the project's
  (+---) convention.
* For epsilon = (ell / L)^4, the smeared operator has prefactor
  4 / (sqrt(6) L^2) and past weight epsilon * f(n, epsilon).

The decisive diagnostics are metric error, one-positive/three-negative
signature, affine probe covariance, and reconstructed volume-density error.
Failure to improve over a mesoscopic scale/density window is evidence against
this reconstruction architecture.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Callable

import numpy as np


MINKOWSKI_INVERSE = np.diag([1.0, -1.0, -1.0, -1.0])
LOCAL_LAYER_COEFFICIENTS = np.array([1.0, -9.0, 16.0, -8.0])
SOURCE_TO_PROJECT_SIGN = -1.0


@dataclass(frozen=True)
class ReconstructionSample:
    metric: list[list[float]]
    eigenvalues: list[float]
    signature: tuple[int, int, int]
    metric_relative_error: float
    target_probe_relative_error: float
    affine_covariance_relative_error: float
    volume_density: float | None
    volume_relative_error: float | None
    operator_on_one: float


def diamond_volume_4d(duration: float) -> float:
    """Volume of a 4D Minkowski Alexandrov interval of proper time duration."""

    if duration <= 0.0:
        raise ValueError("duration must be positive")
    return float(np.pi * duration**4 / 24.0)


def sprinkle_minkowski_diamond(
    rng: np.random.Generator,
    events: int,
    duration: float,
) -> tuple[np.ndarray, int]:
    """Conditionally sprinkle `events` points and append the top endpoint.

    Coordinates are `(t, x, y, z)` with bottom `(0,0,0,0)` and top
    `(duration,0,0,0)`.  Rejection from the bounding box gives the uniform
    spacetime-volume distribution inside the Alexandrov interval.
    """

    if events <= 0:
        raise ValueError("events must be positive")
    if duration <= 0.0:
        raise ValueError("duration must be positive")

    accepted: list[np.ndarray] = []
    accepted_count = 0
    half = duration / 2.0
    while accepted_count < events:
        remaining = events - accepted_count
        batch_size = max(256, 10 * remaining)
        time = rng.uniform(0.0, duration, size=batch_size)
        space = rng.uniform(-half, half, size=(batch_size, 3))
        radius_bound = np.minimum(time, duration - time)
        mask = np.sum(space**2, axis=1) < radius_bound**2
        batch = np.column_stack((time[mask], space[mask]))
        if len(batch):
            take = batch[:remaining]
            accepted.append(take)
            accepted_count += len(take)

    interior = np.concatenate(accepted, axis=0)
    top = np.array([[duration, 0.0, 0.0, 0.0]])
    points = np.concatenate((interior, top), axis=0)
    return points, len(points) - 1


def strictly_precedes(left: np.ndarray, right: np.ndarray) -> np.ndarray:
    """Broadcasted strict Minkowski causal relation with signature (+---)."""

    delta = right - left
    return (delta[..., 0] > 0.0) & (
        delta[..., 0] ** 2 > np.sum(delta[..., 1:] ** 2, axis=-1)
    )


def interval_counts_to_target(
    points: np.ndarray,
    target_index: int,
    block_size: int = 256,
) -> tuple[np.ndarray, np.ndarray]:
    """Return strict-past mask and open-interval counts to one target.

    The count for `y < target` is the number of `z` with
    `y < z < target`.  Evaluation is blockwise so a several-thousand-point
    calibration does not allocate an `N x N x 4` tensor.
    """

    if points.ndim != 2 or points.shape[1] != 4:
        raise ValueError("points must have shape (N, 4)")
    if not 0 <= target_index < len(points):
        raise IndexError("target index is outside the point array")
    if block_size <= 0:
        raise ValueError("block_size must be positive")

    target = points[target_index]
    past = strictly_precedes(points, target)
    counts = np.zeros(len(points), dtype=np.int64)
    target_past_column = past

    for start in range(0, len(points), block_size):
        stop = min(start + block_size, len(points))
        left = points[start:stop, None, :]
        right = points[None, :, :]
        relation = strictly_precedes(left, right)
        counts[start:stop] = np.count_nonzero(
            relation & target_past_column[None, :], axis=1
        )

    counts[~past] = 0
    return past, counts


def local_bd_row(
    past: np.ndarray,
    interval_counts: np.ndarray,
    target_index: int,
    ell: float,
) -> np.ndarray:
    """Most-local 4D Benincasa-Dowker operator row, paper equation (2)."""

    if ell <= 0.0:
        raise ValueError("ell must be positive")
    prefactor = 4.0 / (np.sqrt(6.0) * ell**2)
    row = np.zeros(len(past), dtype=float)
    for layer, coefficient in enumerate(LOCAL_LAYER_COEFFICIENTS):
        row[past & (interval_counts == layer)] = prefactor * coefficient
    row[target_index] = -prefactor
    return row


def smeared_kernel(interval_counts: np.ndarray, epsilon: float) -> np.ndarray:
    """Broad-layer kernel `f(n, epsilon)` from paper equation (9)."""

    if not 0.0 < epsilon < 1.0:
        raise ValueError("smeared epsilon must lie strictly between zero and one")
    n = interval_counts.astype(float)
    one_minus = 1.0 - epsilon
    polynomial = (
        1.0
        - 9.0 * epsilon * n / one_minus
        + 8.0 * epsilon**2 * n * (n - 1.0) / one_minus**2
        - (4.0 / 3.0)
        * epsilon**3
        * n
        * (n - 1.0)
        * (n - 2.0)
        / one_minus**3
    )
    return one_minus**n * polynomial


def smeared_bd_row(
    past: np.ndarray,
    interval_counts: np.ndarray,
    target_index: int,
    ell: float,
    nonlocality_scale: float,
) -> np.ndarray:
    """Smeared 4D causal operator row, paper equations (8) and (9)."""

    if ell <= 0.0 or nonlocality_scale <= 0.0:
        raise ValueError("ell and nonlocality scale must be positive")
    if nonlocality_scale < ell:
        raise ValueError("nonlocality scale must be at least ell")
    epsilon = (ell / nonlocality_scale) ** 4
    if np.isclose(epsilon, 1.0):
        return local_bd_row(past, interval_counts, target_index, ell)

    prefactor = 4.0 / (np.sqrt(6.0) * nonlocality_scale**2)
    row = np.zeros(len(past), dtype=float)
    row[past] = (
        prefactor
        * epsilon
        * smeared_kernel(interval_counts[past], epsilon)
    )
    row[target_index] = -prefactor
    return row


def project_convention_row(source_row: np.ndarray) -> np.ndarray:
    """Convert the source (-+++) d'Alembertian row to project (+---)."""

    return SOURCE_TO_PROJECT_SIGN * source_row


def smooth_compact_cutoff(
    radial_distance: np.ndarray, support_radius: float
) -> np.ndarray:
    """Smooth radial cutoff equal to one on the inner half-radius."""

    if support_radius <= 0.0:
        raise ValueError("support radius must be positive")
    if radial_distance.ndim != 1 or np.any(radial_distance < 0.0):
        raise ValueError("radial distances must be a nonnegative vector")
    inner_radius = support_radius / 2.0
    cutoff = np.ones(len(radial_distance), dtype=float)
    cutoff[radial_distance >= support_radius] = 0.0
    transition = (radial_distance > inner_radius) & (
        radial_distance < support_radius
    )
    scaled = (radial_distance[transition] - inner_radius) / (
        support_radius - inner_radius
    )
    rising = np.exp(-1.0 / scaled)
    falling = np.exp(-1.0 / (1.0 - scaled))
    cutoff[transition] = falling / (rising + falling)
    return cutoff


def compact_coordinate_probes(
    points: np.ndarray,
    target_index: int,
    support_radius: float,
) -> np.ndarray:
    """Coordinate probes times a smooth compact cutoff around the target.

    The cutoff is one through half the requested Euclidean support radius and
    transitions smoothly to zero at the support boundary.  Coordinates enter
    only as calibration probes; the causal operator remains order/count based.
    """

    centered = points - points[target_index]
    radial_distance = np.linalg.norm(centered, axis=1)
    cutoff = smooth_compact_cutoff(radial_distance, support_radius)
    return centered * cutoff[:, None]


def corrected_gamma(row: np.ndarray, probes: np.ndarray, target_index: int) -> np.ndarray:
    """Evaluate the corrected operator pairing on a list of probe fields."""

    if row.ndim != 1:
        raise ValueError("operator row must be one-dimensional")
    if probes.ndim != 2 or probes.shape[0] != len(row):
        raise ValueError("probes must have shape (N, number_of_probes)")
    if not 0 <= target_index < len(row):
        raise IndexError("target index is outside the operator row")

    probe_count = probes.shape[1]
    values = probes[target_index]
    operator_values = row @ probes
    operator_one = float(np.sum(row))
    gamma = np.empty((probe_count, probe_count), dtype=float)
    for a in range(probe_count):
        for b in range(probe_count):
            gamma[a, b] = 0.5 * (
                row @ (probes[:, a] * probes[:, b])
                - values[a] * operator_values[b]
                - values[b] * operator_values[a]
                + values[a] * values[b] * operator_one
            )
    return 0.5 * (gamma + gamma.T)


def matrix_relative_error(actual: np.ndarray, expected: np.ndarray) -> float:
    denominator = np.linalg.norm(expected, ord="fro")
    if denominator == 0.0:
        return float(np.linalg.norm(actual, ord="fro"))
    return float(np.linalg.norm(actual - expected, ord="fro") / denominator)


def signature(matrix: np.ndarray, relative_tolerance: float = 1.0e-8) -> tuple[int, int, int]:
    eigenvalues = np.linalg.eigvalsh(0.5 * (matrix + matrix.T))
    scale = max(1.0, float(np.max(np.abs(eigenvalues))))
    threshold = relative_tolerance * scale
    positive = int(np.count_nonzero(eigenvalues > threshold))
    negative = int(np.count_nonzero(eigenvalues < -threshold))
    zero = len(eigenvalues) - positive - negative
    return positive, negative, zero


def volume_density_from_inverse_metric(metric: np.ndarray) -> float | None:
    determinant = float(np.linalg.det(metric))
    if not np.isfinite(determinant) or abs(determinant) < 1.0e-14:
        return None
    return float(1.0 / np.sqrt(abs(determinant)))


def fixed_probe_transform() -> tuple[np.ndarray, np.ndarray]:
    """A non-Lorentz, invertible affine probe change for covariance testing."""

    linear = np.array(
        [
            [1.10, 0.18, -0.07, 0.03],
            [0.11, 0.92, 0.05, -0.04],
            [-0.06, 0.09, 1.07, 0.08],
            [0.04, -0.03, 0.12, 0.96],
        ]
    )
    offset = np.array([0.7, -0.4, 0.2, 0.9])
    return linear, offset


def reconstruct_one(
    rng: np.random.Generator,
    events: int,
    duration: float,
    nonlocality_scale: float,
    operator: str,
    block_size: int,
    probe_support_radius: float,
) -> ReconstructionSample:
    points, target_index = sprinkle_minkowski_diamond(rng, events, duration)
    past, counts = interval_counts_to_target(points, target_index, block_size)
    ell = (diamond_volume_4d(duration) / events) ** 0.25

    row_builder: Callable[..., np.ndarray]
    if operator == "local":
        row_builder = local_bd_row
        source_row = row_builder(past, counts, target_index, ell)
    elif operator == "smeared":
        row_builder = smeared_bd_row
        source_row = row_builder(
            past, counts, target_index, ell, nonlocality_scale
        )
    else:
        raise ValueError(f"unknown operator: {operator}")
    row = project_convention_row(source_row)

    coordinate_probes = compact_coordinate_probes(
        points, target_index, probe_support_radius
    )
    metric = corrected_gamma(row, coordinate_probes, target_index)

    linear, offset = fixed_probe_transform()
    transformed = coordinate_probes @ linear.T + offset
    transformed_metric = corrected_gamma(row, transformed, target_index)
    finite_covariance_target = linear @ metric @ linear.T
    continuum_covariance_target = linear @ MINKOWSKI_INVERSE @ linear.T

    volume_density = volume_density_from_inverse_metric(metric)
    volume_error = None if volume_density is None else abs(volume_density - 1.0)
    eigenvalues = np.linalg.eigvalsh(metric)
    return ReconstructionSample(
        metric=metric.tolist(),
        eigenvalues=eigenvalues.tolist(),
        signature=signature(metric),
        metric_relative_error=matrix_relative_error(metric, MINKOWSKI_INVERSE),
        target_probe_relative_error=matrix_relative_error(
            transformed_metric, continuum_covariance_target
        ),
        affine_covariance_relative_error=matrix_relative_error(
            transformed_metric, finite_covariance_target
        ),
        volume_density=volume_density,
        volume_relative_error=volume_error,
        operator_on_one=float(np.sum(row)),
    )


def finite_statistics(values: list[float | None]) -> dict[str, float | int | None]:
    finite = np.array(
        [value for value in values if value is not None and np.isfinite(value)],
        dtype=float,
    )
    if len(finite) == 0:
        return {"count": 0, "mean": None, "std": None, "median": None}
    return {
        "count": int(len(finite)),
        "mean": float(np.mean(finite)),
        "std": float(np.std(finite)),
        "median": float(np.median(finite)),
    }


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    if args.realizations <= 0:
        raise ValueError("realizations must be positive")
    ell = (diamond_volume_4d(args.duration) / args.events) ** 0.25
    if args.operator == "smeared" and args.nonlocality_scale < ell:
        raise ValueError(
            f"nonlocality scale {args.nonlocality_scale:g} is below ell {ell:g}"
        )

    seed_sequence = np.random.SeedSequence(args.seed)
    samples = [
        reconstruct_one(
            np.random.default_rng(child_seed),
            args.events,
            args.duration,
            args.nonlocality_scale,
            args.operator,
            args.block_size,
            args.probe_support_radius,
        )
        for child_seed in seed_sequence.spawn(args.realizations)
    ]
    metrics = np.array([sample.metric for sample in samples])
    mean_metric = np.mean(metrics, axis=0)
    std_metric = np.std(metrics, axis=0)
    signature_successes = sum(sample.signature == (1, 3, 0) for sample in samples)
    result: dict[str, object] = {
        "status": "external numerical calibration; not a proof",
        "settings": {
            "events": args.events,
            "realizations": args.realizations,
            "duration": args.duration,
            "diamond_volume": diamond_volume_4d(args.duration),
            "ell": ell,
            "nonlocality_scale": args.nonlocality_scale,
            "epsilon": (ell / args.nonlocality_scale) ** 4,
            "operator": args.operator,
            "probe_support_radius": args.probe_support_radius,
            "source_signature": "(-+++)",
            "project_signature": "(+---)",
            "source_to_project_sign": SOURCE_TO_PROJECT_SIGN,
            "seed": args.seed,
        },
        "summary": {
            "mean_metric": mean_metric.tolist(),
            "std_metric": std_metric.tolist(),
            "standard_error_metric": (std_metric / np.sqrt(len(samples))).tolist(),
            "ensemble_mean_signature": signature(mean_metric),
            "ensemble_mean_metric_relative_error": matrix_relative_error(
                mean_metric, MINKOWSKI_INVERSE
            ),
            "signature_successes": signature_successes,
            "signature_success_rate": signature_successes / len(samples),
            "metric_relative_error": finite_statistics(
                [sample.metric_relative_error for sample in samples]
            ),
            "target_probe_relative_error": finite_statistics(
                [sample.target_probe_relative_error for sample in samples]
            ),
            "affine_covariance_relative_error": finite_statistics(
                [sample.affine_covariance_relative_error for sample in samples]
            ),
            "volume_relative_error": finite_statistics(
                [sample.volume_relative_error for sample in samples]
            ),
            "operator_on_one": finite_statistics(
                [sample.operator_on_one for sample in samples]
            ),
        },
    }
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--events", type=int, default=2000)
    parser.add_argument("--realizations", type=int, default=8)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--nonlocality-scale", type=float, default=0.2)
    parser.add_argument("--operator", choices=("local", "smeared"), default="smeared")
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--probe-support-radius", type=float, default=0.7)
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
