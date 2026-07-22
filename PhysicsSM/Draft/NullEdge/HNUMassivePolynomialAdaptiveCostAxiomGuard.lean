import PhysicsSM.Draft.NullEdge.HNUMassivePolynomialAdaptiveCost

/-!
# Assumption-footprint guards for live massive HNU polynomial cost

These guards pin the exact one-step and many-step estimates, the common compact
schedule, its changing-window cubic cost, and the nondegenerate kinetic/mass
control to Lean/Mathlib's standard three principles.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassivePolynomialAdaptiveCost.massive_one_step_polynomial_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassivePolynomialAdaptiveCost.massive_one_step_polynomial_bound

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassivePolynomialAdaptiveCost.massive_many_step_polynomial_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassivePolynomialAdaptiveCost.massive_many_step_polynomial_bound

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassivePolynomialAdaptiveCost.massive_schedule_error' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassivePolynomialAdaptiveCost.massive_schedule_error

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassivePolynomialAdaptiveCost.massivePolynomialSteps_changing_window_cubic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassivePolynomialAdaptiveCost.massivePolynomialSteps_changing_window_cubic

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassivePolynomialAdaptiveCost.massive_polynomial_control_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassivePolynomialAdaptiveCost.massive_polynomial_control_nonzero
