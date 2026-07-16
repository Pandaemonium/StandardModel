"""Order-only regional rows and exact same-graph covariance accounting.

This Stage A44 support module extends the compact tapered A42 operator from one
marked pivot to a relabeling-covariant set of count-deep pivots. It also
decomposes the empirical second moment of each regional mean into its exact
diagonal and off-diagonal same-graph contributions.

No random benchmark settings or pass thresholds live here. Continuum targets,
intrinsic probe selection, and concentration remain separate protocol steps.
"""

from __future__ import annotations

from dataclasses import dataclass

import numpy as np

from causal_continuum_kernel_moments import FIELD_NAMES, CutoffProfile
from causal_discrete_germ_moments import (
    marked_past_statistics,
    marked_row_data,
    oracle_polynomial_fields,
)
from causal_operator_metric import strictly_precedes
from causal_reusable_relation import PackedCausalRelation


REGIONAL_FIELD_NAMES = (
    "constant",
    "affine_t",
    "affine_x",
    "affine_y",
    "affine_z",
    "quadratic_t_t",
    "quadratic_t_x",
    "quadratic_t_y",
    "quadratic_t_z",
    "quadratic_x_x",
    "quadratic_x_y",
    "quadratic_x_z",
    "quadratic_y_y",
    "quadratic_y_z",
    "quadratic_z_z",
    "cubic_t_t_t",
    "cubic_t_x_x",
)


@dataclass(frozen=True)
class RegionalRealization:
    pivot_indices: list[int]
    pivot_depths: list[int]
    depth_threshold: int
    responses: dict[str, list[float]]


def global_order_counts(
    points: np.ndarray, block_size: int
) -> tuple[np.ndarray, np.ndarray]:
    """Return strict global past and future counts without a dense order matrix."""

    if block_size <= 0:
        raise ValueError("block size must be positive")
    events = len(points)
    past = np.zeros(events, dtype=np.int64)
    future = np.zeros(events, dtype=np.int64)
    for start in range(0, events, block_size):
        stop = min(start + block_size, events)
        relation = strictly_precedes(
            points[start:stop, None, :], points[None, :, :]
        )
        future[start:stop] = np.count_nonzero(relation, axis=1)
        past += np.count_nonzero(relation, axis=0)
    return past, future


def select_deep_pivots(
    past_count: np.ndarray,
    future_count: np.ndarray,
    minimum_pivots: int,
    excluded_indices: tuple[int, ...] = (),
) -> tuple[np.ndarray, np.ndarray, int]:
    """Select the deepest invariant set, retaining every threshold tie.

    The threshold is the `minimum_pivots`-th largest value of
    `min(past_count, future_count)` among eligible events. Every event at or
    above that threshold is retained, so relabeling cannot break a count tie.
    """

    if past_count.shape != future_count.shape or past_count.ndim != 1:
        raise ValueError("past and future counts must be matching vectors")
    if minimum_pivots <= 0:
        raise ValueError("minimum pivots must be positive")
    eligible = np.ones(len(past_count), dtype=bool)
    for index in excluded_indices:
        if index < 0 or index >= len(eligible):
            raise ValueError("excluded pivot index out of range")
        eligible[index] = False
    eligible_depth = np.minimum(past_count, future_count)[eligible]
    if len(eligible_depth) < minimum_pivots:
        raise ValueError("not enough eligible events for the requested pivots")
    partition_index = len(eligible_depth) - minimum_pivots
    threshold = int(np.partition(eligible_depth, partition_index)[partition_index])
    depth = np.minimum(past_count, future_count)
    selected = np.flatnonzero(eligible & (depth >= threshold))
    return selected, depth[selected], threshold


def expanded_oracle_polynomial_fields(
    points: np.ndarray, pivot_index: int, cutoff: np.ndarray
) -> dict[str, np.ndarray]:
    """Return affine probes and the full symmetric quadratic envelope."""

    centered = points - points[pivot_index]
    fields: dict[str, np.ndarray] = {"constant": cutoff}
    coordinate_names = ("t", "x", "y", "z")
    for mu, name in enumerate(coordinate_names):
        fields[f"affine_{name}"] = cutoff * centered[:, mu]
    for mu, left_name in enumerate(coordinate_names):
        for nu in range(mu, 4):
            right_name = coordinate_names[nu]
            fields[f"quadratic_{left_name}_{right_name}"] = (
                cutoff * centered[:, mu] * centered[:, nu]
            )
    fields["cubic_t_t_t"] = cutoff * centered[:, 0] ** 3
    fields["cubic_t_x_x"] = cutoff * centered[:, 0] * centered[:, 1] ** 2
    if tuple(fields) != REGIONAL_FIELD_NAMES:
        raise AssertionError("expanded regional field order drifted")
    return fields


