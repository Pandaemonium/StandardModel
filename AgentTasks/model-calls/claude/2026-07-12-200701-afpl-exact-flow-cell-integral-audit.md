# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `opus`
- Status: `failed`
- Dry run: `False`
- Started: `2026-07-12T20:06:52`
- Finished: `2026-07-12T20:07:01`
- Timeout seconds: `900`
- Max budget USD: `2.00`
- Return code: `1`

## Command

```text
claude -p --bare --model opus --max-budget-usd 2.00 --output-format text --add-dir 'C:\Projects\StandardModel' --tools default --permission-mode bypassPermissions --disallowed-tools 'Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write' --mcp-config 'C:\Projects\StandardModel\Scripts\autonomous_loop\review.mcp.json' --strict-mcp-config
```

## Prompt

```text
You are the independent Claude-family skeptic for the Autonomous Fundamental Physics Lab. Review the attached verbatim Lean sources, especially `ExactFlowCellIntegral.lean`, against this intended reading.

Project context: this is a finite-to-continuum momentum-space result in the Null-Edge program. The claimed theorem is deliberately narrow: the exact continuum multiplier varies with x inside every scheduled momentum cell; its per-cell integral is well-defined; the disjoint global cell integral equals the sum of exact cell energies; the normalization `cellScale^2 * volume(cell) = 1` cancels; the resulting energy is bounded by the actual `spinorCellCoefficient` L2 coefficients under only the original componentwise `MemLp` hypotheses; and the exact cell-variation energy tends to zero. It does NOT yet prove inverse Fourier transport, position-space PDE convergence, Lorentz restoration, or a physical continuum limit.

Audit independently:
1. Is `exactCellVariationField` genuinely x-dependent through `exactFlow`, rather than a sampled or constant surrogate?
2. Are continuity and `IntegrableOn` derived from the definitions and available theorems, without hidden regularity assumptions on F?
3. Does `exactCellVariationEnergy_eq_sum` correctly use pairwise disjoint scheduled cells and identify the actual global integral?
4. Is the volume/scale cancellation exact and nonvacuous?
5. Does `exactCellVariationEnergy_le` use the actual `spinorCellCoefficient`, retain only componentwise `MemLp` assumptions, and avoid silently replacing coefficients by arbitrary data?
6. Is the Tendsto theorem a valid nonnegative squeeze from the displayed bound?
7. Check for vacuity, hollow telescoping, false-shape theorem, or prose stronger than kernel content.

Return one of `ACCEPT_WITH_SCOPE`, `REPAIR_REQUIRED`, or `REJECT`. Cite exact declaration names and give the minimum repair if needed. Do not infer any unproved PDE or position-space consequence.

## Verbatim source artifacts under review

These are the ACTUAL files. Base every finding on the real statements and definitions below, not on any paraphrase above. For each theorem under review, explicitly check whether the Lean matches its intended reading, and flag every mismatch.

### PhysicsSM/Draft/NullEdge/ExactFlowCellIntegral.lean (277 lines)

```lean
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

```

### PhysicsSM/Draft/NullEdge/ExactFlowMomentumLipschitz.lean (108 lines)

```lean
import PhysicsSM.Draft.NullEdge.HermitianExpLipschitz
import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
import PhysicsSM.Draft.NullEdge.ChangingMomentumCellSampling

/-!
# Momentum Lipschitz bound for the exact 3+1 Dirac flow

This module specializes the sharp Hermitian exponential estimate to the live
four-by-four Dirac symbol. The exact multiplier changes across one physical
momentum cell by at most `3 * |t| * h / 2` in L2 operator norm.

This is the local analytic rung needed by `CONT-MULT-001`. It does not yet sum
the cellwise estimate against an arbitrary L2 field, apply inverse Fourier
transform, or identify a position-space PDE solution.

Provenance: in-project composition of `HermitianExpLipschitz`,
`Compact3Plus1DiracRate`, and `ChangingMomentumCellSampling`, July 12, 2026.
-/

