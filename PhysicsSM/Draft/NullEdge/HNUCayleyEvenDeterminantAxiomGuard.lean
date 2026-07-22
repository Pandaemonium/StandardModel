import PhysicsSM.Draft.NullEdge.HNUCayleyEvenDeterminant

/-! # Axiom guard for the massive-HNU Cayley determinant symmetry -/

namespace PhysicsSM.Draft.NullEdge.HNUCayleyEvenDeterminant

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyEvenDeterminant.massiveHNU_det_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveHNU_det_one

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyEvenDeterminant.massiveHNU_homogeneous_det_swap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveHNU_homogeneous_det_swap

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyEvenDeterminant.cayleyGenerator_sub_shift_factor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cayleyGenerator_sub_shift_factor

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyEvenDeterminant.cayleyGenerator_add_shift_factor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cayleyGenerator_add_shift_factor

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyEvenDeterminant.hnuCayleyGenerator_shifted_det_even' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hnuCayleyGenerator_shifted_det_even

end PhysicsSM.Draft.NullEdge.HNUCayleyEvenDeterminant
