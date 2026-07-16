import PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz
import PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk

/-!
# Uniform sampled intra-cell exact-multiplier convergence

This module advances `CONT-MULT-001` from a pointwise operator estimate to a
global coefficient-energy theorem. For every refining cell, choose an
arbitrary physical momentum point inside that cell. The exact Dirac multiplier
at the chosen point and at the cell center act on the actual normalized
coefficient extracted from the input field. The sum of all resulting squared
spinor errors is bounded by

```text
(3 |t| h / 2)^2 * input L2 energy,
```

uniformly over every choice of sample points. Since the physical spacing `h`
tends to zero, the complete sampled error tends to zero.

This is stronger than convergence at one preferred representative and blocks
a center-only reading. It is still a finite sampled theorem: identifying the
cell integral of the continuously varying multiplier with a dominated limit is
the next analytic rung. No inverse Fourier or position-space PDE claim is made.

Provenance: clean-room composition of the sharp Hermitian flow bound,
`ExactFlowMomentumLipschitz.exactFlow_cellCenter_norm_le`, and the normalized
coefficient energy contraction in `ChangingCellScaledLiveWalk`, July 12, 2026.
-/

noncomputable section

open scoped BigOperators ENNReal Matrix.Norms.L2Operator
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.ExactFlowCellSampleEnergy

open ChangingMomentumCellIsometry
open ChangingMomentumCellSampling
open ChangingMomentumCellProjectionStrongScaffold
open ChangingCellScaledLiveWalk
open ScaledChangingMomentumWalk
open Compact3Plus1DiracRate
open ExactFlowMomentumLipschitz

/-- The exact-multiplier variation rate on one physical momentum cell. -/
def exactCellSampleRate (t : Real) (N : Nat) : Real :=
  |t| * (3 * physicalSpacing N / 2)

theorem exactCellSampleRate_nonneg (t : Real) (N : Nat) :
    0 <= exactCellSampleRate t N := by
  unfold exactCellSampleRate
  exact mul_nonneg (abs_nonneg t)
    (div_nonneg (mul_nonneg (by norm_num) (physicalSpacing_pos N).le)
      (by norm_num))

theorem exactCellSampleRate_tendsto_zero (t : Real) :
    Tendsto (exactCellSampleRate t) atTop (nhds 0) := by
  have h := (physicalSpacing_tendsto_zero.const_mul (|t| * (3 / 2 : Real)))
  convert h using 1
  · funext N
    simp [exactCellSampleRate]
    ring
  · ring

/-- Anti-vacuity control: every scheduled family contains the zero momentum
mode, so the global sums do not vanish because the mode set becomes empty. -/
theorem zeroMode_mem_scheduledModes (N : Nat) :
    (0 : Mode3) ∈ scheduledModes N := by
  rw [mem_scheduledModes_iff]
  intro i
  simp

/-- Difference between exact evolution at an arbitrary point of a cell and at
the cell center, applied to the actual field-derived spinor coefficient. -/
def exactCellSampleError (m t : Real) (N : Nat)
    (F : Momentum3 -> Spinor) (sample : Mode3 -> Momentum3)
    (k : Mode3) : Spinor :=
  (EuclideanSpace.equiv (Fin 4) Complex).symm
    ((exactFlow (sample k 0) (sample k 1) (sample k 2) m t -
        exactFlow
          (cellCenter (physicalSpacing N) k 0)
          (cellCenter (physicalSpacing N) k 1)
          (cellCenter (physicalSpacing N) k 2) m t).mulVec
      (spinorCellCoefficient N F k))

/-- Uniform one-cell error bound for any selected point in that cell. -/
theorem exactCellSampleError_norm_le
    (m t : Real) (N : Nat) (F : Momentum3 -> Spinor)
    (sample : Mode3 -> Momentum3) (k : Mode3)
    (hsample : sample k ∈ momentumCell (physicalSpacing N) k) :
    ‖exactCellSampleError m t N F sample k‖ <=
      exactCellSampleRate t N * ‖spinorCellCoefficient N F k‖ := by
  have hop := Matrix.l2_opNorm_mulVec
    (exactFlow (sample k 0) (sample k 1) (sample k 2) m t -
      exactFlow
        (cellCenter (physicalSpacing N) k 0)
        (cellCenter (physicalSpacing N) k 1)
        (cellCenter (physicalSpacing N) k 2) m t)
    (spinorCellCoefficient N F k)
  exact le_trans (by simpa [exactCellSampleError] using hop)
    (mul_le_mul_of_nonneg_right
      (by
        simpa [exactCellSampleRate] using
          exactFlow_cellCenter_norm_le hsample m t)
      (norm_nonneg _))

/-- The complete arbitrary-sample coefficient error is bounded by the square
of the physical cell diameter rate times the actual input-field energy. -/
theorem exactCellSampleError_energy_le
    (m t : Real) (N : Nat) (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume)
    (sample : Mode3 -> Momentum3)
    (hsample : ∀ k, k ∈ scheduledModes N ->
      sample k ∈ momentumCell (physicalSpacing N) k) :
    (∑ k ∈ scheduledModes N,
        ‖exactCellSampleError m t N F sample k‖ ^ 2) <=
      (exactCellSampleRate t N) ^ 2 *
        (∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2) := by
  calc
    (∑ k ∈ scheduledModes N,
        ‖exactCellSampleError m t N F sample k‖ ^ 2) <=
        ∑ k ∈ scheduledModes N,
          (exactCellSampleRate t N * ‖spinorCellCoefficient N F k‖) ^ 2 := by
      apply Finset.sum_le_sum
      intro k hk
      exact pow_le_pow_left₀ (norm_nonneg _)
        (exactCellSampleError_norm_le m t N F sample k (hsample k hk)) 2
    _ = (exactCellSampleRate t N) ^ 2 *
        (∑ k ∈ scheduledModes N, ‖spinorCellCoefficient N F k‖ ^ 2) := by
      simp_rw [mul_pow, Finset.mul_sum]
    _ <= (exactCellSampleRate t N) ^ 2 *
        (∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2) := by
      exact mul_le_mul_of_nonneg_left
        (spinorCellCoefficient_energy_le N F hF) (sq_nonneg _)

/-- **Uniform global sampled convergence.** For any sequence of choices with
one point inside every scheduled cell, the total exact-multiplier variation on
the field-derived coefficients tends to zero. -/
theorem exactCellSampleError_tendsto_zero
    (m t : Real) (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume)
    (sample : Nat -> Mode3 -> Momentum3)
    (hsample : ∀ N k, k ∈ scheduledModes N ->
      sample N k ∈ momentumCell (physicalSpacing N) k) :
    Tendsto
      (fun N => ∑ k ∈ scheduledModes N,
        ‖exactCellSampleError m t N F (sample N) k‖ ^ 2)
      atTop (nhds 0) := by
  let C : Real := ∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2
  refine squeeze_zero
    (fun N => Finset.sum_nonneg fun _ _ => sq_nonneg _)
    (fun N => exactCellSampleError_energy_le m t N F hF
      (sample N) (hsample N)) ?_
  have hr := (exactCellSampleRate_tendsto_zero t).pow 2
  simpa [C] using hr.mul_const C

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowCellSampleEnergy.exactCellSampleError_energy_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactCellSampleError_energy_le

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowCellSampleEnergy.exactCellSampleError_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactCellSampleError_tendsto_zero

end PhysicsSM.Draft.NullEdge.ExactFlowCellSampleEnergy
