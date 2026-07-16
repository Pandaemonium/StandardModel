import pytest

from causal_regional_multigraph_development import (
    evaluate_development_gate,
    residual_realization,
)
from causal_regional_operator_covariance import (
    REGIONAL_FIELD_NAMES,
    covariance_ledger,
)


def checkpoint(scale: float, signature: list[int] | None = None) -> dict[str, object]:
    signature = signature or [1, 3, 0]
    records = []
    for index, value in enumerate((scale, -scale)):
        actual = {name: value for name in REGIONAL_FIELD_NAMES}
        target = {name: 0.0 for name in REGIONAL_FIELD_NAMES}
        records.append(
            {
                "pivot_index": index,
                "count_depth": 10,
                "actual_operator_values": actual,
                "target": {"operator_values": target},
                "actual_signature": signature,
            }
        )
    return {
        "target_gate": {"passes": True},
        "selection": {"depth_threshold": 10},
        "pivot_records": records,
        "regional_mean": {
            "metric_error": 0.1,
            "expanded_operator_error": 0.1,
            "actual_signature": signature,
        },
    }


def test_residual_realization_subtracts_per_pivot_targets() -> None:
    result = residual_realization(checkpoint(2.0))
    assert result.responses["constant"] == [2.0, -2.0]


def test_gate_retains_negative_cross_covariance() -> None:
    checkpoints = [checkpoint(1.0), checkpoint(1.0), checkpoint(1.0)]
    ledger = covariance_ledger(
        [residual_realization(item) for item in checkpoints]
    )
    gate = evaluate_development_gate(checkpoints, ledger)
    assert gate["maximum_covariance_decomposition_error"] < 1.0e-12
    assert not gate["passes"]
    assert gate["decision"] == "retain_backend_but_deprioritize_density_escalation"


def test_gate_stops_nonlorentzian_schedule() -> None:
    checkpoints = [checkpoint(1.0, [0, 4, 0]) for _ in range(3)]
    ledger = covariance_ledger(
        [residual_realization(item) for item in checkpoints]
    )
    gate = evaluate_development_gate(checkpoints, ledger)
    assert gate["decision"] == "stop_branch_n_at_this_schedule"


def test_residual_realization_requires_expected_fields() -> None:
    broken = checkpoint(1.0)
    del broken["pivot_records"][0]["actual_operator_values"]["constant"]
    with pytest.raises(KeyError):
        residual_realization(broken)
