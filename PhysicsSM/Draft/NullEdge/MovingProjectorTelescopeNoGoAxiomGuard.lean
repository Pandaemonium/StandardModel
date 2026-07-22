import PhysicsSM.Draft.NullEdge.MovingProjectorTelescopeNoGo

/-!
# Axiom guard for the moving-projector telescope no-go

The headline finite control should use only Mathlib's standard logical axioms.
-/

namespace PhysicsSM.Draft.NullEdge.MovingProjectorTelescopeNoGo

/-- info: 'PhysicsSM.Draft.NullEdge.MovingProjectorTelescopeNoGo.rotating_band_mismatch' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rotating_band_mismatch

/-- info: 'PhysicsSM.Draft.NullEdge.MovingProjectorTelescopeNoGo.dynamics_drop_out' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dynamics_drop_out

/-- info: 'PhysicsSM.Draft.NullEdge.MovingProjectorTelescopeNoGo.telescope_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms telescope_sum

/-- info: 'PhysicsSM.Draft.NullEdge.MovingProjectorTelescopeNoGo.no_go_lower_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_go_lower_bound

/-- info: 'PhysicsSM.Draft.NullEdge.MovingProjectorTelescopeNoGo.no_go_constant_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_go_constant_pos

/-- info: 'PhysicsSM.Draft.NullEdge.MovingProjectorTelescopeNoGo.telescope_uniformly_positive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms telescope_uniformly_positive

/-- info: 'PhysicsSM.Draft.NullEdge.MovingProjectorTelescopeNoGo.telescope_sum_lower_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms telescope_sum_lower_bound

/-- info: 'PhysicsSM.Draft.NullEdge.MovingProjectorTelescopeNoGo.telescope_monotone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms telescope_monotone

/-- info: 'PhysicsSM.Draft.NullEdge.MovingProjectorTelescopeNoGo.telescope_gate_fails' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms telescope_gate_fails

/-- info: 'PhysicsSM.Draft.NullEdge.MovingProjectorTelescopeNoGo.telescope_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms telescope_tendsto

end PhysicsSM.Draft.NullEdge.MovingProjectorTelescopeNoGo
