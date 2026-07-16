"""Finite causal-overlap counts and conditional distance conversions.

This is the experiment-side companion to
``PhysicsSM/Draft/NullEdge/FiniteCausalOverlap.lean``. It implements the exact
common-Alexandrov count ratio of Boguna and Krioukov, arXiv:2401.17376, and the
source's conditional 1+1 distance formula.

The overlap is intrinsic to a supplied strict order. Proper time, dimension,
and absolute scale remain supplied inputs to any distance conversion.
"""

from __future__ import annotations

from dataclasses import dataclass

import numpy as np


@dataclass(frozen=True)
class CausalOverlapCounts:
    common_count: int
    left_interval_count: int
    right_interval_count: int
    overlap: float


def validate_strict_order(relation: np.ndarray) -> None:
    if relation.ndim != 2 or relation.shape[0] != relation.shape[1]:
        raise ValueError("relation must be a square matrix")
    if relation.dtype != np.bool_:
        raise ValueError("relation must have Boolean dtype")
    if np.any(np.diag(relation)):
        raise ValueError("strict order must be irreflexive")
    composed = (relation.astype(np.uint8) @ relation.astype(np.uint8)) > 0
    if np.any(composed & ~relation):
        raise ValueError("strict order must be transitive")


def causal_overlap_counts(
    relation: np.ndarray, common_past: int, left: int, right: int
) -> CausalOverlapCounts:
    """Count the common region and return its smaller-interval ratio."""

    validate_strict_order(relation)
    events = len(relation)
    if not all(0 <= index < events for index in (common_past, left, right)):
        raise ValueError("event index out of range")
    left_interval = relation[common_past] & relation[:, left]
    right_interval = relation[common_past] & relation[:, right]
    common_interval = left_interval & right_interval
    left_count = int(np.count_nonzero(left_interval))
    right_count = int(np.count_nonzero(right_interval))
    common_count = int(np.count_nonzero(common_interval))
    denominator = min(left_count, right_count)
    overlap = common_count / denominator if denominator else 0.0
    return CausalOverlapCounts(
        common_count=common_count,
        left_interval_count=left_count,
        right_interval_count=right_count,
        overlap=float(overlap),
    )


def overlap_distance_1p1(proper_time: float, overlap: float) -> float:
    """Exact source conversion ``tau*(1-O)/sqrt(O)`` for positive `O`."""

    if proper_time < 0.0:
        raise ValueError("proper time must be nonnegative")
    if not 0.0 < overlap <= 1.0:
        raise ValueError("1+1 distance conversion requires 0 < overlap <= 1")
    return float(proper_time * (1.0 - overlap) / np.sqrt(overlap))


def asymptotic_overlap_distance_proxy(
    dimension_coefficient: float, proper_time: float, overlap: float
) -> float:
    """Finite expression inside the source's large-proper-time limit."""

    if dimension_coefficient <= 0.0:
        raise ValueError("dimension coefficient must be positive")
    if proper_time < 0.0 or not 0.0 <= overlap <= 1.0:
        raise ValueError("require nonnegative proper time and overlap in [0,1]")
    return float(2.0 * proper_time * (1.0 - overlap) / dimension_coefficient)
