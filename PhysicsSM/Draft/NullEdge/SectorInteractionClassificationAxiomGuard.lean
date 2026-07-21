import PhysicsSM.Draft.NullEdge.SectorInteractionClassification

/-!
# Axiom guards for exact finite-sector interaction classification
-/

/-- info: 'SectorInteractionClassification.commutes_sectorProjector_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SectorInteractionClassification.commutes_sectorProjector_iff

/-- info: 'SectorInteractionClassification.exponential_commutes_sectorProjector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SectorInteractionClassification.exponential_commutes_sectorProjector

/-- info: 'SectorInteractionClassification.witness_pair_interaction_mixes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SectorInteractionClassification.witness_pair_interaction_mixes
