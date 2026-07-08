"""T2 linchpin probe: does a MULTI-EDGE (Cl(4)) carrier escape the aperture-
balancing obstruction and admit a genuine J-positive sector?

Context. The single-doublet S1-CC witness (probe_s1cc_aperture_grading.py) is
obstructed: the closure grading `b = sigma_z` and the chirality coincide in a
2-dim Clifford factor, and the Krein metric `J = sigma_x` is FORCED to
anticommute with `b` to balance closure - which then balances the aperture too
(aperture is Clifford-scalar, so `J Q_A` is b-odd whenever `J Q_C` is). No
positive sector exists there.

The rescue (manuscript S6 / STRENGTHENING_ROADMAP.md T2): a genuine two-edge
carrier has a 4-dim Clifford factor Cl(4) in which the closure bivector
`omega = gamma_1 gamma_2` and a grading `b` can be chosen so that
  * `b` ANTICOMMUTES with `omega`  (=> `J Q_C` is b-odd => closure balanced), yet
  * `b` COMMUTES with the Krein metric `J_s`  (=> `J Q_A` is b-even => aperture
    FIXED, not balanced).
The single-doublet could not do both at once; Cl(4) can. This probe builds such
a carrier explicitly and asks the decisive question:

  On the J-POSITIVE subspace, is the total Krein form `J(Q_A + Q_C)` positive-
  definite once the aperture dominates? If yes, a genuine positive physical
  sector exists, `sector_ground_mass` fires on it, and the obstruction is a
  feature of the single-doublet toy, not of the framework.

Construction (Cl(4), Hermitian rep on C^4 = C^2 (x) C^2):
  gamma_1 = sx(x)I, gamma_2 = sy(x)I, gamma_3 = sz(x)sx, gamma_4 = sz(x)sy
    (all Hermitian, anticommuting, square to I).
  omega = gamma_1 gamma_2 = i sz (x) I         closure bivector
  b     = gamma_1 = sx (x) I                    balancing grading
  J_s   = i gamma_3 gamma_4 = -I (x) sz         Krein fundamental symmetry (J_s^2=I)
Color factor C^3; A = lambda I3 (aperture strength), K skew (curvature).
  Q_A = I4 (x) A         (Clifford-scalar aperture; commutes with J)
  Q_C = omega (x) K      (closure; commutes with J)
  H_A = J Q_A,  H_C = J Q_C  (the Krein forms; J = J_s (x) I3)

Numeric oracle only; NOT a Lean result. If it confirms the escape, the Lean
witness (Matrix.PosDef on the sector) is the T2 M-target.
Usage: python Scripts/oracle/probe_multiedge_positive_sector.py
"""

import numpy as np

sx = np.array([[0, 1], [1, 0]], dtype=complex)
sy = np.array([[0, -1j], [1j, 0]], dtype=complex)
sz = np.array([[1, 0], [0, -1]], dtype=complex)
I2 = np.eye(2, dtype=complex)
I3 = np.eye(3, dtype=complex)


def kron(*mats):
    out = mats[0]
    for m in mats[1:]:
        out = np.kron(out, m)
    return out


# Cl(4) Hermitian gammas on C^4
g1 = kron(sx, I2)
g2 = kron(sy, I2)
g3 = kron(sz, sx)
g4 = kron(sz, sy)
I4 = np.eye(4, dtype=complex)

omega = g1 @ g2                     # closure bivector  = i sz (x) I
b = g1                             # balancing grading = sx (x) I
Js = 1j * g3 @ g4                  # Krein fundamental symmetry = -I (x) sz


def inertia(H, tol=1e-8):
    ev = np.linalg.eigvalsh((H + H.conj().T) / 2.0)
    return (int(np.sum(ev > tol)), int(np.sum(ev < -tol)),
            int(np.sum(np.abs(ev) <= tol)))


def is_herm(M, tol=1e-9):
    return np.allclose(M, M.conj().T, atol=tol)


# --- structural checks on the Clifford data ---
print("=== Cl(4) structural checks ===")
gammas = [g1, g2, g3, g4]
anticomm_ok = all(
    np.allclose(gammas[i] @ gammas[j] + gammas[j] @ gammas[i],
                (2.0 if i == j else 0.0) * I4)
    for i in range(4) for j in range(4))
