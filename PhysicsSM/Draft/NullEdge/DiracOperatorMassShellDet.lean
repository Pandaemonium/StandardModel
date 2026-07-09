import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

/-!
# The Dirac-operator determinant: `det(pslash - m·1) = (m² - p²)²` (the 4-spinor mass shell)

The program characterizes mass by a determinant in two complementary places. At the
little-group level, the 2×2 spinor matrix `P(p) = p·σ` has `det P = m²`
(`PauliMomentumPhysLean`, `SigmaMapNullEdges`). This module proves the 4-SPINOR
companion: the characteristic determinant of the full Dirac operator
`D = pslash - m·1`.

Because `pslash² = (E² - kz²)·1`, the operator `pslash` has characteristic
polynomial `(X² - (E²-kz²))²`, so the determinant is a PERFECT SQUARE and the
square root cancels — everything is rational, no `Real.sqrt`:

  `det(pslash - m·1) = (m² - E² + kz²)²`   (`= (m² - p²)²`, `p² = E² - kz²`).

On the mass shell (`E² - kz² = m²`) this is `0` — the Dirac operator is singular
EXACTLY on the shell; off shell it is a positive square and `D` is invertible.
This is the dispersion relation, and it realizes the program's determinant-level
mass-shell test `det D(q) = 0` (the object a genuine, non-doubled mode must satisfy;
see `docs/NULLSTRAND.md`).

Honest scope: the real `(t,z)`-restricted rational avatar of the Dirac dispersion
relation, as finite kernel-checked matrix algebra. The `[import]` physics is the
standard Dirac dispersion `det(pslash - m) ∝ (p² - m²)²`; it complements — but is a
SEPARATE object from — the 2×2 little-group `det P = m²` (`massless_det` records the
`m=0` value `(E²-kz²)² = (det P)²` as interpretation only, not a claim that the two
matrices coincide).

Provenance: PhysLean's Dirac-representation gamma convention (`spaceTime.gamma`),
used as a REFERENCE only, NOT imported. Draft status: kernel-checked with no proof
escape hatches; every headline carries an in-file `#print axioms` guard pinned to
exactly `[propext, Classical.choice, Quot.sound]`.
-/

namespace DiracOperatorMassShellDet

/-- Rational scalar field used throughout (real Dirac representation, so no `Complex`). -/
abbrev Q := ℚ

/-- The real Dirac-rep gamma matrix `γ⁰ = diag(1,1,-1,-1)` (rational 4×4). -/
def g0 : Matrix (Fin 4) (Fin 4) Q :=
  !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]

/-- The real Dirac-rep gamma matrix `γ³` (rational 4×4). -/
def g3 : Matrix (Fin 4) (Fin 4) Q :=
  !![0,0,1,0; 0,0,0,-1; -1,0,0,0; 0,1,0,0]

/-- The Feynman slash `pslash = E·γ⁰ - kz·γ³` in the (t,z) plane. -/
def pslash (E kz : Q) : Matrix (Fin 4) (Fin 4) Q :=
  E • g0 - kz • g3

/-- The Dirac operator `D = pslash - m·1`. -/
def D (E kz m : Q) : Matrix (Fin 4) (Fin 4) Q :=
  pslash E kz - m • (1 : Matrix (Fin 4) (Fin 4) Q)

/-- `pslash² = (E² - kz²)·1`: the on-shell relation at the operator level. -/
theorem pslash_sq (E kz : Q) :
    pslash E kz * pslash E kz = (E ^ 2 - kz ^ 2) • (1 : Matrix (Fin 4) (Fin 4) Q) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [pslash, g0, g3, Matrix.mul_apply, Fin.sum_univ_four] <;> ring

/-- The Dirac operator `D` written out as an explicit rational 4×4 matrix. -/
theorem D_eq (E kz m : Q) :
    D E kz m =
      !![E - m, 0, -kz, 0; 0, E - m, 0, kz; kz, 0, -E - m, 0; 0, -kz, 0, -E - m] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [D, pslash, g0, g3, Matrix.sub_apply, Matrix.smul_apply]

