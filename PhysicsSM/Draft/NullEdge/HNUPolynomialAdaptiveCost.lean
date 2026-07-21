import PhysicsSM.Draft.NullEdge.LieTrotterCommutatorBound

/-!
# Polynomial unitary-product cost and the exact HNU exponential word

For complex finite matrices this module proves a skew-Hermitian ordered-product
estimate with no exponential norm penalty, the exact unitary power telescope,
an explicit polynomial schedule arithmetic bound, and an exact depth-eight
two-component HNU exponential word.

## Scope

The results are not yet one massive HNU continuum theorem. The ordered-product
estimate is proved for four-by-four matrices, while the exact HNU word in this
module is the two-by-two massless Weyl endpoint. The doubled chiral embedding,
fixed Dirac-basis conjugation, Pluecker mass exponential, and their joint norm
bound are not composed here. In particular, `hnuPolynomialCoefficient` is an
explicit candidate inserted into the arithmetic schedule; this module does not
derive it as the one-step error coefficient of the live massive walk.

The module therefore replaces the exponential penalty at the abstract unitary
product-formula layer and proves the exact kinetic factorization. It does not
yet certify polynomial cost for the full massive walk, posit a physical
hierarchy of microscopic clocks, or prove an interacting-QFT continuum limit.

## Provenance

Aristotle project `9a553b51-fc39-43dd-85e4-8955746c6573`, task
`be70e2af-3d95-4906-aefc-f7d76e4b5eab`, locally rechecked under the pinned
toolchain on 2026-07-21. The imported commutator identities come from
`LieTrotterCommutatorBound`; the remaining proofs are the verified Aristotle
return. Claim grade M, [comp].
-/

open scoped BigOperators Real Nat Classical Pointwise
open scoped Matrix.Norms.L2Operator
open LieTrotter

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128
set_option relaxedAutoImplicit false
set_option autoImplicit false
set_option grind.warning false

namespace HNUPolynomialAdaptiveCost

abbrev M4 := LieTrotter.M4

/-!
## Polynomial unitary product bounds and HNU schedule

This module certifies approximation cost for a fixed continuum time.  It does
not assert a physical hierarchy of microscopic clocks, and it is not an
interacting-QFT continuum theorem.
-/

noncomputable section

/-- A matrix is skew-Hermitian in the convention used below. -/
def SkewHermitian (A : M4) : Prop := A.conjTranspose = -A

lemma norm_exp_smul_eq_one_of_skewHermitian (A : M4) (t : ℝ)
    (hA : SkewHermitian A) : ‖NormedSpace.exp (t • A)‖ = 1 := by
      convert CStarRing.norm_of_mem_unitary _;
      all_goals try infer_instance;
      convert NormedSpace.exp_mem_unitary_of_mem_skewAdjoint _;
      · exact NormedAlgebra.restrictScalars ℚ ℂ M4;
      · infer_instance;
      · infer_instance;
      · simp_all +decide [ SkewHermitian, skewAdjoint ];
        simp_all +decide [ Matrix.conjTranspose, star ]

