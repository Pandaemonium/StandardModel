import PhysicsSM.Draft.NullEdge.CompositeMassBridge

/-!
# Axiom guard for the finite composite-mass bridge

The capstone is expected to use only Mathlib's standard logical axioms.
-/

/-- info: 'CompositeMassBridge.one_model_discharges_all_A3' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms CompositeMassBridge.one_model_discharges_all_A3
