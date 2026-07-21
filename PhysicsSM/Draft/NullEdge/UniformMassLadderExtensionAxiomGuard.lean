import PhysicsSM.Draft.NullEdge.UniformMassLadderExtension

/-!
# Assumption-footprint guards for bounded-mass continuum uniformity

These guards pin the bounded-mass many-step estimate, its supremum convergence
form, and the explicit obstruction to a single constant over all masses to
Lean/Mathlib's standard three principles.
-/

/-- info: 'UniformMass.uniform_many_step' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms UniformMass.uniform_many_step

/-- info: 'UniformMass.ballErrorSup_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms UniformMass.ballErrorSup_tendsto_zero

/-- info: 'UniformMass.unbounded_monotone_constant_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms UniformMass.unbounded_monotone_constant_witness
