"""Tests for Stage A37 connection and count-scale convergence controls."""

from __future__ import annotations

import numpy as np

from causal_connection_convergence import (
    connection_response_decomposition,
    mapped_coordinate_window_count,
    select_flat_setting,
    select_spread_indices,
)
from causal_operator_metric import diamond_volume_4d, sprinkle_minkowski_diamond


def test_mapped_window_count_has_correct_flat_density_scale() -> None:
    rng = np.random.default_rng(370)
    events = 100_000
    duration = 1.0
    points, _ = sprinkle_minkowski_diamond(rng, events, duration)
    center = np.array([0.5, 0.0, 0.0, 0.0])
    half_duration = 0.16
    count = mapped_coordinate_window_count(points, center, half_duration)
    expected = events * diamond_volume_4d(2.0 * half_duration) / diamond_volume_4d(
        duration
    )
    assert abs(count - expected) / expected < 0.08


def test_spread_index_selector_reaches_across_candidate_cloud() -> None:
    coordinates = np.column_stack(
        (np.linspace(0.0, 1.0, 100), np.zeros((100, 3)))
    )
    selected = select_spread_indices(
        coordinates, np.arange(100), np.zeros(4), 8
    )
    assert len(selected) == 8
    assert np.max(coordinates[selected, 0]) > 0.9


def test_connection_response_decomposition_separates_amplitude_and_noise() -> None:
    target = np.zeros((4, 4, 4))
    target[0, 1, 1] = -1.5
    orthogonal = np.zeros_like(target)
    orthogonal[1, 0, 0] = 0.3
    amplitude, noise = connection_response_decomposition(
        0.4 * target + orthogonal, target
    )
    assert amplitude is not None and noise is not None
    np.testing.assert_allclose(amplitude, 0.4)
    np.testing.assert_allclose(noise, 0.2)


def test_setting_selector_prefers_complete_flat_gate() -> None:
    failed = {
        "flat_gate_pass": False,
        "signature_pass": True,
        "metric_pass": True,
        "nonzero_connection_pass": False,
        "nonzero_scale_pass": True,
        "worst_cell_median_connection_error": 0.2,
        "worst_cell_ensemble_connection_error": 0.2,
        "worst_cell_median_count_gradient_error": 0.2,
        "worst_cell_ensemble_count_gradient_error": 0.2,
    }
    passed = {
        "flat_gate_pass": True,
        "signature_pass": True,
        "metric_pass": True,
        "nonzero_connection_pass": True,
        "nonzero_scale_pass": True,
        "worst_cell_median_connection_error": 0.8,
        "worst_cell_ensemble_connection_error": 0.8,
        "worst_cell_median_count_gradient_error": 0.8,
        "worst_cell_ensemble_count_gradient_error": 0.8,
    }
    key, _ = select_flat_setting({"failed": failed, "passed": passed})
    assert key == "passed"
