import PhysicsSM.Draft.NullEdge.ContinuousProjectorRank

/-! # Axiom guard for continuous finite projector rank -/

namespace PhysicsSM.Draft.NullEdge.ContinuousProjectorRank

/-- info: 'PhysicsSM.Draft.NullEdge.ContinuousProjectorRank.trace_eq_rank_of_idempotent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms trace_eq_rank_of_idempotent

/-- info: 'PhysicsSM.Draft.NullEdge.ContinuousProjectorRank.continuous_idempotent_rank_constant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms continuous_idempotent_rank_constant

/-- info: 'PhysicsSM.Draft.NullEdge.ContinuousProjectorRank.continuous_rank_two_of_rest' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms continuous_rank_two_of_rest

end PhysicsSM.Draft.NullEdge.ContinuousProjectorRank
