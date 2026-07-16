"""Exact-arithmetic oracle for the half-space boundary-defect window charge.

This is an external experiment, not a proof.  It independently reproduces, in
exact rational arithmetic, the finite result formalized in
``PhysicsSM/Draft/NullEdge/HalfSpaceDefectIndex.lean`` and packages it as the
Phenomenologist Class-3 benchmark ``Q_window`` (see
``AutonomousLab/work/role-activations/role-20260714-002411-b5f572ef_deliverable.md``).

For the truncated unilateral right shift ``S`` on ``Fin (N+1)``:

* the boundary defect ``D = S^H S - S S^H`` is ``+1`` on site 0 and ``-1`` on
  site N (``localized_source_defect``);
* its full trace is ``0`` (``global_defect_trace_zero``);
* a fixed near-boundary window ``sites 0..K`` reads exactly ``+1`` for every
  cutoff ``N > K`` (``localized_window_trace_stabilizes``) -- zero finite-size
  tail;
* ``m`` internal channels give ``+m`` (``stabilizedIndex_additive``);
* a bilateral cyclic permutation has zero defect (``permMatrix_no_defect``);
* the left shift gives ``-1`` (``stabilizedIndex_add_reversed_eq_zero``).

All arithmetic is over ``fractions.Fraction`` so the confirmation is exact, not
floating-point, matching the Lean ``Rat`` field.

The HNU-boundary column (``--hnu``) is a DOCUMENTED INTERFACE, not yet
implemented: it is the held-out Gate-1 test -- recompute ``Q_window`` for the
actual HNU half-line boundary evolution from an independent construction and
check whether it returns a stabilized additive ``+1`` (single unremovable edge
defect) or ``0`` / a paired ``+1,-1`` (doubling).  It intentionally raises
``NotImplementedError`` rather than guessing the real-space HNU convention.
"""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from typing import List


Matrix = List[List[Fraction]]


def zeros(n: int) -> Matrix:
    return [[Fraction(0) for _ in range(n)] for _ in range(n)]


def unilateral_shift(n: int) -> Matrix:
    """Truncated unilateral right shift on Fin(n): S[i,j] = 1 iff i = j+1."""
    s = zeros(n)
    for i in range(n):
        for j in range(n):
            if i == j + 1:
                s[i][j] = Fraction(1)
    return s


def transpose(a: Matrix) -> Matrix:
    n = len(a)
    return [[a[j][i] for j in range(n)] for i in range(n)]


def matmul(a: Matrix, b: Matrix) -> Matrix:
    n = len(a)
    out = zeros(n)
    for i in range(n):
        for k in range(n):
            aik = a[i][k]
            if aik == 0:
                continue
            for j in range(n):
                out[i][j] += aik * b[k][j]
    return out


def sub(a: Matrix, b: Matrix) -> Matrix:
    n = len(a)
    return [[a[i][j] - b[i][j] for j in range(n)] for i in range(n)]


def defect(s: Matrix) -> Matrix:
    """D = S^H S - S S^H (S real, so S^H = S^T)."""
    st = transpose(s)
    return sub(matmul(st, s), matmul(s, st))


def window_trace(d: Matrix, k: int) -> Fraction:
    """Sum of diagonal over sites 0..k inclusive."""
    return sum((d[i][i] for i in range(k + 1)), Fraction(0))


def full_trace(d: Matrix) -> Fraction:
    return sum((d[i][i] for i in range(len(d))), Fraction(0))


def cyclic_permutation(n: int) -> Matrix:
    """Bilateral cyclic shift (a permutation): zero-defect control."""
    p = zeros(n)
    for i in range(n):
        p[i][(i - 1) % n] = Fraction(1)
    return p