print(f"  gammas Hermitian, anticommuting, square to I : {anticomm_ok}")
print(f"  J_s Hermitian : {is_herm(Js)};  J_s^2 = I : {np.allclose(Js @ Js, I4)}")
print(f"  b Hermitian, b^2=I : {is_herm(b) and np.allclose(b @ b, I4)}")
print(f"  b ANTICOMMUTES omega : {np.allclose(b @ omega + omega @ b, 0)}")
print(f"  b COMMUTES J_s       : {np.allclose(b @ Js - Js @ b, 0)}")
print("  (this pair - balance closure, fix aperture - is impossible in the")
print("   2-dim single-doublet factor; it is the room Cl(4) provides.)")

# --- the blocks and their Krein forms ---
K = np.zeros((3, 3), dtype=complex)
K[0, 1] = 1.0
K[1, 0] = -1.0                     # skew curvature (anti-Hermitian)
J = kron(Js, I3)


def build(lam):
    QA = kron(I4, lam * I3)        # aperture (Clifford-scalar, PD operator)
    QC = kron(omega, K)            # closure
    HA = J @ QA
    HC = J @ QC
    return QA, QC, HA, HC


QA0, QC0, HA0, HC0 = build(1.0)
print("\n=== Krein forms + grading action (aperture strength lambda=1) ===")
print(f"  H_A = J Q_A Hermitian : {is_herm(HA0)}")
print(f"  H_C = J Q_C Hermitian : {is_herm(HC0)}")
bfull = kron(b, I3)
act_A = bfull @ HA0 @ bfull
act_C = bfull @ HC0 @ bfull
print(f"  b H_A b = +H_A (aperture FIXED)     : {np.allclose(act_A, HA0)}")
print(f"  b H_C b = -H_C (closure BALANCED)   : {np.allclose(act_C, -HC0)}")
print("  => unlike the single-doublet, b negates ONLY closure, not the aperture.")

# --- the decisive question: a J-positive sector with a positive total form ---
# J-positive subspace P_J = positive eigenspace of J (J is Hermitian, J^2=1).
evJ, UJ = np.linalg.eigh(J)
Pcols = UJ[:, evJ > 0]             # columns spanning the J-positive subspace
print(f"\n=== J-positive sector ===")
print(f"  inertia(J) = {inertia(J)}; dim(J-positive subspace) = {Pcols.shape[1]}")

print("\n=== total Krein form on the J-positive sector, vs aperture strength ===")
print("  lambda |  inertia(H_A+H_C) full  |  inertia on J-positive sector  | positive sector?")
escaped = False
for lam in (0.5, 1.0, 2.0, 4.0, 8.0):
    _, _, HA, HC = build(lam)
    Htot = HA + HC
    full = inertia(Htot)
    sect = inertia(Pcols.conj().T @ Htot @ Pcols)
    pos = (sect[1] == 0 and sect[2] == 0)   # positive-definite on the sector
    escaped = escaped or pos
    print(f"  {lam:5.1f}  |  {str(full):16s}  |  {str(sect):16s}  | {pos}")

print("\n=== VERDICT ===")
if escaped:
    print("  ESCAPE CONFIRMED. On the Cl(4) carrier there IS a J-positive sector on")
    print("  which the total Krein form J(Q_A+Q_C) becomes positive-definite once the")
    print("  aperture dominates. The aperture-balancing obstruction is specific to the")
    print("  2-dim single-doublet factor; a genuine two-edge carrier escapes it and")
    print("  supplies exactly the definite positive sector `sector_ground_mass` needs.")
    print("  => T2 mechanism validated; the Lean witness (Matrix.PosDef on the sector")
    print("     feeding sector_ground_mass) is the next M-target.")
else:
    print("  NO ESCAPE at these settings: the obstruction persists even in Cl(4).")
    print("  That would be a deeper structural theorem; report and re-analyze.")

# contrast control: force b = J-anticommuting single-doublet-style grading and
# show it WOULD balance the aperture (the obstruction), to make the contrast sharp.
print("\n=== contrast: a grading that anticommutes J (single-doublet style) ===")
b_bad = g3                                   # anticommutes J_s = i g3 g4? check
print(f"  g3 anticommutes J_s : {np.allclose(g3 @ Js + Js @ g3, 0)}")
bbad = kron(b_bad, I3)
print(f"  b_bad H_A b_bad = -H_A (would balance aperture) : "
      f"{np.allclose(bbad @ HA0 @ bbad, -HA0)}")
print("  (a J-anticommuting grading balances the aperture - the single-doublet")
print("   trap; the point is that Cl(4) lets us AVOID choosing such a b.)")
