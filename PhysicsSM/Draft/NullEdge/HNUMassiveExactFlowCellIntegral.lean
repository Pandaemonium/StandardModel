import PhysicsSM.Draft.NullEdge.HNUMassiveChangingCellProjectionL2
import PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowMomentumLipschitz
import PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge

/-!
# Actual intra-cell exact massive HNU Dirac-flow integral

This module controls the second term in the HNU changing-cell continuum
decomposition: the difference between the continuously varying exact massive Dirac
multiplier and its value at the center of each physical momentum cell.

The field on every cell uses the actual normalized coefficient extracted from
the supplied four-component `L2(R^3)` field and the reciprocal-square-root cell
normalization. The complete integrated error is bounded by

```text
(3 * |t| * h_N / 2)^2 * input energy
```

and therefore tends to zero on the explicit refining schedule. This is not a
finite sample and does not assume integrability of the multiplier error.

The theorem remains one term of the final three-term continuum capstone. It
does not compare the live HNU update with the center flow or identify the
position-space massive Dirac generator.

Provenance: clean-room four-component specialization of the repository's
`ExactFlowCellIntegral` proof architecture, using the HNU-specific
`massiveEflow_cellCenter_norm_le`, July 20, 2026. Claim grade `M`, `[comp]`.
-/

noncomputable section

open scoped BigOperators ENNReal Matrix.Norms.L2Operator
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowCellIntegral

open ChangingMomentumCellIsometry
open ChangingMomentumCellSampling
open ChangingMomentumCellProjectionStrongScaffold
open ChangingMomentumCellCoefficientBridge
open ScaledChangingMomentumWalk
open HNUManyStepContinuum
open HNUPlueckerMassiveStay
open HNUMassiveContinuumReduction
open HNUMassiveExactFlowMomentumLipschitz
open HNUMassiveChangingCellProjectionL2

/-- The normalized four-component coefficient extracted from one physical
momentum cell. -/
def diracCellCoefficient (N : Nat) (F : Momentum3 -> DiracSpinor)
    (k : Mode3) : DiracSpinor :=
  (EuclideanSpace.equiv (Fin 4) Complex).symm
    (fun j => cellCoefficient (physicalSpacing N) k (fun x => F x j))

/-- The coefficient norm is exactly the sum of its four scalar energies. -/
theorem diracCellCoefficient_norm_sq (N : Nat)
    (F : Momentum3 -> DiracSpinor) (k : Mode3) :
    ‖diracCellCoefficient N F k‖ ^ 2 =
      ∑ j : Fin 4,
        ‖cellCoefficient (physicalSpacing N) k (fun x => F x j)‖ ^ 2 := by
  rw [diracSpinor_norm_sq_eq_sum]
  rfl

