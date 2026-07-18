"""Hostile exact controls for Stage A3f-R4 growing causal atlases."""

from __future__ import annotations

import inspect
import itertools
import unittest
from collections import Counter
from collections.abc import Callable

import numpy as np

import causal_growing_atlas
from causal_adjacent_scale_availability import (
    sparse_inclusive_interval_count_matrix,
)
from causal_growing_atlas import (
    DEVELOPMENT_SEED,
    FROZEN_BUFFER_RADIUS_MULTIPLIERS,
    FROZEN_CAPS,
    FROZEN_DENSITIES,
    HELDOUT_SEED,
    RANDOM_CONTROL_DRAWS,
    atlas_size,
    capacity_constrained_greedy,
    capacity_feasible_mask,
    capacity_greedy_tie_indices,
    classify_cell,
    content_sha256,
    coverage_captures,
    development_decision,
    evaluate_capacity_cell,
    extended_atlas_metrics,
    heldout_decision,
    materialize_candidate_carriers,
    occupied_triangles,
    outcome_counts,
    random_priority_feasible,
    resource_failure_cells,
    spawn_phase_seed_states,
)


def candidate_rows(count: int) -> np.ndarray:
    return np.asarray(
        [[index, index + 1, index + 2] for index in range(count)],
        dtype=np.int64,
    )


def transitive_closure(size: int, edges: list[tuple[int, int]]) -> np.ndarray:
    relation = np.zeros((size, size), dtype=bool)
    for left, right in edges:
        relation[left, right] = True
    for pivot in range(size):
        relation |= relation[:, pivot, None] & relation[None, pivot, :]
    return relation


class FixedPriorityRng:
    def __init__(self, priority: tuple[int, ...]) -> None:
        self.priority = np.asarray(priority, dtype=np.int64)

    def permutation(self, size: int) -> np.ndarray:
        if size != len(self.priority):
            raise ValueError("priority size mismatch")
        return self.priority.copy()


def metric(
    all_coverage: float,
    bulk_coverage: float,
    *,
    repeated: float = 0.6,
    triangles: float = 0.9,
    edge_density: float = 0.5,
    maximum_multiplicity: int = 5,
) -> dict[str, object]:
    return {
        "all_event_coverage": all_coverage,
        "bulk_coverage": bulk_coverage,
        "repeated_given_covered_bulk": repeated,
        "triangle_participation": triangles,
        "edge_density": edge_density,
        "maximum_multiplicity": maximum_multiplicity,
    }


def summary_cell(outcome: str, value: float = 0.8) -> dict[str, object]:
    return {
        "outcome": outcome,
        "captures": {
            "all_event_family_capture": value,
            "bulk_family_capture": value,
            "all_event_headroom_capture": value,
            "bulk_headroom_capture": value,
        },
        "greedy": metric(value, value),
    }


def decision_records(
    realizations: int,
    outcome_for: Callable[[int, float, int, int], str],
) -> list[dict[str, object]]:
    records: list[dict[str, object]] = []
    for events in FROZEN_DENSITIES:
        for realization in range(realizations):
            rungs = []
            for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
                cells = [
                    {
                        "cap": cap,
                        **summary_cell(outcome_for(events, beta, cap, realization)),
                    }
                    for cap in FROZEN_CAPS
                ]
                rungs.append(
                    {"buffer_radius_multiplier": beta, "cells": cells}
                )
            records.append(
                {
                    "events": events,
                    "realization": realization,
                    "rungs": rungs,
                }
            )
    return records