/-
Sharp two-factor unitary Lie--Trotter estimate, with no exponential penalty.
-/
theorem skewHermitian_two_factor_bound
    (A B : M4) (eps : ℝ) (heps : 0 ≤ eps)
    (hA : SkewHermitian A) (hB : SkewHermitian B) :
    ‖NormedSpace.exp (eps • A) * NormedSpace.exp (eps • B) -
        NormedSpace.exp (eps • (A + B))‖ ≤
      (eps ^ 2 / 2) * ‖A * B - B * A‖ := by
        -- Apply the integral representation to the two-factor defect.
        have h_integral : NormedSpace.exp (eps • A) * NormedSpace.exp (eps • B) - NormedSpace.exp (eps • (A + B)) =
          ∫ s in (0 : ℝ)..eps, NormedSpace.exp ((eps - s) • (A + B)) * (NormedSpace.exp (s • A) * B - B * NormedSpace.exp (s • A)) * NormedSpace.exp (s • B) := by
            convert exp_mul_exp_sub_exp_add_eq_integral A B eps using 1;
        -- Apply the integral representation to the commutator term.
        have h_comm : ∀ s ∈ Set.Icc (0 : ℝ) eps, ‖NormedSpace.exp (s • A) * B - B * NormedSpace.exp (s • A)‖ ≤ s * ‖A * B - B * A‖ := by
          intro s hs
          have h_comm : NormedSpace.exp (s • A) * B - B * NormedSpace.exp (s • A) = ∫ r in (0 : ℝ)..s, NormedSpace.exp ((s - r) • A) * (A * B - B * A) * NormedSpace.exp (r • A) := by
            convert exp_mul_sub_mul_exp_eq_integral_commutator A B s using 1;
          rw [ h_comm, intervalIntegral.integral_of_le hs.1 ];
          refine' le_trans ( MeasureTheory.norm_integral_le_integral_norm _ ) ( le_trans ( MeasureTheory.integral_mono_of_nonneg _ _ _ ) _ );
          refine' fun r => ‖A * B - B * A‖;
          · exact Filter.Eventually.of_forall fun x => norm_nonneg _;
          · norm_num;
          · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Ioc ] with r hr;
            refine' le_trans ( norm_mul_le _ _ ) _;
            refine' le_trans ( mul_le_mul_of_nonneg_right ( norm_mul_le _ _ ) ( norm_nonneg _ ) ) _;
            rw [ norm_exp_smul_eq_one_of_skewHermitian A ( s - r ) hA, norm_exp_smul_eq_one_of_skewHermitian A r hA ] ; norm_num;
          · norm_num [ hs.1 ];
        -- Apply the norm bound to each term in the integral.
        have h_integral_bound : ∀ s ∈ Set.Icc (0 : ℝ) eps, ‖NormedSpace.exp ((eps - s) • (A + B)) * (NormedSpace.exp (s • A) * B - B * NormedSpace.exp (s • A)) * NormedSpace.exp (s • B)‖ ≤ s * ‖A * B - B * A‖ := by
          intros s hs
          have h_norm : ‖NormedSpace.exp ((eps - s) • (A + B))‖ ≤ 1 ∧ ‖NormedSpace.exp (s • B)‖ ≤ 1 := by
            constructor;
            · convert norm_exp_smul_eq_one_of_skewHermitian ( A + B ) ( eps - s ) _ |> le_of_eq using 1;
              exact Eq.trans ( Matrix.conjTranspose_add _ _ ) ( by rw [ hA, hB ] ; abel1 );
            · convert norm_exp_smul_eq_one_of_skewHermitian B s hB |> le_of_eq using 1;
          refine' le_trans ( norm_mul_le _ _ ) _;
          exact le_trans ( mul_le_mul ( norm_mul_le _ _ ) h_norm.2 ( by positivity ) ( by positivity ) ) ( by nlinarith [ h_comm s hs, norm_nonneg ( NormedSpace.exp ( s • A ) * B - B * NormedSpace.exp ( s • A ) ) ] );
        rw [ h_integral, intervalIntegral.integral_of_le heps ];
        refine' le_trans ( MeasureTheory.norm_integral_le_integral_norm _ ) ( le_trans ( MeasureTheory.integral_mono_of_nonneg _ _ _ ) _ );
        refine' fun s => s * ‖A * B - B * A‖;
        · exact Filter.Eventually.of_forall fun x => norm_nonneg _;
        · exact Continuous.integrableOn_Ioc ( by continuity );
        · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Ioc ] with s hs using h_integral_bound s <| Set.Ioc_subset_Icc_self hs;
        · rw [ ← intervalIntegral.integral_of_le heps ] ; norm_num

/-- Ordered exponential product (the head is the leftmost factor). -/
def orderedExpProduct (eps : ℝ) : List M4 → M4
  | [] => 1
  | A :: As => NormedSpace.exp (eps • A) * orderedExpProduct eps As

/-- Sum of a matrix list. -/
def matrixListSum : List M4 → M4
  | [] => 0
  | A :: As => A + matrixListSum As

