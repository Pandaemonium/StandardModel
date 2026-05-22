import Mathlib

/-!
# Q-expansion coefficient extraction for lattice theta series

This file proves abstract lemmas needed to extract the q-expansion coefficients
of a lattice theta modular form as combinatorial shell counts.

The proof follows the SPL blueprint adapted for general dimension and all
coefficients `n`. The key results are generic: they work for any lattice
`L : Submodule ℤ (EuclideanSpace ℝ (Fin d))` with even norms.

Main results:

* `shell_finite`: each shell is finite.
* `qParamPowInv_mul_thetaTerm_eq_exp`: the product `𝕢⁻ⁿ` times a theta term is
  a single complex exponential.
* `term_integral_indicator_abstract`: each term integral is `1` if the vector
  is in shell `n`, and `0` otherwise.
* `integral_tsum_swap`: swap the interval integral and theta-series `tsum`.
* `tsum_indicator_eq_ncard`: the `tsum` of a finite-shell indicator equals the
  shell count.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option linter.unusedSimpArgs false
set_option linter.style.openClassical false
set_option linter.flexible false
set_option linter.style.refine false
set_option maxHeartbeats 800000

open Complex MeasureTheory Classical
open scoped RealInnerProductSpace CongruenceSubgroup

namespace CodeLatticeE8.SPL.QExpansionExtraction

/-! ## Basic lemmas -/

/-- `1` is a strict period for `Γ(1)`. -/
lemma one_mem_strictPeriods_Gamma1 :
    (1 : ℝ) ∈ (Γ(1) : Subgroup (GL (Fin 2) ℝ)).strictPeriods := by
  simp

/-- The imaginary part of `u + I` is positive. -/
lemma im_add_I_pos (u : ℝ) : 0 < ((u : ℂ) + Complex.I).im := by
  simp

/-! ## Shell finiteness -/

/-- Each shell `{z : L | ‖z‖² = c}` of a discrete lattice is finite. -/
lemma shell_finite {d : ℕ} {L : Submodule ℤ (EuclideanSpace ℝ (Fin d))}
    [DiscreteTopology L] (c : ℝ) :
    Set.Finite {w : L | ‖(w : EuclideanSpace ℝ (Fin d))‖ ^ 2 = c} := by
  have hclosed : IsClosed (L : Set (EuclideanSpace ℝ (Fin d))) := by
    have : IsClosed (L.toAddSubgroup : Set (EuclideanSpace ℝ (Fin d))) := by
      haveI : DiscreteTopology L.toAddSubgroup := by
        change DiscreteTopology L
        infer_instance
      exact AddSubgroup.isClosed_of_discrete
    convert this
  let R := Real.sqrt (max c 0) + 1
  have hFin : (Metric.closedBall (0 : EuclideanSpace ℝ (Fin d)) R ∩
      (L : Set (EuclideanSpace ℝ (Fin d)))).Finite :=
    Metric.finite_isBounded_inter_isClosed DiscreteTopology.isDiscrete
      Metric.isBounded_closedBall hclosed
  apply Set.Finite.subset
    (hFin.preimage_embedding (⟨Subtype.val, Subtype.val_injective⟩ : L ↪ _))
  intro w hw
  simp only [Set.mem_preimage, Set.mem_inter_iff, Metric.mem_closedBall, dist_zero_right,
    SetLike.mem_coe, Set.mem_setOf_eq] at hw ⊢
  refine ⟨?_, w.2⟩
  change ‖(w : EuclideanSpace ℝ (Fin d))‖ ≤ R
  have h2 : ‖(w : EuclideanSpace ℝ (Fin d))‖ = Real.sqrt c := by
    rw [← hw, Real.sqrt_sq (norm_nonneg _)]
  linarith [Real.sqrt_le_sqrt (le_max_left c 0 : c ≤ max c 0)]

/-! ## Exponential rewriting -/

/-- The theta term `exp(πI ‖z‖² τ)` for a lattice vector. -/
noncomputable def thetaTermAbstract {d : ℕ}
    {L : Submodule ℤ (EuclideanSpace ℝ (Fin d))}
    (τ : ℂ) (z : L) : ℂ :=
  Complex.exp
    ((↑Real.pi : ℂ) * Complex.I *
      ((‖(z : EuclideanSpace ℝ (Fin d))‖ ^ 2 : ℝ) : ℂ) * τ)

