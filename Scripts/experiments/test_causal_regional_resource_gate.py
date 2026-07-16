from causal_regional_resource_gate import evaluate_gate, quadratic_extrapolation


def measured_fixture(events: int = 20003, pivots: int = 8) -> dict[str, object]:
    return {
        "total_points": events,
        "selected_pivots": pivots,
        "build_seconds": 10.0,
        "response_seconds": 2.0,
        "direct_count_match": True,
        "cache_storage_bytes": events * ((events + 7) // 8),
        "cache_file_bytes": events * ((events + 7) // 8),
        "expected_cache_bytes": events * ((events + 7) // 8),
        "all_responses_finite": True,
    }


def test_quadratic_extrapolation_scales_pivots_separately() -> None:
    measured = measured_fixture(events=100, pivots=4)
    projected = quadratic_extrapolation(measured, 197, 8)
    assert projected["target_total_points"] == 200
    assert projected["projected_build_seconds"] == 40.0
    assert projected["projected_response_seconds"] == 16.0
    assert projected["projected_total_seconds"] == 56.0


def test_gate_never_authorizes_large_run() -> None:
    measured = measured_fixture()
    projected = quadratic_extrapolation(measured, 400000, 256)
    gate = evaluate_gate([measured, measured, measured], projected, 10_000_000)
    assert gate["prototype_passes"]
    assert not gate["large_run_authorized"]
    assert len(gate["authorization_blockers"]) == 3