/-- Sum of the norms of a matrix list. -/
def matrixNormSum : List M4 → ℝ
  | [] => 0
  | A :: As => ‖A‖ + matrixNormSum As

/-
Finite ordered-product estimate for skew-Hermitian generators.
-/
theorem skewHermitian_ordered_product_bound (As : List M4) (eps : ℝ)
    (heps : 0 ≤ eps) (hAs : ∀ A ∈ As, SkewHermitian A) :
    ‖orderedExpProduct eps As - NormedSpace.exp (eps • matrixListSum As)‖ ≤
      (eps ^ 2 / 2) * matrixNormSum As ^ 2 := by
        induction' As with A As ih;
        · simp +decide [ orderedExpProduct, matrixListSum, matrixNormSum ];
        · -- Let $S = \sum_{A \in As} A$ and $s = \sum_{A \in As} \|A\|$.
          set S : M4 := matrixListSum As
          set s : ℝ := matrixNormSum As
          have hS : SkewHermitian S := by
            have hS : ∀ (As : List M4), (∀ A ∈ As, SkewHermitian A) → SkewHermitian (matrixListSum As) := by
              intro As hAs; induction As <;> simp_all +decide [ SkewHermitian ] ;
              · exact show Matrix.conjTranspose ( 0 : M4 ) = -0 from by ext i j; norm_num;
              · induction ‹List M4› <;> simp_all +decide [ matrixListSum ];
                grind;
            exact hS As fun A hA => hAs A <| List.mem_cons_of_mem _ hA
          have hs : ‖S‖ ≤ s := by
            have hS_norm : ∀ (As : List M4), ‖matrixListSum As‖ ≤ matrixNormSum As := by
              intro As
              induction' As with A As ih
              simp [matrixListSum, matrixNormSum];
              exact le_trans ( norm_add_le _ _ ) ( by simp [ matrixListSum, matrixNormSum ] ; linarith )
            exact hS_norm As;
          -- Split the defect by adding/subtracting $\exp(\epsilon A) \exp(\epsilon S)$.
          have h_split : ‖orderedExpProduct eps (A :: As) - NormedSpace.exp (eps • (A + S))‖ ≤ ‖NormedSpace.exp (eps • A) * (orderedExpProduct eps As - NormedSpace.exp (eps • S))‖ + ‖NormedSpace.exp (eps • A) * NormedSpace.exp (eps • S) - NormedSpace.exp (eps • (A + S))‖ := by
            convert norm_add_le ( NormedSpace.exp ( eps • A ) * ( orderedExpProduct eps As - NormedSpace.exp ( eps • S ) ) ) ( NormedSpace.exp ( eps • A ) * NormedSpace.exp ( eps • S ) - NormedSpace.exp ( eps • ( A + S ) ) ) using 2 ; simp +decide [ mul_sub, orderedExpProduct ];
          -- Bound the first term using the induction hypothesis.
          have h_first : ‖NormedSpace.exp (eps • A) * (orderedExpProduct eps As - NormedSpace.exp (eps • S))‖ ≤ eps^2 / 2 * s^2 := by
            refine' le_trans ( norm_mul_le _ _ ) _;
            rw [ norm_exp_smul_eq_one_of_skewHermitian A eps ( hAs A ( by simp +decide ) ) ] ; nlinarith [ ih fun A hA => hAs A ( by simp +decide [ hA ] ) ];
          -- Bound the second term using the skew-Hermitian two-factor bound.
          have h_second : ‖NormedSpace.exp (eps • A) * NormedSpace.exp (eps • S) - NormedSpace.exp (eps • (A + S))‖ ≤ eps^2 / 2 * ‖A * S - S * A‖ := by
            apply skewHermitian_two_factor_bound A S eps heps (hAs A (by simp)) hS;
          -- Bound the commutator norm by $2 \|A\| \|S\|$.
          have h_comm : ‖A * S - S * A‖ ≤ 2 * ‖A‖ * ‖S‖ := by
            refine' le_trans ( norm_sub_le _ _ ) _;
            linarith [ norm_mul_le A S, norm_mul_le S A ];
          convert h_split.trans ( add_le_add h_first h_second ) |> le_trans <| ?_ using 1;
          rw [ show matrixNormSum ( A :: As ) = ‖A‖ + s by rfl ];
          nlinarith only [ show 0 ≤ eps ^ 2 * ‖A‖ by positivity, show 0 ≤ eps ^ 2 * s by exact mul_nonneg ( sq_nonneg _ ) ( show 0 ≤ s by exact le_trans ( norm_nonneg _ ) hs ), h_comm, hs, norm_nonneg A, norm_nonneg S ]

