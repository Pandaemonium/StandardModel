"""Stage A36 Levi-Civita connection from A35 reconstructed metric first jets.

Given a contravariant metric ``G`` and coordinate first jet ``dG``, invert to
``g`` and differentiate the inverse exactly,

    d_mu g = -g (d_mu G) g.

The standard Christoffel formula then produces the unique torsion-free,
metric-compatible coordinate connection.  A36 applies this construction to
the fresh A35 samples and compares it with the connection formed from the
known target metric and jet.

The construction is algebraic.  Its physical content is only as strong as the
supplied-coordinate A35 reconstruction; it does not estimate curvature or
derive a chart from a bare graph.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np

from causal_operator_metric import finite_statistics


@dataclass(frozen=True)
class LeviCivitaConnectionSample:
    events: int
    hubble: float
    duration: float
    connection: list[list[list[float]]]
    target_connection: list[list[list[float]]]
    connection_dimensionless_error: float
    connection_absolute_error: float
    target_connection_dimensionless_norm: float
    flat_false_connection_dimensionless_norm: float | None
    torsion_residual: float
    metric_compatibility_residual: float


def covariant_metric_and_first_jet(
    inverse_metric: np.ndarray,
    inverse_metric_first_jet: np.ndarray,
) -> tuple[np.ndarray, np.ndarray]:
    if inverse_metric.shape != (4, 4):
        raise ValueError("inverse metric must have shape (4,4)")
    if inverse_metric_first_jet.shape != (4, 4, 4):
        raise ValueError("inverse metric first jet must have shape (4,4,4)")
    metric = np.linalg.inv(inverse_metric)
    first_jet = np.array(
        [
            -metric @ inverse_metric_first_jet[derivative] @ metric
            for derivative in range(4)
        ]
    )
    return metric, first_jet


def levi_civita_connection_from_inverse_metric(
    inverse_metric: np.ndarray,
    inverse_metric_first_jet: np.ndarray,
) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Return ``Gamma^rho_mu_nu``, the covariant metric, and its first jet."""

    metric, metric_first_jet = covariant_metric_and_first_jet(
        inverse_metric, inverse_metric_first_jet
    )
    connection = np.zeros((4, 4, 4))
    for upper in range(4):
        for left in range(4):
            for right in range(4):
                connection[upper, left, right] = 0.5 * sum(
                    inverse_metric[upper, contracted]
                    * (
                        metric_first_jet[left, contracted, right]
                        + metric_first_jet[right, contracted, left]
                        - metric_first_jet[contracted, left, right]
                    )
                    for contracted in range(4)
                )
    return connection, metric, metric_first_jet


def connection_torsion_residual(connection: np.ndarray) -> float:
    return float(np.linalg.norm(connection - np.swapaxes(connection, 1, 2)))


def connection_metric_compatibility_residual(
    connection: np.ndarray,
    metric: np.ndarray,
    metric_first_jet: np.ndarray,
) -> float:
    residual = np.empty((4, 4, 4))
    for derivative in range(4):
        for left in range(4):
            for right in range(4):
                residual[derivative, left, right] = (
                    metric_first_jet[derivative, left, right]
                    - sum(
                        connection[upper, derivative, left] * metric[upper, right]
                        for upper in range(4)
                    )
                    - sum(
                        connection[upper, derivative, right] * metric[left, upper]
                        for upper in range(4)
                    )
                )
    return float(np.linalg.norm(residual))


