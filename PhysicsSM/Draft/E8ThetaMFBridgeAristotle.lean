import PhysicsSM.Draft.E8ThetaDim8MF
import PhysicsSM.Draft.E8SpherePackingImported
import PhysicsSM.Draft.E8ThetaSPLBridge
import PhysicsSM.Draft.E8ThetaMFBridgeHelper
import PhysicsSM.Draft.E8ShellBridgeNoNativeAristotle
import PhysicsSM.Draft.E8QExpansionExtraction
import PhysicsSM.Draft.HammingWeightEnumeratorNoNativeAristotle

/-!
# Bridge: E8ThetaDim8MF → hammingThetaConvolutionCoeff_eq_e4Coeff

This file bridges the s o r r y-free theorem `thetaE8_MF_eq_E4` (in `E8ThetaDim8MF`)
to the project-side Hamming Construction A coefficient formula.

## Architecture

The proof chains three results:

1. **`thetaE8_MF_eq_E4`** (s o r r y-free in `E8ThetaDim8MF`): the E8 theta
   modular form equals E₄.
2. **Q-expansion extraction** (proved via `E8QExpansionExtraction`): the
   q-expansion coefficients of `thetaE8_MF` equal the E8Lattice shell counts.
3. **Shell count bridge** (proved via `E8ShellBridgeNoNativeAristotle`): the
   E8Lattice shell counts equal the Construction A shell counts
   (`hammingThetaConvolutionCoeff`) without `n a t i v e _ d e c i d e`.

From (2) and (3): `qExpansion(thetaE8_MF).coeff n = hammingThetaConvolutionCoeff n`.
From (1): `qExpansion(thetaE8_MF) = qExpansion(E₄)`, which has known coefficients.
Therefore `hammingThetaConvolutionCoeff n = if n = 0 then 1 else 240 * sigma3 n`.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option maxHeartbeats 400000

open scoped CongruenceSubgroup RealInnerProductSpace
open PhysicsSM.Coding PhysicsSM.Coding.E8ThetaSPLBridge
open PhysicsSM.Coding.E8ThetaDim8
open PhysicsSM.Draft.E8SpherePackingImported
open SpherePacking.ModularForms

local notation "ℝ⁸" => EuclideanSpace ℝ (Fin 8)

namespace PhysicsSM.Coding.E8ThetaMFBridge

/-! ## Shell count bridge -/

/--
Shell count bridge: the number of Construction A lattice vectors with
integer squared norm `4n` equals the number of E8Lattice vectors with
EuclideanSpace squared norm `2n`.

**Proof strategy** (from existing infrastructure in `E8SpherePackingImported`):
1. `constructionAToE8Equiv : (Fin 8 → ℤ) ≃ₗ[ℤ] ↥(Submodule.E8 ℝ)` bijects
   coefficient vectors with E8 lattice vectors.
2. `constructionAToE8_norm_sq` gives `φ(c) ⬝ φ(c) = cᵀ · e8ScaledGramQ · c`.
3. Since `e8ScaledGramQ = e8CodeBasisGram / 2` and
  `cᵀ · e8CodeBasisGram · c = sqNorm(∑ cᵢ bᵢ)`, we get `‖φ(c)‖² = sqNorm(v)/2`.
4. So `sqNorm(v) = 4n ↔ ‖φ(c)‖² = 2n`, giving a shell-to-shell bijection.
-/
theorem constructionAShellSet_ncard_eq_e8Shell (n : ℕ) :
    Set.ncard (constructionAShellSet (4 * n)) =
      Set.ncard {w : E8Lattice | ‖(w : ℝ⁸)‖ ^ 2 = 2 * (n : ℝ)} := by
  simpa [E8ShellBridge.constructionAShellSetLocal, constructionAShellSet] using
    E8ShellBridge.constructionAShellSetLocal_ncard_eq_e8Shell_no_native n

/-! ## Q-expansion coefficient extraction -/

