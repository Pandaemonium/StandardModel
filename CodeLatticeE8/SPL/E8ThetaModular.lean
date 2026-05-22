import Mathlib
import SpherePacking.Dim8.E8.Packing
import SpherePacking.CohnElkies.PoissonSummationGeneral
import SpherePacking.ForMathlib.RadialSchwartz.OneSided
import SpherePacking.ModularForms.Lv1Lv2Identities
import SpherePacking.ModularForms.DimensionFormulas
import CodeLatticeE8.SPL.ThetaProfile
import CodeLatticeE8.SPL.DualLatticeBasis

/-!
# Theta modular form for the E8 lattice in dimension 8

This file constructs the theta series of the E8 lattice as a weight-4 modular form
for Γ(1), adapted from SPL's rank-24/weight-12 blueprint in
`SpherePacking.Dim24.Uniqueness.Rigidity.Classify.Niemeier.RootlessCase.ThetaMF`.

## Main results
* `thetaE8_MF`: The E8 theta series as a `ModularForm (Γ 1) 4`.
* `thetaE8_MF_eq_E4`: This modular form equals E₄.

## Proved lemmas
* `norm_thetaTerm8`: Norm formula for theta terms.
* `summable_thetaTerm8`: Gaussian decay gives theta-term summability on the
  upper half-plane.
* `e8_evenNormSq`: E8 lattice has even squared norms (from `E8_norm_eq_sqrt_even`).
* `e8_integral`: E8 lattice is integral (from polarization + even norms).
* `e8_covolume_eq_one`: E8 has covolume 1, via SPL's public E8 matrix basis.
* `thetaSeries8_add_one`, `thetaSeriesUHP8_vadd_one`: T-invariance.
* `thetaSeries8_MDifferentiable`: holomorphicity by locally uniform convergence
  on upper-half-plane strips.
* `thetaSeriesUHP8_isBoundedAtImInfty`: cusp boundedness from the Gaussian
  majorant.
* `thetaSeriesUHP8_tendsto_one`: constant term at infinity, by dominated
  convergence.
* `thetaSeriesUHP8_S_slash`: S-slash invariance (from `thetaSeriesUHP8_mk_inv_neg` + I⁴=1).
* `thetaSeriesUHP8_T_slash`: T-slash invariance (from `thetaSeriesUHP8_vadd_one`).
* `thetaE8_SIF`, `thetaE8_MF`: Assembled slash-invariant form and modular form.
* `thetaE8_MF_eq_E4`: The theta MF equals E₄ by cusp form uniqueness.

## Proof spine

The two delicate inputs are the dimension-8 self-duality of `E8Lattice` and the
S-transform of the theta series.  Both are proved here using the SPL matrix
basis, the local integral-unimodular dual-lattice helper, and Poisson summation
for the Gaussian kernel.  The final equality with `E₄` then follows from SPL's
weight-four dimension formula and the shared constant term at infinity.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option linter.unusedSimpArgs false
set_option linter.flexible false
set_option maxHeartbeats 800000

open scoped Real MatrixGroups ModularForm CongruenceSubgroup RealInnerProductSpace SchwartzMap FourierTransform
open Complex UpperHalfPlane Filter Asymptotics Topology MeasureTheory
open Manifold SlashInvariantForm Matrix ModularGroup SlashAction MatrixGroups
open SpherePacking.ModularForms

local notation "ℝ⁸" => EuclideanSpace ℝ (Fin 8)

namespace CodeLatticeE8.SPL

/-! ## 1. Theta series definitions -/

/-- The z-th term in the E8 theta series at τ. -/
noncomputable def thetaTerm8 (τ : ℂ) (z : E8Lattice) : ℂ :=
  Complex.exp ((Real.pi : ℂ) * Complex.I * ((‖(z : ℝ⁸)‖ ^ 2 : ℝ) : ℂ) * τ)

/-- The analytic theta series for E8Lattice. -/
noncomputable def thetaSeries8 (τ : ℂ) : ℂ :=
  ∑' z : E8Lattice, thetaTerm8 τ z

/-- Theta series on the upper half-plane. -/
noncomputable def thetaSeriesUHP8 (z : UpperHalfPlane) : ℂ :=
  thetaSeries8 (z : ℂ)

/-! ## 2. Norm formula and summability -/

lemma norm_thetaTerm8 (τ : ℂ) (z : E8Lattice) :
    ‖thetaTerm8 τ z‖ = Real.exp (-Real.pi * (‖(z : ℝ⁸)‖ ^ 2) * τ.im) := by
  simp only [thetaTerm8]
  rw [Complex.norm_exp]
  congr 1
  have h1 : (↑Real.pi * Complex.I * ↑(‖(z : ℝ⁸)‖ ^ 2) * τ) =
    (↑(Real.pi * ‖(z : ℝ⁸)‖ ^ 2) : ℂ) * (Complex.I * τ) := by push_cast; ring
  rw [h1, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im,
    Complex.mul_re, Complex.mul_im, Complex.I_re, Complex.I_im]
  ring

private theorem finite_e8_subtype_norm_lt (R : ℝ) :
    {z : E8Lattice | ‖(z : ℝ⁸)‖ < R}.Finite := by
  have hFinAmb :
      (Metric.closedBall (0 : ℝ⁸) R ∩ (E8Lattice : Set ℝ⁸)).Finite := by
    change (Metric.closedBall (0 : ℝ⁸) R ∩ (E8Lattice.toAddSubgroup : Set ℝ⁸)).Finite
    haveI : DiscreteTopology E8Lattice.toAddSubgroup :=
      (inferInstance : DiscreteTopology E8Lattice)
    exact Metric.finite_isBounded_inter_isClosed DiscreteTopology.isDiscrete Metric.isBounded_closedBall
      inferInstance
  let e : E8Lattice ↪ ℝ⁸ := ⟨fun z : E8Lattice => (z : ℝ⁸), Subtype.val_injective⟩
  have hpre :
      e ⁻¹' (Metric.closedBall (0 : ℝ⁸) R ∩ (E8Lattice : Set ℝ⁸)) =
        {z : E8Lattice | ‖(z : ℝ⁸)‖ ≤ R} := by
    ext z
    constructor
    · intro hz
      have hz' : (e z : ℝ⁸) ∈ Metric.closedBall (0 : ℝ⁸) R := hz.1
      simpa [e, mem_closedBall_zero_iff] using hz'
    · intro hz
      refine ⟨?_, ?_⟩
      · simpa [e, mem_closedBall_zero_iff] using hz
      · simp [e]
  have hFinLe : {z : E8Lattice | ‖(z : ℝ⁸)‖ ≤ R}.Finite := by
    simpa [hpre] using (Set.Finite.preimage_embedding (f := e) hFinAmb)
  refine hFinLe.subset ?_
  intro z hz
  exact le_of_lt (by simpa using hz)

