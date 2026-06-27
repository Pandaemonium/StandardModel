#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Flat tetrahedral retarded null-edge Dirac branch-count oracle.

Standalone, stdlib-only raw-data generator for the flat retarded dual-soldered
null-edge Dirac symbol. It computes the branch (singularity) data described in:

  - docs/CONVENTIONS.md, "Branch-count / no-doubling test".
  - Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md, Sections 20-21
    (Gate C: flat branch and stability audit).
  - AgentTasks/null-edge-flat-branch-count-protocol.md (full protocol).

This is an ORACLE, not a trusted proof (AGENTS.md "CAS and oracle policy"). It
emits raw, machine-readable branch data and deliberately keeps physical
interpretation (doubler vs cutoff artifact vs Krein-nonphysical) out of the raw
tables; classification is left to a separate audit.

Core objects (mostly-minus metric g = diag(+,-,-,-), lattice spacing h):

    u_a    = exp(i q_a) - 1
    G^{-1} = -3/4 I + 1/4 J            (tetrahedral inverse Gram, d = 4)
    p(q)_mu = h^{-1} sum_a u_a alpha^a_mu
    p(q)^2 = u^T G^{-1} u / h^2 = h^{-2} ( -3/4 S2 + 1/4 S1^2 )
             with S1 = sum_a u_a, S2 = sum_a u_a^2.

The branch test is determinant-level, det c(p(q)) = (p^2)^2 = 0 (massless), or
det( i c(p) + m gamma5 ) = (m^2 - p^2)^2 = 0 (mass-shell p^2 = m^2). The
coefficient-vector test p(q) = 0 is NOT used as a branch criterion (it only
detects coefficient-zero doublers, i.e. q = 0).

GUARDRAILS (carried verbatim from the protocol; do not weaken):
  - Retardedness avoids coefficient-zero doublers only; determinant-level
    branches remain to be tested.
  - The physical test is det c(p(q)) = 0 (massless p(q)^2 = 0), not p(q) = 0.
  - This script does NOT certify the operator safe or unsafe from raw data
    alone.

Usage:
    python3 null_edge_branch_count.py [--outdir DIR] [--grid N]
        [--slice-grid N] [--mass M] [--h H] [--seed S] [--tol T]

