"""Tests for exact buffered-core calibration and scale scheduling."""

from __future__ import annotations

import math
import unittest

from scipy.integrate import quad

from causal_buffered_core_feasibility import (
    ALEXANDROV_VOLUME_COEFFICIENT_4D,
    balanced_count_schedule,
    expected_protected_core_count,
    independent_coverage_baseline,
    outer_count_for_expected_core,
    outer_to_buffer_count_ratio_for_fraction,
    proper_time_from_volume_radius,
    protected_core_fraction_4d_from_z,
    schedule_at_density,
    shifted_subdiamond_lower_bound_count,
    volume_radius_from_proper_time,
)


class CausalBufferedCoreFeasibilityTests(unittest.TestCase):
    def test_volume_radius_and_proper_time_round_trip(self) -> None:
        self.assertAlmostEqual(
            ALEXANDROV_VOLUME_COEFFICIENT_4D,
            math.pi / 24.0,
        )
        self.assertAlmostEqual(volume_radius_from_proper_time(1.0), 0.6014986511033369)
        for proper_time in (0.0, 0.25, 1.0, 3.5):
            self.assertAlmostEqual(
                proper_time_from_volume_radius(
                    volume_radius_from_proper_time(proper_time)
                ),
                proper_time,
            )

    def test_closed_form_matches_direct_spatial_ball_quadrature(self) -> None:
        for z in (0.05, 0.2, 0.5, 0.8, 0.95):
            numerical = 4.0 * quad(
                lambda y: (y * y - z * z) ** 1.5,
                z,
                1.0,
                epsabs=1.0e-13,
                epsrel=1.0e-13,
            )[0]
            self.assertAlmostEqual(
                protected_core_fraction_4d_from_z(z),
                numerical,
                places=11,
            )

    def test_core_fraction_boundaries_and_monotonicity(self) -> None:
        self.assertEqual(protected_core_fraction_4d_from_z(0.0), 1.0)
        self.assertEqual(protected_core_fraction_4d_from_z(1.0), 0.0)
        self.assertEqual(protected_core_fraction_4d_from_z(2.0), 0.0)
        values = [
            protected_core_fraction_4d_from_z(z)
            for z in (0.1, 0.3, 0.5, 0.7, 0.9)
        ]
        self.assertTrue(all(left > right for left, right in zip(values, values[1:])))

    def test_exact_outer_count_inversion(self) -> None:
        expected = {
            4.0: 320.21972435506825,
            8.0: 468.9770480496462,
            16.0: 721.3136777895766,
            32.0: 1160.748291746791,
        }
        for buffer_count, target_outer in expected.items():
            outer = outer_count_for_expected_core(buffer_count, 64.0)
            self.assertAlmostEqual(outer, target_outer, places=9)
            self.assertAlmostEqual(
                expected_protected_core_count(outer, buffer_count),
                64.0,
                places=10,
            )

    def test_shifted_subdiamond_is_not_the_full_core(self) -> None:
        outer_count = (2.0 * 4.0**0.25 + 64.0**0.25) ** 4
        self.assertAlmostEqual(
            shifted_subdiamond_lower_bound_count(outer_count, 4.0),
            64.0,
        )
        self.assertAlmostEqual(
            expected_protected_core_count(outer_count, 4.0),
            458.9817131580071,
        )

    def test_a3e_global_core_fraction_correction(self) -> None:
        ell = 0.10219728214404318
        local_volume_radius = 0.18
        fractions = []
        for buffer_ratio in (24.0, 32.0):
            buffer_count = buffer_ratio * (local_volume_radius / ell) ** 4
            fractions.append(
                expected_protected_core_count(9600.0, buffer_count) / 9600.0
            )
        self.assertAlmostEqual(fractions[0], 0.07545154938628768)
        self.assertAlmostEqual(fractions[1], 0.03579953132787217)

    def test_fraction_inversion(self) -> None:
        expected_ratios = {
            0.8: 2905.903708632881,
            0.5: 333.46553467225175,
            0.25: 101.10516475979846,
            0.1: 48.13596134287833,
            0.01: 23.310429061058,
        }
        for fraction, expected_ratio in expected_ratios.items():
            ratio = outer_to_buffer_count_ratio_for_fraction(fraction)
            self.assertAlmostEqual(ratio, expected_ratio, places=9)
            z = 2.0 / ratio**0.25
            self.assertAlmostEqual(
                protected_core_fraction_4d_from_z(z), fraction, places=12
            )

    def test_balanced_count_exponents_under_density_doubling(self) -> None:
        lower = schedule_at_density(4800.0)
        upper = schedule_at_density(9600.0)
        self.assertAlmostEqual(upper.outer_count / lower.outer_count, 2.0**0.75)
        self.assertAlmostEqual(upper.buffer_count / lower.buffer_count, 2.0**0.5)
        self.assertAlmostEqual(upper.local_count / lower.local_count, 2.0**0.25)
        self.assertGreater(
            upper.local_to_discreteness_radius,
            lower.local_to_discreteness_radius,
        )
        self.assertGreater(
            upper.buffer_to_local_radius,
            lower.buffer_to_local_radius,
        )
        self.assertGreater(
            upper.outer_to_buffer_radius,
            lower.outer_to_buffer_radius,
        )

    def test_reference_schedule(self) -> None:
        schedule = balanced_count_schedule(8192.0)
        self.assertAlmostEqual(schedule.buffer_count, 32.0)
        self.assertAlmostEqual(schedule.local_count, math.sqrt(32.0))
        self.assertAlmostEqual(schedule.outer_to_buffer_radius, 4.0)
        self.assertAlmostEqual(schedule.protected_core_fraction, 0.4482243292558662)

    def test_independent_coverage_baseline(self) -> None:
        covered, repeated = independent_coverage_baseline(0.1, 16)
        self.assertAlmostEqual(covered, 1.0 - 0.9**16)
        exactly_one = 16.0 * 0.1 * 0.9**15
        self.assertAlmostEqual(repeated, (covered - exactly_one) / covered)

    def test_invalid_inputs_fail_loudly(self) -> None:
        with self.assertRaises(ValueError):
            volume_radius_from_proper_time(-1.0)
        with self.assertRaises(ValueError):
            expected_protected_core_count(0.0, 1.0)
        with self.assertRaises(ValueError):
            outer_count_for_expected_core(1.0, 0.0)
        with self.assertRaises(ValueError):
            outer_to_buffer_count_ratio_for_fraction(1.0)
        with self.assertRaises(ValueError):
            independent_coverage_baseline(0.5, 0)


if __name__ == "__main__":
    unittest.main()
