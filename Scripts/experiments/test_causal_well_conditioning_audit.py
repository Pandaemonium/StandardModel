"""Tests for the Stage A15 order-volume-chain and scaffold audit."""

from __future__ import annotations

import unittest

import numpy as np

from causal_well_conditioning_audit import (
    ScaffoldAudit,
    audit_recovered_scaffold,
    ideal_scaffold_offsets,
    longest_chain_edge_length,
    select_scaffold_scale,
)


class CausalWellConditioningAuditTests(unittest.TestCase):
    def test_longest_chain_counts_edges_not_transitive_shortcut(self) -> None:
        relation = np.array(
            [
                [False, True, True, True],
                [False, False, True, True],
                [False, False, False, True],
                [False, False, False, False],
            ]
        )
        self.assertEqual(longest_chain_edge_length(relation, 0, 3), 3)

    def test_ideal_scaffold_is_well_conditioned(self) -> None:
        offsets = ideal_scaffold_offsets(0.04)
        frame = offsets[1:] - offsets[0]
        singular_values = np.linalg.svd(frame, compute_uv=False)
        self.assertEqual(np.linalg.matrix_rank(frame), 4)
        self.assertGreater(np.min(singular_values), 0.0)
        self.assertLess(np.linalg.cond(frame), 50.0)

    def test_exact_recovered_scaffold_passes(self) -> None:
        scale = 0.04
        ideal = ideal_scaffold_offsets(scale)
        coordinates = np.vstack((np.zeros(4), ideal))
        pivot = 0
        relation = np.zeros((len(coordinates), len(coordinates)), dtype=bool)
        lower = 1
        uppers = np.arange(2, 6)
        relation[lower, pivot] = True
        relation[lower, uppers] = True
        relation[pivot, uppers] = True
        audit = audit_recovered_scaffold(
            relation,
            coordinates,
            pivot,
            scale,
            maximum_normalized_proximity=1.0e-10,
            minimum_normalized_singular_value=0.1,
            maximum_frame_condition=50.0,
            minimum_active_count=1,
            minimum_active_coverage=1.0,
        )
        self.assertTrue(audit.passes_scaffold_gate)
        self.assertEqual(audit.active_count, 1)
        self.assertEqual(audit.anchor_indices, [1, 2, 3, 4, 5])

    def test_scaffold_selection_prioritizes_gate(self) -> None:
        summaries = {
            "close": {
                "sampled_well_conditioning_gate_success_rate": 0.0,
                "scaffold_gate_success_rate": 0.0,
                "scaffold_active_causal_coverage_fraction": {"median": 1.0},
                "scaffold_frame_condition": {"median": 2.0},
                "normalized_anchor_proximity_maximum": {"median": 0.1},
                "scaffold_scale": 0.03,
            },
            "gated": {
                "sampled_well_conditioning_gate_success_rate": 1.0,
                "scaffold_gate_success_rate": 1.0,
                "scaffold_active_causal_coverage_fraction": {"median": 0.95},
                "scaffold_frame_condition": {"median": 10.0},
                "normalized_anchor_proximity_maximum": {"median": 1.0},
                "scaffold_scale": 0.04,
            },
        }
        key, _ = select_scaffold_scale(summaries)
        self.assertEqual(key, "gated")

    def test_scaffold_audit_record_is_json_compatible(self) -> None:
        audit = ScaffoldAudit(
            scaffold_scale=0.04,
            pivot_index=1,
            active_count=10,
            anchor_indices=[1, 2, 3, 4, 5],
            normalized_proximity_maximum=0.5,
            normalized_frame_minimum_singular_value=1.0,
            frame_condition=2.0,
            lower_precedes_upper_anchors=True,
            active_causal_coverage_fraction=1.0,
            passes_scaffold_gate=True,
        )
        self.assertTrue(all(isinstance(index, int) for index in audit.anchor_indices))


if __name__ == "__main__":
    unittest.main()
