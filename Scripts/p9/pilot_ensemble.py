#!/usr/bin/env python3
"""Matched-ensemble wrapper for the finite P9 source-visibility pilot.

The single-run pilot is useful for sanity checks, but the P9 publication gate
needs matched flat/deformed families, seed spreads, and an explicit separation
rule. This script reuses `pilot.run_pilot` and writes an aggregate JSON report
for a size sweep.
"""

from __future__ import annotations

import argparse
import json
import statistics
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any

from pilot import PilotResult, run_pilot


@dataclass
class SeriesStats:
    count: int
    mean: float
    stdev: float
    minimum: float
    maximum: float


@dataclass
class FamilySummary:
    family: str
    cycle_size: int
    counts: dict[str, int]
    trace: SeriesStats
    trace_density: SeriesStats
    cond2: SeriesStats | None
    boundary_ok_count: int
    psd_ok_count: int
    coarse_by_block: dict[str, dict[str, SeriesStats | int]]


@dataclass
class MatchedComparison:
    cycle_size: int
    quantity: str
    flat_mean: float
    deformed_mean: float
    abs_delta: float
    within_family_spread: float
    separation_ratio: float | None
    passes_threshold: bool


def stats(values: list[float]) -> SeriesStats:
    if not values:
        raise ValueError("cannot summarize an empty value list")
    return SeriesStats(
        count=len(values),
        mean=float(statistics.fmean(values)),
        stdev=float(statistics.stdev(values)) if len(values) > 1 else 0.0,
        minimum=float(min(values)),
        maximum=float(max(values)),
    )


def finite_cond2(result: PilotResult) -> float | None:
    value = result.metrics["projected_noise_cond2"]
    return None if value is None else float(value)


def coarse_stats(results: list[PilotResult]) -> dict[str, dict[str, SeriesStats | int]]:
    blocks: dict[str, dict[str, list[float]]] = {}
    ok: dict[str, int] = {}
    for result in results:
        for item in result.metrics.get("coarse_projection", []):
            block = int(item["block_size"])
            offset = int(item.get("offset", 0))
            key = f"{block}@{offset}"
            blocks.setdefault(key, {"trace": [], "trace_density": [], "cond2": []})
            blocks[key]["trace"].append(float(item["trace"]))
            blocks[key]["trace_density"].append(float(item["trace_density"]))
            if item["cond2"] is not None:
                blocks[key]["cond2"].append(float(item["cond2"]))
            ok[key] = ok.get(key, 0) + int(bool(item["psd_ok"]))
    out: dict[str, dict[str, SeriesStats | int]] = {}
    for key, values in sorted(blocks.items()):
        out[key] = {
            "psd_ok_count": ok.get(key, 0),
            "trace": stats(values["trace"]),
            "trace_density": stats(values["trace_density"]),
        }
        if values["cond2"]:
            out[key]["cond2"] = stats(values["cond2"])
    return out


def summarize_family(family: str, cycle_size: int, results: list[PilotResult]) -> FamilySummary:
    traces = [float(r.metrics["projected_noise_trace"]) for r in results]
    edges = [int(r.counts["E"]) for r in results]
    densities = [trace / edge for trace, edge in zip(traces, edges, strict=True)]
    conds = [c for c in (finite_cond2(r) for r in results) if c is not None]
    return FamilySummary(
        family=family,
        cycle_size=cycle_size,
        counts=dict(results[0].counts),
        trace=stats(traces),
        trace_density=stats(densities),
        cond2=stats(conds) if conds else None,
        boundary_ok_count=sum(int(bool(r.checks["boundary_perturb_ok"])) for r in results),
        psd_ok_count=sum(int(bool(r.checks["projected_psd_ok"])) for r in results),
        coarse_by_block=coarse_stats(results),
    )


def compare(
    cycle_size: int,
    quantity: str,
    flat: SeriesStats,
    deformed: SeriesStats,
    abs_tol: float,
) -> MatchedComparison:
    spread = max(flat.stdev, deformed.stdev)
    delta = abs(deformed.mean - flat.mean)
    if spread <= abs_tol:
        ratio = None
        passes = delta > abs_tol
    else:
        ratio = delta / spread
        passes = ratio > 10.0
    return MatchedComparison(
        cycle_size=cycle_size,
        quantity=quantity,
        flat_mean=flat.mean,
        deformed_mean=deformed.mean,
        abs_delta=delta,
        within_family_spread=spread,
        separation_ratio=ratio,
        passes_threshold=passes,
    )


