import CodeLatticeE8.SPL.E8ThetaModular
import CodeLatticeE8.SPL.ShellBridge
import CodeLatticeE8.SPL.QExpansionExtraction

/-!
# Coefficient bridge for the E8 theta-series theorem

This module connects the analytic modular-form identity
`thetaE8_MF_eq_E4` to the Hamming Construction A coefficient formula.

The proof has three steps:

1. Extract q-expansion coefficients of `thetaE8_MF` as SPL `E8Lattice` shell
   counts.
2. Transport those shell counts to the Hamming Construction A integer model via
   `constructionAShellSet_ncard_eq_e8Shell`.
3. Use the modular-form equality `thetaE8_MF_eq_E4` and SPL's `E4_q_exp` to
   identify every coefficient with the normalized Eisenstein coefficient
   `Theta.e4Coeff`.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option linter.unusedSimpArgs false
set_option linter.flexible false
set_option maxHeartbeats 800000

open scoped CongruenceSubgroup RealInnerProductSpace
open SpherePacking.ModularForms

local notation "ℝ⁸" => EuclideanSpace ℝ (Fin 8)

namespace CodeLatticeE8.SPL

/-! ## Construction A coefficient side -/

/-- The semantic Construction A shell count at theta index `n` is the Hamming
weight-distribution convolution coefficient. -/
theorem constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff (n : Nat) :
    Set.ncard (CodeLatticeE8.constructionAShellSet (4 * n)) =
      hammingThetaConvolutionCoeff n := by
  simpa [hammingThetaConvolutionCoeff, weightContribConvolution] using
    CodeLatticeE8.constructionAShellCount_eq_weight_distribution_convolution (4 * n)

/-! ## Q-expansion extraction for `thetaE8_MF` -/

private lemma thetaTerm8_eq_abstract (z : E8Lattice) (τ : ℂ) :
    thetaTerm8 τ z = QExpansionExtraction.thetaTermAbstract τ z := rfl

private instance : Countable E8Lattice := by
  haveI : Module.Finite ℤ E8Lattice := ZLattice.module_finite ℝ E8Lattice
  haveI : Module.Free ℤ E8Lattice := ZLattice.module_free ℝ E8Lattice
  infer_instance

/-- The q-expansion coefficients of `thetaE8_MF` are the SPL E8 shell counts. -/
theorem thetaE8_MF_qExpansion_coeff_eq_e8Shell (n : ℕ) :
    (ModularFormClass.qExpansion (1 : ℝ) thetaE8_MF).coeff n =
      (Set.ncard (e8LatticeShell n) : ℂ) := by
  have hcoeff :=
    ModularFormClass.qExpansion_coeff_eq_intervalIntegral (f := thetaE8_MF) (h := (1 : ℝ))
      zero_lt_one QExpansionExtraction.one_mem_strictPeriods_Gamma1 n zero_lt_one
  simp only [Complex.ofReal_one, one_mul, one_div, inv_one] at hcoeff
  have hrewrite :
      (fun u : ℝ =>
          (Function.Periodic.qParam (1 : ℝ) ((u : ℂ) + Complex.I) ^ n)⁻¹ *
            thetaE8_MF ⟨(u : ℂ) + Complex.I, QExpansionExtraction.im_add_I_pos u⟩) =
        fun u : ℝ =>
          ∑' z : E8Lattice,
            (Function.Periodic.qParam (1 : ℝ) ((u : ℂ) + Complex.I) ^ n)⁻¹ *
              QExpansionExtraction.thetaTermAbstract ((u : ℂ) + Complex.I) z := by
    funext u
    simp only [thetaE8_MF_apply, thetaSeriesUHP8, thetaSeries8, thetaTerm8_eq_abstract]
    exact tsum_mul_left.symm
  rw [hrewrite] at hcoeff
  have hSumm : Summable fun z : E8Lattice =>
      QExpansionExtraction.thetaTermAbstract (Complex.I : ℂ) z := by
    convert summable_thetaTerm8 (by simp : (0 : ℝ) < (Complex.I).im)
  rw [QExpansionExtraction.integral_tsum_swap n hSumm] at hcoeff
  have hterm : ∀ z : E8Lattice,
      (∫ u : ℝ in (0 : ℝ)..1,
        (Function.Periodic.qParam (1 : ℝ) ((u : ℂ) + Complex.I) ^ n)⁻¹ *
          QExpansionExtraction.thetaTermAbstract ((u : ℂ) + Complex.I) z) =
      if ‖(z : ℝ⁸)‖ ^ 2 = 2 * (n : ℝ) then 1 else 0 := by
    intro z
    exact QExpansionExtraction.term_integral_indicator_abstract n z
      (e8_evenNormSq _ z.2)
  simp_rw [hterm] at hcoeff
  rw [hcoeff]
  simpa [e8LatticeShell] using
    QExpansionExtraction.tsum_indicator_eq_ncard
      (QExpansionExtraction.shell_finite (L := E8Lattice) (2 * (n : ℝ)))

