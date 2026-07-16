import PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit

/-!
# Harvested target: joint trigonometric holonomy curvature limit

The original Aristotle handoff has been proved and integrated into
`TrigonometricHolonomyCurvatureLimit`.  This target now checks the exact live
statement while the independent returned proof and semantic report remain in
the recorded Aristotle output directory.
-/

open Filter Matrix Topology
open scoped Topology

noncomputable section

namespace PhysicsSM.Draft.NullEdge.TrigonometricJointCurvatureHarvest

open PhysicsSM.Draft.NullEdge.CommutatorMixedDerivative
open PhysicsSM.Draft.NullEdge.TrigonometricHolonomyCurvatureLimit

/-- The harvested target is exactly the integrated unrestricted joint limit. -/
example (A G : TrigonometricHolonomyCurvatureLimit.M4)
    (hA : A * A = 1) (hG : G * G = 1) :
    Tendsto
      (fun z : Real × Real =>
        (z.1 * z.2)⁻¹ • (trigRegulator A G z - 1))
      (nhdsWithin (0, 0) nonzeroProductParameters)
      (nhds (lieCoefficient A G)) :=
  jointAreaNormalizedHolonomyLimit A G hA hG

end PhysicsSM.Draft.NullEdge.TrigonometricJointCurvatureHarvest
