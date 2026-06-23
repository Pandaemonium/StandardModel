import Mathlib

/-!
# P4 visible determinant invariant

This package isolates the finite invariant bridge requested by the sharpened P4
conjecture: the dynamic mass should match an unnormalized visible determinant
`det P_vis`, while normalized mixedness is only a frame-relative readout.
-/

open Complex Matrix
open scoped Matrix

noncomputable section

namespace NullEdgeP4VisibleDetInvariant

abbrev CMat2 := Matrix (Fin 2) (Fin 2) Complex

def visibleBoost (A P : CMat2) : CMat2 :=
  A * P * A.conjTranspose

def traceNormalize (P : CMat2) : CMat2 :=
  (P.trace)⁻¹ • P

theorem visibleBoost_det_invariant
    (A P : CMat2) (hA : A.det = 1) :
    (visibleBoost A P).det = P.det := by
  sorry

theorem traceNormalize_det_eq_det_div_trace_sq
    (P : CMat2) :
    (traceNormalize P).det = (P.trace) ^ (-2 : Int) * P.det := by
  sorry

theorem traceNormalize_det_eq_det_inv_trace_sq
    (P : CMat2) :
    (traceNormalize P).det = (P.trace)⁻¹ ^ 2 * P.det := by
  sorry

end NullEdgeP4VisibleDetInvariant
