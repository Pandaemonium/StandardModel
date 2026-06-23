import Mathlib

noncomputable section

namespace NullEdgeP1SL2Frame

open Matrix

/--
SL(2,C) congruence preserves the determinant of a two-spinor Hermitian momentum
matrix. This is the frame-audit theorem behind the distinction between
invariant Pluecker mass and frame-dependent normalized celestial mixedness.
-/
theorem sl2_congruence_det_invariant
    (A P : Matrix (Fin 2) (Fin 2) Complex) (hA : A.det = 1) :
    (A * P * A.conjTranspose).det = P.det := by
  sorry

end NullEdgeP1SL2Frame
