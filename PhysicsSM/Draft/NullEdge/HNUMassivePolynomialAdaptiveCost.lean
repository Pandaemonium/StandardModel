import PhysicsSM.Draft.NullEdge.HNUPolynomialAdaptiveCost
import PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction
import PhysicsSM.Draft.NullEdge.MC2BlockExponentialLift

/-!
# Polynomial adaptive cost for the live massive HNU walk

This module composes the sharp unitary product-formula theorem with the actual
doubled HNU/Pluecker walk. The central theorems compare `massiveWend` itself
with `massiveEflow`; they do not substitute a parallel standalone
factorization.

The conservative coefficient below allows a factor two on the doubled kinetic
block. A sharper `(R + M)^2 / 2` coefficient is welcome if exact block-norm and
unitary-conjugation identities support it.

The result is a fixed-time finite-matrix approximation-cost theorem. It does
not select the supplied Pluecker mass, prove an interacting continuum limit,
or interpret the schedule as a hierarchy of physical clocks.

The composition was completed and locally checked by Codex on 2026-07-21 while
Aristotle project `7f197b23-b63d-48c0-83e7-8d746f0db0a0` remained in proof
search. The independent return is retained for adversarial comparison rather
than treated as the source of the local proofs.
-/

noncomputable section

open Matrix Complex
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.HNUMassivePolynomialAdaptiveCost

open HNUPlueckerMassiveStay
open HNUMassiveContinuumReduction
open HNUManyStepContinuum
open Pluecker3Plus1ComplexMass

/-- Conservative product-formula coefficient for a momentum envelope `R` and
mass envelope `M`. -/
def massivePolynomialCoefficient (R M : Real) : Real := (2 * R + M) ^ 2 / 2

/-- The exact two-component endpoint used by the live massive construction is
the same phase-cancelled eight-exponential word proved in the polynomial-cost
module. -/
theorem liveWend_eq_hnuEndpoint (q : Fin 3 → Real) (eps : Real) :
    Wend q eps = HNUPolynomialAdaptiveCost.hnuEndpoint q eps := by
  rw [Wend, endpoint_eq_Msq]
  rfl

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex
abbrev M4 := Matrix (Fin 4) (Fin 4) Complex

/-- Opposite-chirality block lift of a two-component generator. -/
def chiralGeneratorLift (A : M2) : M4 := MC2.blockDiag A (-A)

/-- The same generator in the fixed live Dirac basis. -/
def diracGeneratorLift (A : M2) : M4 :=
  diracBasis * chiralGeneratorLift A * diracBasis.conjTranspose

/-- The eight paired `q` and `-q` generators of the live doubled kinetic word. -/
def massiveKineticGenerators (q : Fin 3 → Real) : List M4 :=
  (HNUPolynomialAdaptiveCost.hnuEightGenerators q).map diracGeneratorLift

/-- Pluecker mass generator followed by the exact doubled kinetic word. -/
def massiveOrderedGenerators (z : Complex) (q : Fin 3 → Real) : List M4 :=
  ((-(I : Complex)) • mass4 z) :: massiveKineticGenerators q

lemma exp_chiralGeneratorLift (A : M2) (eps : Real) :
    NormedSpace.exp (eps • chiralGeneratorLift A) =
      MC2.blockDiag (NormedSpace.exp (eps • A))
        (NormedSpace.exp (eps • (-A))) := by
  exact MC2Exp.exp_MC2_blockDiag A (-A) eps

lemma exp_diracGeneratorLift (A : M2) (eps : Real) :
    NormedSpace.exp (eps • diracGeneratorLift A) =
      diracBasis * NormedSpace.exp (eps • chiralGeneratorLift A) *
        diracBasis.conjTranspose := by
  exact MC2Exp.exp_unitary_conjugation diracBasis (chiralGeneratorLift A) eps
    diracBasis_unitary

