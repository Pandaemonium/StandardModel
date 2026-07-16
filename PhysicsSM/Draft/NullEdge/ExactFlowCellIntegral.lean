import PhysicsSM.Draft.NullEdge.ExactFlowCellSampleEnergy

/-!
# Actual intra-cell exact-multiplier L2 integral

This is the next `CONT-MULT-001` gate after the landed arbitrary-sample theorem.
It defines the continuously varying exact-flow error inside each physical
momentum cell, with the exact reciprocal-square-root-volume normalization, and
proves the global cell-integral bound and limit.

The mathematical bound is already available pointwise from
`exactFlow_cellCenter_norm_le`; the expected blocker is the Mathlib
measurability/integrability and disjoint-cell set-integral API. Do not replace
this target by a finite sample or assumed integrability theorem: the finite
sample theorem is already landed in `ExactFlowCellSampleEnergy`.

## Trust and provenance

Draft-trust by kernel: the actual integral decomposition, bound, and limit are
proof-hole-free. The exact target was prepared by Codex and proved by Aristotle
project `5f03e432` without strengthening the componentwise `L2` assumptions or
replacing the integral by a sampled surrogate. Codex compared the returned
statements with the preregistered target and replayed them under the pinned
toolchain. The proof reuses the repository's measurable half-open cells,
finite-volume normalization, disjoint-cell integration, and exact-flow
Lipschitz bound.
-/

noncomputable section

open scoped BigOperators ENNReal Matrix.Norms.L2Operator
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.ExactFlowCellIntegral

open ChangingMomentumCellIsometry
open ChangingMomentumCellSampling
open ChangingMomentumCellProjectionStrongScaffold
open ChangingCellScaledLiveWalk
open ScaledChangingMomentumWalk
open Compact3Plus1DiracRate
open ExactFlowMomentumLipschitz
open ExactFlowCellSampleEnergy

/-- Exact multiplier variation at a physical point, applied to the normalized
coefficient and embedded with the reciprocal square-root cell volume. -/
def exactCellVariationAt (m t : Real) (N : Nat)
    (F : Momentum3 -> Spinor) (k : Mode3) (x : Momentum3) : Spinor :=
  (cellScale (physicalSpacing N) : Complex) •
    (EuclideanSpace.equiv (Fin 4) Complex).symm
      ((exactFlow (x 0) (x 1) (x 2) m t -
          exactFlow
            (cellCenter (physicalSpacing N) k 0)
            (cellCenter (physicalSpacing N) k 1)
            (cellCenter (physicalSpacing N) k 2) m t).mulVec
        (spinorCellCoefficient N F k))

/-- Piecewise exact-multiplier variation field on the finite scheduled cell
union. Cell disjointness makes the displayed sum pointwise single-valued. -/
def exactCellVariationField (m t : Real) (N : Nat)
    (F : Momentum3 -> Spinor) : Momentum3 -> Spinor := fun x =>
  ∑ k ∈ scheduledModes N,
    (momentumCell (physicalSpacing N) k).indicator
      (fun x => exactCellVariationAt m t N F k x) x

/-- Continuity of one cell's untruncated multiplier error. This is the main
measurability input; no regularity hypothesis on `F` is needed because the
cell coefficient is constant in `x`. -/
theorem exactCellVariationAt_continuous
    (m t : Real) (N : Nat) (F : Momentum3 -> Spinor) (k : Mode3) :
    Continuous (exactCellVariationAt m t N F k) := by
  letI : NormedAlgebra Rat Compact3Plus1DiracRate.Mat4 :=
    NormedAlgebra.restrictScalars Rat Complex Compact3Plus1DiracRate.Mat4
  unfold exactCellVariationAt Compact3Plus1DiracRate.exactFlow Compact3Plus1DiracRate.H
  apply continuous_const.smul
  apply (EuclideanSpace.equiv (Fin 4) Complex).symm.continuous.comp
  fun_prop

/-- The reciprocal square-root cell scale is nonnegative. -/
theorem cellScale_nonneg (N : Nat) : 0 <= cellScale (physicalSpacing N) := by
  unfold cellScale
  positivity

/-- Exact cell normalization: the cell volume cancels the square of the
reciprocal square-root scale. -/
theorem physicalSpacing_pow_mul_cellScale_sq (N : Nat) :
    (physicalSpacing N) ^ 3 * (cellScale (physicalSpacing N)) ^ 2 = 1 := by
  have hh : 0 < (physicalSpacing N) ^ 3 := pow_pos (physicalSpacing_pos N) 3
  unfold cellScale
  rw [inv_pow, Real.sq_sqrt hh.le, mul_inv_cancel₀ (ne_of_gt hh)]

/-- The continuously varying cell variation is the scaled arbitrary-sample
error evaluated at the running point. -/
theorem exactCellVariationAt_eq_smul (m t : Real) (N : Nat)
    (F : Momentum3 -> Spinor) (k : Mode3) (x : Momentum3) :
    exactCellVariationAt m t N F k x =
      (cellScale (physicalSpacing N) : Complex) •
        exactCellSampleError m t N F (fun _ => x) k := rfl