/--
The product `𝕢(1, u+I)⁻ⁿ * thetaTerm(u+I, z)` equals a single exponential
`exp(((m:ℂ) - n) * (2πI) * (u+I))` when `‖z‖² = 2m`.
-/
lemma qParamPowInv_mul_thetaTerm_eq_exp {d : ℕ}
    {L : Submodule ℤ (EuclideanSpace ℝ (Fin d))}
    (n m : ℕ) (z : L) (u : ℝ)
    (hm : ‖(z : EuclideanSpace ℝ (Fin d))‖ ^ 2 = 2 * (m : ℝ)) :
    (Function.Periodic.qParam (1 : ℝ) ((u : ℂ) + Complex.I) ^ n)⁻¹ *
      thetaTermAbstract ((u : ℂ) + Complex.I) z =
    Complex.exp (((m : ℂ) - n) * (2 * ↑Real.pi * Complex.I) *
      ((u : ℂ) + Complex.I)) := by
  unfold Function.Periodic.qParam thetaTermAbstract
  rw [← Complex.exp_nat_mul, ← Complex.exp_neg, ← Complex.exp_add]
  push_cast [hm]
  ring_nf

/-! ## Integral evaluation -/

/-- The integral `∫₀¹ exp(k * 2πI * (u+I)) du` is `0` when `k ≠ 0`. -/
lemma intervalIntegral_cexp_two_pi_I_int_mul_add_I_eq_zero {k : ℤ} (hk : k ≠ 0) :
    ∫ u : ℝ in (0 : ℝ)..1,
      Complex.exp (((k : ℂ) * (2 * ↑Real.pi * Complex.I)) * ((u : ℂ) + Complex.I)) = 0 := by
  have h_integral_zero :
      ∫ u in (0 : ℝ)..1, Complex.exp (k * (2 * Real.pi * I) * u) = 0 := by
    convert integral_exp_mul_complex ?_ using 1
    · norm_num [Complex.ext_iff, Complex.exp_re, Complex.exp_im]
    · norm_num [hk, Real.pi_ne_zero, Complex.I_ne_zero]
  simp_all +decide [mul_add, Complex.exp_add]

/--
For each lattice vector `z` with `‖z‖² = 2m`, the integral of `𝕢⁻ⁿ` times
`thetaTerm` over `[0,1]` is `1` if `m = n` and `0` otherwise.
-/
lemma term_integral_indicator_abstract {d : ℕ}
    {L : Submodule ℤ (EuclideanSpace ℝ (Fin d))}
    (n : ℕ) (z : L)
    (hEven : ∃ m : ℕ, ‖(z : EuclideanSpace ℝ (Fin d))‖ ^ 2 = 2 * (m : ℝ)) :
    (∫ u : ℝ in (0 : ℝ)..1,
      (Function.Periodic.qParam (1 : ℝ) ((u : ℂ) + Complex.I) ^ n)⁻¹ *
        thetaTermAbstract ((u : ℂ) + Complex.I) z) =
    if ‖(z : EuclideanSpace ℝ (Fin d))‖ ^ 2 = 2 * (n : ℝ) then 1 else 0 := by
  split_ifs with h
  · convert intervalIntegral.integral_congr fun u hu =>
        qParamPowInv_mul_thetaTerm_eq_exp n n z u ?_ using 1 <;>
      norm_num [h]
  · obtain ⟨m, hm⟩ := hEven
    convert intervalIntegral_cexp_two_pi_I_int_mul_add_I_eq_zero
      (show (m : ℤ) - n ≠ 0 from
        sub_ne_zero_of_ne <| mod_cast fun hmn => h <| by aesop) using 1
    convert intervalIntegral.integral_congr fun u hu =>
      qParamPowInv_mul_thetaTerm_eq_exp n m z u hm using 3
    push_cast
    ring

/-! ## Integral-tsum swap -/

/-- `‖𝕢(1, u+I)‖ = exp(-2π)` for all `u : ℝ`. -/
lemma norm_qParam_add_I (u : ℝ) :
    ‖Function.Periodic.qParam (1 : ℝ) ((u : ℂ) + Complex.I)‖ =
      Real.exp (-2 * Real.pi) := by
  simp [Function.Periodic.qParam, Complex.norm_exp]

/--
Norm bound: `‖𝕢⁻ⁿ * thetaTerm(u+I, z)‖ ≤ exp(2nπ) * ‖thetaTerm(I, z)‖`.
-/
lemma norm_qParamPowInv_mul_thetaTerm_le {d : ℕ}
    {L : Submodule ℤ (EuclideanSpace ℝ (Fin d))}
    (n : ℕ) (z : L) (u : ℝ) :
    ‖(Function.Periodic.qParam (1 : ℝ) ((u : ℂ) + Complex.I) ^ n)⁻¹ *
      thetaTermAbstract ((u : ℂ) + Complex.I) z‖ ≤
    Real.exp (2 * (n : ℝ) * Real.pi) * ‖thetaTermAbstract (Complex.I : ℂ) z‖ := by
  have h_bound :
      ‖(Function.Periodic.qParam 1 ((u : ℂ) + Complex.I) ^ n)⁻¹‖ =
        Real.exp (2 * n * Real.pi) := by
    simp +decide [Function.Periodic.qParam, Complex.norm_exp]
    rw [← Real.exp_nat_mul, ← Real.exp_neg]
    ring_nf
  rw [← h_bound, norm_mul]
  unfold thetaTermAbstract
  norm_num [Complex.norm_exp]
  norm_cast
  norm_num

