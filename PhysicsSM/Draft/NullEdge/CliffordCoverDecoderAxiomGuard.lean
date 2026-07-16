import PhysicsSM.Draft.NullEdge.CliffordCoverDecoder

/-!
# Axiom guard for the signed flavor-cover Clifford core
-/

namespace PhysicsSM.Draft.NullEdge.CliffordCoverDecoderAxiomGuard

/-- info: 'PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.deckFlip_involutive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.deckFlip_involutive

/-- info: 'PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.deckFlip_commute' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.deckFlip_commute

/-- info: 'PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.cliffordFlip_involutive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.cliffordFlip_involutive

/-- info: 'PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.cliffordFlip_anticommute' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.cliffordFlip_anticommute

/-- info: 'PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.deckFlip_eq_cliffordFlip_on_vacuum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.deckFlip_eq_cliffordFlip_on_vacuum

/-- info: 'PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.unsigned_signed_distinct_corrected' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CliffordCoverDecoder.unsigned_signed_distinct_corrected

end PhysicsSM.Draft.NullEdge.CliffordCoverDecoderAxiomGuard
