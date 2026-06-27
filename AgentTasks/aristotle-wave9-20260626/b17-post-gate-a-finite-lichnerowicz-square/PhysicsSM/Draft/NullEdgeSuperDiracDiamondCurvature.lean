import Mathlib.Tactic

/-!
# Draft.NullEdgeSuperDiracDiamondCurvature

This module isolates the finite additive/multiplicative identity that the
super-Dirac square must match on one scalar causal diamond.

The covariant differential square `d_U^2` sees an additive path-comparison
defect, while the causal-diamond gauge layer uses a multiplicative holonomy
defect. On one scalar diamond these are related by the exact finite identity
`left - right = (left / right - 1) * right` when the reference path is
invertible.

This is finite algebra only: no logarithms, no small-curvature approximation,
and no continuum Stokes theorem.
-/

namespace PhysicsSM.Draft.NullEdgeSuperDiracDiamondCurvature

/-- Additive triangle curvature relative to a direct comparison edge. -/
def triangleCurvature (pathTransport directTransport : Real) : Real :=
  pathTransport - directTransport

/-- Additive diamond defect between two competing causal paths. -/
def additiveDiamondDefect (leftPath rightPath : Real) : Real :=
  leftPath - rightPath

/-- Multiplicative scalar diamond holonomy defect. -/
noncomputable def multiplicativeDiamondDefect (leftPath rightPath : Real) : Real :=
  leftPath / rightPath

/--
The additive diamond defect is the difference of the two triangle curvatures
relative to any shared direct comparison edge.
-/
theorem additiveDiamondDefect_eq_triangleCurvature_sub
    (leftPath rightPath directTransport : Real) :
    additiveDiamondDefect leftPath rightPath
      = triangleCurvature leftPath directTransport
        - triangleCurvature rightPath directTransport := by
  unfold additiveDiamondDefect triangleCurvature
  ring

/--
For an invertible right-path transport, the multiplicative holonomy defect
contains exactly the same finite additive defect after multiplying by the
reference transport.
-/
theorem additiveDiamondDefect_eq_multiplicative_minus_one_mul
    (leftPath rightPath : Real) (hright : Not (rightPath = 0)) :
    additiveDiamondDefect leftPath rightPath
      = (multiplicativeDiamondDefect leftPath rightPath - 1) * rightPath := by
  unfold additiveDiamondDefect multiplicativeDiamondDefect
  field_simp

/--
Equivalently, the multiplicative defect is trivial iff the additive defect is
zero, assuming the comparison path is invertible.
-/
theorem multiplicative_trivial_iff_additive_zero
    (leftPath rightPath : Real) (hright : Not (rightPath = 0)) :
    (multiplicativeDiamondDefect leftPath rightPath = 1)
      <-> (additiveDiamondDefect leftPath rightPath = 0) := by
  unfold multiplicativeDiamondDefect additiveDiamondDefect
  rw [div_eq_one_iff_eq hright, sub_eq_zero]

end PhysicsSM.Draft.NullEdgeSuperDiracDiamondCurvature
