import PhysicsSM.Draft.NullEdge.HNUManyStepContinuumLive

/-!
# Uniform compact-momentum and changing-window bounds for the HNU walk

`HNUManyStepContinuumLive` proves a fixed-momentum many-step estimate for the
exact Higashikawa-Nakagawa-Ueda endpoint. This module makes the momentum
dependence explicit. It bounds the one-step constant uniformly on every
`qAbs` ball and packages the estimate for a momentum and step schedule that may
change with the refinement level.

The final theorem is a genuine changing-window operator statement: both the
momentum and the number of microscopic steps may vary. Its rate hypothesis is
kept visible. A later module must discharge that hypothesis for the chosen
sampling schedule and then combine it with the existing normalized-cell and
inverse-Fourier machinery. No position-space PDE claim is made here.

Provenance: clean-room composition of the kernel-checked estimates in
`HNUManyStepContinuumLive`, July 20, 2026.
-/

noncomputable section

open Filter Topology
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.HNUCompactMomentumContinuum

open HNUManyStepContinuum

/-- A monotone envelope for the pointwise HNU error constant on
`qAbs q <= R`. -/
def CEnvelope (R : Real) : Real :=
  (40 * R ^ 2 + 40 * R ^ 3) * (2 + R / 2) +
    R ^ 2 / 4 + R ^ 2 * Real.exp R

theorem CEnvelope_nonneg {R : Real} (hR : 0 <= R) :
    0 <= CEnvelope R := by
  unfold CEnvelope
  positivity

/-- The exact pointwise constant is bounded by `CEnvelope R` on the complete
`qAbs` ball of radius `R`. -/
theorem Cbound_le_CEnvelope (q : Fin 3 -> Real) (R : Real)
    (hR : 0 <= R) (hq : qAbs q <= R) :
    Cbound q <= CEnvelope R := by
  have hq0 : 0 <= qAbs q := qAbs_nonneg q
  unfold Cbound CM CEnvelope
  have h2 : qAbs q ^ 2 <= R ^ 2 := by
    exact pow_le_pow_left₀ hq0 hq 2
  have h3 : qAbs q ^ 3 <= R ^ 3 := by
    exact pow_le_pow_left₀ hq0 hq 3
  have hexp : Real.exp (qAbs q) <= Real.exp R :=
    Real.exp_le_exp.mpr hq
  gcongr

/-- Uniform fixed-time estimate over the complete `qAbs` ball. -/
theorem many_step_bound_on_ball (q : Fin 3 -> Real) (R t : Real) (n : Nat)
    (hR : 0 <= R) (hq : qAbs q <= R) (hn : 0 < n)
    (hsmall : |t / (n : Real)| <= 1) :
    norm ((Wend q (t / (n : Real))) ^ n - Eflow q t) <=
      CEnvelope R * t ^ 2 / n := by
  calc
    norm ((Wend q (t / (n : Real))) ^ n - Eflow q t) <=
        Cbound q * t ^ 2 / n := many_step_bound q t n hn hsmall
    _ <= CEnvelope R * t ^ 2 / n := by
      gcongr
      exact Cbound_le_CEnvelope q R hR hq

/-- A changing-window schedule inherits the explicit envelope bound at every
refinement level. -/
theorem changing_window_bound
    (q : Nat -> Fin 3 -> Real) (R : Nat -> Real)
    (steps : Nat -> Nat) (t : Real)
    (hR : forall N, 0 <= R N)
    (hq : forall N, qAbs (q N) <= R N)
    (hsteps : forall N, 0 < steps N)
    (hsmall : forall N, |t / (steps N : Real)| <= 1)
    (N : Nat) :
    norm ((Wend (q N) (t / (steps N : Real))) ^ steps N -
        Eflow (q N) t) <=
      CEnvelope (R N) * t ^ 2 / steps N := by
  exact many_step_bound_on_ball (q N) (R N) t (steps N)
    (hR N) (hq N) (hsteps N) (hsmall N)

/-- **Changing-window HNU convergence.** If the displayed uniform envelope
rate tends to zero, the exact HNU many-step update converges to the Weyl flow
even when the represented momentum changes with the refinement level. -/
theorem changing_window_tendsto
    (q : Nat -> Fin 3 -> Real) (R : Nat -> Real)
    (steps : Nat -> Nat) (t : Real)
    (hR : forall N, 0 <= R N)
    (hq : forall N, qAbs (q N) <= R N)
    (hsteps : forall N, 0 < steps N)
    (hsmall : forall N, |t / (steps N : Real)| <= 1)
    (hrate : Tendsto
      (fun N => CEnvelope (R N) * t ^ 2 / steps N)
      atTop (nhds 0)) :
    Tendsto
      (fun N => norm ((Wend (q N) (t / (steps N : Real))) ^ steps N -
        Eflow (q N) t))
      atTop (nhds 0) := by
  exact squeeze_zero
    (fun N => norm_nonneg _)
    (fun N => changing_window_bound q R steps t hR hq hsteps hsmall N)
    hrate

/-! ## An explicit adaptive schedule -/

/-- A common microscopic step count chosen directly from the uniform envelope.
The added `1` makes positivity unconditional. -/
def adaptiveSteps (R t : Real) (N : Nat) : Nat :=
  Nat.ceil (max |t| (CEnvelope R * t ^ 2 * (N + 1 : Real))) + 1

theorem adaptiveSteps_pos (R t : Real) (N : Nat) :
    0 < adaptiveSteps R t N := by
  unfold adaptiveSteps
  omega

/-- The adaptive schedule always puts the microscopic time increment inside
the one-step estimate's unit interval. -/
theorem adaptiveSteps_small (R t : Real) (N : Nat) :
    |t / (adaptiveSteps R t N : Real)| <= 1 := by
  have hpos : 0 < (adaptiveSteps R t N : Real) := by
    exact_mod_cast adaptiveSteps_pos R t N
  have hceil :
      max |t| (CEnvelope R * t ^ 2 * (N + 1 : Real)) <=
        (Nat.ceil (max |t|
          (CEnvelope R * t ^ 2 * (N + 1 : Real))) : Real) :=
    Nat.le_ceil _
  have ht : |t| <= (adaptiveSteps R t N : Real) := by
    unfold adaptiveSteps
    push_cast
    linarith [le_max_left |t|
      (CEnvelope R * t ^ 2 * (N + 1 : Real))]
  rw [abs_div, abs_of_nonneg hpos.le]
  exact (div_le_one hpos).2 ht

/-- By construction, the adaptive envelope rate is at most `1/(N+1)`,
independently of how quickly the momentum window grows. -/
theorem adaptive_rate_le (R t : Real) (N : Nat) (hR : 0 <= R) :
    CEnvelope R * t ^ 2 / adaptiveSteps R t N <=
      1 / (N + 1 : Real) := by
  have hA : 0 <= CEnvelope R * t ^ 2 :=
    mul_nonneg (CEnvelope_nonneg hR) (sq_nonneg t)
  have hsteps : 0 < (adaptiveSteps R t N : Real) := by
    exact_mod_cast adaptiveSteps_pos R t N
  have hN : 0 < (N + 1 : Real) := by positivity
  have hceil :
      max |t| (CEnvelope R * t ^ 2 * (N + 1 : Real)) <=
        (Nat.ceil (max |t|
          (CEnvelope R * t ^ 2 * (N + 1 : Real))) : Real) :=
    Nat.le_ceil _
  have hproduct :
      CEnvelope R * t ^ 2 * (N + 1 : Real) <=
        (adaptiveSteps R t N : Real) := by
    unfold adaptiveSteps
    push_cast
    linarith [le_max_right |t|
      (CEnvelope R * t ^ 2 * (N + 1 : Real))]
  rw [div_le_div_iff₀ hsteps hN]
  nlinarith

/-- The adaptive rate tends to zero for every nonnegative sequence of momentum
window radii. -/
theorem adaptive_rate_tendsto_zero (R : Nat -> Real) (t : Real)
    (hR : forall N, 0 <= R N) :
    Tendsto
      (fun N => CEnvelope (R N) * t ^ 2 / adaptiveSteps (R N) t N)
      atTop (nhds 0) := by
  refine squeeze_zero
    (fun N => div_nonneg
      (mul_nonneg (CEnvelope_nonneg (hR N)) (sq_nonneg t))
      (Nat.cast_nonneg _))
    (fun N => adaptive_rate_le (R N) t N (hR N)) ?_
  have hlim : Tendsto
      (fun N : Nat => (1 : Real) / ((N : Real) + 1))
      atTop (nhds 0) :=
    tendsto_one_div_add_atTop_nhds_zero_nat
  simpa using hlim

/-- **Explicit changing-window HNU convergence.** For any represented momentum
sequence contained in the displayed windows, the adaptive common-step schedule
converges to the exact Weyl flow at finite time. The window may itself diverge;
the cost is paid transparently in `adaptiveSteps`. -/
theorem adaptive_changing_window_tendsto
    (q : Nat -> Fin 3 -> Real) (R : Nat -> Real) (t : Real)
    (hR : forall N, 0 <= R N)
    (hq : forall N, qAbs (q N) <= R N) :
    Tendsto
      (fun N => norm
        ((Wend (q N) (t / (adaptiveSteps (R N) t N : Real))) ^
            adaptiveSteps (R N) t N - Eflow (q N) t))
      atTop (nhds 0) := by
  exact changing_window_tendsto q R
    (fun N => adaptiveSteps (R N) t N) t hR hq
    (fun N => adaptiveSteps_pos (R N) t N)
    (fun N => adaptiveSteps_small (R N) t N)
    (adaptive_rate_tendsto_zero R t hR)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCompactMomentumContinuum.Cbound_le_CEnvelope' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Cbound_le_CEnvelope

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCompactMomentumContinuum.many_step_bound_on_ball' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms many_step_bound_on_ball

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCompactMomentumContinuum.changing_window_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms changing_window_tendsto

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCompactMomentumContinuum.adaptive_changing_window_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms adaptive_changing_window_tendsto

end PhysicsSM.Draft.NullEdge.HNUCompactMomentumContinuum
