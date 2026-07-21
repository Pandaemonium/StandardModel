import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjection
import Mathlib

/-!
# `L2` contraction of the finite cell-average projection

The normalized finite cell-average projection satisfies the cellwise
Cauchy/Jensen energy estimate and is a global `L2` contraction. Exact energy
identities over finite disjoint cell families connect the local estimate to the
global result. The point-spike control projects to zero, while a constant-one
field supplies a nonzero witness.

Provenance: theorem statements prepared in the changing-lattice continuum
lane. Proofs returned without statement changes or added integrability
hypotheses by Aristotle project `9ffa5c89-bca2-405d-8398-caf2034f4d99`, task
`6e4d7306-407c-4aea-a9ad-83dad0eb8476`, then independently rebuilt under the
repository's pinned Lean 4.28.0 toolchain.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionL2

open ChangingMomentumCellIsometry
open ChangingMomentumPointSamplerNoGo
open ChangingMomentumCellProjection
open ChangingMomentumCellSampling

/-
Cellwise Cauchy inequality for the normalized complex average.
-/
theorem cellAverage_energy_le {h : Real} (hh : 0 < h) (k : Mode3)
    (f : Momentum3 → Complex)
    (hf : IntegrableOn f (momentumCell h k))
    (hf2 : IntegrableOn (fun x => ‖f x‖ ^ 2) (momentumCell h k)) :
    (volume (momentumCell h k)).toReal * ‖cellAverage h k f‖ ^ 2 ≤
      ∫ x in momentumCell h k, ‖f x‖ ^ 2 := by
  -- By definition of cellAverage, we have:
  have h_cellAverage : ‖cellAverage h k f‖ ≤ (1 / (volume (momentumCell h k)).toReal) * ∫ x in momentumCell h k, ‖f x‖ := by
    unfold cellAverage;
    simpa [ norm_smul, abs_of_nonneg ( ENNReal.toReal_nonneg ) ] using mul_le_mul_of_nonneg_left ( MeasureTheory.norm_integral_le_integral_norm f ) ( by positivity );
  -- By Cauchy-Schwarz inequality, we have:
  have h_cauchy_schwarz : (∫ x in momentumCell h k, ‖f x‖) ^ 2 ≤ (∫ x in momentumCell h k, ‖f x‖ ^ 2) * (volume (momentumCell h k)).toReal := by
    have h_cauchy_schwarz : (∫ x in momentumCell h k, (‖f x‖ - (∫ x in momentumCell h k, ‖f x‖) / (volume (momentumCell h k)).toReal) ^ 2) ≥ 0 := by
      exact MeasureTheory.integral_nonneg fun x => sq_nonneg _;
    simp_all +decide [ sub_sq, mul_assoc ];
    rw [ MeasureTheory.integral_add, MeasureTheory.integral_sub ] at h_cauchy_schwarz;
    · by_cases h : ( volume ( momentumCell h k ) |> ENNReal.toReal ) = 0 <;> simp_all +decide [ MeasureTheory.integral_const_mul, MeasureTheory.integral_mul_const ];
      · exact absurd h ( by rw [ volume_momentumCell_toReal hh k ] ; positivity );
      · nlinarith! [ mul_div_cancel₀ ( ∫ x in momentumCell ‹_› k, ‖f x‖ ) h, show 0 < ( volume ( momentumCell ‹_› k ) |> ENNReal.toReal ) from lt_of_le_of_ne ( ENNReal.toReal_nonneg ) ( Ne.symm h ) ];
    · exact hf2;
    · exact MeasureTheory.Integrable.const_mul ( hf.norm.mul_const _ ) _;
    · refine' MeasureTheory.Integrable.sub hf2 _;
      exact MeasureTheory.Integrable.const_mul ( MeasureTheory.Integrable.mul_const ( hf.norm ) _ ) _;
    · apply_rules [ MeasureTheory.integrable_const ];
      constructor ; norm_num [ volume_momentumCell_ne_top ];
      exact lt_top_iff_ne_top.mpr ( volume_momentumCell_ne_top h k );
  refine' le_trans ( mul_le_mul_of_nonneg_left ( pow_le_pow_left₀ ( norm_nonneg _ ) h_cellAverage 2 ) ( ENNReal.toReal_nonneg ) ) _;
  field_simp;
  exact div_le_of_le_mul₀ ( ENNReal.toReal_nonneg ) ( MeasureTheory.integral_nonneg fun _ => sq_nonneg _ ) h_cauchy_schwarz

