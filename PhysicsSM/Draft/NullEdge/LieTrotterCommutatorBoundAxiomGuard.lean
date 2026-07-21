import PhysicsSM.Draft.NullEdge.LieTrotterCommutatorBound

/-!
# Assumption-footprint guards for the commutator Lie-Trotter bound

These guards pin the exact commuting case and the sharp nonnegative-time
commutator estimate to Lean/Mathlib's standard three principles.
-/

/-- info: 'LieTrotter.exp_mul_exp_eq_exp_add_of_mul_eq_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LieTrotter.exp_mul_exp_eq_exp_add_of_mul_eq_mul

/-- info: 'LieTrotter.norm_exp_mul_exp_sub_exp_add_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LieTrotter.norm_exp_mul_exp_sub_exp_add_le

/-- info: 'LieTrotter.norm_lieTrotter_defect_le_zero_of_mul_eq_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms LieTrotter.norm_lieTrotter_defect_le_zero_of_mul_eq_mul
