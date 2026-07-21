import PhysicsSM.Draft.NullEdge.FiniteFermionicInteraction

/-!
# Axiom guards for the finite fermionic interaction control
-/

/-- info: 'FermionInteraction.quarticHamiltonian_eq_H' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FermionInteraction.quarticHamiltonian_eq_H

/-- info: 'FermionInteraction.U_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FermionInteraction.U_unitary

/-- info: 'FermionInteraction.conjugate_outside_create' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FermionInteraction.conjugate_outside_create

/-- info: 'FermionInteraction.conjugate_maps_cell_CAR' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FermionInteraction.conjugate_maps_cell_CAR

/-- info: 'FermionInteraction.pair01_sector_mixed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms FermionInteraction.pair01_sector_mixed
