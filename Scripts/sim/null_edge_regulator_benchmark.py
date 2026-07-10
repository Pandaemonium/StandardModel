"""Held-out high-momentum benchmark for the null-edge walk and Wilson control.

The benchmark specification and kill thresholds are pre-registered in
AgentTasks/null-edge-so-what-closure-2026-07-10/
HELD_OUT_REGULATOR_BENCHMARK.md. NumPy is an external numerical oracle; the
supporting exact identities are proved in Lean.
"""

from __future__ import annotations

import argparse
import json
from itertools import product
from pathlib import Path

import numpy as np


TOL = 1.0e-10


def generators() -> tuple[np.ndarray, np.ndarray, np.ndarray, np.ndarray]:
    i = 1j
    alpha1 = np.array(
        [[0, 0, 0, 1], [0, 0, 1, 0], [0, 1, 0, 0], [1, 0, 0, 0]],
        dtype=complex,
    )
    alpha2 = np.array(
        [[0, 0, 0, -i], [0, 0, i, 0], [0, -i, 0, 0], [i, 0, 0, 0]],
        dtype=complex,
    )
    alpha3 = np.array(
        [[0, 0, 1, 0], [0, 0, 0, -1], [1, 0, 0, 0], [0, -1, 0, 0]],
        dtype=complex,
    )
    beta = np.diag([1, 1, -1, -1]).astype(complex)
    return alpha1, alpha2, alpha3, beta


def factor(q: float, generator: np.ndarray) -> np.ndarray:
    return np.cos(q) * np.eye(4) - 1j * np.sin(q) * generator


def mass4(z: complex) -> np.ndarray:
    _, _, _, beta = generators()
    beta5 = np.array(
        [[0, 0, 1, 0], [0, 0, 0, 1], [-1, 0, 0, 0], [0, -1, 0, 0]],
        dtype=complex,
    )
    return z.real * beta + z.imag * 1j * beta5


def mass_coin4(z: complex, eps: float) -> np.ndarray:
    norm = abs(z)
    if norm == 0.0:
        return np.eye(4, dtype=complex)
    return (
        np.cos(eps * norm) * np.eye(4)
        - 1j * np.sin(eps * norm) / norm * mass4(z)
    )


def walk(qx: float, qy: float, qz: float, z: complex, eps: float) -> np.ndarray:
    alpha1, alpha2, alpha3, _ = generators()
    return (
        factor(qx, alpha1)
        @ factor(qy, alpha2)
        @ factor(qz, alpha3)
        @ mass_coin4(z, eps)
    )


def wilson_hamiltonian(
    qx: float, qy: float, qz: float, mass: float, r: float
) -> np.ndarray:
    alpha1, alpha2, alpha3, beta = generators()
    wilson_mass = mass + r * (
        (1.0 - np.cos(qx)) + (1.0 - np.cos(qy)) + (1.0 - np.cos(qz))
    )
    return (
        np.sin(qx) * alpha1
        + np.sin(qy) * alpha2
        + np.sin(qz) * alpha3
        + wilson_mass * beta
    )


def spectral_distance(matrix: np.ndarray, target: complex) -> float:
    return float(np.min(np.abs(np.linalg.eigvals(matrix) - target)))


def run_benchmark() -> dict[str, object]:
    z = 3.0 + 4.0j
    eps = 0.2
    r = 1.0
    corners = list(product((0.0, float(np.pi)), repeat=3))
    origin_walk = walk(0.0, 0.0, 0.0, z, eps)

    corner_rows: list[dict[str, object]] = []
    alias_residuals: list[float] = []
    wilson_nonorigin_gaps: list[float] = []
    unregulated_zero_count = 0

    for corner in corners:
        parity = sum(abs(q - np.pi) < TOL for q in corner) % 2
        current = walk(*corner, z, eps)
        alias_residual = float(np.linalg.norm(current - origin_walk, ord=2))
        wilson_eigs = np.linalg.eigvalsh(wilson_hamiltonian(*corner, 0.0, r))
        wilson_gap = float(np.min(np.abs(wilson_eigs)))
        bare_gap = float(
            np.min(np.abs(np.linalg.eigvalsh(wilson_hamiltonian(*corner, 0.0, 0.0))))
        )
        if bare_gap < TOL:
            unregulated_zero_count += 1
        if corner != (0.0, 0.0, 0.0):
            wilson_nonorigin_gaps.append(wilson_gap)
        if parity == 0 and corner != (0.0, 0.0, 0.0):
            alias_residuals.append(alias_residual)
        corner_rows.append(
            {
                "corner_over_pi": [round(q / np.pi) for q in corner],
                "parity": parity,
                "origin_alias_residual": alias_residual,
                "wilson_gap": wilson_gap,
                "unregulated_gap": bare_gap,
            }
        )

    body = walk(np.pi / 2.0, np.pi / 2.0, np.pi / 2.0, z, eps)
    body_plus = spectral_distance(body, 1.0)
    body_minus = spectral_distance(body, -1.0)

    metrics = {
        "nonorigin_even_alias_count": len(alias_residuals),
        "max_even_alias_residual": max(alias_residuals),
        "body_center_plus_distance": body_plus,
        "body_center_minus_distance": body_minus,
        "wilson_nonorigin_zero_count": sum(gap < TOL for gap in wilson_nonorigin_gaps),
        "wilson_min_nonorigin_gap": min(wilson_nonorigin_gaps),
        "unregulated_zero_corner_count": unregulated_zero_count,
    }
    checks = {
        "three_nonorigin_even_aliases": metrics["nonorigin_even_alias_count"] == 3,
        "alias_residual": metrics["max_even_alias_residual"] < TOL,
        "body_center_plus": body_plus < TOL,
        "body_center_minus": body_minus < TOL,
        "wilson_no_nonorigin_zeros": metrics["wilson_nonorigin_zero_count"] == 0,
        "wilson_corner_gap": metrics["wilson_min_nonorigin_gap"] >= 2.0 - TOL,
        "unregulated_negative_control": unregulated_zero_count == 8,
    }
    return {
        "parameters": {"z_re": z.real, "z_im": z.imag, "eps": eps, "r": r},
        "tolerance": TOL,
        "metrics": metrics,
        "checks": checks,
        "pass": all(checks.values()),
        "corners": corner_rows,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        type=Path,
        default=Path("Scripts/sim/results/null_edge_regulator_benchmark.json"),
    )
    args = parser.parse_args()
    result = run_benchmark()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(result["metrics"], indent=2))
    print("PASS" if result["pass"] else "FAIL")
    if not result["pass"]:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