theorem summable_thetaTerm8
    {τ : ℂ} (hτ : 0 < τ.im) :
    Summable fun z : E8Lattice => thetaTerm8 τ z := by
  -- Standard theta-series estimate: a Gaussian on a full-rank lattice decays faster than
  -- any inverse power.  This is the rank-8 analogue of SPL's
  -- `SpherePacking.Dim24...ThetaAnalytic.summable_thetaTerm`.
  let r : ℝ := -Module.finrank ℤ E8Lattice - 2
  have hr : r < -Module.finrank ℤ E8Lattice := by linarith
  have hSummable : Summable fun z : E8Lattice => (‖z‖ : ℝ) ^ r :=
    ZLattice.summable_norm_rpow (L := E8Lattice) r hr
  have hdecay :
      (fun x : ℝ => Real.exp (-Real.pi * τ.im * x ^ 2)) =o[atTop] fun x : ℝ => x ^ r := by
    have ha : (-Real.pi * τ.im) < 0 := by nlinarith [Real.pi_pos, hτ]
    simpa [Real.exp_eq_exp, mul_assoc, add_zero] using
      (rexp_neg_quadratic_isLittleO_rpow_atTop (a := (-Real.pi * τ.im)) ha
        (b := (0 : ℝ)) r)
  have hBigO :
      (fun x : ℝ => Real.exp (-Real.pi * τ.im * x ^ 2)) =O[atTop] fun x : ℝ => x ^ r :=
    hdecay.isBigO
  rcases hBigO.exists_pos with ⟨C, hCpos, hC⟩
  rcases (Filter.eventually_atTop.1 hC.bound) with ⟨R, hR⟩
  have hFinite : {z : E8Lattice | ‖(z : ℝ⁸)‖ < R}.Finite :=
    finite_e8_subtype_norm_lt R
  have hBound :
      ∀ᶠ z : E8Lattice in Filter.cofinite,
        ‖thetaTerm8 τ z‖ ≤ C * (‖z‖ : ℝ) ^ r := by
    refine Filter.eventually_cofinite.2 ?_
    refine hFinite.subset ?_
    intro z hzBad
    by_contra hzSmall
    have hzLarge : R ≤ ‖(z : ℝ⁸)‖ := le_of_not_gt hzSmall
    have hRz_norm :
        ‖Real.exp (-Real.pi * τ.im * ‖(z : ℝ⁸)‖ ^ 2)‖ ≤
          C * ‖(‖(z : ℝ⁸)‖ : ℝ) ^ r‖ :=
      hR _ hzLarge
    have hRz : Real.exp (-Real.pi * τ.im * ‖(z : ℝ⁸)‖ ^ 2) ≤
        C * (‖(z : ℝ⁸)‖ : ℝ) ^ r := by
      have hpow_nonneg : 0 ≤ (‖(z : ℝ⁸)‖ : ℝ) ^ r := by positivity
      have hexp_pos : 0 < Real.exp (-Real.pi * τ.im * ‖(z : ℝ⁸)‖ ^ 2) := by positivity
      have hexp_nonneg : 0 ≤ Real.exp (-Real.pi * τ.im * ‖(z : ℝ⁸)‖ ^ 2) :=
        le_of_lt hexp_pos
      simpa [Real.norm_eq_abs, abs_of_nonneg hexp_nonneg, abs_of_nonneg hpow_nonneg]
        using hRz_norm
    have : ‖thetaTerm8 τ z‖ ≤ C * (‖z‖ : ℝ) ^ r := by
      simpa [norm_thetaTerm8, mul_assoc, mul_left_comm, mul_comm] using hRz
    exact hzBad this
  refine Summable.of_norm_bounded_eventually (hSummable.mul_left C) ?_
  filter_upwards [hBound] with z hz
  simpa [norm_mul, Real.norm_eq_abs, abs_of_pos hCpos, mul_assoc] using hz

/-! ## 3. E8 lattice properties -/

theorem e8_evenNormSq :
    ∀ v : ℝ⁸, v ∈ E8Lattice → ∃ n : ℕ, ‖v‖ ^ 2 = (2 : ℝ) * n := by
  intro v hv
  obtain ⟨w, hw, hwv⟩ := Submodule.mem_map.mp hv
  obtain ⟨k, hk, hk'⟩ := E8_norm_eq_sqrt_even w hw
  subst hwv
  change ∃ n : ℕ, ‖(WithLp.linearEquiv 2 ℤ (Fin 8 → ℝ)).symm w‖ ^ 2 = 2 * ↑n
  have hnormeq : ‖(WithLp.linearEquiv 2 ℤ (Fin 8 → ℝ)).symm w‖ = ‖WithLp.toLp 2 w‖ := rfl
  rw [hnormeq]
  obtain ⟨m, rfl⟩ := hk
  have hnsq : ‖WithLp.toLp 2 w‖ ^ 2 = (↑(m + m) : ℝ) := by exact_mod_cast hk'.symm
  have hge : (0 : ℤ) ≤ m + m := by
    exact_mod_cast (show (0 : ℝ) ≤ ↑(m + m) by rw [← hnsq]; positivity)
  have hm_nn : 0 ≤ m := by omega
  exact ⟨m.toNat, by rw [hnsq]; exact_mod_cast (show (m + m : ℤ) = 2 * m.toNat by omega)⟩

