#!/usr/bin/env python3
"""Finite P9 source-visibility pilot.

This script is a numerical companion to the `NullEdgeP9*` draft Lean modules.
It is deliberately small: build a finite chain segment, compute the 1-cochain
Hodge projector, project a finite residual noise kernel, and run a boundary
perturbation regression.

The output is JSON so future runs can be compared without scraping stdout.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any
import math

import numpy as np


@dataclass
class PilotResult:
    run_id: str
    geometry_family: str
    geometry_params: dict[str, Any]
    counts: dict[str, int]
    metrics: dict[str, Any]
    checks: dict[str, Any]
    witnesses: dict[str, float]
    results: dict[str, Any]


def incidence_d0(num_vertices: int, edges: list[tuple[int, int]]) -> np.ndarray:
    """Coboundary from vertex 0-cochains to edge 1-cochains."""
    d0 = np.zeros((len(edges), num_vertices), dtype=float)
    for row, (tail, head) in enumerate(edges):
        d0[row, tail] = -1.0
        d0[row, head] = 1.0
    return d0


def incidence_d1(edges: list[tuple[int, int]], faces: list[list[int]]) -> np.ndarray:
    """Coboundary from edge 1-cochains to face 2-cochains.

    Faces are oriented vertex cycles. Each consecutive vertex pair contributes
    +1 if it matches the stored edge orientation and -1 if reversed.
    """
    edge_index = {edge: i for i, edge in enumerate(edges)}
    edge_index.update({(head, tail): -i - 1 for i, (tail, head) in enumerate(edges)})
    d1 = np.zeros((len(faces), len(edges)), dtype=float)
    for row, face in enumerate(faces):
        for a, b in zip(face, face[1:] + face[:1]):
            idx = edge_index[(a, b)]
            if idx >= 0:
                d1[row, idx] += 1.0
            else:
                d1[row, -idx - 1] -= 1.0
    return d1


def dedupe_edges(edges: list[tuple[int, int]]) -> list[tuple[int, int]]:
    """Dedupe directed and reversed duplicates while preserving first occurrence."""
    kept: list[tuple[int, int]] = []
    seen: set[tuple[int, int]] = set()
    for tail, head in edges:
        if (tail, head) in seen or (head, tail) in seen:
            continue
        kept.append((tail, head))
        seen.add((tail, head))
    return kept


def diamond_strip_geometry(
    num_cells: int, de_sitter: bool
) -> tuple[int, list[tuple[int, int]], list[list[int]], list[float]]:
    """Build a 2-row causal-diamond strip with optional de Sitter-like warp."""
    if num_cells < 2:
        raise ValueError("diamond geometry needs at least 2 cells")

    layers = num_cells + 1
    vertex_times: list[float] = []
    for t in range(layers):
        if de_sitter:
            x = t / num_cells
            warped = (math.exp(1.6 * x) - 1.0) / (math.exp(1.6) - 1.0)
            top = 0.75 * warped
            bottom = 0.9 + 0.25 * (1.0 - warped)
        else:
            top = t / num_cells
            bottom = 0.5 + t / num_cells
        vertex_times.extend([top, bottom])

    edges: list[tuple[int, int]] = []
    for t in range(num_cells):
        upper_t = 2 * t
        lower_t = 2 * t + 1
        upper_tp1 = 2 * (t + 1)
        lower_tp1 = 2 * (t + 1) + 1
        edges.extend(
            [
                (upper_t, upper_tp1),
                (lower_t, lower_tp1),
                (upper_t, lower_tp1),
                (lower_t, upper_tp1),
            ]
        )

    return layers * 2, dedupe_edges(edges), [], vertex_times


def cycle_geometry(size: int) -> tuple[int, list[tuple[int, int]], list[list[int]], list[float]]:
    if size < 3:
        raise ValueError("cycle geometry needs at least 3 vertices")
    edges = [(i, (i + 1) % size) for i in range(size)]
    half = size / 2.0
    times = [min(i, size - i) / half for i in range(size)]
    return size, edges, [], times


def geometry(name: str, cycle_size: int) -> tuple[int, list[tuple[int, int]], list[list[int]], list[float]]:
    if name == "cycle":
        return cycle_geometry(cycle_size)
    if name == "cycle4":
        return 4, [(0, 1), (1, 2), (2, 3), (3, 0)], [], [0.0, 1.0, 2.0, 1.0]
    if name == "filled_triangle":
        return 3, [(0, 1), (1, 2), (0, 2)], [[0, 1, 2]], [0.0, 1.0, 2.0]
    if name == "two_triangle_disk":
        return (
            4,
            [(0, 1), (1, 2), (0, 2), (2, 3), (0, 3)],
            [[0, 1, 2], [0, 2, 3]],
            [0.0, 1.0, 2.0, 3.0],
        )
    if name == "flat_diamond":
        return diamond_strip_geometry(cycle_size, de_sitter=False)
    if name == "de_sitter_diamond":
        return diamond_strip_geometry(cycle_size, de_sitter=True)
    raise ValueError(f"unknown geometry: {name}")


def edge_weights(
    edges: list[tuple[int, int]],
    vertex_times: list[float],
    profile: str,
    expansion_rate: float,
) -> np.ndarray:
    """Return diagonal 1-cochain metric weights.

    `flat` is the identity metric used by the first pilot.  `expanded` is a
    deliberately simple toy profile: edge weights are exponential in midpoint
    time and normalized to mean one.  It is only a stress test for whether the
    harmonic/noise diagnostics are metric-sensitive.
    """
    if profile == "flat":
        return np.ones(len(edges), dtype=float)
    if profile != "expanded":
        raise ValueError(f"unknown metric profile: {profile}")
    mids = np.array([(vertex_times[a] + vertex_times[b]) / 2.0 for a, b in edges])
    weights = np.exp(2.0 * expansion_rate * mids)
    return weights / float(np.mean(weights))


def rank(mat: np.ndarray, tol: float) -> int:
    if mat.size == 0:
        return 0
    return int(np.sum(np.linalg.svd(mat, compute_uv=False) > tol))


def nullspace(mat: np.ndarray, tol: float) -> np.ndarray:
    if mat.size == 0:
        return np.eye(mat.shape[1])
    _, s, vh = np.linalg.svd(mat, full_matrices=True)
    r = int(np.sum(s > tol))
    return vh[r:, :].T


def hodge_projector(
    d0: np.ndarray, d1: np.ndarray, weights1: np.ndarray, tol: float
) -> tuple[np.ndarray, np.ndarray]:
    """Weighted 1-cochain harmonic projector.

    The harmonic subspace is `ker d1 cap ker delta1`, with
    `delta1 = d0.T @ W1` and diagonal `W1`.  The returned matrix is the
    `W1`-orthogonal projector onto this subspace.
    """
    w1 = np.diag(weights1)
    constraints = d0.T @ w1
    if d1.size:
        constraints = np.vstack([constraints, d1])
    basis = nullspace(constraints, tol)
    lap = d0 @ d0.T @ w1
    if d1.size:
        inv_w1 = np.diag(1.0 / weights1)
        lap = lap + inv_w1 @ d1.T @ d1
    sqrt_w = np.diag(np.sqrt(weights1))
    inv_sqrt_w = np.diag(1.0 / np.sqrt(weights1))
    vals = np.linalg.eigvalsh(sqrt_w @ lap @ inv_sqrt_w)
    if basis.shape[1] == 0:
        return np.zeros_like(lap), vals
    gram = basis.T @ w1 @ basis
    return basis @ np.linalg.inv(gram) @ basis.T @ w1, vals


def all_sign_sources(
    num_cells: int,
    amp: np.ndarray,
    rng: np.random.Generator,
    max_mc_samples: int = 2048,
) -> tuple[np.ndarray, np.ndarray]:
    if num_cells <= 12:
        rows = []
        for mask in range(1 << num_cells):
            signs = np.array([1.0 if (mask >> i) & 1 else -1.0 for i in range(num_cells)])
            rows.append(signs * amp)
        sources = np.vstack(rows)
        weights = np.full(len(rows), 1.0 / len(rows))
        return sources, weights

    if max_mc_samples <= 0:
        raise ValueError("max_mc_samples must be positive")
    source_count = min(max_mc_samples, 1 << min(num_cells, 20))
    rows = rng.choice(np.array([-1.0, 1.0]), size=(source_count, num_cells))
    sources = rows * amp
    weights = np.full(source_count, 1.0 / source_count)
    return sources, weights


def noise_kernel(sources: np.ndarray, weights: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    mean = weights @ sources
    centered = sources - mean
    kernel = centered.T @ (centered * weights[:, None])
    return mean, kernel


def positive_condition_number(vals: np.ndarray, tol: float) -> float | None:
    pos = vals[vals > tol]
    if len(pos) == 0:
        return None
    return float(np.max(pos) / np.min(pos))


def parse_coarse_blocks(raw: str) -> list[int]:
    parts = [p.strip() for p in raw.split(",")]
    blocks = []
    for p in parts:
        if not p:
            continue
        n = int(p)
        if n <= 0:
            raise ValueError("coarse block size must be a positive integer")
        blocks.append(n)
    if not blocks:
        raise ValueError("must provide at least one coarse block size")
    # Keep the first instance and then deduplicate to avoid repeated profiles.
    seen: set[int] = set()
    uniq: list[int] = []
    for n in blocks:
        if n in seen:
            continue
        seen.add(n)
        uniq.append(n)
    return uniq


def parse_coarse_offsets(raw: str) -> list[int]:
    parts = [p.strip() for p in raw.split(",")]
    offsets = []
    for p in parts:
        if not p:
            continue
        n = int(p)
        if n < 0:
            raise ValueError("coarse offset must be nonnegative")
        offsets.append(n)
    if not offsets:
        raise ValueError("must provide at least one coarse offset")
    seen: set[int] = set()
    uniq: list[int] = []
    for n in offsets:
        if n in seen:
            continue
        seen.add(n)
        uniq.append(n)
    return uniq


def coarse_projection_profile(
    kernel: np.ndarray, block_sizes: list[int], tol: float, offsets: list[int] | None = None
) -> list[dict[str, Any]]:
    """Coarse-grain projected kernel by disjoint block averaging."""
    if kernel.size == 0:
        return []
    n = kernel.shape[0]
    if offsets is None:
        offsets = [0]
    out: list[dict[str, Any]] = []
    for b in block_sizes:
        if b <= 0:
            raise ValueError(f"invalid coarse block size: {b}")
        for offset in offsets:
            if offset >= n:
                blocks = 0
            else:
                blocks = (n - offset) // b
            if blocks == 0:
                out.append(
                    {
                        "block_size": b,
                        "offset": int(offset),
                        "coarse_edges": 0,
                        "prefix_dropped": int(min(offset, n)),
                        "tail_dropped": int(max(n - offset, 0)),
                        "trace": 0.0,
                        "trace_density": 0.0,
                        "min_eig": 0.0,
                        "max_eig": 0.0,
                        "cond2": None,
                        "psd_ok": False,
                    }
                )
                continue
            tail = n - (offset + blocks * b)
            R = np.zeros((blocks, n), dtype=float)
            scale = 1.0 / math.sqrt(float(b))
            for i in range(blocks):
                start = offset + i * b
                stop = start + b
                R[i, start:stop] = scale
            coarse = R @ kernel @ R.T
            eigs = np.linalg.eigvalsh(coarse)
            psd_ok = bool(np.min(eigs) >= -100 * tol) if len(eigs) else False
            out.append(
                {
                    "block_size": b,
                    "offset": int(offset),
                    "coarse_edges": int(blocks),
                    "prefix_dropped": int(offset),
                    "tail_dropped": int(tail),
                    "trace": float(np.trace(coarse)),
                    "trace_density": float(np.trace(coarse)) / float(blocks),
                    "min_eig": float(np.min(eigs)),
                    "max_eig": float(np.max(eigs)),
                    "cond2": positive_condition_number(eigs, tol),
                    "psd_ok": psd_ok,
                }
            )
    return out


def closed_test_basis(d0: np.ndarray, tol: float) -> np.ndarray:
    """Rows form an orthonormal basis for tests orthogonal to boundary sources."""
    u, s, _ = np.linalg.svd(d0.T, full_matrices=True)
    _ = u
    rank_d0t = int(np.sum(s > tol))
    # Nullspace of d0.T is represented by the last columns of V in SVD of d0.T.
    _, _, vh = np.linalg.svd(d0.T, full_matrices=True)
    return vh[rank_d0t:, :]


def boundary_regression(
    d0: np.ndarray,
    sources: np.ndarray,
    weights: np.ndarray,
    tests: np.ndarray,
    rng: np.random.Generator,
) -> dict[str, float]:
    if tests.size == 0:
        return {"mean_rel_err": 0.0, "noise_rel_err": 0.0}

    potentials = rng.normal(size=(sources.shape[0], d0.shape[1]))
    perturb = potentials @ d0.T
    shifted = sources + perturb

    def responses(src: np.ndarray, test: np.ndarray) -> tuple[float, float]:
        cfg = src @ test
        mean = float(weights @ cfg)
        noise = float(np.sum(weights * (cfg - mean) ** 2))
        return mean, noise

    mean_err = 0.0
    noise_err = 0.0
    for test in tests:
        m0, n0 = responses(sources, test)
        m1, n1 = responses(shifted, test)
        mean_err = max(mean_err, abs(m1 - m0) / max(1.0, abs(m0)))
        noise_err = max(noise_err, abs(n1 - n0) / max(1.0, abs(n0)))
    return {"mean_rel_err": mean_err, "noise_rel_err": noise_err}


def run_pilot(
    name: str,
    tol: float,
    seed: int,
    metric_profile: str,
    expansion_rate: float,
    cycle_size: int,
    coarse_block_sizes: list[int],
    coarse_offsets: list[int] | None = None,
) -> PilotResult:
    rng = np.random.default_rng(seed)
    num_vertices, edges, faces, vertex_times = geometry(name, cycle_size)
    d0 = incidence_d0(num_vertices, edges)
    d1 = incidence_d1(edges, faces)
    num_edges = len(edges)
    weights1 = edge_weights(edges, vertex_times, metric_profile, expansion_rate)

    beta1 = (num_edges - rank(d1, tol)) - rank(d0, tol)
    pi_h, lap_eigs = hodge_projector(d0, d1, weights1, tol)
    harm_dim = rank(pi_h, tol)

    amp = np.ones(num_edges)
    sources, weights = all_sign_sources(num_edges, amp, rng)
    mean, kernel = noise_kernel(sources, weights)
    projected = pi_h @ kernel @ pi_h.T
    noise_eigs = np.linalg.eigvalsh(kernel)
    projected_eigs = np.linalg.eigvalsh(projected)
    cond2 = positive_condition_number(projected_eigs, tol)
    coarse_projection = coarse_projection_profile(
        projected, coarse_block_sizes, tol, coarse_offsets
    )

    tests = closed_test_basis(d0, tol)
    regression = boundary_regression(d0, sources, weights, tests, rng)

    closure = np.array([1.0, -1.0, 0.5])
    plucker_sq = 1.0
    closure_defect_sq = float(closure @ closure)
    energy = float(num_edges)
    moment_mass_sq = energy**2 / 4.0

    checks = {
        **regression,
        "projected_psd_min_eig": float(np.min(projected_eigs)) if len(projected_eigs) else 0.0,
        "boundary_perturb_ok": regression["mean_rel_err"] < 1e-9
        and regression["noise_rel_err"] < 1e-9,
        "projected_psd_ok": bool(np.min(projected_eigs) > -100 * tol) if len(projected_eigs) else True,
        "coarse_projection_ok": all(item["psd_ok"] for item in coarse_projection),
    }

    metrics = {
        "betti1": int(beta1),
        "harm_dim": int(harm_dim),
        "laplacian_eigs": lap_eigs.tolist(),
        "noise_eigs": noise_eigs.tolist(),
        "projected_noise_eigs": projected_eigs.tolist(),
        "projected_noise_trace": float(np.trace(projected)),
        "projected_noise_cond2": cond2,
        "mean_norm": float(np.linalg.norm(mean)),
        "metric_weight_spread": float(np.max(weights1) / np.min(weights1)),
        "coarse_projection": coarse_projection,
    }

    witnesses = {
        "pluckerSq": plucker_sq,
        "closureDefectSq": closure_defect_sq,
        "momentMassSq": moment_mass_sq,
        "unitVisiblePairing": moment_mass_sq,
    }

    results = {
        "positive_signal": (
            checks["boundary_perturb_ok"]
            and checks["projected_psd_ok"]
            and checks["coarse_projection_ok"]
        ),
        "demote_if": [
            "boundary perturbation regression fails",
            "harmonic trace scales like volume in size sweep",
            "projected kernel loses positive-semidefiniteness",
            "condition number grows rapidly under refinement",
            "geometry movement does not persist under coarse projection",
        ],
    }

    return PilotResult(
        run_id=f"{name}-seed{seed}",
        geometry_family=name,
        geometry_params={
            "edges": edges,
            "faces": faces,
            "vertex_times": vertex_times,
            "edge_weights": weights1.tolist(),
            "metric_profile": metric_profile,
            "expansion_rate": expansion_rate,
            "cycle_size": cycle_size,
            "coarse_block_sizes": coarse_block_sizes,
            "coarse_offsets": [0] if coarse_offsets is None else coarse_offsets,
            "tol": tol,
            "seed": seed,
        },
        counts={"V": num_vertices, "E": num_edges, "F": len(faces), "configs": len(sources)},
        metrics=metrics,
        checks=checks,
        witnesses=witnesses,
        results=results,
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--geometry",
        choices=[
            "cycle",
            "cycle4",
            "filled_triangle",
            "two_triangle_disk",
            "flat_diamond",
            "de_sitter_diamond",
        ],
        default="cycle4",
    )
    parser.add_argument("--cycle-size", type=int, default=4)
    parser.add_argument("--tol", type=float, default=1e-9)
    parser.add_argument("--seed", type=int, default=0)
    parser.add_argument("--metric-profile", choices=["flat", "expanded"], default="flat")
    parser.add_argument("--expansion-rate", type=float, default=0.35)
    parser.add_argument(
        "--coarse-block-sizes",
        default="1,2,4",
        help="comma-separated coarse block sizes for projected-kernel profile",
    )
    parser.add_argument(
        "--coarse-offsets",
        default="0",
        help="comma-separated offsets for block-grid aliasing sweeps",
    )
    parser.add_argument("--out", type=Path)
    args = parser.parse_args()
    coarse_block_sizes = parse_coarse_blocks(args.coarse_block_sizes)
    coarse_offsets = parse_coarse_offsets(args.coarse_offsets)

    result = run_pilot(
        args.geometry,
        args.tol,
        args.seed,
        args.metric_profile,
        args.expansion_rate,
        args.cycle_size,
        coarse_block_sizes,
        coarse_offsets,
    )
    payload = asdict(result)
    text = json.dumps(payload, indent=2, sort_keys=True)
    if args.out:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(text + "\n", encoding="utf-8")
    print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
