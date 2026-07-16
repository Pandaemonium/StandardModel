"""Stage A41 continuum moments of the smeared causal-set operator.

The script evaluates the exact Poisson mean of the four-dimensional smeared
Benincasa-Dowker kernel on compactly supported polynomial germs in a flat
marked Alexandrov interval.  It contains no sprinkling noise and performs no
parameter selection.  The frozen protocol is recorded in
``AgentTasks/null-edge-causal-continuum-kernel-moments-stage-a41-plan-2026-07-15.md``.

Coordinates use project signature (+---).  The source (-+++) kernel is
multiplied by -1, so the continuum target is
``Box = partial_t^2 - sum_i partial_i^2``.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from math import comb, factorial
from pathlib import Path

import numpy as np
from numpy.polynomial.legendre import leggauss

from causal_operator_metric import (
    project_convention_row,
    smeared_bd_row,
    smeared_kernel,
)


C4 = np.pi / 24.0
PROJECT_TARGET = np.diag([1.0, -1.0, -1.0, -1.0])
FIELD_NAMES = (
    "constant",
    "temporal_affine",
    "temporal_quadratic",
    "spatial_quadratic",
    "temporal_cubic",
    "temporal_spatial_cubic",
)


@dataclass(frozen=True)
class CutoffProfile:
    name: str
    depth_zero: float
    depth_one: float


@dataclass(frozen=True)
class MomentResult:
    cutoff: str
    nonlocality_ratio: float
    quadrature_order: int
    operator_values: dict[str, float]
    metric_diagonal: list[float]
    metric_relative_error: float
    signature: tuple[int, int, int]
    response_ratio_error: float
    principal_symbol_mismatch: float
    maximum_zero_target_residual: float


def broad_layer_polynomial(z: np.ndarray | float) -> np.ndarray | float:
    """The four-dimensional broad-layer polynomial ``P(z)``."""

    return 1.0 - 9.0 * z + 8.0 * z**2 - (4.0 / 3.0) * z**3


def poisson_averaged_smeared_kernel(mean: float, epsilon: float) -> float:
    """Closed Poisson mean of the broad-layer factor ``f(N, epsilon)``."""

    if mean < 0.0:
        raise ValueError("Poisson mean must be nonnegative")
    if not 0.0 < epsilon < 1.0:
        raise ValueError("epsilon must lie strictly between zero and one")
    z = epsilon * mean
    return float(np.exp(-z) * broad_layer_polynomial(z))


def direct_poisson_smeared_kernel_mean(
    mean: float,
    epsilon: float,
    maximum_count: int,
) -> float:
    """Truncated direct Poisson sum used to audit the closed transform."""

    if mean < 0.0 or maximum_count < 0:
        raise ValueError("require a nonnegative mean and count cutoff")
    if not 0.0 < epsilon < 1.0:
        raise ValueError("epsilon must lie strictly between zero and one")
    probability = float(np.exp(-mean))
    total = 0.0
    one_minus = 1.0 - epsilon
    for count in range(maximum_count + 1):
        n = float(count)
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
        total += probability * one_minus**count * polynomial
        if count < maximum_count:
            probability *= mean / (count + 1.0)
    return float(total)


def poisson_averaged_smeared_kernel_second_moment(
    mean: float,
    epsilon: float,
) -> float:
    """Closed Poisson second moment of ``f(N, epsilon)``.

    The broad-layer polynomial is expressed in the falling-factorial basis.
    Products use
    ``(N)_i (N)_j = sum_k binom(i,k) binom(j,k) k! (N)_(i+j-k)``,
    after which the Poisson generating function is exact term by term.
    """

    if mean < 0.0:
        raise ValueError("Poisson mean must be nonnegative")
    if not 0.0 < epsilon < 1.0:
        raise ValueError("epsilon must lie strictly between zero and one")
    one_minus = 1.0 - epsilon
    coefficients = (
        1.0,
        -9.0 * epsilon / one_minus,
        8.0 * epsilon**2 / one_minus**2,
        -(4.0 / 3.0) * epsilon**3 / one_minus**3,
    )
    transformed_mean = mean * one_minus**2
    polynomial = 0.0
    for left_order, left in enumerate(coefficients):
        for right_order, right in enumerate(coefficients):
            for overlap in range(min(left_order, right_order) + 1):
                product_coefficient = (
                    comb(left_order, overlap)
                    * comb(right_order, overlap)
                    * factorial(overlap)
                )
                falling_order = left_order + right_order - overlap
                polynomial += (
                    left
                    * right
                    * product_coefficient
                    * transformed_mean**falling_order
                )
    exponential = np.exp(mean * (one_minus**2 - 1.0))
    return float(exponential * polynomial)


def direct_poisson_smeared_kernel_second_moment(
    mean: float,
    epsilon: float,
    maximum_count: int,
) -> float:
    """Truncated direct Poisson sum auditing the closed second moment."""

    if mean < 0.0 or maximum_count < 0:
        raise ValueError("require a nonnegative mean and count cutoff")
    if not 0.0 < epsilon < 1.0:
        raise ValueError("epsilon must lie strictly between zero and one")
    probability = float(np.exp(-mean))
    total = 0.0
    for count in range(maximum_count + 1):
        value = float(
            smeared_kernel(np.array([count], dtype=np.int64), epsilon)[0]
        )
        total += probability * value**2
        if count < maximum_count:
            probability *= mean / (count + 1.0)
    return float(total)


def poisson_smeared_kernel_variance(mean: float, epsilon: float) -> float:
    """Exact one-interval Poisson variance of the broad-layer factor."""

    first = poisson_averaged_smeared_kernel(mean, epsilon)
    second = poisson_averaged_smeared_kernel_second_moment(mean, epsilon)
    variance = second - first**2
    tolerance = 1.0e-12 * max(1.0, abs(second), first**2)
    if variance < -tolerance:
        raise ArithmeticError("closed kernel variance is numerically negative")
    return float(max(0.0, variance))


def _broad_layer_falling_coefficients(epsilon: float) -> tuple[float, ...]:
    if not 0.0 < epsilon < 1.0:
        raise ValueError("epsilon must lie strictly between zero and one")
    one_minus = 1.0 - epsilon
    return (
        1.0,
        -9.0 * epsilon / one_minus,
        8.0 * epsilon**2 / one_minus**2,
        -(4.0 / 3.0) * epsilon**3 / one_minus**3,
    )


def _binomial_weighted_falling_moment(
    trials: int,
    probability: float,
    weight: float,
    order: int,
) -> float:
    """Return ``E[(K)_order weight^K]`` for binomial ``K``."""

    if trials < 0 or order < 0:
        raise ValueError("trials and falling-factorial order must be nonnegative")
    if not 0.0 <= probability <= 1.0:
        raise ValueError("binomial probability must lie in [0,1]")
    if order > trials:
        return 0.0
    falling = 1.0
    for offset in range(order):
        falling *= trials - offset
    base = 1.0 - probability + probability * weight
    return float(
        falling
        * (probability * weight) ** order
        * base ** (trials - order)
    )


def binomial_averaged_smeared_kernel(
    trials: int,
    probability: float,
    epsilon: float,
) -> float:
    """Exact finite-binomial mean of the broad-layer factor."""

    coefficients = _broad_layer_falling_coefficients(epsilon)
    one_minus = 1.0 - epsilon
    return float(
        sum(
            coefficient
            * _binomial_weighted_falling_moment(
                trials, probability, one_minus, order
            )
            for order, coefficient in enumerate(coefficients)
        )
    )


def binomial_averaged_smeared_kernel_second_moment(
    trials: int,
    probability: float,
    epsilon: float,
) -> float:
    """Exact finite-binomial second moment of the broad-layer factor."""

    coefficients = _broad_layer_falling_coefficients(epsilon)
    one_minus_squared = (1.0 - epsilon) ** 2
    total = 0.0
    for left_order, left in enumerate(coefficients):
        for right_order, right in enumerate(coefficients):
            for overlap in range(min(left_order, right_order) + 1):
                product_coefficient = (
                    comb(left_order, overlap)
                    * comb(right_order, overlap)
                    * factorial(overlap)
                )
                falling_order = left_order + right_order - overlap
                total += (
                    left
                    * right
                    * product_coefficient
                    * _binomial_weighted_falling_moment(
                        trials,
                        probability,
                        one_minus_squared,
                        falling_order,
                    )
                )
    return float(total)


def direct_binomial_smeared_kernel_moments(
    trials: int,
    probability: float,
    epsilon: float,
) -> tuple[float, float]:
    """Direct finite sum auditing the two closed binomial moments."""

    if trials < 0:
        raise ValueError("binomial trials must be nonnegative")
    if not 0.0 <= probability <= 1.0:
        raise ValueError("binomial probability must lie in [0,1]")
    if not 0.0 < epsilon < 1.0:
        raise ValueError("epsilon must lie strictly between zero and one")
    first = 0.0
    second = 0.0
    for count in range(trials + 1):
        mass = (
            comb(trials, count)
            * probability**count
            * (1.0 - probability) ** (trials - count)
        )
        value = float(
            smeared_kernel(np.array([count], dtype=np.int64), epsilon)[0]
        )
        first += mass * value
        second += mass * value**2
    return float(first), float(second)


def live_project_coefficient_error() -> float:
    """Compare the continuum sign/coefficient lock to the live discrete row."""

    ell = 0.1
    nonlocality_scale = 0.2
    epsilon = (ell / nonlocality_scale) ** 4
    past = np.array([True, True, False])
    counts = np.array([0, 3, 0])
    actual = project_convention_row(
        smeared_bd_row(past, counts, 2, ell, nonlocality_scale)
    )
    prefactor = 4.0 / (np.sqrt(6.0) * nonlocality_scale**2)
    expected = np.zeros(3)
    expected[past] = (
        -prefactor * epsilon * smeared_kernel(counts[past], epsilon)
    )
    expected[2] = prefactor
    denominator = max(1.0, float(np.max(np.abs(expected))))
    return float(np.max(np.abs(actual - expected)) / denominator)


def smooth_depth_cutoff(
    depth: np.ndarray,
    profile: CutoffProfile,
) -> np.ndarray:
    """Smooth step from zero to one across a fixed endpoint-depth band."""

    if not 0.0 <= profile.depth_zero < profile.depth_one <= 1.0:
        raise ValueError("cutoff depths must satisfy 0 <= d0 < d1 <= 1")
    values = np.zeros_like(depth, dtype=float)
    values[depth >= profile.depth_one] = 1.0
    transition = (depth > profile.depth_zero) & (depth < profile.depth_one)
    scaled = (depth[transition] - profile.depth_zero) / (
        profile.depth_one - profile.depth_zero
    )
    rising = np.exp(-1.0 / scaled)
    falling = np.exp(-1.0 / (1.0 - scaled))
    values[transition] = rising / (rising + falling)
    return values


def _gauss_interval(order: int, lower: float, upper: float) -> tuple[np.ndarray, np.ndarray]:
    if order <= 0 or upper < lower:
        raise ValueError("require a positive order and ordered interval")
    nodes, weights = leggauss(order)
    midpoint = 0.5 * (lower + upper)
    radius = 0.5 * (upper - lower)
    return midpoint + radius * nodes, radius * weights


def _proper_variable_segments(
    lower: float,
    upper: float,
    retarded_time: float,
    nonlocality_scale: float,
    radius: float,
    profile: CutoffProfile | None,
) -> list[tuple[float, float]]:
    """Split exactly where the frozen cutoff changes analytic branch."""

    boundaries = [lower, upper]
    if profile is not None:
        for depth in (profile.depth_zero, profile.depth_one):
            crossing = (
                radius**2 * np.sqrt(depth)
                - radius**2
                + 2.0 * radius * retarded_time
            ) / nonlocality_scale**2
            if lower < crossing < upper:
                boundaries.append(float(crossing))
    boundaries = sorted(set(boundaries))
    return list(zip(boundaries[:-1], boundaries[1:], strict=True))


def _retarded_time_segments(
    radius: float,
    profile: CutoffProfile | None,
) -> list[tuple[float, float]]:
    """Split at cutoff intersections with radial axis and outer boundary."""

    boundaries = [0.0, radius / 2.0, radius]
    if profile is not None:
        for depth in (profile.depth_zero, profile.depth_one):
            null_intersection = 0.5 * radius * (1.0 - np.sqrt(depth))
            axis_intersection = radius * (1.0 - depth ** 0.25)
            if 0.0 < null_intersection < radius:
                boundaries.append(float(null_intersection))
            if 0.0 < axis_intersection < radius:
                boundaries.append(float(axis_intersection))
    boundaries = sorted(set(boundaries))
    return list(zip(boundaries[:-1], boundaries[1:], strict=True))


def _field_angular_averages(
    retarded_time: float,
    radius_squared: np.ndarray,
    cutoff: np.ndarray,
) -> dict[str, np.ndarray]:
    """Angular averages for the registered polynomial symmetry classes."""

    u = retarded_time
    spatial_diagonal = radius_squared / 3.0
    return {
        "constant": cutoff,
        "temporal_affine": -u * cutoff,
        "temporal_quadratic": u**2 * cutoff,
        "spatial_quadratic": spatial_diagonal * cutoff,
        "temporal_cubic": -(u**3) * cutoff,
        "temporal_spatial_cubic": -u * spatial_diagonal * cutoff,
    }


def continuum_operator_moments(
    nonlocality_ratio: float,
    profile: CutoffProfile | None,
    quadrature_order: int,
    radius: float = 1.0,
    proper_variable_cutoff: float = 20.0,
) -> MomentResult:
    """Evaluate the registered continuum operator moments at the diamond center."""

    if not 0.0 < nonlocality_ratio < 1.0:
        raise ValueError("nonlocality ratio must lie between zero and one")
    if radius <= 0.0 or proper_variable_cutoff <= 0.0:
        raise ValueError("radius and proper-variable cutoff must be positive")
    nonlocality_scale = nonlocality_ratio * radius
    integrals = {name: 0.0 for name in FIELD_NAMES}

    # Split at u=R/2, where the radial boundary changes from the past light
    # cone of x to the past side of the outer marked diamond.
    for lower_u, upper_u in _retarded_time_segments(radius, profile):
        u_nodes, u_weights = _gauss_interval(
            quadrature_order, lower_u, upper_u
        )
        for u, u_weight in zip(u_nodes, u_weights, strict=True):
            radial_max = min(u, radius - u)
            proper_min = max(0.0, u**2 - radial_max**2)
            proper_max = u**2
            w_lower = proper_min / nonlocality_scale**2
            w_upper = min(
                proper_max / nonlocality_scale**2,
                proper_variable_cutoff,
            )
            if w_upper <= w_lower:
                continue
            for segment_lower, segment_upper in _proper_variable_segments(
                w_lower,
                w_upper,
                u,
                nonlocality_scale,
                radius,
                profile,
            ):
                w_nodes, w_weights = _gauss_interval(
                    quadrature_order, segment_lower, segment_upper
                )
                proper_squared = nonlocality_scale**2 * w_nodes
                radius_squared = np.maximum(0.0, u**2 - proper_squared)
                radial_jacobian = (
                    2.0
                    * np.pi
                    * nonlocality_scale**2
                    * np.sqrt(radius_squared)
                )
                endpoint_proper_squared = (
                    radius**2 - 2.0 * radius * u + proper_squared
                )
                depth = (
                    np.maximum(0.0, endpoint_proper_squared) ** 2 / radius**4
                )
                cutoff = (
                    np.ones_like(depth)
                    if profile is None
                    else smooth_depth_cutoff(depth, profile)
                )
                z = C4 * w_nodes**2
                kernel = np.exp(-z) * broad_layer_polynomial(z)
                measure = u_weight * w_weights * radial_jacobian * kernel
                averages = _field_angular_averages(u, radius_squared, cutoff)
                for name in FIELD_NAMES:
                    integrals[name] += float(
                        np.sum(measure * averages[name])
                    )

    prefactor = 4.0 / (
        np.sqrt(6.0) * nonlocality_scale**2
    )
    scale_four = nonlocality_scale**4
    values = {
        name: prefactor
        * ((1.0 if name == "constant" else 0.0) - integral / scale_four)
        for name, integral in integrals.items()
    }
    metric_diagonal = np.array(
        [
            0.5 * values["temporal_quadratic"],
            0.5 * values["spatial_quadratic"],
            0.5 * values["spatial_quadratic"],
            0.5 * values["spatial_quadratic"],
        ]
    )
    eigenvalues = np.linalg.eigvalsh(np.diag(metric_diagonal))
    tolerance = 1.0e-10
    signature = (
        int(np.count_nonzero(eigenvalues > tolerance)),
        int(np.count_nonzero(eigenvalues < -tolerance)),
        int(np.count_nonzero(np.abs(eigenvalues) <= tolerance)),
    )
    denominator = float(np.linalg.norm(PROJECT_TARGET, ord="fro"))
    metric_error = float(
        np.linalg.norm(np.diag(metric_diagonal) - PROJECT_TARGET, ord="fro")
        / denominator
    )
    spatial_response = values["spatial_quadratic"]
    response_ratio_error = (
        float("inf")
        if abs(spatial_response) <= 1.0e-14
        else abs(values["temporal_quadratic"] / spatial_response + 1.0)
    )
    principal_symbol_denominator = (
        abs(values["temporal_quadratic"]) + abs(spatial_response)
    )
    principal_symbol_mismatch = (
        float("inf")
        if principal_symbol_denominator <= 1.0e-14
        else abs(values["temporal_quadratic"] + spatial_response)
        / principal_symbol_denominator
    )
    zero_residual = max(
        abs(values[name])
        for name in (
            "constant",
            "temporal_affine",
            "temporal_cubic",
            "temporal_spatial_cubic",
        )
    )
    return MomentResult(
        cutoff="none" if profile is None else profile.name,
        nonlocality_ratio=nonlocality_ratio,
        quadrature_order=quadrature_order,
        operator_values=values,
        metric_diagonal=metric_diagonal.tolist(),
        metric_relative_error=metric_error,
        signature=signature,
        response_ratio_error=float(response_ratio_error),
        principal_symbol_mismatch=float(principal_symbol_mismatch),
        maximum_zero_target_residual=float(zero_residual),
    )


def quadrature_agreement(
    low: MomentResult,
    high: MomentResult,
    relative_tolerance: float = 2.0e-5,
    absolute_tolerance: float = 2.0e-6,
) -> dict[str, object]:
    """Compare all registered operator moments at two quadrature orders."""

    if low.cutoff != high.cutoff or low.nonlocality_ratio != high.nonlocality_ratio:
        raise ValueError("quadrature results must share their physical setting")
    differences: dict[str, dict[str, float | bool]] = {}
    for name in FIELD_NAMES:
        left = low.operator_values[name]
        right = high.operator_values[name]
        absolute = abs(left - right)
        scale = max(abs(left), abs(right))
        relative = absolute / scale if scale > absolute_tolerance else 0.0
        differences[name] = {
            "absolute": absolute,
            "relative": relative,
            "passes": bool(
                absolute <= absolute_tolerance
                or relative <= relative_tolerance
            ),
        }
    return {
        "passes": all(bool(item["passes"]) for item in differences.values()),
        "fields": differences,
    }


def run_protocol(args: argparse.Namespace) -> dict[str, object]:
    coefficient_error = live_project_coefficient_error()
    if coefficient_error > 1.0e-12:
        raise RuntimeError(
            "live discrete operator does not match the continuum convention"
        )
    profiles: list[CutoffProfile | None] = [
        CutoffProfile("primary", 0.02, 0.08),
        CutoffProfile("robustness", 0.04, 0.12),
        None,
    ]
    settings: list[dict[str, object]] = []
    for profile in profiles:
        for ratio in args.nonlocality_ratios:
            low = continuum_operator_moments(
                ratio,
                profile,
                args.quadrature_orders[0],
                proper_variable_cutoff=args.proper_variable_cutoff,
            )
            high = continuum_operator_moments(
                ratio,
                profile,
                args.quadrature_orders[1],
                proper_variable_cutoff=args.proper_variable_cutoff,
            )
            settings.append(
                {
                    "cutoff": high.cutoff,
                    "nonlocality_ratio": ratio,
                    "low": asdict(low),
                    "high": asdict(high),
                    "quadrature_agreement": quadrature_agreement(low, high),
                }
            )

    profile_passes: dict[str, dict[str, object]] = {}
    for profile_name in ("primary", "robustness"):
        selected = [
            setting for setting in settings if setting["cutoff"] == profile_name
        ]
        first = selected[0]["high"]
        final = selected[-1]["high"]
        metric_reduction = (
            1.0
            - float(final["metric_relative_error"])
            / float(first["metric_relative_error"])
        )
        zero_reduction = (
            1.0
            - float(final["maximum_zero_target_residual"])
            / float(first["maximum_zero_target_residual"])
        )
        checks = {
            "quadrature": all(
                bool(setting["quadrature_agreement"]["passes"])
                for setting in selected
            ),
            "signature": tuple(final["signature"]) == (1, 3, 0),
            "metric_error": (
                float(final["metric_relative_error"])
                < args.metric_error_threshold
            ),
            "response_ratio": (
                float(final["response_ratio_error"])
                < args.response_ratio_threshold
            ),
            "principal_symbol": (
                float(final["principal_symbol_mismatch"])
                < args.principal_symbol_threshold
            ),
            "zero_residual": (
                float(final["maximum_zero_target_residual"])
                < args.zero_residual_threshold
            ),
            "metric_reduction": metric_reduction >= args.minimum_reduction,
            "zero_reduction": zero_reduction >= args.minimum_reduction,
        }
        profile_passes[profile_name] = {
            "passes": all(checks.values()),
            "checks": checks,
            "metric_error_reduction": metric_reduction,
            "zero_residual_reduction": zero_reduction,
        }

    target_only = bool(getattr(args, "target_only", False))
    target_generation_checks = {
        profile_name: all(
            bool(setting["quadrature_agreement"]["passes"])
            for setting in settings
            if setting["cutoff"] == profile_name
        )
        for profile_name in ("primary", "robustness")
    }
    passes = (
        coefficient_error <= 1.0e-12
        and all(target_generation_checks.values())
        if target_only
        else all(item["passes"] for item in profile_passes.values())
    )
    return {
        "stage": args.stage,
        "claim_boundary": (
            "quadrature-certified finite target generation; not an asymptotic "
            "physics gate"
            if target_only
            else "deterministic continuum-kernel control; not a graph or GR limit"
        ),
        "conventions": {
            "signature": "+---",
            "source_to_project_sign": -1,
            "c4": C4,
            "live_project_coefficient_relative_error": coefficient_error,
            "nonlocality_ratios": args.nonlocality_ratios,
            "quadrature_orders": args.quadrature_orders,
            "proper_variable_cutoff": args.proper_variable_cutoff,
            "target_only": target_only,
            "pass_thresholds": {
                "metric_error": args.metric_error_threshold,
                "response_ratio": args.response_ratio_threshold,
                "principal_symbol": args.principal_symbol_threshold,
                "zero_residual": args.zero_residual_threshold,
                "minimum_reduction": args.minimum_reduction,
            },
            "profiles": [
                {"name": "primary", "depth_zero": 0.02, "depth_one": 0.08},
                {
                    "name": "robustness",
                    "depth_zero": 0.04,
                    "depth_one": 0.12,
                },
            ],
        },
        "profile_passes": profile_passes,
        "target_generation_checks": target_generation_checks,
        "passes": passes,
        "settings": settings,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--stage", default="A41")
    parser.add_argument(
        "--nonlocality-ratios",
        type=float,
        nargs="+",
        default=[0.25, 0.20, 0.16, 0.125, 0.10],
    )
    parser.add_argument(
        "--quadrature-orders", type=int, nargs=2, default=[160, 240]
    )
    parser.add_argument("--proper-variable-cutoff", type=float, default=20.0)
    parser.add_argument("--metric-error-threshold", type=float, default=0.20)
    parser.add_argument("--response-ratio-threshold", type=float, default=0.15)
    parser.add_argument("--principal-symbol-threshold", type=float, default=0.10)
    parser.add_argument("--zero-residual-threshold", type=float, default=0.20)
    parser.add_argument("--minimum-reduction", type=float, default=0.40)
    parser.add_argument(
        "--target-only",
        action="store_true",
        help="certify coefficient convention and quadrature only",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(
            "AgentTasks/causal-continuum-kernel-moments-stage-a41-2026-07-15.json"
        ),
    )
    args = parser.parse_args()
    if sorted(args.nonlocality_ratios, reverse=True) != args.nonlocality_ratios:
        raise ValueError("nonlocality ratios must be supplied in decreasing order")
    if args.quadrature_orders[0] >= args.quadrature_orders[1]:
        raise ValueError("quadrature orders must be strictly increasing")
    artifact = run_protocol(args)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(artifact, indent=2, sort_keys=True, allow_nan=False) + "\n",
        encoding="utf-8",
    )
    print(json.dumps({"output": str(args.output), "passes": artifact["passes"]}))


if __name__ == "__main__":
    main()
