import PhysicsSM.Draft.E8ThetaSPLBridge
import PhysicsSM.Draft.ConstructionAThetaBoundedShellAristotle
import SpherePacking.ModularForms.DimensionFormulas
import PhysicsSM.Draft.E8ThetaMFBridgeAristotle

/-!
# Aristotle target: the remaining E8 theta coefficient formula

This file is a focused handoff after Aristotle job
`9215f082-2baa-4e13-837c-9335ddf88aad`.

That job proved the SPL/Eisenstein side:

* `splThetaE4Series_coeff_eq_e4`;
* `splThetaE4Series_coeff_eq_local_e4`;
* `thetaSeries_eq_e4Series_of_hammingThetaConvolutionCoeff_eq_e4Coeff`.

So the remaining theorem is now purely about the project-side Construction A
coefficient function:

```lean
hammingThetaConvolutionCoeff n =
  if n = 0 then 1 else 240 * sigma3 n
```

Mathematically, this is the E8 theta-series coefficient formula.  Classical
routes include:

1. prove the analytic Construction A theta/weight-enumerator identity and then
   use SPL's `E4 = thetaE4`;
2. prove that the Construction A theta series is a level-one weight-four
   modular form and compare its constant term with `E4`;
3. import a sufficiently strong classical representation-number theorem for
   E8.

This file also contains the s o r r y-free reduction theorem
`hammingThetaConvolutionCoeff_eq_e4Coeff_of_weight4_form`.  It shows that the
main coefficient theorem follows from a single analytic hypothesis: the
Construction A E8 theta function has been constructed as a `ModularForm Γ(1) 4`
whose q-expansion coefficients are the shell-count coefficients
`hammingThetaConvolutionCoeff`.

Please do not weaken the main theorem.  If the full all-`n` proof is out of
reach, useful partial output would be a precise conditional theorem isolating
one-dimensional theta q-expansion facts for `evenLiftCoeff` and `oddLiftCoeff`,
or a formal power-series product theorem showing that the Hamming
weight-enumerator convolution is exactly the q-expansion of SPL's
`thetaE4`.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false
set_option linter.style.setOption false

open scoped CongruenceSubgroup

namespace PhysicsSM.Coding
namespace E8ThetaSPLBridge

/-! ## Sanity checks for the remaining coefficient formula -/

/-- Constant term of the Hamming Construction A convolution. -/
theorem hammingThetaConvolutionCoeff_zero :
    hammingThetaConvolutionCoeff 0 = 1 := by
  calc
    hammingThetaConvolutionCoeff 0 = Set.ncard (constructionAShellSet (4 * 0)) :=
      (constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff 0).symm
    _ = Set.ncard (constructionAShellSet 0) := by norm_num
    _ = shellCountRange5 0 := constructionAShellSet_ncard_eq_shellCountRange5_zero
    _ = 1 := e8ShellCount_zero

/-- First positive coefficient of the Hamming Construction A convolution. -/
theorem hammingThetaConvolutionCoeff_one :
    hammingThetaConvolutionCoeff 1 = 240 * sigma3 1 := by
  calc
    hammingThetaConvolutionCoeff 1 = Set.ncard (constructionAShellSet (4 * 1)) :=
      (constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff 1).symm
    _ = Set.ncard (constructionAShellSet 4) := by norm_num
    _ = shellCountRange5 4 := constructionAShellSet_ncard_eq_shellCountRange5_four
    _ = 240 * sigma3 1 := thetaCoeff_eq_e4Coeff_one

/-- Second positive coefficient of the Hamming Construction A convolution. -/
theorem hammingThetaConvolutionCoeff_two :
    hammingThetaConvolutionCoeff 2 = 240 * sigma3 2 := by
  calc
    hammingThetaConvolutionCoeff 2 = Set.ncard (constructionAShellSet (4 * 2)) :=
      (constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff 2).symm
    _ = Set.ncard (constructionAShellSet 8) := by norm_num
    _ = shellCountRange5 8 := constructionAShellSet_ncard_eq_shellCountRange5_eight
    _ = 240 * sigma3 2 := thetaCoeff_eq_e4Coeff_two