noncomputable section

open Matrix Complex Real
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz

open Compact3Plus1DiracRate
open ChangingMomentumCellIsometry
open ChangingMomentumCellSampling

/-- The difference of two equal-mass Dirac symbols is the symbol of the
momentum difference with zero mass. -/
theorem H_sub_H_eq (kx ky kz qx qy qz m : Real) :
    H kx ky kz m - H qx qy qz m =
      H (kx - qx) (ky - qy) (kz - qz) 0 := by
  unfold H
  push_cast
  module

/-- The Dirac symbol is Lipschitz in the coordinate L1 momentum distance. -/
theorem norm_H_sub_H_le_l1 (kx ky kz qx qy qz m : Real) :
    ‖H kx ky kz m - H qx qy qz m‖ <=
      |kx - qx| + |ky - qy| + |kz - qz| := by
  rw [H_sub_H_eq]
  exact le_trans (norm_H_le_B4 _ _ _ _) (by simp [B4])

/-- The exact Dirac multiplier is sharply Lipschitz in momentum, with no
growth in the absolute momentum window. -/
theorem exactFlow_momentum_lipschitz
    (kx ky kz qx qy qz m t : Real) :
    ‖exactFlow kx ky kz m t - exactFlow qx qy qz m t‖ <=
      |t| * (|kx - qx| + |ky - qy| + |kz - qz|) := by
  refine le_trans
    (by
      simpa [exactFlow] using
        HermitianExpLipschitz.hermitian_exp_lipschitz
          (H kx ky kz m) (H qx qy qz m)
          (H_isHermitian _ _ _ _) (H_isHermitian _ _ _ _) t)
    (mul_le_mul_of_nonneg_left
      (norm_H_sub_H_le_l1 kx ky kz qx qy qz m) (abs_nonneg t))

/-- Inside one physical momentum cell, the exact multiplier differs from its
cell-center value by at most `3 |t| h / 2`. -/
theorem exactFlow_cellCenter_norm_le {h : Real}
    {k : Mode3} {x : Momentum3} (hx : x ∈ momentumCell h k)
    (m t : Real) :
    ‖exactFlow (x 0) (x 1) (x 2) m t -
        exactFlow (cellCenter h k 0) (cellCenter h k 1)
          (cellCenter h k 2) m t‖ <=
      |t| * (3 * h / 2) := by
  have h0 := mem_momentumCell_coord_error hx 0
  have h1 := mem_momentumCell_coord_error hx 1
  have h2 := mem_momentumCell_coord_error hx 2
  refine le_trans
    (exactFlow_momentum_lipschitz
      (x 0) (x 1) (x 2)
      (cellCenter h k 0) (cellCenter h k 1) (cellCenter h k 2) m t) ?_
  apply mul_le_mul_of_nonneg_left _ (abs_nonneg t)
  nlinarith

/-- Boundary control: at zero elapsed time, the exact multiplier is the
identity for every momentum. -/
theorem exactFlow_zero_time (kx ky kz m : Real) :
    exactFlow kx ky kz m 0 = 1 := by
  simp [exactFlow]

/-- Nonconstant control: changing the x momentum changes the live Hermitian
generator. -/
theorem H_x_witness_ne : H 1 0 0 0 ≠ H 0 0 0 0 := by
  intro h
  have h03 := congrFun (congrFun h 0) 3
  norm_num [H, alpha1, alpha2, alpha3, beta] at h03
  simp at h03

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz.exactFlow_momentum_lipschitz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlow_momentum_lipschitz

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz.exactFlow_cellCenter_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlow_cellCenter_norm_le

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz.H_x_witness_ne' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms H_x_witness_ne

end PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz

```

### PhysicsSM/Draft/NullEdge/ChangingMomentumCellCoefficientBridge.lean (160 lines)

```lean
import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionL2

/-!
# Exact coefficient bridge for changing momentum-cell projections

