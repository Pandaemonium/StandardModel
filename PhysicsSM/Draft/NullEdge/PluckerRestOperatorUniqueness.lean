import Mathlib

/-!
# Equivariant uniqueness of the normalized Pluecker rest operator

Formalization of the "Equivariant uniqueness of the normalized rest map" theorem from the
manuscript *A Plucker-Derived Mass Operator for Exactly Unitary Dirac Quantum Walks*
(Schwab, 2026), where it carried a paper proof but no Lean declaration (status `Proof`).
This module upgrades it to kernel-checked, licensing the words *natural* and *uniquely
selected* in the manuscript's exact covariance class and normalization.

## Statement

Fix the chiral grading `Gamma = diag(1,-1)` and the phase conjugator `W_u = diag(u,1)`.
The odd Hermitian rest operator is `B_z = [[0, z],[conj z, 0]]`. If a map
`F : C -> M_2(C)` is (i) odd Hermitian for `Gamma`, (ii) positively homogeneous with
`F 0 = 0`, (iii) equivariant under the phase conjugation `W_u`, and (iv) normalized by
`F 1 = sigma_x`, then `F z = B_z` for every `z`.

The proof uses only (ii)-(iv): writing `z = r u` with `r = |z| >= 0` and `|u| = 1`,
`F z = r * F u = r * (W_u * sigma_x * W_u^dagger) = r * B_u = B_z`. Hypothesis (i) is the
class-defining condition that `B_z` satisfies; it is included for faithfulness to the
manuscript theorem but is not needed for uniqueness.

Provenance: clean-room formalization of the manuscript's Theorem
(`thm:equivariantuniqueness`). Mathlib only. Claim grade `M`, `[comp]` (elementary linear
algebra), `[orig]` for the covariance-class packaging matching the manuscript.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.PluckerRestOperatorUniqueness

/-- The chiral grading `Gamma = diag(1, -1)`. -/
def chiralGrading : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- The odd Hermitian rest operator `B_z = [[0, z], [conj z, 0]]`. -/
def restOperator (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![0, z; (starRingEnd ℂ) z, 0]

/-- The phase conjugator `W_u = diag(u, 1)`. -/
def phaseConjugator (u : ℂ) : Matrix (Fin 2) (Fin 2) ℂ := !![u, 0; 0, 1]

/-- The normalization target `sigma_x = [[0,1],[1,0]]`. -/
def sigmaX : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- `W_u * sigma_x * W_u^dagger = B_u`: the phase conjugation of `sigma_x` is the rest
operator at the phase `u`. -/
theorem phaseConjugator_sigmaX (u : ℂ) :
    phaseConjugator u * sigmaX * (phaseConjugator u)ᴴ = restOperator u := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [phaseConjugator, sigmaX, restOperator, Matrix.mul_apply, Fin.sum_univ_two,
      Matrix.conjTranspose_apply]

/-- The rest operator is positively homogeneous: `r • B_u = B_{r u}` for real `r`
(using `conj (r u) = r conj u`). -/
theorem smul_restOperator (r : ℝ) (u : ℂ) :
    (r : ℂ) • restOperator u = restOperator ((r : ℂ) * u) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [restOperator, Matrix.smul_apply, map_mul, Complex.conj_ofReal, mul_comm]

/-- **Equivariant uniqueness of the normalized rest map** (manuscript
`thm:equivariantuniqueness`). A map `F : C -> M_2(C)` that is odd Hermitian for the chiral
grading, positively homogeneous, equivariant under the phase conjugation `W_u`, and
normalized by `F 1 = sigma_x`, is exactly the Pluecker rest operator `B_z`. -/
theorem equivariant_uniqueness_of_rest_map
    (F : ℂ → Matrix (Fin 2) (Fin 2) ℂ)
    (hclass : ∀ z, (F z).IsHermitian ∧
      chiralGrading * F z + F z * chiralGrading = 0)
    (hzero : F 0 = 0)
    (hhom : ∀ (r : ℝ) (z : ℂ), 0 ≤ r → F ((r : ℂ) * z) = (r : ℂ) • F z)
    (hequiv : ∀ (u z : ℂ), ‖u‖ = 1 → F (u * z) = phaseConjugator u * F z * (phaseConjugator u)ᴴ)
    (hnorm : F 1 = sigmaX) :
    ∀ z, F z = restOperator z := by
  intro z
  rcases eq_or_ne z 0 with h0 | h0
  · subst h0
    rw [hzero]
    ext i j; fin_cases i <;> fin_cases j <;> simp [restOperator]
  · have hrpos : 0 < ‖z‖ := norm_pos_iff.mpr h0
    have hrne : (‖z‖ : ℂ) ≠ 0 := by exact_mod_cast ne_of_gt hrpos
    have hru : (‖z‖ : ℂ) * (z / (‖z‖ : ℂ)) = z := by
      rw [mul_comm]; exact div_mul_cancel₀ z hrne
    have hunorm : ‖z / (‖z‖ : ℂ)‖ = 1 := by
      rw [norm_div, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hrpos]
      exact div_self (ne_of_gt hrpos)
    have hFu : F (z / (‖z‖ : ℂ)) = restOperator (z / (‖z‖ : ℂ)) := by
      have h := hequiv (z / (‖z‖ : ℂ)) 1 hunorm
      rw [mul_one, hnorm, phaseConjugator_sigmaX] at h
      exact h
    calc F z = F ((‖z‖ : ℂ) * (z / (‖z‖ : ℂ))) := by rw [hru]
      _ = (‖z‖ : ℂ) • F (z / (‖z‖ : ℂ)) := hhom ‖z‖ (z / (‖z‖ : ℂ)) (le_of_lt hrpos)
      _ = (‖z‖ : ℂ) • restOperator (z / (‖z‖ : ℂ)) := by rw [hFu]
      _ = restOperator ((‖z‖ : ℂ) * (z / (‖z‖ : ℂ))) := smul_restOperator ‖z‖ (z / (‖z‖ : ℂ))
      _ = restOperator z := by rw [hru]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PluckerRestOperatorUniqueness.phaseConjugator_sigmaX' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms phaseConjugator_sigmaX

/-- info: 'PhysicsSM.Draft.NullEdge.PluckerRestOperatorUniqueness.equivariant_uniqueness_of_rest_map' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms equivariant_uniqueness_of_rest_map

end PhysicsSM.Draft.NullEdge.PluckerRestOperatorUniqueness
