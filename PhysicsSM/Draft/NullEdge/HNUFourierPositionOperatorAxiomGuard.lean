import PhysicsSM.Draft.NullEdge.HNUFourierPositionOperator

/-!
# Assumption-footprint guards for the Fourier-conjugated HNU operator

The guards pin the exact unitary-conjugation and Fourier-domain payload to
Lean/Mathlib's standard three principles.
-/

/-- info: 'LinearPMap.isSelfAdjoint_unitaryConjugate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LinearPMap.isSelfAdjoint_unitaryConjugate

/-- info: 'PhysicsSM.Draft.NullEdge.HNUFourierPositionOperator.positionDirac_isSelfAdjoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUFourierPositionOperator.positionDirac_isSelfAdjoint

/-- info: 'PhysicsSM.Draft.NullEdge.HNUFourierPositionOperator.positionDirac_graph_norm_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUFourierPositionOperator.positionDirac_graph_norm_exact

/-- info: 'PhysicsSM.Draft.NullEdge.HNUFourierPositionOperator.scalar_fourier_deriv_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUFourierPositionOperator.scalar_fourier_deriv_control