def run_family(
    geometry: str,
    metric_profile: str,
    cycle_size: int,
    seeds: list[int],
    expansion_rate: float,
    tol: float,
    coarse_block_sizes: list[int],
    coarse_offsets: list[int],
) -> list[PilotResult]:
    return [
        run_pilot(
            geometry,
            tol,
            seed,
            metric_profile,
            expansion_rate,
            cycle_size,
            coarse_block_sizes,
            coarse_offsets,
        )
        for seed in seeds
    ]


def parse_int_list(raw: str) -> list[int]:
    values = [int(part.strip()) for part in raw.split(",") if part.strip()]
    if not values:
        raise ValueError("expected at least one integer")
    return values


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--sizes", default="3,4,5,6,7,8")
    parser.add_argument("--seeds", default="0,1,2,3,4,5,6,7,8,9")
    parser.add_argument("--tol", type=float, default=1e-9)
    parser.add_argument("--abs-separation-tol", type=float, default=1e-6)
    parser.add_argument("--expansion-rate", type=float, default=0.35)
    parser.add_argument("--coarse-block-sizes", default="1,2,4")
    parser.add_argument("--coarse-offsets", default="0")
    parser.add_argument("--out", type=Path)
    args = parser.parse_args()

    sizes = parse_int_list(args.sizes)
    seeds = parse_int_list(args.seeds)
    coarse_block_sizes = parse_int_list(args.coarse_block_sizes)
    coarse_offsets = parse_int_list(args.coarse_offsets)

    summaries: list[dict[str, Any]] = []
    comparisons: list[dict[str, Any]] = []
    for size in sizes:
        flat_runs = run_family(
            "flat_diamond",
            "flat",
            size,
            seeds,
            args.expansion_rate,
            args.tol,
            coarse_block_sizes,
            coarse_offsets,
        )
        deformed_runs = run_family(
            "de_sitter_diamond",
            "expanded",
            size,
            seeds,
            args.expansion_rate,
            args.tol,
            coarse_block_sizes,
            coarse_offsets,
        )
        flat_summary = summarize_family("flat_diamond", size, flat_runs)
        deformed_summary = summarize_family("de_sitter_diamond", size, deformed_runs)
        summaries.extend([asdict(flat_summary), asdict(deformed_summary)])
        comparisons.append(
            asdict(
                compare(
                    size,
                    "projected_noise_trace_density",
                    flat_summary.trace_density,
                    deformed_summary.trace_density,
                    args.abs_separation_tol,
                )
            )
        )
        for block in sorted(flat_summary.coarse_by_block):
            flat_block = flat_summary.coarse_by_block[block].get("trace_density")
            deformed_block = deformed_summary.coarse_by_block.get(block, {}).get(
                "trace_density"
            )
            if isinstance(flat_block, SeriesStats) and isinstance(
                deformed_block, SeriesStats
            ):
                comparisons.append(
                    asdict(
                        compare(
                            size,
                            f"coarse_block_{block}_trace_density",
                            flat_block,
                            deformed_block,
                            args.abs_separation_tol,
                        )
                    )
                )

    payload = {
        "run_id": "p9-matched-diamond-ensemble",
        "purpose": (
            "Matched flat-vs-deformed P9 coarse readout pilot with seed spreads "
            "and a simple separation threshold."
        ),
        "parameters": {
            "sizes": sizes,
            "seeds": seeds,
            "tol": args.tol,
            "abs_separation_tol": args.abs_separation_tol,
            "expansion_rate": args.expansion_rate,
            "coarse_block_sizes": coarse_block_sizes,
            "coarse_offsets": coarse_offsets,
        },
        "family_summaries": summaries,
        "comparisons": comparisons,
        "any_threshold_pass": any(item["passes_threshold"] for item in comparisons),
        "all_boundary_regressions_pass": all(
            item["boundary_ok_count"] == len(seeds) for item in summaries
        ),
        "all_projected_psd_pass": all(
            item["psd_ok_count"] == len(seeds) for item in summaries
        ),
    }

    text = json.dumps(payload, indent=2, sort_keys=True)
    if args.out:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(text + "\n", encoding="utf-8")
    print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
