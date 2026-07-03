#!/usr/bin/env python3
"""Gate Q2 / G1'.2 lattice first law: delta S = delta <K> for free fermions.

Protocol: `AgentTasks/nerd-gate-q2-discrete-qnec-protocol-2026-07-02.md`
(first companion measurement, "Gate G1'.2's numerical shadow") and run task T5
of `AgentTasks/overnight-nerd-run-2026-07-02/`.

This is the numerical companion to the Lean theorem
`PhysicsSM.Draft.NullEdge.GateD.FiniteFirstLaw.finite_first_law`
(the exact entanglement first law identity). Here we confirm the free-fermion
Gaussian version on the lattice: to first order in a perturbation `delta C` of
the reduced correlation matrix, the entanglement-entropy change equals the
modular-energy change,

    delta S = delta <K> = Tr( delta C . h_A ),

where `h_A = log((1 - C_A) / C_A)` is the single-particle entanglement (modular)
Hamiltonian (Peschel). This is *the* structural fact underlying the NERD Gate D
"first law is an identity" claim - the deflationary half of the gravity story -
made numerical and Gaussian-exact.

Derivation (why it is exact to first order): with the block entropy
`S = -Tr[ C log C + (1-C) log(1-C) ]`, the differential is
`dS = -Tr[ dC ( log C - log(1-C) ) ] = Tr[ dC . log((1-C)/C) ] = Tr[ dC . h_A ]`.
The check below confirms this numerically and that the residual is O(delta^2)
(i.e. the ratio delta S / Tr(dC h_A) -> 1 as the perturbation shrinks).

Model / conventions
-------------------
- Half-filled critical (massless) periodic tight-binding ring (validated
  toolchain, see `massless_calibration.py`); block A = L consecutive sites in a
  ring of 8L.
- Perturbation: a small random Hermitian `delta C`, PROJECTED onto the active
  entanglement subspace of `C_A` (eigenvalues in [0.05, 0.95]), where `h_A` is
  bounded and the linearization is well-conditioned. On the inactive modes
  (`nu -> 0/1`) `h_A` is near-singular and a generic `delta C` makes the
  finite-difference test ill-conditioned; the projection is the physically
  meaningful test (perturbing the non-trivial entanglement degrees of freedom).
  Entropy computed by the exact Peschel eigenvalue formula (nats).

Result (L=48, massless ring N=384): the ratio `dS / Tr(dC h_A)` converges to 1
with the perturbation size (0.930, 0.993, 0.9993, 0.99993 at eps = 1e-2..1e-5),
i.e. `dS = delta <K>` to first order - the Gaussian lattice shadow of the Lean
theorem `FiniteFirstLaw.finite_first_law`.

Oracle / fixture metadata (per repo CAS-and-oracle policy)
----------------------------------------------------------
- Tool: python3 + numpy (version printed at run time).
- Command: `python Scripts/qnec/first_law.py [--L ...] [--json]`.
- Output: table of (eps, delta S, Tr(dC h_A), ratio); JSON with `--json`.
- License: original clean-room implementation; no external code copied.
- CI: not wired; draft/oracle numerical fixture, NOT kernel-checked.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np


def ring_correlation(n_sites: int, dimerization: float = 0.0) -> np.ndarray:
    """Half-filled correlation matrix of the (optionally dimerized) ring.

    The test below uses the CRITICAL (massless, `dimerization = 0`) chain,
    which has a broad entanglement spectrum (many `C_A` eigenvalues away from
    0 and 1 - "active" modes). The perturbation is projected onto that active
    subspace, where `h_A` is bounded and the first-law linearization is
    well-conditioned. (The gapped chain is the WRONG choice here: its few
    entangled modes sit at `nu -> 0/1`, leaving no active subspace.)
    """
    h = np.zeros((n_sites, n_sites))
    for i in range(n_sites):
        j = (i + 1) % n_sites
        t = 1.0 + dimerization * (1.0 if i % 2 == 0 else -1.0)
        h[i, j] -= t
        h[j, i] -= t
    _, modes = np.linalg.eigh(h)
    occ = modes[:, : n_sites // 2]
    return occ @ occ.conj().T


def block_entropy(c_a: np.ndarray) -> float:
    nu = np.linalg.eigvalsh(0.5 * (c_a + c_a.conj().T)).real
    eps = 1e-13
    nu = np.clip(nu, eps, 1.0 - eps)
    return float(-np.sum(nu * np.log(nu) + (1.0 - nu) * np.log(1.0 - nu)))


def entanglement_hamiltonian(c_a: np.ndarray) -> np.ndarray:
    c_a = 0.5 * (c_a + c_a.conj().T)
    nu, vecs = np.linalg.eigh(c_a)
    eps = 1e-13
    nu = np.clip(nu, eps, 1.0 - eps)
    diag = np.log((1.0 - nu) / nu)
    return (vecs * diag) @ vecs.conj().T


def run(block_len: int, seed: int = 0, dimerization: float = 0.0) -> dict:
    n_sites = 8 * block_len
    corr = ring_correlation(n_sites, dimerization)
    region = np.arange(block_len)
    c_a = corr[np.ix_(region, region)].real
    c_a = 0.5 * (c_a + c_a.T)
    h_a = entanglement_hamiltonian(c_a)
    s0 = block_entropy(c_a)

    # A random Hermitian perturbation, PROJECTED onto the active entanglement
    # modes (C_A eigenvalues away from 0 and 1). On the inactive modes
    # (nu -> 0 or 1) h_A is near-singular and the entropy is non-analytic, so a
    # generic delta C there makes the finite-difference first-law test
    # ill-conditioned; projecting onto the active subspace is the physically
    # meaningful, well-conditioned test (perturbing the non-trivial
    # entanglement degrees of freedom, where h_A is bounded).
    nu, vecs = np.linalg.eigh(c_a)
    active = (nu > 0.05) & (nu < 0.95)
    p_active = vecs[:, active] @ vecs[:, active].T
    rng = np.random.default_rng(seed)
    m = rng.standard_normal((block_len, block_len))
    d_dir = 0.5 * (m + m.T)
    d_dir = p_active @ d_dir @ p_active  # restrict to active subspace
    nrm = np.linalg.norm(d_dir)
    if nrm == 0:
        raise SystemExit("no active entanglement modes; raise L or dimerization")
    d_dir /= nrm

    rows = []
    for eps in (1e-2, 1e-3, 1e-4, 1e-5):
        dc = eps * d_dir
        ds_numeric = block_entropy(c_a + dc) - s0
        ds_firstlaw = float(np.trace(dc @ h_a))
        ratio = ds_numeric / ds_firstlaw if ds_firstlaw != 0 else float("nan")
        rows.append((eps, ds_numeric, ds_firstlaw, ratio))
    return {
        "block_len": block_len,
        "n_sites": n_sites,
        "S0": s0,
        "rows": rows,
        "numpy_version": np.__version__,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--L", type=int, default=48)
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()

    result = run(args.L)
    print(f"# Gate Q2 / G1'.2 lattice first law  delta S = Tr(delta C . h_A)")
    print(f"# block L = {result['block_len']} in ring N = {result['n_sites']}, "
          f"S0 = {result['S0']:.6f} nats, numpy {result['numpy_version']}")
    print(f"{'eps':>8} {'dS numeric':>16} {'Tr(dC h_A)':>16} {'ratio':>12}")
    for eps, dsn, dsf, ratio in result["rows"]:
        print(f"{eps:>8.0e} {dsn:>16.9f} {dsf:>16.9f} {ratio:>12.8f}")
    # First-order agreement: ratio -> 1 as eps -> 0, with O(eps) approach.
    finest_ratio = result["rows"][-1][3]
    print(f"# finest-eps ratio dS/Tr(dC h_A) = {finest_ratio:.8f} "
          f"-> {'FIRST LAW CONFIRMED (delta S = delta <K> to first order)' if abs(finest_ratio - 1.0) < 1e-3 else 'CHECK: ratio not -> 1'}")

    if args.json:
        out_dir = Path(__file__).resolve().parent / "out"
        out_dir.mkdir(parents=True, exist_ok=True)
        out_path = out_dir / "first_law.json"
        serializable = dict(result)
        serializable["rows"] = [
            {"eps": e, "dS_numeric": a, "dS_firstlaw": b, "ratio": r}
            for (e, a, b, r) in result["rows"]
        ]
        out_path.write_text(json.dumps(serializable, indent=2) + "\n",
                            encoding="utf-8")
        print(f"# wrote {out_path}")


if __name__ == "__main__":
    main()
