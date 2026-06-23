import Mathlib

/-!
# NullEdgeDiamondTwoTriangleCurvature.Core

Focused Aristotle target for relating a minimal causal-diamond defect to two
triangle curvature defects in the scalar Abelian transport setting.

The future non-Abelian version should use group-valued holonomy. This file
proves the additive/linearized algebraic seed first.
-/

noncomputable section

namespace NullEdgeDiamondTwoTriangleCurvature

open Complex

variable {V : Type}

/-- Scalar triangle transport defect. -/
def triangleCurvature (U : V -> V -> Complex) (i j k : V) : Complex :=
  U i j * U j k - U i k

/-- Additive/linearized diamond defect between two two-step paths. -/
def additiveDiamondDefect (U : V -> V -> Complex) (p a b q : V) : Complex :=
  U p a * U a q - U p b * U b q

/-- Difference of the two triangle curvatures using the same comparison edge. -/
def twoTriangleCurvatureDifference
    (U : V -> V -> Complex) (p a b q : V) : Complex :=
  triangleCurvature U p a q - triangleCurvature U p b q

/-- The additive diamond defect is the difference of the two triangle
curvatures. -/
theorem diamondDefect_eq_triangleCurvature_difference
    (U : V -> V -> Complex) (p a b q : V) :
    additiveDiamondDefect U p a b q =
      twoTriangleCurvatureDifference U p a b q := by
  sorry

/-- Equivalent orientation: the linearized holonomy around the diamond is the
first triangle curvature minus the second. -/
theorem diamondHolonomy_linearized_eq_triangleCurvature_difference
    (U : V -> V -> Complex) (p a b q : V) :
    U p a * U a q - U p b * U b q =
      triangleCurvature U p a q - triangleCurvature U p b q := by
  sorry

/-- If both triangles are flat against the same comparison edge, the additive
diamond defect vanishes. -/
theorem additiveDiamondDefect_eq_zero_of_flat_triangles
    (U : V -> V -> Complex) (p a b q : V)
    (ha : triangleCurvature U p a q = 0)
    (hb : triangleCurvature U p b q = 0) :
    additiveDiamondDefect U p a b q = 0 := by
  sorry

end NullEdgeDiamondTwoTriangleCurvature

end