/-- Pointwise cell norm bound from the imported exact cell norm estimate. -/
theorem exactCellVariationAt_norm_le (m t : Real) (N : Nat)
    (F : Momentum3 -> Spinor) (k : Mode3) {x : Momentum3}
    (hx : x ∈ momentumCell (physicalSpacing N) k) :
    ‖exactCellVariationAt m t N F k x‖ <=
      cellScale (physicalSpacing N) *
        (exactCellSampleRate t N * ‖spinorCellCoefficient N F k‖) := by
  rw [exactCellVariationAt_eq_smul, norm_smul,
    show ‖(cellScale (physicalSpacing N) : Complex)‖ = cellScale (physicalSpacing N) from by
      rw [Complex.norm_real]; exact abs_of_nonneg (cellScale_nonneg N)]
  exact mul_le_mul_of_nonneg_left
    (exactCellSampleError_norm_le m t N F (fun _ => x) k hx)
    (cellScale_nonneg N)

/-- Squared pointwise cell norm bound. -/
theorem exactCellVariationAt_norm_sq_le (m t : Real) (N : Nat)
    (F : Momentum3 -> Spinor) (k : Mode3) {x : Momentum3}
    (hx : x ∈ momentumCell (physicalSpacing N) k) :
    ‖exactCellVariationAt m t N F k x‖ ^ 2 <=
      (cellScale (physicalSpacing N)) ^ 2 *
        (exactCellSampleRate t N * ‖spinorCellCoefficient N F k‖) ^ 2 := by
  rw [← mul_pow]
  exact pow_le_pow_left₀ (norm_nonneg _)
    (exactCellVariationAt_norm_le m t N F k hx) 2

/-- The squared cell variation is integrable on its cell (measurable set of
finite volume, continuous integrand bounded by a constant). -/
theorem exactCellVariationAt_integrableOn (m t : Real) (N : Nat)
    (F : Momentum3 -> Spinor) (k : Mode3) :
    IntegrableOn (fun x => ‖exactCellVariationAt m t N F k x‖ ^ 2)
      (momentumCell (physicalSpacing N) k) := by
  refine Measure.integrableOn_of_bounded
    (volume_momentumCell_ne_top _ _)
    (((exactCellVariationAt_continuous m t N F k).norm.pow 2).aestronglyMeasurable)
    (M := (cellScale (physicalSpacing N)) ^ 2 *
      (exactCellSampleRate t N * ‖spinorCellCoefficient N F k‖) ^ 2) ?_
  filter_upwards [ae_restrict_mem (momentumCell_measurable _ _)] with x hx
  rw [Real.norm_of_nonneg (by positivity)]
  exact exactCellVariationAt_norm_sq_le m t N F k hx

/-- One-cell set-integral bound: the cell integral of the squared exact
variation is at most the squared sample rate times the coefficient energy. -/
theorem exactCellVariationAt_setIntegral_le (m t : Real) (N : Nat)
    (F : Momentum3 -> Spinor) (k : Mode3) :
    (∫ x in momentumCell (physicalSpacing N) k,
        ‖exactCellVariationAt m t N F k x‖ ^ 2) <=
      (exactCellSampleRate t N) ^ 2 * ‖spinorCellCoefficient N F k‖ ^ 2 := by
  calc
    (∫ x in momentumCell (physicalSpacing N) k,
        ‖exactCellVariationAt m t N F k x‖ ^ 2) <=
        ∫ _x in momentumCell (physicalSpacing N) k,
          (cellScale (physicalSpacing N)) ^ 2 *
            (exactCellSampleRate t N * ‖spinorCellCoefficient N F k‖) ^ 2 := by
      refine setIntegral_mono_on
        (exactCellVariationAt_integrableOn m t N F k)
        (integrableOn_const (volume_momentumCell_ne_top _ _))
        (momentumCell_measurable _ _) ?_
      intro x hx
      exact exactCellVariationAt_norm_sq_le m t N F k hx
    _ = (exactCellSampleRate t N) ^ 2 * ‖spinorCellCoefficient N F k‖ ^ 2 := by
      rw [setIntegral_const, measureReal_def,
        volume_momentumCell_toReal (physicalSpacing_pos N), smul_eq_mul,
        mul_pow, ← mul_assoc, physicalSpacing_pow_mul_cellScale_sq N, one_mul]

/-- On a scheduled cell, the piecewise field agrees with that cell's variation. -/
theorem exactCellVariationField_eq_on_cell (m t : Real) (N : Nat)
    (F : Momentum3 -> Spinor) {k : Mode3} {x : Momentum3}
    (hk : k ∈ scheduledModes N)
    (hx : x ∈ momentumCell (physicalSpacing N) k) :
    exactCellVariationField m t N F x = exactCellVariationAt m t N F k x := by
  unfold exactCellVariationField
  rw [Finset.sum_eq_single k]
  · rw [Set.indicator_of_mem hx]
  · intro q hq hqk
    rw [Set.indicator_of_notMem]
    exact fun hxq =>
      Set.disjoint_left.1
        (momentumCell_disjoint (physicalSpacing_pos N) hqk) hxq hx
  · intro h
    exact absurd hk h

