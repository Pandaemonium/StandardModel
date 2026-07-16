"""Finite continuum targets for arbitrary pivots in a marked 4D diamond.

The centered A41 quadrature exploits spherical symmetry. Regional A44 pivots
are selected from order counts and generally lie off center, where the outer
compact taper breaks that symmetry. This module integrates in relative
retarded time and proper separation. The angular domain is the exact spherical
cap cut out by the outer diamond, avoiding the high-variance uniform-volume
sampling that is unsuitable for the cancellation-dominated near-lightcone
kernel.

Coordinates are oracle inputs only. They neither select pivots nor change the
finite graph operator.
"""

from __future__ import annotations

from dataclasses import dataclass

import numpy as np
from numpy.polynomial.legendre import leggauss

from causal_continuum_kernel_moments import (
    C4,
    PROJECT_TARGET,
    CutoffProfile,
    broad_layer_polynomial,
    smooth_depth_cutoff,
)
from causal_operator_metric import diamond_volume_4d, strictly_precedes


COORDINATE_NAMES = ("t", "x", "y", "z")


@dataclass(frozen=True)
class OffCenterMomentResult:
    pivot: list[float]
    quadrature_orders: list[int]
    operator_values: dict[str, float]
    metric: list[list[float]]
    metric_relative_error: float
    signature: tuple[int, int, int]
    maximum_affine_residual: float


def continuum_depth_ratio(points: np.ndarray, radius: float = 1.0) -> np.ndarray:
    """Continuum counterpart of the two-sided count-depth normalization."""

    if points.ndim != 2 or points.shape[1] != 4:
        raise ValueError("points must have shape (N, 4)")
    if radius <= 0.0:
        raise ValueError("radius must be positive")
    spatial_squared = np.sum(points[:, 1:] ** 2, axis=1)
    bottom_tau_squared = points[:, 0] ** 2 - spatial_squared
    top_tau_squared = (2.0 * radius - points[:, 0]) ** 2 - spatial_squared
    return (
        np.minimum(
            np.maximum(0.0, bottom_tau_squared) ** 2,
            np.maximum(0.0, top_tau_squared) ** 2,
        )
        / radius**4
    )


def _gauss_interval(
    order: int, lower: float, upper: float
) -> tuple[np.ndarray, np.ndarray]:
    if order <= 0 or upper < lower:
        raise ValueError("require a positive order and ordered interval")
    nodes, weights = leggauss(order)
    midpoint = 0.5 * (lower + upper)
    half_width = 0.5 * (upper - lower)
    return midpoint + half_width * nodes, half_width * weights


def _spatial_frame(spatial_pivot: np.ndarray) -> np.ndarray:
    """Return an oriented orthonormal frame with axis zero radial at the pivot."""

    norm = float(np.linalg.norm(spatial_pivot))
    if norm <= 1.0e-15:
        return np.eye(3)
    radial = spatial_pivot / norm
    trial = (
        np.array([1.0, 0.0, 0.0])
        if abs(radial[0]) < 0.8
        else np.array([0.0, 1.0, 0.0])
    )
    transverse_one = trial - float(trial @ radial) * radial
    transverse_one /= np.linalg.norm(transverse_one)
    transverse_two = np.cross(radial, transverse_one)
    return np.column_stack((radial, transverse_one, transverse_two))


def _retarded_time_segments(time: float, spatial_radius: float) -> list[tuple[float, float]]:
    """Split at cap-topology changes and fixed conditioning points."""

    boundaries = [0.0, time]
    for value in (
        0.25 * time,
        0.5 * time,
        0.75 * time,
        time - spatial_radius,
        0.5 * (time + spatial_radius),
    ):
        if 0.0 < value < time:
            boundaries.append(float(value))
    boundaries = sorted(set(boundaries))
    return list(zip(boundaries[:-1], boundaries[1:], strict=True))