/-- The scheduled four-component coefficients inherit the scalar projection
energy contraction. -/
theorem diracCellCoefficient_energy_le (N : Nat)
    (F : Momentum3 -> DiracSpinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    (∑ k ∈ scheduledModes N, ‖diracCellCoefficient N F k‖ ^ 2) <=
      ∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2 := by
  calc
    (∑ k ∈ scheduledModes N, ‖diracCellCoefficient N F k‖ ^ 2) =
        ∑ k ∈ scheduledModes N, ∑ j : Fin 4,
          ‖cellCoefficient (physicalSpacing N) k (fun x => F x j)‖ ^ 2 := by
      apply Finset.sum_congr rfl
      intro k hk
      exact diracCellCoefficient_norm_sq N F k
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

/-- Uniform exact-flow variation rate inside one physical cell. -/
def exactCellRate (t : Real) (N : Nat) : Real :=
  |t| * (3 * physicalSpacing N / 2)

theorem exactCellRate_nonneg (t : Real) (N : Nat) :
    0 <= exactCellRate t N := by
  unfold exactCellRate
  exact mul_nonneg (abs_nonneg t)
    (div_nonneg (mul_nonneg (by norm_num) (physicalSpacing_pos N).le)
      (by norm_num))

theorem exactCellRate_tendsto_zero (t : Real) :
    Tendsto (exactCellRate t) atTop (nhds 0) := by
  have h := physicalSpacing_tendsto_zero.const_mul (|t| * (3 / 2 : Real))
  convert h using 1
  · funext N
    simp [exactCellRate]
    ring
  · ring

/-- The unscaled exact-flow variation at a point of one cell, applied to the
actual field-derived coefficient. -/
def exactCellError (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) (k : Mode3) (x : Momentum3) :
    DiracSpinor :=
  (EuclideanSpace.equiv (Fin 4) Complex).symm
    ((massiveEflow z x t -
        massiveEflow z (cellCenter (physicalSpacing N) k) t).mulVec
      (diracCellCoefficient N F k))

/-- Uniform unscaled one-cell error bound. -/
theorem exactCellError_norm_le (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) (k : Mode3) {x : Momentum3}
    (hx : x ∈ momentumCell (physicalSpacing N) k) :
    ‖exactCellError z t N F k x‖ <=
      exactCellRate t N * ‖diracCellCoefficient N F k‖ := by
  have hop := Matrix.l2_opNorm_mulVec
    (massiveEflow z x t -
      massiveEflow z (cellCenter (physicalSpacing N) k) t)
    (diracCellCoefficient N F k)
  exact le_trans (by simpa [exactCellError] using hop)
    (mul_le_mul_of_nonneg_right
      (by
        simpa [exactCellRate] using massiveEflow_cellCenter_norm_le z hx t)
      (norm_nonneg _))

/-- Exact multiplier variation at a physical point, embedded with the
reciprocal-square-root cell normalization. -/
def exactCellVariationAt (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) (k : Mode3) (x : Momentum3) :
    DiracSpinor :=
  (cellScale (physicalSpacing N) : Complex) • exactCellError z t N F k x

/-- Continuity of one cell's untruncated multiplier error. -/
theorem exactCellVariationAt_continuous (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) (k : Mode3) :
    Continuous (exactCellVariationAt z t N F k) := by
  letI : NormedAlgebra Rat HNUMassiveContinuumReduction.Mat4 :=
    NormedAlgebra.restrictScalars Rat Complex HNUMassiveContinuumReduction.Mat4
  unfold exactCellVariationAt exactCellError massiveEflow massiveGenerator kinetic4
  apply continuous_const.smul
  apply (EuclideanSpace.equiv (Fin 4) Complex).symm.continuous.comp
  fun_prop

/-- The reciprocal-square-root cell scale is nonnegative. -/
theorem cellScale_nonneg (N : Nat) : 0 <= cellScale (physicalSpacing N) := by
  unfold cellScale
  positivity

/-- Exact cancellation of cell volume against the square of the embedding
scale. -/
theorem physicalSpacing_pow_mul_cellScale_sq (N : Nat) :
    (physicalSpacing N) ^ 3 * (cellScale (physicalSpacing N)) ^ 2 = 1 := by
  have hh : 0 < (physicalSpacing N) ^ 3 :=
    pow_pos (physicalSpacing_pos N) 3
  unfold cellScale
  rw [inv_pow, Real.sq_sqrt hh.le, mul_inv_cancel₀ (ne_of_gt hh)]

/-- Pointwise scaled cell norm bound. -/
theorem exactCellVariationAt_norm_le (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) (k : Mode3) {x : Momentum3}
    (hx : x ∈ momentumCell (physicalSpacing N) k) :
    ‖exactCellVariationAt z t N F k x‖ <=
      cellScale (physicalSpacing N) *
        (exactCellRate t N * ‖diracCellCoefficient N F k‖) := by
  rw [exactCellVariationAt, norm_smul,
    show ‖(cellScale (physicalSpacing N) : Complex)‖ =
        cellScale (physicalSpacing N) from by
      rw [Complex.norm_real]
      exact abs_of_nonneg (cellScale_nonneg N)]
  exact mul_le_mul_of_nonneg_left
    (exactCellError_norm_le z t N F k hx) (cellScale_nonneg N)

/-- Squared pointwise cell norm bound. -/
theorem exactCellVariationAt_norm_sq_le (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) (k : Mode3) {x : Momentum3}
    (hx : x ∈ momentumCell (physicalSpacing N) k) :
    ‖exactCellVariationAt z t N F k x‖ ^ 2 <=
      (cellScale (physicalSpacing N)) ^ 2 *
        (exactCellRate t N * ‖diracCellCoefficient N F k‖) ^ 2 := by
  rw [← mul_pow]
  exact pow_le_pow_left₀ (norm_nonneg _)
    (exactCellVariationAt_norm_le z t N F k hx) 2

/-- The squared variation is integrable on its finite cell. -/
theorem exactCellVariationAt_integrableOn (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) (k : Mode3) :
    IntegrableOn (fun x => ‖exactCellVariationAt z t N F k x‖ ^ 2)
      (momentumCell (physicalSpacing N) k) := by
  refine Measure.integrableOn_of_bounded
    (volume_momentumCell_ne_top _ _)
    (((exactCellVariationAt_continuous z t N F k).norm.pow 2).aestronglyMeasurable)
    (M := (cellScale (physicalSpacing N)) ^ 2 *
      (exactCellRate t N * ‖diracCellCoefficient N F k‖) ^ 2) ?_
  filter_upwards [ae_restrict_mem (momentumCell_measurable _ _)] with x hx
  rw [Real.norm_of_nonneg (by positivity)]
  exact exactCellVariationAt_norm_sq_le z t N F k hx

/-- One-cell integral bound after exact normalization cancellation. -/
theorem exactCellVariationAt_setIntegral_le (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) (k : Mode3) :
    (∫ x in momentumCell (physicalSpacing N) k,
        ‖exactCellVariationAt z t N F k x‖ ^ 2) <=
      (exactCellRate t N) ^ 2 * ‖diracCellCoefficient N F k‖ ^ 2 := by
  calc
    (∫ x in momentumCell (physicalSpacing N) k,
        ‖exactCellVariationAt z t N F k x‖ ^ 2) <=
        ∫ _x in momentumCell (physicalSpacing N) k,
          (cellScale (physicalSpacing N)) ^ 2 *
            (exactCellRate t N * ‖diracCellCoefficient N F k‖) ^ 2 := by
      refine setIntegral_mono_on
        (exactCellVariationAt_integrableOn z t N F k)
        (integrableOn_const (volume_momentumCell_ne_top _ _))
        (momentumCell_measurable _ _) ?_
      intro x hx
      exact exactCellVariationAt_norm_sq_le z t N F k hx
    _ = (exactCellRate t N) ^ 2 *
        ‖diracCellCoefficient N F k‖ ^ 2 := by
      rw [setIntegral_const, measureReal_def,
        volume_momentumCell_toReal (physicalSpacing_pos N), smul_eq_mul,
        mul_pow, ← mul_assoc, physicalSpacing_pow_mul_cellScale_sq N,
        one_mul]

/-- Piecewise exact-flow variation field over all scheduled cells. -/
def exactCellVariationField (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) : Momentum3 -> DiracSpinor := fun x =>
  ∑ k ∈ scheduledModes N,
    (momentumCell (physicalSpacing N) k).indicator
      (fun x => exactCellVariationAt z t N F k x) x

/-- On a scheduled cell, the piecewise field agrees with that cell's
variation. -/
theorem exactCellVariationField_eq_on_cell (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) {k : Mode3} {x : Momentum3}
    (hk : k ∈ scheduledModes N)
    (hx : x ∈ momentumCell (physicalSpacing N) k) :
    exactCellVariationField z t N F x = exactCellVariationAt z t N F k x := by
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

/-- The squared piecewise field is integrable on each scheduled cell. -/
theorem exactCellVariationField_integrableOn (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) {k : Mode3}
    (hk : k ∈ scheduledModes N) :
    IntegrableOn (fun x => ‖exactCellVariationField z t N F x‖ ^ 2)
      (momentumCell (physicalSpacing N) k) := by
  refine (exactCellVariationAt_integrableOn z t N F k).congr_fun ?_
    (momentumCell_measurable _ _)
  intro x hx
  dsimp only
  rw [exactCellVariationField_eq_on_cell z t N F hk hx]

/-- Exact disjoint-cell decomposition of the global variation energy. -/
theorem exactCellVariationField_energy_eq (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) :
    (∫ x, ‖exactCellVariationField z t N F x‖ ^ 2) =
      ∑ k ∈ scheduledModes N,
        ∫ x in momentumCell (physicalSpacing N) k,
          ‖exactCellVariationAt z t N F k x‖ ^ 2 := by
  have hunion :
      (∫ x, ‖exactCellVariationField z t N F x‖ ^ 2) =
        ∫ x in ⋃ k ∈ scheduledModes N,
            momentumCell (physicalSpacing N) k,
          ‖exactCellVariationField z t N F x‖ ^ 2 := by
    rw [setIntegral_eq_integral_of_forall_compl_eq_zero]
    intro x hx
    have hzero : exactCellVariationField z t N F x = 0 := by
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
    rw [exactCellVariationField_eq_on_cell z t N F hk hx]
  · exact fun k hk => momentumCell_measurable _ _
  · exact fun x hx y hy hxy =>
      momentumCell_disjoint (physicalSpacing_pos N) hxy
  · exact fun k hk => exactCellVariationField_integrableOn z t N F hk

/-- The full intra-cell HNU exact-flow variation is bounded by the squared
cell rate times the actual input-field energy. -/
theorem exactCellVariationField_energy_le (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    (∫ x, ‖exactCellVariationField z t N F x‖ ^ 2) <=
      (exactCellRate t N) ^ 2 *
        (∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2) := by
  rw [exactCellVariationField_energy_eq]
  calc
    (∑ k ∈ scheduledModes N,
        ∫ x in momentumCell (physicalSpacing N) k,
          ‖exactCellVariationAt z t N F k x‖ ^ 2) <=
        ∑ k ∈ scheduledModes N,
          (exactCellRate t N) ^ 2 * ‖diracCellCoefficient N F k‖ ^ 2 := by
      exact Finset.sum_le_sum fun k hk =>
        exactCellVariationAt_setIntegral_le z t N F k
    _ = (exactCellRate t N) ^ 2 *
        (∑ k ∈ scheduledModes N, ‖diracCellCoefficient N F k‖ ^ 2) := by
      rw [Finset.mul_sum]
    _ <= (exactCellRate t N) ^ 2 *
        (∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2) := by
      exact mul_le_mul_of_nonneg_left
        (diracCellCoefficient_energy_le N F hF) (sq_nonneg _)

/-- The finite piecewise exact-flow variation field is almost everywhere
strongly measurable. -/
theorem exactCellVariationField_aestronglyMeasurable (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) :
    AEStronglyMeasurable (exactCellVariationField z t N F) volume := by
  unfold exactCellVariationField
  have h : AEStronglyMeasurable
      (∑ k ∈ scheduledModes N,
        (momentumCell (physicalSpacing N) k).indicator
          (fun x => exactCellVariationAt z t N F k x)) volume := by
    apply Finset.aestronglyMeasurable_sum _
    intro k hk
    exact
      (exactCellVariationAt_continuous z t N F k).aestronglyMeasurable.indicator
        (momentumCell_measurable _ _)
  refine h.congr ?_
  exact Filter.Eventually.of_forall fun x => by simp

/-- The representative-level squared norm of the global variation field is
integrable. -/
theorem exactCellVariationField_sq_integrable (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) :
    Integrable (fun x => ‖exactCellVariationField z t N F x‖ ^ 2) volume := by
  have hunion :
      IntegrableOn (fun x => ‖exactCellVariationField z t N F x‖ ^ 2)
        (⋃ k ∈ scheduledModes N, momentumCell (physicalSpacing N) k) volume := by
    rw [integrableOn_finset_iUnion]
    exact fun k hk => exactCellVariationField_integrableOn z t N F hk
  refine hunion.integrable_of_forall_notMem_eq_zero ?_
  intro x hx
  have hzero : exactCellVariationField z t N F x = 0 := by
    unfold exactCellVariationField
    refine Finset.sum_eq_zero ?_
    intro k hk
    rw [Set.indicator_of_notMem]
    exact fun hxk => hx (Set.mem_biUnion hk hxk)
  simp [hzero]

/-- The global variation field is an actual momentum-space `L2` element. -/
theorem exactCellVariationField_memLp (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) :
    MemLp (exactCellVariationField z t N F) 2 volume := by
  rw [memLp_two_iff_integrable_sq_norm
    (exactCellVariationField_aestronglyMeasurable z t N F)]
  exact exactCellVariationField_sq_integrable z t N F

/-- Bundle the actual intra-cell exact-flow variation in momentum-space
`L2`. -/
def exactCellVariationLp (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) :
    Lp DiracSpinor 2 (volume : Measure Momentum3) :=
  (exactCellVariationField_memLp z t N F).toLp
    (exactCellVariationField z t N F)

/-- The quotient-space norm squared is the integrated variation energy. -/
theorem exactCellVariationLp_norm_sq_eq (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) :
    ‖exactCellVariationLp z t N F‖ ^ 2 =
      ∫ x, ‖exactCellVariationField z t N F x‖ ^ 2 := by
  let hf := exactCellVariationField_memLp z t N F
  rw [show exactCellVariationLp z t N F =
      hf.toLp (exactCellVariationField z t N F) by rfl]
  rw [Lp.norm_toLp]
  rw [hf.eLpNorm_eq_integral_rpow_norm (by norm_num) (by norm_num)]
  simp only [ENNReal.toReal_ofNat]
  have henergy : 0 <= ∫ x, ‖exactCellVariationField z t N F x‖ ^ 2 :=
    integral_nonneg fun x => sq_nonneg _
  rw [ENNReal.toReal_ofReal']
  rw [max_eq_left (by positivity)]
  have hrpow_energy :
      (∫ x, ‖exactCellVariationField z t N F x‖ ^ (2 : Real)) =
        ∫ x, ‖exactCellVariationField z t N F x‖ ^ (2 : Nat) := by
    apply integral_congr_ae
    exact Filter.Eventually.of_forall fun x => Real.rpow_two _
  rw [hrpow_energy]
  exact Real.rpow_inv_natCast_pow (n := 2)
    henergy (by norm_num)

/-- Strong convergence of the genuine momentum-space `L2` variation
element. -/
theorem exactCellVariationLp_norm_tendsto_zero (z : Complex) (t : Real)
    (F : Momentum3 -> DiracSpinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    Tendsto (fun N => ‖exactCellVariationLp z t N F‖) atTop (nhds 0) := by
  have hsq : Tendsto (fun N => ‖exactCellVariationLp z t N F‖ ^ 2)
      atTop (nhds 0) := by
    refine squeeze_zero
      (g := fun N => (exactCellRate t N) ^ 2 *
        (∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2))
      (fun N => sq_nonneg ‖exactCellVariationLp z t N F‖)
      (fun N => ?_) ?_
    · rw [exactCellVariationLp_norm_sq_eq]
      exact exactCellVariationField_energy_le z t N F hF
    · have hr := (exactCellRate_tendsto_zero t).pow 2
      simpa using hr.mul_const (∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2)
  have hsqrt := hsq.sqrt
  simpa [Real.sqrt_sq_eq_abs, abs_of_nonneg] using hsqrt

/-- Move the variation error to Euclidean momentum coordinates with the
explicit volume-preserving identity map. -/
def euclideanExactCellVariationLp (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) :
    Lp DiracSpinor 2 (volume : Measure FourierMomentum3) :=
  MeasureTheory.Lp.compMeasurePreserving
    (fun x : FourierMomentum3 => WithLp.ofLp x)
    (PiLp.volume_preserving_ofLp (ι := Fin 3))
    (exactCellVariationLp z t N F)

/-- The coordinate-domain bridge preserves the variation-error norm. -/
theorem euclideanExactCellVariationLp_norm_eq (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) :
    ‖euclideanExactCellVariationLp z t N F‖ =
      ‖exactCellVariationLp z t N F‖ := by
  exact Lp.norm_compMeasurePreserving _ _

/-- Reconstruct the exact-flow cell-variation error in position space by the
vector-valued inverse Fourier isometry. -/
def positionExactCellVariationLp (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) :
    Lp DiracSpinor 2 (volume : Measure FourierMomentum3) :=
  (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 DiracSpinor).symm
    (euclideanExactCellVariationLp z t N F)

/-- Plancherel preserves the exact-flow cell-variation norm. -/
theorem positionExactCellVariationLp_norm_eq (z : Complex) (t : Real) (N : Nat)
    (F : Momentum3 -> DiracSpinor) :
    ‖positionExactCellVariationLp z t N F‖ =
      ‖euclideanExactCellVariationLp z t N F‖ := by
  exact
    (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 DiracSpinor).symm.norm_map
      (euclideanExactCellVariationLp z t N F)

/-- **Intra-cell position-space capstone.** The inverse-Fourier reconstructed
exact massive HNU flow variation tends strongly to zero in `L2`. -/
theorem positionExactCellVariationLp_norm_tendsto_zero (z : Complex) (t : Real)
    (F : Momentum3 -> DiracSpinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    Tendsto (fun N => ‖positionExactCellVariationLp z t N F‖)
      atTop (nhds 0) := by
  apply (exactCellVariationLp_norm_tendsto_zero z t F hF).congr'
  exact Filter.Eventually.of_forall fun N =>
    ((positionExactCellVariationLp_norm_eq z t N F).trans
      (euclideanExactCellVariationLp_norm_eq z t N F)).symm

/-- **Actual intra-cell HNU exact-flow convergence.** The complete integrated
variation between the exact massive Dirac multiplier and its cell-center value tends
to zero for every componentwise `L2` Dirac field. -/
theorem exactCellVariationField_tendsto_zero (z : Complex) (t : Real)
    (F : Momentum3 -> DiracSpinor)
    (hF : ∀ j : Fin 4, MemLp (fun x => F x j) 2 volume) :
    Tendsto
      (fun N => ∫ x, ‖exactCellVariationField z t N F x‖ ^ 2)
      atTop (nhds 0) := by
  refine squeeze_zero
    (fun N => integral_nonneg fun x => sq_nonneg _)
    (fun N => exactCellVariationField_energy_le z t N F hF) ?_
  have hr := (exactCellRate_tendsto_zero t).pow 2
  simpa using hr.mul_const (∑ j : Fin 4, ∫ x, ‖F x j‖ ^ 2)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowCellIntegral.diracCellCoefficient_energy_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms diracCellCoefficient_energy_le

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowCellIntegral.exactCellVariationField_energy_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactCellVariationField_energy_eq

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowCellIntegral.exactCellVariationField_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactCellVariationField_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowCellIntegral.positionExactCellVariationLp_norm_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positionExactCellVariationLp_norm_tendsto_zero

end PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowCellIntegral
