from causal_regional_scaling_gate import (
    evaluate_scaling_gate,
    predicted_from_baseline,
)


def test_prediction_separates_size_and_pivot_factors() -> None:
    baseline = {
        "total_points": 100,
        "selected_pivots": 8,
        "build_seconds": 2.0,
        "response_seconds": 0.5,
    }
    prediction = predicted_from_baseline(baseline, 200, 16)
    assert prediction["build_seconds"] == 8.0
    assert prediction["response_seconds"] == 4.0


def test_scaling_gate_passes_without_authorizing_physics() -> None:
    result = {
        "cache_storage_bytes": 100,
        "cache_file_bytes": 100,
        "expected_cache_bytes": 100,
        "selected_pivots": 16,
        "all_responses_finite": True,
        "build_seconds": 10.0,
        "response_seconds": 2.0,
    }
    prediction = {"build_seconds": 5.0, "response_seconds": 1.0}
    extrapolation = {
        "packed_relation_bytes": 20_000_550_003,
        "projected_total_seconds": 6000.0,
    }
    gate = evaluate_scaling_gate(result, prediction, extrapolation, 1000)
    assert gate["resource_precondition_passes"]
    assert not gate["large_run_authorized"]
    assert not gate["physical_stage_authorized"]