The representative-safe projection stores a constant cell average on each
selected momentum cell. The normalized coefficient seen by the landed
`L2(R^3)` cell embedding is therefore not the bare average: it is the average
multiplied by the square root of the cell volume.

This module proves that normalization exactly. The resulting coefficient
embedding is pointwise equal to `projectFinite`, and its finite coefficient
energy is exactly the projected `L2` energy. A mesh-two control shows that the
bare average has energy one while the represented constant cell has energy
eight, so omitting the square-root-volume factor is a genuine normalization
error.

This is the first rung of `CONT-LIVE-001`. It identifies the coefficients that
must be supplied to the scaled live walk, but it does not yet evolve them,
apply an inverse Fourier transform, or prove a position-space PDE limit.

Provenance: clean-room composition of the project definitions
`cellAverage`, `cellPacket`, `embedFinite`, and `projectFinite`, July 12, 2026.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge

open ChangingMomentumCellIsometry
open ChangingMomentumPointSamplerNoGo
open ChangingMomentumCellProjection
open ChangingMomentumCellProjectionL2

/-- The normalized coefficient represented by one constant momentum cell. -/
def cellCoefficient (h : Real) (k : Mode3)
    (f : Momentum3 -> Complex) : Complex :=
  (Real.sqrt (h ^ 3) : Complex) * cellAverage h k f

/-- One normalized coefficient packet is exactly the corresponding constant
cell-average contribution to `projectFinite`. -/
theorem cellPacket_cellCoefficient {h : Real} (hh : 0 < h)
    (k : Mode3) (f : Momentum3 -> Complex) :
    cellPacket h k (cellCoefficient h k f) =
      (momentumCell h k).indicator (fun _ => cellAverage h k f) := by
  funext x
  by_cases hx : x ∈ momentumCell h k
  · rw [cellPacket, Set.indicator_of_mem hx, Set.indicator_of_mem hx]
    have hs : Real.sqrt (h ^ 3) ≠ 0 :=
      ne_of_gt (Real.sqrt_pos.2 (pow_pos hh 3))
    have hsC : (Real.sqrt (h ^ 3) : Complex) ≠ 0 := by
      exact_mod_cast hs
    unfold cellScale cellCoefficient
    push_cast
    rw [← mul_assoc]
    rw [inv_mul_cancel₀ hsC, one_mul]
  · simp [cellPacket, hx]

/-- The normalized finite coefficient embedding reconstructs the
representative-safe cell-average projection pointwise. -/
theorem embedFinite_cellCoefficient {h : Real} (hh : 0 < h)
    (s : Finset Mode3) (f : Momentum3 -> Complex) :
    embedFinite h s (fun k => cellCoefficient h k f) =
      projectFinite h s f := by
  funext x
  unfold embedFinite projectFinite
  apply Finset.sum_congr rfl
  intro k hk
  rw [cellPacket_cellCoefficient hh k f]

/-- The squared norm of one normalized coefficient is cell volume times the
squared norm of its average. -/
theorem norm_sq_cellCoefficient {h : Real} (hh : 0 < h)
    (k : Mode3) (f : Momentum3 -> Complex) :
    ‖cellCoefficient h k f‖ ^ 2 =
      (volume (momentumCell h k)).toReal * ‖cellAverage h k f‖ ^ 2 := by
  rw [volume_momentumCell_toReal hh k]
  simp only [cellCoefficient, norm_mul, Complex.norm_real,
    mul_pow]
  rw [Real.norm_eq_abs, abs_of_nonneg (Real.sqrt_nonneg _)]
  rw [Real.sq_sqrt (le_of_lt (pow_pos hh 3))]

/-- Finite coefficient energy is exactly the projected continuum `L2`
energy. -/
theorem coefficient_energy_eq_projectFinite {h : Real} (hh : 0 < h)
    (s : Finset Mode3) (f : Momentum3 -> Complex) :
    (∑ k ∈ s, ‖cellCoefficient h k f‖ ^ 2) =
      ∫ x, ‖projectFinite h s f x‖ ^ 2 := by
  rw [integral_norm_sq_projectFinite_eq_sum hh s f]
  apply Finset.sum_congr rfl
  intro k hk
  exact norm_sq_cellCoefficient hh k f

