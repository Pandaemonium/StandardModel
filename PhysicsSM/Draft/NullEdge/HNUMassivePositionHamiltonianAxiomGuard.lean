import PhysicsSM.Draft.NullEdge.HNUMassivePositionHamiltonian

/-! # Assumption-footprint guards for the live massive position Hamiltonian -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassivePositionHamiltonian.massivePositionHamiltonian_isSelfAdjoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassivePositionHamiltonian.massivePositionHamiltonian_isSelfAdjoint

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassivePositionHamiltonian.massivePositionHamiltonian_graph_norm_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUMassivePositionHamiltonian.massivePositionHamiltonian_graph_norm_exact
