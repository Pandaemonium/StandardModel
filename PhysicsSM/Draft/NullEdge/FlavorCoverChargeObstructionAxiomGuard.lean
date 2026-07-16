import PhysicsSM.Draft.NullEdge.FlavorCoverChargeObstruction

/-!
# Axiom guard for the flavor-cover charge obstruction

This guard pins the trust footprint of the regular-deck-action obstruction and
its explicit nonconstant `6 + 2` hypercharge witness.
-/

namespace PhysicsSM.Draft.NullEdge.FlavorCoverChargeObstructionAxiomGuard

/-- info: 'PhysicsSM.Draft.NullEdge.FlavorCoverChargeObstruction.deckInvariant_forces_constant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FlavorCoverChargeObstruction.deckInvariant_forces_constant

/-- info: 'PhysicsSM.Draft.NullEdge.FlavorCoverChargeObstruction.leptonSheets_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FlavorCoverChargeObstruction.leptonSheets_card

/-- info: 'PhysicsSM.Draft.NullEdge.FlavorCoverChargeObstruction.quarkSheets_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FlavorCoverChargeObstruction.quarkSheets_card

/-- info: 'PhysicsSM.Draft.NullEdge.FlavorCoverChargeObstruction.leftDoubletHypercharge_not_deckInvariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FlavorCoverChargeObstruction.leftDoubletHypercharge_not_deckInvariant

end PhysicsSM.Draft.NullEdge.FlavorCoverChargeObstructionAxiomGuard