/--
The q-expansion coefficients of the E8 theta modular form `thetaE8_MF`
equal the shell counts of `E8Lattice`.

The proof adapts the SPL blueprint from dimension 24 / coefficient 2
(`qExpansion_coeff_two_thetaSeries_eq_thetaCoeff`) to dimension 8 / all
coefficients:
1. Express `(qExpansion 1 thetaE8_MF).coeff n` as `∫₀¹ q⁻ⁿ θ(u+i) du`
   via `qExpansion_coeff_eq_intervalIntegral`.
2. Rewrite θ as `∑' z, exp(πi‖z‖²(u+i))`.
3. Swap sum and integral (dominated convergence, using Gaussian summability).
4. Each term integrates to `1` if `‖z‖² = 2n`, `0` otherwise (by
   `∫₀¹ exp(2πi(m-n)u) du = δ_{m,n}`).
5. Sum the indicator to get the shell count.
-/
private lemma thetaTerm8_eq_abstract (z : E8Lattice) (τ : ℂ) :
    thetaTerm8 τ z = E8QExpansionExtraction.thetaTermAbstract τ z := rfl

private instance : Countable E8Lattice := by
  haveI : Module.Finite ℤ E8Lattice := ZLattice.module_finite ℝ E8Lattice
  haveI : Module.Free ℤ E8Lattice := ZLattice.module_free ℝ E8Lattice
  infer_instance

theorem thetaE8_MF_qExpansion_coeff_eq_e8Shell (n : ℕ) :
    (ModularFormClass.qExpansion (1 : ℝ) thetaE8_MF).coeff n =
      (Set.ncard {w : E8Lattice | ‖(w : ℝ⁸)‖ ^ 2 = 2 * (n : ℝ)} : ℂ) := by
  have hcoeff :=
    ModularFormClass.qExpansion_coeff_eq_intervalIntegral (f := thetaE8_MF) (h := (1 : ℝ))
      zero_lt_one E8QExpansionExtraction.one_mem_strictPeriods_Gamma1 n zero_lt_one
  simp only [Complex.ofReal_one, one_mul, one_div, inv_one] at hcoeff
  have hrewrite :
      (fun u : ℝ =>
          (Function.Periodic.qParam (1 : ℝ) ((u : ℂ) + Complex.I) ^ n)⁻¹ *
            thetaE8_MF ⟨(u : ℂ) + Complex.I, E8QExpansionExtraction.im_add_I_pos u⟩) =
        fun u : ℝ =>
          ∑' z : E8Lattice,
            (Function.Periodic.qParam (1 : ℝ) ((u : ℂ) + Complex.I) ^ n)⁻¹ *
              E8QExpansionExtraction.thetaTermAbstract ((u : ℂ) + Complex.I) z := by
    funext u
    simp only [thetaE8_MF_apply, thetaSeriesUHP8, thetaSeries8, thetaTerm8_eq_abstract]
    exact tsum_mul_left.symm
  rw [hrewrite] at hcoeff
  have hSumm : Summable fun z : E8Lattice =>
      E8QExpansionExtraction.thetaTermAbstract (Complex.I : ℂ) z := by
    convert summable_thetaTerm8 (by simp : (0 : ℝ) < (Complex.I).im)
  rw [E8QExpansionExtraction.integral_tsum_swap n hSumm] at hcoeff
  have hterm : ∀ z : E8Lattice,
      (∫ u : ℝ in (0 : ℝ)..1,
        (Function.Periodic.qParam (1 : ℝ) ((u : ℂ) + Complex.I) ^ n)⁻¹ *
          E8QExpansionExtraction.thetaTermAbstract ((u : ℂ) + Complex.I) z) =
      if ‖(z : ℝ⁸)‖ ^ 2 = 2 * (n : ℝ) then 1 else 0 := by
    intro z
    exact E8QExpansionExtraction.term_integral_indicator_abstract n z
      (e8_evenNormSq _ z.2)
  simp_rw [hterm] at hcoeff
  rw [hcoeff]
  exact E8QExpansionExtraction.tsum_indicator_eq_ncard (E8QExpansionExtraction.shell_finite _)