theorem e8_integral :
    ∀ u v : ℝ⁸, u ∈ E8Lattice → v ∈ E8Lattice →
      ∃ m : ℤ, @inner ℝ ℝ⁸ _ u v = m := by
  intro u v hu hv
  have huv : u + v ∈ E8Lattice := add_mem hu hv
  obtain ⟨a, ha⟩ := e8_evenNormSq u hu
  obtain ⟨b, hb⟩ := e8_evenNormSq v hv
  obtain ⟨c, hc⟩ := e8_evenNormSq (u + v) huv
  have hpol : ‖u + v‖ ^ 2 = ‖u‖ ^ 2 + 2 * @inner ℝ ℝ⁸ _ u v + ‖v‖ ^ 2 := norm_add_sq_real u v
  exact ⟨(c : ℤ) - (a : ℤ) - (b : ℤ), by exact_mod_cast (show @inner ℝ ℝ⁸ _ u v = (c : ℝ) - (a : ℝ) - (b : ℝ) by nlinarith)⟩

/-- The public row-basis presentation of `E8Lattice`. -/
private lemma span_E8Matrix_eq_E8Lattice_local :
    Submodule.span ℤ
      (Set.range fun i ↦
        (WithLp.linearEquiv 2 ℤ (Fin 8 → ℝ)).symm ((E8Matrix ℝ).row i)) =
      E8Lattice := by
  rw [show Set.range
        (fun i ↦ (WithLp.linearEquiv 2 ℤ (Fin 8 → ℝ)).symm ((E8Matrix ℝ).row i)) =
        ((WithLp.linearEquiv 2 ℤ (Fin 8 → ℝ)).symm :
            (Fin 8 → ℝ) →ₗ[ℤ] EuclideanSpace ℝ (Fin 8)) '' Set.range (E8Matrix ℝ).row by
      simpa [Function.comp] using
        Set.range_comp (WithLp.linearEquiv 2 ℤ (Fin 8 → ℝ)).symm (E8Matrix ℝ).row,
    ← Submodule.map_span, span_E8Matrix ℝ]
  simp [E8Lattice]

