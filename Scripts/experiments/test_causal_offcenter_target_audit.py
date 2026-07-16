from causal_offcenter_target_audit import (
    normalized_channel_shift,
    relative_metric_shift,
)
from causal_offcenter_continuum_targets import OffCenterMomentResult


def fixture(scale: float) -> OffCenterMomentResult:
    values = {
        "constant": scale,
        "affine_t": scale,
        "affine_x": 0.0,
        "affine_y": 0.0,
        "affine_z": 0.0,
        "quadratic_t_t": scale,
        "quadratic_t_x": 0.0,
        "quadratic_t_y": 0.0,
        "quadratic_t_z": 0.0,
        "quadratic_x_x": -scale,
        "quadratic_x_y": 0.0,
        "quadratic_x_z": 0.0,
        "quadratic_y_y": -scale,
        "quadratic_y_z": 0.0,
        "quadratic_z_z": -scale,
        "cubic_t_t_t": scale,
        "cubic_t_x_x": scale,
    }
    return OffCenterMomentResult(
        pivot=[1.0, 0.0, 0.0, 0.0],
        quadrature_orders=[1, 1, 1, 1],
        operator_values=values,
        metric=[
            [scale, 0.0, 0.0, 0.0],
            [0.0, -scale, 0.0, 0.0],
            [0.0, 0.0, -scale, 0.0],
            [0.0, 0.0, 0.0, -scale],
        ],
        metric_relative_error=0.0,
        signature=(1, 3, 0),
        maximum_affine_residual=scale,
    )


def test_zero_target_shift_is_exact() -> None:
    result = fixture(1.0)
    assert normalized_channel_shift(result, result) == 0.0
    assert relative_metric_shift(result, result) == 0.0


def test_target_shift_detects_rescaling() -> None:
    center = fixture(1.0)
    actual = fixture(1.1)
    assert normalized_channel_shift(actual, center) > 0.0
    assert relative_metric_shift(actual, center) > 0.0
