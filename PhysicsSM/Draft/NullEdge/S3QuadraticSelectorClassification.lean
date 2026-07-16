import PhysicsSM.Draft.NullEdge.ChannelQuadraticSelectorFamily

/-!
# Classification of permutation-natural quadratic channel selectors

Focused Aristotle target for the four-channel decomposition program.  The
landed selector theorem treats diagonal positive metrics.  This successor
classifies the complete six-parameter homogeneous quadratic family under the
two adjacent channel swaps and then proves the exact selector on a fixed-total
fibre for every fully symmetric quadratic form.

The theorem distinguishes two questions: permutation naturality reduces the
six coefficients to a diagonal coefficient and a common cross coefficient;
strict convexity transverse to the fixed-total direction then selects equal
thirds.  It does not claim that physics or information theory chooses either
remaining coefficient.

Provenance: target statements were prepared in the Autonomous Fundamental
Physics Lab and proved by Aristotle project
`909624b6-0c1f-4a26-b2e2-d9d7492a9e02`. The returned source was replayed
locally under Lean 4.28 before cross-family semantic review.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.S3QuadraticSelectorClassification

open ChannelQuadraticSelectorFamily

/-- General homogeneous real quadratic form in three labelled channels.  The
cross coefficients use the conventional factor of two. -/
def quadratic6 (a b c d e f x y z : Real) : Real :=
  a * x ^ 2 + b * y ^ 2 + c * z ^ 2 +
    2 * d * x * y + 2 * e * x * z + 2 * f * y * z

/-- Full adjacent-swap invariance classifies the six coefficients exactly:
all diagonal coefficients agree and all cross coefficients agree. -/
theorem full_s3_invariance_iff (a b c d e f : Real) :
    And
      (forall x y z,
        quadratic6 a b c d e f x y z = quadratic6 a b c d e f y x z)
      (forall x y z,
        quadratic6 a b c d e f x y z = quadratic6 a b c d e f x z y) <->
      And (a = b) (And (b = c) (And (d = e) (e = f))) := by
  constructor;
  · unfold quadratic6;
    rintro ⟨ h₁, h₂ ⟩;
    refine' ⟨ _, _, _, _ ⟩ <;> linarith [ h₁ 1 0 0, h₁ 0 1 0, h₁ 0 0 1, h₁ 1 1 0, h₁ 1 0 1, h₁ 0 1 1, h₂ 1 0 0, h₂ 0 1 0, h₂ 0 0 1, h₂ 1 1 0, h₂ 1 0 1, h₂ 0 1 1 ];
  · grind +locals

/-- The two-parameter fully permutation-symmetric quadratic family. -/
def symmetricQuadratic (a d x y z : Real) : Real :=
  quadratic6 a a a d d d x y z

/-- On a fixed-total fibre, the common-mode coefficient contributes only the
constant `d * s^2`; all selector information is carried by `a - d`. -/
theorem fixed_total_cost_identity {a d s x y z : Real}
    (hsum : x + y + z = s) :
    symmetricQuadratic a d x y z =
      (a - d) * (x ^ 2 + y ^ 2 + z ^ 2) + d * s ^ 2 := by
  grind +locals

/-- **Natural-selector capstone.** Every permutation-invariant quadratic form
that is strictly convex transverse to the fixed-total direction has equal
thirds as its unique minimizer on that fibre. -/
theorem symmetricQuadratic_unique_equal_thirds {a d s x y z : Real}
    (htransverse : d < a) (hsum : x + y + z = s)
    (hcost : symmetricQuadratic a d x y z <=
      symmetricQuadratic a d (s / 3) (s / 3) (s / 3)) :
    And (x = s / 3) (And (y = s / 3) (z = s / 3)) := by
  -- Apply the `positive_symmetric_unique_equal_thirds` theorem.
  have := positive_symmetric_unique_equal_thirds (by linarith : 0 < a - d) hsum; simp_all +decide [ symmetricQuadratic, quadraticCost ];
  exact this ( by rw [ quadratic6, quadratic6 ] at hcost; rw [ ← hsum ] at *; nlinarith )

/-! ## Non-degeneracy and non-canonicity controls -/

/-- Distinct fully symmetric metrics can induce the same selector because
their common-mode difference is constant on a fixed-total fibre. -/
theorem distinct_symmetric_metrics :
    Not (symmetricQuadratic 1 0 1 0 0 = symmetricQuadratic 2 1 1 0 0) := by
  norm_num [symmetricQuadratic, quadratic6]

/-- The theorem's transverse convexity condition is genuine: at `a = d` the
cost is constant on every unit-total fibre. -/
theorem transverse_boundary_flat (x y z : Real) (hsum : x + y + z = 1) :
    symmetricQuadratic 1 1 x y z = 1 := by
  rw [fixed_total_cost_identity hsum]
  norm_num

/-! ## Axiom-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.S3QuadraticSelectorClassification.full_s3_invariance_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms full_s3_invariance_iff

/-- info: 'PhysicsSM.Draft.NullEdge.S3QuadraticSelectorClassification.fixed_total_cost_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fixed_total_cost_identity

/-- info: 'PhysicsSM.Draft.NullEdge.S3QuadraticSelectorClassification.symmetricQuadratic_unique_equal_thirds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms symmetricQuadratic_unique_equal_thirds

end PhysicsSM.Draft.NullEdge.S3QuadraticSelectorClassification
