"""Stage A27 multi-density flat-shape selection and fresh curved fusion.

This stage strengthens A26 by requiring one operator setting to perform across
two disjoint flat development densities.  Candidate settings are scored within
each density by Lorentzian signature and determinant-normalized conformal-shape
error.  Selection then minimizes the worst density score before the unchanged
A25 count-volume fusion is evaluated on fresh curved samples.

No curved target enters selection.  Coordinates, density, dimension, probes,
and schedules remain supplied, so this is still a conditional regulator audit.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from causal_fused_operator_count_metric import run_experiment as run_fusion
from causal_shape_selected_fused_metric import select_flat_shape_setting, setting_key


def select_multidensity_shape_setting(
    development_artifacts: list[dict[str, object]],
) -> tuple[dict[str, object], dict[str, dict[str, object]]]:
    """Minimize worst flat shape error over all supplied densities."""

    if len(development_artifacts) < 2:
        raise ValueError("multi-density selection requires at least two artifacts")
    density_scores: dict[str, dict[str, dict[str, object]]] = {}
    common_keys: set[str] | None = None
    for artifact in development_artifacts:
        settings = artifact["settings"]
        events = int(settings["events"])
        label = f"N={events}"
        if label in density_scores:
            raise ValueError("selection artifacts must have distinct event counts")
        _, scores = select_flat_shape_setting(artifact["samples"])
        density_scores[label] = scores
        common_keys = set(scores) if common_keys is None else common_keys & set(scores)
    if not common_keys:
        raise ValueError("selection artifacts have no common settings")

    def minimax_score(key: str) -> tuple[float, ...]:
        scores = [density_scores[label][key] for label in sorted(density_scores)]
        return (
            -min(float(score["signature_success_rate"]) for score in scores),
            max(float(score["median_unit_volume_shape_error"]) for score in scores),
            max(
                float(score["ensemble_mean_unit_volume_shape_error"])
                for score in scores
            ),
            max(float(score["maximum_unit_volume_shape_error"]) for score in scores),
            key,
        )

    selected_key = min(common_keys, key=minimax_score)
    first_samples = development_artifacts[0]["samples"]
    representative = next(
        sample for sample in first_samples if setting_key(sample) == selected_key
    )
    selected = {
        "key": selected_key,
        "nonlocality_multiplier": float(representative["nonlocality_multiplier"]),
        "support_multiplier": float(representative["support_multiplier"]),
        "averaging_multiplier": float(representative["averaging_multiplier"]),
        "selection_data": "flat samples from every listed development density",
        "minimum_signature_rate": -minimax_score(selected_key)[0],
        "worst_median_unit_volume_shape_error": minimax_score(selected_key)[1],
        "worst_ensemble_unit_volume_shape_error": minimax_score(selected_key)[2],
        "worst_maximum_unit_volume_shape_error": minimax_score(selected_key)[3],
    }
    return selected, density_scores


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    artifacts = [
        json.loads(path.read_text(encoding="utf-8")) for path in args.selection_inputs
    ]
    selected, density_scores = select_multidensity_shape_setting(artifacts)
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
        "conditional multi-density flat-shape-selected fusion; not reconstruction"
    )
    result["stage"] = "A27"
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
    parser.add_argument("--maximum-operator-rows", type=int, default=96)
    parser.add_argument("--maximum-count-centers", type=int, default=96)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument("--seed", type=int, default=20261150)
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
