import Mathlib

/-!
# Fixed-momentum determinant-phase realizability

This focused target upgrades the known `U(2)` factorization-fiber theorem to
an image-and-fiber classification for the joint map

`M |-> (M M^H, det M)`.

The intended result says that, relative to an invertible base factor `M0`, a
complex determinant value `z` is realizable at fixed momentum exactly when
`normSq z = normSq (det M0)`.  Thus momentum fixes the magnitude of the complex
Pluecker datum but not its phase; after both momentum and phase are fixed, the
remaining factorization fiber is `SU(2)`.

Conventions: matrices act on columns from the left, `M^H` is conjugate
transpose, and factor changes act from the right.
-/

open scoped Matrix ComplexOrder

noncomputable section

namespace FactorizationRealizability

abbrev Mat2 := Matrix (Fin 2) (Fin 2) Complex

def SameMomentumGram (M0 M : Mat2) : Prop :=
  M * Mᴴ = M0 * M0ᴴ

theorem unitary_right_action_preserves
    (M0 U : Mat2) (hU : U ∈ Matrix.unitaryGroup (Fin 2) Complex) :
    SameMomentumGram M0 (M0 * U) := by
  simp_all +decide [SameMomentumGram, Matrix.mul_assoc]
  simp_all +decide [← Matrix.mul_assoc, Matrix.mem_unitaryGroup_iff]
  simp_all +decide [mul_assoc, star]

theorem factorization_fiber_unitary
    (M0 L0 M : Mat2)
    (hleft : L0 * M0 = 1) (hright : M0 * L0 = 1)
    (hgram : SameMomentumGram M0 M) :
    ∃! U : Mat2, U ∈ Matrix.unitaryGroup (Fin 2) Complex ∧ M = M0 * U := by
  refine' ⟨L0 * M, _, _⟩ <;> simp_all +decide
  · simp_all +decide [Matrix.mem_unitaryGroup_iff]
    simp_all +decide [← Matrix.mul_assoc, SameMomentumGram]
    simp_all +decide [mul_assoc, star]
    simp_all +decide [← Matrix.conjTranspose_mul]
  · simp_all +decide [← Matrix.mul_assoc]

theorem factorization_fiber_special_unitary
    (M0 L0 M : Mat2)
    (hleft : L0 * M0 = 1) (hright : M0 * L0 = 1)
    (hgram : SameMomentumGram M0 M) (hdet : M.det = M0.det) :
    ∃! U : Mat2,
      U ∈ Matrix.specialUnitaryGroup (Fin 2) Complex ∧ M = M0 * U := by
  sorry

/-- The determinant of a positive Gram factor is the squared magnitude of the
factor determinant. -/
theorem det_gram_eq_normSq (M : Mat2) :
    (M * Mᴴ).det = Complex.normSq M.det := by
  sorry

/-- Equal positive momentum Grams force equal determinant magnitudes. -/
theorem sameMomentum_forces_det_normSq
    (M0 M : Mat2) (hgram : SameMomentumGram M0 M) :
    Complex.normSq M.det = Complex.normSq M0.det := by
  sorry

/-- A diagonal unitary used to realize an arbitrary allowed determinant
phase. -/
def phaseUnitary (u : Complex) : Mat2 := !![u, 0; 0, 1]

theorem phaseUnitary_det (u : Complex) : (phaseUnitary u).det = u := by
  sorry

theorem phaseUnitary_mem_unitary (u : Complex)
    (hu : Complex.normSq u = 1) :
    phaseUnitary u ∈ Matrix.unitaryGroup (Fin 2) Complex := by
  sorry

theorem det_ne_zero_of_twoSidedInverse
    (M0 L0 : Mat2) (hleft : L0 * M0 = 1) : M0.det ≠ 0 := by
  sorry

/-- Every complex phase with the momentum-forced magnitude is realized by an
explicit right-unitary factor change. -/
theorem fixedMomentum_phase_realizable
    (M0 L0 : Mat2)
    (hleft : L0 * M0 = 1) (hright : M0 * L0 = 1)
    (z : Complex)
    (hz : Complex.normSq z = Complex.normSq M0.det) :
    ∃ M : Mat2, SameMomentumGram M0 M ∧ M.det = z := by
  sorry

/-- **Image classification.**  At fixed nondegenerate momentum, determinant
phase is free and determinant magnitude is fixed. -/
theorem fixedMomentum_phase_iff
    (M0 L0 : Mat2)
    (hleft : L0 * M0 = 1) (hright : M0 * L0 = 1)
    (z : Complex) :
    (∃ M : Mat2, SameMomentumGram M0 M ∧ M.det = z) ↔
      Complex.normSq z = Complex.normSq M0.det := by
  sorry

/-- **Fiber classification.**  Once momentum and determinant phase are both
fixed, all remaining factors form the unique right `SU(2)` orbit. -/
theorem fixedMomentum_fixedPhase_fiber
    (M0 L0 M : Mat2)
    (hleft : L0 * M0 = 1) (hright : M0 * L0 = 1)
    (hgram : SameMomentumGram M0 M) (hdet : M.det = M0.det) :
    ∃! U : Mat2,
      U ∈ Matrix.specialUnitaryGroup (Fin 2) Complex ∧ M = M0 * U := by
  sorry

/-! ## Nondegenerate phase-freedom witness -/

def witnessBase : Mat2 := !![2, 0; 0, 1]

def witnessQuarterTurn : Mat2 := !![Complex.I, 0; 0, 1]

def witnessRotated : Mat2 := witnessBase * witnessQuarterTurn

theorem witness_same_momentum_different_phase :
    SameMomentumGram witnessBase witnessRotated ∧
      witnessRotated.det = 2 * Complex.I ∧
      witnessBase.det = 2 ∧ witnessRotated.det ≠ witnessBase.det := by
  sorry

end FactorizationRealizability
