import PhysicsSM.Draft.NullEdge.Compact3Plus1RefinedWindowRate

/-!
# An explicit growing-window corollary for the 3+1 split walk

This module composes the small-step-sensitive estimate in
`Compact3Plus1RefinedWindowRate` with the concrete refinement schedule
`n = K^4`. On the parameter window `B4 <= K`, the modewise error is bounded by

```text
2 * t^2 / K^2 * exp(|t| / K^3).
```

This is the first explicit growing-window rung for Paper D. It is still a
modewise matrix estimate. It does not define Shannon sampling on physical
space, identify the changing finite tori with `L2(R^3)`, or prove the final
position-space Dirac PDE theorem.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.Compact3Plus1GrowingWindowRate

open scoped Matrix.Norms.L2Operator
open Filter
open PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
open PhysicsSM.Draft.NullEdge.Compact3Plus1RefinedWindowRate

set_option maxHeartbeats 600000

/-- Pure-real estimate that turns the refined many-step right-hand side into
the quartic-window rate. Keeping this scalar argument separate prevents matrix
normalization from obscuring the proof. -/
theorem quartic_rhs_bound
    (B t : Real) (K : Nat) (hK : 0 < K) (hB0 : 0 <= B)
    (hB : B <= (K : Real)) :
    2 * B ^ 2 * t ^ 2 / (K : Real) ^ 4 *
        Real.exp (|t| * B / (K : Real) ^ 4) <=
      2 * t ^ 2 / (K : Real) ^ 2 * Real.exp (|t| / (K : Real) ^ 3) := by
  have hKR : 0 < (K : Real) := by exact_mod_cast hK
  have hB2 : B ^ 2 <= (K : Real) ^ 2 :=
    (sq_le_sq₀ hB0 hKR.le).2 hB
  have hK4R : 0 < (K : Real) ^ 4 := pow_pos hKR 4
  have hpre :
      2 * B ^ 2 * t ^ 2 / (K : Real) ^ 4 <=
        2 * t ^ 2 / (K : Real) ^ 2 := by
    have hmul :
        2 * B ^ 2 * t ^ 2 <= 2 * (K : Real) ^ 2 * t ^ 2 := by
      exact mul_le_mul_of_nonneg_right
        (mul_le_mul_of_nonneg_left hB2 (by positivity)) (sq_nonneg t)
    have hdiv := div_le_div_of_nonneg_right hmul hK4R.le
    calc
      2 * B ^ 2 * t ^ 2 / (K : Real) ^ 4 <=
          2 * (K : Real) ^ 2 * t ^ 2 / (K : Real) ^ 4 := hdiv
      _ = 2 * t ^ 2 / (K : Real) ^ 2 := by field_simp
  have harg :
      |t| * B / (K : Real) ^ 4 <= |t| / (K : Real) ^ 3 := by
    have hmul : |t| * B <= |t| * (K : Real) :=
      mul_le_mul_of_nonneg_left hB (abs_nonneg t)
    have hdiv := div_le_div_of_nonneg_right hmul hK4R.le
    calc
      |t| * B / (K : Real) ^ 4 <=
          |t| * (K : Real) / (K : Real) ^ 4 := hdiv
      _ = |t| / (K : Real) ^ 3 := by field_simp
  exact mul_le_mul hpre (Real.exp_le_exp.mpr harg)
    (Real.exp_pos _).le (by positivity)

/-- A quartic refinement schedule turns the live small-step estimate into an
explicit growing-window rate. The hypothesis `B4 <= K` permits momenta and
mass to vary with `K`; it is not a fixed-box specialization. -/
theorem quartic_window_many_step_bound
    (kx ky kz m t : Real) (n K : Nat) (hn : n = K ^ 4) (hK : 0 < K)
    (hB : B4 kx ky kz m <= (K : Real)) :
    ‖(splitStep kx ky kz m (t / (n : Real))) ^ n -
        exactFlow kx ky kz m t‖ <=
      2 * t ^ 2 / (K : Real) ^ 2 * Real.exp (|t| / (K : Real) ^ 3) := by
  have hnpos : 0 < n := by simpa [hn] using pow_pos hK 4
  have hB0 : 0 <= B4 kx ky kz m := by
    unfold B4
    positivity
  have hbase := fixed_time_many_step_bound_refined
    kx ky kz m t n hnpos
  have hncast : (n : Real) = (K : Real) ^ 4 := by
    rw [hn, Nat.cast_pow]
  have hrhs :
      2 * B4 kx ky kz m ^ 2 * t ^ 2 / (n : Real) *
          Real.exp (|t| * B4 kx ky kz m / (n : Real)) <=
        2 * t ^ 2 / (K : Real) ^ 2 * Real.exp (|t| / (K : Real) ^ 3) := by
    rw [hncast]
    exact quartic_rhs_bound (B4 kx ky kz m) t K hK hB0 hB
  exact hbase.trans hrhs

