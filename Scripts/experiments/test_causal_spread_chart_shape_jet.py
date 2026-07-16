"""Tests for Stage A34 spread-row shape-jet selection."""

from __future__ import annotations

from causal_spread_chart_shape_jet import (
    select_nonzero_weight,
    select_spread_setting,
)


def test_nonzero_weight_selector_never_returns_zero() -> None:
    scores = {
        "w=0.000000": {
            "weight": 0.0,
            "worst_cell_median_normalized_error": 0.0,
            "worst_cell_ensemble_normalized_error": 0.0,
            "error": {"median": 0.0},
        },
        "w=0.100000": {
            "weight": 0.1,
            "worst_cell_median_normalized_error": 0.8,
            "worst_cell_ensemble_normalized_error": 0.7,
            "error": {"median": 0.6},
        },
    }
    assert select_nonzero_weight(scores)["weight"] == 0.1


def test_setting_selector_prefers_one_that_beats_zero() -> None:
    summaries = {
        "bad": {
            "beats_zero_baseline": False,
            "pivot_tensor_pass": True,
            "minimum_signature_rate": 1.0,
            "selected_worst_cell_median_normalized_error": 0.5,
            "selected_worst_cell_ensemble_normalized_error": 0.5,
            "worst_pivot_median_shape_error": 0.1,
            "averaging_multiplier": 1.1,
        },
        "good": {
            "beats_zero_baseline": True,
            "pivot_tensor_pass": True,
            "minimum_signature_rate": 0.9,
            "selected_worst_cell_median_normalized_error": 0.9,
            "selected_worst_cell_ensemble_normalized_error": 0.9,
            "worst_pivot_median_shape_error": 0.2,
            "averaging_multiplier": 1.4,
        },
    }
    key, _ = select_spread_setting(summaries)
    assert key == "good"


def test_setting_selector_preserves_pivot_gate_after_response_gate() -> None:
    summaries = {
        "bad_pivot": {
            "beats_zero_baseline": True,
            "pivot_tensor_pass": False,
            "minimum_signature_rate": 1.0,
            "selected_worst_cell_median_normalized_error": 0.7,
            "selected_worst_cell_ensemble_normalized_error": 0.7,
            "worst_pivot_median_shape_error": 0.31,
            "averaging_multiplier": 1.9,
        },
        "good_pivot": {
            "beats_zero_baseline": True,
            "pivot_tensor_pass": True,
            "minimum_signature_rate": 1.0,
            "selected_worst_cell_median_normalized_error": 0.8,
            "selected_worst_cell_ensemble_normalized_error": 0.8,
            "worst_pivot_median_shape_error": 0.29,
            "averaging_multiplier": 1.7,
        },
    }
    key, _ = select_spread_setting(summaries)
    assert key == "good_pivot"
