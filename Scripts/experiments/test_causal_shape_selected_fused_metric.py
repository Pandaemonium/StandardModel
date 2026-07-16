import numpy as np
import pytest

from causal_shape_selected_fused_metric import (
    select_flat_shape_setting,
    setting_key,
    unit_volume_shape,
)


def sample(
    hubble: float,
    metric: np.ndarray,
    nonlocality: float,
    support: float,
    averaging: float,
) -> dict[str, object]:
    return {
        "hubble": hubble,
        "metric": metric.tolist(),
        "nonlocality_multiplier": nonlocality,
        "support_multiplier": support,
        "averaging_multiplier": averaging,
    }


def test_unit_volume_shape_removes_positive_scalar() -> None:
    eta = np.diag([1.0, -1.0, -1.0, -1.0])
    assert np.allclose(unit_volume_shape(3.5 * eta), eta)


def test_unit_volume_shape_rejects_degenerate_metric() -> None:
    with pytest.raises(ValueError, match="nondegenerate"):
        unit_volume_shape(np.zeros((4, 4)))


def test_shape_selector_uses_only_flat_samples() -> None:
    eta = np.diag([1.0, -1.0, -1.0, -1.0])
    biased = np.diag([2.0, -0.7, -0.7, -0.7])
    samples = [
        sample(0.0, eta, 0.65, 1.2, 0.9),
        sample(0.0, biased, 0.65, 1.4, 0.9),
        sample(0.2, biased, 0.65, 1.2, 0.9),
        sample(0.2, eta, 0.65, 1.4, 0.9),
    ]
    selected, scores = select_flat_shape_setting(samples)
    assert selected["key"] == setting_key(samples[0])
    assert len(scores) == 2
    assert selected["score"]["median_unit_volume_shape_error"] == pytest.approx(0.0)


def test_shape_selector_penalizes_wrong_signature() -> None:
    eta = np.diag([1.0, -1.0, -1.0, -1.0])
    negative = -np.eye(4)
    samples = [
        sample(0.0, eta, 0.65, 1.2, 0.9),
        sample(0.0, negative, 0.55, 1.2, 0.9),
    ]
    selected, _ = select_flat_shape_setting(samples)
    assert selected["key"] == setting_key(samples[0])
