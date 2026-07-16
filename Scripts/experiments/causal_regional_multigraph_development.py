"""Stage A44N fresh multi-graph regional covariance development gate."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np

from causal_regional_operator_covariance import (
    REGIONAL_FIELD_NAMES,
    RegionalRealization,
    covariance_ledger,
)
from causal_selected_pivot_target_calibration import calibrate_selected_graph


FRESH_SEEDS = (20261560, 20261561, 20261562)
OUTPUT_PATTERN = (
    "AgentTasks/causal-regional-multigraph-stage-a44n-development-"
    "seed-{seed}-2026-07-15.json"
)
AGGREGATE_OUTPUT = Path(
    "AgentTasks/causal-regional-multigraph-stage-a44n-development-2026-07-15.json"
)
METRIC_DIAGONAL_FIELDS = (
    "quadratic_t_t",
    "quadratic_x_x",
    "quadratic_y_y",
    "quadratic_z_z",
)


def checkpoint_path(seed: int) -> Path:
    return Path(OUTPUT_PATTERN.format(seed=seed))


def run_checkpoint(seed: int) -> dict[str, object]:
    if seed not in FRESH_SEEDS:
        raise ValueError("A44N seed is not preregistered")
    artifact = calibrate_selected_graph(
        seed,
        events=100000,
        minimum_pivots=16,
        stage="A44N-development-checkpoint",
        claim_boundary="one fresh development graph; not concentration",
    )
    path = checkpoint_path(seed)
    path.write_text(
        json.dumps(artifact, indent=2, sort_keys=True, allow_nan=False) + "\n",
        encoding="utf-8",
    )
    return artifact


def load_checkpoints() -> list[dict[str, object]]:
    checkpoints: list[dict[str, object]] = []
    for seed in FRESH_SEEDS:
        path = checkpoint_path(seed)
        if not path.exists():
            raise FileNotFoundError(f"missing preregistered checkpoint: {path}")
        artifact = json.loads(path.read_text(encoding="utf-8"))
        if artifact.get("stage") != "A44N-development-checkpoint":
            raise ValueError(f"wrong checkpoint stage in {path}")
        if artifact["settings"]["seed"] != seed:
            raise ValueError(f"wrong checkpoint seed in {path}")
        if not artifact["target_gate"]["passes"]:
            raise ValueError(f"target gate failed in {path}")
        checkpoints.append(artifact)
    return checkpoints


def residual_realization(checkpoint: dict[str, object]) -> RegionalRealization:
    records = checkpoint["pivot_records"]
    responses = {
        name: [
            record["actual_operator_values"][name]
            - record["target"]["operator_values"][name]
            for record in records
        ]
        for name in REGIONAL_FIELD_NAMES
    }
    return RegionalRealization(
        pivot_indices=[record["pivot_index"] for record in records],
        pivot_depths=[record["count_depth"] for record in records],
        depth_threshold=checkpoint["selection"]["depth_threshold"],
        responses=responses,
    )


def evaluate_development_gate(
    checkpoints: list[dict[str, object]], ledger: dict[str, object]
) -> dict[str, object]:
    metric_errors = np.array(
        [item["regional_mean"]["metric_error"] for item in checkpoints]
    )
    operator_errors = np.array(
        [
            item["regional_mean"]["expanded_operator_error"]
            for item in checkpoints
        ]
    )
    signatures = [
        tuple(item["regional_mean"]["actual_signature"])
        for item in checkpoints
    ]
    pivot_records = [
        record for item in checkpoints for record in item["pivot_records"]
    ]
    individual_signature_rate = float(
        np.mean(
            [tuple(record["actual_signature"]) == (1, 3, 0) for record in pivot_records]
        )
    )
    decomposition_max = max(
        field["decomposition_error"] for field in ledger["fields"].values()
    )
    effective_counts = [
        ledger["fields"][name]["effective_pivot_count"]
        for name in METRIC_DIAGONAL_FIELDS
    ]
    finite_effective_counts = [
        float(value) for value in effective_counts if value is not None
    ]
    effective_count_check = (
        len(finite_effective_counts) == len(METRIC_DIAGONAL_FIELDS)
        and min(finite_effective_counts) >= 3.0
        and float(np.median(finite_effective_counts)) >= 4.0
    )
    checks = {
        "all_target_gates": all(item["target_gate"]["passes"] for item in checkpoints),
        "regional_signatures": all(signature == (1, 3, 0) for signature in signatures),
        "individual_signature_rate": individual_signature_rate >= 0.75,
        "median_metric_error": float(np.median(metric_errors)) < 0.50,
        "maximum_metric_error": float(np.max(metric_errors)) < 0.75,
        "median_operator_error": float(np.median(operator_errors)) < 1.25,
        "maximum_operator_error": float(np.max(operator_errors)) < 2.0,
        "covariance_decomposition": decomposition_max < 1.0e-12,
        "effective_pivot_count": effective_count_check,
    }
    if all(checks.values()):
        decision = "retain_branch_n_and_preregister_n200000_development"
    elif checks["regional_signatures"]:
        decision = "retain_backend_but_deprioritize_density_escalation"
    else:
        decision = "stop_branch_n_at_this_schedule"
    return {
        "checks": checks,
        "passes": all(checks.values()),
        "decision": decision,
        "metric_errors": metric_errors.tolist(),
        "operator_errors": operator_errors.tolist(),
        "individual_signature_rate": individual_signature_rate,
        "maximum_covariance_decomposition_error": decomposition_max,
        "metric_diagonal_effective_pivot_counts": dict(
            zip(METRIC_DIAGONAL_FIELDS, effective_counts, strict=True)
        ),
    }


def aggregate_checkpoints(
    checkpoints: list[dict[str, object]],
) -> dict[str, object]:
    if len(checkpoints) != len(FRESH_SEEDS):
        raise ValueError("aggregation requires every fresh checkpoint")
    realizations = [residual_realization(item) for item in checkpoints]
    ledger = covariance_ledger(realizations)
    gate = evaluate_development_gate(checkpoints, ledger)
    return {
        "stage": "A44N-development",
        "claim_boundary": "three fresh development graphs; not held-out concentration",
        "settings": {
            "seeds": list(FRESH_SEEDS),
            "events": 100000,
            "minimum_pivots": 16,
            "nonlocality_ratio": 0.20,
            "profile": {"name": "primary", "depth_zero": 0.02, "depth_one": 0.08},
        },
        "graph_summaries": [
            {
                "seed": item["settings"]["seed"],
                "pivot_count": item["selection"]["pivot_count"],
                "metric_error": item["regional_mean"]["metric_error"],
                "operator_error": item["regional_mean"]["expanded_operator_error"],
                "actual_signature": item["regional_mean"]["actual_signature"],
                "resource": item["resource"],
            }
            for item in checkpoints
        ],
        "residual_covariance_ledger": ledger,
        "gate": gate,
        "heldout_opened": False,
        "n400000_authorized": False,
        "physical_pass_claimed": False,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--seed", type=int, choices=FRESH_SEEDS)
    group.add_argument("--aggregate", action="store_true")
    args = parser.parse_args()
    if args.seed is not None:
        artifact = run_checkpoint(args.seed)
        print(
            json.dumps(
                {
                    "output": str(checkpoint_path(args.seed)),
                    "seed": args.seed,
                    "target_gate_passes": artifact["target_gate"]["passes"],
                    "metric_error": artifact["regional_mean"]["metric_error"],
                    "physical_pass_claimed": False,
                }
            )
        )
        return
    checkpoints = load_checkpoints()
    artifact = aggregate_checkpoints(checkpoints)
    AGGREGATE_OUTPUT.write_text(
        json.dumps(artifact, indent=2, sort_keys=True, allow_nan=False) + "\n",
        encoding="utf-8",
    )
    print(
        json.dumps(
            {
                "output": str(AGGREGATE_OUTPUT),
                "passes": artifact["gate"]["passes"],
                "decision": artifact["gate"]["decision"],
                "physical_pass_claimed": False,
            }
        )
    )


if __name__ == "__main__":
    main()
