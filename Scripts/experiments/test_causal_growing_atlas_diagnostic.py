from __future__ import annotations

import ast
import tempfile
import unittest
from pathlib import Path

import numpy as np

import causal_growing_atlas_diagnostic as diagnostic
from frozen_run_guard import FrozenRunConflict


class CompleteFamilySummaryTests(unittest.TestCase):
    def test_common_event_certificate_and_top_endpoint_are_counted(self) -> None:
        cores = np.array(
            [
                [True, True, False, False],
                [False, True, True, False],
                [True, True, True, False],
            ],
            dtype=bool,
        )
        summary = diagnostic.summarize_complete_family(cores)
        self.assertFalse(summary["family_empty"])
        self.assertTrue(summary["global_intersection_nonempty"])
        self.assertEqual(summary["global_intersection_size"], 1)
        self.assertEqual(summary["maximum_event_multiplicity"], 3)
        self.assertEqual(summary["events_attaining_maximum_multiplicity"], 1)
        self.assertEqual(summary["diamond_event_count"], 4)
        self.assertTrue(summary["complete_family_certificate_dead"])

    def test_empty_family_uses_null_not_vacuous_intersection(self) -> None:
        summary = diagnostic.summarize_complete_family(
            np.zeros((0, 5), dtype=bool)
        )
        self.assertTrue(summary["family_empty"])
        self.assertIsNone(summary["global_intersection_nonempty"])
        self.assertIsNone(summary["global_intersection_size"])
        self.assertIsNone(summary["maximum_event_multiplicity"])
        self.assertIsNone(summary["core_size"]["minimum"])

    def test_empty_core_breaks_intersection_and_is_archived(self) -> None:
        cores = np.array(
            [
                [True, False, False],
                [False, False, False],
            ],
            dtype=bool,
        )
        summary = diagnostic.summarize_complete_family(cores)
        self.assertFalse(summary["global_intersection_nonempty"])
        self.assertEqual(summary["core_size"]["minimum"], 0)
        self.assertEqual(summary["core_size"]["median"], 0.5)

    def test_even_family_median_can_be_half_integer(self) -> None:
        cores = np.array(
            [
                [True, False, False, False],
                [True, True, False, False],
                [True, True, True, False],
                [True, True, True, True],
            ],
            dtype=bool,
        )
        summary = diagnostic.summarize_complete_family(cores)
        self.assertEqual(summary["core_size"]["median"], 2.5)


class InterpretationTests(unittest.TestCase):
    @staticmethod
    def rung(beta: str, intersection: bool | None, minimum: int | None) -> dict:
        return {
            "beta": beta,
            "global_intersection_nonempty": intersection,
            "core_size": {"minimum": minimum},
        }

    def test_all_rungs_obstructed(self) -> None:
        rungs = [
            self.rung("0.80", True, 4),
            self.rung("1.00", True, 3),
            self.rung("1.25", True, 2),
        ]
        self.assertEqual(
            diagnostic.interpretation_label(rungs),
            "complete_family_obstruction_all_tested_rungs",
        )

    def test_smaller_rung_break_requires_nonvanishing_cores(self) -> None:
        rungs = [
            self.rung("0.80", True, 4),
            self.rung("1.00", True, 3),
            self.rung("1.25", False, 2),
        ]
        self.assertEqual(
            diagnostic.interpretation_label(rungs),
            "chart_scale_breaks_common_intersection",
        )
        rungs[-1]["core_size"]["minimum"] = 0
        self.assertEqual(
            diagnostic.interpretation_label(rungs),
            "smaller_rung_core_vanishing_or_mixed",
        )

    def test_consumed_rungs_without_common_event(self) -> None:
        rungs = [
            self.rung("0.80", False, 4),
            self.rung("1.00", False, 3),
            self.rung("1.25", True, 2),
        ]
        self.assertEqual(
            diagnostic.interpretation_label(rungs),
            "consumed_rungs_no_global_intersection",
        )

    def test_null_or_heterogeneous_pattern_is_mixed(self) -> None:
        rungs = [
            self.rung("0.80", True, 4),
            self.rung("1.00", None, None),
            self.rung("1.25", False, 2),
        ]
        self.assertEqual(
            diagnostic.interpretation_label(rungs),
            "mixed_rung_pattern",
        )


