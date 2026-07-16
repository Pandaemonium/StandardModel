"""Stage A43 low-epsilon concentration of one marked causal-operator row.

The A42 marked-row implementation is reused with exact interval statistics
computed once per realization. A43 compares the quadratic metric channel and
lower-order diagnostics against A41e finite Poisson-mean targets at the two
scales frozen in its preregistration.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict
from pathlib import Path

import numpy as np

from causal_continuum_kernel_moments import CutoffProfile
from causal_discrete_germ_moments import (
    DiscreteMomentSample,
    live_project_coefficient_error,
    run_split,
)


QUADRATIC_FIELDS = ("temporal_quadratic", "spatial_quadratic")
LOWER_ORDER_FIELDS = (
    "temporal_affine",
    "temporal_cubic",
    "temporal_spatial_cubic",
)


def response_error(
    actual: dict[str, float],
    target: dict[str, float],
    fields: tuple[str, ...],
) -> float:
    """Root-mean-square normalized error on a declared field subset."""

    residuals = np.array(
        [
            (actual[name] - target[name]) / max(1.0, abs(target[name]))
            for name in fields
        ]
    )
    return float(np.linalg.norm(residuals) / np.sqrt(len(fields)))


def load_a41e_targets(
    path: Path,
) -> dict[tuple[str, float], dict[str, float]]:
    artifact = json.loads(path.read_text(encoding="utf-8"))
    if artifact.get("stage") != "A41e" or not artifact.get("passes"):
        raise ValueError("A43 requires the passing A41e target artifact")
    if not artifact.get("conventions", {}).get("target_only"):
        raise ValueError("A43 target artifact must be marked target-only")
    targets: dict[tuple[str, float], dict[str, float]] = {}
    for setting in artifact["settings"]:
        cutoff = str(setting["cutoff"])
        ratio = float(setting["nonlocality_ratio"])
        if cutoff in {"primary", "robustness"} and ratio in {0.30, 0.25}:
            targets[(cutoff, ratio)] = {
                name: float(value)
                for name, value in setting["high"]["operator_values"].items()
            }
    expected = {
        (cutoff, ratio)
        for cutoff in ("primary", "robustness")
        for ratio in (0.30, 0.25)
    }
    if set(targets) != expected:
        raise ValueError("A41e artifact lacks a required A43 target stratum")
    return targets


def load_diagonal_predictions(
    path: Path,
) -> dict[tuple[str, float], dict[str, float]]:
    artifact = json.loads(path.read_text(encoding="utf-8"))
    expected_boundary = (
        "exact Poisson diagonal second-moment contribution; excludes "
        "off-diagonal and random-taper covariance"
    )
    if artifact.get("claim_boundary") != expected_boundary:
        raise ValueError("unrecognized diagonal-variance artifact")
    predictions: dict[tuple[str, float], dict[str, float]] = {}
    for record in artifact["records"]:
        high = record["high"]
        cutoff = str(high["cutoff"])
        ratio = float(high["nonlocality_ratio"])
        if cutoff in {"primary", "robustness"} and ratio in {0.30, 0.25}:
            if int(high["events"]) != 20_000:
                raise ValueError("A43 diagonal prediction must use N=20000")
            predictions[(cutoff, ratio)] = {
                name: float(value)
                for name, value in high[
                    "diagonal_standard_deviation"
                ].items()
            }
    if len(predictions) != 4:
        raise ValueError("diagonal artifact lacks an A43 stratum")
    return predictions


def enrich_summaries(
    summaries: list[dict[str, object]],
    diagonal_predictions: dict[tuple[str, float], dict[str, float]],
) -> None:
    for summary in summaries:
        actual = summary["mean_operator_values"]
        target = summary["target_values"]
        if not isinstance(actual, dict) or not isinstance(target, dict):
            raise TypeError("operator summaries must be dictionaries")
        summary["quadratic_response_error"] = response_error(
            actual, target, QUADRATIC_FIELDS
        )
        summary["lower_order_response_error"] = response_error(
            actual, target, LOWER_ORDER_FIELDS
        )
        summary["potential_response"] = float(actual["constant"])
        target_metric = np.asarray(summary["target_metric_diagonal"], dtype=float)
        summary["target_is_lorentzian"] = bool(
            np.count_nonzero(target_metric > 1.0e-10) == 1
            and np.count_nonzero(target_metric < -1.0e-10) == 3
        )
        if int(summary["events"]) == 20_000:
            key = (str(summary["cutoff"]), float(summary["nonlocality_ratio"]))
            prediction = diagonal_predictions[key]
            standard_deviations = summary["standard_deviations"]
            if not isinstance(standard_deviations, dict):
                raise TypeError("standard deviations must be a dictionary")
            summary["quadratic_diagonal_prediction"] = {
                name: prediction[name] for name in QUADRATIC_FIELDS
            }
            summary["quadratic_empirical_to_diagonal_ratio"] = {
                name: float(standard_deviations[name]) / prediction[name]
                for name in QUADRATIC_FIELDS
            }


def _fractional_reduction(low: float, high: float) -> float:
    if low <= 0.0:
        return 1.0 if high <= 0.0 else float("-inf")
    return 1.0 - high / low


def heldout_gate(summaries: list[dict[str, object]]) -> dict[str, object]:
    strata: dict[str, dict[str, object]] = {}
    for cutoff in ("primary", "robustness"):
        for ratio in (0.30, 0.25):
            low = next(
                item
                for item in summaries
                if item["events"] == 10_000
                and item["cutoff"] == cutoff
                and item["nonlocality_ratio"] == ratio
            )
            high = next(
                item
                for item in summaries
                if item["events"] == 20_000
                and item["cutoff"] == cutoff
                and item["nonlocality_ratio"] == ratio
            )
            quadratic_reduction = _fractional_reduction(
                float(low["quadratic_response_error"]),
                float(high["quadratic_response_error"]),
            )
            metric_reduction = _fractional_reduction(
                float(low["ensemble_mean_metric_error"]),
                float(high["ensemble_mean_metric_error"]),
            )
            principal_difference = abs(
                float(high["ensemble_mean_principal_symbol_mismatch"])
                - float(high["target_principal_symbol_mismatch"])
            )
            empirical_ratios = high[
                "quadratic_empirical_to_diagonal_ratio"
            ]
            if not isinstance(empirical_ratios, dict):
                raise TypeError("empirical diagonal ratios must be a dictionary")
            checks = {
                "target_lorentzian": bool(high["target_is_lorentzian"]),
                "scale_and_cutoff": bool(
                    high["all_scale_admissible"]
                    and high["all_endpoint_cutoffs_exact"]
                ),
                "quadratic_response": (
                    float(high["quadratic_response_error"]) < 0.15
                ),
                "metric": float(high["ensemble_mean_metric_error"]) < 0.15,
                "principal_symbol": principal_difference < 0.08,
                "lower_order": (
                    float(high["lower_order_response_error"]) < 0.30
                ),
                "quadratic_improvement": quadratic_reduction >= 0.15,
                "metric_improvement": metric_reduction >= 0.15,
                "signature": float(high["signature_match_rate"]) >= 0.75,
                "diagonal_prediction": all(
                    float(empirical_ratios[name]) <= 3.0
                    for name in QUADRATIC_FIELDS
                ),
            }
            key = f"{cutoff}|L={ratio:.2f}"
            strata[key] = {
                "passes": all(checks.values()),
                "checks": checks,
                "quadratic_error_reduction": quadratic_reduction,
                "metric_error_reduction": metric_reduction,
                "principal_symbol_difference": principal_difference,
                "quadratic_empirical_to_diagonal_ratio": empirical_ratios,
            }
    coefficient_check = live_project_coefficient_error() < 1.0e-12
    return {
        "coefficient_convention": coefficient_check,
        "strata": strata,
        "passes": coefficient_check
        and all(bool(item["passes"]) for item in strata.values()),
    }


def write_artifact(
    output: Path,
    split: str,
    seed: int,
    events: list[int],
    realizations: int,
    samples: list[DiscreteMomentSample],
    summaries: list[dict[str, object]],
    gate: dict[str, object] | None,
    args: argparse.Namespace,
) -> None:
    artifact = {
        "stage": "A43",
        "split": split,
        "claim_boundary": (
            "flat oracle pointwise finite-scale concentration; not a joint "
            "continuum, intrinsic algebra, or curvature result"
        ),
        "settings": {
            "seed": seed,
            "events": events,
            "realizations_per_density": realizations,
            "duration": args.duration,
            "nonlocality_ratios": args.nonlocality_ratios,
            "profiles": [
                asdict(CutoffProfile("primary", 0.02, 0.08)),
                asdict(CutoffProfile("robustness", 0.04, 0.12)),
            ],
            "block_size": args.block_size,
            "continuum_target": str(args.continuum_target),
            "diagonal_variance": str(args.diagonal_variance),
            "live_project_coefficient_relative_error": (
                live_project_coefficient_error()
            ),
        },
        "gate": gate,
        "summaries": summaries,
        "samples": [asdict(sample) for sample in samples],
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(
        json.dumps(artifact, indent=2, sort_keys=True, allow_nan=False) + "\n",
        encoding="utf-8",
    )


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--split", choices=("development", "heldout"), required=True)
    parser.add_argument("--duration", type=float, default=2.0)
    parser.add_argument(
        "--nonlocality-ratios", type=float, nargs="+", default=[0.30, 0.25]
    )
    parser.add_argument("--block-size", type=int, default=64)
    parser.add_argument(
        "--continuum-target",
        type=Path,
        default=Path(
            "AgentTasks/causal-continuum-kernel-moments-stage-a41e-2026-07-15.json"
        ),
    )
    parser.add_argument(
        "--diagonal-variance",
        type=Path,
        default=Path(
            "AgentTasks/causal-kernel-diagonal-variance-audit-2026-07-15.json"
        ),
    )
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    targets = load_a41e_targets(args.continuum_target)
    diagonal_predictions = load_diagonal_predictions(args.diagonal_variance)
    profiles = [
        CutoffProfile("primary", 0.02, 0.08),
        CutoffProfile("robustness", 0.04, 0.12),
    ]
    if args.split == "development":
        seed = 20261480
        events = [10_000, 20_000]
        realizations = 8
    else:
        seed = 20261490
        events = [10_000, 20_000]
        realizations = 32
    samples, summaries = run_split(
        seed,
        events,
        realizations,
        args.duration,
        profiles,
        args.nonlocality_ratios,
        targets,
        args.block_size,
    )
    enrich_summaries(summaries, diagonal_predictions)
    gate = heldout_gate(summaries) if args.split == "heldout" else None
    output = args.output or Path(
        f"AgentTasks/causal-discrete-germ-concentration-stage-a43-"
        f"{args.split}-2026-07-15.json"
    )
    write_artifact(
        output,
        args.split,
        seed,
        events,
        realizations,
        samples,
        summaries,
        gate,
        args,
    )
    print(
        json.dumps(
            {
                "output": str(output),
                "passes": None if gate is None else gate["passes"],
            }
        )
    )


if __name__ == "__main__":
    main()
