import PhysicsSM.Draft.NullEdge.FiniteMovingBandWitness

/-! Build-enforced axiom footprint for the finite moving-band control. -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteMovingBandWitness.exact_uniform_gap' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs(info) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteMovingBandWitness.exact_uniform_gap

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteMovingBandWitness.moving_projector_defect_factorization' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs(info) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteMovingBandWitness.moving_projector_defect_factorization

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteMovingBandWitness.accumulated_budget_tendsto_zero' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs(info) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteMovingBandWitness.accumulated_budget_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteMovingBandWitness.scheduledProduct_fixed_endpoint_and_zero_leakage' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs(info) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteMovingBandWitness.scheduledProduct_fixed_endpoint_and_zero_leakage