/-- The exact coefficient family inherits the projection's `L2` contraction. -/
theorem coefficient_energy_le_input {h : Real} (hh : 0 < h)
    (s : Finset Mode3) (f : Momentum3 -> Complex)
    (hf : ∀ k, k ∈ s -> IntegrableOn f (momentumCell h k))
    (hf2 : Integrable (fun x => ‖f x‖ ^ 2)) :
    (∑ k ∈ s, ‖cellCoefficient h k f‖ ^ 2) <=
      ∫ x, ‖f x‖ ^ 2 := by
  rw [coefficient_energy_eq_projectFinite hh s f]
  exact projectFinite_L2_contraction hh s f hf hf2

/-- Nonzero normalization witness: a constant field gives coefficient
`sqrt(h^3)` on every cell. -/
theorem cellCoefficient_const_one {h : Real} (hh : 0 < h) (k : Mode3) :
    cellCoefficient h k (fun _ => (1 : Complex)) = Real.sqrt (h ^ 3) := by
  rw [cellCoefficient, cellAverage_const_one hh]
  simp

/-- The constant-cell normalization witness is genuinely nonzero at every
positive mesh size. -/
theorem cellCoefficient_const_one_ne_zero {h : Real} (hh : 0 < h)
    (k : Mode3) :
    cellCoefficient h k (fun _ => (1 : Complex)) ≠ 0 := by
  rw [cellCoefficient_const_one hh]
  exact_mod_cast ne_of_gt (Real.sqrt_pos.2 (pow_pos hh 3))

/-- Wrong-normalization control. At mesh two, the bare cell average has
coefficient energy one, while the constant represented cell has `L2` energy
eight. -/
theorem bare_average_wrong_energy_two (k : Mode3) :
    ‖cellAverage 2 k (fun _ => (1 : Complex))‖ ^ 2 = 1 ∧
      (∫ x, ‖projectFinite 2 {k} (fun _ => (1 : Complex)) x‖ ^ 2) = 8 := by
  constructor
  · rw [cellAverage_const_one (by norm_num : (0 : Real) < 2)]
    norm_num
  · rw [integral_norm_sq_projectFinite_eq_sum
      (by norm_num : (0 : Real) < 2)]
    simp [cellAverage_const_one (by norm_num : (0 : Real) < 2),
      volume_momentumCell_toReal (by norm_num : (0 : Real) < 2)]
    norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge.embedFinite_cellCoefficient' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms embedFinite_cellCoefficient

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge.coefficient_energy_eq_projectFinite' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coefficient_energy_eq_projectFinite

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge.coefficient_energy_le_input' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coefficient_energy_le_input

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge.bare_average_wrong_energy_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bare_average_wrong_energy_two

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge.cellCoefficient_const_one_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cellCoefficient_const_one_ne_zero

end PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge

```

### PhysicsSM/Draft/NullEdge/ChangingCellScaledLiveWalk.lean (270 lines)

```lean
import PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge
import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionStrongScaffold
import PhysicsSM.Draft.NullEdge.ScaledChangingMomentumWalk

/-!
# Scaled live-walk convergence for changing-cell coefficients

This module composes the two previously separate halves of the changing-
lattice momentum program:

1. representative-safe normalized cell coefficients extracted from an actual
   four-component `L2(R^3)` field;
2. the live quartic-step `3+1` split walk evaluated at the physical center of
   every scheduled momentum cell.

The main theorem proves that the live-versus-exact coefficient error, embedded
back into the same normalized momentum cells, converges strongly to zero in
the sum of the four component `L2` norms. The coefficient family is defined
from the input field by `cellCoefficient`; it is not an arbitrary sequence or
an assumed convergent discretization.

