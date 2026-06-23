import Mathlib

/-!
# P1 SL(2,C) determinant frame audit

This draft module integrates Aristotle project
`c91d864e-60d7-44dc-bbf7-1bfa97e5ac4a`.

The theorem is a minimal frame-audit lemma for the origin-of-mass paper: the
determinant of a two-spinor Hermitian momentum block is invariant under
`SL(2,C)` congruence. The normalized celestial density is observer-relative,
but the unnormalized determinant mass is invariant.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP1SL2Frame

open Matrix

/--
`SL(2,C)` congruence preserves the determinant of a two-spinor momentum matrix.
This is the finite algebra behind the distinction between invariant Plucker
mass and observer-conditioned celestial mixedness.
-/
theorem sl2_congruence_det_invariant
    (A P : Matrix (Fin 2) (Fin 2) Complex) (hA : A.det = 1) :
    (A * P * A.conjTranspose).det = P.det := by
  rw [Matrix.det_mul, Matrix.det_mul, Matrix.det_conjTranspose, hA]
  simp

end PhysicsSM.Draft.NullEdgeP1SL2Frame
