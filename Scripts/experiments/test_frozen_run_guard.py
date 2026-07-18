"""Hostile controls for exclusive frozen-run output reservations."""

from __future__ import annotations

import hashlib
import json
import tempfile
import unittest
from pathlib import Path

from frozen_run_guard import (
    FrozenRunConflict,
    FrozenRunReservation,
    FrozenRunSetReservation,
    frozen_run_reservation,
    frozen_run_set_reservation,
)


def metadata() -> dict[str, object]:
    return {
        "work_item": "TEST-FROZEN-001",
        "protocol_sha256": "a" * 64,
        "seed": 17,
    }


class FrozenRunGuardTests(unittest.TestCase):
    def test_context_reserves_output_and_retains_completed_sentinel(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "result.json"
            with frozen_run_reservation(output, metadata()) as reservation:
                self.assertTrue(output.exists())
                self.assertTrue(reservation.sentinel_path.exists())
                output.write_text('{"value":1}\n', encoding="utf-8")
            record = json.loads(reservation.sentinel_path.read_text())
            self.assertEqual(record["status"], "completed")
            self.assertEqual(record["work_item"], "TEST-FROZEN-001")
            self.assertEqual(
                record["output_raw_sha256"],
                hashlib.sha256(output.read_bytes()).hexdigest(),
            )

    def test_concurrent_reservation_is_refused_before_computation(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "result.json"
            first = FrozenRunReservation.acquire(output, metadata())
            with self.assertRaises(FrozenRunConflict):
                FrozenRunReservation.acquire(output, metadata())
            output.write_text("done\n", encoding="utf-8")
            first.complete()

    def test_completed_reservation_cannot_be_reused(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "result.json"
            with frozen_run_reservation(output, metadata()):
                output.write_text("done\n", encoding="utf-8")
            with self.assertRaises(FrozenRunConflict):
                FrozenRunReservation.acquire(output, metadata())

    def test_existing_output_is_refused_without_leaving_new_sentinel(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "result.json"
            output.write_text("existing\n", encoding="utf-8")
            sentinel = output.with_name(output.name + ".run-sentinel.json")
            with self.assertRaises(FrozenRunConflict):
                FrozenRunReservation.acquire(output, metadata())
            self.assertFalse(sentinel.exists())
            self.assertEqual(output.read_text(), "existing\n")

    def test_exception_retains_failed_sentinel_and_reserved_output(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "result.json"
            sentinel = output.with_name(output.name + ".run-sentinel.json")
            with self.assertRaisesRegex(RuntimeError, "test failure"):
                with frozen_run_reservation(output, metadata()):
                    raise RuntimeError("test failure")
            record = json.loads(sentinel.read_text())
            self.assertEqual(record["status"], "failed")
            self.assertIn("test failure", record["failure_reason"])
            self.assertTrue(output.exists())

    def test_empty_success_is_converted_to_durable_failure(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "result.json"
            sentinel = output.with_name(output.name + ".run-sentinel.json")
            with self.assertRaisesRegex(FrozenRunConflict, "not populated"):
                with frozen_run_reservation(output, metadata()):
                    pass
            record = json.loads(sentinel.read_text())
            self.assertEqual(record["status"], "failed")
            self.assertIn("not populated", record["failure_reason"])

    def test_required_provenance_metadata_is_enforced(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "result.json"
            with self.assertRaisesRegex(ValueError, "protocol_sha256"):
                FrozenRunReservation.acquire(
                    output,
                    {"work_item": "TEST", "seed": 1},
                )

    def test_set_reservation_hashes_every_declared_output(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            outputs = (root / "development.json", root / "heldout.json")
            sentinel = root / "run-sentinel.json"
            with frozen_run_set_reservation(
                outputs, sentinel, metadata()
            ) as reservation:
                outputs[0].write_text("development\n", encoding="utf-8")
                outputs[1].write_text("heldout\n", encoding="utf-8")
            record = json.loads(sentinel.read_text())
            self.assertEqual(record["status"], "completed")
            self.assertEqual(record["output_paths"], [str(path) for path in outputs])
            for output in outputs:
                self.assertEqual(
                    record["output_raw_sha256"][str(output)],
                    hashlib.sha256(output.read_bytes()).hexdigest(),
                )
            self.assertEqual(reservation.output_paths, outputs)

    def test_set_reservation_rolls_back_if_later_output_exists(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            first = root / "first.json"
            existing = root / "existing.json"
            sentinel = root / "run-sentinel.json"
            existing.write_text("do not replace\n", encoding="utf-8")
            with self.assertRaises(FrozenRunConflict):
                FrozenRunSetReservation.acquire(
                    (first, existing), sentinel, metadata()
                )
            self.assertFalse(first.exists())
            self.assertFalse(sentinel.exists())
            self.assertEqual(existing.read_text(), "do not replace\n")

    def test_set_reservation_rejects_duplicate_paths(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            output = root / "same.json"
            sentinel = root / "run-sentinel.json"
            with self.assertRaisesRegex(ValueError, "distinct"):
                FrozenRunSetReservation.acquire(
                    (output, output), sentinel, metadata()
                )
            self.assertFalse(output.exists())
            self.assertFalse(sentinel.exists())

    def test_set_reservation_refuses_concurrent_sentinel(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            outputs = (root / "a.json", root / "b.json")
            sentinel = root / "run-sentinel.json"
            first = FrozenRunSetReservation.acquire(outputs, sentinel, metadata())
            with self.assertRaises(FrozenRunConflict):
                FrozenRunSetReservation.acquire(
                    (root / "c.json", root / "d.json"),
                    sentinel,
                    metadata(),
                )
            outputs[0].write_text("a\n", encoding="utf-8")
            outputs[1].write_text("b\n", encoding="utf-8")
            first.complete()

    def test_set_reservation_empty_member_is_durable_failure(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            outputs = (root / "development.json", root / "heldout.json")
            sentinel = root / "run-sentinel.json"
            with self.assertRaises(FrozenRunConflict):
                with frozen_run_set_reservation(outputs, sentinel, metadata()):
                    outputs[0].write_text("development\n", encoding="utf-8")
            record = json.loads(sentinel.read_text())
            self.assertEqual(record["status"], "failed")
            self.assertIn(str(outputs[1]), record["failure_reason"])
            self.assertTrue(all(path.exists() for path in outputs))


if __name__ == "__main__":
    unittest.main()
