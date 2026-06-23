import Mathlib.Tactic

/-!
# P1 two-null split mass ratio and velocity identity

For an observer-axis two-null split with right/left null energies `a` and `b`,
the normalized mass ratio obeys the standard special-relativistic identity
`m^2 / E^2 = 1 - v^2`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP1TwoNullMassRatioVelocity

def splitEnergy (a b : Real) : Real :=
  a + b

def splitSpatial (a b : Real) : Real :=
  a - b

def splitMassSq (a b : Real) : Real :=
  4 * a * b

theorem split_massRatioSq_eq_one_sub_velocitySq
    (a b : Real) (hE : splitEnergy a b ≠ 0) :
    splitMassSq a b / splitEnergy a b ^ 2
      =
    1 - (splitSpatial a b / splitEnergy a b) ^ 2 := by
  unfold splitMassSq splitEnergy splitSpatial at *
  field_simp
  ring

end PhysicsSM.Draft.NullEdgeP1TwoNullMassRatioVelocity
