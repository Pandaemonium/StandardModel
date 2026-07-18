"""Hostile exact controls for Stage A3f-R5 smaller-core growing atlases."""

from __future__ import annotations

import inspect
import tempfile
import unittest
from pathlib import Path
from types import SimpleNamespace
from unittest.mock import patch

import numpy as np
from scipy import sparse

import causal_growing_atlas as r4
import causal_smaller_core_growing_atlas as r5


def metric(value: float = 0.8) -> dict[str, object]:
    return {
        "all_event_coverage": value,
        "bulk_coverage": value,
        "repeated_given_covered_bulk": value,
        "triangle_participation": value,
        "edge_density": 0.5,
        "maximum_multiplicity": 5,
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
        "greedy": metric(value),
    }


def decision_records(
    realizations: int,
    primary_outcome: str = "PASS",
    diagnostic_poison: str = "INADMISSIBLE",
    low_value: float = 0.8,
    high_value: float = 0.8,
) -> list[dict[str, object]]:
    records: list[dict[str, object]] = []
    for events in r5.FROZEN_DENSITIES:
        value = low_value if events == r5.FROZEN_DENSITIES[0] else high_value
        for realization in range(realizations):
            primary_cells = [
                {
                    "cap": cap,
                    **summary_cell(primary_outcome, value),
                }
                for cap in r5.FROZEN_CAPS
            ]
            diagnostic_cells = [
                {
                    "cap": cap,
                    "outcome": diagnostic_poison,
                    "captures": {},
                    "greedy": {},
                }
                for cap in r5.FROZEN_CAPS
            ]
            records.append(
                {
                    "events": events,
                    "realization": realization,
                    "rungs": [
                        {
                            "buffer_radius_multiplier": r5.PRIMARY_BETA,
                            "decision_role": "result_bearing_primary",
                            "cells": primary_cells,
                        },
                        {
                            "buffer_radius_multiplier": r5.DIAGNOSTIC_BETA,
                            "decision_role": "diagnostic_negative_control",
                            "cells": diagnostic_cells,
                        },
                    ],
                }
            )
    return records


def raw_capacity_cell(
    *,
    cap: int = 5,
    size: int = 2,
    selected: int = 2,
    control_sizes: tuple[int, ...] = (2, 2, 2, 2, 2),
) -> dict[str, object]:
    return {
        "cap": cap,
        "atlas_size": size,
        "outcome": "PASS",
        "inadmissible_reasons": [],
        "complete_union_all_event_coverage": 0.9,
        "complete_union_bulk_coverage": 0.9,
        "greedy": {
            "selected_candidates": tuple((0, 1, 2) for _ in range(selected)),
            "maximum_multiplicity": min(cap, selected),
        },
        "greedy_steps": [],
        "random_feasible_controls": [
            {
                "selected_candidates": tuple(
                    (0, 1, 2) for _ in range(control_size)
                ),
                "maximum_multiplicity": min(cap, control_size),
            }
            for control_size in control_sizes
        ],
        "captures": {},
        "positive_all_event_marginal_after_first": True,
        "tripwires": {"replay": True},
        "gates": {"2_exact_cardinality": True},
    }


