"""Tests for the Stage A16 chart-consensus tetrad selector."""

from __future__ import annotations

import unittest

import numpy as np

from causal_johnston_probe_metric import JohnstonLightconeEmbedding
from causal_trilateration_tetrad_selector import (
    chart_transition_error,
    common_bracketing_pools,
    oracle_active_reconstruction_error,
    select_consensus_frame,
    temporal_shell_candidates,
)


def synthetic_chart(probes: np.ndarray, pivot_index: int = 5) -> JohnstonLightconeEmbedding:
    """Build the minimal lightcone-chart record needed by selector tests."""

    return JohnstonLightconeEmbedding(
        probes=probes,
        embedded_mask=np.ones(len(probes), dtype=bool),
        intrinsic_time=probes[:, 0],
        intrinsic_radius=np.zeros(len(probes)),
        spatial_singular_values=np.ones(4),
        spatial_rank_gap=1.0,
        dominant_spatial_gap_rank=3,
        pivot_index=pivot_index,
        past_count=1,
        future_count=4,
        scale_balance_residual=0.0,
    )


class CausalTrilaterationTetradSelectorTests(unittest.TestCase):
    def test_common_bracketing_pools_require_every_active_event(self) -> None:
        relation = np.zeros((7, 7), dtype=bool)
        active = np.array([2, 3])
        relation[0, active] = True
        relation[1, 2] = True
        relation[active, 5] = True
        relation[2, 6] = True
        relation[0, 2] = True
        relation[0, 3] = True
        lower, upper = common_bracketing_pools(relation, 2, active)
        np.testing.assert_array_equal(lower, np.array([0]))
        np.testing.assert_array_equal(upper, np.array([5]))

    def test_temporal_shell_is_stably_capped(self) -> None:
        probes = np.zeros((5, 4))
        probes[:, 0] = np.array([0.41, 0.39, 0.42, 0.38, 0.9])
        candidates = np.arange(5)
        selected = temporal_shell_candidates(
            probes,
            candidates,
            target_time=0.4,
            relative_width=0.1,
            maximum_count=3,
        )
        np.testing.assert_array_equal(selected, np.array([0, 1, 2]))

    def test_consensus_selector_finds_full_rank_scaffold(self) -> None:
        probes = np.array(
            [
                [-0.4, 0.0, 0.0, 0.0],
                [0.4, 0.0, 0.0, 0.0],
                [0.4, 0.1, 0.0, 0.0],
                [0.4, 0.0, 0.1, 0.0],
                [0.4, 0.0, 0.0, 0.1],
                [0.0, 0.0, 0.0, 0.0],
            ]
        )
        rotation = np.array(
            [
                [1.0, 0.0, 0.0, 0.0],
                [0.0, 0.0, 1.0, 0.0],
                [0.0, -1.0, 0.0, 0.0],
                [0.0, 0.0, 0.0, 1.0],
            ]
        )
        charts = [synthetic_chart(probes), synthetic_chart(probes @ rotation)]
        selected = select_consensus_frame(
            charts,
            lower_candidates=np.array([0]),
            upper_candidates=np.array([1, 2, 3, 4]),
            anchor_time=0.4,
        )
        self.assertEqual(selected.anchor_indices, [0, 1, 2, 3, 4])
        self.assertGreater(selected.normalized_minimum_singular_value, 0.0)
        self.assertLess(selected.maximum_frame_condition, 50.0)

    def test_affinely_related_charts_have_zero_control_errors(self) -> None:
        probes = np.array(
            [
                [-0.4, 0.0, 0.0, 0.0],
                [0.4, 0.0, 0.0, 0.0],
                [0.4, 0.1, 0.0, 0.0],
                [0.4, 0.0, 0.1, 0.0],
                [0.4, 0.0, 0.0, 0.1],
                [0.0, 0.01, 0.02, 0.03],
                [0.05, -0.02, 0.01, 0.04],
                [-0.05, 0.03, -0.02, 0.01],
                [0.02, 0.02, 0.01, -0.03],
            ]
        )
        transform = np.array(
            [
                [1.0, 0.0, 0.0, 0.0],
                [0.0, 0.0, 1.0, 0.0],
                [0.0, -1.0, 0.0, 0.0],
                [0.0, 0.0, 0.0, 1.0],
            ]
        )
        moved = probes @ transform + np.array([0.2, -0.1, 0.3, 0.4])
        charts = [synthetic_chart(probes), synthetic_chart(moved)]
        anchors = np.arange(5)
        evaluation = np.arange(5, 9)
        transition = chart_transition_error(charts, anchors, evaluation)
        self.assertLess(transition, 1.0e-12)

        points = probes @ np.diag([1.1, 0.9, 1.2, 0.8])
        reconstruction = oracle_active_reconstruction_error(
            points,
            [synthetic_chart(probes)],
            anchors,
            evaluation,
            pivot_index=5,
        )
        self.assertLess(reconstruction, 1.0e-12)


if __name__ == "__main__":
    unittest.main()
