import PhysicsSM.Draft.NullEdge.MovingSectorLeakage

/-! Build-enforced axiom footprint for the moving-sector leakage capstone. -/

/-- info: 'PhysicsSM.Draft.NullEdge.MovingSectorLeakage.norm_moving_leakage_le_sum' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs(info) in
#print axioms PhysicsSM.Draft.NullEdge.MovingSectorLeakage.norm_moving_leakage_le_sum

/-- info: 'PhysicsSM.Draft.NullEdge.MovingSectorLeakage.norm_moving_leakage_le_nat_mul' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs(info) in
#print axioms PhysicsSM.Draft.NullEdge.MovingSectorLeakage.norm_moving_leakage_le_nat_mul

/-- info: 'PhysicsSM.Draft.NullEdge.MovingSectorLeakage.moving_leakage_eq_zero_of_exact' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs(info) in
#print axioms PhysicsSM.Draft.NullEdge.MovingSectorLeakage.moving_leakage_eq_zero_of_exact