/-
The resulting exact telescoping estimate for powers of unitary one-step maps.
-/
theorem unitary_power_telescope_bound (U V : M4) (n : ℕ)
    (hU : U ∈ unitary M4) (hV : V ∈ unitary M4) :
    ‖U ^ n - V ^ n‖ ≤ n * ‖U - V‖ := by
      induction' n with n ih;
      · norm_num;
      · -- By the properties of the norm and the induction hypothesis, we have:
        have h_step : ‖U ^ (n + 1) - V ^ (n + 1)‖ ≤ ‖U ^ n - V ^ n‖ * ‖U‖ + ‖V ^ n‖ * ‖U - V‖ := by
          have h_step : ‖U ^ (n + 1) - V ^ (n + 1)‖ ≤ ‖(U ^ n - V ^ n) * U + V ^ n * (U - V)‖ := by
            simp +decide [ pow_succ, mul_sub, sub_mul ];
          exact h_step.trans ( norm_add_le_of_le ( norm_mul_le _ _ ) ( norm_mul_le _ _ ) );
        -- Since $U$ and $V$ are unitary, we have $\|U\| = 1$ and $\|V^n\| = 1$.
        have h_norm_U : ‖U‖ = 1 := by
          convert CStarRing.norm_of_mem_unitary hU
        have h_norm_Vn : ‖V ^ n‖ = 1 := by
          exact CStarRing.norm_of_mem_unitary ( by exact Submonoid.pow_mem _ hV _ );
        simp_all +decide [ add_mul ] ; linarith

/-- A polynomial schedule sufficient for an error coefficient `C` at fixed time. -/
def polynomialSteps (C t : ℝ) (N : ℕ) : ℕ :=
  Nat.ceil (max |t| (C * t ^ 2 * (N + 1 : ℝ))) + 1

lemma polynomialSteps_pos (C t : ℝ) (N : ℕ) : 0 < polynomialSteps C t N := by
  exact Nat.succ_pos _

/-
Abstract fixed-time schedule guarantee.
-/
theorem polynomial_schedule_rate (C t : ℝ) (N : ℕ) :
    C * t ^ 2 / polynomialSteps C t N ≤ 1 / (N + 1 : ℝ) := by
      rw [ div_le_div_iff₀ ] <;> norm_cast <;> norm_num [ polynomialSteps ];
      nlinarith [ Nat.le_ceil ( Max.max |t| ( C * t ^ 2 * ( N + 1 ) ) ), le_max_right |t| ( C * t ^ 2 * ( N + 1 ) ) ]

/-- A candidate polynomial coefficient for a future kinetic-plus-mass composition.\nNo theorem in this module identifies it with the live massive walk's one-step error. -/
def hnuPolynomialCoefficient (R M : ℝ) : ℝ := (R + M) ^ 2 / 2

/-
At `R_N = 3(N+1)`, fixed mass bound `M`, and fixed time `t`, this explicit
cubic real bound controls the common schedule.
-/
theorem polynomialSteps_changing_window_cubic (M t : ℝ) (N : ℕ) :
    (polynomialSteps (hnuPolynomialCoefficient (3 * (N + 1 : ℝ)) M) t N : ℝ) ≤
      |t| + (((3 * (N + 1 : ℝ) + M) ^ 2 / 2) * t ^ 2 * (N + 1)) + 2 := by
        unfold polynomialSteps hnuPolynomialCoefficient;
        norm_num [ max_def ];
        split_ifs;
        · linarith [ Nat.ceil_lt_add_one ( show 0 ≤ ( 3 * ( N + 1 ) + M ) ^ 2 / 2 * t ^ 2 * ( N + 1 ) by positivity ), abs_nonneg t ];
        · nlinarith [ Nat.ceil_lt_add_one ( abs_nonneg t ), show 0 ≤ ( 3 * ( N + 1 ) + M ) ^ 2 / 2 * t ^ 2 * ( N + 1 ) by positivity ]


