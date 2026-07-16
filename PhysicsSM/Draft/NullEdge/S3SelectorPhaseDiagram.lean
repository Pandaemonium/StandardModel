import PhysicsSM.Draft.NullEdge.S3QuadraticSelectorClassification

/-!
# Exhaustive phase diagram for permutation-natural quadratic selectors

Focused successor to the six-coefficient `S3` classification. The target
classifies the remaining transverse coefficient into three regimes on every
fixed-total fibre: unique equal-third selection, flat non-selection, or
unbounded-below instability.

This is a theorem about the fully permutation-symmetric homogeneous quadratic
family. It does not choose the family from physics or information theory.

Provenance: theorem statements and definitions were prepared locally; Aristotle
project `81bc8433-2f6a-4c6f-a39e-66588595d2a0` supplied the proofs, which were
replayed under the repository's pinned Lean toolchain before integration.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.S3SelectorPhaseDiagram

open S3QuadraticSelectorClassification

/-- Along a zero-total transverse ray, the common mode is constant and the
coefficient `a - d` controls the quadratic growth exactly. -/
theorem transverse_ray_identity (a d s t : Real) :
    symmetricQuadratic a d t (-t) s =
      2 * (a - d) * t ^ 2 + a * s ^ 2 := by
  rw [symmetricQuadratic, quadratic6]; ring

/-- A negative transverse coefficient makes the fixed-total cost unbounded
below. The explicit witness ray is `(t,-t,s)`. -/
theorem negative_transverse_unbounded_below {a d s : Real} (hnegative : a < d)
    (B : Real) :
    Exists fun t : Real => symmetricQuadratic a d t (-t) s < B := by
  have hc : 0 < d - a := by linarith
  set M := (a * s ^ 2 - B) / (2 * (d - a)) with hM
  refine ⟨|M| + 1, ?_⟩
  rw [transverse_ray_identity]
  have ht2 : (|M| + 1) ^ 2 > M := by
    nlinarith [abs_nonneg M, le_abs_self M, sq_nonneg (|M| + 1)]
  have hne : (2 * (d - a)) ≠ 0 := by positivity
  have hkey : 2 * (d - a) * M = a * s ^ 2 - B := by
    rw [hM]; field_simp
  nlinarith [mul_pos hc (by linarith : (|M| + 1) ^ 2 - M > 0), hkey]

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
  refine ⟨?_, ?_, ?_⟩
  · intro h x y z hsum hcost
    exact symmetricQuadratic_unique_equal_thirds h hsum hcost
  · intro h x y z hsum
    rw [fixed_total_cost_identity hsum, h]; ring
  · intro h B
    exact negative_transverse_unbounded_below h B

/-! ## Axiom-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.S3SelectorPhaseDiagram.transverse_ray_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms transverse_ray_identity

/-- info: 'PhysicsSM.Draft.NullEdge.S3SelectorPhaseDiagram.negative_transverse_unbounded_below' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms negative_transverse_unbounded_below

/-- info: 'PhysicsSM.Draft.NullEdge.S3SelectorPhaseDiagram.selector_phase_diagram' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms selector_phase_diagram

end PhysicsSM.Draft.NullEdge.S3SelectorPhaseDiagram
