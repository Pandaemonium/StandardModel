import PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction

/-!
# Assumption-footprint guards for the massive HNU continuum reduction

These guards pin the exact mass exponential, the HNU-specific kinetic rate,
the massive one-step estimate, the fixed-time many-step estimate, and the
nondegenerate kinetic/mass witness to Lean/Mathlib's standard three principles.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction.massCoin4_eq_exp_mass4' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction.massCoin4_eq_exp_mass4

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction.diracHNU_sub_linear_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction.diracHNU_sub_linear_bound

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction.massive_one_step_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction.massive_one_step_bound

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction.massive_many_step_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction.massive_many_step_bound

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction.massive_control_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction.massive_control_nonzero