Honest scope: the exact comparison flow is the landed momentum-space Dirac
multiplier. This module does not apply a continuum inverse Fourier transform,
identify a position-space PDE solution, or prove Lorentz restoration.

Provenance: clean-room composition of
`ChangingMomentumCellCoefficientBridge`, `ScaledChangingMomentumWalk`, and
Mathlib's Euclidean-spinor norm, July 12, 2026.
-/

noncomputable section

open scoped BigOperators ENNReal Matrix.Norms.L2Operator
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk

open ChangingMomentumCellIsometry
open ChangingMomentumCellCoefficientBridge
open ChangingMomentumCellProjectionStrongScaffold
open ChangingModeEmbedding
open ScaledChangingMomentumWalk
open Compact3Plus1DiracRate

/-- Four-component coefficient space used by the live matrix walk. -/
abbrev Spinor := EuclideanSpace Complex (Fin 4)

/-- Coordinate bridge between the cell code's functional `Z^3` presentation
and the walk code's nested-product presentation. -/
def mode3Equiv : Mode3 ≃ Mode where
  toFun k := ((k 0, k 1), k 2)
  invFun k := ![k.1.1, k.1.2, k.2]
  left_inv k := by
    funext i
    fin_cases i <;> rfl
  right_inv k := rfl

/-- The scheduled functional cube is exactly the walk's nested-product mode
box after the coordinate bridge. -/
theorem mem_scheduledModes_iff_modeBox (N : Nat) (k : Mode3) :
    k ∈ scheduledModes N ↔
      mode3Equiv k ∈ modeBox (physicalCutoff N) := by
  rw [mem_scheduledModes_iff, mem_modeBox_iff]
  constructor
  · intro h
    exact ⟨h 0, h 1, h 2⟩
  · rintro ⟨h0, h1, h2⟩ i
    fin_cases i
    · exact h0
    · exact h1
    · exact h2

/-- The actual normalized spinor coefficient extracted from one momentum
cell, component by component. -/
def spinorCellCoefficient (N : Nat) (F : Momentum3 -> Spinor)
    (k : Mode3) : Spinor :=
  (EuclideanSpace.equiv (Fin 4) Complex).symm
    (fun j => cellCoefficient (physicalSpacing N) k (fun x => F x j))

/-- Euclidean spinor norm squared is the sum of its four coordinate norm
squares. -/
theorem spinor_norm_sq_eq_sum (v : Spinor) :
    ‖v‖ ^ 2 = ∑ j : Fin 4, ‖v j‖ ^ 2 := by
  rw [EuclideanSpace.norm_eq]
  exact Real.sq_sqrt (Finset.sum_nonneg fun _ _ => sq_nonneg _)

/-- The normalized spinor cell coefficient has exactly the sum of the four
scalar coefficient energies. -/
theorem spinorCellCoefficient_norm_sq (N : Nat)
    (F : Momentum3 -> Spinor) (k : Mode3) :
    ‖spinorCellCoefficient N F k‖ ^ 2 =
      ∑ j : Fin 4,
        ‖cellCoefficient (physicalSpacing N) k (fun x => F x j)‖ ^ 2 := by
  rw [spinor_norm_sq_eq_sum]
  rfl

