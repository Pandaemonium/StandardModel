"""Exclusive output reservation for result-bearing frozen experiments.

The guard atomically creates a run sentinel and the final output path before
any computation begins.  A concurrent process, stale sentinel, or existing
output therefore causes a hard refusal instead of an overwrite.  Sentinels are
retained after success or failure as provenance records.
"""

from __future__ import annotations

import hashlib
import json
import os
import secrets
from contextlib import contextmanager
from dataclasses import dataclass
from datetime import UTC, datetime
from pathlib import Path
from typing import Iterator, Mapping, Sequence


REQUIRED_METADATA_KEYS = frozenset({"work_item", "protocol_sha256", "seed"})


class FrozenRunConflict(RuntimeError):
    """The frozen output or its run sentinel is already reserved."""


def _timestamp() -> str:
    return datetime.now(UTC).isoformat()


def _json_bytes(record: Mapping[str, object]) -> bytes:
    return (json.dumps(record, indent=2, sort_keys=True) + "\n").encode("utf-8")


def _exclusive_write(path: Path, data: bytes) -> None:
    descriptor = os.open(path, os.O_CREAT | os.O_EXCL | os.O_WRONLY)
    try:
        os.write(descriptor, data)
    finally:
        os.close(descriptor)


def _atomic_replace(path: Path, data: bytes, nonce: str) -> None:
    temporary = path.with_name(f".{path.name}.{nonce}.tmp")
    _exclusive_write(temporary, data)
    os.replace(temporary, path)


@dataclass
class FrozenRunReservation:
    """One exclusive frozen-run reservation and its durable sentinel."""

    output_path: Path
    sentinel_path: Path
    record: dict[str, object]

    @classmethod
    def acquire(
        cls,
        output_path: Path,
        metadata: Mapping[str, object],
    ) -> FrozenRunReservation:
        """Atomically reserve a sentinel and empty output before computation."""

        missing = REQUIRED_METADATA_KEYS - metadata.keys()
        if missing:
            raise ValueError(
                "frozen-run metadata is missing: " + ", ".join(sorted(missing))
            )
        output = Path(output_path)
        if not output.parent.is_dir():
            raise FileNotFoundError(output.parent)
        sentinel = output.with_name(output.name + ".run-sentinel.json")
        nonce = secrets.token_hex(16)
        record: dict[str, object] = {
            "schema_version": 1,
            "status": "acquired",
            "output_path": str(output),
            "sentinel_path": str(sentinel),
            "pid": os.getpid(),
            "run_nonce": nonce,
            "acquired_at": _timestamp(),
            **dict(metadata),
        }
        try:
            _exclusive_write(sentinel, _json_bytes(record))
        except FileExistsError as error:
            raise FrozenRunConflict(
                f"frozen run sentinel already exists: {sentinel}"
            ) from error

        try:
            output_descriptor = os.open(
                output, os.O_CREAT | os.O_EXCL | os.O_WRONLY
            )
            os.close(output_descriptor)
        except FileExistsError as error:
            sentinel.unlink(missing_ok=True)
            raise FrozenRunConflict(
                f"frozen output already exists: {output}"
            ) from error
        except BaseException:
            sentinel.unlink(missing_ok=True)
            raise
        return cls(output, sentinel, record)

    def _set_status(self, status: str, **fields: object) -> None:
        self.record.update(fields)
        self.record["status"] = status
        self.record[f"{status}_at"] = _timestamp()
        _atomic_replace(
            self.sentinel_path,
            _json_bytes(self.record),
            str(self.record["run_nonce"]),
        )

    def complete(self) -> None:
        """Mark a nonempty reserved output complete and archive its raw hash."""

        if not self.output_path.is_file() or self.output_path.stat().st_size == 0:
            self.fail("reserved output was not populated")
            raise FrozenRunConflict("reserved output was not populated")
        raw_hash = hashlib.sha256(self.output_path.read_bytes()).hexdigest()
        self._set_status(
            "completed",
            output_size_bytes=self.output_path.stat().st_size,
            output_raw_sha256=raw_hash,
        )

    def fail(self, reason: str) -> None:
        """Mark a consumed reservation failed without making it reusable."""

        self._set_status("failed", failure_reason=reason)