lemma orderedExpProduct_dirac_map (As : List M2) (eps : Real) :
    HNUPolynomialAdaptiveCost.orderedExpProduct eps
        (As.map diracGeneratorLift) =
      diracBasis *
        MC2.blockDiag
          (HNUPolynomialAdaptiveCost.orderedExpProduct2 eps As)
          (HNUPolynomialAdaptiveCost.orderedExpProduct2 eps (As.map (-·))) *
        diracBasis.conjTranspose := by
  have blockDiag_one : MC2.blockDiag (1 : M2) 1 = (1 : M4) := by
    unfold MC2.blockDiag
    rw [Matrix.fromBlocks_one]
    ext i j
    simp [Matrix.reindex_apply, Matrix.one_apply]
  have blockDiag_mul (A B C D : M2) :
      MC2.blockDiag A B * MC2.blockDiag C D =
        MC2.blockDiag (A * C) (B * D) := by
    unfold MC2.blockDiag
    rw [← Matrix.reindexAlgEquiv_apply ℚ Complex,
      ← Matrix.reindexAlgEquiv_apply ℚ Complex,
      ← map_mul, Matrix.fromBlocks_multiply]
    simp
  have basis_cancel : diracBasis.conjTranspose * diracBasis = (1 : M4) :=
    diracBasis_unitary.1
  have conjugate_mul (X Y : M4) :
      (diracBasis * X * diracBasis.conjTranspose) *
          (diracBasis * Y * diracBasis.conjTranspose) =
        diracBasis * (X * Y) * diracBasis.conjTranspose := by
    calc
      _ = diracBasis * X * (diracBasis.conjTranspose * diracBasis) * Y *
          diracBasis.conjTranspose := by noncomm_ring
      _ = diracBasis * (X * Y) * diracBasis.conjTranspose := by
        rw [basis_cancel]
        simp [Matrix.mul_assoc]
  induction As with
  | nil =>
      simp only [List.map_nil, HNUPolynomialAdaptiveCost.orderedExpProduct,
        HNUPolynomialAdaptiveCost.orderedExpProduct2, blockDiag_one]
      simpa only [mul_one] using (diracBasis_unitary.2).symm
  | cons A As ih =>
      rw [List.map_cons, HNUPolynomialAdaptiveCost.orderedExpProduct,
        exp_diracGeneratorLift, exp_chiralGeneratorLift, ih]
      simp only [HNUPolynomialAdaptiveCost.orderedExpProduct2]
      rw [show (List.map (fun x => -x) (A :: As)) =
          (-A) :: List.map (fun x => -x) As by rfl]
      simp only [HNUPolynomialAdaptiveCost.orderedExpProduct2]
      rw [← blockDiag_mul]
      exact conjugate_mul _ _

lemma hnuEightGenerators_neg (q : Fin 3 → Real) :
    (HNUPolynomialAdaptiveCost.hnuEightGenerators q).map (-·) =
      HNUPolynomialAdaptiveCost.hnuEightGenerators (-q) := by
  unfold HNUPolynomialAdaptiveCost.hnuEightGenerators
    HNUPolynomialAdaptiveCost.hnuFourGenerators
  norm_num [neg_div]

lemma blockDiag_Wend_eq_doubled (q : Fin 3 → Real) (eps : Real) :
    MC2.blockDiag (Wend q eps) (Wend (-q) eps) =
      doubledChiralEndpoint (fun i => eps * q i) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [*, MC2.blockDiag, doubledChiralEndpoint] <;> ring
  all_goals simp +decide [Matrix.fromBlocks, finSumFinEquiv]
  all_goals simp +decide [Fin.addCases, Fin.sum_univ_succ, Fin.sum_univ_zero,
    HNUExactCore.endpoint, Wend]

lemma massiveKinetic_product_exact (q : Fin 3 → Real) (eps : Real) :
    HNUPolynomialAdaptiveCost.orderedExpProduct eps (massiveKineticGenerators q) =
      diracHNU (fun i => eps * q i) := by
  unfold massiveKineticGenerators
  rw [orderedExpProduct_dirac_map, hnuEightGenerators_neg,
    ← HNUPolynomialAdaptiveCost.hnuEndpoint_eq_ordered_exponential_word,
    ← HNUPolynomialAdaptiveCost.hnuEndpoint_eq_ordered_exponential_word,
    ← liveWend_eq_hnuEndpoint, ← liveWend_eq_hnuEndpoint,
    blockDiag_Wend_eq_doubled]
  rfl