With --outdir set, CSV/JSON tables are written there. A JSON summary is always
printed to stdout. The script never touches repository build artifacts.
"""

from __future__ import annotations

import argparse
import cmath
import csv
import itertools
import json
import math
import os
import random
import sys

# ---------------------------------------------------------------------------
# Minimal complex 4x4 linear algebra (stdlib only).
# ---------------------------------------------------------------------------


def mat_zeros(n):
    return [[0j for _ in range(n)] for _ in range(n)]


def mat_ident(n):
    m = mat_zeros(n)
    for i in range(n):
        m[i][i] = 1 + 0j
    return m


def mat_add(a, b):
    n = len(a)
    return [[a[i][j] + b[i][j] for j in range(n)] for i in range(n)]


def mat_scale(a, s):
    n = len(a)
    return [[a[i][j] * s for j in range(n)] for i in range(n)]


def mat_mul(a, b):
    n = len(a)
    out = mat_zeros(n)
    for i in range(n):
        ai = a[i]
        for k in range(n):
            aik = ai[k]
            if aik == 0:
                continue
            bk = b[k]
            oi = out[i]
            for j in range(n):
                oi[j] += aik * bk[j]
    return out


def mat_det(a):
    """Determinant of a complex matrix via Gaussian elimination with pivoting."""
    n = len(a)
    m = [row[:] for row in a]
    det = 1 + 0j
    for col in range(n):
        piv = max(range(col, n), key=lambda r: abs(m[r][col]))
        if abs(m[piv][col]) == 0:
            return 0j
        if piv != col:
            m[col], m[piv] = m[piv], m[col]
            det = -det
        det *= m[col][col]
        inv = 1 / m[col][col]
        for r in range(col + 1, n):
            factor = m[r][col] * inv
            if factor == 0:
                continue
            for c in range(col, n):
                m[r][c] -= factor * m[col][c]
    return det


def mat_rank(a, tol):
    """Numerical rank of a complex matrix via Gaussian elimination."""
    n = len(a)
    m = [row[:] for row in a]
    rank = 0
    rows = list(range(n))
    for col in range(n):
        # find pivot among remaining rows
        pivot_row = None
        best = tol
        for r in rows:
            if abs(m[r][col]) > best:
                best = abs(m[r][col])
                pivot_row = r
        if pivot_row is None:
            continue
        rows.remove(pivot_row)
        rank += 1
        inv = 1 / m[pivot_row][col]
        for r in rows:
            factor = m[r][col] * inv
            if factor == 0:
                continue
            for c in range(col, n):
                m[r][c] -= factor * m[pivot_row][c]
    return rank


def kernel_dim(a, tol):
    return len(a) - mat_rank(a, tol)


def mat_trace(a):
    return sum(a[i][i] for i in range(len(a)))


# ---------------------------------------------------------------------------
# Gamma matrices (Dirac representation), mostly-minus g = diag(+,-,-,-).
# {gamma^mu, gamma^nu} = 2 g^{mu nu} I, so c(p)^2 = p^2 I and det c(p) = (p^2)^2.
# ---------------------------------------------------------------------------

# Pauli matrices.
SIGMA = [
    [[0, 1], [1, 0]],            # sigma_1
    [[0, -1j], [1j, 0]],         # sigma_2
    [[1, 0], [0, -1]],           # sigma_3
]


def build_gammas():
    I2 = [[1, 0], [0, 1]]
    Z2 = [[0, 0], [0, 0]]

    def block(tl, tr, bl, br):
        m = mat_zeros(4)
        for i in range(2):
            for j in range(2):
                m[i][j] = complex(tl[i][j])
                m[i][j + 2] = complex(tr[i][j])
                m[i + 2][j] = complex(bl[i][j])
                m[i + 2][j + 2] = complex(br[i][j])
        return m

    g0 = block(I2, Z2, Z2, [[-1, 0], [0, -1]])
    gammas = [g0]
    for k in range(3):
        s = SIGMA[k]
        neg_s = [[-s[0][0], -s[0][1]], [-s[1][0], -s[1][1]]]
        gammas.append(block(Z2, s, neg_s, Z2))
    # gamma5 = i g0 g1 g2 g3 = [[0, I],[I, 0]] in this representation.
    g5 = block(Z2, I2, I2, Z2)
    return gammas, g5


GAMMAS, GAMMA5 = build_gammas()


def clifford(p):
    """c(p) = gamma^mu p_mu for covector components p = (p0, p1, p2, p3)."""
    out = mat_zeros(4)
    for mu in range(4):
        out = mat_add(out, mat_scale(GAMMAS[mu], complex(p[mu])))
    return out


# ---------------------------------------------------------------------------
# Tetrahedral dual null frame and the symbol map.
# ---------------------------------------------------------------------------

SQRT3 = math.sqrt(3.0)

# Spatial tetrahedral directions s_A (Open Questions 6.9).
S_DIRS = [
    (1.0, 1.0, 1.0),
    (1.0, -1.0, -1.0),
    (-1.0, 1.0, -1.0),
    (-1.0, -1.0, 1.0),
]


def alpha_covectors():
    """alpha^A = (1/4) dt + (3/4) n_A . dx with n_A = s_A / sqrt(3)."""
    alphas = []
    for s in S_DIRS:
        n = (s[0] / SQRT3, s[1] / SQRT3, s[2] / SQRT3)
        alphas.append((0.25, 0.75 * n[0], 0.75 * n[1], 0.75 * n[2]))
    return alphas


ALPHAS = alpha_covectors()


def minkowski_dot(a, b):
    """g^{-1}(a, b) for covectors with g = diag(+,-,-,-)."""
    return a[0] * b[0] - a[1] * b[1] - a[2] * b[2] - a[3] * b[3]


def inverse_gram():
    """G^{-1}_{ab} = g^{-1}(alpha^a, alpha^b)."""
    n = len(ALPHAS)
    return [[minkowski_dot(ALPHAS[a], ALPHAS[b]) for b in range(n)] for a in range(n)]


def expected_inverse_gram(d=4):
    """-(d-1)/d I + (1/d) J."""
    g = [[(1.0 / d) for _ in range(d)] for _ in range(d)]
    for i in range(d):
        g[i][i] += -(d - 1.0) / d
    return g


def u_of_q(q):
    """u_a = exp(i q_a) - 1."""
    return [cmath.exp(1j * qa) - 1 for qa in q]


def symbol_covector(u, h=1.0):
    """p(q)_mu = h^{-1} sum_a u_a alpha^a_mu."""
    p = [0j, 0j, 0j, 0j]
    for a, ua in enumerate(u):
        for mu in range(4):
            p[mu] += ua * ALPHAS[a][mu]
    return [pm / h for pm in p]


def p_squared_quadform(u, h=1.0):
    """p^2 = h^{-2} ( -3/4 S2 + 1/4 S1^2 )."""
    s1 = sum(u)
    s2 = sum(ua * ua for ua in u)
    return (-0.75 * s2 + 0.25 * s1 * s1) / (h * h)


def p_squared_spacetime(p):
    """p^2 = g^{-1}(p, p) from spacetime covector components."""
    return p[0] * p[0] - p[1] * p[1] - p[2] * p[2] - p[3] * p[3]


# ---------------------------------------------------------------------------
# Regression checks (Section 7 steps 1-2): the build is internally consistent.
# ---------------------------------------------------------------------------


def regression_checks(seed, tol):
    rng = random.Random(seed)
    report = {}

    # 1. Inverse Gram matches -3/4 I + 1/4 J.
    G = inverse_gram()
    Gexp = expected_inverse_gram(4)
    gram_err = max(
        abs(G[a][b] - Gexp[a][b]) for a in range(4) for b in range(4)
    )
    report["inverse_gram_max_abs_error"] = gram_err
    report["inverse_gram_matches_minus34I_plus14J"] = bool(gram_err < 1e-12)
    report["inverse_gram"] = [[round(G[a][b], 12) for b in range(4)] for a in range(4)]

    # 2. p^2 quadratic form vs spacetime build, on random real q.
    p2_err = 0.0
    det_err = 0.0
    csq_err = 0.0
    for _ in range(64):
        q = [rng.uniform(-math.pi, math.pi) for _ in range(4)]
        u = u_of_q(q)
        p = symbol_covector(u)
        p2_quad = p_squared_quadform(u)
        p2_space = p_squared_spacetime(p)
        p2_err = max(p2_err, abs(p2_quad - p2_space))

        cp = clifford(p)
        # det c(p) = (p^2)^2.
        det_cp = mat_det(cp)
        det_err = max(det_err, abs(det_cp - p2_space * p2_space))
        # c(p)^2 = p^2 I.
        cp2 = mat_mul(cp, cp)
        target = mat_scale(mat_ident(4), p2_space)
        csq_err = max(
            csq_err,
            max(abs(cp2[i][j] - target[i][j]) for i in range(4) for j in range(4)),
        )

    report["p2_quadform_vs_spacetime_max_error"] = p2_err
    report["det_cp_equals_p2_squared_max_error"] = det_err
    report["cp_squared_equals_p2_I_max_error"] = csq_err

    # 3. det( i c(p) + m gamma5 ) = (m^2 - p^2)^2, on random real q and m.
    massdet_err = 0.0
    for _ in range(64):
        q = [rng.uniform(-math.pi, math.pi) for _ in range(4)]
        m = rng.uniform(-2.0, 2.0)
        u = u_of_q(q)
        p = symbol_covector(u)
        p2 = p_squared_spacetime(p)
        op = mat_add(mat_scale(clifford(p), 1j), mat_scale(GAMMA5, m))
        det_op = mat_det(op)
        massdet_err = max(massdet_err, abs(det_op - (m * m - p2) ** 2))
    report["det_massive_equals_m2_minus_p2_squared_max_error"] = massdet_err

    report["all_regressions_pass"] = bool(
        gram_err < 1e-10
        and p2_err < 1e-9
        and det_err < 1e-7
        and csq_err < 1e-9
        and massdet_err < 1e-7
    )
    return report


# ---------------------------------------------------------------------------
# Section 3 discrete corner scan: q_a in {0, pi}^4.
# ---------------------------------------------------------------------------


def corner_scan(mass, tol):
    rows = []
    for bits in itertools.product([0, 1], repeat=4):
        q = [math.pi if b else 0.0 for b in bits]
        u = u_of_q(q)
        p = symbol_covector(u)
        p2 = p_squared_spacetime(p)
        p2_real = p2.real
        # corners are exactly real; tag mass-shell membership.
        on_massshell = abs(p2 - mass * mass) < 1e-9
        is_null = abs(p2) < 1e-9
        cp = clifford(p)
        op = mat_add(mat_scale(cp, 1j), mat_scale(GAMMA5, mass))
        ker = kernel_dim(op, tol)
        ker_massless = kernel_dim(cp, tol)
        num_pi = sum(bits)
        rows.append(
            {
                "q_over_pi": list(bits),
                "u_real": [round(ua.real, 12) for ua in u],
                "num_pi": num_pi,
                "p2_re": round(p2_real, 12),
                "p2_im": round(p2.imag, 12),
                "is_massless_null": bool(is_null),
                "on_massshell_p2_eq_m2": bool(on_massshell),
                "clifford_kernel_dim_massless": ker_massless,
                "kernel_dim_massive_op": ker,
                "krein_doubled_kernel_dim": 2 * ker,
            }
        )
    return rows


# ---------------------------------------------------------------------------
# High-symmetry candidate enumeration (Sections 2-3, 5).
# ---------------------------------------------------------------------------


def high_symmetry_candidates(mass, tol):
    cands = []

    def record(label, q, note):
        u = u_of_q(q)
        p = symbol_covector(u)
        p2 = p_squared_spacetime(p)
        p2_quad = p_squared_quadform(u)
        s1 = sum(u)
        s2 = sum(ua * ua for ua in u)
        cp = clifford(p)
        op = mat_add(mat_scale(cp, 1j), mat_scale(GAMMA5, mass))
        cands.append(
            {
                "label": label,
                "q": [round(qa, 12) for qa in q],
                "q_over_pi": [round(qa / math.pi, 6) for qa in q],
                "u_re": [round(ua.real, 12) for ua in u],
                "u_im": [round(ua.imag, 12) for ua in u],
                "p_re": [round(pm.real, 12) for pm in p],
                "p_im": [round(pm.imag, 12) for pm in p],
                "coeff_vector_p_is_zero": bool(
                    max(abs(pm) for pm in p) < 1e-12
                ),
                "S1_re": round(s1.real, 12),
                "S1_im": round(s1.imag, 12),
                "S2_re": round(s2.real, 12),
                "S2_im": round(s2.imag, 12),
                "p2_re": round(p2.real, 12),
                "p2_im": round(p2.imag, 12),
                "p2_quadform_re": round(p2_quad.real, 12),
                "uTGinv_u_re": round((p2_quad).real, 12),
                "is_massless_null": bool(abs(p2) < 1e-9),
                "on_massshell_p2_eq_m2": bool(abs(p2 - mass * mass) < 1e-9),
                "clifford_kernel_dim_massless": kernel_dim(cp, tol),
                "kernel_dim_massive_op": kernel_dim(op, tol),
                "krein_doubled_kernel_dim": 2 * kernel_dim(op, tol),
                "note": note,
            }
        )

    # Physical / continuum point.
    record("origin", [0.0, 0.0, 0.0, 0.0], "continuum / physical point")

    # The decisive warning corner and its three-pi permutations.
    pi = math.pi
    three_pi = [
        ("three_pi_corner_4zero", [pi, pi, pi, 0.0]),
        ("three_pi_corner_3zero", [pi, pi, 0.0, pi]),
        ("three_pi_corner_2zero", [pi, 0.0, pi, pi]),
        ("three_pi_corner_1zero", [0.0, pi, pi, pi]),
    ]
    for label, q in three_pi:
        record(label, q, "high-momentum null doubler candidate (det-level branch)")

    # All-pi timelike corner (not a null branch).
    record("all_pi_corner", [pi, pi, pi, pi], "timelike corner, p2 = +4, not null")

    # Single-pi and double-pi spacelike corners (representatives).
    record("one_pi_corner", [pi, 0.0, 0.0, 0.0], "spacelike corner, p2 = -2")
    record("two_pi_corner", [pi, pi, 0.0, 0.0], "spacelike corner, p2 = -2")

    return cands


# ---------------------------------------------------------------------------
# Energy-slice (propagating-branch) enumeration (Section 6, step 4).
# Fix three real spatial edge phases; solve the quadratic for u_1, classify the
# root real (|z1| = 1, propagating) vs complex (|z1| != 1, damped/growing).
# ---------------------------------------------------------------------------


def solve_quadratic(a2, a1, a0):
    """Roots of a2 x^2 + a1 x + a0 = 0 (complex)."""
    if abs(a2) < 1e-300:
        if abs(a1) < 1e-300:
            return []
        return [-a0 / a1]
    disc = cmath.sqrt(a1 * a1 - 4 * a2 * a0)
    return [(-a1 + disc) / (2 * a2), (-a1 - disc) / (2 * a2)]


def energy_slice_scan(mass, slice_grid, tol):
    """For a grid of real (q2, q3, q4), solve p^2 = m^2 for u_1, tag roots."""
    rows = []
    n_real = 0
    n_complex = 0
    if slice_grid < 1:
        slice_grid = 1
    step = 2 * math.pi / slice_grid
    grid = [(-math.pi + (i + 0.5) * step) for i in range(slice_grid)]
    for q2 in grid:
        for q3 in grid:
            for q4 in grid:
                uvec = u_of_q([0.0, q2, q3, q4])
                t1 = uvec[1] + uvec[2] + uvec[3]
                t2 = uvec[1] ** 2 + uvec[2] ** 2 + uvec[3] ** 2
                # -1/2 a^2 + 1/2 T1 a + (1/4 T1^2 - 3/4 T2) - m^2 = 0
                a2 = -0.5 + 0j
                a1 = 0.5 * t1
                a0 = 0.25 * t1 * t1 - 0.75 * t2 - mass * mass
                roots = solve_quadratic(a2, a1, a0)
                for a in roots:
                    z1 = a + 1.0
                    is_real = abs(abs(z1) - 1.0) < 1e-7
                    if is_real:
                        n_real += 1
                        q1 = cmath.phase(z1)
                    else:
                        n_complex += 1
                        q1 = None
                    rows.append(
                        {
                            "q2": round(q2, 9),
                            "q3": round(q3, 9),
                            "q4": round(q4, 9),
                            "u1_re": round(a.real, 12),
                            "u1_im": round(a.imag, 12),
                            "abs_z1": round(abs(z1), 12),
                            "log_abs_z1": round(math.log(abs(z1)) if abs(z1) > 0 else float("-inf"), 12),
                            "real_propagating_branch": bool(is_real),
                            "q1_if_real": (round(q1, 12) if q1 is not None else None),
                        }
                    )
    summary = {
        "slice_grid_per_dim": slice_grid,
        "spatial_points": slice_grid ** 3,
        "roots_total": len(rows),
        "real_propagating_roots": n_real,
        "complex_energy_roots": n_complex,
        "note": (
            "Generic real spatial slices yield complex-energy roots "
            "(|z1| != 1): pervasive complex branches (Chernodub-style "
            "warning, arXiv:1701.07426). Real propagating roots live on a "
            "measure-zero locus."
        ),
    }
    return summary, rows


# ---------------------------------------------------------------------------
# Optional numerical grid scan over real q (Section 6): count null grid points.
# ---------------------------------------------------------------------------


def grid_scan(mass, grid_n, tol):
    if grid_n < 1:
        grid_n = 1
    pts = [2 * math.pi * k / grid_n for k in range(grid_n)]
    n_null = 0
    n_massshell = 0
    max_abs_im_p2 = 0.0
    sample_null = []
    for q in itertools.product(pts, repeat=4):
        u = u_of_q(list(q))
        p2 = p_squared_quadform(u)
        max_abs_im_p2 = max(max_abs_im_p2, abs(p2.imag))
        if abs(p2) < 1e-9:
            n_null += 1
            if len(sample_null) < 16:
                sample_null.append([round(qa / math.pi, 6) for qa in q])
        if abs(p2 - mass * mass) < 1e-9:
            n_massshell += 1
    return {
        "grid_n_per_dim": grid_n,
        "total_points": grid_n ** 4,
        "massless_null_grid_points": n_null,
        "massshell_grid_points_p2_eq_m2": n_massshell,
        "max_abs_imaginary_part_p2": round(max_abs_im_p2, 12),
        "sample_null_points_q_over_pi": sample_null,
        "note": (
            "p2 is complex-valued on the real torus; massless condition "
            "p2 = 0 is two real equations on T^4, so the null set is "
            "generically a 2-real-dimensional variety (point count scales "
            "like a surface)."
        ),
    }


# ---------------------------------------------------------------------------
# Krein doubling note (Section 7, step 8): multiplicity only, not safety.
# ---------------------------------------------------------------------------

KREIN_NOTE = (
    "Krein doubling D_dbl = [[0, D_-], [D_+, 0]] with D_- = J D_+^dagger J gives "
    "det D_dbl = +/- det D_+ * det D_-, so each branch multiplicity doubles "
    "(a 2-dim massless Clifford kernel becomes 4-dim). The J-inner-product sign "
    "on each kernel is classification data, NOT a stability/positivity/real-"
    "spectrum certificate (Working Plan 20.6)."
)


# ---------------------------------------------------------------------------
# I/O helpers.
# ---------------------------------------------------------------------------


def write_csv(path, rows):
    if not rows:
        with open(path, "w", encoding="utf-8", newline="") as fh:
            fh.write("")
        return
    # Flatten list-valued fields to JSON strings for CSV.
    fieldnames = list(rows[0].keys())
    with open(path, "w", encoding="utf-8", newline="") as fh:
        writer = csv.DictWriter(fh, fieldnames=fieldnames, lineterminator="\n")
        writer.writeheader()
        for row in rows:
            out = {}
            for k, v in row.items():
                if isinstance(v, (list, dict)):
                    out[k] = json.dumps(v)
                else:
                    out[k] = v
            writer.writerow(out)


def write_json(path, obj):
    with open(path, "w", encoding="utf-8", newline="\n") as fh:
        json.dump(obj, fh, indent=2, sort_keys=False)
        fh.write("\n")


# ---------------------------------------------------------------------------
# Main.
# ---------------------------------------------------------------------------


def build_report(args):
    tol = args.tol
    report = {
        "title": "Flat tetrahedral retarded null-edge Dirac branch-count raw data",
        "kind": "oracle (raw branch data; not a proof; not a safety certificate)",
        "conventions": {
            "metric": "mostly-minus g = diag(+,-,-,-)",
            "u_a": "exp(i q_a) - 1",
            "inverse_gram": "G^{-1} = -3/4 I + 1/4 J",
            "p_squared": "p(q)^2 = u^T G^{-1} u / h^2",
            "branch_test": "det c(p(q)) = 0  (massless p^2 = 0), NOT p(q) = 0",
            "mass_shell": "det(i c(p) + m gamma5) = (m^2 - p^2)^2 = 0",
            "h": args.h,
            "mass": args.mass,
        },
        "guardrails": [
            "Retardedness avoids coefficient-zero doublers only; "
            "determinant-level branches remain to be tested.",
            "The physical test is det c(p(q)) = 0 (massless p(q)^2 = 0), "
            "not p(q) = 0; a nonzero Lorentzian null covector has Clifford "
            "kernel.",
            "This raw data does NOT certify the operator safe or unsafe.",
            "Coefficient-vector zeros are NOT used as a branch criterion.",
        ],
        "regression_checks": regression_checks(args.seed, tol),
        "high_symmetry_candidates": high_symmetry_candidates(args.mass, tol),
        "discrete_corner_scan": corner_scan(args.mass, tol),
        "krein_doubling_note": KREIN_NOTE,
    }

    # Discrete corner summary (raw counts only).
    corners = report["discrete_corner_scan"]
    report["discrete_corner_summary"] = {
        "total_corners": len(corners),
        "massless_null_corners": sum(1 for c in corners if c["is_massless_null"]),
        "massless_null_corner_count_note": (
            "Massless: expect 5 = 1 origin + 4 three-pi corners "
            "(retardedness removes coefficient-zero corners but leaves 4 "
            "determinant-level corner branches; compare naive 16)."
        ),
    }

    slice_summary, slice_rows = energy_slice_scan(args.mass, args.slice_grid, tol)
    report["energy_slice_summary"] = slice_summary

    report["grid_scan"] = grid_scan(args.mass, args.grid, tol)

    return report, slice_rows


def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Flat tetrahedral retarded null-edge Dirac branch-count oracle."
    )
    parser.add_argument("--outdir", default=None,
                        help="Directory to write CSV/JSON tables (optional).")
    parser.add_argument("--grid", type=int, default=8,
                        help="Grid points per dimension for the real torus scan.")
    parser.add_argument("--slice-grid", type=int, default=6,
                        help="Grid points per dimension for the energy-slice scan.")
    parser.add_argument("--mass", type=float, default=0.0,
                        help="Internal scalar mass m (mass-shell p^2 = m^2).")
    parser.add_argument("--h", type=float, default=1.0,
                        help="Lattice spacing h (symbol normalization).")
    parser.add_argument("--seed", type=int, default=20260626,
                        help="RNG seed for regression sampling.")
    parser.add_argument("--tol", type=float, default=1e-9,
                        help="Numerical tolerance for ranks/kernels.")
    args = parser.parse_args(argv)

    report, slice_rows = build_report(args)

    if args.outdir:
        os.makedirs(args.outdir, exist_ok=True)
        write_json(os.path.join(args.outdir, "branch_count_report.json"), report)
        write_csv(
            os.path.join(args.outdir, "branch_count_corners.csv"),
            report["discrete_corner_scan"],
        )
        write_csv(
            os.path.join(args.outdir, "branch_count_high_symmetry.csv"),
            report["high_symmetry_candidates"],
        )
        write_csv(
            os.path.join(args.outdir, "branch_count_energy_slice.csv"),
            slice_rows,
        )
        report["energy_slice_rows_written"] = len(slice_rows)
        report["outdir"] = os.path.abspath(args.outdir)

    json.dump(report, sys.stdout, indent=2, sort_keys=False)
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
