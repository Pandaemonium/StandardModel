"""Hostile exact controls for Stage A3f-R3 atlas-family scaling."""

from __future__ import annotations

import inspect
import itertools
import math
import unittest

import numpy as np

import causal_atlas_scaling
from causal_adjacent_scale_availability import (
    sparse_inclusive_interval_count_matrix,
)
from causal_atlas_coverage import (
    FROZEN_BUFFER_RADIUS_MULTIPLIERS,
    complete_outer_candidates,
    protected_core,
)
from causal_atlas_scaling import (
    FROZEN_DENSITIES,
    FROZEN_SEED,
    candidate_content_sha256,
    effective_count_threshold,
    final_gates,
    flat_bulk_fraction_prediction,
    process_peak_working_set_bytes,
    resource_failure_record,
    scientific_content_sha256,
    spawn_scaling_seed_states,
    stream_complete_family,
    summarize_density,
)


def transitive_closure(size: int, edges: list[tuple[int, int]]) -> np.ndarray:
    relation = np.zeros((size, size), dtype=bool)
    for left, right in edges:
        relation[left, right] = True
    for pivot in range(size):
        relation |= relation[:, pivot, None] & relation[None, pivot, :]
    return relation


def chain_relation(size: int) -> np.ndarray:
    return transitive_closure(
        size, [(index, index + 1) for index in range(size - 1)]
    )


def stream(
    relation: np.ndarray,
    candidates: np.ndarray,
    base_buffer_count: float,
    **kwargs: object,
) -> dict[str, object]:
    counts = sparse_inclusive_interval_count_matrix(relation)
    return stream_complete_family(
        relation,
        counts,
        candidates,
        base_buffer_count,
        len(relation) - 1,
        **kwargs,
    )


class FakeMemoryInfo:
    def __init__(self, peak_wset: int) -> None:
        self.peak_wset = peak_wset
        self.rss = peak_wset


class FakeProcess:
    def __init__(self, peak_wset: int) -> None:
        self.peak_wset = peak_wset

    def memory_info(self) -> FakeMemoryInfo:
        return FakeMemoryInfo(self.peak_wset)


