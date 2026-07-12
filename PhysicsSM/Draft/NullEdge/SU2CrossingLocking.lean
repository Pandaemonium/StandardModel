import PhysicsSM.Draft.NullEdge.ReciprocalConditionalShiftRegulator

/-!
# Exact SU(2) crossing locking

For a unitary `2 x 2` matrix of determinant one, a zero of `det(U-I)` forces
`U=I`, while a zero of `det(U+I)` forces `U=-I`.  The determinant-minus-one
controls demonstrate that unimodularity is load-bearing.

This is a finite matrix theorem.  It does not assert transversality, a Chern
charge, or global chirality for a walk.

Proof provenance: the two load-bearing matrix lemmas were proved by Aristotle
project `9060adfd-4338-4717-bd85-02780e93b741` in a focused Mathlib-only
package after the original full-project job stalled.  The extracted proof was
independently checked before integration on 2026-07-11.  The pointwise
corollaries and exact negative controls were composed locally.
-/

namespace PhysicsSM.Draft.NullEdge.SU2CrossingLocking

open Matrix Complex
open ReciprocalConditionalShiftRegulator

noncomputable section

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

/-- Structure of a determinant-one unitary `2 x 2` matrix: the lower row is
determined by the upper row and the upper entries have unit combined norm. -/
private lemma su2_relations (U : M2) (hU : IsUnitary2 U) (hdet : U.det = 1) :
    U 1 1 = star (U 0 0) ∧ U 1 0 = -star (U 0 1) ∧
      Complex.normSq (U 0 0) + Complex.normSq (U 0 1) = 1 := by
  unfold IsUnitary2 at hU
  simp_all +decide [← Matrix.ext_iff, Fin.forall_fin_two, Complex.ext_iff,
    Matrix.mul_apply]
  simp_all +decide [Complex.normSq, Matrix.det_fin_two]
  grind +splitIndPred

/-- In a determinant-one unitary two-band sector, a `+1` eigenvalue locks the
whole matrix to `+I`. -/
theorem det_sub_one_eq_zero_iff_eq_one (U : M2)
    (hU : IsUnitary2 U) (hdet : U.det = 1) :
    (U - 1).det = 0 ↔ U = 1 := by
  constructor <;> intro h
  · have := su2_relations U hU hdet
    simp_all +decide [Complex.ext_iff, Matrix.det_fin_two]
    ext i j
    fin_cases i <;> fin_cases j <;> simp_all +decide [Complex.ext_iff]
    · constructor <;> nlinarith only [h]
    · constructor <;> nlinarith only [h]
    · constructor <;> nlinarith only [h]
    · constructor <;> nlinarith only [h]
  · simp +decide [h]
    norm_num [Matrix.det_succ_row_zero]

/-- In a determinant-one unitary two-band sector, a `-1` eigenvalue locks the
whole matrix to `-I`. -/
theorem det_add_one_eq_zero_iff_eq_neg_one (U : M2)
    (hU : IsUnitary2 U) (hdet : U.det = 1) :
    (U + 1).det = 0 ↔ U = -(1 : M2) := by
  constructor <;> intro h
  · obtain ⟨h1, h2, h3⟩ := su2_relations U hU hdet
    simp_all +decide [Complex.ext_iff, Matrix.det_fin_two]
    ext i j
    fin_cases i <;> fin_cases j <;> norm_num <;>
      simp_all +decide [Complex.ext_iff]
    · constructor <;> nlinarith only [h, hdet]
    · constructor <;> nlinarith only [h, hdet]
    · constructor <;> nlinarith only [h, hdet]
    · constructor <;> nlinarith only [h, hdet]
  · norm_num [h]
    norm_num [Matrix.det_succ_row_zero]

/-- Pointwise form for a determinant-one unitary Bloch family. -/
theorem plus_crossing_set_eq_identity_preimage
    {K : Type} (U : K -> M2)
    (hU : ∀ k, IsUnitary2 (U k)) (hdet : ∀ k, (U k).det = 1) :
    {k | (U k - 1).det = 0} = {k | U k = 1} := by
  ext k
  exact det_sub_one_eq_zero_iff_eq_one (U k) (hU k) (hdet k)

/-- Pointwise pi-quasienergy form for a determinant-one unitary Bloch family. -/
theorem minus_crossing_set_eq_neg_identity_preimage
    {K : Type} (U : K -> M2)
    (hU : ∀ k, IsUnitary2 (U k)) (hdet : ∀ k, (U k).det = 1) :
    {k | (U k + 1).det = 0} = {k | U k = -(1 : M2)} := by
  ext k
  exact det_add_one_eq_zero_iff_eq_neg_one (U k) (hU k) (hdet k)

def detNegOneControl : M2 := !![1, 0; 0, -1]

/-- Without determinant one, a unitary can have a `+1` eigenvalue without
being the identity. -/
theorem detNegOneControl_plus_crossing :
    IsUnitary2 detNegOneControl ∧ detNegOneControl.det = -1 ∧
      (detNegOneControl - 1).det = 0 ∧ detNegOneControl ≠ 1 := by
  constructor
  · constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;>
      norm_num [detNegOneControl, Matrix.mul_apply, Complex.ext_iff]
  · constructor
    · norm_num [detNegOneControl, Matrix.det_fin_two]
    · constructor
      · norm_num [detNegOneControl, Matrix.det_fin_two]
      · intro h
        have h11 := congrArg (fun A : M2 => A 1 1) h
        norm_num [detNegOneControl] at h11

/-- The sign-reversed control similarly has a `-1` eigenvalue without being
`-I`. -/
theorem neg_detNegOneControl_minus_crossing :
    IsUnitary2 (-detNegOneControl) ∧ (-detNegOneControl).det = -1 ∧
      (-detNegOneControl + 1).det = 0 ∧
      -detNegOneControl ≠ -(1 : M2) := by
  constructor
  · constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;>
      norm_num [detNegOneControl, Matrix.mul_apply, Complex.ext_iff]
  · constructor
    · norm_num [detNegOneControl, Matrix.det_fin_two]
    · constructor
      · norm_num [detNegOneControl, Matrix.det_fin_two]
      · intro h
        have h11 := congrArg (fun A : M2 => A 1 1) h
        norm_num [detNegOneControl] at h11

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.SU2CrossingLocking.det_sub_one_eq_zero_iff_eq_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_sub_one_eq_zero_iff_eq_one

/-- info: 'PhysicsSM.Draft.NullEdge.SU2CrossingLocking.det_add_one_eq_zero_iff_eq_neg_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_add_one_eq_zero_iff_eq_neg_one

/-- info: 'PhysicsSM.Draft.NullEdge.SU2CrossingLocking.detNegOneControl_plus_crossing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms detNegOneControl_plus_crossing

end

end PhysicsSM.Draft.NullEdge.SU2CrossingLocking
