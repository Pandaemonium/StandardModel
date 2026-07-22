import PhysicsSM.Draft.NullEdge.InvariantCovarianceEigenspaceStructure

/-!
# Axiom guard for invariant-covariance eigenspace structure

This guard pins the principal finite algebra, spectral variance, rank-two
rigidity, and higher-rank freedom results to Lean's standard-three footprint.
-/

namespace PhysicsSM.Draft.NullEdge.InvariantCovarianceEigenspaceStructure

/-- info: 'PhysicsSM.Draft.NullEdge.InvariantCovarianceEigenspaceStructure.pairClassMatrix_linearIndependent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pairClassMatrix_linearIndependent

/-- info: 'PhysicsSM.Draft.NullEdge.InvariantCovarianceEigenspaceStructure.pairClassMatrix_span' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pairClassMatrix_span

/-- info: 'PhysicsSM.Draft.NullEdge.InvariantCovarianceEigenspaceStructure.invariant_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms invariant_mul

/-- info: 'PhysicsSM.Draft.NullEdge.InvariantCovarianceEigenspaceStructure.invariant_commute' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms invariant_commute

/-- info: 'PhysicsSM.Draft.NullEdge.InvariantCovarianceEigenspaceStructure.regionalVariance_spectral' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms regionalVariance_spectral

/-- info: 'PhysicsSM.Draft.NullEdge.InvariantCovarianceEigenspaceStructure.region_projection_weights' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms region_projection_weights

/-- info: 'PhysicsSM.Draft.NullEdge.InvariantCovarianceEigenspaceStructure.rankTwo_matrix_rigidity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rankTwo_matrix_rigidity

/-- info: 'PhysicsSM.Draft.NullEdge.InvariantCovarianceEigenspaceStructure.centered_indicator_norm_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms centered_indicator_norm_sq

/-- info: 'PhysicsSM.Draft.NullEdge.InvariantCovarianceEigenspaceStructure.rankTwo_regionalVariance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rankTwo_regionalVariance

/-- info: 'PhysicsSM.Draft.NullEdge.InvariantCovarianceEigenspaceStructure.spectral_freedom_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms spectral_freedom_witness

end PhysicsSM.Draft.NullEdge.InvariantCovarianceEigenspaceStructure
