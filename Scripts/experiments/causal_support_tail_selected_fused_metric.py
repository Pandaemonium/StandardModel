"""Stage A28 expanded-support tail selection and fresh curved metric fusion.

A26-A27 showed that central flat shape errors do not control signature tails or
row support.  This stage expands the compact-probe support grid and selects one
setting over two flat development densities using, in order: minimum signature
rate, worst individual unit-volume shape error, minimum row-support fraction,
worst design condition, and worst median shape error.  Curved samples remain
sealed until the setting is fixed.

The selected operator shape is fused with the independent A24 count volume by
the unchanged A25 determinant rule.  Coordinates, dimension, density, probes,
and schedules remain supplied; this is a conditional finite-density audit.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np

from causal_fused_operator_count_metric import run_experiment as run_fusion
from causal_operator_metric import MINKOWSKI_INVERSE, matrix_relative_error, signature
from causal_shape_selected_fused_metric import setting_key, unit_volume_shape


def select_support_tail_setting(
    development_artifacts: list[dict[str, object]],
) -> tuple[dict[str, object], dict[str, dict[str, dict[str, object]]]]:
    """Select a common setting using flat tail, support, and conditioning gates."""

    if len(development_artifacts) < 2:
        raise ValueError("tail selection requires at least two density artifacts")
    density_scores: dict[str, dict[str, dict[str, object]]] = {}
    representatives: dict[str, dict[str, object]] = {}
    common_keys: set[str] | None = None
    for artifact in development_artifacts:
        settings = artifact["settings"]
        events = int(settings["events"])
        maximum_rows = int(settings["maximum_rows"])
        label = f"N={events}"
        if label in density_scores:
            raise ValueError("development artifacts must have distinct densities")
        flat_samples = [
            sample
            for sample in artifact["samples"]
            if float(sample["hubble"]) == 0.0
        ]
        grouped: dict[str, list[dict[str, object]]] = {}
        for sample in flat_samples:
            key = setting_key(sample)
            grouped.setdefault(key, []).append(sample)
            representatives.setdefault(key, sample)
        scores: dict[str, dict[str, object]] = {}
        for key, samples in grouped.items():
            shape_errors: list[float] = []
            signature_successes = 0
            for sample in samples:
                metric = np.array(sample["metric"], dtype=float)
                if signature(metric) == (1, 3, 0):
                    signature_successes += 1
                    shape_errors.append(
                        matrix_relative_error(
                            unit_volume_shape(metric), MINKOWSKI_INVERSE
                        )
                    )
            scores[key] = {
                "sample_count": len(samples),
                "signature_success_rate": signature_successes / len(samples),
                "maximum_unit_volume_shape_error": (
                    float(np.max(shape_errors)) if shape_errors else float("inf")
                ),
                "median_unit_volume_shape_error": (
                    float(np.median(shape_errors)) if shape_errors else float("inf")
                ),
                "minimum_row_support_fraction": min(
                    int(sample["row_count"]) / maximum_rows for sample in samples
                ),
                "maximum_design_condition": max(
                    float(sample["design_condition"]) for sample in samples
                ),
            }
        density_scores[label] = scores
        common_keys = set(scores) if common_keys is None else common_keys & set(scores)
    if not common_keys:
        raise ValueError("development artifacts have no common settings")

    def score(key: str) -> tuple[float, ...]:
        per_density = [
            density_scores[label][key] for label in sorted(density_scores)
        ]
        return (
            -min(float(item["signature_success_rate"]) for item in per_density),
            max(float(item["maximum_unit_volume_shape_error"]) for item in per_density),
            -min(float(item["minimum_row_support_fraction"]) for item in per_density),
            max(float(item["maximum_design_condition"]) for item in per_density),
            max(float(item["median_unit_volume_shape_error"]) for item in per_density),
            key,
        )

    selected_key = min(common_keys, key=score)
    representative = representatives[selected_key]
    selected = {
        "key": selected_key,
        "nonlocality_multiplier": float(representative["nonlocality_multiplier"]),
        "support_multiplier": float(representative["support_multiplier"]),
        "averaging_multiplier": float(representative["averaging_multiplier"]),
        "selection_data": "flat expanded-support samples at every listed density",
        "minimum_signature_rate": -score(selected_key)[0],
        "worst_individual_unit_volume_shape_error": score(selected_key)[1],
        "minimum_row_support_fraction": -score(selected_key)[2],
        "worst_design_condition": score(selected_key)[3],
        "worst_median_unit_volume_shape_error": score(selected_key)[4],
    }
    return selected, density_scores


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    artifacts = [
        json.loads(path.read_text(encoding="utf-8")) for path in args.selection_inputs
    ]
    selected, density_scores = select_support_tail_setting(artifacts)
    fusion_args = argparse.Namespace(
        mode="held-out",
        events=args.events,
        realizations=args.realizations,
        duration=args.duration,
        pivot_fraction=args.pivot_fraction,
        hubble_values=args.hubble_values,
        operator_nonlocality_multiplier=selected["nonlocality_multiplier"],
        operator_support_multiplier=selected["support_multiplier"],
        operator_averaging_multiplier=selected["averaging_multiplier"],
        count_window_multiplier=args.count_window_multiplier,
        count_center_multiplier=args.count_center_multiplier,
        maximum_operator_rows=args.maximum_operator_rows,
        maximum_count_centers=args.maximum_count_centers,
        block_size=args.block_size,
        seed=args.seed,
        include_samples=args.include_samples,
        require_lorentzian=False,
    )
    result = run_fusion(fusion_args)
    result["status"] = (
        "conditional expanded-support tail-selected fusion; not reconstruction"
    )
    result["stage"] = "A28"
    result["selection_protocol"] = {
        "inputs": [str(path) for path in args.selection_inputs],
        "curved_samples_used_for_selection": False,
        "target_metric_used_after_selection": False,
        "selected_setting": selected,
        "flat_density_scores": density_scores,
    }
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--selection-inputs", type=Path, nargs="+", required=True)
    parser.add_argument("--events", type=int, default=4000)
    parser.add_argument("--realizations", type=int, default=4)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--pivot-fraction", type=float, default=0.7)
    parser.add_argument(
        "--hubble-values", type=float, nargs="+", default=[0.0, 0.1, 0.2]
    )
    parser.add_argument("--count-window-multiplier", type=float, default=0.65)
    parser.add_argument("--count-center-multiplier", type=float, default=1.2)
    parser.add_argument("--maximum-operator-rows", type=int, default=128)
    parser.add_argument("--maximum-count-centers", type=int, default=128)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--seed", type=int, default=20261190)
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
