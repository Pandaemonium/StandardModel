import PhysicsSM.Draft.NullEdge.WeightedGrowingWindowModeSum

/-!
Focused Paper D successor target. This task file is not imported by a project
root. The proof placeholder marks the exact Aristotle handoff target.
-/

noncomputable section

open Filter Topology
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.LiveWeighted3Plus1Walk

set_option maxHeartbeats 3000000

open ChangingModeEmbedding
open SobolevTailRate
open Compact3Plus1DiracRate
open Compact3Plus1GrowingWindowRate
open WeightedGrowingWindowModeSum

/-- A refinement radius dominating three cutoff momentum coordinates and a
fixed natural mass bound. -/
def refinementRadius (M N : Nat) : Nat := 3 * N + M + 1

/-- The quartic number of microscopic steps at cutoff `N`. -/
def refinementSteps (M N : Nat) : Nat := refinementRadius M N ^ 4

/-- Scalar operator-error envelope for the live `3+1` walk on the changing
momentum box. Outside the box the dynamic bulk error is zero; the separately
proved Sobolev tail controls the omitted exact modes. -/
def walkErrorEnvelope {E : Type*} [Norm E]
    (m t : Real) (M N : Nat) (f : Mode -> E) (k : Mode) : Real :=
  if k ∈ modeBox N then
    ‖(splitStep (k.1.1 : Real) (k.1.2 : Real) (k.2 : Real) m
          (t / (refinementSteps M N : Real))) ^ refinementSteps M N -
        exactFlow (k.1.1 : Real) (k.1.2 : Real) (k.2 : Real) m t‖ * ‖f k‖
  else 0

/-- Uniform reciprocal envelope for the live bulk error. -/
def bulkRate (t : Real) (M N : Nat) : Real :=
  (2 * t ^ 2 * Real.exp |t|) / (refinementRadius M N : Real)

theorem bulkRate_nonneg (t : Real) (M N : Nat) :
    0 <= bulkRate t M N := by
  unfold bulkRate refinementRadius
  positivity

/-- The refinement radius grows without bound with the cutoff. -/
theorem refinementRadius_tendsto_atTop (M : Nat) :
    Tendsto (fun N : Nat => (refinementRadius M N : Real)) atTop atTop := by
  have hcast : Tendsto (fun N : Nat => (N : Real)) atTop atTop :=
    tendsto_natCast_atTop_atTop
  refine tendsto_atTop_mono (fun N => ?_) hcast
  have hnat : N <= refinementRadius M N := by
    unfold refinementRadius
    omega
  exact_mod_cast hnat

/-- The common reciprocal bulk rate vanishes with refinement. -/
theorem bulkRate_tendsto_zero (t : Real) (M : Nat) :
    Tendsto (fun N : Nat => bulkRate t M N) atTop (nhds 0) := by
  unfold bulkRate
  exact tendsto_const_nhds.div_atTop (refinementRadius_tendsto_atTop M)

/-- Every mode in the cutoff box lies inside the chosen `B4` window. -/
theorem mode_B4_le_refinementRadius
    (m : Real) (M N : Nat) (hm : |m| <= (M : Real))
    (k : Mode) (hk : k ∈ modeBox N) :
    B4 (k.1.1 : Real) (k.1.2 : Real) (k.2 : Real) m <=
      (refinementRadius M N : Real) := by
  have hr : modeRadius k <= N := (mem_modeBox_iff_radius_le k N).1 hk
  have hxNat : k.1.1.natAbs <= N :=
    (Nat.le_max_left _ _).trans ((Nat.le_max_left _ _).trans hr)
  have hyNat : k.1.2.natAbs <= N :=
    (Nat.le_max_right _ _).trans ((Nat.le_max_left _ _).trans hr)
  have hzNat : k.2.natAbs <= N := (Nat.le_max_right _ _).trans hr
  have hx : |(k.1.1 : Real)| <= (N : Real) := by
    rw [← Int.cast_abs, Int.abs_eq_natAbs]
    exact_mod_cast hxNat
  have hy : |(k.1.2 : Real)| <= (N : Real) := by
    rw [← Int.cast_abs, Int.abs_eq_natAbs]
    exact_mod_cast hyNat
  have hz : |(k.2 : Real)| <= (N : Real) := by
    rw [← Int.cast_abs, Int.abs_eq_natAbs]
    exact_mod_cast hzNat
  simp only [B4, refinementRadius, Nat.cast_add, Nat.cast_mul,
    Nat.cast_ofNat]
  linarith