/-
Exact energy of the finite piecewise-constant average projection.
-/
theorem integral_norm_sq_projectFinite_eq_sum {h : Real} (hh : 0 < h)
    (s : Finset Mode3) (f : Momentum3 → Complex) :
    ∫ x, ‖projectFinite h s f x‖ ^ 2 =
      ∑ k ∈ s,
        (volume (momentumCell h k)).toReal * ‖cellAverage h k f‖ ^ 2 := by
  -- Let's simplify the integral using the definition of `projectFinite`.
  have h_integral : ∫ x, ‖projectFinite h s f x‖ ^ 2 = ∫ x in ⋃ k ∈ s, momentumCell h k, ‖projectFinite h s f x‖ ^ 2 := by
    rw [ MeasureTheory.setIntegral_eq_integral_of_forall_compl_eq_zero ];
    unfold projectFinite; aesop;
  have h_integral : ∫ x in ⋃ k ∈ s, momentumCell h k, ‖projectFinite h s f x‖ ^ 2 = ∑ k ∈ s, ∫ x in momentumCell h k, ‖cellAverage h k f‖ ^ 2 := by
    rw [ MeasureTheory.integral_biUnion_finset ];
    · refine' Finset.sum_congr rfl fun k hk => MeasureTheory.setIntegral_congr_fun ( momentumCell_measurable h k ) fun x hx => _;
      rw [ projectFinite_eq_average hh s f hk hx ];
    · exact fun k hk => momentumCell_measurable h k;
    · exact fun x hx y hy hxy => momentumCell_disjoint hh hxy;
    · intro k hk
      have h_integrable : IntegrableOn (fun x => ‖cellAverage h k f‖ ^ 2) (momentumCell h k) := by
        simp +zetaDelta at *;
        exact Or.inr ( lt_top_iff_ne_top.mpr ( volume_momentumCell_ne_top h k ) );
      refine' h_integrable.congr _;
      filter_upwards [ MeasureTheory.ae_restrict_mem ( momentumCell_measurable h k ) ] with x hx using by rw [ projectFinite_eq_average hh s f hk hx ] ;
  simp_all +decide [ MeasureTheory.measureReal_def ]

/-
Disjoint selected cells decompose the input energy exactly.
-/
theorem sum_setIntegral_norm_sq_eq_cellUnion {h : Real} (hh : 0 < h)
    (s : Finset Mode3) (f : Momentum3 → Complex)
    (hf2 : Integrable (fun x => ‖f x‖ ^ 2)) :
    (∑ k ∈ s, ∫ x in momentumCell h k, ‖f x‖ ^ 2) =
      ∫ x in cellUnion h s, ‖f x‖ ^ 2 := by
  rw [ cellUnion, MeasureTheory.integral_biUnion_finset ];
  · exact fun k hk => momentumCell_measurable h k;
  · exact fun x hx y hy hxy => momentumCell_disjoint hh hxy;
  · exact fun k hk => hf2.integrableOn

/-
The normalized finite cell-average projection is an `L2` contraction.
-/
theorem projectFinite_L2_contraction {h : Real} (hh : 0 < h)
    (s : Finset Mode3) (f : Momentum3 → Complex)
    (hf : ∀ k ∈ s, IntegrableOn f (momentumCell h k))
    (hf2 : Integrable (fun x => ‖f x‖ ^ 2)) :
    ∫ x, ‖projectFinite h s f x‖ ^ 2 ≤ ∫ x, ‖f x‖ ^ 2 := by
  rw [ integral_norm_sq_projectFinite_eq_sum hh s f ];
  refine' le_trans ( Finset.sum_le_sum fun k hk => cellAverage_energy_le hh k f ( hf k hk ) ( hf2.integrableOn ) ) _;
  rw [ ← MeasureTheory.integral_biUnion_finset ];
  · apply_rules [ MeasureTheory.setIntegral_le_integral ];
    exact Filter.Eventually.of_forall fun x => sq_nonneg _;
  · exact fun k hk => momentumCell_measurable h k;
  · exact fun x hx y hy hxy => momentumCell_disjoint hh hxy;
  · exact fun k hk => hf2.integrableOn

/-
AE-zero data, including the point spike, project to the zero function.
-/
theorem projectFinite_pointSpike_zero {h : Real} (s : Finset Mode3)
    (c : Momentum3) :
    projectFinite h s (pointSpike c) = 0 := by
  have h_congr : ∀ k ∈ s, cellAverage h k (pointSpike c) = 0 := by
    intro k hk;
    rw [ cellAverage_congr_ae ( pointSpike_ae_zero c ) ] ; norm_num [ cellAverage ];
  unfold projectFinite; aesop;

/-
Nonvacuity: a selected cell reproduces the constant-one field there.
-/
theorem projectFinite_one_nonzero {h : Real} (hh : 0 < h) (k : Mode3) :
    projectFinite h {k} (fun _ => (1 : Complex)) (cellCenter h k) = 1 := by
  convert projectFinite_const_one_on_cell hh { k } ( Finset.mem_singleton_self k ) ( cellCenter_mem hh k ) using 1

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionL2.cellAverage_energy_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cellAverage_energy_le

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionL2.projectFinite_L2_contraction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projectFinite_L2_contraction

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionL2.projectFinite_pointSpike_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projectFinite_pointSpike_zero

end PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionL2
