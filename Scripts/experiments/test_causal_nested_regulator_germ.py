"""Tests for the Stage A3e nested-regulator and inner-germ gate."""

from __future__ import annotations

import inspect
import unittest

import numpy as np
from scipy import sparse

from causal_adjacent_scale_availability import (
    sparse_inclusive_interval_count_matrix,
)
from causal_compact_bracket_carrier import CountBalancedBracket
from causal_nested_regulator_germ import (
    analytic_minimum_buffer_ratio,
    complete_minimum_excess_orbit,
    evaluate_mark_order,
    evaluate_outer_order,
    full_inner_intervals_preserve_counts,
    genuinely_nested,
    maximum_admitted_carrier_count,
    select_nested_minimum_orbits,
    spawn_realization_seed_states,
)


def transitive_closure(size: int, edges: list[tuple[int, int]]) -> np.ndarray:
    relation = np.zeros((size, size), dtype=bool)
    for left, right in edges:
        relation[left, right] = True
    for pivot in range(size):
        relation |= relation[:, pivot, None] & relation[None, pivot, :]
    return relation


def synthetic_nested_selector_data() -> tuple[np.ndarray, sparse.csr_matrix, int]:
    relation = transitive_closure(
        8,
        [
            (0, 1),
            (0, 2),
            (1, 3),
            (2, 3),
            (3, 5),
            (3, 6),
            (5, 7),
            (6, 7),
        ],
    )
    mark = 3
    counts = np.zeros((8, 8), dtype=np.int32)
    counts[0, mark] = 20
    counts[mark, 7] = 20
    counts[0, 7] = 320
    for past in (1, 2):
        counts[past, mark] = 10
        for future in (5, 6):
            counts[past, future] = 160
    for future in (5, 6):
        counts[mark, future] = 10
    return relation, sparse.csr_matrix(counts), mark


class NestedRegulatorGermTests(unittest.TestCase):
    def test_frozen_buffer_exceeds_analytic_minimum(self) -> None:
        ratio = analytic_minimum_buffer_ratio(
            0.10219728214404318,
            0.18,
            1.25,
        )
        self.assertAlmostEqual(ratio, 20.3537595771238)
        self.assertLess(ratio, 24.0)

    def test_refinement_carrier_arithmetic_threshold(self) -> None:
        maximum = maximum_admitted_carrier_count(
            9.62349080026453,
            32.0,
        )
        self.assertAlmostEqual(maximum, 9238.55116825395)
        self.assertLess(maximum, 9601)

    def test_complete_minimum_orbit_retains_every_exact_tie(self) -> None:
        brackets = [
            CountBalancedBracket(0, 5, 10, 10, 160, 1.0),
            CountBalancedBracket(1, 6, 10, 10, 160, 1.0),
            CountBalancedBracket(2, 7, 10, 10, 176, 1.1),
        ]
        retained = complete_minimum_excess_orbit(brackets)
        self.assertEqual(
            {(item.past_endpoint, item.future_endpoint) for item in retained},
            {(0, 5), (1, 6)},
        )

    def test_selector_retains_full_nested_minimum_orbits(self) -> None:
        relation, counts, mark = synthetic_nested_selector_data()
        tight, refinement, pairs = select_nested_minimum_orbits(
            relation,
            counts,
            mark,
            half_count_target=10.0,
            tight_buffer_ratio=1.0,
            refinement_buffer_ratio=2.0,
        )
        self.assertEqual(len(refinement), 1)
        self.assertEqual(len(tight), 4)
        self.assertEqual(len(pairs), 4)
        self.assertTrue(
            all(genuinely_nested(relation, item, refinement[0]) for item in tight)
        )

    def test_selector_is_exactly_relabeling_equivariant(self) -> None:
        relation, counts, mark = synthetic_nested_selector_data()
        tight, refinement, _ = select_nested_minimum_orbits(
            relation,
            counts,
            mark,
            10.0,
            1.0,
            2.0,
        )
        permutation = np.array([5, 0, 7, 2, 6, 3, 1, 4])
        inverse = np.argsort(permutation)
        relabeled_relation = relation[np.ix_(permutation, permutation)]
        relabeled_counts = counts.toarray()[np.ix_(permutation, permutation)]
        new_tight, new_refinement, _ = select_nested_minimum_orbits(
            relabeled_relation,
            sparse.csr_matrix(relabeled_counts),
            int(inverse[mark]),
            10.0,
            1.0,
            2.0,
        )
        pulled_tight = {
            (permutation[item.past_endpoint], permutation[item.future_endpoint])
            for item in new_tight
        }
        pulled_refinement = {
            (permutation[item.past_endpoint], permutation[item.future_endpoint])
            for item in new_refinement
        }
        self.assertEqual(
            pulled_tight,
            {(item.past_endpoint, item.future_endpoint) for item in tight},
        )
        self.assertEqual(
            pulled_refinement,
            {(item.past_endpoint, item.future_endpoint) for item in refinement},
        )

    def test_outer_source_closure_is_not_tautological(self) -> None:
        relation = transitive_closure(9, [(index, index + 1) for index in range(8)])
        counts = sparse_inclusive_interval_count_matrix(relation)
        bracket = CountBalancedBracket(0, 8, 1, 1, 8, 1.0)
        evaluation = evaluate_outer_order(
            relation,
            counts,
            mark=4,
            bracket=bracket,
            buffer_ratio=1.0,
            scales=(1.0, 1.0, 1.0),
            ell=1.0,
        )
        self.assertTrue(all(raw > 0 for raw in evaluation.raw_shell_counts))
        self.assertTrue(
            all(
                qualified <= raw
                for qualified, raw in zip(
                    evaluation.shell_counts,
                    evaluation.raw_shell_counts,
                    strict=True,
                )
            )
        )
        self.assertLess(min(evaluation.source_closure_rates), 1.0)

    def test_full_inner_intervals_preserve_counts_in_nonconvex_germ(self) -> None:
        relation = transitive_closure(
            7,
            [(0, 1), (1, 2), (2, 3), (3, 4), (4, 5), (5, 6)],
        )
        counts = sparse_inclusive_interval_count_matrix(relation)
        germ = np.array([False, True, True, False, True, True, False])
        self.assertTrue(full_inner_intervals_preserve_counts(relation, counts, germ))

    def test_seed_streams_are_separate_and_reproducible(self) -> None:
        first = spawn_realization_seed_states(2026071606, 3)
        second = spawn_realization_seed_states(2026071606, 3)
        self.assertEqual(first, second)
        self.assertTrue(all(sprinkle != marks for sprinkle, marks in first))
        self.assertEqual(len({pair for pair in first}), 3)

    def test_selector_apis_have_no_coordinate_argument(self) -> None:
        for function in (select_nested_minimum_orbits, evaluate_mark_order):
            parameters = inspect.signature(function).parameters
            self.assertNotIn("points", parameters)
            self.assertNotIn("coordinates", parameters)


if __name__ == "__main__":
    unittest.main()