/-- The integrand `u ↦ 𝕢⁻ⁿ * thetaTerm(u+I, z)` is continuous in `u`. -/
lemma continuous_qParamPowInv_mul_thetaTerm {d : ℕ}
    {L : Submodule ℤ (EuclideanSpace ℝ (Fin d))}
    (n : ℕ) (z : L) :
    Continuous fun u : ℝ =>
      (Function.Periodic.qParam (1 : ℝ) ((↑u : ℂ) + Complex.I) ^ n)⁻¹ *
        thetaTermAbstract ((↑u : ℂ) + Complex.I) z := by
  unfold Function.Periodic.qParam thetaTermAbstract
  refine' Continuous.mul _ _
  · exact Continuous.inv₀ (by continuity) fun u => pow_ne_zero _ <| Complex.exp_ne_zero _
  · fun_prop

/-- Bundled continuous map for the integrand. -/
noncomputable def qPIMTT {d : ℕ} {L : Submodule ℤ (EuclideanSpace ℝ (Fin d))}
    (n : ℕ) (z : L) : C(ℝ, ℂ) :=
  ⟨fun u => (Function.Periodic.qParam (1 : ℝ) ((↑u : ℂ) + Complex.I) ^ n)⁻¹ *
        thetaTermAbstract ((↑u : ℂ) + Complex.I) z,
   continuous_qParamPowInv_mul_thetaTerm n z⟩

/-- Summability of restricted norms for the integral-tsum swap. -/
lemma summable_norm_restrict_qPIMTT {d : ℕ}
    {L : Submodule ℤ (EuclideanSpace ℝ (Fin d))}
    [Countable L]
    (n : ℕ) (hSumm : Summable fun z : L => thetaTermAbstract (Complex.I : ℂ) z) :
    Summable fun z : L =>
      ‖(qPIMTT n z).restrict
        (⟨Set.uIcc 0 1, isCompact_uIcc⟩ : TopologicalSpace.Compacts ℝ)‖ := by
  refine' .of_nonneg_of_le (fun z => norm_nonneg _) (fun z => _)
    (hSumm.norm.mul_left (Real.exp (2 * n * Real.pi)))
  refine' ContinuousMap.norm_le _ _ |>.2 fun u => _
  · positivity
  · convert norm_qParamPowInv_mul_thetaTerm_le n z u.val using 1

/--
Swap `∫₀¹` and `∑'` for the theta integrand, assuming the theta series at
`τ = I` is summable.
-/
lemma integral_tsum_swap {d : ℕ} {L : Submodule ℤ (EuclideanSpace ℝ (Fin d))}
    [Countable L]
    (n : ℕ) (hSumm : Summable fun z : L => thetaTermAbstract (Complex.I : ℂ) z) :
    ∫ u : ℝ in (0 : ℝ)..1,
      ∑' z : L,
        (Function.Periodic.qParam (1 : ℝ) ((↑u : ℂ) + Complex.I) ^ n)⁻¹ *
          thetaTermAbstract ((↑u : ℂ) + Complex.I) z =
    ∑' z : L,
      ∫ u : ℝ in (0 : ℝ)..1,
        (Function.Periodic.qParam (1 : ℝ) ((↑u : ℂ) + Complex.I) ^ n)⁻¹ *
          thetaTermAbstract ((↑u : ℂ) + Complex.I) z := by
  exact (intervalIntegral.tsum_intervalIntegral_eq_of_summable_norm
    (summable_norm_restrict_qPIMTT n hSumm)).symm

/-! ## Indicator `tsum` to `ncard` -/

/-- The `tsum` of a finite-set indicator equals the `ncard` of the set. -/
lemma tsum_indicator_eq_ncard {α : Type*} {S : Set α} (hS : S.Finite) :
    (∑' z : α, if z ∈ S then (1 : ℂ) else 0) = (S.ncard : ℂ) := by
  have h_tsum_indicator :
      ∑' z, (if z ∈ S then 1 else 0 : ℂ) = ∑ z ∈ hS.toFinset, (1 : ℂ) := by
    rw [tsum_eq_sum]
    exacts
      [ Finset.sum_congr rfl fun x hx => if_pos <| hS.mem_toFinset.mp hx,
        fun x hx => if_neg <| fun hx' => hx <| hS.mem_toFinset.mpr hx' ]
  simp_all +decide [Set.ncard_eq_toFinset_card']
  rw [← Set.ncard_coe_finset, hS.coe_toFinset]

end CodeLatticeE8.SPL.QExpansionExtraction