/-- The live matrix error at every retained mode is bounded by one common
reciprocal rate times the input-mode norm. -/
theorem walkErrorEnvelope_le_bulkRate
    {E : Type*} [NormedAddCommGroup E]
    (m t : Real) (M N : Nat) (hm : |m| <= (M : Real))
    (f : Mode -> E) (k : Mode) :
    walkErrorEnvelope m t M N f k <= bulkRate t M N * ‖f k‖ := by
  by_cases hk : k ∈ modeBox N
  · have hKpos : 0 < refinementRadius M N := by
      unfold refinementRadius
      omega
    have hB := mode_B4_le_refinementRadius m M N hm k hk
    have hmatrix :=
      (quartic_window_many_step_bound
        (k.1.1 : Real) (k.1.2 : Real) (k.2 : Real) m t
        (refinementSteps M N) (refinementRadius M N)
        (by simp [refinementSteps]) hKpos hB).trans
      (quartic_rate_le_reciprocal_envelope
        t (refinementRadius M N) hKpos)
    have hmul := mul_le_mul_of_nonneg_right hmatrix (norm_nonneg (f k))
    simpa [walkErrorEnvelope, hk, bulkRate] using hmul
  · simp [walkErrorEnvelope, hk, bulkRate]
    positivity

theorem walkErrorEnvelope_nonneg
    {E : Type*} [NormedAddCommGroup E]
    (m t : Real) (M N : Nat) (f : Mode -> E) (k : Mode) :
    0 <= walkErrorEnvelope m t M N f k := by
  unfold walkErrorEnvelope
  split_ifs
  · exact mul_nonneg (norm_nonneg _) (norm_nonneg _)
  · exact le_rfl

/-- The actual quartic split-versus-exact matrix-error envelope, square-summed
over an expanding momentum box against any square-summable profile, tends to
zero. This is a dynamic coefficient-space bulk theorem, not yet the final
position-space Dirac PDE limit. -/
theorem walkErrorEnvelope_tendsto_zero
    {E : Type*} [NormedAddCommGroup E]
    (m t : Real) (M : Nat) (hm : |m| <= (M : Real))
    (f : Mode -> E) (hf : Summable (fun k => ‖f k‖ ^ 2)) :
    Tendsto
      (fun N : Nat => ∑' k : Mode, (walkErrorEnvelope m t M N f k) ^ 2)
      atTop (nhds 0) := by
  have hbulk : Tendsto (fun N : Nat => bulkRate t M N) atTop (nhds 0) :=
    bulkRate_tendsto_zero t M
  have hgoal :
      (fun N : Nat => ∑' k : Mode, (walkErrorEnvelope m t M N f k) ^ 2) =
        (fun N : Nat =>
          ∑' k : Mode, ‖(walkErrorEnvelope m t M N f k : Real)‖ ^ 2) := by
    funext N
    refine tsum_congr (fun k => ?_)
    rw [Real.norm_eq_abs, sq_abs]
  rw [hgoal]
  refine growingWindow_countableWeightedL2_tendsto_zero
    (r := fun N : Nat => (bulkRate t M N) ^ 2)
    (err := fun N k => walkErrorEnvelope m t M N f k)
    (f := fun k => (‖f k‖ : Real)) (s := 0) ?_ ?_ ?_
  · simpa using hbulk.pow 2
  · simpa using hf
  · intro N k
    have h0 : 0 <= walkErrorEnvelope m t M N f k :=
      walkErrorEnvelope_nonneg m t M N f k
    have hle : walkErrorEnvelope m t M N f k <= bulkRate t M N * ‖f k‖ :=
      walkErrorEnvelope_le_bulkRate m t M N hm f k
    have hsq : ‖(walkErrorEnvelope m t M N f k : Real)‖ ^ 2 <=
        (bulkRate t M N * ‖f k‖) ^ 2 := by
      rw [Real.norm_eq_abs, sq_abs]
      exact pow_le_pow_left₀ h0 hle 2
    calc
      ‖(walkErrorEnvelope m t M N f k : Real)‖ ^ 2 <=
          (bulkRate t M N * ‖f k‖) ^ 2 := hsq
      _ = (bulkRate t M N) ^ 2 *
            (((1 + modeRadius k : Nat) ^ 0 : Real) *
              ‖(‖f k‖ : Real)‖ ^ 2) := by
            simp [mul_pow]

/-- Nonzero momentum/time fixture showing that the live envelope is not
definitionally zero at finite cutoff. -/
theorem walkErrorEnvelope_nonzero_fixture :
    walkErrorEnvelope 0 1 0 1
      (fun k : Mode => if k = ((1, 0), 0) then (1 : Real) else 0)
      ((1, 0), 0) =
      ‖(splitStep 1 0 0 0 (1 / 256 : Real)) ^ 256 -
        exactFlow 1 0 0 0 1‖ := by
  simp [walkErrorEnvelope, refinementSteps, refinementRadius, modeBox,
    intInterval]

end PhysicsSM.Draft.NullEdge.LiveWeighted3Plus1Walk
