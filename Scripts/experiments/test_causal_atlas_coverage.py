"""Hostile controls for the corrected Stage A3f-R1 causal-atlas gate."""

from __future__ import annotations

import inspect
import unittest
from collections import Counter
from itertools import combinations

import numpy as np
from scipy import sparse

import causal_atlas_coverage
from causal_adjacent_scale_availability import (
    sparse_inclusive_interval_count_matrix,
)
from causal_atlas_coverage import (
    FROZEN_ATLAS_SIZE,
    FROZEN_BUFFER_RADIUS_MULTIPLIERS,
    FROZEN_DENSITIES,
    FROZEN_SEED,
    _rng,
    complete_outer_candidates,
    evaluate_atlas,
    final_gates,
    independent_order_bulk,
    mask_jaccard,
    outer_carrier,
    protected_core,
    sample_outer_candidates,
    sampled_induced_count_tripwire,
    spawn_realization_seed_states,
)
from causal_buffered_core_feasibility import schedule_at_density


def transitive_closure(size: int, edges: list[tuple[int, int]]) -> np.ndarray:
    relation = np.zeros((size, size), dtype=bool)
    for left, right in edges:
        relation[left, right] = True
    for pivot in range(size):
        relation |= relation[:, pivot, None] & relation[None, pivot, :]
    return relation


def chain_relation(size: int) -> np.ndarray:
    return transitive_closure(
        size,
        [(index, index + 1) for index in range(size - 1)],
    )


