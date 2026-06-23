import Mathlib.Tactic

/-!
# P9 two-triangle defect sensitivity benchmark

This module integrates Aristotle project
`aca96818-d575-44e4-97cb-949aa461dfe6`.

Scientific role: this is the minimal two-triangle source-visibility benchmark
for the P9 program.  Common-mode curvature bookkeeping is invisible to the
linearized diamond-defect readout, while differential curvature is visible.
It is a finite kinematic test object, not a continuum gravity claim.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9DefectSensitivityBenchmark

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
  simp [defectReadout, addVec, commonMode]

/--
Differential curvature is visible: adding `(+eps, -eps)` shifts the defect
readout by `2 * eps`.
-/
theorem defectReadout_add_differentialMode
    (curv : Vec2) (eps : Real) :
    defectReadout (addVec curv (differentialMode eps)) =
      defectReadout curv + 2 * eps := by
  simp [defectReadout, addVec, differentialMode]
  ring

/-- The defect readout vanishes exactly when the two triangle curvatures agree. -/
theorem defectReadout_eq_zero_iff_equal (curv : Vec2) :
    defectReadout curv = 0 <-> curv 0 = curv 1 := by
  simp [defectReadout, sub_eq_zero]

/-- The quadratic defect response is nonnegative. -/
theorem defectResponse_nonneg (curv : Vec2) :
    0 <= defectReadout curv * defectReadout curv := by
  exact mul_self_nonneg _

/--
If the original diamond has zero defect, a nonzero differential perturbation
creates a nonzero defect.
-/
theorem differentialMode_creates_defect_of_ne_zero
    (curv : Vec2) (eps : Real)
    (hzero : defectReadout curv = 0)
    (hne : eps != 0) :
    defectReadout (addVec curv (differentialMode eps)) != 0 := by
  simp only [bne_iff_ne] at hne
  rw [defectReadout_add_differentialMode, hzero, zero_add]
  simp only [bne_iff_ne]
  intro h
  rcases mul_eq_zero.mp h with htwo | heps
  case inl =>
    norm_num at htwo
  case inr =>
    exact hne heps

end PhysicsSM.Draft.NullEdgeP9DefectSensitivityBenchmark

end