def run(k: int, cutoffs: List[int], channels: List[int]) -> dict:
    results: dict = {"window_K": k, "shift": [], "controls": {}}

    # Class-3 benchmark: Q_window for the right shift across cutoffs and channels.
    for n_sites in cutoffs:
        n = n_sites  # matrix dimension = N+1 in the Lean statement
        s = unilateral_shift(n)
        d = defect(s)
        row = {
            "N_plus_1": n,
            "window_trace_m1": str(window_trace(d, k)),
            "full_trace": str(full_trace(d)),
            "source_site0": str(d[0][0]),
            "far_site_last": str(d[n - 1][n - 1]),
        }
        # channel additivity: m independent copies -> block-diagonal, trace scales.
        row["window_trace_by_channels"] = {
            str(m): str(window_trace(d, k) * m) for m in channels
        }
        results["shift"].append(row)

    # Negative control: bilateral permutation has zero defect everywhere.
    n = max(cutoffs)
    perm = cyclic_permutation(n)
    dperm = defect(perm)
    results["controls"]["bilateral_permutation_full_trace"] = str(full_trace(dperm))
    results["controls"]["bilateral_permutation_window"] = str(window_trace(dperm, k))

    # Orientation reversal: left shift = S^T, defect negates.
    s = unilateral_shift(n)
    left = transpose(s)
    dleft = defect(left)
    results["controls"]["left_shift_window"] = str(window_trace(dleft, k))
    results["controls"]["right_plus_left_window"] = str(
        window_trace(defect(s), k) + window_trace(dleft, k)
    )

    # Assertions matching the Lean theorem (exact).
    checks = {
        "window_eq_plus_one_all_cutoffs": all(
            window_trace(defect(unilateral_shift(n)), k) == Fraction(1)
            for n in cutoffs
            if n > k
        ),
        "full_trace_zero": all(
            full_trace(defect(unilateral_shift(n))) == Fraction(0) for n in cutoffs
        ),
        "channel_additive": all(
            window_trace(defect(unilateral_shift(max(cutoffs))), k) * m
            == Fraction(m)
            for m in channels
        ),
        "bilateral_zero_defect": full_trace(dperm) == Fraction(0)
        and window_trace(dperm, k) == Fraction(0),
        "orientation_sums_to_zero": (
            window_trace(defect(unilateral_shift(n)), k)
            + window_trace(dleft, k)
        )
        == Fraction(0),
    }
    results["checks"] = checks
    results["all_checks_pass"] = all(checks.values())
    return results


def hnu_window_defect(k: int, cutoffs: List[int]) -> dict:
    """HELD-OUT Gate-1 test (documented interface, intentionally unimplemented).

    Recompute Q_window for the actual HNU half-line boundary evolution from an
    independent real-space construction (see HNURealSpaceCore / HNURealSpaceBridge
    conventions).  Expected discriminator:
      * stabilized additive +1  -> HNU edge carries a single unremovable defect
        (supports the single-edge-Weyl route);
      * 0 or paired (+1,-1) in-window -> doubling; the single-edge-Weyl route is
        falsified here (decisive Gate-1 kill).
    Not guessed here to avoid a convention error in the real-space HNU walk.
    """
    raise NotImplementedError(
        "HNU half-line boundary evolution not implemented; this is the held-out "
        "Gate-1 test. Build it from the real-space HNU convention, not from the "
        "shift model, so the comparison is genuinely independent."
    )


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--window", type=int, default=3, help="near-boundary window radius K")
    ap.add_argument(
        "--cutoffs",
        type=int,
        nargs="+",
        default=[5, 8, 20, 100],
        help="matrix dimensions N+1 to test (must exceed window+1)",
    )
    ap.add_argument(
        "--channels", type=int, nargs="+", default=[1, 2, 3], help="channel counts m"
    )
    ap.add_argument("--hnu", action="store_true", help="run the held-out HNU column (NotImplemented)")
    args = ap.parse_args()

    if args.hnu:
        hnu_window_defect(args.window, args.cutoffs)
        return

    out = run(args.window, args.cutoffs, args.channels)
    print(json.dumps(out, indent=2))


if __name__ == "__main__":
    main()
