import PhysicsSM.Draft.NullEdge.Goal3ChannelRG

/-!
# Exact marginal-line dynamics of the three-channel RG map

The Jacobian of `Goal3ChannelRG.R3` at `(1,1,0)` has eigenvalue `-1` along
`(1,1,0)`.  A proposed dimensional-transmutation route asks whether nonlinear
terms turn the doubled map into a cubic drift along this direction.

For the live rational map the answer is exact and negative: every nonzero point
`(g,g,0)` is sent to `(-g,-g,0)`, and the second iterate returns exactly to the
starting point.  Thus this particular marginal line is exactly period two; it
does not generate a KT-type hierarchy.  The off-line `3-4-5`-scale control
shows that the full RG map is nevertheless nontrivial.

This is a scoped kill of the proposed marginal-line transmutation mechanism,
not a no-go against dimensional transmutation elsewhere in the coupling space.
-/

namespace PhysicsSM.Draft.NullEdge.Goal3MarginalLine

open Goal3ChannelRG

/-- The live three-channel RG map is an exact sign flip on the nonzero
aperture-closure diagonal with zero turn coupling. -/
theorem R3_on_marginal_line (g : ℚ) (hg : g ≠ 0) :
    R3 g g 0 = (-g, -g, 0) := by
  apply Prod.ext
  · dsimp [R3]
    field_simp
    ring
  · apply Prod.ext
    · dsimp [R3]
      field_simp
      ring
    · simp [R3]

/-- The marginal line is exactly period two under the nonlinear RG map. -/
theorem R3_second_iterate_on_marginal_line (g : ℚ) (hg : g ≠ 0) :
    let y := R3 g g 0
    R3 y.1 y.2.1 y.2.2 = (g, g, 0) := by
  dsimp only
  rw [R3_on_marginal_line g hg]
  change R3 (-g) (-g) 0 = (g, g, 0)
  rw [R3_on_marginal_line (-g) (neg_ne_zero.mpr hg)]
  simp

/-- A nonzero point on the marginal line is period two rather than fixed. -/
theorem R3_marginal_line_not_fixed (g : ℚ) (hg : g ≠ 0) :
    R3 g g 0 ≠ (g, g, 0) := by
  rw [R3_on_marginal_line g hg]
  intro h
  have hfirst := congrArg Prod.fst h
  apply hg
  linarith

/-- Off the critical diagonal the map is not merely a sign flip. -/
theorem off_line_nontrivial_control :
    R3 (1 : ℚ) (1 / 2 : ℚ) 0 = (1 / 2, -1 / 4, 0) := by
  norm_num [R3]

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.Goal3MarginalLine.R3_on_marginal_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms R3_on_marginal_line

/-- info: 'PhysicsSM.Draft.NullEdge.Goal3MarginalLine.R3_second_iterate_on_marginal_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms R3_second_iterate_on_marginal_line

/-- info: 'PhysicsSM.Draft.NullEdge.Goal3MarginalLine.R3_marginal_line_not_fixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms R3_marginal_line_not_fixed

/-- info: 'PhysicsSM.Draft.NullEdge.Goal3MarginalLine.off_line_nontrivial_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms off_line_nontrivial_control

end PhysicsSM.Draft.NullEdge.Goal3MarginalLine