/-! ## Exact two-component HNU exponential word -/

open Complex

abbrev M2 := Matrix (Fin 2) (Fin 2) ℂ

def sigma1 : M2 := !![0, 1; 1, 0]
def sigma2 : M2 := !![0, -I; I, 0]
def sigma3 : M2 := !![1, 0; 0, -1]
def qAbs (q : Fin 3 → ℝ) : ℝ := |q 0| + |q 1| + |q 2|

def hnuFourGenerators (q : Fin 3 → ℝ) : List M2 :=
  [(-(I : ℂ) * (q 0 / 2)) • sigma1, (-(I : ℂ) * (q 2 / 4)) • sigma3,
   (-(I : ℂ) * (q 1 / 2)) • sigma2, (-(I : ℂ) * (q 2 / 4)) • sigma3]
def hnuEightGenerators (q : Fin 3 → ℝ) : List M2 := hnuFourGenerators q ++ hnuFourGenerators q

def matrixListSum2 : List M2 → M2 | [] => 0 | A :: As => A + matrixListSum2 As
def matrixNormSum2 : List M2 → ℝ | [] => 0 | A :: As => ‖A‖ + matrixNormSum2 As
def orderedExpProduct2 (eps : ℝ) : List M2 → M2
  | [] => 1 | A :: As => NormedSpace.exp (eps • A) * orderedExpProduct2 eps As

theorem hnuEightGenerators_sum (q : Fin 3 → ℝ) :
    matrixListSum2 (hnuEightGenerators q) =
      (-(I : ℂ)) • ((q 0 : ℂ) • sigma1 + (q 1 : ℂ) • sigma2 + (q 2 : ℂ) • sigma3) := by
        unfold hnuEightGenerators; norm_num [ matrixListSum2 ] ;
        unfold hnuFourGenerators matrixListSum2; norm_num [ Fin.sum_univ_three ] ; ring;
        ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ matrixListSum2 ] <;> ring

theorem hnuEightGenerators_norm_sum (q : Fin 3 → ℝ) :
    matrixNormSum2 (hnuEightGenerators q) = qAbs q := by
      unfold hnuEightGenerators;
      unfold hnuFourGenerators; norm_num [ matrixNormSum2 ] ; ring;
      norm_num [ norm_smul, qAbs ];
      rw [ show ‖sigma1‖ = 1 by
            refine' le_antisymm _ _;
            · refine' ContinuousLinearMap.opNorm_le_bound _ zero_le_one fun x => _;
              norm_num [ EuclideanSpace.norm_eq, sigma1 ];
              exact Real.sqrt_le_sqrt ( by linarith! );
            · refine' le_csInf _ _ <;> norm_num;
              · refine' ⟨ 1, _, _ ⟩ <;> norm_num [ EuclideanSpace.norm_eq ];
                norm_num [ sigma1, Matrix.mulVec ];
                exact fun x => Real.sqrt_le_sqrt <| by linarith!;
              · intro b hb h; specialize h ( EuclideanSpace.single 0 1 ) ; norm_num [ EuclideanSpace.norm_eq, Matrix.toEuclideanLin ] at h;
                exact le_trans ( by norm_num [ sigma1 ] ) h, show ‖sigma2‖ = 1 by
                                        refine' le_antisymm _ _ <;> norm_num [ Matrix.norm_def, sigma2 ];
                                        · refine' ContinuousLinearMap.opNorm_le_bound _ zero_le_one fun x => _;
                                          simp +decide [ Matrix.toEuclideanLin, EuclideanSpace.norm_eq ];
                                          exact Real.sqrt_le_sqrt ( by linarith! );
                                        · refine' le_csInf _ _ <;> norm_num [ Matrix.mulVec, dotProduct, EuclideanSpace.norm_eq ];
                                          · exact ⟨ 1, ⟨ by norm_num, fun x => by rw [ add_comm, one_mul ] ⟩ ⟩;
                                          · intro b hb h; specialize h ( EuclideanSpace.single 0 1 ) ; norm_num at h;
                                            linarith, show ‖sigma3‖ = 1 by
                                                                    refine' le_antisymm _ _;
                                                                    · refine' ContinuousLinearMap.opNorm_le_bound _ zero_le_one fun x => _;
                                                                      norm_num [ EuclideanSpace.norm_eq, sigma3 ];
                                                                      rfl;
                                                                    · refine' le_csInf _ _ <;> norm_num [ sigma3 ];
                                                                      · refine' ⟨ 1, _, _ ⟩ <;> norm_num [ EuclideanSpace.norm_eq ];
                                                                        exact fun x => le_rfl;
                                                                      · intro b hb h; specialize h ( EuclideanSpace.single 0 1 ) ; norm_num [ EuclideanSpace.norm_eq ] at h;
                                                                        linarith ] ; ring