class CausalSmallerCoreGrowingAtlasTests(unittest.TestCase):
    def test_protocol_has_one_primary_and_one_gate_inert_diagnostic(self) -> None:
        protocol = r5.frozen_protocol()
        self.assertEqual(protocol["primary_beta"], 1.25)
        self.assertEqual(protocol["diagnostic_negative_control_beta"], 1.0)
        self.assertTrue(protocol["diagnostic_excluded_from_all_decisions"])
        self.assertFalse(protocol["unexpected_nonhostile_control_gate_effect"])
        self.assertTrue(protocol["family_diagnostics_before_selection"])

    def test_r4_selector_gates_and_ceilings_are_inherited_exactly(self) -> None:
        self.assertEqual(r5.FROZEN_CAPS, r4.FROZEN_CAPS)
        self.assertEqual(r5.FROZEN_DENSITIES, r4.FROZEN_DENSITIES)
        self.assertEqual(r5.RANDOM_CONTROL_DRAWS, r4.RANDOM_CONTROL_DRAWS)
        self.assertEqual(
            r5.MAXIMUM_COMPLETE_CANDIDATES, r4.MAXIMUM_COMPLETE_CANDIDATES
        )
        self.assertEqual(
            r5.MAXIMUM_PEAK_WORKING_SET_BYTES,
            r4.MAXIMUM_PEAK_WORKING_SET_BYTES,
        )
        self.assertEqual(r5.atlas_size(6000), 18)
        self.assertEqual(r5.atlas_size(12000), 21)
        protocol = r5.frozen_protocol()
        self.assertEqual(protocol["minimum_bulk_coverage"], 0.70)
        self.assertEqual(protocol["minimum_family_capture"], 0.80)
        self.assertEqual(protocol["minimum_headroom_capture"], 0.50)
        self.assertEqual(protocol["minimum_repeated_coverage"], 0.35)
        self.assertEqual(protocol["maximum_edge_density"], 0.90)
        self.assertEqual(protocol["minimum_triangle_participation"], 0.80)

    def test_frozen_seed_trees_are_disjoint_and_replayable(self) -> None:
        development = r5.spawn_phase_seed_states(
            r5.DEVELOPMENT_SEED,
            r5.FROZEN_DENSITIES,
            r5.DEVELOPMENT_REALIZATIONS,
            r5.FROZEN_CAPS,
        )
        replay = r5.spawn_phase_seed_states(
            r5.DEVELOPMENT_SEED,
            r5.FROZEN_DENSITIES,
            r5.DEVELOPMENT_REALIZATIONS,
            r5.FROZEN_CAPS,
        )
        heldout = r5.spawn_phase_seed_states(
            r5.HELDOUT_SEED,
            r5.FROZEN_DENSITIES,
            r5.HELDOUT_REALIZATIONS,
            r5.FROZEN_CAPS,
        )
        self.assertEqual(development, replay)
        self.assertNotEqual(development, heldout[: len(development)])
        self.assertTrue(
            all(
                set(record["rungs"])
                == {r5.beta_key(1.25), r5.beta_key(1.0)}
                for record in development
            )
        )

    def test_seed_roles_are_pairwise_disjoint_within_each_record(self) -> None:
        record = r5.spawn_phase_seed_states(17, (100,), 1, (5, 8))[0]
        states: list[tuple[int, ...]] = [tuple(record["sprinkling"])]
        for rung in record["rungs"].values():
            states.append(tuple(rung["unconstrained_greedy"]))
            for cell in rung["caps"].values():
                states.append(tuple(cell["greedy"]))
                states.extend(tuple(state) for state in cell["random_controls"])
        self.assertEqual(len(states), len(set(states)))

    def test_mechanism_labels_preserve_one_directionality(self) -> None:
        common = {"global_intersection_nonempty": True}
        empty = {"global_intersection_nonempty": False}
        family_empty = {"global_intersection_nonempty": None}
        self.assertEqual(r5.mechanism_label(common, True), "certificate_dead")
        self.assertEqual(r5.mechanism_label(common, False), "certificate_dead")
        self.assertEqual(
            r5.mechanism_label(empty, False),
            "empty_intersection_greedy_trapped",
        )
        self.assertEqual(
            r5.mechanism_label(empty, True),
            "empty_intersection_greedy_reaches_target",
        )
        self.assertIsNone(r5.mechanism_label(family_empty, False))

    def test_diagnostic_cell_has_no_result_bearing_assignment(self) -> None:
        family = {"global_intersection_nonempty": False}
        diagnostic = r5.diagnostic_capacity_cell(raw_capacity_cell(), family)
        self.assertNotIn("outcome", diagnostic)
        self.assertNotIn("gates", diagnostic)
        self.assertNotIn("inadmissible_reasons", diagnostic)
        self.assertTrue(diagnostic["selector_reaches_target"])
        self.assertTrue(diagnostic["unexpected_nonhostile_control"])
        self.assertEqual(len(diagnostic["random_controls_reach_target"]), 5)
        self.assertEqual(
            diagnostic["mechanism_label"],
            "empty_intersection_greedy_reaches_target",
        )

    def test_diagnostic_shortfall_is_archived_but_never_classified(self) -> None:
        family = {"global_intersection_nonempty": False}
        diagnostic = r5.diagnostic_capacity_cell(
            raw_capacity_cell(selected=1, control_sizes=(1, 2, 2, 2, 2)),
            family,
        )
        self.assertFalse(diagnostic["selector_reaches_target"])
        self.assertFalse(diagnostic["unexpected_nonhostile_control"])
        self.assertEqual(
            diagnostic["mechanism_label"],
            "empty_intersection_greedy_trapped",
        )
        self.assertNotIn("outcome", diagnostic)

    def test_diagnostic_resource_failure_has_no_outcome(self) -> None:
        cells = r5.diagnostic_resource_failure_cells((5, 8, 12), 18, "memory")
        self.assertEqual(len(cells), 3)
        self.assertTrue(all("outcome" not in cell for cell in cells))
        self.assertTrue(
            all(cell["diagnostic_runtime_notes"] == ["memory"] for cell in cells)
        )

    def test_development_decision_ignores_diagnostic_poison(self) -> None:
        failed_diagnostic = decision_records(3, diagnostic_poison="FAIL")
        inadmissible_diagnostic = decision_records(
            3, diagnostic_poison="INADMISSIBLE"
        )
        first = r5.development_decision(failed_diagnostic)
        second = r5.development_decision(inadmissible_diagnostic)
        self.assertEqual(first, second)
        self.assertEqual(first["outcome"], "CAP_SELECTED")
        self.assertEqual(first["chosen_cap"], 5)
        self.assertEqual(first["diagnostic_beta_excluded"], 1.0)

    def test_development_primary_fail_vs_inadmissible_semantics(self) -> None:
        failed = decision_records(3, primary_outcome="FAIL")
        self.assertEqual(r5.development_decision(failed)["outcome"], "FAIL")
        inadmissible = decision_records(3, primary_outcome="INADMISSIBLE")
        self.assertEqual(
            r5.development_decision(inadmissible)["outcome"], "INADMISSIBLE"
        )

    def test_heldout_ignores_diagnostic_and_uses_primary_drift_only(self) -> None:
        passing = decision_records(
            5,
            diagnostic_poison="INADMISSIBLE",
            low_value=0.80,
            high_value=0.90,
        )
        result = r5.heldout_decision(passing, 5)
        self.assertTrue(result["stage_passes"])
        self.assertEqual(result["outcome"], "PASS")
        self.assertEqual(result["diagnostic_beta_excluded"], 1.0)
        for value in result["drifts"].values():
            self.assertAlmostEqual(value, 0.1)

    def test_heldout_primary_drift_failure_is_decisive(self) -> None:
        records = decision_records(5, low_value=0.60, high_value=0.90)
        result = r5.heldout_decision(records, 5)
        self.assertFalse(result["stage_passes"])
        self.assertEqual(result["outcome"], "FAIL")

    def test_family_summary_precedes_every_selector(self) -> None:
        order: list[str] = []
        relation = np.zeros((2, 2), dtype=bool)
        counts = sparse.csr_matrix((2, 2), dtype=np.int64)
        candidates = np.asarray([[0, 1, 1]], dtype=np.int64)
        carriers = np.ones((1, 2), dtype=bool)
        states = r5.spawn_phase_seed_states(23, (2,), 1, (5,))[0]["rungs"]

        def summarize(cores: np.ndarray) -> dict[str, object]:
            order.append("family")
            return {
                "family_empty": False,
                "global_intersection_nonempty": False,
            }

        def unconstrained(*args: object, **kwargs: object) -> tuple[np.ndarray, tuple]:
            del args, kwargs
            order.append("unconstrained")
            return np.asarray([0], dtype=np.int64), ()

        def capacity(*args: object, **kwargs: object) -> dict[str, object]:
            del args, kwargs
            order.append("capacity")
            return raw_capacity_cell(cap=5, size=1, selected=1, control_sizes=(1,) * 5)

        with (
            patch.object(r5, "independent_order_bulk", return_value=np.ones(2, bool)),
            patch.object(
                r5,
                "complete_candidate_cores",
                return_value=(candidates, np.ones((1, 2), bool)),
            ),
            patch.object(r5, "summarize_complete_family", side_effect=summarize),
            patch.object(r5, "greedy_maximum_coverage", side_effect=unconstrained),
            patch.object(r5.r4, "evaluate_capacity_cell", side_effect=capacity),
            patch.object(r5.r4, "extended_atlas_metrics", return_value={}),
        ):
            r5.evaluate_rung(
                relation,
                counts,
                candidates,
                carriers,
                SimpleNamespace(buffer_count=1.0),
                r5.PRIMARY_BETA,
                1,
                (5,),
                states[r5.beta_key(r5.PRIMARY_BETA)],
            )
        self.assertEqual(order, ["family", "unconstrained", "capacity"])

    def test_each_selector_scores_the_bulk_of_its_own_rung(self) -> None:
        seen_bulk: list[tuple[float, ...]] = []
        relation = np.zeros((2, 2), dtype=bool)
        counts = sparse.csr_matrix((2, 2), dtype=np.int64)
        candidates = np.asarray([[0, 1, 1]], dtype=np.int64)
        carriers = np.ones((1, 2), dtype=bool)
        states = r5.spawn_phase_seed_states(29, (2,), 1, (5,))[0]["rungs"]

        def bulk(_relation: np.ndarray, buffer_count: float) -> np.ndarray:
            return np.asarray([buffer_count > 1.5, buffer_count <= 1.5])

        def capacity(*args: object, **kwargs: object) -> dict[str, object]:
            del kwargs
            seen_bulk.append(tuple(float(value) for value in args[5]))
            return raw_capacity_cell(cap=5, size=1, selected=1, control_sizes=(1,) * 5)

        common_patches = (
            patch.object(r5, "independent_order_bulk", side_effect=bulk),
            patch.object(
                r5,
                "complete_candidate_cores",
                return_value=(candidates, np.ones((1, 2), bool)),
            ),
            patch.object(
                r5,
                "summarize_complete_family",
                return_value={
                    "family_empty": False,
                    "global_intersection_nonempty": False,
                },
            ),
            patch.object(
                r5,
                "greedy_maximum_coverage",
                return_value=(np.asarray([0], dtype=np.int64), ()),
            ),
            patch.object(r5.r4, "evaluate_capacity_cell", side_effect=capacity),
            patch.object(r5.r4, "extended_atlas_metrics", return_value={}),
        )
        with common_patches[0], common_patches[1], common_patches[2], common_patches[3], common_patches[4], common_patches[5]:
            for beta in (r5.PRIMARY_BETA, r5.DIAGNOSTIC_BETA):
                r5.evaluate_rung(
                    relation,
                    counts,
                    candidates,
                    carriers,
                    SimpleNamespace(buffer_count=1.0),
                    beta,
                    1,
                    (5,),
                    states[r5.beta_key(beta)],
                )
        self.assertEqual(seen_bulk, [(1.0, 0.0), (0.0, 1.0)])

    def test_unreviewed_rung_is_rejected_before_any_computation(self) -> None:
        with self.assertRaisesRegex(ValueError, "not a frozen R5 rung"):
            r5.evaluate_rung(
                np.zeros((1, 1), dtype=bool),
                sparse.csr_matrix((1, 1), dtype=np.int64),
                np.empty((0, 3), dtype=np.int64),
                np.empty((0, 1), dtype=bool),
                SimpleNamespace(buffer_count=1.0),
                0.8,
                1,
                (5,),
                {},
            )

    def test_resource_overwrite_never_classifies_diagnostic(self) -> None:
        rungs = [
            {
                "decision_role": "result_bearing_primary",
                "cells": [{"outcome": "PASS", "inadmissible_reasons": []}],
            },
            {
                "decision_role": "diagnostic_negative_control",
                "cells": [{"diagnostic_runtime_notes": []}],
            },
        ]
        r5._overwrite_resource_outcomes(rungs, "timeout")
        self.assertEqual(rungs[0]["cells"][0]["outcome"], "INADMISSIBLE")
        self.assertNotIn("outcome", rungs[1]["cells"][0])
        self.assertEqual(
            rungs[1]["cells"][0]["diagnostic_runtime_notes"], ["timeout"]
        )

    def test_output_set_is_reserved_before_runner(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            development = root / "development.json"
            heldout = root / "heldout.json"
            sentinel = root / "sentinel.json"

            def runner() -> tuple[dict[str, object], dict[str, object]]:
                self.assertTrue(development.exists())
                self.assertTrue(heldout.exists())
                self.assertTrue(sentinel.exists())
                return {"decision": {"outcome": "INADMISSIBLE"}}, {
                    "status": "retired_unconsumed"
                }

            left, right = r5.execute_reserved_benchmark(
                development,
                heldout,
                sentinel,
                {
                    "work_item": "test",
                    "protocol_sha256": "0" * 64,
                    "seed": {"development": 1, "heldout": 2},
                },
                runner,
            )
            self.assertEqual(left["decision"]["outcome"], "INADMISSIBLE")
            self.assertEqual(right["status"], "retired_unconsumed")
            self.assertTrue(development.exists())
            self.assertTrue(heldout.exists())
            self.assertTrue(sentinel.exists())

    def test_content_hashes_preserve_r4_canonicalization(self) -> None:
        left = {
            "runtime_seconds": 1.0,
            "phase_peak_working_set_bytes": 10,
            "value": 3,
        }
        runtime_changed = {**left, "runtime_seconds": 9.0}
        peak_changed = {**left, "phase_peak_working_set_bytes": 99}
        self.assertEqual(
            r5.content_sha256(left, deterministic=False),
            r5.content_sha256(runtime_changed, deterministic=False),
        )
        self.assertNotEqual(
            r5.content_sha256(left, deterministic=False),
            r5.content_sha256(peak_changed, deterministic=False),
        )
        self.assertEqual(
            r5.content_sha256(left, deterministic=True),
            r5.content_sha256(peak_changed, deterministic=True),
        )

    def test_order_side_apis_have_no_coordinate_input(self) -> None:
        for function in (
            r5.evaluate_rung,
            r5.development_decision,
            r5.heldout_decision,
            r5.mechanism_label,
        ):
            parameters = inspect.signature(function).parameters
            self.assertNotIn("points", parameters)
            self.assertNotIn("coordinates", parameters)


if __name__ == "__main__":
    unittest.main()
