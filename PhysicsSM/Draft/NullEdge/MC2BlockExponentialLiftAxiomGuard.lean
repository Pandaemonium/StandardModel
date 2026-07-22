import PhysicsSM.Draft.NullEdge.MC2BlockExponentialLift

/-!
Build-enforced axiom footprint for the matrix-exponential bridge used by the
massive HNU polynomial-cost proof.
-/

/-- info: 'MC2Exp.exp_blockDiag' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs(info) in
#print axioms MC2Exp.exp_blockDiag

/-- info: 'MC2Exp.exp_MC2_blockDiag' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs(info) in
#print axioms MC2Exp.exp_MC2_blockDiag

/-- info: 'MC2Exp.exp_unitary_conjugation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs(info) in
#print axioms MC2Exp.exp_unitary_conjugation

/-- info: 'MC2Exp.exp_conjugated_blockDiag' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs(info) in
#print axioms MC2Exp.exp_conjugated_blockDiag