/-! ## Combined bridge and main formula -/

/-! ### No-native Construction A convolution bridge

The public theorem
`constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff` currently routes
through the original Hamming weight-support theorem, whose proof used
`n a t i v e _ d e c i d e`.  For the modular-form bridge we use the no-native Hamming
support theorem from `HammingWeightEnumeratorNoNativeAristotle` instead.
-/

private theorem sum_filter_weight_eq_no_native (F : Nat → Nat) (w : Nat) :
    (hammingCodewords.filter (fun c => hammingWeight c = w)).sum
      (fun c => F (hammingWeight c)) =
    (hammingCodewords.filter (fun c => hammingWeight c = w)).card * F w := by
  rw [Finset.card_eq_sum_ones, Finset.sum_mul]
  exact Finset.sum_congr rfl fun x hx => by
    simp only [Finset.mem_filter] at hx
    rw [hx.2]
    ring

private theorem hammingCodewords_weight_trichotomy_no_native {c : BinaryVector 8}
    (hc : c ∈ hammingCodewords) :
    hammingWeight c = 0 ∨ hammingWeight c = 4 ∨ hammingWeight c = 8 := by
  exact extendedHamming8_weight_support_no_native c
    (Finset.mem_filter.mp hc).2

private theorem hammingCodewords_eq_weight_union_no_native :
    hammingCodewords =
      hammingCodewords.filter (fun c => hammingWeight c = 0) ∪
      hammingCodewords.filter (fun c => hammingWeight c = 4) ∪
      hammingCodewords.filter (fun c => hammingWeight c = 8) := by
  ext c
  simp only [Finset.mem_union, Finset.mem_filter]
  constructor
  · intro hc
    rcases hammingCodewords_weight_trichotomy_no_native hc with h | h | h
    · exact Or.inl (Or.inl ⟨hc, h⟩)
    · exact Or.inl (Or.inr ⟨hc, h⟩)
    · exact Or.inr ⟨hc, h⟩
  · rintro ((⟨hc, -⟩ | ⟨hc, -⟩) | ⟨hc, -⟩) <;> exact hc

private theorem hammingCodewords_sum_by_weight_classes_no_native (F : Nat → Nat) :
    hammingCodewords.sum (fun c => F (hammingWeight c)) =
      extendedHamming8WeightDist 0 * F 0 +
      extendedHamming8WeightDist 4 * F 4 +
      extendedHamming8WeightDist 8 * F 8 := by
  conv_lhs => rw [hammingCodewords_eq_weight_union_no_native]
  have d04 : Disjoint (hammingCodewords.filter (fun c => hammingWeight c = 0))
                       (hammingCodewords.filter (fun c => hammingWeight c = 4)) :=
    Finset.disjoint_filter.mpr fun _ _ h0 h4 => absurd (h0.symm.trans h4) (by omega)
  have d048 : Disjoint
    (hammingCodewords.filter (fun c => hammingWeight c = 0) ∪
     hammingCodewords.filter (fun c => hammingWeight c = 4))
    (hammingCodewords.filter (fun c => hammingWeight c = 8)) := by
    rw [Finset.disjoint_union_left]
    exact ⟨Finset.disjoint_filter.mpr fun _ _ h0 h8 =>
             absurd (h0.symm.trans h8) (by omega),
           Finset.disjoint_filter.mpr fun _ _ h4 h8 =>
             absurd (h4.symm.trans h8) (by omega)⟩
  rw [Finset.sum_union d048, Finset.sum_union d04,
      sum_filter_weight_eq_no_native, sum_filter_weight_eq_no_native,
      sum_filter_weight_eq_no_native,
      hammingCodewords_filter_weight_card, hammingCodewords_filter_weight_card,
      hammingCodewords_filter_weight_card]

