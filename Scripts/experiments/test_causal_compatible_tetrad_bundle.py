"""Tests for Stage A19 compatibility-selected tetrad bundles."""

from __future__ import annotations

import unittest

import numpy as np

from causal_compatible_tetrad_bundle import (
    TripleAudit,
    fit_three_way_transition,
    select_compatible_triple,
)
from causal_tetrad_bundle_atlas import LocalFittedPatch


def patch(
    pivot: int,
    coordinates: np.ndarray,
    metric: np.ndarray,
    coframe: np.ndarray,
) -> LocalFittedPatch:
    """Build a fully passing local patch for transition tests."""

    return LocalFittedPatch(
        pivot_index=pivot,
        center_distance=0.0,
        active_indices=np.array([pivot]),
        anchor_indices=np.arange(5),
        carrier_indices=np.arange(len(coordinates)),
        consensus_coordinates=coordinates,
        chart_support=2 * np.ones(len(coordinates), dtype=int),
        metric=metric,
        coframe=coframe,
        passes_intrinsic_patch_gate=True,
        chart_leave_one_out_error=0.0,
        chart_dispersion_error=0.0,
        heldout_interval_error=0.0,
        noncausal_violation_fraction=0.0,
        causal_sensitivity=1.0,
        causal_specificity=1.0,
        oracle_coordinate_error=0.0,
        oracle_metric_error=0.0,
    )


def triple(
    indices: tuple[int, int, int],
    selector_gate: bool,
    metric_error: float,
    test_error: float,
) -> TripleAudit:
    """Construct fields used by the pure triple selector."""

    return TripleAudit(
        indices=indices,
        domains=[np.arange(20), np.arange(20), np.arange(20)],
        transitions={},
        minimum_pair_overlap=20,
        triple_overlap_count=20,
        maximum_selector_affine_error=0.1,
        maximum_test_affine_error=test_error,
        maximum_design_condition=1.0,
        maximum_metric_error=metric_error,
        maximum_lorentz_defect=metric_error,
        affine_cocycle_error=0.1,
        lorentz_cocycle_error=0.1,
        orientation_exists=True,
        selector_gate=selector_gate,
    )


class CausalCompatibleTetradBundleTests(unittest.TestCase):
    def test_exact_transition_generalizes_to_selector_and_test_slices(self) -> None:
        rng = np.random.default_rng(44)
        source_coordinates = rng.normal(scale=0.1, size=(60, 4))
        source_coordinates[:5] = np.array(
            [
                [-0.4, 0.0, 0.0, 0.0],
                [0.4, 0.0, 0.0, 0.0],
                [0.4, 0.1, 0.0, 0.0],
                [0.4, 0.0, 0.1, 0.0],
                [0.4, 0.0, 0.0, 0.1],
            ]
        )
        linear = np.array(
            [
                [1.1, 0.1, 0.0, 0.0],
                [0.0, 0.9, 0.1, 0.0],
                [0.1, 0.0, 1.2, 0.1],
                [0.0, 0.1, 0.0, 0.8],
            ]
        )
        shift = np.array([0.2, -0.1, 0.3, 0.4])
        target_coordinates = source_coordinates @ linear + shift
        eta = np.diag([1.0, -1.0, -1.0, -1.0])
        target_coframe = np.linalg.inv(linear)
        source = patch(5, source_coordinates, eta, np.eye(4))
        target = patch(
            6,
            target_coordinates,
            target_coframe @ eta @ target_coframe.T,
            target_coframe,
        )
        audit = fit_three_way_transition(
            np.random.default_rng(3),
            0,
            1,
            source,
            target,
            np.arange(60),
            np.arange(60),
            source_coordinates,
            fit_fraction=0.6,
            selector_fraction=0.2,
        )
        self.assertEqual(audit.fit_count, 36)
        self.assertEqual(audit.selector_count, 12)
        self.assertEqual(audit.test_count, 12)
        self.assertLess(audit.selector_affine_relative_error, 1.0e-12)
        self.assertLess(audit.test_affine_relative_error, 1.0e-12)
        self.assertLess(audit.metric_covariance_relative_error, 1.0e-12)
        self.assertLess(audit.lorentz_defect_relative_error, 1.0e-12)

    def test_selector_never_uses_final_test_error(self) -> None:
        passing_with_bad_test = triple((0, 1, 2), True, 0.2, 9.0)
        failed_with_good_test = triple((0, 1, 3), False, 0.1, 0.0)
        selected = select_compatible_triple(
            [failed_with_good_test, passing_with_bad_test]
        )
        self.assertEqual(selected.indices, (0, 1, 2))

    def test_selector_breaks_gate_ties_by_metric_compatibility(self) -> None:
        worse = triple((0, 1, 2), True, 0.3, 0.0)
        better = triple((0, 1, 3), True, 0.2, 5.0)
        selected = select_compatible_triple([worse, better])
        self.assertEqual(selected.indices, (0, 1, 3))


if __name__ == "__main__":
    unittest.main()
