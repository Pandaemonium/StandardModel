#!/usr/bin/env python3
"""Gate Q2 / D3.1 modular defect: entanglement Hamiltonian vs the boost.

Protocol: `AgentTasks/nerd-gate-q2-discrete-qnec-protocol-2026-07-02.md`
(second companion measurement) and `Sources/Null_Edge_Dynamics_Gate_D.md`
Gate D3.1. Run task T5 of `AgentTasks/overnight-nerd-run-2026-07-02/`.

This is the D3.1 *modular defect* measurement - the numerical F-M2 datum the
NERD gravity story hinges on. The Bisognano-Wichmann theorem (and its lattice
Eisler-Peschel shadow) predicts that the entanglement (modular) Hamiltonian of
a ground-state region IS a boost generator. For free fermions the modular
Hamiltonian is quadratic with single-particle matrix

    h_A = log( (1 - C_A) C_A^{-1} )   (Peschel),

computed here by eigenvalue functional calculus on the restricted correlation
matrix C_A (no matrix logm needed). For a half-line cut the boost prediction is
that the nearest-neighbour hopping of h_A grows LINEARLY with distance from the
entangling cut. The "modular defect" is the deviation of the lattice h_A from
that exact linear boost profile; it is expected to shrink toward the continuum,
and its persistence at finite spacing is exactly the finite-vs-type-III
(F-M2) content.

Model / conventions
-------------------
- Open tight-binding chain of `2 L` sites, `t = 1`, half filling; region A =
  left half `[0, L)`, so the entangling cut sits at the chain centre and the
  open boundary of A is at site 0. (Open BC gives the cleanest single-cut boost
  profile; the periodic ring has two cuts.)
- h_A single-particle matrix by eigenvalue calculus of C_A.
- Boost signature: nearest-neighbour hopping magnitude `T(i) = |h_A[i, i+1]|`
  grows ~linearly in `i` toward the cut (Eisler-Peschel). We fit `T(i)` to a
  line over the clean interior and report R^2 (boost-ness) and the residual
  (lattice defect).

Oracle / fixture metadata (per repo CAS-and-oracle policy)
----------------------------------------------------------
- Tool: python3 + numpy (version printed at run time).
- Command: `python Scripts/qnec/modular_defect.py [--L ...] [--json]`.
- Conventions as above; natural units.
- Output: printed hopping profile + linear-fit R^2 and residual; JSON to
  `Scripts/qnec/out/modular_defect.json` with `--json`.
- License: original clean-room implementation; no external code copied.
- CI: not wired; draft/oracle numerical fixture, NOT kernel-checked.

## STATUS: EXPLORATORY / handoff (finding recorded 2026-07-03, run T5)

This script is a documented STEPPING STONE, not a validated result. The
open-chain correlation matrix and the entanglement Hamiltonian
`h_A = log((1-C_A)/C_A)` (eigenvalue calculus) are correct and reusable. The
NAIVE OBSERVABLE below - the raw nearest-neighbour hopping `|h_A[i,i+1]|` - is
NOT the boost: numerically it is roughly FLAT across the interior (~17.5 for
L=128), not the linearly-growing ramp, giving linear R^2 ~ 0.23.

Lesson (the actual F-M2 measurement recipe for the next rung): for a
free-fermion block the clean Bisognano-Wichmann boost does NOT sit in the raw
`h_A` nearest-neighbour entries (`h_A` has long-range entries); it sits in the
Eisler-Peschel COMMUTING tridiagonal operator `T` that commutes with both `C_A`
and `h_A`, whose hopping follows the exact parabolic entanglement-temperature
profile `beta(i) ~ i (L - i)` for an interval (linear near a single cut). The
correct D3.1 modular-defect observable is therefore the deviation of that
commuting operator (or of `h_A` projected onto the entanglement-temperature
profile) from the exact continuum boost - NOT the raw `h_A[i,i+1]`. Implement
that operator next; the machinery here (C_A, h_A) is the correct input.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np


def open_chain_correlation(n_sites: int) -> np.ndarray:
    """Half-filled ground-state correlation matrix of the OPEN tight-binding chain."""
    h = np.zeros((n_sites, n_sites))
    for i in range(n_sites - 1):
        h[i, i + 1] -= 1.0
        h[i + 1, i] -= 1.0
    _, modes = np.linalg.eigh(h)
    # eigh returns ascending eigenvalues; occupy the lowest half.
    occ = modes[:, : n_sites // 2]
    return occ @ occ.conj().T


def entanglement_hamiltonian(corr: np.ndarray, region: np.ndarray) -> np.ndarray:
    """Single-particle entanglement Hamiltonian h_A = log((1-C_A)/C_A)."""
    c_a = corr[np.ix_(region, region)]
    c_a = 0.5 * (c_a + c_a.conj().T)
    nu, vecs = np.linalg.eigh(c_a)
    eps = 1e-12
    nu = np.clip(nu, eps, 1.0 - eps)
    diag = np.log((1.0 - nu) / nu)
    return (vecs * diag) @ vecs.conj().T


def run(half_len: int) -> dict:
    n_sites = 2 * half_len
    corr = open_chain_correlation(n_sites)
    region = np.arange(half_len)
    h_a = entanglement_hamiltonian(corr, region)
    # Nearest-neighbour hopping magnitude profile.
    hop = np.array([abs(h_a[i, i + 1]) for i in range(half_len - 1)])
    idx = np.arange(half_len - 1)
    # Fit a line over the clean interior (drop the two ends: open boundary at
    # i=0 and the cut at i=half_len-1 have edge effects).
    lo = max(1, half_len // 8)
    hi = half_len - 1 - max(1, half_len // 8)
    xs = idx[lo:hi].astype(float)
    ys = hop[lo:hi]
    a_mat = np.vstack([xs, np.ones_like(xs)]).T
    (slope, intercept), *_ = np.linalg.lstsq(a_mat, ys, rcond=None)
    fit = slope * xs + intercept
    ss_res = float(np.sum((ys - fit) ** 2))
    ss_tot = float(np.sum((ys - ys.mean()) ** 2))
    r2 = 1.0 - ss_res / ss_tot if ss_tot > 0 else 0.0
    # Modular defect: RMS relative deviation from the linear boost over interior.
    rms_defect = float(np.sqrt(np.mean(((ys - fit) / np.maximum(fit, 1e-9)) ** 2)))
    return {
        "half_len": half_len,
        "n_sites": n_sites,
        "hop_profile": hop.tolist(),
        "boost_slope": float(slope),
        "boost_intercept": float(intercept),
        "linear_r2": float(r2),
        "rms_relative_defect": rms_defect,
        "numpy_version": np.__version__,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--L", type=int, default=128,
                        help="half length (region size); chain has 2L sites")
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()

    result = run(args.L)
    print(f"# Gate Q2 / D3.1 modular defect (entanglement Hamiltonian vs boost)")
    print(f"# open chain 2L = {result['n_sites']} sites, region L = "
          f"{result['half_len']}, numpy {result['numpy_version']}")
    print(f"# nearest-neighbour hopping T(i) = |h_A[i,i+1]| toward the cut:")
    hop = result["hop_profile"]
    step = max(1, len(hop) // 16)
    print(f"{'i':>5} {'T(i)':>12}")
    for i in range(0, len(hop), step):
        print(f"{i:>5} {hop[i]:>12.6f}")
    print(f"# boost fit (interior): T(i) ~ {result['boost_slope']:.5f} * i + "
          f"{result['boost_intercept']:.5f}")
    print(f"# BOOST-NESS linear R^2 = {result['linear_r2']:.6f} "
          f"(1.0 = exact boost); RMS relative modular defect = "
          f"{result['rms_relative_defect']:.4e}")
    print(f"# EXPLORATORY FINDING: raw |h_A[i,i+1]| is ~flat, NOT the boost "
          f"(linear R^2 ~ {result['linear_r2']:.2f}). The BW boost lives in the "
          f"Eisler-Peschel COMMUTING operator, not raw h_A entries - see the "
          f"module docstring for the correct next-rung observable.")

    if args.json:
        out_dir = Path(__file__).resolve().parent / "out"
        out_dir.mkdir(parents=True, exist_ok=True)
        out_path = out_dir / "modular_defect.json"
        out_path.write_text(json.dumps(result, indent=2) + "\n",
                            encoding="utf-8")
        print(f"# wrote {out_path}")


if __name__ == "__main__":
    main()