theorem constructionAShellCount_eq_weight_distribution_convolution_no_native
    (s : Nat) :
    Set.ncard (constructionAShellSet s) =
      extendedHamming8WeightDist 0 * weightContribConvolution 0 s +
      extendedHamming8WeightDist 4 * weightContribConvolution 4 s +
      extendedHamming8WeightDist 8 * weightContribConvolution 8 s := by
  rw [constructionAShellCount_eq_codeword_convolution]
  exact hammingCodewords_sum_by_weight_classes_no_native
    (fun w => weightContribConvolution w s)

theorem constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff_no_native (n : Nat) :
    Set.ncard (constructionAShellSet (4 * n)) =
      hammingThetaConvolutionCoeff n := by
  simpa [hammingThetaConvolutionCoeff] using
    constructionAShellCount_eq_weight_distribution_convolution_no_native (4 * n)

/--
The q-expansion coefficients of `thetaE8_MF` match the Hamming Construction A
convolution coefficients.
-/
theorem thetaE8_MF_qExpansion_coeff_eq_hammingThetaConvolutionCoeff (n : ℕ) :
    (ModularFormClass.qExpansion (1 : ℝ) thetaE8_MF).coeff n =
      (hammingThetaConvolutionCoeff n : ℂ) := by
  rw [thetaE8_MF_qExpansion_coeff_eq_e8Shell n,
      ← constructionAShellSet_ncard_eq_e8Shell n,
      constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff_no_native n]

/--
The all-coefficient E8 representation formula, proved via the E8 theta
modular form.

Proof structure:
1. From `thetaE8_MF_qExpansion_coeff_eq_hammingThetaConvolutionCoeff`:
   `qExpansion(thetaE8_MF).coeff n = hammingThetaConvolutionCoeff n`.
2. From `thetaE8_MF_eq_E4`: `qExpansion(thetaE8_MF) = qExpansion(E₄)`.
3. From `E4_q_exp`: `qExpansion(E₄).coeff n = if n=0 then 1 else 240*sigma3 n`.
4. Therefore `hammingThetaConvolutionCoeff n = if n=0 then 1 else 240*sigma3 n`.
-/
theorem hammingThetaConvolutionCoeff_eq_e4Coeff_via_MF (n : ℕ) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n := by
  -- Step 1: qExpansion of thetaE8_MF at n = hammingThetaConvolutionCoeff n
  have hbridge := thetaE8_MF_qExpansion_coeff_eq_hammingThetaConvolutionCoeff n
  -- Step 2: thetaE8_MF = E₄, so their q-expansions agree
  have hMF_eq : (ModularFormClass.qExpansion (1 : ℝ) (thetaE8_MF : UpperHalfPlane → ℂ)) =
      (ModularFormClass.qExpansion (1 : ℝ) (E₄ : UpperHalfPlane → ℂ)) := by
    congr 1
    exact congrArg DFunLike.coe thetaE8_MF_eq_E4
  -- Step 3: E₄ q-expansion coefficients
  have hE4n := congrFun E4_q_exp n
  -- Step 4: chain: hammingThetaConvolutionCoeff n = E₄ coeff at n
  have hcoeff_eq : (hammingThetaConvolutionCoeff n : ℂ) =
      (ModularFormClass.qExpansion (1 : ℝ) (E₄ : UpperHalfPlane → ℂ)).coeff n := by
    rw [← hbridge, congr_arg (PowerSeries.coeff n) hMF_eq]
  rw [hE4n] at hcoeff_eq
  by_cases hn : n = 0
  · subst hn; simp at hcoeff_eq; exact_mod_cast hcoeff_eq.symm
  · rw [if_neg hn]
    rw [if_neg hn] at hcoeff_eq
    have hsigma : ((ArithmeticFunction.sigma 3 n : ℕ) : ℂ) = (sigma3 n : ℂ) := by
      rw [← sigma3_eq_mathlib_sigma n]
    rw [hsigma] at hcoeff_eq
    exact_mod_cast hcoeff_eq

end PhysicsSM.Coding.E8ThetaMFBridge