/-- Sharp boundary-window control: a pure x-momentum at the edge has `B4 = K`.
This records that the growing-window theorem is not secretly a fixed-mode
statement. -/
theorem quartic_window_boundary (K : Nat) :
    B4 (K : Real) 0 0 0 = (K : Real) := by
  unfold B4
  norm_num [abs_of_nonneg (Nat.cast_nonneg K : (0 : Real) <= (K : Real))]

/-- The quartic rate is bounded by a simple reciprocal envelope. This weaker
envelope is convenient for the strong asymptotic statement below. -/
theorem quartic_rate_le_reciprocal_envelope
    (t : Real) (K : Nat) (hK : 0 < K) :
    2 * t ^ 2 / (K : Real) ^ 2 * Real.exp (|t| / (K : Real) ^ 3) <=
      (2 * t ^ 2 * Real.exp |t|) / (K : Real) := by
  have hKR : 0 < (K : Real) := by exact_mod_cast hK
  have hKone : (1 : Real) <= (K : Real) := by exact_mod_cast hK
  have hpre : 2 * t ^ 2 / (K : Real) ^ 2 <= 2 * t ^ 2 / (K : Real) := by
    field_simp
    nlinarith [sq_nonneg t]
  have harg : |t| / (K : Real) ^ 3 <= |t| := by
    rw [div_le_iff₀ (pow_pos hKR 3)]
    exact le_mul_of_one_le_right (abs_nonneg t) (one_le_pow₀ hKone)
  calc
    2 * t ^ 2 / (K : Real) ^ 2 * Real.exp (|t| / (K : Real) ^ 3) <=
        (2 * t ^ 2 / (K : Real)) * Real.exp |t| :=
      mul_le_mul hpre (Real.exp_le_exp.mpr harg) (Real.exp_pos _).le (by positivity)
    _ = (2 * t ^ 2 * Real.exp |t|) / (K : Real) := by ring

/-- Growing-window consistency for arbitrary parameter sequences satisfying
`B4 <= K`. Both the lattice step count and the allowed momentum/mass window
change with `K`; the comparison remains modewise against the exact flow at the
same parameters. -/
theorem quartic_window_error_tendsto_zero
    (kx ky kz m : Nat -> Real) (t : Real)
    (hB : forall K : Nat,
      B4 (kx K) (ky K) (kz K) (m K) <= (K + 1 : Real)) :
    Tendsto
      (fun K : Nat =>
        ‖(splitStep (kx K) (ky K) (kz K) (m K)
            (t / (((K + 1) ^ 4 : Nat) : Real))) ^ ((K + 1) ^ 4) -
          exactFlow (kx K) (ky K) (kz K) (m K) t‖)
      atTop (nhds 0) := by
  refine squeeze_zero
    (g := fun K : Nat => (2 * t ^ 2 * Real.exp |t|) / (K + 1 : Real))
    (fun K => norm_nonneg _) (fun K => ?_) ?_
  · have h := (quartic_window_many_step_bound
        (kx K) (ky K) (kz K) (m K) t ((K + 1) ^ 4) (K + 1)
        rfl (Nat.succ_pos K) (by simpa using hB K)).trans
      (quartic_rate_le_reciprocal_envelope t (K + 1) (Nat.succ_pos K))
    simpa [Nat.cast_add, Nat.cast_one] using h
  · exact tendsto_const_nhds.div_atTop
      (Filter.tendsto_atTop_add_const_right _ _ tendsto_natCast_atTop_atTop)

/-- Nonzero momentum and nonzero time control at the first convenient quartic
refinement, `K = 2` and `n = 16`. -/
theorem quartic_window_nonzero_control :
    ‖(splitStep 1 0 0 0 (1 / 16 : Real)) ^ 16 - exactFlow 1 0 0 0 1‖ <=
      (1 / 2 : Real) * Real.exp (1 / 8 : Real) := by
  have h := quartic_window_many_step_bound 1 0 0 0 1 16 2
    (by norm_num) (by norm_num) (by norm_num [B4])
  norm_num at h ⊢
  simpa using h

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.Compact3Plus1GrowingWindowRate.quartic_rhs_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quartic_rhs_bound

/-- info: 'PhysicsSM.Draft.NullEdge.Compact3Plus1GrowingWindowRate.quartic_window_many_step_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quartic_window_many_step_bound

/-- info: 'PhysicsSM.Draft.NullEdge.Compact3Plus1GrowingWindowRate.quartic_window_boundary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quartic_window_boundary

/-- info: 'PhysicsSM.Draft.NullEdge.Compact3Plus1GrowingWindowRate.quartic_rate_le_reciprocal_envelope' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quartic_rate_le_reciprocal_envelope

/-- info: 'PhysicsSM.Draft.NullEdge.Compact3Plus1GrowingWindowRate.quartic_window_error_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quartic_window_error_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.Compact3Plus1GrowingWindowRate.quartic_window_nonzero_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quartic_window_nonzero_control

end PhysicsSM.Draft.NullEdge.Compact3Plus1GrowingWindowRate
