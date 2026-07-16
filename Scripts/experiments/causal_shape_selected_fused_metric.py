"""Stage A26 flat-shape selection followed by operator/count metric fusion.

Stage A23 selected its regulator by prioritizing a first-jet score among
near-best raw flat metrics.  Stage A25 subsequently showed that this first jet
does not survive refinement and that count volume can repair only the overall
scale.  This stage therefore reuses the untouched A23 development grid and
selects the setting with the best determinant-normalized flat conformal shape.

Only ``H = 0`` development samples enter selection.  The selected operator
setting is then passed unchanged to the A25 same-sprinkling count-volume fusion
on fresh curved seeds.  Coordinates, density, dimension, probe germs, and both
window schedules remain supplied, so this is a conditional selector audit, not
bare-graph metric reconstruction.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np

from causal_fused_operator_count_metric import run_experiment as run_fusion
from causal_operator_metric import MINKOWSKI_INVERSE, matrix_relative_error, signature


def setting_key(sample: dict[str, object]) -> str:
    """Return the frozen A23 setting key for one serialized sample."""

    return (
        f"cL={float(sample['nonlocality_multiplier']):.6f}|"
        f"cS={float(sample['support_multiplier']):.6f}|"
        f"cA={float(sample['averaging_multiplier']):.6f}"
    )


def unit_volume_shape(metric: np.ndarray) -> np.ndarray:
    """Remove the positive inverse-metric scale using the determinant."""

    if metric.shape != (4, 4):
        raise ValueError("metric must be 4 by 4")
    determinant = float(np.linalg.det(metric))
    if determinant == 0.0:
        raise ValueError("metric must be nondegenerate")
    return metric / abs(determinant) ** 0.25


def select_flat_shape_setting(
    serialized_samples: list[dict[str, object]],
) -> tuple[dict[str, object], dict[str, dict[str, object]]]:
    """Select the most stable unit-volume shape using flat samples only."""

    flat_samples = [
        sample for sample in serialized_samples if float(sample["hubble"]) == 0.0
    ]
    if not flat_samples:
        raise ValueError("selection input must contain H = 0 samples")
    grouped: dict[str, list[dict[str, object]]] = {}
    for sample in flat_samples:
        grouped.setdefault(setting_key(sample), []).append(sample)

    scores: dict[str, dict[str, object]] = {}
    for key, samples in grouped.items():
        shape_errors: list[float] = []
        shapes: list[np.ndarray] = []
        signature_successes = 0
        for sample in samples:
            metric = np.array(sample["metric"], dtype=float)
            if signature(metric) == (1, 3, 0):
                signature_successes += 1
                shape = unit_volume_shape(metric)
                shapes.append(shape)
                shape_errors.append(matrix_relative_error(shape, MINKOWSKI_INVERSE))
        if shapes:
            ensemble_shape_error = matrix_relative_error(
                np.mean(shapes, axis=0), MINKOWSKI_INVERSE
            )
            median_shape_error = float(np.median(shape_errors))
            maximum_shape_error = float(np.max(shape_errors))
        else:
            ensemble_shape_error = float("inf")
            median_shape_error = float("inf")
            maximum_shape_error = float("inf")
        scores[key] = {
            "sample_count": len(samples),
            "signature_success_rate": signature_successes / len(samples),
            "median_unit_volume_shape_error": median_shape_error,
            "ensemble_mean_unit_volume_shape_error": ensemble_shape_error,
            "maximum_unit_volume_shape_error": maximum_shape_error,
        }

    selected_key, selected_score = min(
        scores.items(),
        key=lambda item: (
            -float(item[1]["signature_success_rate"]),
            float(item[1]["median_unit_volume_shape_error"]),
            float(item[1]["ensemble_mean_unit_volume_shape_error"]),
            float(item[1]["maximum_unit_volume_shape_error"]),
            item[0],
        ),
    )
    representative = grouped[selected_key][0]
    selected = {
        "key": selected_key,
        "nonlocality_multiplier": float(representative["nonlocality_multiplier"]),
        "support_multiplier": float(representative["support_multiplier"]),
        "averaging_multiplier": float(representative["averaging_multiplier"]),
        "selection_data": "H = 0 samples from the frozen A23 development artifact",
        "score": selected_score,
    }
    return selected, scores


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    development = json.loads(args.selection_input.read_text(encoding="utf-8"))
    selected, scores = select_flat_shape_setting(development["samples"])
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
        "conditional flat-shape-selected operator/count fusion; not reconstruction"
    )
    result["stage"] = "A26"
    result["selection_protocol"] = {
        "input": str(args.selection_input),
        "curved_samples_used_for_selection": False,
        "target_metric_used_after_selection": False,
        "selected_setting": selected,
        "flat_candidate_scores": scores,
    }
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--selection-input", type=Path, required=True)
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
    parser.add_argument("--seed", type=int, default=20261120)
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
