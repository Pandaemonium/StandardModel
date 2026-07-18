"""Synthetic-poset tripwires for the marked shell-angular selector."""

from __future__ import annotations

import numpy as np
import pytest

from causal_marked_shell_selector import (
    longest_path_depths,
    matrix_inertia,
    open_interval_count_matrix,
    select_marked_shell_sector,
)


def transitive_closure(events: int, edges: list[tuple[int, int]]) -> np.ndarray:
    relation = np.zeros((events, events), dtype=bool)
    for source, target in edges:
        relation[source, target] = True
    for pivot in range(events):
        relation |= relation[:, [pivot]] & relation[[pivot], :]
    return relation


def marked_shell_control() -> tuple[np.ndarray, int, int, int]:
    bottom = 0
    p0, p1, p2, p3 = 1, 2, 3, 4
    r3, z1, z2, z3 = 5, 6, 7, 8
    r1, z = 9, 10
    shell = [11, 12, 13, 14, 15]
    evaluation, top = 16, 17
    edges = [
        (bottom, p0),
        (bottom, p1),
        (bottom, p2),
        (bottom, p3),
        (bottom, r3),
        (bottom, r1),
        (r3, z1),
        (z1, z2),
        (z2, z3),
        (z3, evaluation),
        (r1, z),
        (z, evaluation),
        (evaluation, top),
    ]
    shell_pasts = [
        (p0, p1),
        (p0, p2),
        (p0, p3),
        (p0, p1, p2),
        (p0, p2, p3),
    ]
    for event, pasts in zip(shell, shell_pasts, strict=True):
        edges.extend((past, event) for past in pasts)
        edges.append((event, evaluation))
    return transitive_closure(18, edges), bottom, evaluation, top


def global_shell_projector(
    events: int, shell: np.ndarray, projector: np.ndarray
) -> np.ndarray:
    result = np.zeros((events, events), dtype=float)
    result[np.ix_(shell, shell)] = projector
    return result


def test_open_counts_and_longest_depths_on_control() -> None:
    relation, bottom, evaluation, _ = marked_shell_control()
    counts = open_interval_count_matrix(relation)
    assert counts[5, evaluation] == 3
    assert counts[9, evaluation] == 1
    assert counts[11, evaluation] == 0
    depths = longest_path_depths(relation, bottom)
    assert depths[bottom] == 0
    assert depths[evaluation] == 5


def test_selector_has_exact_support_and_mostly_minus_tripwires() -> None:
    relation, bottom, evaluation, top = marked_shell_control()
    sector = select_marked_shell_sector(
        relation, bottom, evaluation, top, epsilon_floor=1e-3
    )
    assert len(sector.shell) >= 5
    assert len(sector.radial) >= 1
    assert not np.any(relation[np.ix_(sector.shell, sector.shell)])
    assert not np.intersect1d(sector.shell, sector.radial).size
    assert np.all(sector.time_probe[np.setdiff1d(np.arange(18), sector.radial)] == 0)
    assert np.linalg.matrix_rank(sector.shell_spatial_projector, tol=1e-9) == 3
    assert np.allclose(
        sector.shell_spatial_projector @ sector.shell_spatial_projector,
        sector.shell_spatial_projector,
    )
    assert sector.triplet_gap > 0.0
    assert sector.corrected_inertia == (1, 0, 3)
    assert matrix_inertia(sector.corrected_gram) == (1, 0, 3)
    assert np.allclose(sector.corrected_gram[0, 1:], 0.0, atol=1e-10)
    assert sector.corrected_gram[0, 0] > 0.0
    assert np.all(np.diag(sector.corrected_gram)[1:] < 0.0)


def test_overlap_and_projector_are_relabeling_equivariant() -> None:
    relation, bottom, evaluation, top = marked_shell_control()
    original = select_marked_shell_sector(
        relation, bottom, evaluation, top, epsilon_floor=1e-3
    )
    permutation = np.array(
        [7, 0, 13, 4, 16, 2, 11, 8, 17, 5, 1, 14, 9, 3, 15, 6, 10, 12]
    )
    inverse = np.empty_like(permutation)
    inverse[permutation] = np.arange(len(permutation))
    permuted_relation = relation[np.ix_(permutation, permutation)]
    relabeled = select_marked_shell_sector(
        permuted_relation,
        int(inverse[bottom]),
        int(inverse[evaluation]),
        int(inverse[top]),
        epsilon_floor=1e-3,
    )

    original_projector = global_shell_projector(
        len(relation), original.shell, original.shell_spatial_projector
    )
    relabeled_projector = global_shell_projector(
        len(relation), relabeled.shell, relabeled.shell_spatial_projector
    )
    pulled_back = relabeled_projector[np.ix_(inverse, inverse)]
    assert np.allclose(pulled_back, original_projector, atol=1e-9)
    assert relabeled.corrected_inertia == original.corrected_inertia
    assert relabeled.triplet_gap == pytest.approx(original.triplet_gap)


def test_marking_and_shell_size_fail_closed() -> None:
    relation, bottom, evaluation, top = marked_shell_control()
    with pytest.raises(ValueError, match="bottom < evaluation < top"):
        select_marked_shell_sector(relation, evaluation, bottom, top)

    chain = transitive_closure(4, [(0, 1), (1, 2), (2, 3)])
    with pytest.raises(ValueError, match="shell is too small"):
        select_marked_shell_sector(chain, 0, 2, 3)