class CausalAtlasCoverageTests(unittest.TestCase):
    def test_frozen_balanced_schedule_and_constants(self) -> None:
        lower = schedule_at_density(4800.0)
        upper = schedule_at_density(9600.0)
        self.assertAlmostEqual(lower.outer_count, 2048.0)
        self.assertAlmostEqual(lower.buffer_count, 12.6992084157456)
        self.assertAlmostEqual(lower.local_count, 3.56359487256136)
        self.assertAlmostEqual(upper.outer_count / lower.outer_count, 2.0**0.75)
        self.assertAlmostEqual(upper.buffer_count / lower.buffer_count, 2.0**0.5)
        self.assertAlmostEqual(upper.local_count / lower.local_count, 2.0**0.25)
        self.assertEqual(FROZEN_DENSITIES, (4800, 9600))
        self.assertEqual(FROZEN_BUFFER_RADIUS_MULTIPLIERS, (0.8, 1.0, 1.25))
        self.assertEqual(FROZEN_ATLAS_SIZE, 16)

    def test_sparse_counts_match_dense_chain_and_branching_controls(self) -> None:
        relations = [
            chain_relation(8),
            transitive_closure(
                7,
                [(0, 1), (0, 2), (1, 3), (2, 3), (3, 4), (3, 5), (5, 6)],
            ),
        ]
        for relation in relations:
            integer_relation = relation.astype(np.int32)
            dense = (integer_relation @ integer_relation) * integer_relation
            dense += integer_relation
            sparse_counts = sparse_inclusive_interval_count_matrix(relation)
            np.testing.assert_array_equal(sparse_counts.toarray(), dense)

    def test_candidate_set_is_exactly_relabeling_equivariant(self) -> None:
        counts = np.zeros((5, 5), dtype=np.int32)
        counts[0, 3] = 9
        counts[1, 4] = 10
        counts[2, 4] = 11
        counts[0, 4] = 12
        original = complete_outer_candidates(sparse.csr_matrix(counts), 10.0)

        permutation = np.array([3, 0, 4, 1, 2])
        relabeled_counts = counts[np.ix_(permutation, permutation)]
        relabeled = complete_outer_candidates(
            sparse.csr_matrix(relabeled_counts),
            10.0,
        )
        pulled = {
            (int(permutation[past]), int(permutation[future]), int(count))
            for past, future, count in relabeled
        }
        self.assertEqual(
            pulled,
            {(int(past), int(future), int(count)) for past, future, count in original},
        )

    def test_core_bulk_coverage_and_overlap_relabel_exactly(self) -> None:
        relation = chain_relation(8)
        counts = sparse_inclusive_interval_count_matrix(relation)
        candidates = np.array([[0, 7, 7], [0, 6, 6]], dtype=np.int64)
        original = evaluate_atlas(
            relation,
            counts,
            candidates,
            buffer_radius_multiplier=1.0,
            base_buffer_count=2.0,
            atlas_size=2,
            rng=np.random.default_rng(9),
        )
        np.testing.assert_array_equal(
            np.flatnonzero(protected_core(relation, counts, 0, 7, 2.0)),
            [2, 3, 4, 5],
        )
        np.testing.assert_array_equal(
            np.flatnonzero(independent_order_bulk(relation, 2.0)),
            [2, 3, 4, 5],
        )

        permutation = np.array([4, 0, 7, 2, 6, 1, 5, 3])
        inverse = np.argsort(permutation)
        new_relation = relation[np.ix_(permutation, permutation)]
        new_counts = sparse_inclusive_interval_count_matrix(new_relation)
        new_candidates = np.array(
            [
                [int(inverse[past]), int(inverse[future]), int(count)]
                for past, future, count in candidates
            ],
            dtype=np.int64,
        )
        relabeled = evaluate_atlas(
            new_relation,
            new_counts,
            new_candidates,
            buffer_radius_multiplier=1.0,
            base_buffer_count=2.0,
            atlas_size=2,
            rng=np.random.default_rng(9),
        )
        for field in (
            "carrier_sizes",
            "core_sizes",
            "all_event_coverage",
            "bulk_count",
            "covered_bulk_count",
            "bulk_coverage",
            "repeated_covered_bulk_count",
            "repeated_given_covered_bulk",
            "maximum_multiplicity",
            "nonempty_carrier_overlap_pairs",
            "nonempty_core_overlap_pairs",
            "carrier_jaccard_values",
            "core_jaccard_values",
            "runtime_count_tripwire",
        ):
            self.assertEqual(getattr(relabeled, field), getattr(original, field))
        pulled_candidates = {
            (int(permutation[past]), int(permutation[future]), int(count))
            for past, future, count in relabeled.sampled_candidates
        }
        self.assertEqual(pulled_candidates, set(original.sampled_candidates))

    def test_uniform_subset_sampler_has_all_small_set_outcomes(self) -> None:
        candidates = np.array(
            [[index, index + 5, 10] for index in range(4)],
            dtype=np.int64,
        )
        expected_subsets = {
            tuple(pair) for pair in combinations(range(len(candidates)), 2)
        }
        frequencies: Counter[tuple[int, ...]] = Counter()
        rng = np.random.default_rng(2026071607)
        draws = 12000
        for _ in range(draws):
            sample = sample_outer_candidates(candidates, 2, rng)
            frequencies[tuple(sorted(int(row[0]) for row in sample))] += 1
        self.assertEqual(set(frequencies), expected_subsets)
        expected_frequency = draws / len(expected_subsets)
        for count in frequencies.values():
            self.assertLess(abs(count - expected_frequency), 0.10 * expected_frequency)

    def test_protected_core_is_contained_and_count_tripwire_passes(self) -> None:
        relation = chain_relation(9)
        counts = sparse_inclusive_interval_count_matrix(relation)
        carrier = outer_carrier(relation, 0, 8)
        core = protected_core(relation, counts, 0, 8, 2.0)
        self.assertFalse(np.any(core & ~carrier))
        self.assertTrue(sampled_induced_count_tripwire(relation, counts, carrier))

    def test_jaccard_handles_empty_and_nonempty_controls(self) -> None:
        empty = np.zeros(4, dtype=bool)
        left = np.array([True, True, False, False])
        right = np.array([False, True, True, False])
        self.assertIsNone(mask_jaccard(empty, empty))
        self.assertAlmostEqual(mask_jaccard(left, right), 1.0 / 3.0)

    def test_seed_streams_are_distinct_reproducible_and_replayable(self) -> None:
        first = spawn_realization_seed_states(FROZEN_SEED, FROZEN_DENSITIES, 5, 3)
        second = spawn_realization_seed_states(FROZEN_SEED, FROZEN_DENSITIES, 5, 3)
        self.assertEqual(first, second)
        self.assertTrue(all(len(run) == 4 for run in first))
        self.assertEqual(len({state for run in first for state in run}), 40)
        np.testing.assert_array_equal(
            _rng(first[0][0]).integers(0, 2**31, size=8),
            _rng(second[0][0]).integers(0, 2**31, size=8),
        )

    def test_zero_denominator_refinement_never_passes(self) -> None:
        density_summaries = {}
        for events in FROZEN_DENSITIES:
            density_summaries[str(events)] = {
                str(beta): {
                    "density_pass": True,
                    "median_all_event_coverage": 0.75,
                    "median_bulk_coverage": None,
                    "median_repeated_given_covered_bulk": None,
                }
                for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS
            }
        gates = final_gates(density_summaries)
        self.assertFalse(gates["stage_passes_coverage_gate"])
        self.assertTrue(
            all(
                not row["passes"]
                for row in gates["refinement_drift"].values()
            )
        )

    def test_order_side_apis_have_no_coordinate_argument(self) -> None:
        order_functions = (
            complete_outer_candidates,
            sample_outer_candidates,
            outer_carrier,
            protected_core,
            independent_order_bulk,
            mask_jaccard,
            sampled_induced_count_tripwire,
            evaluate_atlas,
            final_gates,
        )
        for function in order_functions:
            parameters = inspect.signature(function).parameters
            self.assertNotIn("points", parameters)
            self.assertNotIn("coordinates", parameters)

    def test_no_support_row_or_metric_phase_is_imported(self) -> None:
        source = inspect.getsource(causal_atlas_coverage)
        self.assertNotIn("_operator_row_at_mark", source)
        self.assertNotIn("corrected_gamma", source)
        self.assertNotIn("MINKOWSKI_INVERSE", source)
        self.assertNotIn("evaluate_outer_order", source)


if __name__ == "__main__":
    unittest.main()
