import numpy as np
import pytest

from causal_selected_pivot_target_calibration import (
    matrix_signature,
    metric_from_expanded,
    normalized_expanded_error,
    residual_mean_ledger,
)


def expanded_fixture(scale: float = 1.0) -> dict[str, float]:
    values = {"constant": 0.0}
    values.update({f"affine_{name}": 0.0 for name in "txyz"})
    for mu, left in enumerate("txyz"):
        for nu in range(mu, 4):
            right = "txyz"[nu]
            values[f"quadratic_{left}_{right}"] = (
                2.0 * scale if mu == nu == 0 else
                -2.0 * scale if mu == nu else 0.0
            )
    values["cubic_t_t_t"] = 0.0
    values["cubic_t_x_x"] = 0.0
    return values


def test_expanded_metric_recovers_lorentz_diagonal() -> None:
    metric = metric_from_expanded(expanded_fixture())
    assert np.array_equal(metric, np.diag([1.0, -1.0, -1.0, -1.0]))
    assert matrix_signature(metric) == (1, 3, 0)


def test_expanded_error_vanishes_on_equal_values() -> None:
    values = expanded_fixture()
    assert normalized_expanded_error(values, values) == 0.0


def test_residual_ledger_keeps_negative_cross_terms() -> None:
    ledger = residual_mean_ledger([1.0, -1.0])
    assert ledger["diagonal_contribution"] == pytest.approx(0.5)
    assert ledger["off_diagonal_contribution"] == pytest.approx(-0.5)
    assert ledger["regional_mean_squared"] == pytest.approx(0.0)
    assert ledger["decomposition_error"] < 1.0e-15
