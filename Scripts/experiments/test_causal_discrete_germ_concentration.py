import numpy as np

from causal_discrete_germ_concentration import (
    enrich_summaries,
    LOWER_ORDER_FIELDS,
    QUADRATIC_FIELDS,
    response_error,
)


def test_response_error_is_zero_on_declared_equal_subset() -> None:
    target = {
        "temporal_affine": 1.0,
        "temporal_quadratic": 2.0,
        "spatial_quadratic": -2.0,
        "temporal_cubic": 0.0,
        "temporal_spatial_cubic": 0.0,
    }
    assert response_error(target, target, QUADRATIC_FIELDS) == 0.0
    assert response_error(target, target, LOWER_ORDER_FIELDS) == 0.0


def test_response_error_uses_target_scale_floor() -> None:
    actual = {"temporal_quadratic": 3.0, "spatial_quadratic": -1.0}
    target = {"temporal_quadratic": 2.0, "spatial_quadratic": -2.0}
    assert np.isclose(response_error(actual, target, QUADRATIC_FIELDS), 0.5)


def test_enrichment_rejects_non_lorentzian_target() -> None:
    summary = {
        "mean_operator_values": {
            "constant": 0.0,
            "temporal_affine": 0.0,
            "temporal_quadratic": -1.0,
            "spatial_quadratic": -1.0,
            "temporal_cubic": 0.0,
            "temporal_spatial_cubic": 0.0,
        },
        "target_values": {
            "constant": 0.0,
            "temporal_affine": 0.0,
            "temporal_quadratic": -1.0,
            "spatial_quadratic": -1.0,
            "temporal_cubic": 0.0,
            "temporal_spatial_cubic": 0.0,
        },
        "target_metric_diagonal": [-0.5, -0.5, -0.5, -0.5],
        "events": 10_000,
    }
    enrich_summaries([summary], {})
    assert not summary["target_is_lorentzian"]
