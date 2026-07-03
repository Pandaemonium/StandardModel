#!/usr/bin/env python3
"""Gate Q2 massless calibration: free-fermion entanglement entropy (Peschel).

Protocol: `AgentTasks/nerd-gate-q2-discrete-qnec-protocol-2026-07-02.md`,
run task T5 of the overnight run `AgentTasks/overnight-nerd-run-2026-07-02/`.

This is the *calibration* rung of the discrete-QNEC program (NERD Gate Q2 /
paper P3): before measuring any discrete quantum-null-energy-condition deficit
or modular defect, we confirm the exact free-fermion machinery reproduces the
known c = 1 conformal-field-theory logarithmic scaling of interval
entanglement entropy. In the massless case the continuum QNEC is saturated, so
this run isolates pure lattice artifacts and fixes the entropy toolchain.

Physics / conventions
---------------------
- Model: nearest-neighbour tight-binding free fermions on a ring of `N` sites,
  `H = -t sum_i (c_i^dag c_{i+1} + h.c.)`, `t = 1`, periodic boundary
  conditions, half filling (`N/2` lowest modes occupied). This is the lattice
  regularization whose continuum limit is the massless (1+1)d Dirac fermion -
  the c = 1 free-fermion CFT. It is the standard, model-independent calibration
  for the Peschel correlation-matrix entropy method; the checkerboard-specific
  null-cut geometry enters only later (the QNEC deformation rung), not the
  massless entropy calibration.
- Ground-state correlation matrix `C_ij = <c_i^dag c_j>` = sum over occupied
  single-particle modes of `conj(psi_k(i)) psi_k(j)`.
- Peschel: the reduced state on a region `A` is Gaussian, and the entanglement
  entropy is `S(A) = - sum_a [ nu_a log nu_a + (1 - nu_a) log(1 - nu_a) ]`
  over eigenvalues `nu_a in [0, 1]` of the restricted correlation matrix
  `C[A, A]`. (Natural log -> entropy in nats.)
- CFT prediction (periodic ring, single interval, Calabrese-Cardy):
  `S(l) = (c/3) log[ (N/pi) sin(pi l / N) ] + c1`, with central charge `c = 1`
  for free Dirac fermions. Fitting `S` against the chord variable
  `X = log[(N/pi) sin(pi l / N)]` recovers `c = 3 * slope`.

Success criterion (calibration): fitted `c` within a few percent of 1 across a
window of interval sizes away from the very small-`l` lattice regime.

Oracle / fixture metadata (per repo CAS-and-oracle policy)
----------------------------------------------------------
- Tool: python3 + numpy (see `numpy.__version__` printed at run time).
- Generation command: `python Scripts/qnec/massless_calibration.py`.
- Input conventions: as above (t=1, periodic, half filling, natural log).
- Output format: printed table of `(l, S_numeric, X_chord)` plus the fitted
  central charge and residual; machine-readable JSON to
  `Scripts/qnec/out/massless_calibration.json` when `--json` is passed.
- License status: original clean-room implementation of the standard Peschel
  method; no external code copied.
- CI: not wired into CI; this is a draft/oracle numerical fixture, NOT a
  kernel-checked result. Numerical evidence only.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np


def correlation_matrix(n_sites: int, dimerization: float = 0.0) -> np.ndarray:
    """Ground-state two-point correlation matrix of the half-filled ring.

    `dimerization` in [0, 1) opens a mass gap via alternating hopping
    `t_i = 1 +- dimerization` (the lattice mass of the (1+1)d Dirac fermion).
    `dimerization = 0` is the massless (c = 1) critical chain.
    """
    # Hopping Hamiltonian (real symmetric, periodic), optionally dimerized.
    h = np.zeros((n_sites, n_sites))
    for i in range(n_sites):
        j = (i + 1) % n_sites
        t = 1.0 + dimerization * (1.0 if i % 2 == 0 else -1.0)
        h[i, j] -= t
        h[j, i] -= t
    # Single-particle eigenmodes, ascending energy.
    energies, modes = np.linalg.eigh(h)
    order = np.argsort(energies)
    energies = energies[order]
    modes = modes[:, order]
    # Half filling: occupy the lowest n_sites // 2 modes. Guard the (measure
    # zero at generic N) degeneracy exactly at the Fermi level by filling by
    # index, which is the standard half-filled-ground-state convention.
    n_occ = n_sites // 2
    occ = modes[:, :n_occ]
    # C_ij = sum_k conj(psi_k(i)) psi_k(j) = (occ occ^dag)_{ij}.
    corr = occ @ occ.conj().T
    return corr


def entanglement_entropy(corr: np.ndarray, region: np.ndarray) -> float:
    """Peschel entanglement entropy (nats) of a region from `corr`."""
    sub = corr[np.ix_(region, region)]
    # Hermitize against tiny asymmetry, take real eigenvalues in [0, 1].
    sub = 0.5 * (sub + sub.conj().T)
    nu = np.linalg.eigvalsh(sub).real
    # Clip to the open interval to avoid 0*log 0 / log of tiny negatives.
    eps = 1e-12
    nu = np.clip(nu, eps, 1.0 - eps)
    return float(-np.sum(nu * np.log(nu) + (1.0 - nu) * np.log(1.0 - nu)))


def run(n_sites: int, dimerization: float = 0.0) -> dict:
    corr = correlation_matrix(n_sites, dimerization)
    # Contiguous intervals [0, l) over a window that avoids the smallest-l
    # lattice regime and the l -> N finite-size wrap.
    l_min = max(4, n_sites // 16)
    l_max = n_sites // 2
    lengths = list(range(l_min, l_max + 1))
    rows = []
    for length in lengths:
        region = np.arange(length)
        s = entanglement_entropy(corr, region)
        chord = np.log((n_sites / np.pi) * np.sin(np.pi * length / n_sites))
        rows.append((length, s, chord))
    # Fit S = slope * X + intercept ; c = 3 * slope (periodic ring).
    xs = np.array([r[2] for r in rows])
    ys = np.array([r[1] for r in rows])
    a_mat = np.vstack([xs, np.ones_like(xs)]).T
    (slope, intercept), residuals, *_ = np.linalg.lstsq(a_mat, ys, rcond=None)
    c_fit = 3.0 * slope
    resid = float(residuals[0]) if len(residuals) else float(
        np.sum((ys - (slope * xs + intercept)) ** 2))
    return {
        "n_sites": n_sites,
        "rows": rows,
        "slope": float(slope),
        "intercept": float(intercept),
        "central_charge_fit": float(c_fit),
        "residual_sq": resid,
        "dimerization": float(dimerization),
        # Saturation diagnostics (meaningful in the massive/dimerized case),
        # measured over the MIDDLE THIRD of the interval range to avoid both
        # the small-l lattice regime and the l -> N/2 ring finite-size wrap.
        # A dimerized gapped chain saturates to a flat AREA LAW, but S(l)
        # carries a genuine period-2 dimer-parity oscillation (cutting a
        # strong vs weak bond), so saturation is judged PER PARITY: each of
        # the two l-parity subseries must be flat.
        "s_plateau_even": float(np.mean(
            ys[len(ys) // 3: 2 * len(ys) // 3][0::2])),
        "s_plateau_odd": float(np.mean(
            ys[len(ys) // 3: 2 * len(ys) // 3][1::2])),
        "plateau_spread": float(max(
            np.std(ys[len(ys) // 3: 2 * len(ys) // 3][0::2]),
            np.std(ys[len(ys) // 3: 2 * len(ys) // 3][1::2]))),
        "numpy_version": np.__version__,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--n", type=int, default=256,
                        help="number of ring sites (even)")
    parser.add_argument("--dimerization", type=float, default=0.0,
                        help="alternating-hopping gap in [0,1); 0 = massless")
    parser.add_argument("--json", action="store_true",
                        help="also write JSON fixture under Scripts/qnec/out/")
    args = parser.parse_args()
    if args.n % 2 != 0:
        raise SystemExit("n must be even (half filling)")

    result = run(args.n, args.dimerization)
    massive = args.dimerization != 0.0
    label = ("massive/dimerized" if massive else "massless critical")
    print(f"# Gate Q2 {label} run (Peschel free-fermion), "
          f"N = {result['n_sites']}, dimerization = {result['dimerization']}, "
          f"numpy {result['numpy_version']}")
    print(f"{'l':>5} {'S(l) [nats]':>14} {'X=chord':>12}")
    for length, s, chord in result["rows"]:
        print(f"{length:>5} {s:>14.6f} {chord:>12.6f}")
    if not massive:
        print(f"# CFT fit: c = 3 * slope = {result['central_charge_fit']:.4f} "
              f"(target 1.0), intercept = {result['intercept']:.4f}, "
              f"residual_sq = {result['residual_sq']:.3e}")
        verdict = abs(result["central_charge_fit"] - 1.0)
        print(f"# |c_fit - 1| = {verdict:.4f} -> "
              f"{'CALIBRATED (within 3%)' if verdict < 0.03 else 'CHECK: off target'}")
    else:
        # Massive signature: the entropy saturates to a flat area law (per
        # dimer-cut parity) rather than growing logarithmically.
        print(f"# massive: area-law plateaus (per dimer-cut parity) = "
              f"{result['s_plateau_even']:.6f} / {result['s_plateau_odd']:.6f} "
              f"nats; per-parity flatness spread = "
              f"{result['plateau_spread']:.3e}")
        print(f"# -> {'SATURATED (flat area-law plateau per parity, gapped)' if result['plateau_spread'] < 1e-3 else 'not yet saturated: raise N or dimerization'}")

    if args.json:
        out_dir = Path(__file__).resolve().parent / "out"
        out_dir.mkdir(parents=True, exist_ok=True)
        out_path = out_dir / "massless_calibration.json"
        serializable = dict(result)
        serializable["rows"] = [
            {"l": length, "S": s, "X": chord}
            for (length, s, chord) in result["rows"]
        ]
        out_path.write_text(json.dumps(serializable, indent=2) + "\n",
                            encoding="utf-8")
        print(f"# wrote {out_path}")


if __name__ == "__main__":
    main()