/-- Third positive coefficient of the Hamming Construction A convolution. -/
theorem hammingThetaConvolutionCoeff_three :
    hammingThetaConvolutionCoeff 3 = 240 * sigma3 3 := by
  calc
    hammingThetaConvolutionCoeff 3 = Set.ncard (constructionAShellSet (4 * 3)) :=
      (constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff 3).symm
    _ = Set.ncard (constructionAShellSet 12) := by norm_num
    _ = shellCountRange7 12 := constructionAShellSet_ncard_eq_shellCountRange7_twelve
    _ = 240 * sigma3 3 := thetaCoeff_eq_e4Coeff_three

/--
The coefficient identity is already kernel-checked for the first four
coefficients.  This is not the final theorem, but it is a useful sanity check
for the normalization `theta index n <-> unscaled shell 4*n`.
-/
theorem hammingThetaConvolutionCoeff_le_three (n : Nat) (hn : n <= 3) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n := by
  interval_cases n <;>
    simp [hammingThetaConvolutionCoeff_zero, hammingThetaConvolutionCoeff_one,
      hammingThetaConvolutionCoeff_two, hammingThetaConvolutionCoeff_three]

/-!
Aristotle handoff:

Main goal:
  Prove `hammingThetaConvolutionCoeff_eq_e4Coeff` below.

Definitions:
  * `hammingThetaConvolutionCoeff n` is the three-term Hamming
    weight-distribution convolution at unscaled shell `4*n`.
  * `weightContribConvolution w s` is a finite convolution of the
    one-dimensional parity lift coefficients `evenLiftCoeff` and
    `oddLiftCoeff`.
  * `sigma3 n` is the local sum of cubes of divisors.

Useful proved lemmas:
  * `constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff`;
  * `constructionAShellCount_eq_weight_distribution_convolution`;
  * `splThetaE4Series_coeff_eq_local_e4`;
  * `thetaSeries_eq_e4Series_of_hammingThetaConvolutionCoeff_eq_e4Coeff`;
  * `sigma3_eq_mathlib_sigma`.
  * `hammingThetaConvolutionCoeff_le_three`;
  * `hammingThetaConvolutionCoeff_eq_e4Coeff_of_series_eq`.

Known literature route:
  For a binary Construction A lattice, the theta series is obtained by
  substituting the one-dimensional even/odd theta series into the code's weight
  enumerator.  For the extended Hamming `[8,4,4]` code the weight enumerator is
  `x^8 + 14*x^4*y^4 + y^8`; after Jacobi's identity this is the SPL
  theta-polynomial `H2^2 + H2*H4 + H4^2`, which SPL has already identified
  with `E4`.
-/

/-! ## Coefficient extraction from a full series identity -/

/--
If the project-local formal theta series is already known to equal the
project-local formal `E4` series, then the Hamming Construction A convolution
coefficient formula follows for every `n`.

