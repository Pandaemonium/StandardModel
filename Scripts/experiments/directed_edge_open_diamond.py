"""Numerical oracle for unitary directed-edge walks on an open 3D diamond.

This is an external experiment, not a proof.  It tests the smallest real-time
completion suggested by the open-causal-diamond route:

* vertices are integer points in an L1 ball in Z^3;
* states live on directed nearest-neighbor edges;
* one update scatters an incoming edge into an outgoing edge at its head;
* every local scattering block is unitary, including at the boundary.

The script compares Grover and discrete-Fourier vertex coins and reports exact
global-unitarity residuals, zero/pi quasienergy counts, and boundary weights of
the corresponding eigenvectors.  It also tests a different disposition of the
surface spectrum: finite-time decoupling of a fixed deep-interior transition
amplitude as the boundary recedes.  A localized zero/pi mode is therefore a
kill signal only if its interior influence fails to decouple in the scaling
regime, not merely because the surface mode exists.
"""

from __future__ import annotations

import argparse
import json
from itertools import product

import numpy as np


Vertex = tuple[int, int, int]
DirectedEdge = tuple[Vertex, Vertex]


AXES: tuple[Vertex, ...] = (
    (1, 0, 0),
    (-1, 0, 0),
    (0, 1, 0),
    (0, -1, 0),
    (0, 0, 1),
    (0, 0, -1),
)


def add(x: Vertex, y: Vertex) -> Vertex:
    return (x[0] + y[0], x[1] + y[1], x[2] + y[2])


def l1(x: Vertex) -> int:
    return abs(x[0]) + abs(x[1]) + abs(x[2])


def diamond(radius: int) -> tuple[list[Vertex], dict[Vertex, list[Vertex]]]:
    vertices = [
        (x, y, z)
        for x, y, z in product(range(-radius, radius + 1), repeat=3)
        if abs(x) + abs(y) + abs(z) <= radius
    ]
    vertex_set = set(vertices)
    neighbors = {
        v: sorted(add(v, step) for step in AXES if add(v, step) in vertex_set)
        for v in vertices
    }
    return sorted(vertices), neighbors


def coin_matrix(degree: int, coin: str) -> np.ndarray:
    if coin == "grover":
        return 2.0 * np.ones((degree, degree), dtype=complex) / degree - np.eye(
            degree, dtype=complex
        )
    if coin == "fourier":
        roots = np.arange(degree)
        return np.exp(2j * np.pi * np.outer(roots, roots) / degree) / np.sqrt(degree)
    raise ValueError(f"unknown coin: {coin}")


def walk_matrix(
    neighbors: dict[Vertex, list[Vertex]], coin: str
) -> tuple[np.ndarray, list[DirectedEdge]]:
    edges = sorted((u, v) for u, ns in neighbors.items() for v in ns)
    edge_index = {edge: i for i, edge in enumerate(edges)}
    update = np.zeros((len(edges), len(edges)), dtype=complex)

    for v, ns in neighbors.items():
        local = coin_matrix(len(ns), coin)
        for incoming_index, u in enumerate(ns):
            source = edge_index[(u, v)]
            for outgoing_index, w in enumerate(ns):
                target = edge_index[(v, w)]
                update[target, source] = local[outgoing_index, incoming_index]
    return update, edges


def cluster_subspace_boundary_spectrum(
    eigenvalues: np.ndarray,
    eigenvectors: np.ndarray,
    boundary_mask: np.ndarray,
    target: complex,
    tolerance: float,
) -> dict[str, object]:
    indices = np.flatnonzero(np.abs(eigenvalues - target) <= tolerance)
    if len(indices) == 0:
        return {
            "multiplicity": 0,
            "boundary_compression_eigenvalues": [],
            "max_boundary_weight": 0.0,
        }

    basis = eigenvectors[:, indices]
    basis, _ = np.linalg.qr(basis)
    boundary_projector = np.diag(boundary_mask.astype(float))
    compression = basis.conj().T @ boundary_projector @ basis
    weights = np.linalg.eigvalsh(compression).real
    return {
        "multiplicity": int(len(indices)),
        "boundary_compression_eigenvalues": [float(x) for x in weights],
        "max_boundary_weight": float(np.max(weights)),
    }


def nearest_mode_summary(
    eigenvalues: np.ndarray,
    eigenvectors: np.ndarray,
    boundary_mask: np.ndarray,
    target: complex,
) -> dict[str, float]:
    index = int(np.argmin(np.abs(eigenvalues - target)))
    vector = eigenvectors[:, index]
    probabilities = np.abs(vector) ** 2
    probabilities = probabilities / probabilities.sum()
    return {
        "distance_to_target": float(abs(eigenvalues[index] - target)),
        "phase": float(np.angle(eigenvalues[index])),
        "boundary_weight": float(probabilities[boundary_mask].sum()),
        "inverse_participation_ratio": float(np.sum(probabilities**2)),
    }


def finite_time_interior_summary(
    update: np.ndarray,
    edges: list[DirectedEdge],
    boundary_mask: np.ndarray,
    separation: int,
    steps: int,
) -> dict[str, object]:
    """Track one fixed interior edge-to-edge amplitude and boundary leakage.

    The source is an edge entering the origin from negative x.  The target is
    an edge entering `(separation, 0, 0)` from its negative-x neighbor.  When a
    requested edge is absent, the radius is too small for this OD5-min test.
    """

    source: DirectedEdge = ((-1, 0, 0), (0, 0, 0))
    target: DirectedEdge = (
        (separation - 1, 0, 0),
        (separation, 0, 0),
    )
    edge_index = {edge: i for i, edge in enumerate(edges)}
    if source not in edge_index or target not in edge_index:
        return {
            "available": False,
            "source": source,
            "target": target,
            "reason": "requested source or target edge is outside the diamond",
        }

    state = np.zeros(len(edges), dtype=complex)
    state[edge_index[source]] = 1.0
    target_index = edge_index[target]
    trajectory = []
    for time in range(steps + 1):
        amplitude = state[target_index]
        probabilities = np.abs(state) ** 2
        trajectory.append(
            {
                "time": time,
                "target_amplitude_re": float(amplitude.real),
                "target_amplitude_im": float(amplitude.imag),
                "boundary_probability": float(probabilities[boundary_mask].sum()),
                "norm_error": float(abs(probabilities.sum() - 1.0)),
            }
        )
        state = update @ state

    return {
        "available": True,
        "source": source,
        "target": target,
        "separation": separation,
        "steps": steps,
        "trajectory": trajectory,
    }


