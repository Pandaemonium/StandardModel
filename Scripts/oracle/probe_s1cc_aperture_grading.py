"""S1-CC adversarial probe (Fable call-04): does the closure grading `b` balance
ONLY the closure block, or the WHOLE operator?

Fable call-04's central adversarial finding: the S1-CC resolution's escape
route ("physical positivity comes from the J-definite complement of the closure
doublet") silently requires that the closure bivector `b = sigma_z (x) I`
anticonjugates ONLY `J Q_C`, and FIXES `J Q_A` and `J Q_T`. If `b` also
anticonjugates `J(Q_A + Q_T)`, then `J D^#D` is balanced on EVERY b-invariant
sector, `min spec < 0`, "mass" is indefinite, and the ground-state program
(manuscript S4 rail 3, S10 crux 0) collapses.

Structural prediction (this probe tests it): with the S1-CC witness's own
`J = sigma_x (x) I` and `b = sigma_z (x) I`, we have `J b = - b J` (sigma_x
anticommutes with sigma_z). So for ANY block `M = (sigma_z-even) (x) color`
(identity or sigma_z on the Clifford factor), `J M` is sigma_z-ODD and hence
b-NEGATED. The aperture `Q_A = {gamma,gamma}(x)transport = I (x) A` (the
anticommutator is a scalar in the Clifford factor) and the turn
`Q_T = phi^2 = I (x) T` (Gamma-even) are BOTH `I (x) color`, hence sigma_z-even,
hence their J-forms are b-NEGATED too. Only a block that is sigma_z-ODD in the
Clifford factor (sigma_x/sigma_y (x) color) would have a b-FIXED J-form.

Kill condition: if `J Q_A` and `J Q_T` are b-negated on the natural witness
structure, the balanced-closure escape route FAILS on the toy - a genuine
positive aperture must then come from Clifford/metric structure the closure-only
witness omits (an indefinite metric g giving Q_A genuine Clifford content, or a
different J). This does NOT by itself kill the resolution in a real carrier, but
it shows the current witness cannot exhibit the escape, and it pre-registers the
exact structural feature a rescuing carrier must have.

Numeric oracle only; NOT a Lean result.
Usage: python Scripts/oracle/probe_s1cc_aperture_grading.py
"""

import numpy as np

sx = np.array([[0, 1], [1, 0]], dtype=complex)
sy = np.array([[0, -1j], [1j, 0]], dtype=complex)
sz = np.array([[1, 0], [0, -1]], dtype=complex)
I2 = np.eye(2, dtype=complex)
I3 = np.eye(3, dtype=complex)

J = np.kron(sx, I3)          # Krein fundamental symmetry (witness convention)
b = np.kron(sz, I3)          # closure bivector grading (anticonjugation)

# Curvature / transport color data (from probe_s1cc_balanced_inertia.py)
K = np.zeros((3, 3), dtype=complex)
K[0, 1] = 1.0
K[1, 0] = -1.0               # skew-Hermitian curvature

# A positive-definite color "aperture" A and "turn" T (any Hermitian PD works;
# the grading action does not depend on the color content).
rng = np.random.default_rng(0)
Araw = rng.standard_normal((3, 3)) + 1j * rng.standard_normal((3, 3))
A = Araw.conj().T @ Araw + 3 * I3          # Hermitian PD (aperture ~ metric*transport)
Traw = rng.standard_normal((3, 3)) + 1j * rng.standard_normal((3, 3))
T = Traw.conj().T @ Traw + 3 * I3          # Hermitian PD (turn phi^2)

# The four blocks in the sigma (x) color structure.
QC = np.kron(sz, K)          # closure: bivector [gamma,gamma] ~ sigma_z on Clifford
QA = np.kron(I2, A)          # aperture: {gamma,gamma}=scalar => I on Clifford
QT = np.kron(I2, T)          # turn: phi^2, Gamma-even => I on Clifford
# For contrast, a HYPOTHETICAL sigma_z-odd aperture (what WOULD survive):
QA_odd = np.kron(sx, A)      # sigma_x on Clifford (would be b-fixed under J)


def grading_action(M, name):
    """Report whether b^{-1} (J M) b equals +(J M) [FIXED] or -(J M) [NEGATED]."""
    JM = J @ M
    conj = np.linalg.inv(b) @ JM @ b
    herm = np.allclose(JM.conj().T, JM)
    if np.allclose(conj, -JM):
        verdict = "NEGATED  (b balances this block => contributes indefinite)"
    elif np.allclose(conj, JM):
        verdict = "FIXED    (b preserves this block => can carry positivity)"
    else:
        verdict = "MIXED    (neither pure eigenblock)"
    print(f"  J {name:8s} Hermitian={herm!s:5s}  b^-1(J {name}) b = {verdict}")
    return verdict