/-- The squared field is integrable on each scheduled cell. -/
theorem exactCellVariationField_integrableOn (m t : Real) (N : Nat)
    (F : Momentum3 -> Spinor) {k : Mode3} (hk : k ∈ scheduledModes N) :
    IntegrableOn (fun x => ‖exactCellVariationField m t N F x‖ ^ 2)
      (momentumCell (physicalSpacing N) k) := by
  refine (exactCellVariationAt_integrableOn m t N F k).congr_fun ?_
    (momentumCell_measurable _ _)
  intro x hx
  dsimp only
  rw [exactCellVariationField_eq_on_cell m t N F hk hx]

/-- Exact disjoint-cell decomposition of the global embedded spinor energy. -/
theorem exactCellVariationField_energy_eq
    (m t : Real) (N : Nat) (F : Momentum3 -> Spinor) :
    (∫ x, ‖exactCellVariationField m t N F x‖ ^ 2) =
      ∑ k ∈ scheduledModes N,
        ∫ x in momentumCell (physicalSpacing N) k,
          ‖exactCellVariationAt m t N F k x‖ ^ 2 := by
  have hunion :
      (∫ x, ‖exactCellVariationField m t N F x‖ ^ 2) =
        ∫ x in ⋃ k ∈ scheduledModes N, momentumCell (physicalSpacing N) k,
          ‖exactCellVariationField m t N F x‖ ^ 2 := by
    rw [setIntegral_eq_integral_of_forall_compl_eq_zero]
    intro x hx
    have hzero : exactCellVariationField m t N F x = 0 := by
      unfold exactCellVariationField
      refine Finset.sum_eq_zero ?_
      intro k hk
      rw [Set.indicator_of_notMem]
      exact fun hxk => hx (Set.mem_biUnion hk hxk)
    rw [hzero]
    simp
  rw [hunion, integral_biUnion_finset]
  · refine Finset.sum_congr rfl fun k hk => ?_
    refine setIntegral_congr_fun (momentumCell_measurable _ _) fun x hx => ?_
    rw [exactCellVariationField_eq_on_cell m t N F hk hx]
  · exact fun k hk => momentumCell_measurable _ _
  · exact fun x hx y hy hxy =>
      momentumCell_disjoint (physicalSpacing_pos N) hxy
  · exact fun k hk => exactCellVariationField_integrableOn m t N F hk

/-- The actual continuously varying multiplier error obeys the same global
input-energy bound as every finite sample selection. -/
theorem exactCellVariationField_energy_le
    (m t : Real) (N : Nat) (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    (∫ x, ‖exactCellVariationField m t N F x‖ ^ 2) <=
      (exactCellSampleRate t N) ^ 2 *
        (∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2) := by
  rw [exactCellVariationField_energy_eq]
  calc
    (∑ k ∈ scheduledModes N,
        ∫ x in momentumCell (physicalSpacing N) k,
          ‖exactCellVariationAt m t N F k x‖ ^ 2) <=
        ∑ k ∈ scheduledModes N,
          (exactCellSampleRate t N) ^ 2 * ‖spinorCellCoefficient N F k‖ ^ 2 := by
      exact Finset.sum_le_sum
        fun k hk => exactCellVariationAt_setIntegral_le m t N F k
    _ = (exactCellSampleRate t N) ^ 2 *
        (∑ k ∈ scheduledModes N, ‖spinorCellCoefficient N F k‖ ^ 2) := by
      rw [Finset.mul_sum]
    _ <= (exactCellSampleRate t N) ^ 2 *
        (∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2) := by
      exact mul_le_mul_of_nonneg_left
        (spinorCellCoefficient_energy_le N F hF) (sq_nonneg _)

/-- **Actual intra-cell multiplier convergence.** The full embedded L2 energy
of the continuously varying exact multiplier minus its cell-center value tends
to zero for every componentwise L2 spinor field. -/
theorem exactCellVariationField_tendsto_zero
    (m t : Real) (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    Tendsto
      (fun N => ∫ x, ‖exactCellVariationField m t N F x‖ ^ 2)
      atTop (nhds 0) := by
  refine squeeze_zero
    (fun N => integral_nonneg fun x => sq_nonneg _)
    (fun N => exactCellVariationField_energy_le m t N F hF) ?_
  have hr := (exactCellSampleRate_tendsto_zero t).pow 2
  simpa using hr.mul_const (∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowCellIntegral.exactCellVariationField_energy_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactCellVariationField_energy_eq

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowCellIntegral.exactCellVariationField_energy_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactCellVariationField_energy_le

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowCellIntegral.exactCellVariationField_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactCellVariationField_tendsto_zero

end PhysicsSM.Draft.NullEdge.ExactFlowCellIntegral