/-- A concrete `ℤ`-basis for `E8Lattice`, built from the rows of `E8Matrix`. -/
private noncomputable def e8ZBasis : Module.Basis (Fin 8) ℤ E8Lattice := by
  refine Module.Basis.mk
      (v := fun i ↦
        ⟨(WithLp.linearEquiv 2 ℤ (Fin 8 → ℝ)).symm ((E8Matrix ℝ).row i), ?_⟩) ?_ ?_
  · exact Submodule.mem_map_of_mem (E8Matrix_row_mem_E8 i)
  · refine LinearIndependent.of_comp (Submodule.subtype _) ?_
    refine LinearIndependent.of_comp (M' := (Fin 8 → ℝ))
      (WithLp.linearEquiv 2 ℤ (Fin 8 → ℝ)) ?_
    exact (linearIndependent_E8Matrix ℝ).restrict_scalars' ℤ
  · rw [← Submodule.map_le_map_iff_of_injective (f := E8Lattice.subtype) (by simp)]
    simp only [Submodule.map_top, Submodule.range_subtype]
    rw [Submodule.map_span, ← Set.range_comp]
    exact span_E8Matrix_eq_E8Lattice_local.ge

private lemma e8ZBasis_apply (i : Fin 8) :
    e8ZBasis i =
      (WithLp.linearEquiv 2 ℤ (Fin 8 → ℝ)).symm ((E8Matrix ℝ).row i) := by
  rw [e8ZBasis, Module.Basis.coe_mk]

private lemma e8Basis_volume_pi :
    MeasureTheory.volume (ZSpan.fundamentalDomain (E8Basis ℝ)) = 1 := by
  rw [ZSpan.volume_fundamentalDomain]
  simp [of_basis_eq_matrix, E8Matrix_unimodular]

private lemma e8ZBasis_fundamentalDomain_preimage :
    (WithLp.linearEquiv 2 ℝ (Fin 8 → ℝ)).symm ⁻¹'
        ZSpan.fundamentalDomain (e8ZBasis.ofZLatticeBasis ℝ E8Lattice) =
      ZSpan.fundamentalDomain (E8Basis ℝ) := by
  rw [← LinearEquiv.image_eq_preimage_symm, ZSpan.map_fundamentalDomain]
  congr! 1
  ext i : 1
  simp [e8ZBasis_apply, E8Basis_apply]

private lemma e8ZBasis_volume :
    MeasureTheory.volume (ZSpan.fundamentalDomain (e8ZBasis.ofZLatticeBasis ℝ E8Lattice)) =
      1 := by
  rw [← (EuclideanSpace.volume_preserving_symm_measurableEquiv_toLp (Fin 8)).symm.measure_preimage_equiv]
  erw [e8ZBasis_fundamentalDomain_preimage]
  exact e8Basis_volume_pi

theorem e8_covolume_eq_one :
    ZLattice.covolume E8Lattice volume = 1 := by
  rw [ZLattice.covolume_eq_measure_fundamentalDomain
    (L := E8Lattice) (μ := volume) (F := ZSpan.fundamentalDomain
      (e8ZBasis.ofZLatticeBasis ℝ E8Lattice))
    (ZLattice.isAddFundamentalDomain e8ZBasis volume)]
  rw [MeasureTheory.Measure.real]
  rw [e8ZBasis_volume]
  norm_num

/-- The ℝ-basis for ℝ⁸ whose ℤ-span is E8Lattice. -/
private noncomputable def e8RBasis : Module.Basis (Fin 8) ℝ ℝ⁸ :=
  e8ZBasis.ofZLatticeBasis ℝ E8Lattice

private lemma e8RBasis_span :
    Submodule.span ℤ (Set.range e8RBasis) = E8Lattice :=
  e8ZBasis.ofZLatticeBasis_span ℝ

private lemma e8_inner_mem_one :
    ∀ i j : Fin 8, @inner ℝ ℝ⁸ _ (e8RBasis i) (e8RBasis j) ∈ (1 : Submodule ℤ ℝ) := by
  intro i j
  have hi : (e8RBasis i : ℝ⁸) ∈ E8Lattice :=
    e8RBasis_span ▸ Submodule.subset_span (Set.mem_range_self i)
  have hj : (e8RBasis j : ℝ⁸) ∈ E8Lattice :=
    e8RBasis_span ▸ Submodule.subset_span (Set.mem_range_self j)
  obtain ⟨m, hm⟩ := e8_integral _ _ hi hj
  exact Submodule.mem_one.mpr ⟨m, by simp [Algebra.linearMap_apply]; exact hm.symm⟩

private lemma e8RBasis_inner_eq_gram (i j : Fin 8) :
    @inner ℝ ℝ⁸ _ (e8RBasis i) (e8RBasis j) =
    ((E8Matrix ℝ) * (E8Matrix ℝ).transpose) i j := by
  -- e8RBasis i = (e8ZBasis i : ℝ⁸) = WithLp.equiv.symm ((E8Matrix ℝ).row i)
  simp only [e8RBasis, Module.Basis.ofZLatticeBasis_apply, e8ZBasis, Module.Basis.coe_mk]
  simp [PiLp.inner_apply, RCLike.inner_apply, mul_comm,
    Matrix.mul_apply, Matrix.transpose_apply, Matrix.row]

private lemma e8_gram_det_isUnit :
    IsUnit (gramMatrixZ 8 e8RBasis e8_inner_mem_one).det := by
  -- Strategy: cast det to ℝ, show it equals 1, then conclude
  rw [Int.isUnit_iff]
  have h_cast : ((gramMatrixZ 8 e8RBasis e8_inner_mem_one).det : ℝ) = 1 := by
    -- Step 1: cast det = det of cast matrix
    have h_det_cast : ((gramMatrixZ 8 e8RBasis e8_inner_mem_one).det : ℝ) =
        ((gramMatrixZ 8 e8RBasis e8_inner_mem_one).map (Int.castRingHom ℝ)).det := by
      have h := RingHom.map_det (Int.castRingHom ℝ) (gramMatrixZ 8 e8RBasis e8_inner_mem_one)
      rw [RingHom.mapMatrix_apply] at h
      change Int.cast _ = _
      exact h
    rw [h_det_cast]
    -- Step 2: cast matrix = real Gram matrix = E8Matrix * E8Matrixᵀ
    have h_entries : (gramMatrixZ 8 e8RBasis e8_inner_mem_one).map (Int.castRingHom ℝ) =
        (E8Matrix ℝ) * (E8Matrix ℝ).transpose := by
      ext i j
      simp only [Matrix.map_apply]
      rw [show (Int.castRingHom ℝ) ((gramMatrixZ 8 e8RBasis e8_inner_mem_one) i j) =
          (algebraMap ℤ ℝ) ((gramMatrixZ 8 e8RBasis e8_inner_mem_one) i j) from rfl]
      rw [gramMatrixZ_spec]
      exact e8RBasis_inner_eq_gram i j
    rw [h_entries]
    -- Step 3: det(M * Mᵀ) = det(M)²
    rw [Matrix.det_mul, Matrix.det_transpose]
    -- Step 4: det(E8Matrix) = 1
    rw [E8Matrix_unimodular ℝ]; norm_num
  have h1 : (gramMatrixZ 8 e8RBasis e8_inner_mem_one).det = 1 ∨
      (gramMatrixZ 8 e8RBasis e8_inner_mem_one).det = -1 := by
    have : ((gramMatrixZ 8 e8RBasis e8_inner_mem_one).det : ℝ) = (1 : ℤ) := by
      exact_mod_cast h_cast
    left; exact_mod_cast this
  exact h1

theorem e8_dualLattice_eq_self :
    SchwartzMap.dualLattice (d := 8) E8Lattice = E8Lattice := by
  -- SchwartzMap.dualLattice is (innerₗ ℝ⁸).dualSubmodule
  change (ipBilin 8).dualSubmodule E8Lattice = E8Lattice
  rw [← e8RBasis_span]
  have hB : (ipBilin 8).Nondegenerate := by
    constructor <;> (intro x hx; have h := hx x; simp [innerₗ_apply_apply] at h; exact h)
  exact dualSubmodule_innerₗ_eq_span_of_integral_unimodular 8 e8RBasis
    hB e8_inner_mem_one e8_gram_det_isUnit

/-! ## 4. T-invariance -/

private lemma thetaTerm8_add_one (τ : ℂ) (z : E8Lattice) :
    thetaTerm8 (τ + 1) z = thetaTerm8 τ z := by
  obtain ⟨n, hn⟩ := e8_evenNormSq (z : ℝ⁸) z.property
  simp only [thetaTerm8]
  rw [hn]
  have hsplit :
      (↑Real.pi * Complex.I * ↑((2 : ℝ) * ↑n) * (τ + 1)) =
        (↑Real.pi * Complex.I * ↑((2 : ℝ) * ↑n) * τ) +
          (n : ℂ) * (2 * ↑Real.pi * Complex.I) := by
    push_cast
    ring
  rw [hsplit, Complex.exp_add, Complex.exp_nat_mul_two_pi_mul_I, mul_one]

theorem thetaSeries8_add_one {τ : ℂ} (_hτ : 0 < τ.im) :
    thetaSeries8 (τ + 1) = thetaSeries8 τ := by
  simp only [thetaSeries8]
  exact tsum_congr fun z => thetaTerm8_add_one τ z

theorem thetaSeriesUHP8_vadd_one (z : UpperHalfPlane) :
    thetaSeriesUHP8 ((1 : ℝ) +ᵥ z) = thetaSeriesUHP8 z := by
  simpa [thetaSeriesUHP8, UpperHalfPlane.coe_vadd, add_comm] using
    (thetaSeries8_add_one (τ := (z : ℂ)) z.2)

/-! ## 5. S-transformation -/

private alias thetaProfile8 := ThetaProfile.thetaProfile
private alias thetaProfile8_contDiff := ThetaProfile.thetaProfile_contDiff
private alias thetaProfile8_decay := ThetaProfile.thetaProfile_decay

/-- The Schwartz map on ℝ⁸ built from the theta profile. -/
private noncomputable def thetaKernel8 (τ : ℂ) (hτ : 0 < τ.im) : 𝓢(ℝ⁸, ℂ) :=
  RadialSchwartz.Bridge.schwartzMap_norm_sq_of_contDiff_decay_nonneg (F := ℝ⁸)
    (thetaProfile8 τ) (thetaProfile8_contDiff τ) (thetaProfile8_decay τ hτ)

@[simp] private lemma thetaKernel8_apply (τ : ℂ) (hτ : 0 < τ.im) (x : ℝ⁸) :
    thetaKernel8 τ hτ x =
      Complex.exp ((Real.pi : ℂ) * Complex.I * τ * ((‖x‖ ^ 2 : ℝ) : ℂ)) := by
  simp only [thetaKernel8,
    RadialSchwartz.Bridge.schwartzMap_norm_sq_of_contDiff_decay_nonneg_apply]
  simp [thetaProfile8, ThetaProfile.thetaProfile, mul_assoc, mul_comm]

theorem thetaSeries8_transform_S
    {τ : ℂ} (hτ : 0 < τ.im) :
    thetaSeries8 (-1 / τ) =
      (-(τ * Complex.I)) ^ (4 : ℂ) * thetaSeries8 τ := by
  -- Step 0: useful facts
  have hτ0 : τ ≠ 0 := by intro h; simp [h] at hτ
  have hτ1 : 0 < (-1 / τ).im := ThetaProfile.neg_one_div_im_pos hτ
  -- Step 1: rewrite -(τ*I) as τ/I
  have h_neg_eq_div : -(τ * Complex.I) = τ / Complex.I := by
    rw [div_eq_mul_inv, Complex.inv_I]; ring
  rw [h_neg_eq_div]
  -- Step 2: Apply Poisson summation at τ₁ = -1/τ, v = 0
  let f : 𝓢(ℝ⁸, ℂ) := thetaKernel8 (-1 / τ) hτ1
  have hps := SchwartzMap.poissonSummation_lattice (d := 8) (L := E8Lattice)
    (f := f) (v := (0 : ℝ⁸))
  -- Step 3: LHS of Poisson = thetaSeries8(-1/τ)
  have hlhs : (∑' ℓ : E8Lattice, f (ℓ : ℝ⁸)) = thetaSeries8 (-1 / τ) := by
    simp only [thetaSeries8, thetaTerm8, f]
    congr 1; ext z
    simp [thetaKernel8_apply, mul_assoc, mul_left_comm, mul_comm]
  -- Step 4: Identify f with a Gaussian exp(-b * ‖x‖²)
  set b : ℂ := (Real.pi : ℂ) * (Complex.I / τ) with hb_def
  have hb_re : 0 < b.re := by
    simp [hb_def, Complex.div_re, Complex.normSq_apply]
    apply mul_pos Real.pi_pos
    apply div_pos hτ
    nlinarith [sq_nonneg τ.re, sq_nonneg τ.im]
  have hf_eq : (fun x : ℝ⁸ => f x) = fun x : ℝ⁸ => Complex.exp (-b * (‖x‖ : ℂ) ^ 2) := by
    funext x; simp only [f, thetaKernel8_apply]; congr 1; push_cast; ring
  -- Step 5: Fourier transform of the Gaussian
  have hgauss := fun (w : ℝ⁸) =>
    fourier_gaussian_innerProductSpace (V := ℝ⁸) hb_re w
  -- Step 6: Simplify π/b = τ/I
  have hπb : (Real.pi : ℂ) / b = τ / Complex.I := by
    simp only [hb_def]
    field_simp [Real.pi_ne_zero, Complex.I_ne_zero, hτ0]
  -- Step 7: Compute the Fourier transform for each dual lattice element
  have hfourier : ∀ m : SchwartzMap.dualLattice (d := 8) E8Lattice,
      (FourierTransform.fourier (fun x : ℝ⁸ => f x) (m : ℝ⁸)) =
        (τ / Complex.I) ^ (4 : ℂ) *
          Complex.exp ((Real.pi : ℂ) * Complex.I * τ * ((‖(m : ℝ⁸)‖ ^ 2 : ℝ) : ℂ)) := by
    intro m
    rw [hf_eq, hgauss, hπb]
    congr 1
    · -- exponent: (Module.finrank ℝ ℝ⁸) / 2 = 4
      congr 1; simp; norm_num
    · -- exponential argument: -π² * ‖m‖² / b = π*I*τ*‖m‖²
      congr 1
      have : -(Real.pi : ℂ) ^ 2 * (‖(m : ℝ⁸)‖ : ℂ) ^ 2 / b =
          (Real.pi : ℂ) * Complex.I * τ * ((‖(m : ℝ⁸)‖ ^ 2 : ℝ) : ℂ) := by
        simp only [hb_def]
        field_simp [Real.pi_ne_zero, Complex.I_ne_zero, hτ0]
        ring_nf; simp [Complex.I_sq]
      exact this
  -- Step 8: Combine Poisson summation with Fourier computation
  -- The Poisson summation gives:
  -- ∑ ℓ∈L f(ℓ) = (1/covol) * ∑ m∈L* F̂(f)(m) * exp(2πi⟨0,m⟩)
  -- with v=0, the inner product term vanishes
  have hps' : thetaSeries8 (-1 / τ) =
      (1 / (ZLattice.covolume E8Lattice MeasureTheory.volume : ℂ)) *
        ∑' m : SchwartzMap.dualLattice (d := 8) E8Lattice,
          (FourierTransform.fourier (fun x : ℝ⁸ => f x) (m : ℝ⁸)) *
            Complex.exp (2 * Real.pi * Complex.I * ⟪(0 : ℝ⁸), (m : ℝ⁸)⟫_[ℝ]) := by
    rw [← hlhs]
    convert hps using 1
    simp
  -- Simplify: inner product with 0 gives 0, exp(0)=1
  have hinner_zero : ∀ m : SchwartzMap.dualLattice (d := 8) E8Lattice,
      Complex.exp (2 * Real.pi * Complex.I * ⟪(0 : ℝ⁸), (m : ℝ⁸)⟫_[ℝ]) = 1 := by
    intro m; simp
  -- Covolume = 1
  have hcovol : (ZLattice.covolume E8Lattice MeasureTheory.volume : ℂ) = 1 := by
    rw [e8_covolume_eq_one]; simp
  -- Dual lattice = self
  have hdual := e8_dualLattice_eq_self
  -- Step 9: Simplify the sum
  have hsum_eq :
      ∑' m : SchwartzMap.dualLattice (d := 8) E8Lattice,
        (FourierTransform.fourier (fun x : ℝ⁸ => f x) (m : ℝ⁸)) *
          Complex.exp (2 * Real.pi * Complex.I * ⟪(0 : ℝ⁸), (m : ℝ⁸)⟫_[ℝ]) =
      (τ / Complex.I) ^ (4 : ℂ) *
        ∑' m : SchwartzMap.dualLattice (d := 8) E8Lattice,
          Complex.exp ((Real.pi : ℂ) * Complex.I * τ * ((‖(m : ℝ⁸)‖ ^ 2 : ℝ) : ℂ)) := by
    have : ∀ m : SchwartzMap.dualLattice (d := 8) E8Lattice,
        (FourierTransform.fourier (fun x : ℝ⁸ => f x) (m : ℝ⁸)) *
          Complex.exp (2 * Real.pi * Complex.I * ⟪(0 : ℝ⁸), (m : ℝ⁸)⟫_[ℝ]) =
        (τ / Complex.I) ^ (4 : ℂ) *
          Complex.exp ((Real.pi : ℂ) * Complex.I * τ * ((‖(m : ℝ⁸)‖ ^ 2 : ℝ) : ℂ)) := by
      intro m; rw [hfourier m, hinner_zero m, mul_one]
    rw [tsum_congr this, tsum_mul_left]
  -- Step 10: Reindex dual = self
  have hsum_reindex :
      ∑' m : SchwartzMap.dualLattice (d := 8) E8Lattice,
        Complex.exp ((Real.pi : ℂ) * Complex.I * τ * ((‖(m : ℝ⁸)‖ ^ 2 : ℝ) : ℂ)) =
      thetaSeries8 τ := by
    have : ∀ z : E8Lattice,
        Complex.exp ((Real.pi : ℂ) * Complex.I * ((‖(z : ℝ⁸)‖ ^ 2 : ℝ) : ℂ) * τ) =
        Complex.exp ((Real.pi : ℂ) * Complex.I * τ * ((‖(z : ℝ⁸)‖ ^ 2 : ℝ) : ℂ)) := by
      intro z; ring_nf
    simp_rw [thetaSeries8, thetaTerm8, this]
    exact hdual.symm ▸ rfl
  -- Assemble
  rw [hps', hcovol, one_div, inv_one, one_mul, hsum_eq, hsum_reindex]

theorem thetaSeriesUHP8_mk_inv_neg (z : UpperHalfPlane) :
    thetaSeriesUHP8 (UpperHalfPlane.mk (-z : ℂ)⁻¹ z.im_inv_neg_coe_pos) =
      (-(z : ℂ) * Complex.I) ^ (4 : ℂ) * thetaSeriesUHP8 z := by
  simpa [thetaSeriesUHP8, div_eq_mul_inv, UpperHalfPlane.coe_mk, inv_neg, mul_assoc]
    using (thetaSeries8_transform_S (τ := (z : ℂ)) z.2)

/-! ## 6. Holomorphicity and cusp bounds -/

private lemma neg_pi_mul_norm_sq_nonpos (v : ℝ⁸) :
    -Real.pi * (‖v‖ ^ 2) ≤ 0 := by
  have hπ : 0 < Real.pi := Real.pi_pos
  have hv0 : 0 ≤ ‖v‖ ^ 2 := by positivity
  nlinarith [hπ, hv0]

private lemma exp_mul_le_exp_mul_of_nonpos_left {a b c : ℝ} (hab : a ≤ b) (hc : c ≤ 0) :
    Real.exp (c * b) ≤ Real.exp (c * a) :=
  (Real.exp_le_exp).2 (mul_le_mul_of_nonpos_left hab hc)

private lemma norm_thetaTerm8_le_of_le_im (x : E8Lattice) (w : ℂ)
    {a : ℝ} (ha : a ≤ w.im) :
    ‖thetaTerm8 w x‖ ≤ Real.exp (-Real.pi * (‖(x : ℝ⁸)‖ ^ 2) * a) := by
  have hcoef : (-Real.pi * (‖(x : ℝ⁸)‖ ^ 2)) ≤ 0 :=
    neg_pi_mul_norm_sq_nonpos (v := (x : ℝ⁸))
  have hexp :
      Real.exp ((-Real.pi * (‖(x : ℝ⁸)‖ ^ 2)) * w.im) ≤
        Real.exp ((-Real.pi * (‖(x : ℝ⁸)‖ ^ 2)) * a) :=
    exp_mul_le_exp_mul_of_nonpos_left ha hcoef
  simpa [norm_thetaTerm8, mul_assoc, mul_left_comm, mul_comm] using hexp

private lemma summable_gaussian8 {a : ℝ} (ha : 0 < a) :
    Summable fun x : E8Lattice => Real.exp (-Real.pi * (‖(x : ℝ⁸)‖ ^ 2) * a) := by
  have haτ : 0 < ((Complex.I : ℂ) * a).im := by simpa using ha
  have hSumm : Summable fun x : E8Lattice => thetaTerm8 ((Complex.I : ℂ) * a) x :=
    summable_thetaTerm8 (τ := (Complex.I : ℂ) * a) haτ
  simpa [norm_thetaTerm8] using hSumm.norm

theorem thetaSeries8_MDifferentiable :
    MDifferentiable 𝓘(ℂ) 𝓘(ℂ) thetaSeriesUHP8 := by
  rw [UpperHalfPlane.mdifferentiable_iff]
  intro z hz
  have hzIm : 0 < z.im := by simpa using hz
  let a : ℝ := z.im / 2
  have ha : 0 < a := by
    dsimp [a]
    nlinarith [hzIm]
  let U : Set ℂ := {w : ℂ | a < w.im}
  have hUopen : IsOpen U := isOpen_lt continuous_const Complex.continuous_im
  have hzU : z ∈ U := by
    dsimp [U, a]
    nlinarith [hzIm]
  let u : E8Lattice → ℝ := fun x => Real.exp (-Real.pi * (‖(x : ℝ⁸)‖ ^ 2) * a)
  have hu : Summable u := summable_gaussian8 (a := a) ha
  have hterm : ∀ x : E8Lattice, DifferentiableOn ℂ (fun w : ℂ => thetaTerm8 w x) U := by
    intro x
    let c : ℂ := (Real.pi : ℂ) * Complex.I * ((‖(x : ℝ⁸)‖ ^ 2 : ℝ) : ℂ)
    have hconst : Differentiable ℂ (fun _ : ℂ => c) := by simp
    have hid : Differentiable ℂ (fun w : ℂ => w) := differentiable_id
    have hdiff : Differentiable ℂ (fun w : ℂ => Complex.exp (c * w)) := (hconst.mul hid).cexp
    simpa [thetaTerm8, c, mul_assoc, mul_left_comm, mul_comm] using hdiff.differentiableOn
  have hle : ∀ (x : E8Lattice) (w : ℂ), w ∈ U → ‖thetaTerm8 w x‖ ≤ u x := by
    intro x w hw
    have ha_le : a ≤ w.im := le_of_lt hw
    simpa [u] using norm_thetaTerm8_le_of_le_im (x := x) (w := w) ha_le
  have hUdiff :
      DifferentiableOn ℂ (fun w : ℂ => ∑' x : E8Lattice, thetaTerm8 w x) U :=
    Complex.differentiableOn_tsum_of_summable_norm (U := U)
      (F := fun x : E8Lattice => fun w : ℂ => thetaTerm8 w x)
      (hu := hu) (hf := hterm) (hU := hUopen) (hF_le := hle)
  have hAt : DifferentiableAt ℂ (fun w : ℂ => ∑' x : E8Lattice, thetaTerm8 w x) z :=
    (hUdiff z hzU).differentiableAt (hUopen.mem_nhds hzU)
  have hWithin : DifferentiableWithinAt ℂ thetaSeries8 {w : ℂ | 0 < w.im} z := by
    simpa [thetaSeries8] using hAt.differentiableWithinAt
  have hEq :
      ∀ w ∈ {w : ℂ | 0 < w.im},
        (thetaSeriesUHP8 ∘ UpperHalfPlane.ofComplex) w = thetaSeries8 w := by
    intro w hw
    have hw' : 0 < w.im := by simpa using hw
    simp [Function.comp, thetaSeriesUHP8, UpperHalfPlane.ofComplex_apply_of_im_pos hw']
  exact hWithin.congr hEq (hEq z hz)

theorem thetaSeriesUHP8_isBoundedAtImInfty :
    UpperHalfPlane.IsBoundedAtImInfty thetaSeriesUHP8 := by
  rw [UpperHalfPlane.isBoundedAtImInfty_iff]
  let g : E8Lattice → ℝ := fun x => Real.exp (-Real.pi * (‖(x : ℝ⁸)‖ ^ 2) * (1 : ℝ))
  have hg : Summable g := summable_gaussian8 (a := (1 : ℝ)) (by simp)
  refine ⟨∑' x : E8Lattice, g x, 1, ?_⟩
  intro z hz
  have hbound :
      ‖thetaSeriesUHP8 z‖ ≤ ∑' x : E8Lattice, g x := by
    have hg' : HasSum g (∑' x : E8Lattice, g x) := hg.hasSum
    have hle : ∀ x : E8Lattice, ‖thetaTerm8 (z : ℂ) x‖ ≤ g x := by
      intro x
      simpa [g] using
        (norm_thetaTerm8_le_of_le_im (x := x) (w := (z : ℂ)) (a := (1 : ℝ))
          (by simpa using hz))
    simpa [thetaSeriesUHP8, thetaSeries8] using
      (tsum_of_norm_bounded (hg := hg') (f := fun x : E8Lattice => thetaTerm8 (z : ℂ) x) hle)
  simpa using hbound

/-! ## 7. Slash invariance -/

private theorem thetaSeriesUHP8_S_slash :
    thetaSeriesUHP8 ∣[(4 : ℤ)] ModularGroup.S = thetaSeriesUHP8 := by
  ext z
  rw [modular_slash_S_apply]
  have hz0 : (z : ℂ) ≠ 0 := ne_zero z
  have hθS := thetaSeriesUHP8_mk_inv_neg z
  rw [hθS]
  have hcpow : (-(z : ℂ) * Complex.I) ^ (4 : ℂ) = (-(z : ℂ) * Complex.I) ^ (4 : ℕ) :=
    Complex.cpow_natCast _ 4
  have hpow : (-(z : ℂ) * Complex.I) ^ (4 : ℕ) = (z : ℂ) ^ (4 : ℕ) := by
    rw [neg_mul, neg_pow, mul_pow]
    norm_num
  rw [hcpow, hpow]
  have hz4 : ((z : ℂ) ^ (4 : ℕ)) ≠ 0 := pow_ne_zero _ hz0
  field_simp

private theorem thetaSeriesUHP8_T_slash :
    thetaSeriesUHP8 ∣[(4 : ℤ)] ModularGroup.T = thetaSeriesUHP8 := by
  ext z
  simpa [modular_slash_T_apply, thetaSeriesUHP8, add_comm] using
    thetaSeriesUHP8_vadd_one z

/-! ## 8. Modular form assembly -/

/-- The E8 theta series as a slash-invariant form of weight 4. -/
noncomputable def thetaE8_SIF : SlashInvariantForm (CongruenceSubgroup.Gamma 1) 4 where
  toFun := thetaSeriesUHP8
  slash_action_eq' :=
    slashaction_generators_GL2R thetaSeriesUHP8 4
      thetaSeriesUHP8_S_slash thetaSeriesUHP8_T_slash

/-- The E8 theta series as a weight-4 modular form for Γ(1). -/
noncomputable def thetaE8_MF : ModularForm (CongruenceSubgroup.Gamma 1) 4 :=
  { thetaE8_SIF with
    holo' := thetaSeries8_MDifferentiable
    bdd_at_cusps' := fun hc => by
      apply bounded_at_cusps_of_bounded_at_infty (k := (4 : ℤ)) (f := thetaSeriesUHP8) hc
      intro A hA
      rcases hA with ⟨A', rfl⟩
      have hθ_inv : ∀ γ : SL(2, ℤ), thetaSeriesUHP8 ∣[(4 : ℤ)] γ = thetaSeriesUHP8 :=
        slashaction_generators_SL2Z thetaSeriesUHP8 4
          thetaSeriesUHP8_S_slash thetaSeriesUHP8_T_slash
      simpa [ModularForm.SL_slash] using
        congr_arg UpperHalfPlane.IsBoundedAtImInfty (hθ_inv A') ▸ thetaSeriesUHP8_isBoundedAtImInfty }

/-! ## 9. thetaE8_MF = E₄ -/

/-- The theta series tends to 1 as Im z → ∞. -/
theorem thetaSeriesUHP8_tendsto_one :
    Tendsto thetaSeriesUHP8 atImInfty (𝓝 (1 : ℂ)) := by
  let g : E8Lattice → ℂ := fun x => if x = 0 then (1 : ℂ) else 0
  let bound : E8Lattice → ℝ :=
    fun x => Real.exp (-Real.pi * (‖(x : ℝ⁸)‖ ^ 2) * (1 : ℝ))
  have hbound_sum : Summable bound := summable_gaussian8 (a := (1 : ℝ)) (by simp)
  have hterm :
      ∀ x : E8Lattice, Tendsto (fun z : UpperHalfPlane => thetaTerm8 (z : ℂ) x)
        atImInfty (𝓝 (g x)) := by
    intro x
    by_cases hx : x = 0
    · subst x
      simp [g, thetaTerm8]
    · have hxv : (x : ℝ⁸) ≠ 0 := by
        intro hxv
        apply hx
        exact Subtype.ext hxv
      have hnorm_ne : ‖(x : ℝ⁸)‖ ≠ 0 := norm_ne_zero_iff.mpr hxv
      have hnorm_pos : 0 < ‖(x : ℝ⁸)‖ ^ 2 := sq_pos_of_ne_zero hnorm_ne
      have hcoef : -Real.pi * (‖(x : ℝ⁸)‖ ^ 2) < 0 :=
        mul_neg_of_neg_of_pos (neg_lt_zero.mpr Real.pi_pos) hnorm_pos
      have hlim :
          Tendsto
            (fun z : UpperHalfPlane =>
              Real.exp ((-Real.pi * (‖(x : ℝ⁸)‖ ^ 2)) * z.im))
            atImInfty (𝓝 0) :=
        Real.tendsto_exp_atBot.comp
          (Filter.tendsto_im_atImInfty.const_mul_atTop_of_neg hcoef)
      have hzero :
          Tendsto (fun z : UpperHalfPlane => thetaTerm8 (z : ℂ) x)
            atImInfty (𝓝 0) := by
        rw [tendsto_zero_iff_norm_tendsto_zero]
        simpa [norm_thetaTerm8, mul_assoc, mul_left_comm, mul_comm] using hlim
      simpa [g, hx] using hzero
  have h_bound :
      ∀ᶠ z : UpperHalfPlane in atImInfty,
        ∀ x : E8Lattice, ‖thetaTerm8 (z : ℂ) x‖ ≤ bound x := by
    rw [Filter.eventually_atImInfty]
    refine ⟨1, ?_⟩
    intro z hz x
    simpa [bound] using
      (norm_thetaTerm8_le_of_le_im (x := x) (w := (z : ℂ)) (a := (1 : ℝ))
        (by simpa using hz))
  have htsum :
      Tendsto (fun z : UpperHalfPlane => ∑' x : E8Lattice, thetaTerm8 (z : ℂ) x)
        atImInfty (𝓝 (∑' x : E8Lattice, g x)) :=
    tendsto_tsum_of_dominated_convergence hbound_sum hterm h_bound
  have hg_tsum : (∑' x : E8Lattice, g x) = 1 := by
    rw [tsum_eq_single (0 : E8Lattice)]
    · simp [g]
    · intro x hx
      simp [g, hx]
  simpa [thetaSeriesUHP8, thetaSeries8, hg_tsum] using htsum

/-- The E8 theta modular form equals E₄. -/
theorem thetaE8_MF_eq_E4 : thetaE8_MF = E₄ := by
  symm
  let diff : ModularForm (CongruenceSubgroup.Gamma 1) 4 := E₄ - thetaE8_MF
  have hdiff0 : Tendsto (fun z : UpperHalfPlane => diff z) atImInfty (𝓝 (0 : ℂ)) := by
    have hE4 := tendsto_E₄_atImInfty
    have hθ := thetaSeriesUHP8_tendsto_one
    have : Tendsto (fun z => E₄ z - thetaE8_MF z) atImInfty (𝓝 (1 - 1 : ℂ)) :=
      hE4.sub hθ
    simpa [sub_self] using this
  have hdiff_cusp : IsCuspForm (CongruenceSubgroup.Gamma 1) 4 diff := by
    rw [IsCuspForm_iff_coeffZero_eq_zero, ModularFormClass.qExpansion_coeff]
    simp only [Nat.factorial_zero, Nat.cast_one, inv_one, iteratedDeriv_zero, one_mul]
    exact UpperHalfPlane.IsZeroAtImInfty.cuspFunction_apply_zero hdiff0
      (by norm_num : (0 : ℝ) < 1)
  exact sub_eq_zero.mp (by simpa [diff] using
    IsCuspForm_weight_lt_eq_zero 4 (by norm_num) diff hdiff_cusp)

/-- The function values of thetaE8_MF. -/
theorem thetaE8_MF_apply (z : UpperHalfPlane) :
    thetaE8_MF z = thetaSeriesUHP8 z := rfl

end CodeLatticeE8.SPL
