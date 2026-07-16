"""Tests for Stage A18 overlapping metric/coframe patches."""

from __future__ import annotations

import unittest

import numpy as np

from causal_tetrad_bundle_atlas import (
    LocalFittedPatch,
    TransitionAudit,
    fit_transition,
    homogeneous_affine_matrix,
    orient_coframe_transitions,
    select_patch_triple,
)


def patch(
    pivot: int,
    carrier: np.ndarray,
    coordinates: np.ndarray,
    metric: np.ndarray | None = None,
    coframe: np.ndarray | None = None,
) -> LocalFittedPatch:
    """Construct the internal patch record used by transition tests."""

    count = len(coordinates)
    return LocalFittedPatch(
        pivot_index=pivot,
        center_distance=float(pivot),
        active_indices=np.array([pivot]),
        anchor_indices=np.arange(5),
        carrier_indices=carrier,
        consensus_coordinates=coordinates,
        chart_support=2 * np.ones(count, dtype=int),
        metric=np.eye(4) if metric is None else metric,
        coframe=np.eye(4) if coframe is None else coframe,
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


def transition(left: int, right: int, internal: np.ndarray) -> TransitionAudit:
    """Construct the transition fields needed by sign-gauge tests."""

    return TransitionAudit(
        source_patch=left,
        target_patch=right,
        overlap_count=10,
        training_count=7,
        heldout_count=3,
        affine_map=np.eye(5),
        affine_heldout_relative_error=0.0,
        affine_design_condition=1.0,
        metric_covariance_relative_error=0.0,
        lorentz_defect_relative_error=0.0,
        internal_transition=internal,
        oracle_affine_map_relative_error=0.0,
    )


class CausalTetradBundleAtlasTests(unittest.TestCase):
    def test_homogeneous_affine_matrices_compose_in_row_convention(self) -> None:
        first = np.vstack((1.2 * np.eye(4), np.array([0.1, 0.2, 0.3, 0.4])))
        second = np.vstack((0.8 * np.eye(4), np.array([-0.2, 0.1, 0.0, 0.3])))
        point = np.array([0.2, -0.1, 0.4, 0.7, 1.0])
        sequential = (
            point @ homogeneous_affine_matrix(first)
        ) @ homogeneous_affine_matrix(second)
        composed = point @ (
            homogeneous_affine_matrix(first)
            @ homogeneous_affine_matrix(second)
        )
        np.testing.assert_allclose(sequential, composed, atol=1.0e-12)

    def test_patch_triple_prioritizes_intrinsic_overlap(self) -> None:
        coordinates = np.zeros((30, 4))
        coordinates[:, 0] = np.linspace(0.0, 0.1, len(coordinates))
        patches = [
            patch(0, np.arange(0, 20), coordinates),
            patch(1, np.arange(2, 22), coordinates),
            patch(2, np.arange(4, 24), coordinates),
            patch(3, np.arange(20, 30), coordinates),
        ]
        indices, domains = select_patch_triple(patches, radius=1.0)
        self.assertEqual(indices, (0, 1, 2))
        self.assertEqual(len(set(domains[0]) & set(domains[1]) & set(domains[2])), 30)

    def test_exact_affine_transition_preserves_metric_and_coframe(self) -> None:
        rng = np.random.default_rng(9)
        source_coordinates = rng.normal(scale=0.1, size=(40, 4))
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
        target_metric = target_coframe @ eta @ target_coframe.T
        source = patch(
            5, np.arange(40), source_coordinates, eta, np.eye(4)
        )
        target = patch(
            6,
            np.arange(40),
            target_coordinates,
            target_metric,
            target_coframe,
        )
        audit = fit_transition(
            np.random.default_rng(2),
            0,
            1,
            source,
            target,
            np.arange(40),
            np.arange(40),
            source_coordinates,
            training_fraction=0.7,
        )
        self.assertLess(audit.affine_heldout_relative_error, 1.0e-12)
        self.assertLess(audit.metric_covariance_relative_error, 1.0e-12)
        self.assertLess(audit.lorentz_defect_relative_error, 1.0e-12)

    def test_sign_gauge_repairs_orientation_and_time_orientation(self) -> None:
        time_flip = np.diag([-1.0, -1.0, 1.0, 1.0])
        orientation_flip = np.diag([-1.0, 1.0, 1.0, 1.0])
        transitions = {
            (0, 1): transition(0, 1, time_flip),
            (0, 2): transition(0, 2, orientation_flip),
            (1, 2): transition(1, 2, time_flip @ orientation_flip),
        }
        success, determinant, time_component, _ = orient_coframe_transitions(
            transitions
        )
        self.assertTrue(success)
        self.assertGreater(determinant, 0.0)
        self.assertGreater(time_component, 0.0)


if __name__ == "__main__":
    unittest.main()