/-- The q-expansion coefficients of `thetaE8_MF` are the Hamming convolution
coefficients. -/
theorem thetaE8_MF_qExpansion_coeff_eq_hammingThetaConvolutionCoeff (n : ℕ) :
    (ModularFormClass.qExpansion (1 : ℝ) thetaE8_MF).coeff n =
      (hammingThetaConvolutionCoeff n : ℂ) := by
  rw [thetaE8_MF_qExpansion_coeff_eq_e8Shell n,
    ← constructionAShellSet_ncard_eq_e8Shell n,
    constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff n]

/-! ## Final all-coefficient identity -/

/-- The Hamming Construction A E8 theta coefficient equals the normalized `E4`
coefficient for every `n`. -/
theorem hammingThetaConvolutionCoeff_eq_e4Coeff (n : ℕ) :
    hammingThetaConvolutionCoeff n = Theta.e4Coeff n := by
  have hbridge := thetaE8_MF_qExpansion_coeff_eq_hammingThetaConvolutionCoeff n
  have hMF_eq :
      (ModularFormClass.qExpansion (1 : ℝ) (thetaE8_MF : UpperHalfPlane → ℂ)) =
        (ModularFormClass.qExpansion (1 : ℝ) (E₄ : UpperHalfPlane → ℂ)) := by
    congr 1
    exact congrArg DFunLike.coe thetaE8_MF_eq_E4
  have hE4n := congrFun E4_q_exp n
  have hcoeff_eq : (hammingThetaConvolutionCoeff n : ℂ) =
      (ModularFormClass.qExpansion (1 : ℝ) (E₄ : UpperHalfPlane → ℂ)).coeff n := by
    rw [← hbridge, congr_arg (PowerSeries.coeff n) hMF_eq]
  rw [hE4n] at hcoeff_eq
  unfold Theta.e4Coeff
  by_cases hn : n = 0
  · subst n
    simp at hcoeff_eq ⊢
    exact_mod_cast hcoeff_eq
  · rw [if_neg hn]
    rw [if_neg hn] at hcoeff_eq
    have hsigma : ((ArithmeticFunction.sigma 3 n : ℕ) : ℂ) =
        (Theta.sigma3 n : ℂ) := by
      rw [← Theta.sigma3_eq_mathlib_sigma n]
    rw [hsigma] at hcoeff_eq
    exact_mod_cast hcoeff_eq

/-- The integer formal Hamming Construction A theta series equals the integer
formal Eisenstein `E4` series. -/
theorem thetaSeries_hammingE8_eq_e4Series :
    thetaSeries = e4Series :=
  thetaSeries_hammingE8_eq_e4Series_of_coeff hammingThetaConvolutionCoeff_eq_e4Coeff

end CodeLatticeE8.SPL
