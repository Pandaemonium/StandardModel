"""Stage A34 spread-row mesoscopic selection for nonlinear chart shape jets.

A33 shows that the nearest-row affine fit cannot distinguish exact nonzero
quadratic-chart shape jets from noise.  Once the row cap saturates, increasing
the nominal averaging radius does not increase the derivative baseline because
the predecessor selector keeps only the nearest rows.  A34 replaces that cap
behavior by deterministic farthest-point sampling across the full averaging
ball and compares several averaging radii.

Selection remains entirely on flat zero, temporal, and shear chart controls at
two densities.  A viable setting must use a nonzero tangent weight and beat the
zero-response baseline; returning a zero derivative is not accepted.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict
from pathlib import Path

import numpy as np

from causal_operator_metric import finite_statistics
from causal_quadratic_chart_shape_jet import (
    QuadraticChartShapeSample,
    quadratic_chart_controls,
    reconstruct_chart_control_realization,
    tangent_weight_scores,
)


def select_nonzero_weight(scores: dict[str, dict[str, object]]) -> dict[str, object]:
    candidates = [
        summary
        for summary in scores.values()
        if float(summary["weight"]) > 0.0
    ]
    if not candidates:
        raise ValueError("at least one positive tangent weight is required")

    def score(summary: dict[str, object]) -> tuple[float, ...]:
        errors = summary["error"]
        assert isinstance(errors, dict)
        return (
            float(summary["worst_cell_median_normalized_error"]),
            float(summary["worst_cell_ensemble_normalized_error"]),
            float(errors["median"]),
            -float(summary["weight"]),
        )

    return min(candidates, key=score)


def summarize_setting(
    averaging_multiplier: float,
    samples: list[QuadraticChartShapeSample],
    weights: list[float],
    pivot_error_threshold: float,
) -> dict[str, object]:
    scores = tangent_weight_scores(samples, weights)
    zero = scores.get("w=0.000000")
    if zero is None:
        raise ValueError("the zero tangent baseline is required")
    selected = select_nonzero_weight(scores)
    cells = sorted({(sample.events, sample.chart_name) for sample in samples})
    pivot_cells: dict[str, dict[str, object]] = {}
    for events, chart_name in cells:
        matching = [
            sample
            for sample in samples
            if sample.events == events and sample.chart_name == chart_name
        ]
        pivot_cells[f"N={events}|chart={chart_name}"] = {
            "shape_relative_error": finite_statistics(
                [sample.shape_relative_error for sample in matching]
            ),
            "signature_success_rate": sum(
                sample.metric_signature == (1, 3, 0) for sample in matching
            )
            / len(matching),
            "row_count": finite_statistics(
                [float(sample.row_count) for sample in matching]
            ),
            "design_condition": finite_statistics(
                [sample.design_condition for sample in matching]
            ),
        }
    minimum_signature_rate = min(
        float(cell["signature_success_rate"]) for cell in pivot_cells.values()
    )
    worst_pivot_median = max(
        float(cell["shape_relative_error"]["median"])
        for cell in pivot_cells.values()
    )
    selected_median = float(selected["worst_cell_median_normalized_error"])
    selected_ensemble = float(selected["worst_cell_ensemble_normalized_error"])
    zero_median = float(zero["worst_cell_median_normalized_error"])
    zero_ensemble = float(zero["worst_cell_ensemble_normalized_error"])
    return {
        "averaging_multiplier": averaging_multiplier,
        "selected_nonzero_weight": float(selected["weight"]),
        "selected_worst_cell_median_normalized_error": selected_median,
        "selected_worst_cell_ensemble_normalized_error": selected_ensemble,
        "zero_baseline_worst_cell_median_normalized_error": zero_median,
        "zero_baseline_worst_cell_ensemble_normalized_error": zero_ensemble,
        "beats_zero_baseline": (
            selected_median < zero_median and selected_ensemble < zero_ensemble
        ),
        "minimum_signature_rate": minimum_signature_rate,
        "worst_pivot_median_shape_error": worst_pivot_median,
        "pivot_error_threshold": pivot_error_threshold,
        "pivot_tensor_pass": worst_pivot_median <= pivot_error_threshold,
        "candidate_scores": scores,
        "pivot_cells": pivot_cells,
    }


def select_spread_setting(
    summaries: dict[str, dict[str, object]],
) -> tuple[str, dict[str, object]]:
    def score(item: tuple[str, dict[str, object]]) -> tuple[float, ...]:
        summary = item[1]
        return (
            -float(bool(summary["beats_zero_baseline"])),
            -float(bool(summary["pivot_tensor_pass"])),
            -float(summary["minimum_signature_rate"]),
            float(summary["selected_worst_cell_median_normalized_error"]),
            float(summary["selected_worst_cell_ensemble_normalized_error"]),
            float(summary["worst_pivot_median_shape_error"]),
            float(summary["averaging_multiplier"]),
        )

    return min(summaries.items(), key=score)


def run_experiment(args: argparse.Namespace) -> dict[str, object]:
    if len(set(args.events_values)) < 2:
        raise ValueError("A34 requires at least two development densities")
    controls = quadratic_chart_controls()
    density_realizations = [
        (events, realization)
        for events in sorted(set(args.events_values))
        for realization in range(args.realizations)
    ]
    child_seeds = np.random.SeedSequence(args.seed).spawn(
        len(density_realizations)
    )
    setting_samples: dict[float, list[QuadraticChartShapeSample]] = {}
    for averaging_multiplier in sorted(set(args.averaging_multipliers)):
        samples: list[QuadraticChartShapeSample] = []
        for index, (events, _) in enumerate(density_realizations):
            maximum_rows = max(
                5, int(round(args.maximum_rows_factor * np.sqrt(events)))
            )
            samples.extend(
                reconstruct_chart_control_realization(
                    np.random.default_rng(child_seeds[index]),
                    events,
                    args.duration,
                    controls,
                    args.temporal_response_weight,
                    args.operator_nonlocality_multiplier,
                    args.operator_support_multiplier,
                    averaging_multiplier,
                    maximum_rows,
                    args.block_size,
                    args.pivot_fraction,
                    target_selection="spread",
                )
            )
        setting_samples[averaging_multiplier] = samples

    summaries = {
        f"cA={averaging_multiplier:.6f}": summarize_setting(
            averaging_multiplier,
            samples,
            args.tangent_weights,
            args.pivot_error_threshold,
        )
        for averaging_multiplier, samples in setting_samples.items()
    }
    selected_key, selected = select_spread_setting(summaries)
    result: dict[str, object] = {
        "status": "flat spread-row shape-jet selection; not connection",
        "stage": "A34",
        "mode": "development",
        "claim_boundary": {
            "all_backgrounds_are_flat": True,
            "zero_and_nonzero_exact_shape_jets_are_used": True,
            "two_density_selection_is_required": True,
            "nonzero_tangent_response_is_required": True,
            "spread_selection_uses_supplied_embedding_coordinates": True,
            "curved_targets_are_not_used": True,
        },
        "selected_setting": {
            "key": selected_key,
            "averaging_multiplier": selected["averaging_multiplier"],
            "tangent_weight": selected["selected_nonzero_weight"],
            "beats_zero_baseline": selected["beats_zero_baseline"],
            "pivot_tensor_pass": selected["pivot_tensor_pass"],
        },
        "setting_summaries": summaries,
        "settings": {
            "events_values": sorted(set(args.events_values)),
            "realizations_per_density": args.realizations,
            "duration": args.duration,
            "pivot_fraction": args.pivot_fraction,
            "temporal_response_weight": args.temporal_response_weight,
            "operator_nonlocality_multiplier": (
                args.operator_nonlocality_multiplier
            ),
            "operator_support_multiplier": args.operator_support_multiplier,
            "averaging_multipliers": sorted(set(args.averaging_multipliers)),
            "maximum_rows_factor": args.maximum_rows_factor,
            "pivot_error_threshold": args.pivot_error_threshold,
            "seed": args.seed,
        },
    }
    if args.include_samples:
        result["samples"] = {
            f"cA={averaging_multiplier:.6f}": [
                asdict(sample) for sample in samples
            ]
            for averaging_multiplier, samples in setting_samples.items()
        }
    return result


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--events-values", type=int, nargs="+", default=[4000, 8000])
    parser.add_argument("--realizations", type=int, default=5)
    parser.add_argument("--duration", type=float, default=1.0)
    parser.add_argument("--pivot-fraction", type=float, default=0.7)
    parser.add_argument("--temporal-response-weight", type=float, default=0.6)
    parser.add_argument("--operator-nonlocality-multiplier", type=float, default=0.75)
    parser.add_argument("--operator-support-multiplier", type=float, default=1.8)
    parser.add_argument(
        "--averaging-multipliers", type=float, nargs="+", default=[1.1, 1.4, 1.7, 1.9]
    )
    parser.add_argument("--maximum-rows-factor", type=float, default=4.0)
    parser.add_argument("--pivot-error-threshold", type=float, default=0.3)
    parser.add_argument("--block-size", type=int, default=256)
    parser.add_argument(
        "--tangent-weights",
        type=float,
        nargs="+",
        default=[0.0, 0.05, 0.1, 0.15, 0.2, 0.3, 0.4, 0.5, 0.6, 0.8, 1.0],
    )
    parser.add_argument("--seed", type=int, default=20261340)
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
