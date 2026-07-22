import PhysicsSM.Draft.NullEdge.DiscreteAdiabaticCancellation

/-! # Axiom guard for exact discrete adiabatic cancellation -/

namespace PhysicsSM.Draft.NullEdge.DiscreteAdiabaticCancellation

/-- info: 'PhysicsSM.Draft.NullEdge.DiscreteAdiabaticCancellation.moving_frame_reduction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms moving_frame_reduction

/-- info: 'PhysicsSM.Draft.NullEdge.DiscreteAdiabaticCancellation.fixed_path_leakage_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fixed_path_leakage_bound

/-- info: 'PhysicsSM.Draft.NullEdge.DiscreteAdiabaticCancellation.fixed_path_nonvacuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fixed_path_nonvacuous

/-- info: 'PhysicsSM.Draft.NullEdge.DiscreteAdiabaticCancellation.fixed_path_leakage_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fixed_path_leakage_tendsto_zero

end PhysicsSM.Draft.NullEdge.DiscreteAdiabaticCancellation