def offcenter_continuum_operator_moments(
    pivot: np.ndarray,
    nonlocality_ratio: float,
    profile: CutoffProfile,
    radius: float = 1.0,
    retarded_time_order: int = 40,
    proper_order: int = 48,
    polar_order: int = 12,
    azimuth_order: int = 12,
    proper_variable_cutoff: float = 20.0,
) -> OffCenterMomentResult:
    """Evaluate finite Poisson-mean moments and the full metric at ``pivot``."""

    pivot = np.asarray(pivot, dtype=float)
    if pivot.shape != (4,):
        raise ValueError("pivot must have four coordinates")
    if not 0.0 < nonlocality_ratio < 1.0:
        raise ValueError("nonlocality ratio must lie between zero and one")
    if min(
        retarded_time_order, proper_order, polar_order, azimuth_order
    ) <= 0:
        raise ValueError("quadrature orders must be positive")
    if proper_variable_cutoff <= 0.0:
        raise ValueError("proper-variable cutoff must be positive")
    bottom = np.array([0.0, 0.0, 0.0, 0.0])
    top = np.array([2.0 * radius, 0.0, 0.0, 0.0])
    if not (
        bool(strictly_precedes(bottom, pivot))
        and bool(strictly_precedes(pivot, top))
    ):
        raise ValueError("pivot must lie strictly inside the marked diamond")

    nonlocality_scale = nonlocality_ratio * radius
    prefactor = 4.0 / (np.sqrt(6.0) * nonlocality_scale**2)
    spatial_pivot = pivot[1:]
    spatial_radius = float(np.linalg.norm(spatial_pivot))
    frame = _spatial_frame(spatial_pivot)
    phi = 2.0 * np.pi * (np.arange(azimuth_order) + 0.5) / azimuth_order
    phi_weight = 2.0 * np.pi / azimuth_order

    field_names = ["constant"]
    field_names.extend(f"affine_{name}" for name in COORDINATE_NAMES)
    field_names.extend(
        f"quadratic_{COORDINATE_NAMES[mu]}_{COORDINATE_NAMES[nu]}"
        for mu in range(4)
        for nu in range(mu, 4)
    )
    field_names.extend(("cubic_t_t_t", "cubic_t_x_x"))
    integrals = {name: 0.0 for name in field_names}

    for lower_u, upper_u in _retarded_time_segments(
        float(pivot[0]), spatial_radius
    ):
        u_nodes, u_weights = _gauss_interval(
            retarded_time_order, lower_u, upper_u
        )
        for u, u_weight in zip(u_nodes, u_weights, strict=True):
            w_upper = min(
                u**2 / nonlocality_scale**2, proper_variable_cutoff
            )
            if w_upper <= 0.0:
                continue
            w_nodes, w_weights = _gauss_interval(proper_order, 0.0, w_upper)
            for w, w_weight in zip(w_nodes, w_weights, strict=True):
                radial_squared = max(
                    0.0, u**2 - nonlocality_scale**2 * w
                )
                radial = float(np.sqrt(radial_squared))
                bottom_time = float(pivot[0] - u)
                denominator = 2.0 * spatial_radius * radial
                if denominator <= 1.0e-15:
                    if spatial_radius**2 + radial_squared >= bottom_time**2:
                        continue
                    polar_lower = -1.0
                else:
                    polar_lower = (
                        spatial_radius**2
                        + radial_squared
                        - bottom_time**2
                    ) / denominator
                    if polar_lower >= 1.0:
                        continue
                    polar_lower = max(-1.0, float(polar_lower))

                polar, polar_weights = _gauss_interval(
                    polar_order, polar_lower, 1.0
                )
                sine = np.sqrt(np.maximum(0.0, 1.0 - polar**2))
                kernel = float(
                    np.exp(-C4 * w**2)
                    * broad_layer_polynomial(C4 * w**2)
                )
                radial_jacobian = 0.5 * nonlocality_scale**2 * radial
                base_weight = u_weight * w_weight * radial_jacobian * kernel
                for cosine, cosine_weight, sine_value in zip(
                    polar, polar_weights, sine, strict=True
                ):
                    local_directions = np.column_stack(
                        (
                            np.full(azimuth_order, cosine),
                            sine_value * np.cos(phi),
                            sine_value * np.sin(phi),
                        )
                    )
                    directions = local_directions @ frame.T
                    spatial_displacement = -radial * directions
                    spatial_point = spatial_pivot + spatial_displacement
                    points = np.column_stack(
                        (
                            np.full(azimuth_order, bottom_time),
                            spatial_point,
                        )
                    )
                    cutoff = smooth_depth_cutoff(
                        continuum_depth_ratio(points, radius), profile
                    )
                    weights = (
                        base_weight * cosine_weight * phi_weight * cutoff
                    )
                    displacement = np.column_stack(
                        (
                            np.full(azimuth_order, -u),
                            spatial_displacement,
                        )
                    )
                    integrals["constant"] += float(np.sum(weights))
                    for mu, name in enumerate(COORDINATE_NAMES):
                        integrals[f"affine_{name}"] += float(
                            weights @ displacement[:, mu]
                        )
                    for mu, left_name in enumerate(COORDINATE_NAMES):
                        for nu in range(mu, 4):
                            right_name = COORDINATE_NAMES[nu]
                            integrals[
                                f"quadratic_{left_name}_{right_name}"
                            ] += float(
                                weights
                                @ (
                                    displacement[:, mu]
                                    * displacement[:, nu]
                                )
                            )
                    integrals["cubic_t_t_t"] += float(
                        weights @ displacement[:, 0] ** 3
                    )
                    integrals["cubic_t_x_x"] += float(
                        weights
                        @ (displacement[:, 0] * displacement[:, 1] ** 2)
                    )

    values = {
        name: float(
            prefactor
            * (
                (1.0 if name == "constant" else 0.0)
                - integral / nonlocality_scale**4
            )
        )
        for name, integral in integrals.items()
    }
    metric = np.zeros((4, 4), dtype=float)
    for mu, left_name in enumerate(COORDINATE_NAMES):
        for nu in range(mu, 4):
            right_name = COORDINATE_NAMES[nu]
            metric[mu, nu] = 0.5 * values[
                f"quadratic_{left_name}_{right_name}"
            ]
            metric[nu, mu] = metric[mu, nu]

    eigenvalues = np.linalg.eigvalsh(metric)
    tolerance = 1.0e-10
    signature = (
        int(np.count_nonzero(eigenvalues > tolerance)),
        int(np.count_nonzero(eigenvalues < -tolerance)),
        int(np.count_nonzero(np.abs(eigenvalues) <= tolerance)),
    )
    metric_error = float(
        np.linalg.norm(metric - PROJECT_TARGET, ord="fro")
        / np.linalg.norm(PROJECT_TARGET, ord="fro")
    )
    affine_residual = max(
        abs(values[f"affine_{name}"]) for name in COORDINATE_NAMES
    )
    return OffCenterMomentResult(
        pivot=pivot.tolist(),
        quadrature_orders=[
            retarded_time_order,
            proper_order,
            polar_order,
            azimuth_order,
        ],
        operator_values=values,
        metric=metric.tolist(),
        metric_relative_error=metric_error,
        signature=signature,
        maximum_affine_residual=float(affine_residual),
    )


def result_difference(
    left: OffCenterMomentResult, right: OffCenterMomentResult
) -> dict[str, float]:
    """Compare two quadrature orders at one physical setting."""

    if left.pivot != right.pivot:
        raise ValueError("results must share a pivot")
    common = set(left.operator_values) & set(right.operator_values)
    return {
        "maximum_operator_absolute": max(
            abs(left.operator_values[name] - right.operator_values[name])
            for name in common
        ),
        "metric_frobenius": float(
            np.linalg.norm(np.asarray(left.metric) - np.asarray(right.metric))
        ),
    }