@contextmanager
def frozen_run_reservation(
    output_path: Path,
    metadata: Mapping[str, object],
) -> Iterator[FrozenRunReservation]:
    """Reserve a frozen output and retain a complete or failed sentinel."""

    reservation = FrozenRunReservation.acquire(output_path, metadata)
    try:
        yield reservation
    except BaseException as error:
        reservation.fail(f"{type(error).__name__}: {error}")
        raise
    else:
        reservation.complete()


@dataclass
class FrozenRunSetReservation:
    """One exclusive reservation covering every declared result path."""

    output_paths: tuple[Path, ...]
    sentinel_path: Path
    record: dict[str, object]

    @classmethod
    def acquire(
        cls,
        output_paths: Sequence[Path],
        sentinel_path: Path,
        metadata: Mapping[str, object],
    ) -> FrozenRunSetReservation:
        """Atomically reserve a sentinel and all outputs before computation."""

        missing = REQUIRED_METADATA_KEYS - metadata.keys()
        if missing:
            raise ValueError(
                "frozen-run metadata is missing: " + ", ".join(sorted(missing))
            )
        outputs = tuple(Path(path) for path in output_paths)
        if not outputs:
            raise ValueError("at least one frozen output path is required")
        if len(set(outputs)) != len(outputs):
            raise ValueError("frozen output paths must be distinct")
        sentinel = Path(sentinel_path)
        if sentinel in outputs:
            raise ValueError("the sentinel path must be distinct from every output")
        if not sentinel.parent.is_dir():
            raise FileNotFoundError(sentinel.parent)
        for output in outputs:
            if not output.parent.is_dir():
                raise FileNotFoundError(output.parent)

        nonce = secrets.token_hex(16)
        record: dict[str, object] = {
            "schema_version": 1,
            "status": "acquired",
            "output_paths": [str(path) for path in outputs],
            "sentinel_path": str(sentinel),
            "pid": os.getpid(),
            "run_nonce": nonce,
            "acquired_at": _timestamp(),
            **dict(metadata),
        }
        try:
            _exclusive_write(sentinel, _json_bytes(record))
        except FileExistsError as error:
            raise FrozenRunConflict(
                f"frozen run sentinel already exists: {sentinel}"
            ) from error

        reserved: list[Path] = []
        try:
            for output in outputs:
                descriptor = os.open(
                    output, os.O_CREAT | os.O_EXCL | os.O_WRONLY
                )
                os.close(descriptor)
                reserved.append(output)
        except FileExistsError as error:
            for output in reserved:
                output.unlink(missing_ok=True)
            sentinel.unlink(missing_ok=True)
            raise FrozenRunConflict(
                f"frozen output already exists: {output}"
            ) from error
        except BaseException:
            for output in reserved:
                output.unlink(missing_ok=True)
            sentinel.unlink(missing_ok=True)
            raise
        return cls(outputs, sentinel, record)

    def _set_status(self, status: str, **fields: object) -> None:
        self.record.update(fields)
        self.record["status"] = status
        self.record[f"{status}_at"] = _timestamp()
        _atomic_replace(
            self.sentinel_path,
            _json_bytes(self.record),
            str(self.record["run_nonce"]),
        )

    def complete(self) -> None:
        """Mark every nonempty output complete and archive its raw hash."""

        empty = [
            str(path)
            for path in self.output_paths
            if not path.is_file() or path.stat().st_size == 0
        ]
        if empty:
            self.fail("reserved output was not populated: " + ", ".join(empty))
            raise FrozenRunConflict("one or more reserved outputs were not populated")
        hashes = {
            str(path): hashlib.sha256(path.read_bytes()).hexdigest()
            for path in self.output_paths
        }
        sizes = {str(path): path.stat().st_size for path in self.output_paths}
        self._set_status(
            "completed",
            output_size_bytes=sizes,
            output_raw_sha256=hashes,
        )

    def fail(self, reason: str) -> None:
        """Mark a consumed output-set reservation failed and non-reusable."""

        self._set_status("failed", failure_reason=reason)


@contextmanager
def frozen_run_set_reservation(
    output_paths: Sequence[Path],
    sentinel_path: Path,
    metadata: Mapping[str, object],
) -> Iterator[FrozenRunSetReservation]:
    """Reserve every frozen output and retain one durable run sentinel."""

    reservation = FrozenRunSetReservation.acquire(
        output_paths, sentinel_path, metadata
    )
    try:
        yield reservation
    except BaseException as error:
        reservation.fail(f"{type(error).__name__}: {error}")
        raise
    else:
        reservation.complete()