/-- The scheduled spinor coefficients inherit the sum of the four scalar
`L2` energy bounds. -/
theorem spinorCellCoefficient_energy_le
    (N : Nat) (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    (∑ k ∈ scheduledModes N, ‖spinorCellCoefficient N F k‖ ^ 2) <=
      ∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2 := by
  calc
    (∑ k ∈ scheduledModes N, ‖spinorCellCoefficient N F k‖ ^ 2) =
        ∑ k ∈ scheduledModes N, ∑ j : Fin 4,
          ‖cellCoefficient (physicalSpacing N) k (fun x => F x j)‖ ^ 2 := by
      apply Finset.sum_congr rfl
      intro k hk
      exact spinorCellCoefficient_norm_sq N F k
    _ = ∑ j : Fin 4, ∑ k ∈ scheduledModes N,
          ‖cellCoefficient (physicalSpacing N) k (fun x => F x j)‖ ^ 2 := by
      rw [Finset.sum_comm]
    _ <= ∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2 := by
      apply Finset.sum_le_sum
      intro j hj
      exact coefficient_energy_le_input (physicalSpacing_pos N)
        (scheduledModes N) (fun x => F x j)
        (fun k hk => memLp_two_integrableOn_momentumCell
          (hF j) (physicalSpacing N) k)
        (memLp_two_integrable_norm_sq (hF j))

/-- The explicit common operator-error rate for the scaled scheduled box. -/
def scaledCellRate (t : Real) (M N : Nat) : Real :=
  2 * t ^ 2 / (scaledWindow M N : Real) ^ 2 *
    Real.exp (|t| / (scaledWindow M N : Real) ^ 3)

theorem scaledCellRate_nonneg (t : Real) (M N : Nat) :
    0 <= scaledCellRate t M N := by
  unfold scaledCellRate
  positivity

theorem scaledCellRate_tendsto_zero (t : Real) (M : Nat) :
    Tendsto (fun N => scaledCellRate t M N) atTop (nhds 0) := by
  simpa [scaledCellRate] using scaled_box_rate_tendsto_zero t M

/-- Live split-versus-exact error for the coefficient extracted from one
scheduled cell. -/
def scaledCellModeError (m t : Real) (M N : Nat)
    (F : Momentum3 -> Spinor) (k : Mode3) : Spinor :=
  let q := mode3Equiv k
  let A :=
    (splitStep (scaledMomentum N q 0) (scaledMomentum N q 1)
      (scaledMomentum N q 2) m
      (t / (scaledSteps M N : Real))) ^ scaledSteps M N
  let B := exactFlow (scaledMomentum N q 0) (scaledMomentum N q 1)
    (scaledMomentum N q 2) m t
  (EuclideanSpace.equiv (Fin 4) Complex).symm
    ((A - B).mulVec (spinorCellCoefficient N F k))

/-- Each actual cell-derived coefficient error obeys the common scaled-box
operator rate. -/
theorem scaledCellModeError_norm_le
    (m t : Real) (M N : Nat) (hm : |m| <= (M : Real))
    (F : Momentum3 -> Spinor) (k : Mode3) (hk : k ∈ scheduledModes N) :
    ‖scaledCellModeError m t M N F k‖ <=
      scaledCellRate t M N * ‖spinorCellCoefficient N F k‖ := by
  have hbox : mode3Equiv k ∈ modeBox (physicalCutoff N) :=
    (mem_scheduledModes_iff_modeBox N k).1 hk
  have hmatrix := scaled_box_many_step_bound m t M N hm (mode3Equiv k) hbox
  have hop := Matrix.l2_opNorm_mulVec
    ((splitStep
      (scaledMomentum N (mode3Equiv k) 0)
      (scaledMomentum N (mode3Equiv k) 1)
      (scaledMomentum N (mode3Equiv k) 2) m
      (t / (scaledSteps M N : Real))) ^ scaledSteps M N -
      exactFlow
        (scaledMomentum N (mode3Equiv k) 0)
        (scaledMomentum N (mode3Equiv k) 1)
        (scaledMomentum N (mode3Equiv k) 2) m t)
    (spinorCellCoefficient N F k)
  exact le_trans (by simpa [scaledCellModeError] using hop)
    (mul_le_mul_of_nonneg_right hmatrix (norm_nonneg _))

/-- The total scheduled coefficient error is bounded by the common live rate
times the actual field-derived coefficient energy. -/
theorem scaledCellModeError_energy_le
    (m t : Real) (M N : Nat) (hm : |m| <= (M : Real))
    (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    (∑ k ∈ scheduledModes N, ‖scaledCellModeError m t M N F k‖ ^ 2) <=
      (scaledCellRate t M N) ^ 2 *
        (∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2) := by
  calc
    (∑ k ∈ scheduledModes N, ‖scaledCellModeError m t M N F k‖ ^ 2) <=
        ∑ k ∈ scheduledModes N,
          (scaledCellRate t M N * ‖spinorCellCoefficient N F k‖) ^ 2 := by
      apply Finset.sum_le_sum
      intro k hk
      exact pow_le_pow_left₀ (norm_nonneg _)
        (scaledCellModeError_norm_le m t M N hm F k hk) 2
    _ = (scaledCellRate t M N) ^ 2 *
        (∑ k ∈ scheduledModes N, ‖spinorCellCoefficient N F k‖ ^ 2) := by
      simp_rw [mul_pow, Finset.mul_sum]
    _ <= (scaledCellRate t M N) ^ 2 *
        (∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2) := by
      exact mul_le_mul_of_nonneg_left
        (spinorCellCoefficient_energy_le N F hF) (sq_nonneg _)

/-- The actual scaled live-walk coefficient error tends strongly to zero for
the normalized coefficients extracted from every four-coordinate `L2` field. -/
theorem scaledCellModeError_tendsto_zero
    (m t : Real) (M : Nat) (hm : |m| <= (M : Real))
    (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    Tendsto
      (fun N => ∑ k ∈ scheduledModes N,
        ‖scaledCellModeError m t M N F k‖ ^ 2)
      atTop (nhds 0) := by
  let C : Real := ∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2
  refine squeeze_zero
    (fun N => Finset.sum_nonneg fun _ _ => sq_nonneg _)
    (fun N => scaledCellModeError_energy_le m t M N hm F hF) ?_
  have hr := (scaledCellRate_tendsto_zero t M).pow 2
  simpa [C] using hr.mul_const C

/-- Re-embed one scalar coordinate of the live coefficient error into the
same normalized momentum cells used by the input projection. -/
def embeddedErrorComponent (m t : Real) (M N : Nat)
    (F : Momentum3 -> Spinor) (j : Fin 4) : Momentum3 -> Complex :=
  embedFinite (physicalSpacing N) (scheduledModes N)
    (fun k => scaledCellModeError m t M N F k j)

/-- Componentwise cell isometry identifies the embedded error energy with
the spinor coefficient error exactly. -/
theorem embeddedError_energy_eq
    (m t : Real) (M N : Nat) (F : Momentum3 -> Spinor) :
    (∑ j : Fin 4, ∫ x, ‖embeddedErrorComponent m t M N F j x‖ ^ 2) =
      ∑ k ∈ scheduledModes N, ‖scaledCellModeError m t M N F k‖ ^ 2 := by
  simp_rw [embeddedErrorComponent,
    embedFinite_isometry (physicalSpacing_pos N)]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro k hk
  exact (spinor_norm_sq_eq_sum (scaledCellModeError m t M N F k)).symm

/-- **Changing-cell live-walk composition.** The actual cell-derived live
error, embedded in the refining momentum cells, converges strongly to zero. -/
theorem embeddedScaledLiveError_tendsto_zero
    (m t : Real) (M : Nat) (hm : |m| <= (M : Real))
    (F : Momentum3 -> Spinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    Tendsto
      (fun N => ∑ j : Fin 4,
        ∫ x, ‖embeddedErrorComponent m t M N F j x‖ ^ 2)
      atTop (nhds 0) := by
  apply (scaledCellModeError_tendsto_zero m t M hm F hF).congr'
  exact Filter.Eventually.of_forall fun N =>
    (embeddedError_energy_eq m t M N F).symm

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk.mem_scheduledModes_iff_modeBox' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mem_scheduledModes_iff_modeBox

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk.spinorCellCoefficient_energy_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms spinorCellCoefficient_energy_le

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk.scaledCellModeError_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms scaledCellModeError_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk.embeddedScaledLiveError_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms embeddedScaledLiveError_tendsto_zero

end PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk

```

## Final instruction

Produce your review now, strictly in the Required output format specified above.
```

## Response stdout

```text
Credit balance is too low

```

## Response stderr

```text

```
