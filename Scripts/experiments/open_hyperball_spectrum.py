"""Numerical oracle for the open-causal-diamond 3+1 route.

This script is not a proof. It validates the finite spectral formulas targeted
in `OpenHyperballSingleValley.lean` and contrasts them with the periodic
centered-difference spectrum. The Lean kernel remains the trusted endpoint.

Reference: Yumoto and Misumi, "Lattice fermions as spectral graphs",
arXiv:2112.13501. The implementation below is clean-room from the displayed
matrix and eigenvalue formulas.
"""

from __future__ import annotations

import argparse
import json
from itertools import product

import numpy as np


def open_difference(n: int) -> np.ndarray:
    """Centered difference on an open path, with no wraparound edge."""
    q = np.zeros((n, n), dtype=np.complex128)
    for j in range(n - 1):
        q[j, j + 1] = 0.5
        q[j + 1, j] = -0.5
    return q


def periodic_difference(n: int) -> np.ndarray:
    """Centered difference on a cycle."""
    q = open_difference(n)
    q[n - 1, 0] = 0.5
    q[0, n - 1] = -0.5
    return q


def open_eigenvalue(n: int, k: int) -> complex:
    """Paper convention: k ranges from 1 through n."""
    return 1j * np.cos(np.pi * k / (n + 1))


def open_eigenvector(n: int, k: int) -> np.ndarray:
    a = np.arange(1, n + 1)
    vector = (1j**a) * np.sin(np.pi * a * k / (n + 1))
    return vector / np.linalg.norm(vector)


def audit_size(n: int, tolerance: float) -> dict[str, object]:
    q_open = open_difference(n)
    residuals = []
    for k in range(1, n + 1):
        value = open_eigenvalue(n, k)
        vector = open_eigenvector(n, k)
        residuals.append(float(np.linalg.norm(q_open @ vector - value * vector)))

    open_values = np.array([open_eigenvalue(n, k) for k in range(1, n + 1)])
    periodic_values = np.linalg.eigvals(periodic_difference(n))
    open_sorted = np.sort(open_values.imag)
    min_open_spacing = float(np.min(np.diff(open_sorted))) if n > 1 else float("inf")
    periodic_formula = np.sin(2 * np.pi * np.arange(n) / n)
    periodic_has_collision = bool(
        n > 1
        and any(
            abs(periodic_formula[j] - periodic_formula[k]) < tolerance
            for j in range(n)
            for k in range(j + 1, n)
        )
    )
    periodic_is_monotone = bool(
        np.all(np.diff(periodic_formula) > tolerance)
        or np.all(np.diff(periodic_formula) < -tolerance)
    )
    open_zero_indices = [
        k for k, value in enumerate(open_values, start=1) if abs(value) < tolerance
    ]
    periodic_zero_count = int(np.count_nonzero(np.abs(periodic_values) < tolerance))

    coordinate_zero_count = len(open_zero_indices)
    four_coordinate_zero_count = sum(
        all(abs(open_values[k - 1]) < tolerance for k in mode)
        for mode in product(range(1, n + 1), repeat=4)
    )

    expected_open_count = 1 if n % 2 == 1 else 0
    expected_periodic_count = 2 if n % 2 == 0 else 1
    passed = (
        max(residuals, default=0.0) < tolerance
        and min_open_spacing > tolerance
        and coordinate_zero_count == expected_open_count
        and periodic_zero_count == expected_periodic_count
        and not periodic_is_monotone
        and (n % 2 == 1 or periodic_has_collision)
        and four_coordinate_zero_count == expected_open_count**4
    )
    return {
        "n": n,
        "passed": passed,
        "max_eigenvector_residual": max(residuals, default=0.0),
        "open_zero_indices": open_zero_indices,
        "periodic_zero_count": periodic_zero_count,
        "periodic_has_spectral_collision": periodic_has_collision,
        "periodic_spectrum_is_monotone": periodic_is_monotone,
        "four_coordinate_zero_count": four_coordinate_zero_count,
        "minimum_open_spectral_spacing": min_open_spacing,
        "nearest_open_abs_eigenvalue": float(np.min(np.abs(open_values))),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--sizes", type=int, nargs="+", default=[3, 4, 5, 6, 7])
    parser.add_argument("--tolerance", type=float, default=1e-10)
    args = parser.parse_args()

    audits = [audit_size(n, args.tolerance) for n in args.sizes]
    print(json.dumps({"passed": all(a["passed"] for a in audits), "audits": audits}, indent=2))
    if not all(a["passed"] for a in audits):
        raise SystemExit(1)


if __name__ == "__main__":
    main()