def reconstruct_connection_sample(
    sample: dict[str, object],
    events: int,
) -> LeviCivitaConnectionSample:
    inverse_metric = np.array(sample["fused_metric"], dtype=float)
    inverse_jet = np.array(sample["selected_first_jet"], dtype=float)
    target_inverse_metric = np.array(sample["target_metric"], dtype=float)
    target_inverse_jet = np.array(sample["target_first_jet"], dtype=float)
    connection, metric, metric_jet = levi_civita_connection_from_inverse_metric(
        inverse_metric, inverse_jet
    )
    target_connection, _, _ = levi_civita_connection_from_inverse_metric(
        target_inverse_metric, target_inverse_jet
    )
    duration = float(sample["duration"])
    target_norm = duration * float(np.linalg.norm(target_connection))
    absolute_error = duration * float(
        np.linalg.norm(connection - target_connection)
    )
    hubble = float(sample["hubble"])
    return LeviCivitaConnectionSample(
        events=events,
        hubble=hubble,
        duration=duration,
        connection=connection.tolist(),
        target_connection=target_connection.tolist(),
        connection_dimensionless_error=absolute_error / max(1.0, target_norm),
        connection_absolute_error=absolute_error,
        target_connection_dimensionless_norm=target_norm,
        flat_false_connection_dimensionless_norm=(
            duration * float(np.linalg.norm(connection)) if hubble == 0.0 else None
        ),
        torsion_residual=connection_torsion_residual(connection),
        metric_compatibility_residual=connection_metric_compatibility_residual(
            connection, metric, metric_jet
        ),
    )


def summarize_samples(samples: list[LeviCivitaConnectionSample]) -> dict[str, object]:
    if not samples:
        raise ValueError("cannot summarize empty samples")
    connections = np.array([sample.connection for sample in samples])
    target = np.array(samples[0].target_connection)
    target_norm = samples[0].target_connection_dimensionless_norm
    duration = samples[0].duration
    return {
        "events": samples[0].events,
        "hubble": samples[0].hubble,
        "connection_dimensionless_error": finite_statistics(
            [sample.connection_dimensionless_error for sample in samples]
        ),
        "ensemble_connection_dimensionless_error": float(
            duration * np.linalg.norm(np.mean(connections, axis=0) - target)
            / max(1.0, target_norm)
        ),
        "connection_absolute_error": finite_statistics(
            [sample.connection_absolute_error for sample in samples]
        ),
        "target_connection_dimensionless_norm": target_norm,
        "flat_false_connection_dimensionless_norm": finite_statistics(
            [sample.flat_false_connection_dimensionless_norm for sample in samples]
        ),
        "torsion_residual": finite_statistics(
            [sample.torsion_residual for sample in samples]
        ),
        "metric_compatibility_residual": finite_statistics(
            [sample.metric_compatibility_residual for sample in samples]
        ),
    }


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    artifacts = [
        json.loads(path.read_text(encoding="utf-8")) for path in args.inputs
    ]
    samples: list[LeviCivitaConnectionSample] = []
    input_records: list[dict[str, object]] = []
    for path, artifact in zip(args.inputs, artifacts, strict=True):
        if artifact.get("stage") != "A35" or "samples" not in artifact:
            raise ValueError(f"{path} is not an A35 artifact with samples")
        events = int(artifact["settings"]["events"])
        input_records.append({"path": str(path), "events": events})
        samples.extend(
            reconstruct_connection_sample(sample, events)
            for sample in artifact["samples"]
        )
    cells = sorted({(sample.events, sample.hubble) for sample in samples})
    result: dict[str, object] = {
        "status": "conditional Levi-Civita connection control; not curvature",
        "stage": "A36",
        "claim_boundary": {
            "connection_is_derived_from_the_a35_metric_and_first_jet": True,
            "torsion_free_and_metric_compatible_are_algebraic": True,
            "target_comparison_uses_supplied_embedding_coordinates": True,
            "chart_density_dimension_probes_and_windows_are_supplied": True,
            "connection_convergence_is_not_claimed": True,
            "curvature_is_not_computed": True,
        },
        "inputs": input_records,
        "cell_summaries": {
            f"N={events}|H={hubble:.6f}": summarize_samples(
                [
                    sample
                    for sample in samples
                    if sample.events == events and sample.hubble == hubble
                ]
            )
            for events, hubble in cells
        },
    }
    if args.include_samples:
        result["samples"] = [asdict(sample) for sample in samples]
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--inputs", type=Path, nargs="+", required=True)
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