class CausalGrowingAtlasTests(unittest.TestCase):
    def test_frozen_cardinality_is_exact_and_growing(self) -> None:
        self.assertEqual(atlas_size(6000), 18)
        self.assertEqual(atlas_size(12000), 21)
        self.assertLess(atlas_size(6000), atlas_size(12000))
        with self.assertRaises(ValueError):
            atlas_size(0)

    def test_phase_seed_trees_are_disjoint_and_replayable(self) -> None:
        first = spawn_phase_seed_states(
            DEVELOPMENT_SEED, FROZEN_DENSITIES, 3, FROZEN_CAPS
        )
        second = spawn_phase_seed_states(
            DEVELOPMENT_SEED, FROZEN_DENSITIES, 3, FROZEN_CAPS
        )
        heldout = spawn_phase_seed_states(
            HELDOUT_SEED, FROZEN_DENSITIES, 5, (8,)
        )
        self.assertEqual(first, second)
        self.assertEqual(len(first), 6)
        self.assertEqual(len(heldout), 10)

        def flatten(records: tuple[dict[str, object], ...]) -> set[tuple[int, ...]]:
            states: set[tuple[int, ...]] = set()
            for record in records:
                states.add(tuple(record["sprinkling"]))
                for rung in record["rungs"].values():
                    states.add(tuple(rung["unconstrained_greedy"]))
                    for cap in rung["caps"].values():
                        states.add(tuple(cap["greedy"]))
                        states.update(
                            tuple(state) for state in cap["random_controls"]
                        )
                        self.assertEqual(
                            len(cap["random_controls"]), RANDOM_CONTROL_DRAWS
                        )
            return states

        development_states = flatten(first)
        heldout_states = flatten(heldout)
        self.assertEqual(len(development_states), 6 * 39)
        self.assertEqual(len(heldout_states), 10 * 15)
        self.assertTrue(development_states.isdisjoint(heldout_states))

    def test_materialized_carriers_use_literal_open_intervals(self) -> None:
        relation = transitive_closure(
            5, [(0, 1), (1, 2), (2, 3), (3, 4)]
        )
        candidates = np.asarray([[0, 4, 4], [1, 4, 3]], dtype=np.int64)
        carriers = materialize_candidate_carriers(relation, candidates)
        np.testing.assert_array_equal(
            carriers[0], np.asarray([False, True, True, True, False])
        )
        np.testing.assert_array_equal(
            carriers[1], np.asarray([False, False, True, True, False])
        )

    def test_capacity_feasibility_is_exact_eventwise(self) -> None:
        cores = np.asarray(
            [
                [True, True, False, False],
                [False, True, True, False],
                [False, False, True, True],
                [False, False, False, False],
            ]
        )
        available = np.ones(4, dtype=bool)
        multiplicity = np.asarray([1, 2, 0, 0], dtype=np.int64)
        feasible = capacity_feasible_mask(
            cores, available, multiplicity, cap=2
        )
        np.testing.assert_array_equal(feasible, [False, False, True, False])

    def test_capacity_feasibility_matches_exhaustive_small_oracle(self) -> None:
        for family_mask in range(1 << 9):
            cores = np.asarray(
                [
                    [bool(family_mask & (1 << (3 * row + column))) for column in range(3)]
                    for row in range(3)
                ]
            )
            for multiplicity_values in itertools.product(range(3), repeat=3):
                multiplicity = np.asarray(multiplicity_values, dtype=np.int64)
                for cap in (1, 2):
                    actual = capacity_feasible_mask(
                        cores, np.ones(3, dtype=bool), multiplicity, cap
                    )
                    expected = np.asarray(
                        [
                            bool(np.any(core))
                            and all(
                                not member or multiplicity[index] < cap
                                for index, member in enumerate(core)
                            )
                            for core in cores
                        ]
                    )
                    np.testing.assert_array_equal(actual, expected)

    def test_tie_orbit_uses_bulk_then_all_event_score(self) -> None:
        cores = np.asarray(
            [
                [True, False, True, False],
                [True, False, False, True],
                [False, True, True, True],
            ]
        )
        feasible = np.ones(3, dtype=bool)
        covered = np.zeros(4, dtype=bool)
        bulk = np.asarray([True, True, False, False])
        tied, bulk_score, all_score = capacity_greedy_tie_indices(
            cores, feasible, covered, bulk
        )
        self.assertEqual(bulk_score, 1)
        self.assertEqual(all_score, 3)
        np.testing.assert_array_equal(tied, [2])

    def test_capacity_greedy_never_exceeds_cap_and_replays(self) -> None:
        candidates = candidate_rows(5)
        cores = np.asarray(
            [
                [True, True, False, False, False],
                [False, True, True, False, False],
                [False, False, True, True, False],
                [False, False, False, True, True],
                [True, False, False, False, True],
            ]
        )
        bulk = np.ones(5, dtype=bool)
        first, first_steps = capacity_constrained_greedy(
            candidates, cores, bulk, 4, 2, np.random.default_rng(19)
        )
        second, second_steps = capacity_constrained_greedy(
            candidates, cores, bulk, 4, 2, np.random.default_rng(19)
        )
        np.testing.assert_array_equal(first, second)
        self.assertEqual(first_steps, second_steps)
        self.assertLessEqual(
            int(np.max(np.sum(cores[first], axis=0), initial=0)), 2
        )
        self.assertTrue(all(step.exact_tie_orbit for step in first_steps))

    def test_random_priority_control_is_replayable_and_capacity_safe(self) -> None:
        cores = np.asarray(
            [
                [True, True, False, False],
                [False, True, True, False],
                [False, False, True, True],
                [True, False, False, True],
            ]
        )
        first = random_priority_feasible(
            cores, 3, 2, np.random.default_rng(7)
        )
        second = random_priority_feasible(
            cores, 3, 2, np.random.default_rng(7)
        )
        np.testing.assert_array_equal(first, second)
        self.assertLessEqual(
            int(np.max(np.sum(cores[first], axis=0), initial=0)), 2
        )

    def test_random_priority_law_is_candidate_relabeling_equivariant(self) -> None:
        cores = np.asarray(
            [
                [True, True, False],
                [False, True, True],
                [True, False, True],
            ]
        )

        def law(matrix: np.ndarray) -> Counter[tuple[int, ...]]:
            result: Counter[tuple[int, ...]] = Counter()
            for priority in itertools.permutations(range(len(matrix))):
                selected = random_priority_feasible(
                    matrix, 2, 2, FixedPriorityRng(priority)
                )
                result[tuple(int(value) for value in selected)] += 1
            return result

        permutation = np.asarray([2, 0, 1], dtype=np.int64)
        inverse = np.argsort(permutation)
        original = law(cores)
        relabeled = law(cores[permutation])
        mapped = Counter(
            {
                tuple(int(permutation[index]) for index in selection): count
                for selection, count in relabeled.items()
            }
        )
        self.assertEqual(original, mapped)
        self.assertTrue(np.array_equal(inverse[permutation], np.arange(3)))

    def test_literal_triangles_are_not_only_graph_cliques(self) -> None:
        selected = np.asarray(
            [
                [True, True, False],
                [True, False, True],
                [False, True, True],
            ]
        )
        self.assertEqual(occupied_triangles(selected), ())
        selected[2, 0] = True
        self.assertEqual(occupied_triangles(selected), ((0, 1, 2),))

    def test_extended_metrics_detect_full_intersection_and_dimension(self) -> None:
        candidates = candidate_rows(3)
        cores = np.asarray(
            [
                [True, True, False, False],
                [True, False, True, False],
                [True, False, False, True],
            ]
        )
        metrics = extended_atlas_metrics(
            candidates,
            cores,
            np.asarray([0, 1, 2], dtype=np.int64),
            np.ones(4, dtype=bool),
        )
        self.assertTrue(metrics["full_common_intersection"])
        self.assertEqual(metrics["maximum_multiplicity"], 3)
        self.assertEqual(metrics["occupied_triangles"], ((0, 1, 2),))
        self.assertEqual(metrics["triangle_participation"], 1.0)
        self.assertEqual(metrics["edge_density"], 1.0)

    def test_synthetic_cell_runs_complete_tripwire_path(self) -> None:
        relation = transitive_closure(
            8, [(index, index + 1) for index in range(7)]
        )
        counts = sparse_inclusive_interval_count_matrix(relation)
        candidates = np.asarray(
            [[0, 7, 7], [0, 6, 6], [1, 7, 6], [1, 6, 5]],
            dtype=np.int64,
        )
        carriers = materialize_candidate_carriers(relation, candidates)
        cores = carriers.copy()
        seed_states = tuple(
            tuple(int(value) for value in root.generate_state(4))
            for root in np.random.SeedSequence(11).spawn(6)
        )
        result = evaluate_capacity_cell(
            relation,
            counts,
            candidates,
            carriers,
            cores,
            np.ones(8, dtype=bool),
            cap=2,
            size=2,
            greedy_seed_state=seed_states[0],
            control_seed_states=seed_states[1:],
        )
        self.assertIn(result["outcome"], ("PASS", "FAIL", "INADMISSIBLE"))
        self.assertTrue(all(result["tripwires"].values()))
        self.assertEqual(len(result["random_feasible_controls"]), 5)
        self.assertEqual(len(result["greedy_steps"]), 2)
        self.assertLessEqual(result["greedy"]["maximum_multiplicity"], 2)

    def test_capture_uses_median_of_five_controls(self) -> None:
        selected = metric(0.70, 0.80)
        controls = [
            metric(value, value + 0.10)
            for value in (0.10, 0.20, 0.30, 0.40, 0.50)
        ]
        captures = coverage_captures(selected, controls, 0.80, 0.90)
        self.assertAlmostEqual(
            captures["median_control_all_event_coverage"], 0.30
        )
        self.assertAlmostEqual(captures["all_event_family_capture"], 0.875)
        self.assertAlmostEqual(captures["all_event_headroom_capture"], 0.8)

    def test_control_saturation_has_no_headroom_capture(self) -> None:
        selected = metric(0.90, 0.90)
        controls = [metric(0.895, 0.895) for _ in range(5)]
        captures = coverage_captures(selected, controls, 0.90, 0.90)
        self.assertIsNone(captures["all_event_headroom_capture"])
        self.assertIsNone(captures["bulk_headroom_capture"])

    def test_outcome_taxonomy_encodes_intended_asymmetry(self) -> None:
        passing = {"gate": True}
        failed_greedy = {"2_exact_cardinality": False}
        self.assertEqual(classify_cell(passing, []), "PASS")
        self.assertEqual(classify_cell(failed_greedy, []), "FAIL")
        self.assertEqual(
            classify_cell(failed_greedy, ["random-feasible control shortfall"]),
            "INADMISSIBLE",
        )
        self.assertEqual(
            outcome_counts(
                [
                    {"outcome": "PASS"},
                    {"outcome": "FAIL"},
                    {"outcome": "INADMISSIBLE"},
                ]
            ),
            {"PASS": 1, "FAIL": 1, "INADMISSIBLE": 1},
        )

    def test_development_selects_smallest_qualifying_cap(self) -> None:
        def outcome(events: int, beta: float, cap: int, realization: int) -> str:
            del events, beta
            if cap in (8, 12) and realization < 2:
                return "PASS"
            return "FAIL"

        decision = development_decision(decision_records(3, outcome))
        self.assertEqual(decision["outcome"], "CAP_SELECTED")
        self.assertEqual(decision["chosen_cap"], 8)

    def test_development_distinguishes_fail_from_inadmissible(self) -> None:
        failed = development_decision(
            decision_records(3, lambda _n, _b, _c, r: "FAIL" if r < 2 else "PASS")
        )
        self.assertEqual(failed["outcome"], "FAIL")
        inconclusive = development_decision(
            decision_records(
                3,
                lambda _n, _b, _c, r: (
                    "INADMISSIBLE" if r == 0 else ("FAIL" if r == 1 else "PASS")
                ),
            )
        )
        self.assertEqual(inconclusive["outcome"], "INADMISSIBLE")

    def test_heldout_applies_four_of_five_and_drift(self) -> None:
        records = decision_records(5, lambda _n, _b, _c, r: "PASS" if r < 4 else "FAIL")
        passing = heldout_decision(records, 5)
        self.assertTrue(passing["stage_passes"])
        self.assertEqual(passing["outcome"], "PASS")

        failed_records = decision_records(
            5, lambda _n, _b, _c, r: "FAIL" if r < 2 else "PASS"
        )
        failed = heldout_decision(failed_records, 5)
        self.assertEqual(failed["outcome"], "FAIL")

        inadmissible_records = decision_records(
            5,
            lambda _n, _b, _c, r: (
                "INADMISSIBLE" if r == 0 else ("FAIL" if r == 1 else "PASS")
            ),
        )
        inadmissible = heldout_decision(inadmissible_records, 5)
        self.assertEqual(inadmissible["outcome"], "INADMISSIBLE")

    def test_resource_failure_shape_is_never_zero_coverage(self) -> None:
        cells = resource_failure_cells(FROZEN_CAPS, "memory ceiling")
        self.assertEqual(len(cells), 3)
        self.assertTrue(all(cell["outcome"] == "INADMISSIBLE" for cell in cells))
        self.assertTrue(all("greedy" not in cell for cell in cells))

    def test_content_hashes_drop_only_declared_runtime_fields(self) -> None:
        left = {
            "runtime_seconds": 1.0,
            "phase_peak_working_set_bytes": 10,
            "value": 3,
        }
        runtime_changed = {
            "runtime_seconds": 9.0,
            "phase_peak_working_set_bytes": 10,
            "value": 3,
        }
        peak_changed = {
            "runtime_seconds": 9.0,
            "phase_peak_working_set_bytes": 99,
            "value": 3,
        }
        value_changed = {**left, "value": 4}
        self.assertEqual(
            content_sha256(left, deterministic=False),
            content_sha256(runtime_changed, deterministic=False),
        )
        self.assertNotEqual(
            content_sha256(left, deterministic=False),
            content_sha256(peak_changed, deterministic=False),
        )
        self.assertEqual(
            content_sha256(left, deterministic=True),
            content_sha256(peak_changed, deterministic=True),
        )
        self.assertNotEqual(
            content_sha256(left, deterministic=True),
            content_sha256(value_changed, deterministic=True),
        )

    def test_order_side_apis_have_no_coordinate_input(self) -> None:
        functions = (
            capacity_feasible_mask,
            capacity_greedy_tie_indices,
            capacity_constrained_greedy,
            random_priority_feasible,
            occupied_triangles,
            extended_atlas_metrics,
            coverage_captures,
            development_decision,
            heldout_decision,
        )
        for function in functions:
            parameters = inspect.signature(function).parameters
            self.assertNotIn("points", parameters)
            self.assertNotIn("coordinates", parameters)
        source = inspect.getsource(causal_growing_atlas)
        self.assertNotIn("profile_pca_probes", source)
        self.assertNotIn("corrected_gamma", source)
        self.assertNotIn("MINKOWSKI_INVERSE", source)


if __name__ == "__main__":
    unittest.main()
