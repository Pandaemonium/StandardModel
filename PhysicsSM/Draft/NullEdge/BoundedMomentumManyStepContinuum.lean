import PhysicsSM.Draft.NullEdge.FixedMomentumManyStepContinuum

/-!
# Uniform many-step convergence on bounded momentum boxes

The landed fixed-momentum theorem bounds the split-step walk error by
`D(k,m) * t^2 / n`. This module makes the next quantifier explicit: on a box
`|k| <= K`, `|m| <= M`, one displayed constant `Dbox K M` bounds every point.
The common rate tends to zero as the number of steps grows.

This is uniformity over bounded momentum and mass parameters for the finite
`2 x 2` symbol. It is not yet an inverse-Fourier, position-space, full
propagator, PDE, or `3+1` convergence theorem.

Provenance: finite inequality target selected by the 2026-07-10 Aristotle
strategy audit and literature pass. The statement was submitted as Aristotle
project `405dc47e-4111-4c22-8058-81be695a8b3a`; Codex also produced this
independent proof while the job was running.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.BoundedMomentumManyStepContinuum

open Filter Topology
open scoped Matrix.Norms.L2Operator
open PhysicsSM.Draft.NullEdge.FixedMomentumManyStepContinuum

/-- Entrywise remainder bound after replacing `|k|,|m|` by box radii. -/
def Cbox (K M : ℝ) : ℝ :=
  2 * K ^ 2 + 2 * M ^ 2 + K * M ^ 2 + K ^ 2 * M + K * M

/-- One explicit many-step error constant valid on the entire parameter box. -/
def Dbox (K M : ℝ) : ℝ :=
  4 * Cbox K M + 4 * (K + M) ^ 2 * Real.exp (K + M)

/-- The pointwise walk constant is bounded by the box constant. -/
theorem Dkm_le_Dbox (k m K M : ℝ) (hK : 0 ≤ K) (hM : 0 ≤ M)
    (hk : |k| ≤ K) (hm : |m| ≤ M) :
    Dkm k m ≤ Dbox K M := by
  have hk2 : k ^ 2 ≤ K ^ 2 := by
    rw [← sq_abs k]
    exact (sq_le_sq₀ (abs_nonneg k) hK).2 hk
  have hm2 : m ^ 2 ≤ M ^ 2 := by
    rw [← sq_abs m]
    exact (sq_le_sq₀ (abs_nonneg m) hM).2 hm
  have hkm2 : |k| * m ^ 2 ≤ K * M ^ 2 :=
    mul_le_mul hk hm2 (sq_nonneg m) hK
  have hk2m : k ^ 2 * |m| ≤ K ^ 2 * M :=
    mul_le_mul hk2 hm (abs_nonneg m) (sq_nonneg K)
  have hkm : |k| * |m| ≤ K * M :=
    mul_le_mul hk hm (abs_nonneg m) hK
  have hC : Ckm k m ≤ Cbox K M := by
    unfold Ckm Cbox
    nlinarith
  have hsum : |k| + |m| ≤ K + M := add_le_add hk hm
  have hsq : (|k| + |m|) ^ 2 ≤ (K + M) ^ 2 :=
    pow_le_pow_left₀ (by positivity) hsum 2
  have hexp : Real.exp (|k| + |m|) ≤ Real.exp (K + M) :=
    Real.exp_le_exp.mpr hsum
  have hprod :
      (|k| + |m|) ^ 2 * Real.exp (|k| + |m|) ≤
        (K + M) ^ 2 * Real.exp (K + M) :=
    mul_le_mul hsq hexp (Real.exp_nonneg _) (sq_nonneg _)
  unfold Dkm Dbox
  nlinarith

/-- **Uniform bounded-momentum rate.** Every point in the displayed box obeys
the same fixed-time `Dbox(K,M) * t^2 / n` estimate. -/
theorem fixed_time_many_step_bound_on_box (k m K M t : ℝ) (n : ℕ)
    (hn : 0 < n) (hsmall : |t / (n : ℝ)| ≤ 1)
    (hK : 0 ≤ K) (hM : 0 ≤ M) (hk : |k| ≤ K) (hm : |m| ≤ M) :
    ‖(walk (k * (t / (n : ℝ))) (m * (t / (n : ℝ)))) ^ n -
        exactFlow k m t‖ ≤ Dbox K M * t ^ 2 / n := by
  have hpoint := fixed_time_many_step_bound k m t n hn hsmall
  have hD := Dkm_le_Dbox k m K M hK hM hk hm
  have hfactor : 0 ≤ t ^ 2 / (n : ℝ) :=
    div_nonneg (sq_nonneg t) (Nat.cast_nonneg n)
  calc
    _ ≤ Dkm k m * t ^ 2 / n := hpoint
    _ = Dkm k m * (t ^ 2 / n) := by ring
    _ ≤ Dbox K M * (t ^ 2 / n) :=
      mul_le_mul_of_nonneg_right hD hfactor
    _ = Dbox K M * t ^ 2 / n := by ring

/-- The common box error envelope tends to zero at the explicit `1/n` rate. -/
theorem box_error_envelope_tendsto_zero (K M t : ℝ) :
    Tendsto (fun n : ℕ => Dbox K M * t ^ 2 / (n + 1 : ℝ))
      atTop (𝓝 0) := by
  exact tendsto_const_nhds.div_atTop
    (Filter.tendsto_atTop_add_const_right _ _ tendsto_natCast_atTop_atTop)

/-- Nondegenerate rational box fixture. -/
theorem rational_box_witness :
    Dkm (3 / 5) (4 / 5) ≤ Dbox 1 1 ∧ Dbox 1 1 > 0 := by
  constructor
  · apply Dkm_le_Dbox <;> norm_num
  · unfold Dbox Cbox
    positivity

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.BoundedMomentumManyStepContinuum.fixed_time_many_step_bound_on_box' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fixed_time_many_step_bound_on_box

/-- info: 'PhysicsSM.Draft.NullEdge.BoundedMomentumManyStepContinuum.box_error_envelope_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms box_error_envelope_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.BoundedMomentumManyStepContinuum.rational_box_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_box_witness

end PhysicsSM.Draft.NullEdge.BoundedMomentumManyStepContinuum