class CausalAtlasScalingTests(unittest.TestCase):
    def test_real_threshold_is_exactly_the_integer_ceiling(self) -> None:
        self.assertEqual(effective_count_threshold(0.01), 1)
        self.assertEqual(effective_count_threshold(2.0), 2)
        self.assertEqual(effective_count_threshold(2.0001), 3)
        with self.assertRaises(ValueError):
            effective_count_threshold(-1.0)

    def test_streamed_cores_match_reviewed_materialized_predicate(self) -> None:
        relation = chain_relation(11)
        counts = sparse_inclusive_interval_count_matrix(relation)
        candidates = np.asarray(
            [[0, 10, 10], [0, 9, 9], [1, 10, 9], [1, 9, 8]],
            dtype=np.int64,
        )
        result = stream_complete_family(
            relation,
            counts,
            candidates,
            2.0,
            10,
            include_union_masks=True,
        )
        self.assertEqual(result["status"], "completed")
        for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
            threshold = beta**4 * 2.0
            cores = [
                protected_core(
                    relation,
                    counts,
                    int(past),
                    int(future),
                    threshold,
                )
                for past, future, _ in candidates
            ]
            expected = np.any(np.stack(cores), axis=0)
            actual = result["all_event_union_masks"][str(beta)]
            np.testing.assert_array_equal(actual, expected)
            rung = next(
                row
                for row in result["rungs"]
                if row["buffer_radius_multiplier"] == beta
            )
            self.assertEqual(
                rung["complete_union_all_event_count"],
                int(np.count_nonzero(expected)),
            )
            self.assertTrue(rung["core_carrier_containment_tripwire"])
            self.assertTrue(rung["core_bulk_containment_tripwire"])
            self.assertTrue(rung["integer_factorization_tripwire"])
            self.assertTrue(rung["floating_factorization_tripwire"])

    def test_every_candidate_count_matches_its_actual_carrier(self) -> None:
        relation = chain_relation(8)
        candidates = np.asarray(
            [[0, 7, 7], [0, 6, 6], [1, 7, 6]], dtype=np.int64
        )
        good = stream(relation, candidates, 1.0)
        self.assertTrue(good["candidate_count_tripwire"])
        self.assertTrue(good["induced_count_tripwire"])

        corrupt = candidates.copy()
        corrupt[1, 2] += 1
        bad = stream(relation, corrupt, 1.0)
        self.assertFalse(bad["candidate_count_tripwire"])
        self.assertFalse(bad["induced_count_tripwire"])
        self.assertTrue(all(not row["admissible"] for row in bad["rungs"]))

    def test_complete_union_maps_under_every_four_event_relabeling(self) -> None:
        relation = chain_relation(4)
        counts = sparse_inclusive_interval_count_matrix(relation)
        candidates = complete_outer_candidates(counts, 2.0, (0.9, 1.1))
        original = stream(
            relation, candidates, 0.1, include_union_masks=True
        )
        for permutation_tuple in itertools.permutations(range(4)):
            permutation = np.asarray(permutation_tuple, dtype=np.int64)
            relabeled_relation = relation[np.ix_(permutation, permutation)]
            relabeled_counts = sparse_inclusive_interval_count_matrix(
                relabeled_relation
            )
            relabeled_candidates = complete_outer_candidates(
                relabeled_counts, 2.0, (0.9, 1.1)
            )
            relabeled = stream_complete_family(
                relabeled_relation,
                relabeled_counts,
                relabeled_candidates,
                0.1,
                3,
                include_union_masks=True,
            )
            for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
                np.testing.assert_array_equal(
                    relabeled["all_event_union_masks"][str(beta)],
                    original["all_event_union_masks"][str(beta)][permutation],
                )

    def test_candidate_processing_order_cannot_change_any_union(self) -> None:
        relation = chain_relation(9)
        candidates = np.asarray(
            [[0, 8, 8], [0, 7, 7], [1, 8, 7]], dtype=np.int64
        )
        original = stream(
            relation, candidates, 1.0, include_union_masks=True
        )
        for permutation in itertools.permutations(range(len(candidates))):
            relabeled = stream(
                relation,
                candidates[np.asarray(permutation)],
                1.0,
                include_union_masks=True,
            )
            for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
                np.testing.assert_array_equal(
                    relabeled["all_event_union_masks"][str(beta)],
                    original["all_event_union_masks"][str(beta)],
                )

    def test_bulk_containment_gives_exact_coverage_factorization(self) -> None:
        relation = chain_relation(10)
        candidates = np.asarray(
            [[0, 9, 9], [0, 8, 8], [1, 9, 8]], dtype=np.int64
        )
        result = stream(relation, candidates, 1.0)
        for rung in result["rungs"]:
            self.assertEqual(
                rung["complete_union_all_event_count"],
                rung["complete_union_bulk_count"],
            )
            factored = (
                rung["bulk_fraction"]
                * rung["complete_union_bulk_coverage"]
            )
            self.assertAlmostEqual(
                rung["complete_union_all_event_coverage"], factored
            )

    def test_resource_failures_are_none_valued_and_never_truncate(self) -> None:
        relation = chain_relation(5)
        candidates = np.asarray(
            [[0, 4, 4], [0, 3, 3], [1, 4, 3]], dtype=np.int64
        )
        candidate_failure = stream(
            relation, candidates, 1.0, maximum_candidates=2
        )
        self.assertEqual(candidate_failure["status"], "resource_failure")
        self.assertEqual(candidate_failure["complete_candidate_count"], 3)
        self.assertTrue(
            all(
                row["complete_union_all_event_coverage"] is None
                and not row["admissible"]
                for row in candidate_failure["rungs"]
            )
        )

        time_failure = stream(
            relation,
            candidates,
            1.0,
            started_at=0.0,
            maximum_seconds=1.0,
            clock=lambda: 2.0,
        )
        self.assertEqual(time_failure["status"], "resource_failure")
        self.assertEqual(time_failure["resource_failure"]["phase"], "streaming")

        memory_failure = stream(
            relation,
            candidates,
            1.0,
            maximum_peak_bytes=100,
            process=FakeProcess(101),
        )
        self.assertEqual(memory_failure["status"], "resource_failure")

    def test_resource_failure_shape_is_structurally_distinct(self) -> None:
        failed = resource_failure_record(
            "test", "ceiling", 10, 2.0, 17, {"test": 1}
        )
        self.assertEqual(failed["status"], "resource_failure")
        self.assertEqual(failed["complete_candidate_count"], 17)
        self.assertIsNone(failed["rungs"][0]["bulk_fraction"])
        self.assertTrue(all(not row["admissible"] for row in failed["rungs"]))

    def test_seed_streams_and_candidate_hashes_are_replayable(self) -> None:
        first = spawn_scaling_seed_states(FROZEN_SEED, FROZEN_DENSITIES, 5)
        second = spawn_scaling_seed_states(FROZEN_SEED, FROZEN_DENSITIES, 5)
        self.assertEqual(first, second)
        self.assertEqual(len(first), 10)
        self.assertEqual(len(set(first)), 10)
        candidates = np.asarray([[1, 3, 2], [0, 4, 4]], dtype=np.int64)
        self.assertEqual(
            candidate_content_sha256(candidates),
            candidate_content_sha256(candidates.copy()),
        )
        self.assertNotEqual(
            candidate_content_sha256(candidates),
            candidate_content_sha256(candidates[::-1]),
        )

    def test_flat_f4_control_uses_the_archived_real_ratio(self) -> None:
        prediction = flat_bulk_fraction_prediction(12.0, 6000)
        z = 2.0 * (12.0 / 6000) ** 0.25
        self.assertGreater(prediction, 0.0)
        self.assertLess(prediction, 1.0)
        self.assertGreater(z, 0.0)

    def test_summary_clusters_before_forming_scaled_deficit(self) -> None:
        rows = []
        saturations = [0.80, 0.82, 0.84, 0.86, 0.88]
        for index, saturation in enumerate(saturations):
            rungs = []
            for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS:
                rungs.append(
                    {
                        "buffer_radius_multiplier": beta,
                        "admissible": True,
                        "bulk_fraction": 0.70,
                        "flat_f4_bulk_fraction_prediction": 0.69,
                        "complete_union_all_event_coverage": 0.70 * saturation,
                        "complete_union_bulk_coverage": saturation,
                        "scaled_saturation_deficit": math.sqrt(6000)
                        * (1.0 - saturation),
                    }
                )
            rows.append(
                {
                    "complete_candidate_count": 100 + index,
                    "rungs": rungs,
                }
            )
        summary = summarize_density(6000, rows)
        cell = summary["by_rung"]["0.8"]
        self.assertAlmostEqual(
            cell["clustered_scaled_saturation_deficit"],
            math.sqrt(6000) * (1.0 - 0.84),
        )
        self.assertEqual(len(cell["realization_scaled_saturation_deficits"]), 5)
        self.assertAlmostEqual(cell["median_f4_absolute_error"], 0.01)

    def test_final_gate_separates_geometric_kill_from_resource_failure(self) -> None:
        def density(events: int, saturation: float, all_coverage: float) -> dict[str, object]:
            return {
                "events": events,
                "by_rung": {
                    str(beta): {
                        "density_cell_admissible": True,
                        "median_complete_union_bulk_coverage": saturation,
                        "median_complete_union_all_event_coverage": all_coverage,
                        "clustered_scaled_saturation_deficit": math.sqrt(events)
                        * (1.0 - saturation),
                        "median_f4_absolute_error": 0.01,
                    }
                    for beta in FROZEN_BUFFER_RADIUS_MULTIPLIERS
                },
            }

        passing = {
            "6000": density(6000, 0.84, 0.57),
            "12000": density(12000, 0.887, 0.64),
        }
        gates = final_gates(passing)
        self.assertTrue(gates["stage_passes_scaling_gate"])
        self.assertFalse(gates["kill_displayed_saturation_law"])
        self.assertFalse(gates["operator_gate_open"])
        self.assertTrue(gates["g2_closed"])

        inconclusive = {
            key: {
                **value,
                "by_rung": {
                    beta: {**cell, "density_cell_admissible": False}
                    for beta, cell in value["by_rung"].items()
                },
            }
            for key, value in passing.items()
        }
        resource_gates = final_gates(inconclusive)
        self.assertFalse(resource_gates["kill_displayed_saturation_law"])
        self.assertTrue(resource_gates["resource_inconclusive_for_saturation_law"])

        failed = {
            "6000": density(6000, 0.84, 0.57),
            "12000": density(12000, 0.80, 0.55),
        }
        failure_gates = final_gates(failed)
        self.assertTrue(failure_gates["kill_displayed_saturation_law"])

    def test_scientific_hash_drops_only_runtime_fields_recursively(self) -> None:
        left = {
            "stage": "A3f-R3",
            "runtime_seconds": 1.0,
            "rows": [{"value": 3, "runtime_seconds": 2.0}],
        }
        right = {
            "stage": "A3f-R3",
            "runtime_seconds": 99.0,
            "rows": [{"runtime_seconds": 42.0, "value": 3}],
        }
        changed = {
            "stage": "A3f-R3",
            "rows": [{"value": 4, "runtime_seconds": 2.0}],
        }
        self.assertEqual(
            scientific_content_sha256(left), scientific_content_sha256(right)
        )
        self.assertNotEqual(
            scientific_content_sha256(left), scientific_content_sha256(changed)
        )

    def test_order_side_function_has_no_coordinate_or_selector_input(self) -> None:
        source = inspect.getsource(stream_complete_family)
        for forbidden in (
            "coordinates",
            "greedy_maximum_coverage",
            "sample_uniform_indices",
            "eigensolver",
            "profile_pca_probes",
        ):
            self.assertNotIn(forbidden, source)
        module_source = inspect.getsource(causal_atlas_scaling)
        for forbidden in (
            "greedy_maximum_coverage",
            "sample_uniform_indices",
            "evaluate_selected_atlas",
            "profile_pca_probes",
            "local_bd_row",
        ):
            self.assertNotIn(forbidden, module_source)

    def test_peak_working_set_is_positive(self) -> None:
        self.assertGreater(process_peak_working_set_bytes(), 0)


if __name__ == "__main__":
    unittest.main()