print("=== S1-CC witness conventions ===")
print(f"  J b = - b J (sigma_x anticommutes sigma_z) ? {np.allclose(J @ b, -b @ J)}")
print()
print("=== grading action b^-1 (J Q_X) b  on each block ===")
vC = grading_action(QC, "Q_C")
vA = grading_action(QA, "Q_A")
vT = grading_action(QT, "Q_T")
print()
print("  (contrast) a hypothetical sigma_z-ODD aperture, to show what b FIXES:")
vAodd = grading_action(QA_odd, "Q_A_odd")

print()
print("=== VERDICT ===")
escape_holds = ("FIXED" in vA and "FIXED" in vT and "NEGATED" in vC)
if escape_holds:
    print("  ESCAPE HOLDS on the witness: b negates only closure; Q_A, Q_T fixed.")
else:
    print("  ESCAPE FAILS on the witness: b negates J Q_C AND J Q_A / J Q_T.")
    print("  => The closure-only witness (J = sigma_x (x) I, Q_A = I (x) A) CANNOT")
    print("     exhibit the J-definite-complement escape. A rescuing carrier must")
    print("     supply a sigma_z-ODD aperture (genuine Clifford content from an")
    print("     indefinite metric g) or a different J. This confirms Fable")
    print("     call-04's adversarial finding at the witness level and pins the")
    print("     exact structural requirement for a real positive-sector model.")

# Also: total operator J(Q_A+Q_C+4Q_T) grading, the existential question.
total = J @ (QA + QC + 4 * QT)
conj_total = np.linalg.inv(b) @ total @ b
print()
print("=== the existential question: is J(Q_A+Q_C+4Q_T) balanced by b? ===")
print(f"  b^-1 [J(Q_A+Q_C+4Q_T)] b = -(same) ? "
      f"{np.allclose(conj_total, -total)}")
print("  (True => the WHOLE Krein form is congruent to its negative => balanced")
print("   on every b-invariant sector => min spec < 0 => ground-state program")
print("   collapses on this witness structure.)")

# --- Concrete physical-sector check: inertia of the TOTAL on V'/N ---
# Use Gauss-COMMUTING aperture/turn (physical: [G, A] = [G, T] = 0) so the
# blocks respect the constraint, then compute the total's inertia on the exact
# V'/N complement used by probe_s1cc_balanced_inertia.py.
G = np.diag([0.0, 0.0, 1.0]).astype(complex)
E01_2 = np.array([[0, 1], [0, 0]], dtype=complex)
QG = np.sqrt(2.0) * np.kron(E01_2, G)         # nilpotent Gauss charge
# G-commuting PD color blocks (block-diagonal in ker G = span(e0,e1) vs e2):
Acomm = np.diag([2.0, 3.0, 5.0]).astype(complex)
Tcomm = np.diag([1.5, 2.5, 4.0]).astype(complex)
QA_c = np.kron(I2, Acomm)
QT_c = np.kron(I2, Tcomm)
total_c = J @ (QA_c + QC + 4 * QT_c)


def inertia(H, tol=1e-9):
    ev = np.linalg.eigvalsh((H + H.conj().T) / 2.0)
    return (int(np.sum(ev > tol)), int(np.sum(ev < -tol)),
            int(np.sum(np.abs(ev) <= tol)))


def kernel_basis(M, tol=1e-9):
    u, s, vh = np.linalg.svd(M)
    return vh.conj().T[:, [i for i in range(vh.shape[0])
                           if i >= len(s) or s[i] <= tol]]


Vp = kernel_basis(QG)                          # V' = ker Q_G
JVp = Vp.conj().T @ J @ Vp
evJ, UJ = np.linalg.eigh((JVp + JVp.conj().T) / 2.0)
keep = [i for i in range(len(evJ)) if abs(evJ[i]) > 1e-9]
Wp = Vp @ UJ[:, keep]                           # V'/N complement (J-nondegenerate)
total_sector = Wp.conj().T @ total_c @ Wp
sig_tot = inertia(total_sector)
print()
print("=== TOTAL operator inertia on the physical sector V'/N "
      "(Gauss-commuting Q_A,Q_T) ===")
print(f"  sig(J(Q_A+Q_C+4Q_T) |_{{V'/N}}) = {sig_tot}")
print(f"  balanced on the physical sector (p == q)? {sig_tot[0] == sig_tot[1]}")
print("  => Even the FULL operator (kinetic + closure + turn) is balanced on")
print("     the Gauss sector: no positive ground state exists here. The")
print("     aperture does NOT rescue positivity on this witness.")
