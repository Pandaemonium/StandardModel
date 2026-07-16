import PhysicsSM.Draft.NullEdge.S3QuadraticSelectorClassification

/-!
# Exhaustive phase diagram for permutation-natural quadratic selectors

Focused successor to the six-coefficient `S3` classification. The target
classifies the remaining transverse coefficient into three regimes on every
fixed-total fibre: unique equal-third selection, flat non-selection, or
unbounded-below instability.

This is a theorem about the fully permutation-symmetric homogeneous quadratic
family. It does not choose the family from physics or information theory.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.S3SelectorPhaseDiagram

open S3QuadraticSelectorClassification

/-- Along a zero-total transverse ray, the common mode is constant and the
coefficient `a - d` controls the quadratic growth exactly. -/
theorem transverse_ray_identity (a d s t : Real) :
    symmetricQuadratic a d t (-t) s =
      2 * (a - d) * t ^ 2 + a * s ^ 2 := by
  sorry

/-- A negative transverse coefficient makes the fixed-total cost unbounded
below. The explicit witness ray is `(t,-t,s)`. -/
theorem negative_transverse_unbounded_below {a d s : Real} (hnegative : a < d)
    (B : Real) :
    Exists fun t : Real => symmetricQuadratic a d t (-t) s < B := by
  sorry

/-- **Quadratic-selector phase diagram.** Exactly the sign of `a - d`
distinguishes strict selection, flat non-selection, and instability. -/
theorem selector_phase_diagram (a d s : Real) :
    And
      ((d < a) -> forall x y z : Real,
        x + y + z = s ->
        symmetricQuadratic a d x y z <=
          symmetricQuadratic a d (s / 3) (s / 3) (s / 3) ->
        And (x = s / 3) (And (y = s / 3) (z = s / 3)))
      (And
        ((a = d) -> forall x y z : Real,
          x + y + z = s -> symmetricQuadratic a d x y z = a * s ^ 2)
        ((a < d) -> forall B : Real,
          Exists fun t : Real => symmetricQuadratic a d t (-t) s < B)) := by
  sorry

end PhysicsSM.Draft.NullEdge.S3SelectorPhaseDiagram