class ReplayTests(unittest.TestCase):
    def test_expected_counts_pin_every_consumed_rung(self) -> None:
        self.assertEqual(len(diagnostic.EXPECTED_REPLAY), 6)
        for (events, realization), expected in diagnostic.EXPECTED_REPLAY.items():
            for beta in diagnostic.CONSUMED_BETAS:
                assertion = diagnostic.assert_replay_equal(
                    events=events,
                    realization=realization,
                    beta=beta,
                    candidate_count=int(expected["candidate_count"]),
                    bulk_count=int(
                        expected["bulk_counts"][diagnostic.beta_key(beta)]
                    ),
                )
                self.assertTrue(assertion["candidate_count_matches"])
                self.assertTrue(assertion["bulk_count_matches"])

    def test_candidate_or_bulk_mismatch_hard_fails(self) -> None:
        expected = diagnostic.EXPECTED_REPLAY[(6000, 0)]
        with self.assertRaisesRegex(RuntimeError, "candidate-count"):
            diagnostic.assert_replay_equal(
                events=6000,
                realization=0,
                beta=0.8,
                candidate_count=int(expected["candidate_count"]) + 1,
                bulk_count=int(expected["bulk_counts"]["0.80"]),
            )
        with self.assertRaisesRegex(RuntimeError, "bulk-count"):
            diagnostic.assert_replay_equal(
                events=6000,
                realization=0,
                beta=0.8,
                candidate_count=int(expected["candidate_count"]),
                bulk_count=int(expected["bulk_counts"]["0.80"]) + 1,
            )

    def test_sprinkling_states_match_r4_seed_tree(self) -> None:
        full = diagnostic.spawn_phase_seed_states(
            diagnostic.DEVELOPMENT_SEED,
            diagnostic.FROZEN_DENSITIES,
            diagnostic.DEVELOPMENT_REALIZATIONS,
            diagnostic.FROZEN_CAPS,
        )
        expected = tuple(tuple(record["sprinkling"]) for record in full)
        self.assertEqual(diagnostic.diagnostic_sprinkling_states(), expected)
        self.assertEqual(len(set(expected)), 6)


class ReservationAndDisciplineTests(unittest.TestCase):
    def metadata(self) -> dict:
        return {
            "work_item": "GRAV-GROWING-ATLAS-001",
            "protocol_sha256": "a" * 64,
            "seed": {
                "development": diagnostic.DEVELOPMENT_SEED,
                "status": "consumed_deterministic_replay",
            },
        }

    def test_reservation_exists_before_runner_and_completes(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            output = root / "diagnostic.json"
            sentinel = root / "sentinel.json"

            def runner() -> dict[str, object]:
                self.assertTrue(output.exists())
                self.assertTrue(sentinel.exists())
                return {"runtime_seconds": 1.0, "phase_peak_working_set_bytes": 2}

            payload = diagnostic.execute_reserved_diagnostic(
                output, sentinel, self.metadata(), runner
            )
            self.assertEqual(payload["runtime_seconds"], 1.0)
            self.assertGreater(output.stat().st_size, 0)
            self.assertIn('"status": "completed"', sentinel.read_text())

    def test_existing_sentinel_blocks_before_runner(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            output = root / "diagnostic.json"
            sentinel = root / "sentinel.json"
            sentinel.write_text("{}\n", encoding="utf-8")
            called = False

            def runner() -> dict[str, object]:
                nonlocal called
                called = True
                return {}

            with self.assertRaises(FrozenRunConflict):
                diagnostic.execute_reserved_diagnostic(
                    output, sentinel, self.metadata(), runner
                )
            self.assertFalse(called)
            self.assertFalse(output.exists())

    def test_failed_runner_retains_sentinel_and_writes_no_payload(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            output = root / "diagnostic.json"
            sentinel = root / "sentinel.json"

            def runner() -> dict[str, object]:
                raise RuntimeError("replay mismatch")

            with self.assertRaisesRegex(RuntimeError, "replay mismatch"):
                diagnostic.execute_reserved_diagnostic(
                    output, sentinel, self.metadata(), runner
                )
            self.assertTrue(sentinel.exists())
            self.assertEqual(output.stat().st_size, 0)
            sentinel_text = sentinel.read_text(encoding="utf-8")
            self.assertIn('"status": "failed"', sentinel_text)
            self.assertIn("replay mismatch", sentinel_text)

    def test_source_has_no_selector_gate_or_comparator_calls(self) -> None:
        source = Path(diagnostic.__file__).read_text(encoding="utf-8")
        tree = ast.parse(source)
        called = {
            node.func.id
            for node in ast.walk(tree)
            if isinstance(node, ast.Call) and isinstance(node.func, ast.Name)
        }
        forbidden = {
            "capacity_constrained_greedy",
            "random_priority_feasible",
            "greedy_maximum_coverage",
            "evaluate_capacity_cell",
            "development_decision",
            "heldout_decision",
            "run_phase",
            "run_chained_benchmark",
        }
        self.assertTrue(called.isdisjoint(forbidden))

    def test_protocol_fences_diagnostic_from_trial_and_geometry(self) -> None:
        protocol = diagnostic.frozen_protocol()
        self.assertFalse(protocol["selectors_called"])
        self.assertFalse(protocol["comparators_called"])
        self.assertFalse(protocol["gates_evaluated"])
        self.assertFalse(protocol["independent_trial"])
        self.assertEqual(protocol["heldout_seed_status"], "retired_unconsumed")
        self.assertEqual(protocol["diagnostic_betas"], (0.8, 1.0, 1.25))

    def test_runtime_and_peak_do_not_change_deterministic_hash(self) -> None:
        left = {
            "value": 3,
            "runtime_seconds": 1.0,
            "phase_peak_working_set_bytes": 2,
        }
        right = {
            "value": 3,
            "runtime_seconds": 9.0,
            "phase_peak_working_set_bytes": 8,
        }
        self.assertEqual(
            diagnostic.content_sha256(left, deterministic=True),
            diagnostic.content_sha256(right, deterministic=True),
        )
        self.assertNotEqual(
            diagnostic.content_sha256(left, deterministic=False),
            diagnostic.content_sha256(right, deterministic=False),
        )


if __name__ == "__main__":
    unittest.main()
