import PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias

/-!
# Dependency guard for retarded-moment metric debiasing

This module pins the transitive dependency footprint of the exact covariance
identities and nonidentity rational witness. It does not upgrade the supplied
metric, moment, jet, inverse, response, chart, or continuum assumptions to a
graph reconstruction.
-/

namespace PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebiasAxiomGuard

/-- info: 'PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias.momentNorm_congr' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias.momentNorm_congr

/-- info: 'PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias.temporalProjector_congr' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias.temporalProjector_congr

/-- info: 'PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias.debiasedMetric_congr' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias.debiasedMetric_congr

/-- info: 'PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias.temporalProjectorJet_congr' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias.temporalProjectorJet_congr

/-- info: 'PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias.debiasedMetricJet_congr' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias.debiasedMetricJet_congr

/-- info: 'PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias.nontrivial_response_correction_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias.nontrivial_response_correction_witness

end PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebiasAxiomGuard
