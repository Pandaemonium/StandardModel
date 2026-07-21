import PhysicsSM.Draft.NullEdge.HNUCompactMomentumContinuum
import PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction

/-!
# Uniform compact-momentum bounds for the massive HNU walk

This module bounds the exact massive HNU one-step coefficient uniformly on a
declared momentum ball `qAbs q <= R` and mass ball `norm z <= M`. It then gives
an explicit common microscopic-step schedule whose fixed-time error tends to
zero even when the represented momentum window changes with refinement.

The mass parameter is fixed by the physical evolution and is not scaled with
the lattice spacing. The bounded mass `M` appears only in the uniform error
envelope. This remains a momentum-space multiplier theorem; the changing-cell
projection, cell variation, ultraviolet tail, and inverse Fourier composition
are successor obligations.

Provenance: clean-room composition of `HNUMassiveContinuumReduction` and
`HNUCompactMomentumContinuum`, July 20, 2026. Claim grade `M`, `[comp]`.
-/

noncomputable section

open Filter Topology
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.HNUMassiveCompactMomentumContinuum

open HNUManyStepContinuum
open HNUCompactMomentumContinuum
open HNUMassiveContinuumReduction

/-- Uniform envelope for the doubled kinetic remainder on `qAbs q <= R`. -/
def kineticEnvelope (R : Real) : Real :=
  2 * (CEnvelope R + R ^ 2 * Real.exp R)

/-- Uniform envelope for the full massive one-step coefficient on
`norm z <= M` and `qAbs q <= R`. -/
def massiveCEnvelope (M R : Real) : Real :=
  M ^ 2 * Real.exp M + kineticEnvelope R +
    M * (kineticEnvelope R + R) +
    (R + M) ^ 2 * Real.exp (R + M)

theorem kineticEnvelope_nonneg {R : Real} (hR : 0 <= R) :
    0 <= kineticEnvelope R := by
  unfold kineticEnvelope
  exact mul_nonneg (by norm_num)
    (add_nonneg (CEnvelope_nonneg hR)
      (mul_nonneg (sq_nonneg R) (Real.exp_nonneg R)))

theorem massiveCEnvelope_nonneg {M R : Real}
    (hM : 0 <= M) (hR : 0 <= R) :
    0 <= massiveCEnvelope M R := by
  unfold massiveCEnvelope
  have hk := kineticEnvelope_nonneg hR
  positivity

/-- The doubled kinetic coefficient is bounded on every `qAbs` ball. -/
theorem kineticRemainderC_le_kineticEnvelope
    (q : Fin 3 -> Real) (R : Real) (hR : 0 <= R)
    (hq : qAbs q <= R) :
    kineticRemainderC q <= kineticEnvelope R := by
  have hq0 := qAbs_nonneg q
  have hsq : qAbs q ^ 2 <= R ^ 2 := pow_le_pow_left₀ hq0 hq 2
  have hexp : Real.exp (qAbs q) <= Real.exp R := Real.exp_le_exp.mpr hq
  unfold kineticRemainderC kineticEnvelope
  gcongr
  exact Cbound_le_CEnvelope q R hR hq

/-- The exact massive coefficient is bounded uniformly on the displayed
momentum and mass balls. -/
theorem massiveRemainderC_le_massiveCEnvelope
    (z : Complex) (q : Fin 3 -> Real) (M R : Real)
    (hM : 0 <= M) (hR : 0 <= R)
    (hz : norm z <= M) (hq : qAbs q <= R) :
    massiveRemainderC z q <= massiveCEnvelope M R := by
  have hz0 : 0 <= norm z := norm_nonneg z
  have hq0 := qAbs_nonneg q
  have hk0 : 0 <= kineticRemainderC q := by
    unfold kineticRemainderC
    exact mul_nonneg (by norm_num)
      (add_nonneg (Cbound_nonneg q)
        (mul_nonneg (sq_nonneg (qAbs q)) (Real.exp_nonneg (qAbs q))))
  have hk := kineticRemainderC_le_kineticEnvelope q R hR hq
  have hze : Real.exp (norm z) <= Real.exp M := Real.exp_le_exp.mpr hz
  have hqe : Real.exp (qAbs q + norm z) <= Real.exp (R + M) :=
    Real.exp_le_exp.mpr (add_le_add hq hz)
  have hzsq : norm z ^ 2 <= M ^ 2 := pow_le_pow_left₀ hz0 hz 2
  have hsum0 : 0 <= qAbs q + norm z := add_nonneg hq0 hz0
  have hsumsq : (qAbs q + norm z) ^ 2 <= (R + M) ^ 2 :=
    pow_le_pow_left₀ hsum0 (add_le_add hq hz) 2
  unfold massiveRemainderC massiveCEnvelope
  dsimp
  gcongr

/-- Uniform fixed-time estimate over complete momentum and mass balls. -/
theorem massive_many_step_bound_on_balls
    (z : Complex) (hz0 : Not (z = 0)) (q : Fin 3 -> Real)
    (M R t : Real) (n : Nat)
    (hM : 0 <= M) (hR : 0 <= R)
    (hz : norm z <= M) (hq : qAbs q <= R)
    (hn : 0 < n) (hsmall : |t / (n : Real)| <= 1) :
    norm ((massiveWend z q (t / (n : Real))) ^ n -
        massiveEflow z q t) <=
      massiveCEnvelope M R * t ^ 2 / n := by
  calc
    norm ((massiveWend z q (t / (n : Real))) ^ n -
        massiveEflow z q t) <= massiveRemainderC z q * t ^ 2 / n :=
      massive_many_step_bound z hz0 q t n hn hsmall
    _ <= massiveCEnvelope M R * t ^ 2 / n := by
      gcongr
      exact massiveRemainderC_le_massiveCEnvelope z q M R hM hR hz hq

/-- Common microscopic step count selected from the massive uniform envelope. -/
def massiveAdaptiveSteps (M R t : Real) (N : Nat) : Nat :=
  Nat.ceil
    (max |t| (massiveCEnvelope M R * t ^ 2 * (N + 1 : Real))) + 1

theorem massiveAdaptiveSteps_pos (M R t : Real) (N : Nat) :
    0 < massiveAdaptiveSteps M R t N := by
  unfold massiveAdaptiveSteps
  omega

theorem massiveAdaptiveSteps_small (M R t : Real) (N : Nat) :
    |t / (massiveAdaptiveSteps M R t N : Real)| <= 1 := by
  have hpos : 0 < (massiveAdaptiveSteps M R t N : Real) := by
    exact_mod_cast massiveAdaptiveSteps_pos M R t N
  have hceil :
      max |t| (massiveCEnvelope M R * t ^ 2 * (N + 1 : Real)) <=
        (Nat.ceil (max |t|
          (massiveCEnvelope M R * t ^ 2 * (N + 1 : Real))) : Real) :=
    Nat.le_ceil _
  have ht : |t| <= (massiveAdaptiveSteps M R t N : Real) := by
    unfold massiveAdaptiveSteps
    push_cast
    linarith [le_max_left |t|
      (massiveCEnvelope M R * t ^ 2 * (N + 1 : Real))]
  rw [abs_div, abs_of_nonneg hpos.le]
  exact (div_le_one hpos).2 ht

/-- The adaptive massive envelope rate is at most `1/(N+1)`. -/
theorem massive_adaptive_rate_le (M R t : Real) (N : Nat)
    (hM : 0 <= M) (hR : 0 <= R) :
    massiveCEnvelope M R * t ^ 2 / massiveAdaptiveSteps M R t N <=
      1 / (N + 1 : Real) := by
  have hA : 0 <= massiveCEnvelope M R * t ^ 2 :=
    mul_nonneg (massiveCEnvelope_nonneg hM hR) (sq_nonneg t)
  have hsteps : 0 < (massiveAdaptiveSteps M R t N : Real) := by
    exact_mod_cast massiveAdaptiveSteps_pos M R t N
  have hN : 0 < (N + 1 : Real) := by positivity
  have hceil :
      max |t| (massiveCEnvelope M R * t ^ 2 * (N + 1 : Real)) <=
        (Nat.ceil (max |t|
          (massiveCEnvelope M R * t ^ 2 * (N + 1 : Real))) : Real) :=
    Nat.le_ceil _
  have hproduct : massiveCEnvelope M R * t ^ 2 * (N + 1 : Real) <=
      (massiveAdaptiveSteps M R t N : Real) := by
    unfold massiveAdaptiveSteps
    push_cast
    linarith [le_max_right |t|
      (massiveCEnvelope M R * t ^ 2 * (N + 1 : Real))]
  rw [div_le_div_iff₀ hsteps hN]
  nlinarith

/-- The adaptive rate tends to zero for nonnegative changing momentum windows
and a fixed nonnegative mass bound. -/
theorem massive_adaptive_rate_tendsto_zero
    (M : Real) (R : Nat -> Real) (t : Real)
    (hM : 0 <= M) (hR : forall N, 0 <= R N) :
    Tendsto
      (fun N => massiveCEnvelope M (R N) * t ^ 2 /
        massiveAdaptiveSteps M (R N) t N)
      atTop (nhds 0) := by
  refine squeeze_zero
    (fun N => div_nonneg
      (mul_nonneg (massiveCEnvelope_nonneg hM (hR N)) (sq_nonneg t))
      (Nat.cast_nonneg _))
    (fun N => massive_adaptive_rate_le M (R N) t N hM (hR N)) ?_
  have hlim : Tendsto
      (fun N : Nat => (1 : Real) / ((N : Real) + 1))
      atTop (nhds 0) := tendsto_one_div_add_atTop_nhds_zero_nat
  simpa using hlim

/-- Explicit changing-window convergence for fixed nonzero Pluecker mass. -/
theorem massive_adaptive_changing_window_tendsto
    (z : Complex) (hz0 : Not (z = 0)) (M : Real)
    (q : Nat -> Fin 3 -> Real) (R : Nat -> Real) (t : Real)
    (hM : 0 <= M) (hR : forall N, 0 <= R N)
    (hz : norm z <= M) (hq : forall N, qAbs (q N) <= R N) :
    Tendsto
      (fun N => norm
        ((massiveWend z (q N)
          (t / (massiveAdaptiveSteps M (R N) t N : Real))) ^
            massiveAdaptiveSteps M (R N) t N -
          massiveEflow z (q N) t))
      atTop (nhds 0) := by
  exact squeeze_zero
    (fun N => norm_nonneg _)
    (fun N => massive_many_step_bound_on_balls z hz0 (q N) M (R N) t
      (massiveAdaptiveSteps M (R N) t N) hM (hR N) hz (hq N)
      (massiveAdaptiveSteps_pos M (R N) t N)
      (massiveAdaptiveSteps_small M (R N) t N))
    (massive_adaptive_rate_tendsto_zero M R t hM hR)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveCompactMomentumContinuum.massiveRemainderC_le_massiveCEnvelope' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveRemainderC_le_massiveCEnvelope

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveCompactMomentumContinuum.massive_many_step_bound_on_balls' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massive_many_step_bound_on_balls

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveCompactMomentumContinuum.massive_adaptive_changing_window_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massive_adaptive_changing_window_tendsto

end PhysicsSM.Draft.NullEdge.HNUMassiveCompactMomentumContinuum
