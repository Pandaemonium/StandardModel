import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 800000

/-!
# Even mass gaps the chiral zero mode — an honest boundary (kill-test)

A finite, rational `2×2` graded model verifying the corrected `s8` claim:
the chiral-index "protected massless mode" is robust **only** to grading-preserving
(ODD) perturbations; an EVEN (grading-diagonal) mass term GAPS it.

* `Γ = diag(1,-1)` is the `ℤ/2` grading.
* `A = !![0,1;0,0]` is an ODD (anticommutes with `Γ`) Hermitian-square host with an
  explicit protected zero mode `v = ![1,0]`.
* `Podd s = !![0,s;0,0]` is an ODD perturbation — the zero mode persists.
* `Peven m = !![m,0;0,-m]` is an EVEN (axial/chiral mass) perturbation — for `m ≠ 0`
  the Hermitian square `Hₘ = (A+Peven m)ᴴ (A+Peven m)` has `det Hₘ = m⁴ ≠ 0`, so it
  has **no** zero eigenvalue: the mode is now MASSIVE.

Conclusion: the protection is chiral-symmetry-CONDITIONAL, not "immune to every
potential"; its honest scope is odd/grading-preserving perturbations only.
-/

namespace EvenMassGaps

open Matrix

/-- The `ℤ/2` grading operator `Γ = diag(1,-1)`. -/
abbrev Gamma : Matrix (Fin 2) (Fin 2) ℚ := !![1, 0; 0, -1]

/-- The ODD Hermitian-square host operator (maps `+` to `-`, rank 1). -/
abbrev A : Matrix (Fin 2) (Fin 2) ℚ := !![0, 1; 0, 0]

/-- The explicit protected chiral zero mode. -/
abbrev v : Fin 2 → ℚ := ![1, 0]

/-- An ODD (grading-reversing, off-diagonal) perturbation. -/
abbrev Podd (s : ℚ) : Matrix (Fin 2) (Fin 2) ℚ := !![0, s; 0, 0]

/-- An EVEN (grading-diagonal, axial/chiral mass) perturbation. -/
abbrev Peven (m : ℚ) : Matrix (Fin 2) (Fin 2) ℚ := !![m, 0; 0, -m]

/-- The Hermitian square of the even-mass–perturbed operator. -/
abbrev Hmass (m : ℚ) : Matrix (Fin 2) (Fin 2) ℚ :=
  (A + Peven m)ᴴ * (A + Peven m)

/-! ### Grading structure: `A`, `Podd` are ODD; `Peven` is EVEN. -/

/-- `A` is ODD: it anticommutes with the grading `Γ`. -/
theorem A_odd : Gamma * A + A * Gamma = 0 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp

/-- `Podd s` is ODD: it anticommutes with the grading `Γ`. -/
theorem Podd_odd (s : ℚ) : Gamma * Podd s + Podd s * Gamma = 0 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp

/-- `Peven m` is EVEN: it commutes with the grading `Γ`. -/
theorem Peven_even (m : ℚ) : Gamma * Peven m = Peven m * Gamma := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two]

/-! ### Target 1 — the protected chiral zero mode exists (exactly). -/

/-- The vector `v = ![1,0]` is annihilated by `A` (a true kernel vector). -/
theorem A_zero_mode : A.mulVec v = 0 := by
  funext i; fin_cases i <;> simp [Matrix.mulVec, dotProduct, Fin.sum_univ_two]

/-- **Target 1.** `v = ![1,0]` is an exact zero eigenvector of the Hermitian square
`Aᴴ A`: the protected massless mode with eigenvalue `0`. -/
theorem zero_mode_exists : (Aᴴ * A).mulVec v = 0 := by
  funext i; fin_cases i <;>
    simp [Matrix.mulVec, dotProduct, Matrix.mul_apply, Matrix.conjTranspose,
      Fin.sum_univ_two]

/-! ### Target 2 — ODD perturbations preserve the zero mode (the true narrow content). -/

/-- **Target 2.** Adding any ODD perturbation `Podd s` keeps `v` a zero mode: the
grading-preserving deformation cannot lift the eigenvalue off `0`. -/
theorem odd_preserves (s : ℚ) : (A + Podd s).mulVec v = 0 := by
  funext i; fin_cases i <;>
    simp [Matrix.mulVec, dotProduct, Fin.sum_univ_two, Matrix.add_apply]