def analyze(
    radius: int,
    coin: str,
    tolerance: float,
    separation: int,
    decoupling_steps: int,
    decoupling_only: bool,
) -> dict[str, object]:
    vertices, neighbors = diamond(radius)
    update, edges = walk_matrix(neighbors, coin)
    identity = np.eye(update.shape[0], dtype=complex)
    unitarity_error = float(np.linalg.norm(update.conj().T @ update - identity, ord=2))

    boundary_vertices = {v for v in vertices if len(neighbors[v]) < len(AXES)}
    boundary_mask = np.array(
        [u in boundary_vertices or v in boundary_vertices for u, v in edges]
    )

    result: dict[str, object] = {
        "radius": radius,
        "coin": coin,
        "vertices": len(vertices),
        "directed_edges": len(edges),
        "boundary_vertices": len(boundary_vertices),
        "unitarity_error": unitarity_error,
        "interior_decoupling": finite_time_interior_summary(
            update, edges, boundary_mask, separation, decoupling_steps
        ),
        "passed_unitarity": unitarity_error < 1e-10,
    }
    if decoupling_only:
        return result

    eigenvalues, eigenvectors = np.linalg.eig(update)

    zero = cluster_subspace_boundary_spectrum(
        eigenvalues, eigenvectors, boundary_mask, 1.0 + 0j, tolerance
    )
    pi = cluster_subspace_boundary_spectrum(
        eigenvalues, eigenvectors, boundary_mask, -1.0 + 0j, tolerance
    )
    phases = np.angle(eigenvalues)

    result.update({
        "max_eigenvalue_modulus_error": float(np.max(np.abs(np.abs(eigenvalues) - 1))),
        "nearest_zero_phase": float(np.min(np.abs(phases))),
        "nearest_pi_phase": float(np.min(np.abs(np.abs(phases) - np.pi))),
        "zero_subspace": zero,
        "pi_subspace": pi,
        "nearest_zero_mode": nearest_mode_summary(
            eigenvalues, eigenvectors, boundary_mask, 1.0 + 0j
        ),
        "nearest_pi_mode": nearest_mode_summary(
            eigenvalues, eigenvectors, boundary_mask, -1.0 + 0j
        ),
    })
    return result


def compare_interior_trajectories(results: list[dict[str, object]]) -> list[dict[str, object]]:
    """Compare each fixed-coin trajectory with the largest-radius reference."""

    comparisons = []
    for coin in sorted({str(result["coin"]) for result in results}):
        coin_results = sorted(
            (result for result in results if result["coin"] == coin),
            key=lambda result: int(result["radius"]),
        )
        available = [
            result
            for result in coin_results
            if result["interior_decoupling"]["available"]  # type: ignore[index]
        ]
        if not available:
            continue
        reference = available[-1]
        reference_trajectory = reference["interior_decoupling"]["trajectory"]  # type: ignore[index]
        radius_errors = []
        for result in available:
            trajectory = result["interior_decoupling"]["trajectory"]  # type: ignore[index]
            errors = [
                abs(
                    complex(
                        sample["target_amplitude_re"],
                        sample["target_amplitude_im"],
                    )
                    - complex(
                        reference_sample["target_amplitude_re"],
                        reference_sample["target_amplitude_im"],
                    )
                )
                for sample, reference_sample in zip(trajectory, reference_trajectory)
            ]
            radius_errors.append(
                {
                    "radius": result["radius"],
                    "max_target_amplitude_difference": float(max(errors, default=0.0)),
                }
            )
        comparisons.append(
            {
                "coin": coin,
                "reference_radius": reference["radius"],
                "radius_errors": radius_errors,
            }
        )
    return comparisons


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--radii", nargs="+", type=int, default=[1, 2, 3])
    parser.add_argument("--coins", nargs="+", choices=["grover", "fourier"], default=["grover", "fourier"])
    parser.add_argument("--tolerance", type=float, default=1e-8)
    parser.add_argument("--separation", type=int, default=1)
    parser.add_argument("--decoupling-steps", type=int, default=4)
    parser.add_argument(
        "--decoupling-only",
        action="store_true",
        help="skip full diagonalization and run only unitarity/interior propagation",
    )
    args = parser.parse_args()

    results = [
        analyze(
            radius,
            coin,
            args.tolerance,
            args.separation,
            args.decoupling_steps,
            args.decoupling_only,
        )
        for radius in args.radii
        for coin in args.coins
    ]
    payload = {
        "experiment": "directed-edge-open-diamond",
        "interpretation": (
            "Oracle only. Exact unitarity validates the architecture; zero/pi "
            "multiplicity or boundary weight diagnoses a particular coin; "
            "finite-time interior stabilization tests whether surface modes "
            "decouple as the boundary recedes."
        ),
        "interior_trajectory_comparison": compare_interior_trajectories(results),
        "results": results,
        "passed": all(result["passed_unitarity"] for result in results),
    }
    print(json.dumps(payload, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