lemma massiveOrdered_product_exact (z : Complex) (hz : z ≠ 0)
    (q : Fin 3 → Real) (eps : Real) :
    HNUPolynomialAdaptiveCost.orderedExpProduct eps
        (massiveOrderedGenerators z q) = massiveWend z q eps := by
  simp [massiveOrderedGenerators, HNUPolynomialAdaptiveCost.orderedExpProduct]
  rw [massiveKinetic_product_exact, massiveWend]
  unfold massiveHNU
  simp +decide [massCoin4_eq_exp_mass4 z hz, massiveWend]

lemma massiveOrderedGenerators_skew (z : Complex) (q : Fin 3 → Real) :
    ∀ A ∈ massiveOrderedGenerators z q,
      HNUPolynomialAdaptiveCost.SkewHermitian A := by
  intro A hA
  unfold massiveOrderedGenerators at hA
  simp at hA
  rcases hA with (h | h)
  · unfold HNUPolynomialAdaptiveCost.SkewHermitian
    ext i j
    simp +decide [h, mass4]
    ring
    unfold beta5 beta
    fin_cases i <;> fin_cases j <;> norm_num [Matrix.mul_apply, gamma5]
  · obtain ⟨A', hA', rfl⟩ :
        ∃ A', A' ∈ HNUPolynomialAdaptiveCost.hnuEightGenerators q ∧
          A = diracGeneratorLift A' := by
      unfold massiveKineticGenerators at h
      aesop
    have hA'_skew : A'.conjTranspose = -A' := by
      unfold HNUPolynomialAdaptiveCost.hnuEightGenerators at hA'
      simp_all +decide [HNUPolynomialAdaptiveCost.hnuFourGenerators]
      rcases hA' with (rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl) <;>
        norm_num [HNUPolynomialAdaptiveCost.sigma1,
          HNUPolynomialAdaptiveCost.sigma2,
          HNUPolynomialAdaptiveCost.sigma3]
      all_goals
        ext i j
        fin_cases i <;> fin_cases j <;> norm_num [Complex.ext_iff]
    unfold diracGeneratorLift
    simp +decide [hA'_skew, HNUPolynomialAdaptiveCost.SkewHermitian]
    unfold chiralGeneratorLift
    simp +decide [hA'_skew, Matrix.mul_assoc]
    unfold MC2.blockDiag
    simp +decide [hA'_skew, Matrix.mul_assoc]
    ext i j
    simp +decide [Matrix.mul_apply, Matrix.submatrix_apply, finSumFinEquiv]
    simp +decide [Fin.sum_univ_succ, Fin.addCases]
    simp +decide [← Matrix.ext_iff] at hA'_skew ⊢
    grind +splitIndPred

lemma massiveOrderedGenerators_sum (z : Complex) (q : Fin 3 → Real) :
    HNUPolynomialAdaptiveCost.matrixListSum (massiveOrderedGenerators z q) =
      (-(I : Complex)) • (kinetic4 q + mass4 z) := by
  have hDiracAdd : ∀ A B : M2,
      diracGeneratorLift (A + B) =
        diracGeneratorLift A + diracGeneratorLift B := by
    unfold diracGeneratorLift
    simp +decide [Matrix.mul_add, Matrix.add_mul, Matrix.mul_assoc]
    unfold chiralGeneratorLift
    simp +decide [← mul_assoc, ← add_mul, ← mul_add]
    intro A B
    congr
    ext i j
    fin_cases i <;> fin_cases j <;> norm_num [MC2.blockDiag]
    all_goals simp +decide [finSumFinEquiv]
    all_goals simp +decide [Fin.addCases]
    all_goals ring
  have hDiracSum : ∀ l : List M2,
      diracGeneratorLift (List.sum l) =
        List.sum (List.map diracGeneratorLift l) := by
    intro l
    induction l <;> simp +decide [*]
    simpa using hDiracAdd 0 0
  have hKineticSum :
      List.sum (List.map diracGeneratorLift
        (HNUPolynomialAdaptiveCost.hnuEightGenerators q)) =
        diracBasis * chiralGeneratorLift (-I • Hw q) *
          diracBasis.conjTranspose := by
    convert (hDiracSum (HNUPolynomialAdaptiveCost.hnuEightGenerators q)).symm
      using 1
    convert congr_arg
      (fun x => diracBasis * chiralGeneratorLift x * diracBasis.conjTranspose)
      (HNUPolynomialAdaptiveCost.hnuEightGenerators_sum q) using 1
    · convert rfl
      convert HNUPolynomialAdaptiveCost.hnuEightGenerators_sum q using 1
    · convert congr_arg
        (fun x => diracBasis * chiralGeneratorLift x * diracBasis.conjTranspose)
        (HNUPolynomialAdaptiveCost.hnuEightGenerators_sum q) using 1
  convert congr_arg (fun x => (-I : Complex) • mass4 z + x) hKineticSum using 1
  rw [show kinetic4 q =
      diracBasis * chiralKinetic q * diracBasis.conjTranspose from
    (chiralKinetic_conjugate q).symm]
  norm_num [chiralGeneratorLift]
  abel_nf
  unfold chiralKinetic
  norm_num [MC2.blockDiag]
  abel_nf
  ext i j
  norm_num [Matrix.mul_apply, finSumFinEquiv]
  ring
  simp +decide [Fin.sum_univ_succ, Fin.addCases]
  ring

lemma norm_diracGeneratorLift (A : M2) :
    ‖diracGeneratorLift A‖ = ‖A‖ := by
  calc
    ‖diracGeneratorLift A‖ = ‖chiralGeneratorLift A‖ := by
      simpa [diracGeneratorLift] using
        MC2.norm_unitary_conjugation diracBasis (chiralGeneratorLift A)
          diracBasis_unitary
    _ = max ‖A‖ ‖-A‖ := by
      exact MC2.norm_blockDiag A (-A)
    _ = ‖A‖ := by simp

lemma massiveOrderedGenerators_norm_sum_le (z : Complex) (q : Fin 3 → Real) :
    HNUPolynomialAdaptiveCost.matrixNormSum (massiveOrderedGenerators z q) ≤
      2 * qAbs q + ‖z‖ := by
  have hmap : ∀ As : List M2,
      HNUPolynomialAdaptiveCost.matrixNormSum
          (As.map diracGeneratorLift) =
        HNUPolynomialAdaptiveCost.matrixNormSum2 As := by
    intro As
    induction As with
    | nil => rfl
    | cons A As ih =>
        simp only [List.map_cons, HNUPolynomialAdaptiveCost.matrixNormSum,
          HNUPolynomialAdaptiveCost.matrixNormSum2, norm_diracGeneratorLift, ih]
  unfold massiveOrderedGenerators massiveKineticGenerators
  simp only [HNUPolynomialAdaptiveCost.matrixNormSum, norm_smul,
    norm_mass4, hmap,
    HNUPolynomialAdaptiveCost.hnuEightGenerators_norm_sum]
  rw [show ‖-(I : Complex)‖ = 1 by norm_num]
  norm_num
  unfold HNUPolynomialAdaptiveCost.qAbs HNUManyStepContinuum.qAbs
  linarith [abs_nonneg (q 0), abs_nonneg (q 1), abs_nonneg (q 2)]

/-- The actual massive HNU step has a polynomial one-step error envelope.

The proof must factor the live doubled endpoint and exact Pluecker mass coin
into skew-Hermitian exponentials and apply the ordered-product theorem. -/
theorem massive_one_step_polynomial_bound (z : Complex) (hz : z ≠ 0)
    (q : Fin 3 → Real) (eps : Real) (heps : 0 ≤ eps) :
    ‖massiveWend z q eps - massiveEflow z q eps‖ ≤
      massivePolynomialCoefficient (qAbs q) ‖z‖ * eps ^ 2 := by
  have hproduct :=
    HNUPolynomialAdaptiveCost.skewHermitian_ordered_product_bound
      (massiveOrderedGenerators z q) eps heps
      (massiveOrderedGenerators_skew z q)
  rw [massiveOrdered_product_exact z hz,
    massiveOrderedGenerators_sum] at hproduct
  have hflow :
      NormedSpace.exp
          (eps • ((-(I : Complex)) • (kinetic4 q + mass4 z))) =
        massiveEflow z q eps := by
    unfold massiveEflow massiveGenerator
    congr 1
    ext i j
    simp [smul_smul]
    ring
  rw [hflow] at hproduct
  refine hproduct.trans ?_
  have hsum_nonneg :
      0 ≤ HNUPolynomialAdaptiveCost.matrixNormSum
        (massiveOrderedGenerators z q) := by
    induction massiveOrderedGenerators z q with
    | nil => rfl
    | cons A As ih =>
        simp only [HNUPolynomialAdaptiveCost.matrixNormSum]
        positivity
  have henvelope_nonneg : 0 ≤ 2 * qAbs q + ‖z‖ := by
    exact add_nonneg (mul_nonneg (by norm_num) (qAbs_nonneg q)) (norm_nonneg z)
  have hsum := massiveOrderedGenerators_norm_sum_le z q
  have hsquare :
      HNUPolynomialAdaptiveCost.matrixNormSum
          (massiveOrderedGenerators z q) ^ 2 ≤
        (2 * qAbs q + ‖z‖) ^ 2 :=
    (sq_le_sq₀ hsum_nonneg henvelope_nonneg).2 hsum
  unfold massivePolynomialCoefficient
  calc
    eps ^ 2 / 2 *
          HNUPolynomialAdaptiveCost.matrixNormSum
            (massiveOrderedGenerators z q) ^ 2 ≤
        eps ^ 2 / 2 * (2 * qAbs q + ‖z‖) ^ 2 :=
      mul_le_mul_of_nonneg_left hsquare (by positivity)
    _ = (2 * qAbs q + ‖z‖) ^ 2 / 2 * eps ^ 2 := by ring

/-- Fixed-time many-step error with no exponential momentum penalty. -/
theorem massive_many_step_polynomial_bound (z : Complex) (hz : z ≠ 0)
    (q : Fin 3 → Real) (t : Real) (ht : 0 ≤ t) (n : Nat) (hn : 0 < n) :
    ‖(massiveWend z q (t / (n : Real))) ^ n - massiveEflow z q t‖ ≤
      massivePolynomialCoefficient (qAbs q) ‖z‖ * t ^ 2 / (n : Real) := by
  have hstep := massive_one_step_polynomial_bound z hz q
    (t / (n : Real)) (div_nonneg ht (Nat.cast_nonneg n))
  have htelescope :=
    HNUPolynomialAdaptiveCost.unitary_power_telescope_bound
      (massiveWend z q (t / (n : Real)))
      (massiveEflow z q (t / (n : Real))) n
      (massiveWend_mem_unitary z hz q (t / (n : Real)))
      (massiveEflow_mem_unitary z q (t / (n : Real)))
  rw [← massiveEflow_div_pow z q t n hn]
  refine htelescope.trans ?_
  refine (mul_le_mul_of_nonneg_left hstep (Nat.cast_nonneg n)).trans_eq ?_
  field_simp [Nat.cast_ne_zero.mpr hn.ne']

/-- Compact momentum and mass envelopes give one common polynomial bound. -/
theorem massive_compact_envelope_bound (z : Complex) (hz : z ≠ 0)
    (q : Fin 3 → Real) (R M t : Real) (ht : 0 ≤ t)
    (hq : qAbs q ≤ R) (hzM : ‖z‖ ≤ M) (n : Nat) (hn : 0 < n) :
    ‖(massiveWend z q (t / (n : Real))) ^ n - massiveEflow z q t‖ ≤
      massivePolynomialCoefficient R M * t ^ 2 / (n : Real) := by
  refine (massive_many_step_polynomial_bound z hz q t ht n hn).trans ?_
  have hpoint_nonneg : 0 ≤ 2 * qAbs q + ‖z‖ := by
    exact add_nonneg (mul_nonneg (by norm_num) (qAbs_nonneg q)) (norm_nonneg z)
  have henvelope_nonneg : 0 ≤ 2 * R + M := by
    linarith [qAbs_nonneg q, norm_nonneg z]
  have hlinear : 2 * qAbs q + ‖z‖ ≤ 2 * R + M := by
    linarith
  have hsquare : (2 * qAbs q + ‖z‖) ^ 2 ≤ (2 * R + M) ^ 2 :=
    (sq_le_sq₀ hpoint_nonneg henvelope_nonneg).2 hlinear
  unfold massivePolynomialCoefficient
  gcongr

/-- A common microscopic-depth schedule for the live massive walk. -/
def massivePolynomialSteps (R M t : Real) (N : Nat) : Nat :=
  HNUPolynomialAdaptiveCost.polynomialSteps
    (massivePolynomialCoefficient R M) t N

/-- The common schedule drives the actual massive-walk error below
`1 / (N + 1)` on the stated compact envelopes. -/
theorem massive_schedule_error (z : Complex) (hz : z ≠ 0)
    (q : Fin 3 → Real) (R M t : Real) (ht : 0 ≤ t)
    (hq : qAbs q ≤ R) (hzM : ‖z‖ ≤ M) (N : Nat) :
    ‖(massiveWend z q (t / (massivePolynomialSteps R M t N : Real))) ^
          massivePolynomialSteps R M t N - massiveEflow z q t‖ ≤
      1 / (N + 1 : Real) := by
  have hn : 0 < massivePolynomialSteps R M t N := by
    unfold massivePolynomialSteps
    exact HNUPolynomialAdaptiveCost.polynomialSteps_pos _ _ _
  refine (massive_compact_envelope_bound z hz q R M t ht hq hzM
    (massivePolynomialSteps R M t N) hn).trans ?_
  unfold massivePolynomialSteps
  exact HNUPolynomialAdaptiveCost.polynomial_schedule_rate
    (massivePolynomialCoefficient R M) t N

/-- At the changing window `R_N = 3(N+1)`, the conservative common schedule
has an explicit cubic real upper bound. -/
theorem massivePolynomialSteps_changing_window_cubic (M t : Real) (N : Nat) :
    (massivePolynomialSteps (3 * (N + 1 : Real)) M t N : Real) ≤
      |t| + (((6 * (N + 1 : Real) + M) ^ 2 / 2) * t ^ 2 * (N + 1)) + 2 := by
  unfold massivePolynomialSteps HNUPolynomialAdaptiveCost.polynomialSteps
    massivePolynomialCoefficient
  norm_num [max_def]
  rw [show 2 * (3 * (N + 1 : Real)) + M =
      6 * (N + 1 : Real) + M by ring]
  split_ifs
  · linarith [Nat.ceil_lt_add_one
      (show 0 ≤ (6 * (N + 1 : Real) + M) ^ 2 / 2 * t ^ 2 *
        (N + 1) by positivity), abs_nonneg t]
  · nlinarith [Nat.ceil_lt_add_one (abs_nonneg t),
      show 0 ≤ (6 * (N + 1 : Real) + M) ^ 2 / 2 * t ^ 2 *
        (N + 1) by positivity]

/-- Both kinetic and Pluecker mass generators are nonzero in the required
`q = (1,0,0)`, `z = 3+4i` control. -/
theorem massive_polynomial_control_nonzero :
    kinetic4 ![1, 0, 0] ≠ 0 ∧ mass4 (3 + 4 * I) ≠ 0 := by
  exact massive_control_nonzero

end PhysicsSM.Draft.NullEdge.HNUMassivePolynomialAdaptiveCost
