import numpy as np

from causal_support_tail_selected_fused_metric import select_support_tail_setting


def sample(
    metric: np.ndarray,
    support: float,
    rows: int,
    condition: float = 10.0,
) -> dict[str, object]:
    return {
        "hubble": 0.0,
        "metric": metric.tolist(),
        "nonlocality_multiplier": 0.7,
        "support_multiplier": support,
        "averaging_multiplier": 1.0,
        "row_count": rows,
        "design_condition": condition,
    }


def artifact(events: int, samples: list[dict[str, object]]) -> dict[str, object]:
    return {
        "settings": {"events": events, "maximum_rows": 100},
        "samples": samples,
    }


def test_tail_selector_rejects_low_support_outlier() -> None:
    eta = np.diag([1.0, -1.0, -1.0, -1.0])
    mild = np.diag([1.2, -0.93, -0.93, -0.93])
    severe = np.diag([2.5, -0.6, -0.6, -0.6])
    density_one = artifact(
        1000,
        [
            sample(eta, 1.2, 40),
            sample(severe, 1.2, 40),
            sample(mild, 1.8, 90),
            sample(mild, 1.8, 90),
        ],
    )
    density_two = artifact(
        2000,
        [
            sample(eta, 1.2, 50),
            sample(severe, 1.2, 50),
            sample(mild, 1.8, 95),
            sample(mild, 1.8, 95),
        ],
    )
    selected, scores = select_support_tail_setting([density_one, density_two])
    assert selected["support_multiplier"] == 1.8
    assert selected["minimum_row_support_fraction"] == 0.9
    assert set(scores) == {"N=1000", "N=2000"}
