import PhysicsSM.Draft.NullEdge.WeakFermionParityChirality

/-!
# Axiom guard for weak chirality from fermion parity

The principal live-model parity, number-conservation, sector-census, and
sharpness declarations are pinned to Lean's standard-three footprint.
-/

namespace PhysicsSM.Draft.NullEdge.WeakFermionParityChirality

/-- info: 'PhysicsSM.Draft.NullEdge.WeakFermionParityChirality.chirality_eq_neg_fermion_parity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chirality_eq_neg_fermion_parity

/-- info: 'PhysicsSM.Draft.NullEdge.WeakFermionParityChirality.commutes_chi_of_commutes_number' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms commutes_chi_of_commutes_number

/-- info: 'PhysicsSM.Draft.NullEdge.WeakFermionParityChirality.chiral_cross_blocks_zero_of_number_conservation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chiral_cross_blocks_zero_of_number_conservation

/-- info: 'PhysicsSM.Draft.NullEdge.WeakFermionParityChirality.generators_left_block' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms generators_left_block

/-- info: 'PhysicsSM.Draft.NullEdge.WeakFermionParityChirality.number_zero_eigenspace_one_dim' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms number_zero_eigenspace_one_dim

/-- info: 'PhysicsSM.Draft.NullEdge.WeakFermionParityChirality.number_two_eigenspace_one_dim' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms number_two_eigenspace_one_dim

/-- info: 'PhysicsSM.Draft.NullEdge.WeakFermionParityChirality.number_one_eigenspace_two_dim' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms number_one_eigenspace_two_dim

/-- info: 'PhysicsSM.Draft.NullEdge.WeakFermionParityChirality.one_plus_two_plus_one_content' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms one_plus_two_plus_one_content

/-- info: 'PhysicsSM.Draft.NullEdge.WeakFermionParityChirality.B1_not_number_conserving_and_not_chirality_conserving' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms B1_not_number_conserving_and_not_chirality_conserving

/-- info: 'PhysicsSM.Draft.NullEdge.WeakFermionParityChirality.live_chirality_eq_neg_fermion_parity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms live_chirality_eq_neg_fermion_parity

/-- info: 'PhysicsSM.Draft.NullEdge.WeakFermionParityChirality.live_generators_left_block' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms live_generators_left_block

end PhysicsSM.Draft.NullEdge.WeakFermionParityChirality
