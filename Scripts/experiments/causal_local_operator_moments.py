"""Stage A44a ideal-moment controls for a local causal operator.

The source-sign stencil follows Boguna and Krioukov, arXiv:2506.18745,
equations (84)--(91). Coordinate-oracle hyperboloid neighborhoods are built to
satisfy the displayed first- and second-moment relations exactly. The reported
operator is globally negated for the project signature (+---).

This is an algebraic/coordinate-oracle control. It does not estimate distances
from an order, select causal-set neighborhoods, or test random concentration.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import dataclass
from pathlib import Path
from typing import Callable

import numpy as np


Field = Callable[[np.ndarray], np.ndarray]


@dataclass(frozen=True)
class LocalMomentStencil:
    spatial_dimension: int
    balance: float
    scale: float
    temporal_forward: np.ndarray
    temporal_backward: np.ndarray
    spatial_forward: np.ndarray
    spatial_backward: np.ndarray


def ideal_moment_stencil(
    spatial_dimension: int, balance: float, scale: float
) -> LocalMomentStencil:
    """Construct symmetric hyperboloid points with the required moments."""

    if spatial_dimension <= 0:
        raise ValueError("spatial dimension must be positive")
    if balance <= 0.0 or scale <= 0.0:
        raise ValueError("balance and scale must be positive")
    temporal_forward = np.zeros(spatial_dimension + 1)
    temporal_backward = np.zeros(spatial_dimension + 1)
    temporal_forward[0] = scale
    temporal_backward[0] = -scale

    time_radius = scale * np.sqrt(spatial_dimension / balance + 1.0)
    spatial_radius = scale * np.sqrt(spatial_dimension / balance)
    spatial_forward = np.zeros((2 * spatial_dimension, spatial_dimension + 1))
    spatial_backward = np.zeros_like(spatial_forward)
    spatial_forward[:, 0] = time_radius
    spatial_backward[:, 0] = -time_radius
    for axis in range(spatial_dimension):
        spatial_forward[2 * axis, axis + 1] = spatial_radius
        spatial_forward[2 * axis + 1, axis + 1] = -spatial_radius
        spatial_backward[2 * axis, axis + 1] = spatial_radius
        spatial_backward[2 * axis + 1, axis + 1] = -spatial_radius
    return LocalMomentStencil(
        spatial_dimension=spatial_dimension,
        balance=balance,
        scale=scale,
        temporal_forward=temporal_forward,
        temporal_backward=temporal_backward,
        spatial_forward=spatial_forward,
        spatial_backward=spatial_backward,
    )


def second_difference(
    center: float, forward: float, backward: float, scale: float
) -> float:
    return float((forward + backward - 2.0 * center) / scale**2)


def local_responses(
    stencil: LocalMomentStencil, field: Field
) -> tuple[float, float, float, float]:
    """Return temporal, spatial, source-sign, and project-sign responses."""

    center_point = np.zeros(stencil.spatial_dimension + 1)
    center = float(field(center_point))
    temporal = second_difference(
        center,
        float(field(stencil.temporal_forward)),
        float(field(stencil.temporal_backward)),
        stencil.scale,
    )
    spatial = second_difference(
        center,
        float(np.mean(field(stencil.spatial_forward))),
        float(np.mean(field(stencil.spatial_backward))),
        stencil.scale,
    )
    source = (
        -(stencil.balance + stencil.spatial_dimension + 1.0) * temporal
        + stencil.balance * spatial
    )
    return temporal, spatial, float(source), float(-source)


def polynomial_fields(spatial_dimension: int) -> dict[str, Field]:
    fields: dict[str, Field] = {
        "constant": lambda x: np.ones(np.shape(x)[:-1]),
        "temporal_affine": lambda x: x[..., 0],
        "temporal_quadratic": lambda x: x[..., 0] ** 2,
    }
    for axis in range(spatial_dimension):
        fields[f"spatial_affine_{axis + 1}"] = (
            lambda x, j=axis + 1: x[..., j]
        )
        fields[f"spatial_quadratic_{axis + 1}"] = (
            lambda x, j=axis + 1: x[..., j] ** 2
        )
        fields[f"temporal_spatial_cross_{axis + 1}"] = (
            lambda x, j=axis + 1: x[..., 0] * x[..., j]
        )
    if spatial_dimension >= 2:
        fields["spatial_cross_1_2"] = lambda x: x[..., 1] * x[..., 2]
    return fields


def expected_project_response(name: str) -> float:
    if name == "temporal_quadratic":
        return 2.0
    if name.startswith("spatial_quadratic_"):
        return -2.0
    return 0.0


def moment_diagnostics(stencil: LocalMomentStencil) -> dict[str, object]:
    points = np.concatenate(
        (stencil.spatial_forward, stencil.spatial_backward), axis=0
    )
    first_moment = np.mean(points, axis=0)
    second_moment = np.mean(points**2, axis=0)
    target_second = np.concatenate(
        (
            [
                (stencil.spatial_dimension / stencil.balance + 1.0)
                * stencil.scale**2
            ],
            np.full(
                stencil.spatial_dimension,
                stencil.scale**2 / stencil.balance,
            ),
        )
    )
    proper_time_squared = (
        points[:, 0] ** 2 - np.sum(points[:, 1:] ** 2, axis=1)
    )
    return {
        "max_absolute_first_moment": float(np.max(np.abs(first_moment))),
        "max_absolute_second_moment_error": float(
            np.max(np.abs(second_moment - target_second))
        ),
        "max_absolute_proper_time_squared_error": float(
            np.max(np.abs(proper_time_squared - stencil.scale**2))
        ),
    }


def audit_stencil(stencil: LocalMomentStencil) -> dict[str, object]:
    responses: dict[str, dict[str, float]] = {}
    for name, field in polynomial_fields(stencil.spatial_dimension).items():
        temporal, spatial, source, project = local_responses(stencil, field)
        expected = expected_project_response(name)
        responses[name] = {
            "temporal_difference": temporal,
            "spatial_difference": spatial,
            "source_response": source,
            "project_response": project,
            "expected_project_response": expected,
            "absolute_error": abs(project - expected),
        }
    metric_diagonal = [
        0.5 * responses["temporal_quadratic"]["project_response"]
    ] + [
        0.5 * responses[f"spatial_quadratic_{axis + 1}"][
            "project_response"
        ]
        for axis in range(stencil.spatial_dimension)
    ]
    return {
        "spatial_dimension": stencil.spatial_dimension,
        "balance": stencil.balance,
        "scale": stencil.scale,
        "moment_diagnostics": moment_diagnostics(stencil),
        "responses": responses,
        "metric_diagonal": metric_diagonal,
        "max_absolute_response_error": max(
            item["absolute_error"] for item in responses.values()
        ),
    }


def asymmetric_negative_control(stencil: LocalMomentStencil) -> float:
    """Break one spatial first moment and return the leaked affine response."""

    shifted = stencil.spatial_forward.copy()
    shifted[0, 1] += 0.25 * stencil.scale
    perturbed = LocalMomentStencil(
        spatial_dimension=stencil.spatial_dimension,
        balance=stencil.balance,
        scale=stencil.scale,
        temporal_forward=stencil.temporal_forward,
        temporal_backward=stencil.temporal_backward,
        spatial_forward=shifted,
        spatial_backward=stencil.spatial_backward,
    )
    field = polynomial_fields(stencil.spatial_dimension)["spatial_affine_1"]
    return local_responses(perturbed, field)[3]


def run_audit() -> dict[str, object]:
    settings = [
        audit_stencil(ideal_moment_stencil(d, 243.0 / 29.0, 0.2))
        for d in (1, 2, 3)
    ]
    negative_control = asymmetric_negative_control(
        ideal_moment_stencil(3, 243.0 / 29.0, 0.2)
    )
    tolerance = 1.0e-12
    passes = all(
        setting["max_absolute_response_error"] < tolerance
        and setting["moment_diagnostics"][
            "max_absolute_first_moment"
        ] < tolerance
        and setting["moment_diagnostics"][
            "max_absolute_second_moment_error"
        ] < tolerance
        and setting["moment_diagnostics"][
            "max_absolute_proper_time_squared_error"
        ] < tolerance
        for setting in settings
    ) and abs(negative_control) > 1.0e-3
    return {
        "stage": "A44a",
        "claim_boundary": (
            "ideal coordinate-oracle local moment stencil; no intrinsic "
            "distance or concentration claim"
        ),
        "conventions": {
            "source_signature": "-+++",
            "project_signature": "+---",
            "project_response": "negative of source response",
        },
        "settings": settings,
        "asymmetric_affine_negative_control": negative_control,
        "passes": passes,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(
            "AgentTasks/causal-local-operator-moments-stage-a44a-2026-07-15.json"
        ),
    )
    args = parser.parse_args()
    artifact = run_audit()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(
        json.dumps(artifact, indent=2, sort_keys=True, allow_nan=False) + "\n",
        encoding="utf-8",
    )
    print(json.dumps({"output": str(args.output), "passes": artifact["passes"]}))


if __name__ == "__main__":
    main()