def hnuRotation (sigma : M2) (theta : ℝ) : M2 :=
  (Real.cos theta : ℂ) • (1 : M2) - (I * (Real.sin theta : ℂ)) • sigma

theorem exp_pauli_generator (sigma : M2) (theta : ℝ) (hsq : sigma * sigma = 1) :
    NormedSpace.exp ((-(I : ℂ) * theta) • sigma) = hnuRotation sigma theta := by
      -- By definition of exponentiation of a matrix, we have:
      have h_exp.eq : NormedSpace.exp ((-I * (theta : ℂ)) • sigma) = ∑' n : ℕ, ((-I * (theta : ℂ)) ^ n / (n ! : ℂ)) • sigma ^ n := by
        convert NormedSpace.exp_eq_tsum using 3 ; ring;
        constructor;
        intro h;
        convert NormedSpace.exp_eq_tsum;
        intro h; rw [ h ℂ ] ; ext n; norm_num [ mul_pow, mul_assoc, mul_comm, mul_left_comm ] ;
        rw [ tsum_congr fun n => ?_ ];
        rw [ neg_pow ] ; norm_num [ mul_pow, mul_assoc, mul_comm, mul_left_comm, smul_pow ] ; ring;
        simp +decide [ mul_assoc, mul_left_comm, smul_smul ];
        simp +decide [ mul_assoc, mul_comm, mul_left_comm, Algebra.smul_def ];
      -- Separate the series into even and odd terms.
      have h_split : ∑' n : ℕ, ((-I * (theta : ℂ)) ^ n / (n ! : ℂ)) • sigma ^ n = (∑' n : ℕ, ((-I * (theta : ℂ)) ^ (2 * n) / ((2 * n)! : ℂ)) • (1 : M2)) + (∑' n : ℕ, ((-I * (theta : ℂ)) ^ (2 * n + 1) / ((2 * n + 1)! : ℂ)) • sigma) := by
        rw [ ← tsum_even_add_odd ];
        · norm_num [ pow_add, pow_mul, hsq ];
          norm_num [ show sigma ^ 2 = 1 by rw [ pow_two, hsq ] ];
        · -- The series $\sum_{k=0}^{\infty} \frac{(-I \theta)^{2k}}{(2k)!}$ is the Taylor series for $\cos(\theta)$, which converges.
          have h_cos_series : Summable (fun k : ℕ => ((-I * (theta : ℂ)) ^ (2 * k) / ((2 * k)! : ℂ))) := by
            exact Summable.of_norm <| by simpa using Real.summable_pow_div_factorial _ |> Summable.comp_injective <| by intro m n h; simpa using h;
          convert h_cos_series.smul_const ( 1 : M2 ) using 2 ; norm_num [ pow_mul, hsq ];
          simp_all +decide [ pow_succ, mul_assoc ];
        · -- The series $\sum_{k=0}^{\infty} \frac{(-I \theta)^{2k+1}}{(2k+1)!} \sigma^{2k+1}$ is absolutely convergent.
          have h_abs_conv : Summable (fun k : ℕ => ‖((-I * (theta : ℂ)) ^ (2 * k + 1) / ((2 * k + 1)! : ℂ)) • sigma ^ (2 * k + 1)‖) := by
            -- Since $\sigma^2 = 1$, we have $\|\sigma^{2k+1}\| = \|\sigma\|$ for all $k$.
            have h_sigma_norm : ∀ k : ℕ, ‖sigma ^ (2 * k + 1)‖ ≤ ‖sigma‖ := by
              intro k; induction k <;> simp_all +decide [ Nat.mul_succ, pow_succ, pow_mul ] ;
            norm_num [ norm_smul, h_sigma_norm ];
            exact Summable.of_nonneg_of_le ( fun k => mul_nonneg ( div_nonneg ( pow_nonneg ( abs_nonneg _ ) _ ) ( Nat.cast_nonneg _ ) ) ( norm_nonneg _ ) ) ( fun k => mul_le_mul_of_nonneg_left ( h_sigma_norm k ) ( div_nonneg ( pow_nonneg ( abs_nonneg _ ) _ ) ( Nat.cast_nonneg _ ) ) ) ( Summable.mul_right _ <| Real.summable_pow_div_factorial _ |> Summable.comp_injective <| by intro m n h; simpa using h );
          exact h_abs_conv.of_norm;
      -- Recognize that the series for the even terms is the Taylor series for $\cos(\theta)$ and the series for the odd terms is the Taylor series for $\sin(\theta)$.
      have h_cos_sin : (∑' n : ℕ, ((-I * (theta : ℂ)) ^ (2 * n) / ((2 * n)! : ℂ))) = Complex.cos (theta : ℂ) ∧ (∑' n : ℕ, ((-I * (theta : ℂ)) ^ (2 * n + 1) / ((2 * n + 1)! : ℂ))) = -Complex.I * Complex.sin (theta : ℂ) := by
        constructor;
        · rw [ Complex.cos_eq_tsum ] ; congr ; ext n ; norm_num [ pow_mul, mul_pow ] ; ring;
        · rw [ Complex.sin_eq_tsum ];
          rw [ ← tsum_mul_left ] ; congr ; ext n ; norm_num [ pow_add, pow_mul, mul_pow ] ; ring;
      simp_all +decide [ hnuRotation ];
      rw [ Summable.tsum_smul_const, Summable.tsum_smul_const ] ; aesop; all_goals exact Summable.of_norm <| by simpa using Real.summable_pow_div_factorial _ |> Summable.comp_injective <| by intro m n h; simpa using h

def hnuFourWord (q : Fin 3 → ℝ) (eps : ℝ) : M2 :=
  hnuRotation sigma1 (eps * q 0 / 2) * hnuRotation sigma3 (eps * q 2 / 4) *
  hnuRotation sigma2 (eps * q 1 / 2) * hnuRotation sigma3 (eps * q 2 / 4)
def hnuEndpoint (q : Fin 3 → ℝ) (eps : ℝ) : M2 := hnuFourWord q eps * hnuFourWord q eps

theorem hnuEndpoint_eq_ordered_exponential_word (q : Fin 3 → ℝ) (eps : ℝ) :
    hnuEndpoint q eps = orderedExpProduct2 eps (hnuEightGenerators q) := by
      unfold hnuEndpoint hnuEightGenerators;
      unfold hnuFourWord hnuFourGenerators orderedExpProduct2;
      -- Apply the exp_pauli_generator theorem to each generator in the list.
      have h1 := exp_pauli_generator sigma1 (eps * q 0 / 2) (by
      ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ sigma1 ])
      have h2 := exp_pauli_generator sigma3 (eps * q 2 / 4) (by
      ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ sigma3 ])
      have h3 := exp_pauli_generator sigma2 (eps * q 1 / 2) (by
      ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ sigma2 ])
      have h4 := exp_pauli_generator sigma3 (eps * q 2 / 4) (by
      ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ sigma3 ]);
      simp_all +decide [ ← mul_assoc, ← smul_assoc, orderedExpProduct2 ];
      grind

end
end HNUPolynomialAdaptiveCost