This is useful for the next proof search because it isolates a second route:
prove the series equality directly by modular forms or by an SPL theta-polynomial
bridge, then extract the combinatorial coefficient statement here.
-/
theorem hammingThetaConvolutionCoeff_eq_e4Coeff_of_series_eq
    (heq : E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series) (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n := by
  have hcoeff := congr_arg (PowerSeries.coeff n) heq
  simp only [E8ThetaAristotle.thetaSeries, E8ThetaAristotle.e4Series,
    PowerSeries.coeff_mk] at hcoeff
  have hconv := constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff n
  have hset_eq :
      {z : Fin 8 -> Int | (e8IntLattice : Set _) z /\ sqNorm z = 4 * (n : Int)} =
        constructionAShellSet (4 * n) := by
    ext z
    simp only [constructionAShellSet, Set.mem_setOf_eq]
    constructor
    case mp =>
      intro h
      exact And.intro h.left (by
        have hs := h.right
        push_cast at hs
        omega)
    case mpr =>
      intro h
      exact And.intro h.left (by
        have hs := h.right
        push_cast at hs
        omega)
  rw [hset_eq] at hcoeff
  rw [hconv] at hcoeff
  by_cases hn : n = 0
  case pos =>
    subst hn
    simp [hammingThetaConvolutionCoeff_zero]
  case neg =>
    rw [if_neg hn] at hcoeff
    rw [if_neg hn]
    exact_mod_cast hcoeff

/-! ## Modular-form reduction -/

/--
Sorry-free reduction of the E8 coefficient formula to a single modular-form
hypothesis.

If there exists a weight-4 level-1 modular form `f` whose q-expansion
coefficients match the Hamming Construction A convolution coefficients, then
the coefficient formula holds for all `n`.

The proof uses the SPL theorem that `M_4(SL2(Z))` is one-dimensional, compares
the constant coefficient to force `f = E4`, and then reads off the q-expansion
of the normalized Eisenstein series.
-/
theorem hammingThetaConvolutionCoeff_eq_e4Coeff_of_weight4_form
    (f : ModularForm Γ(1) 4)
    (hf : ∀ n : Nat, (ModularFormClass.qExpansion (1 : ℝ) f).coeff n =
      (hammingThetaConvolutionCoeff n : ℂ)) :
    ∀ n : Nat, hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n := by
  have hfE4 : f = E₄ := by
    obtain ⟨c, hc⟩ : ∃ c : ℂ, c • E₄ = f :=
      (finrank_eq_one_iff_of_nonzero' E₄ E4_ne_zero).1
        ((Module.rank_eq_one_iff_finrank_eq_one).1 (by
          have := ModularForm.dimension_level_one 4 (by norm_num) ⟨2, rfl⟩
          simp at this
          norm_cast at this)) f
    have hcoeff0 := hf 0
    rw [← hc] at hcoeff0
    have hsmul : c • ModularFormClass.qExpansion (1 : ℝ) (↑E₄ : UpperHalfPlane → ℂ) =
        ModularFormClass.qExpansion (1 : ℝ) (c • ↑(E₄ : ModularForm Γ(1) 4)) := by
      have := qExpansion_smul2 1 c E₄
      push_cast at this
      exact this
    rw [show ModularFormClass.qExpansion (1 : ℝ) (↑(c • E₄ : ModularForm Γ(1) 4)) =
      c • ModularFormClass.qExpansion (1 : ℝ) (↑(E₄ : ModularForm Γ(1) 4))
      from hsmul.symm] at hcoeff0
    simp only [PowerSeries.coeff_smul, E4_q_exp_zero, smul_eq_mul, mul_one] at hcoeff0
    have hc1 : c = 1 := by
      have := hammingThetaConvolutionCoeff_zero
      rw [this] at hcoeff0
      exact_mod_cast hcoeff0
    rw [← hc, hc1, one_smul]
  intro n
  have hfn := hf n
  rw [hfE4] at hfn
  have hE4n := congrFun E4_q_exp n
  rw [hE4n] at hfn
  by_cases hn : n = 0
  · simp [hn, hammingThetaConvolutionCoeff_zero]
  · rw [if_neg hn] at hfn
    rw [if_neg hn]
    have hsigma : ((ArithmeticFunction.sigma 3 n : Nat) : ℂ) = (sigma3 n : ℂ) := by
      rw [← sigma3_eq_mathlib_sigma n]
    rw [hsigma] at hfn
    exact_mod_cast hfn.symm

/-! ## Main remaining theorem -/

/--
All-coefficient E8 representation formula.

For `n = 0`, the coefficient is 1 (the unique zero vector).  For `n > 0`, this
is the classical E8 representation-number formula: the number of lattice
vectors with unscaled Construction A norm `4*n` is `240 * sigma3 n`.

Proved via the rank-8 theta modular form `thetaE8_MF` from `E8ThetaDim8MF`:
1. `thetaE8_MF_eq_E4` shows the E8 theta series equals E₄ (s o r r y-free).
2. The q-expansion extraction + shell count bridge in `E8ThetaMFBridgeAristotle`
   connects the theta Fourier coefficients to `hammingThetaConvolutionCoeff`.
3. Since `thetaE8_MF = E₄`, the q-expansion coefficients match E₄'s.

Uses two proved transport lemmas in `E8ThetaMFBridgeAristotle.lean`:
* `constructionAShellSet_ncard_eq_e8Shell` (shell count bijection)
* `thetaE8_MF_qExpansion_coeff_eq_e8Shell` (q-expansion coefficient extraction)
-/
theorem hammingThetaConvolutionCoeff_eq_e4Coeff (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n :=
  E8ThetaMFBridge.hammingThetaConvolutionCoeff_eq_e4Coeff_via_MF n

/--
Closing theorem: once the coefficient formula above is proved, the project's
integer formal theta series equals its local formal Eisenstein series.
-/
theorem thetaSeries_eq_e4Series_from_hammingThetaConvolutionCoeff :
    E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series :=
  thetaSeries_eq_e4Series_of_hammingThetaConvolutionCoeff_eq_e4Coeff
    hammingThetaConvolutionCoeff_eq_e4Coeff

end E8ThetaSPLBridge
end PhysicsSM.Coding
