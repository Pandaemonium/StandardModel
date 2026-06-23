import Mathlib.Tactic

/-!
# P9 two-triangle defect sensitivity benchmark

This focused file isolates a finite source-visibility benchmark for the P9
program.  A two-triangle diamond has two scalar curvature samples.  The
linearized diamond-defect readout is their difference.

The intended physical reading is deliberately modest: common-mode curvature
bookkeeping is invisible to the defect, while differential curvature is visible.
This is a finite test object for defect sensitivity, not a continuum gravity
claim.
-/

noncomputable section

namespace NullEdgeP9DefectSensitivityBenchmark

abbrev Vec2 := Fin 2 -> Real

/-- Add finite two-component curvature/source vectors. -/
def addVec (x y : Vec2) : Vec2 := fun i => x i + y i

/-- The linearized diamond-defect readout: first triangle minus second triangle. -/
def defectReadout (curv : Vec2) : Real := curv 0 - curv 1

/-- A common-mode perturbation changes both triangle curvatures equally. -/
def commonMode (c : Real) : Vec2 := fun _ => c

/-- A differential perturbation changes the two triangle curvatures oppositely. -/
def differentialMode (eps : Real) : Vec2 :=
  fun i => if i = 0 then eps else -eps

/-- Common-mode curvature bookkeeping is invisible to the defect readout. -/
theorem defectReadout_add_commonMode
    (curv : Vec2) (c : Real) :
    defectReadout (addVec curv (commonMode c)) = defectReadout curv := by
  sorry

/--
Differential curvature is visible: adding `(+eps, -eps)` shifts the defect
readout by `2 * eps`.
-/
theorem defectReadout_add_differentialMode
    (curv : Vec2) (eps : Real) :
    defectReadout (addVec curv (differentialMode eps)) =
      defectReadout curv + 2 * eps := by
  sorry

/-- The defect readout vanishes exactly when the two triangle curvatures agree. -/
theorem defectReadout_eq_zero_iff_equal (curv : Vec2) :
    defectReadout curv = 0 <-> curv 0 = curv 1 := by
  sorry

/-- The quadratic defect response is nonnegative. -/
theorem defectResponse_nonneg (curv : Vec2) :
    0 <= defectReadout curv * defectReadout curv := by
  sorry

/--
If the original diamond has zero defect, a nonzero differential perturbation
creates a nonzero defect.
-/
theorem differentialMode_creates_defect_of_ne_zero
    (curv : Vec2) (eps : Real)
    (hzero : defectReadout curv = 0)
    (hne : eps != 0) :
    defectReadout (addVec curv (differentialMode eps)) != 0 := by
  sorry

end NullEdgeP9DefectSensitivityBenchmark

end
