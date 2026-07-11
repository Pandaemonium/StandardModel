"""dynamics_lab: spec-driven finite quantum dynamics simulator.

Goal (user directive, overnight run 2026-07-11): one deterministic,
JSON-out engine able to simulate any tractable finite system used by the
null-edge program, growing toward general finite physical systems.

v1 capabilities (consolidates the run's verified oracle machinery):
  - 1D split-step Dirac walks on a ring: W = S.C (complex Pluecker coins)
    and the palindromic W = S.C.S (real SO(2) coins), with arbitrary
    site-dependent field profiles;
  - ordered 3+1 successive-axis walk symbol U(q, theta) at given momenta;
  - graders/reflections and symmetry checks (chirality, commutants);
  - exact-tolerance spectral audit: pinned +-1 modes, gaps, localization
    profiles of selected eigenvectors;
  - free fermionic pair sector: second-quantized two-particle matrix
    (2x2 minors) and n-step transfer probabilities;
  - state evolution with per-step observables (site probabilities).

v1.1 additions (2026-07-11 advisor-H2 lane, cross-verified with exact
sympy in the run scratchpad window_charge oracles):
  - filled-sea window charge: orthonormal (Schur) spectral split into
    filled band eps in (0, pi), exact +1 and -1 gap modes; per-window
    charges and sector-resolved defect charges vs a control field
    (walk-native Goldstone-Wilczek half-charge; exactly -1/2 per gap
    sector at the reflection-symmetric two-wall fixture);
  - exact site-local chiral grading for SC walks:
    Gamma(x) = cos_t * sigma_y - field(x) * sin_t * sigma_z, with
    residual checks of Gamma W Gamma = W^dagger and Gamma-oddness of
    K = (W - W^dagger)/2i.

Design rules: no randomness anywhere (deterministic by construction);
every run emits a JSON record with the full spec, numerical tolerances,
NumPy version, and a SHA-256 of the canonical result payload - matching
the repository's reproducibility harness standard.  Exact claims are the
job of the Lean modules; this lab is for exploration, regression tests,
and figures.

Provenance: consolidated from the 2026-07-11 run scratchpad oracles
(wall_parity_oracle, wall_mode_profile, pair_minor/return/gradient,
trace_index_oracle), whose findings were cross-verified with exact sympy
arithmetic before Lean submission.

Usage:
  python Scripts/sim/dynamics_lab.py --demo           # run built-in demos
  python Scripts/sim/dynamics_lab.py --spec spec.json # run a spec file
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from itertools import combinations

import numpy as np

TOL = 1e-9


# ---------------------------------------------------------------- builders

def coin_complex(u, cos_t, sin_t):
    """Complex Pluecker coin exp(-i theta B_u-hat): 2x2 with unit phase u."""
    u = complex(u)
    return np.array([[cos_t, -1j * sin_t * u],
                     [-1j * sin_t * np.conj(u), cos_t]], dtype=complex)


def coin_so2(sign, cos_t, sin_t):
    """Real SO(2) rotation coin with signed angle (K6 family)."""
    s = sign * sin_t
    return np.array([[cos_t, -s], [s, cos_t]], dtype=complex)


def build_walk_1d(spec):
    """Build a 1D ring walk from a spec dict.

    spec keys: L (sites), family ('SC' or 'SCS'), cos_t, sin_t,
    field: list of length L of unit phases (SC) or signs (SCS).
    """
    L = spec["L"]
    fam = spec.get("family", "SC")
    cos_t, sin_t = spec["cos_t"], spec["sin_t"]
    field = spec["field"]
    N = 2 * L
    C = np.zeros((N, N), dtype=complex)
    for x in range(L):
        blk = (coin_complex(field[x], cos_t, sin_t) if fam == "SC"
               else coin_so2(field[x], cos_t, sin_t))
        C[2 * x:2 * x + 2, 2 * x:2 * x + 2] = blk
    S = np.zeros((N, N), dtype=complex)
    for x in range(L):
        S[2 * ((x + 1) % L), 2 * x] = 1
        S[2 * ((x - 1) % L) + 1, 2 * x + 1] = 1
    return S @ C if fam == "SC" else S @ C @ S


def symbol_3plus1(qx, qy, qz, theta):
    """Ordered successive-axis 3+1 Bloch symbol (live Clifford basis)."""
    s1 = np.array([[0, 1], [1, 0]], dtype=complex)
    s2 = np.array([[0, -1j], [1j, 0]], dtype=complex)
    s3 = np.array([[1, 0], [0, -1]], dtype=complex)
    i2 = np.eye(2)
    a1, a2, a3 = np.kron(s1, s1), np.kron(s1, s2), np.kron(s1, s3)
    beta = np.kron(s3, i2)

    def rot(gen, ang):
        return np.cos(ang) * np.eye(4) - 1j * np.sin(ang) * gen

    return rot(a1, qx) @ rot(a2, qy) @ rot(a3, qz) @ rot(beta, theta)


# ---------------------------------------------------------------- analysis

def unitarity_error(W):
    return float(np.max(np.abs(W.conj().T @ W - np.eye(W.shape[0]))))


def pinned_modes(W):
    """Exact-tolerance +-1 eigenmode census with localization profiles."""
    evals, evecs = np.linalg.eig(W)
    out = {}
    for lam, name in [(1.0, "plus_one"), (-1.0, "minus_one")]:
        idx = np.where(np.abs(evals - lam) < TOL)[0]
        modes = []
        for j in idx:
            v = evecs[:, j]
            L = W.shape[0] // 2
            prof = [float(abs(v[2 * x]) ** 2 + abs(v[2 * x + 1]) ** 2)
                    for x in range(L)]
            tot = sum(prof)
            modes.append({"site_probabilities":
                          [round(p / tot, 10) for p in prof]})
        out[name] = {"multiplicity": int(len(idx)), "modes": modes}
    gaps = np.sort(np.abs(np.angle(evals)))
    out["min_quasienergy"] = float(gaps[0])
    return out


def chiral_grading(spec):
    """Exact site-local chiral grading for SC walks (advisor-H2 lane).

    Gamma(x) = cos_t * sigma_y - field(x) * sin_t * sigma_z.  For the
    3-4-5 coin this has exact rational blocks; sympy-verified to satisfy
    Gamma W Gamma = W^dagger and to anticommute with K = Im W.
    """
    L, c, s0 = spec["L"], spec["cos_t"], spec["sin_t"]
    field = spec["field"]
    G = np.zeros((2 * L, 2 * L), dtype=complex)
    sy = np.array([[0, -1j], [1j, 0]])
    sz = np.array([[1, 0], [0, -1]])
    for x in range(L):
        G[2 * x:2 * x + 2, 2 * x:2 * x + 2] = c * sy - field[x] * s0 * sz
    return G


def spectral_split_schur(W, tol=TOL):
    """Orthonormal spectral densities: filled band (0, pi), +1, -1 modes.

    Uses complex Schur so degenerate subspaces stay orthonormal (a plain
    eig basis skews window charges by O(1e-2) - verified in the run).
    """
    from scipy.linalg import schur
    T, Z = schur(W, output="complex")
    vals = np.diag(T)
    N = W.shape[0]
    dens = {"fill": np.zeros(N), "zero": np.zeros(N), "pi": np.zeros(N)}
    counts = {"fill": 0, "zero": 0, "pi": 0}
    for j in range(N):
        lam = vals[j]
        if abs(lam - 1) < tol:
            key = "zero"
        elif abs(lam + 1) < tol:
            key = "pi"
        elif 0 < np.angle(lam) < np.pi:
            key = "fill"
        else:
            continue
        dens[key] += np.abs(Z[:, j]) ** 2
        counts[key] += 1
    return dens, counts


def window_charges(spec, W):
    """Filled-sea window charges and sector-resolved defect charges.

    Spec block: {"windows": [[sites...], ...], "control_field": [...]}.
    Sector-resolved defect charge at a window = sea deficit vs control
    plus half the window density of that sector's exact gap modes
    (the walk-native Goldstone-Wilczek / Jackiw-Rebbi convention).
    """
    wc = spec["window_charge"]
    L = spec["L"]
    ctrl_spec = dict(spec)
    ctrl_spec["field"] = wc["control_field"]
    Wc = build_walk_1d(ctrl_spec)
    dens, counts = spectral_split_schur(W)
    dens_c, counts_c = spectral_split_schur(Wc)

    def q(d, sites):
        return float(sum(d[2 * (x % L)] + d[2 * (x % L) + 1] for x in sites))

    out = {"gap_mode_counts": {k: int(v) for k, v in counts.items()
                               if k != "fill"},
           "control_gap_mode_counts": {k: int(v) for k, v in counts_c.items()
                                       if k != "fill"},
           "windows": []}
    for sites in wc["windows"]:
        sea = q(dens["fill"], sites) - q(dens_c["fill"], sites)
        qz, qp = q(dens["zero"], sites), q(dens["pi"], sites)
        out["windows"].append({
            "sites": list(sites),
            "sea_deficit": round(sea, 10),
            "zero_mode_density": round(qz, 10),
            "pi_mode_density": round(qp, 10),
            "defect_charge_sector_0": round(sea + qz / 2, 10),
            "defect_charge_sector_pi": round(sea + qp / 2, 10),
        })
    return out


def pair_matrix(U):
    """Second-quantized two-particle sector: 2x2 minors over ordered pairs."""
    n = U.shape[0]
    pairs = list(combinations(range(n), 2))
    G = np.zeros((len(pairs), len(pairs)), dtype=complex)
    for a, (r1, r2) in enumerate(pairs):
        for b, (c1, c2) in enumerate(pairs):
            G[a, b] = U[r1, c1] * U[r2, c2] - U[r1, c2] * U[r2, c1]
    return G, pairs


def evolve(W, psi0, steps, observe_every=1):
    """Evolve a state; record site-probability snapshots."""
    psi = np.array(psi0, dtype=complex)
    psi = psi / np.linalg.norm(psi)
    L = W.shape[0] // 2
    frames = []
    for t in range(steps + 1):
        if t % observe_every == 0:
            frames.append({
                "t": t,
                "site_probabilities":
                    [round(float(abs(psi[2 * x]) ** 2
                                 + abs(psi[2 * x + 1]) ** 2), 10)
                     for x in range(L)],
            })
        psi = W @ psi
    return frames


# ---------------------------------------------------------------- runner

def run_spec(spec):
    """Execute one simulation spec; return a deterministic result record."""
    kind = spec["kind"]
    result = {"spec": spec, "numpy": np.__version__, "tolerance": TOL}
    if kind == "walk1d":
        W = build_walk_1d(spec)
        result["unitarity_error"] = unitarity_error(W)
        result["spectrum_audit"] = pinned_modes(W)
        if "pair_sector_steps" in spec:
            G, pairs = pair_matrix(np.linalg.matrix_power(
                W, spec["pair_sector_steps"]))
            result["pair_return_probabilities"] = {
                str(pairs[a]): round(float(abs(G[a, a]) ** 2), 10)
                for a in range(len(pairs))}
        if "evolve" in spec:
            ev = spec["evolve"]
            psi0 = np.zeros(2 * spec["L"], dtype=complex)
            psi0[ev["start_index"]] = 1.0
            result["evolution"] = evolve(W, psi0, ev["steps"],
                                         ev.get("observe_every", 1))
        if "window_charge" in spec:
            result["window_charge"] = window_charges(spec, W)
        if spec.get("check_chiral_grading") and spec.get("family") == "SC":
            G = chiral_grading(spec)
            K = (W - W.conj().T) / 2j
            result["chiral_grading"] = {
                "gamma_W_gamma_minus_Wdag":
                    float(np.max(np.abs(G @ W @ G - W.conj().T))),
                "gamma_K_plus_K_gamma":
                    float(np.max(np.abs(G @ K + K @ G))),
                "gamma_squared_minus_id":
                    float(np.max(np.abs(G @ G - np.eye(2 * spec["L"])))),
            }
    elif kind == "symbol3plus1":
        U = symbol_3plus1(spec["qx"], spec["qy"], spec["qz"], spec["theta"])
        result["unitarity_error"] = unitarity_error(U)
        result["det_U_minus_1"] = repr(complex(np.linalg.det(U - np.eye(4))))
        result["det_U_plus_1"] = repr(complex(np.linalg.det(U + np.eye(4))))
        evals = np.linalg.eigvals(U)
        result["quasienergies"] = sorted(round(float(a), 10)
                                         for a in np.angle(evals))
    else:
        raise ValueError(f"unknown spec kind: {kind}")

    payload = json.dumps(result, sort_keys=True, default=str)
    result["sha256"] = hashlib.sha256(payload.encode()).hexdigest()
    return result


DEMOS = [
    # the run's two-wall complex-coin ring: pinned exact +-1 modes
    {"kind": "walk1d", "L": 8, "family": "SC", "cos_t": 0.8, "sin_t": 0.6,
     "field": [1, 1, 1, 1, -1, -1, -1, -1],
     "evolve": {"start_index": 8, "steps": 12, "observe_every": 4}},
    # constant control: gapped, no pinned modes
    {"kind": "walk1d", "L": 8, "family": "SC", "cos_t": 0.8, "sin_t": 0.6,
     "field": [1] * 8},
    # K6 palindromic two-wall (sector-det-blind family)
    {"kind": "walk1d", "L": 4, "family": "SCS", "cos_t": 0.8, "sin_t": 0.6,
     "field": [1, 1, -1, 1]},
    # body-center 3+1 symbol: exact +-1 modes for every mass angle
    {"kind": "symbol3plus1", "qx": np.pi / 2, "qy": np.pi / 2,
     "qz": np.pi / 2, "theta": 0.6435011087932844},
    # advisor-H2 window half-charge: two-wall kink vs constant control;
    # expected: sector-resolved defect charges exactly -1/2 at the
    # reflection-symmetric windows (sympy-verified in the run)
    {"kind": "walk1d", "L": 8, "family": "SC", "cos_t": 0.8, "sin_t": 0.6,
     "field": [1, 1, 1, 1, -1, -1, -1, -1],
     "check_chiral_grading": True,
     "window_charge": {"control_field": [1] * 8,
                       "windows": [[2, 3, 4, 5], [6, 7, 0, 1]]}},
]


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--spec", help="path to a JSON spec file")
    ap.add_argument("--demo", action="store_true", help="run built-in demos")
    ap.add_argument("--out", help="write JSON results to this path")
    args = ap.parse_args()

    specs = DEMOS if args.demo else []
    if args.spec:
        with open(args.spec, encoding="utf-8") as f:
            loaded = json.load(f)
            specs.extend(loaded if isinstance(loaded, list) else [loaded])
    if not specs:
        ap.error("provide --demo or --spec")

    results = [run_spec(s) for s in specs]
    text = json.dumps(results, indent=2, default=str)
    if args.out:
        with open(args.out, "w", encoding="utf-8", newline="\n") as f:
            f.write(text + "\n")
        print(f"wrote {args.out} ({len(results)} results)")
    else:
        for r in results:
            audit = r.get("spectrum_audit", {})
            print(r["spec"].get("kind"),
                  {k: audit[k]["multiplicity"] for k in
                   ("plus_one", "minus_one") if k in audit}
                  if audit else r.get("quasienergies"),
                  "sha", r["sha256"][:12])


if __name__ == "__main__":
    sys.exit(main())
