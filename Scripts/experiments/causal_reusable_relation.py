"""Reusable bit-packed causal relation for exact regional interval counts.

The cache stores the strict transitive relation, not embedding distances or a
coordinate-selected neighborhood. Coordinates are used only to construct the
flat-space oracle relation. Once built, global depths and every marked-pivot
interval count are recovered from order bits alone.

Rows are packed little-endian so event ``j`` is bit ``j % 8`` of byte
``j // 8``. A disk-backed cache therefore uses exactly
``events * ceil(events / 8)`` bytes, apart from filesystem metadata.
"""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

import numpy as np

from causal_operator_metric import strictly_precedes


_BYTE_POPCOUNT = np.unpackbits(
    np.arange(256, dtype=np.uint8)[:, None], axis=1
).sum(axis=1, dtype=np.uint8)


def packed_relation_bytes(events: int) -> int:
    """Return exact raw storage for an ``events`` by ``events`` bit matrix."""

    if events < 0:
        raise ValueError("events must be nonnegative")
    return events * ((events + 7) // 8)


def relation_scratch_upper_bound_bytes(
    row_block_size: int, column_block_size: int
) -> int:
    """Conservative bound for one broadcasted relation-construction block.

    ``strictly_precedes`` materializes one four-component ``float64`` delta,
    one ``float64`` spatial-square reduction, and several boolean masks. The
    factor 41 safely covers those arrays without depending on allocator reuse.
    """

    if row_block_size <= 0 or column_block_size <= 0:
        raise ValueError("block sizes must be positive")
    return 41 * row_block_size * column_block_size


@dataclass
class PackedCausalRelation:
    """Bit-packed strict relation with reusable global and interval counts."""

    packed_rows: np.ndarray
    past_count: np.ndarray
    future_count: np.ndarray

    def __post_init__(self) -> None:
        events = len(self.past_count)
        expected_shape = (events, (events + 7) // 8)
        if self.packed_rows.shape != expected_shape:
            raise ValueError("packed relation has the wrong shape")
        if self.packed_rows.dtype != np.uint8:
            raise ValueError("packed relation must use uint8 rows")
        if self.future_count.shape != (events,):
            raise ValueError("future count has the wrong shape")

    @property
    def events(self) -> int:
        return len(self.past_count)

    @property
    def bytes_per_row(self) -> int:
        return self.packed_rows.shape[1]

    @property
    def storage_bytes(self) -> int:
        return int(self.packed_rows.nbytes)

    def dense_relation(self) -> np.ndarray:
        """Unpack the cache for small-fixture verification only."""

        return np.unpackbits(
            self.packed_rows,
            axis=1,
            count=self.events,
            bitorder="little",
        ).astype(bool)

    def past_mask(self, pivot_index: int) -> np.ndarray:
        """Return the strict-past column of ``pivot_index``."""

        if pivot_index < 0 or pivot_index >= self.events:
            raise IndexError("pivot index is outside the relation")
        byte_index, bit_index = divmod(pivot_index, 8)
        return (
            (self.packed_rows[:, byte_index] >> bit_index) & np.uint8(1)
        ).astype(bool)

    def interval_counts_to_pivot(
        self, pivot_index: int, row_block_size: int = 256
    ) -> tuple[np.ndarray, np.ndarray]:
        """Return predecessors and exact open-interval counts to one pivot."""

        if row_block_size <= 0:
            raise ValueError("row block size must be positive")
        past = self.past_mask(pivot_index)
        past_indices = np.flatnonzero(past)
        pivot_past_bytes = np.packbits(past, bitorder="little")
        interval_count = np.zeros(len(past_indices), dtype=np.int64)
        for start in range(0, len(past_indices), row_block_size):
            stop = min(start + row_block_size, len(past_indices))
            rows = self.packed_rows[past_indices[start:stop]]
            shared = np.bitwise_and(rows, pivot_past_bytes[None, :])
            interval_count[start:stop] = np.sum(
                _BYTE_POPCOUNT[shared], axis=1, dtype=np.int64
            )
        return past_indices, interval_count

    def marked_past_statistics(
        self, pivot_index: int, row_block_size: int = 256
    ) -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
        """Match ``causal_discrete_germ_moments.marked_past_statistics``."""

        past_indices, interval_count = self.interval_counts_to_pivot(
            pivot_index, row_block_size
        )
        return (
            past_indices,
            self.past_count[past_indices].copy(),
            self.future_count[past_indices].copy(),
            interval_count,
        )

    def flush(self) -> None:
        """Flush a disk-backed cache; in-memory arrays need no action."""

        if isinstance(self.packed_rows, np.memmap):
            self.packed_rows.flush()

    def close(self) -> None:
        """Close a disk-backed cache so temporary files can be removed."""

        if isinstance(self.packed_rows, np.memmap):
            self.packed_rows.flush()
            mmap = getattr(self.packed_rows, "_mmap", None)
            if mmap is not None:
                mmap.close()


def build_packed_causal_relation(
    points: np.ndarray,
    row_block_size: int = 32,
    column_block_size: int = 8192,
    storage_path: Path | None = None,
) -> PackedCausalRelation:
    """Build the exact strict relation once in bounded two-dimensional blocks."""

    if points.ndim != 2 or points.shape[1] != 4:
        raise ValueError("points must have shape (N, 4)")
    if row_block_size <= 0 or column_block_size <= 0:
        raise ValueError("block sizes must be positive")
    if column_block_size % 8 != 0:
        raise ValueError("column block size must be divisible by eight")

    events = len(points)
    bytes_per_row = (events + 7) // 8
    shape = (events, bytes_per_row)
    if storage_path is None:
        packed_rows: np.ndarray = np.zeros(shape, dtype=np.uint8)
    else:
        storage_path.parent.mkdir(parents=True, exist_ok=True)
        packed_rows = np.memmap(
            storage_path, dtype=np.uint8, mode="w+", shape=shape
        )
        packed_rows[:] = 0

    past_count = np.zeros(events, dtype=np.int64)
    future_count = np.zeros(events, dtype=np.int64)
    for row_start in range(0, events, row_block_size):
        row_stop = min(row_start + row_block_size, events)
        for column_start in range(0, events, column_block_size):
            column_stop = min(column_start + column_block_size, events)
            relation = strictly_precedes(
                points[row_start:row_stop, None, :],
                points[None, column_start:column_stop, :],
            )
            future_count[row_start:row_stop] += np.count_nonzero(
                relation, axis=1
            )
            past_count[column_start:column_stop] += np.count_nonzero(
                relation, axis=0
            )
            byte_start = column_start // 8
            byte_stop = (column_stop + 7) // 8
            packed_rows[
                row_start:row_stop, byte_start:byte_stop
            ] = np.packbits(relation, axis=1, bitorder="little")

    cache = PackedCausalRelation(packed_rows, past_count, future_count)
    cache.flush()
    return cache