/-- The zero mode also survives at the level of the Hermitian square under an ODD
perturbation. -/
theorem odd_preserves_sq (s : ℚ) :
    ((A + Podd s)ᴴ * (A + Podd s)).mulVec v = 0 := by
  have h : (A + Podd s).mulVec v = 0 := odd_preserves s
  rw [← Matrix.mulVec_mulVec, h, Matrix.mulVec_zero]

/-! ### Target 3 — an EVEN mass term GAPS the mode (the kill). -/

/-- The Hermitian square of the even-mass operator, explicitly. -/
theorem Hmass_eq (m : ℚ) : Hmass m = !![m^2, m; m, 1 + m^2] := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Hmass, Matrix.mul_apply, Matrix.conjTranspose, Fin.sum_univ_two] <;> ring

/-- The determinant of the even-mass Hermitian square is `m⁴`. -/
theorem Hmass_det (m : ℚ) : (Hmass m).det = m^4 := by
  rw [Hmass_eq, Matrix.det_fin_two_of]; ring

/-- **Target 3.** For any nonzero even mass `m`, the Hermitian square `Hₘ` has
`det Hₘ = m⁴ ≠ 0`: it is invertible, hence has **no** zero eigenvalue. The chiral
mode is gapped (massive). -/
theorem even_gaps {m : ℚ} (hm : m ≠ 0) : (Hmass m).det = m^4 ∧ (Hmass m).det ≠ 0 := by
  refine ⟨Hmass_det m, ?_⟩
  rw [Hmass_det]
  positivity

/-- The former zero mode is no longer a zero mode of `Hₘ` once `m ≠ 0`:
`Hₘ v ≠ 0`, and in fact the energy `vᵀ Hₘ v = m² > 0` is strictly positive. -/
theorem even_mode_massive {m : ℚ} (hm : m ≠ 0) :
    (Hmass m).mulVec v ≠ 0 ∧ dotProduct v ((Hmass m).mulVec v) = m^2 := by
  constructor
  · intro h
    have h0 := congrFun h 0
    rw [Hmass_eq] at h0
    simp [Matrix.mulVec, dotProduct, Fin.sum_univ_two] at h0
    exact hm h0
  · rw [Hmass_eq]
    simp [Matrix.mulVec, dotProduct, Fin.sum_univ_two]

/-! ### Target 4 — conditional-protection verdict (the packaged kill-test). -/

/-- **Target 4 (verdict).** The chiral zero mode `v`:

* exists exactly (`Aᴴ A · v = 0`),
* is **preserved** by *every* ODD (grading-preserving) perturbation `Podd s`
  (`(A + Podd s) · v = 0`),
* but is **gapped** by the explicit EVEN mass `m = 1`: the Hermitian square
  `H₁` has `det H₁ = 1 ≠ 0` and `H₁ v ≠ 0` with strictly positive energy
  `vᵀ H₁ v = 1 > 0`.

Hence the protection is chiral-symmetry-CONDITIONAL — its honest scope is
odd/grading-preserving perturbations only, NOT "immune to every potential". -/
theorem conditional_protection_verdict :
    (Aᴴ * A).mulVec v = 0 ∧
    (∀ s : ℚ, (A + Podd s).mulVec v = 0) ∧
    ((Hmass 1).det = 1 ∧ (Hmass 1).det ≠ 0 ∧
      (Hmass 1).mulVec v ≠ 0 ∧ (0 : ℚ) < dotProduct v ((Hmass 1).mulVec v)) := by
  refine ⟨zero_mode_exists, odd_preserves, ?_, ?_, ?_, ?_⟩
  · rw [Hmass_det]; norm_num
  · rw [Hmass_det]; norm_num
  · exact (even_mode_massive (m := 1) (by norm_num)).1
  · have h := (even_mode_massive (m := 1) (by norm_num)).2
    rw [h]; norm_num

/-! ### Axiom footprint: exactly `[propext, Classical.choice, Quot.sound]`. -/

/-- info: 'EvenMassGaps.zero_mode_exists' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zero_mode_exists

/-- info: 'EvenMassGaps.odd_preserves' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms odd_preserves

/-- info: 'EvenMassGaps.even_gaps' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms even_gaps

/-- info: 'EvenMassGaps.conditional_protection_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms conditional_protection_verdict

end EvenMassGaps