/-- PAYLOAD: the Dirac-operator determinant is a perfect square,
`det (pslash - m·1) = (m² - E² + kz²)²`. -/
theorem dirac_det (E kz m : Q) :
    (D E kz m).det = (m ^ 2 - E ^ 2 + kz ^ 2) ^ 2 := by
  rw [D_eq]
  simp [Matrix.det_succ_row_zero, Fin.sum_univ_succ, Matrix.submatrix_apply, Fin.succAbove]
  ring

/-- PAYLOAD: `D` is singular exactly on the mass shell. -/
theorem det_zero_iff_massshell (E kz m : Q) :
    (D E kz m).det = 0 ↔ E ^ 2 - kz ^ 2 = m ^ 2 := by
  rw [dirac_det, pow_eq_zero_iff (by norm_num)]
  constructor
  · intro h; linarith [h]
  · intro h; linarith [h]

/-- Off the mass shell the determinant is a positive square, so `D` is invertible. -/
theorem det_pos_iff_off_shell (E kz m : Q) :
    0 < (D E kz m).det ↔ E ^ 2 - kz ^ 2 ≠ m ^ 2 := by
  rw [dirac_det]
  constructor
  · intro h hcon
    have h0 : m ^ 2 - E ^ 2 + kz ^ 2 = 0 := by linarith [hcon]
    rw [h0] at h; norm_num at h
  · intro h
    have hne : m ^ 2 - E ^ 2 + kz ^ 2 ≠ 0 := by
      intro hc; apply h; linarith [hc]
    exact (sq_nonneg _).lt_of_ne (Ne.symm (pow_ne_zero 2 hne))

/-- At `m = 0` the determinant is the square of the little-group disagreement `E² - kz²`
(which is `det P` for the 2×2 little-group matrix `P = p·σ`). -/
theorem massless_det (E kz : Q) :
    (D E kz 0).det = (E ^ 2 - kz ^ 2) ^ 2 := by
  rw [dirac_det]; ring

/-- VERDICT: the 4-spinor Dirac-operator determinant face of mass. -/
theorem dirac_massshell_det_verdict (E kz m : Q) :
    (D E kz m).det = (m ^ 2 - E ^ 2 + kz ^ 2) ^ 2 ∧
    ((D E kz m).det = 0 ↔ E ^ 2 - kz ^ 2 = m ^ 2) ∧
    (0 < (D E kz m).det ↔ E ^ 2 - kz ^ 2 ≠ m ^ 2) :=
  ⟨dirac_det E kz m, det_zero_iff_massshell E kz m, det_pos_iff_off_shell E kz m⟩

/-! ### Non-degeneracy witnesses -/

/-- On-shell witness: `E=5, kz=3, m=4` gives `E²-kz²=16=m²` and `det = 0`. -/
theorem onshell_witness : (D 5 3 4).det = 0 := by
  rw [dirac_det]; norm_num

/-- Off-shell witness: `E=5, kz=3, m=3` gives `det = 49 ≠ 0`, so `D` invertible. -/
theorem offshell_witness : (D 5 3 3).det = 49 ∧ 0 < (D 5 3 3).det := by
  rw [dirac_det]; norm_num

/-- Massless witness: `E=5, kz=3, m=0` gives `det = 256`. -/
theorem massless_witness : (D 5 3 0).det = 256 := by
  rw [dirac_det]; norm_num

/-! ### Axiom audit: every headline uses only `[propext, Classical.choice, Quot.sound]` -/

/-- info: 'DiracOperatorMassShellDet.pslash_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms pslash_sq

/-- info: 'DiracOperatorMassShellDet.dirac_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms dirac_det

/-- info: 'DiracOperatorMassShellDet.det_zero_iff_massshell' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms det_zero_iff_massshell

/-- info: 'DiracOperatorMassShellDet.det_pos_iff_off_shell' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms det_pos_iff_off_shell

/-- info: 'DiracOperatorMassShellDet.massless_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms massless_det

/-- info: 'DiracOperatorMassShellDet.dirac_massshell_det_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms dirac_massshell_det_verdict

/-- info: 'DiracOperatorMassShellDet.onshell_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms onshell_witness

/-- info: 'DiracOperatorMassShellDet.offshell_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms offshell_witness

/-- info: 'DiracOperatorMassShellDet.massless_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms massless_witness

end DiracOperatorMassShellDet
