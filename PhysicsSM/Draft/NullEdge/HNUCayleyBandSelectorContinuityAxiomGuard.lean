import PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorContinuity

/-! # Axiom guard for HNU Cayley-generator continuity -/

namespace PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorContinuity

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorContinuity.continuousAt_matrix_inv_comp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms continuousAt_matrix_inv_comp

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorContinuity.massiveHNU_continuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveHNU_continuous

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorContinuity.hnuCayleyGenerator_continuousWithinAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hnuCayleyGenerator_continuousWithinAt

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorContinuity.hnuCayleyGenerator_continuousOn' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hnuCayleyGenerator_continuousOn

end PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorContinuity
