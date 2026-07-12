import PhysicsSM.Draft.NullEdge.ReciprocalConditionalShiftRegulator

/-!
# Aristotle target: exact SU(2) crossing locking

Prove the exact two-band algebra behind isolated determinant-one crossings.
For a unitary `2 x 2` matrix of determinant one, a zero of `det(U-I)` forces
`U=I`, while a zero of `det(U+I)` forces `U=-I`.  The determinant-minus-one
controls demonstrate that unimodularity is load-bearing.

This is a finite matrix theorem.  It does not assert transversality, a Chern
charge, or global chirality for a walk.
-/

namespace PhysicsSM.Draft.NullEdge.SU2CrossingLocking

open Matrix Complex
open ReciprocalConditionalShiftRegulator

noncomputable section

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

/-- In a determinant-one unitary two-band sector, a `+1` eigenvalue locks the
whole matrix to `+I`. -/
theorem det_sub_one_eq_zero_iff_eq_one (U : M2)
    (hU : IsUnitary2 U) (hdet : U.det = 1) :
    (U - 1).det = 0 ↔ U = 1 := by
  sorry

/-- In a determinant-one unitary two-band sector, a `-1` eigenvalue locks the
whole matrix to `-I`. -/
theorem det_add_one_eq_zero_iff_eq_neg_one (U : M2)
    (hU : IsUnitary2 U) (hdet : U.det = 1) :
    (U + 1).det = 0 ↔ U = -(1 : M2) := by
  sorry

/-- Pointwise form for a determinant-one unitary Bloch family. -/
theorem plus_crossing_set_eq_identity_preimage
    {K : Type} (U : K -> M2)
    (hU : ∀ k, IsUnitary2 (U k)) (hdet : ∀ k, (U k).det = 1) :
    {k | (U k - 1).det = 0} = {k | U k = 1} := by
  sorry

/-- Pointwise pi-quasienergy form for a determinant-one unitary Bloch family. -/
theorem minus_crossing_set_eq_neg_identity_preimage
    {K : Type} (U : K -> M2)
    (hU : ∀ k, IsUnitary2 (U k)) (hdet : ∀ k, (U k).det = 1) :
    {k | (U k + 1).det = 0} = {k | U k = -(1 : M2)} := by
  sorry

def detNegOneControl : M2 := !![1, 0; 0, -1]

/-- Negative control: without determinant one, a unitary can have a `+1`
eigenvalue without being the identity. -/
theorem detNegOneControl_plus_crossing :
    IsUnitary2 detNegOneControl ∧ detNegOneControl.det = -1 ∧
      (detNegOneControl - 1).det = 0 ∧ detNegOneControl ≠ 1 := by
  sorry

/-- The sign-reversed control similarly has a `-1` eigenvalue without being
`-I`. -/
theorem neg_detNegOneControl_minus_crossing :
    IsUnitary2 (-detNegOneControl) ∧ (-detNegOneControl).det = -1 ∧
      (-detNegOneControl + 1).det = 0 ∧
      -detNegOneControl ≠ -(1 : M2) := by
  sorry

end

end PhysicsSM.Draft.NullEdge.SU2CrossingLocking