def regional_pivot_responses(
    points: np.ndarray,
    bottom_index: int,
    top_index: int,
    random_events: int,
    duration: float,
    nonlocality_ratio: float,
    profile: CutoffProfile,
    minimum_pivots: int,
    block_size: int,
    relation_cache: PackedCausalRelation | None = None,
    expanded_fields: bool = False,
) -> RegionalRealization:
    """Evaluate centered compact-germ polynomial rows at count-deep pivots."""

    if relation_cache is not None and relation_cache.events != len(points):
        raise ValueError("relation cache and point array have different sizes")
    past_count, future_count = (
        global_order_counts(points, block_size)
        if relation_cache is None
        else (relation_cache.past_count, relation_cache.future_count)
    )
    pivots, pivot_depths, threshold = select_deep_pivots(
        past_count,
        future_count,
        minimum_pivots,
        excluded_indices=(bottom_index, top_index),
    )
    response_names = REGIONAL_FIELD_NAMES if expanded_fields else FIELD_NAMES
    responses = {name: [] for name in response_names}
    for pivot_index in pivots:
        statistics = (
            marked_past_statistics(points, int(pivot_index), block_size)
            if relation_cache is None
            else relation_cache.marked_past_statistics(
                int(pivot_index), block_size
            )
        )
        row_data = marked_row_data(
            points,
            bottom_index,
            int(pivot_index),
            top_index,
            random_events,
            duration,
            nonlocality_ratio,
            profile,
            block_size,
            statistics,
        )
        fields = (
            expanded_oracle_polynomial_fields(
                points, int(pivot_index), row_data.cutoff
            )
            if expanded_fields
            else oracle_polynomial_fields(
                points, int(pivot_index), row_data.cutoff
            )
        )
        for name in response_names:
            responses[name].append(float(row_data.row @ fields[name]))
    return RegionalRealization(
        pivot_indices=[int(index) for index in pivots],
        pivot_depths=[int(value) for value in pivot_depths],
        depth_threshold=threshold,
        responses=responses,
    )


def covariance_ledger(
    realizations: list[RegionalRealization],
) -> dict[str, object]:
    """Decompose regional-mean variation into exact diagonal/off-diagonal terms.

    For field `f`, let `mu` be the equal-realization mean of the regional
    means and `r_gi = B_gi(f)-mu`. For each graph `g`,

    `(mean_i r_gi)^2 = sum_i r_gi^2/m_g^2
                        + sum_(i != j) r_gi*r_gj/m_g^2`.

    Averaging this identity over graphs gives the reported ledger. The
    off-diagonal term therefore includes all overlap and shared-sprinkling
    covariance present in the sample; it is not inferred from independent
    rows.
    """

    if not realizations:
        raise ValueError("at least one regional realization is required")
    fields = tuple(realizations[0].responses)
    if not fields:
        raise ValueError("regional realization must contain fields")
    for realization in realizations:
        if set(realization.responses) != set(fields):
            raise ValueError("regional field sets do not match")
        lengths = {len(values) for values in realization.responses.values()}
        if lengths != {len(realization.pivot_indices)} or not realization.pivot_indices:
            raise ValueError("every field needs one value per nonempty pivot set")

    ledger: dict[str, dict[str, float | None]] = {}
    for name in fields:
        arrays = [np.asarray(item.responses[name], dtype=float) for item in realizations]
        graph_means = np.array([np.mean(values) for values in arrays])
        grand_mean = float(np.mean(graph_means))
        diagonal_terms: list[float] = []
        off_diagonal_terms: list[float] = []
        single_row_second_moments: list[float] = []
        direct_terms: list[float] = []
        for values in arrays:
            residual = values - grand_mean
            count = len(residual)
            diagonal = float(np.sum(residual**2) / count**2)
            total = float(np.mean(residual) ** 2)
            diagonal_terms.append(diagonal)
            off_diagonal_terms.append(total - diagonal)
            single_row_second_moments.append(float(np.mean(residual**2)))
            direct_terms.append(total)
        diagonal_contribution = float(np.mean(diagonal_terms))
        off_diagonal_contribution = float(np.mean(off_diagonal_terms))
        regional_mean_second_moment = float(np.mean(direct_terms))
        single_row_second_moment = float(np.mean(single_row_second_moments))
        effective_pivot_count = (
            single_row_second_moment / regional_mean_second_moment
            if regional_mean_second_moment > 1.0e-30
            else None
        )
        ledger[name] = {
            "grand_mean": grand_mean,
            "single_row_second_moment": single_row_second_moment,
            "diagonal_contribution": diagonal_contribution,
            "off_diagonal_contribution": off_diagonal_contribution,
            "regional_mean_second_moment": regional_mean_second_moment,
            "decomposition_error": abs(
                regional_mean_second_moment
                - diagonal_contribution
                - off_diagonal_contribution
            ),
            "effective_pivot_count": effective_pivot_count,
        }
    return {
        "realizations": len(realizations),
        "pivot_counts": [len(item.pivot_indices) for item in realizations],
        "mean_pivot_count": float(
            np.mean([len(item.pivot_indices) for item in realizations])
        ),
        "fields": ledger,
    }
