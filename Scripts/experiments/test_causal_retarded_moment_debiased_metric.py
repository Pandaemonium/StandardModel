import numpy as np
import pytest

from causal_retarded_moment_debiased_metric import (
    retarded_time_response_correction,
    retarded_time_response_correction_with_jet,
    select_temporal_response_weight,
)


def test_retarded_time_response_correction_is_affine_covariant() -> None:
    metric = np.diag([2.0, -0.8, -0.9, -1.1])
    moment = np.array([-0.3, 0.02, -0.01, 0.01])
    linear = np.array(
        [
            [1.1, 0.1, 0.0, 0.0],
            [0.2, 0.9, 0.1, 0.0],
            [0.0, 0.1, 1.2, 0.1],
            [0.0, 0.0, 0.1, 0.8],
        ]
    )
    corrected, norm = retarded_time_response_correction(metric, moment, 0.6)
    transformed, transformed_norm = retarded_time_response_correction(
        linear @ metric @ linear.T,
        linear @ moment,
        0.6,
    )
    np.testing.assert_allclose(transformed, linear @ corrected @ linear.T)
    assert transformed_norm == pytest.approx(norm)


def test_unit_weight_leaves_metric_unchanged() -> None:
    metric = np.diag([2.0, -1.0, -1.0, -1.0])
    corrected, _ = retarded_time_response_correction(
        metric, np.array([-0.3, 0.0, 0.0, 0.0]), 1.0
    )
    np.testing.assert_allclose(corrected, metric)


def test_spacelike_moment_is_rejected() -> None:
    with pytest.raises(ValueError, match="timelike"):
        retarded_time_response_correction(
            np.diag([1.0, -1.0, -1.0, -1.0]),
            np.array([0.0, 1.0, 0.0, 0.0]),
            0.6,
        )


def test_response_first_jet_matches_finite_difference() -> None:
    metric = np.diag([2.0, -0.8, -0.9, -1.1])
    metric_jet = np.zeros((4, 4, 4))
    metric_jet[0] = np.diag([0.2, -0.1, -0.05, -0.08])
    moment = np.array([-0.3, 0.02, -0.01, 0.01])
    moment_jet = np.zeros((4, 4))
    moment_jet[0] = np.array([-0.04, 0.01, 0.0, -0.005])
    _, corrected_jet, _ = retarded_time_response_correction_with_jet(
        metric, metric_jet, moment, moment_jet, 0.6
    )
    step = 1.0e-6
    plus, _ = retarded_time_response_correction(
        metric + step * metric_jet[0],
        moment + step * moment_jet[0],
        0.6,
    )
    minus, _ = retarded_time_response_correction(
        metric - step * metric_jet[0],
        moment - step * moment_jet[0],
        0.6,
    )
    np.testing.assert_allclose(
        corrected_jet[0], (plus - minus) / (2.0 * step), rtol=1.0e-8
    )


def test_flat_tail_selector_prefers_balanced_response() -> None:
    moment = [-0.3, 0.0, 0.0, 0.0]
    samples = [
        {
            "hubble": 0.0,
            "metric": np.diag([2.0, -1.0, -1.0, -1.0]).tolist(),
            "retarded_moment": moment,
        }
    ]
    artifacts = [
        {"settings": {"events": 1000}, "samples": samples},
        {"settings": {"events": 2000}, "samples": samples},
    ]
    selected, _ = select_temporal_response_weight(artifacts, [0.5, 0.75, 1.0])
    assert selected == 0.5
