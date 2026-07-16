import numpy as np

from causal_multidensity_shape_selected_fused_metric import (
    select_multidensity_shape_setting,
)


def make_sample(
    metric: np.ndarray,
    nonlocality: float,
    averaging: float,
) -> dict[str, object]:
    return {
        "hubble": 0.0,
        "metric": metric.tolist(),
        "nonlocality_multiplier": nonlocality,
        "support_multiplier": 1.2,
        "averaging_multiplier": averaging,
    }


def artifact(events: int, samples: list[dict[str, object]]) -> dict[str, object]:
    return {"settings": {"events": events}, "samples": samples}


def test_multidensity_selector_uses_minimax_shape_error() -> None:
    eta = np.diag([1.0, -1.0, -1.0, -1.0])
    mild = np.diag([1.25, -0.9, -0.9, -0.9])
    severe = np.diag([2.0, -0.7, -0.7, -0.7])
    density_one = artifact(
        1000,
        [make_sample(eta, 0.6, 0.7), make_sample(mild, 0.6, 0.9)],
    )
    density_two = artifact(
        2000,
        [make_sample(mild, 0.6, 0.7), make_sample(severe, 0.6, 0.9)],
    )
    selected, scores = select_multidensity_shape_setting(
        [density_one, density_two]
    )
    assert selected["averaging_multiplier"] == 0.7
    assert set(scores) == {"N=1000", "N=2000"}
