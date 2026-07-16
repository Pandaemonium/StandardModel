"""Exact diagonal second-moment contribution for the smeared causal operator.

For a Poisson sprinkling, the Mecke identity makes the sum of squared
single-predecessor contributions an exact continuum integral. This script
evaluates that positive diagonal term on the A41 marked germ. It does not
include off-diagonal shared-sprinkling covariance or random cutoff-depth noise,
so it is not the full variance of the discrete operator row.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_continuum_kernel_moments import (
    C4,
    FIELD_NAMES,
    CutoffProfile,
    _gauss_interval,
    _proper_variable_segments,
    _retarded_time_segments,
    poisson_averaged_smeared_kernel_second_moment,
    smooth_depth_cutoff,
)


@dataclass(frozen=True)
class DiagonalVarianceResult:
    events: int
    cutoff: str
    nonlocality_ratio: float
    quadrature_order: int
    epsilon: float
    ell_over_nonlocality: float
    diagonal_variance: dict[str, float]
    diagonal_standard_deviation: dict[str, float]


def _field_square_angular_averages(
    retarded_time: float,
    radius_squared: np.ndarray,
    cutoff: np.ndarray,
) -> dict[str, np.ndarray]:
    """Angular averages of the squares of the six A41 field classes."""

    u = retarded_time
    cutoff_squared = cutoff**2
    spatial_fourth = radius_squared**2 / 5.0
    return {
        "constant": cutoff_squared,
        "temporal_affine": u**2 * cutoff_squared,
        "temporal_quadratic": u**4 * cutoff_squared,
        "spatial_quadratic": spatial_fourth * cutoff_squared,
        "temporal_cubic": u**6 * cutoff_squared,
        "temporal_spatial_cubic": u**2 * spatial_fourth * cutoff_squared,
    }


def continuum_diagonal_variance(
    events: int,
    nonlocality_ratio: float,
    profile: CutoffProfile,
    quadrature_order: int,
    radius: float = 1.0,
    proper_variable_cutoff: float = 20.0,
) -> DiagonalVarianceResult:
    """Evaluate the exact Poisson diagonal second-moment contribution."""

    if events <= 0 or quadrature_order <= 0:
        raise ValueError("events and quadrature order must be positive")
    if not 0.0 < nonlocality_ratio < 1.0:
        raise ValueError("nonlocality ratio must lie between zero and one")
    if radius <= 0.0 or proper_variable_cutoff <= 0.0:
        raise ValueError("radius and proper-variable cutoff must be positive")

    nonlocality_scale = nonlocality_ratio * radius
    diamond_volume = 16.0 * C4 * radius**4
    ell = (diamond_volume / events) ** 0.25
    epsilon = (ell / nonlocality_scale) ** 4
    if not epsilon < 1.0:
        raise ValueError("diagonal audit requires ell < nonlocality scale")
    integrals = {name: 0.0 for name in FIELD_NAMES}

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
                cutoff = smooth_depth_cutoff(depth, profile)
                z = C4 * w_nodes**2
                second_moment = np.fromiter(
                    (
                        poisson_averaged_smeared_kernel_second_moment(
                            float(value / epsilon), epsilon
                        )
                        for value in z
                    ),
                    dtype=float,
                    count=len(z),
                )
                measure = (
                    u_weight * w_weights * radial_jacobian * second_moment
                )
                averages = _field_square_angular_averages(
                    u, radius_squared, cutoff
                )
                for name in FIELD_NAMES:
                    integrals[name] += float(
                        np.sum(measure * averages[name])
                    )

    prefactor = 4.0 / (np.sqrt(6.0) * nonlocality_scale**2)
    # rho = 1/(epsilon L^4), while each predecessor coefficient is
    # prefactor*epsilon. Their squared diagonal contribution is therefore
    # prefactor^2*epsilon/L^4 times the continuum integral.
    variance_factor = (
        prefactor**2 * epsilon / nonlocality_scale**4
    )
    variance = {
        name: float(variance_factor * integral)
        for name, integral in integrals.items()
    }
    return DiagonalVarianceResult(
        events=events,
        cutoff=profile.name,
        nonlocality_ratio=nonlocality_ratio,
        quadrature_order=quadrature_order,
        epsilon=float(epsilon),
        ell_over_nonlocality=float(ell / nonlocality_scale),
        diagonal_variance=variance,
        diagonal_standard_deviation={
            name: float(np.sqrt(max(0.0, value)))
            for name, value in variance.items()
        },
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--events", type=int, default=20_000)
    parser.add_argument(
        "--nonlocality-ratios",
        type=float,
        nargs="+",
        default=[0.30, 0.25, 0.20, 0.16],
    )
    parser.add_argument(
        "--quadrature-orders", type=int, nargs=2, default=[48, 72]
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(
            "AgentTasks/causal-kernel-diagonal-variance-audit-2026-07-15.json"
        ),
    )
    args = parser.parse_args()
    profiles = (
        CutoffProfile("primary", 0.02, 0.08),
        CutoffProfile("robustness", 0.04, 0.12),
    )
    records: list[dict[str, object]] = []
    for profile in profiles:
        for ratio in args.nonlocality_ratios:
            low = continuum_diagonal_variance(
                args.events, ratio, profile, args.quadrature_orders[0]
            )
            high = continuum_diagonal_variance(
                args.events, ratio, profile, args.quadrature_orders[1]
            )
            relative_differences = {
                name: abs(
                    low.diagonal_standard_deviation[name]
                    - high.diagonal_standard_deviation[name]
                )
                / max(1.0e-14, high.diagonal_standard_deviation[name])
                for name in FIELD_NAMES
            }
            records.append(
                {
                    "low": asdict(low),
                    "high": asdict(high),
                    "maximum_relative_quadrature_difference": max(
                        relative_differences.values()
                    ),
                }
            )
    artifact = {
        "claim_boundary": (
            "exact Poisson diagonal second-moment contribution; excludes "
            "off-diagonal and random-taper covariance"
        ),
        "quadrature_orders": args.quadrature_orders,
        "records": records,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(artifact, indent=2, sort_keys=True, allow_nan=False) + "\n",
        encoding="utf-8",
    )
    print(json.dumps({"output": str(args.output), "records": len(records)}))


if __name__ == "__main__":
    main()
