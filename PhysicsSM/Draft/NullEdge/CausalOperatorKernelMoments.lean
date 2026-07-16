import Mathlib

/-!
# Exact broad-layer kernel moments and conditional concentration

This draft module records the exact finite polynomial used for the Poisson
second moment of the four-dimensional broad-layer kernel. The key
falling-factorial product identity is kernel-checked. The displayed Poisson and
finite-binomial expressions are definitions of the closed formulas; this file
does not construct a Poisson random variable or prove that a causal-set row has
those laws.

The final Chebyshev theorem is explicitly conditional on a total variance
bound. That bound must include random atoms, finite-population effects, random
two-sided taper depth, and shared-sprinkling covariance. Positive effective
sample size and nonnegative variance scale are visible hypotheses.

Provenance: the broad-layer coefficients follow Benincasa and Dowker,
arXiv:1001.2725. The falling-factorial proof and concentration wrapper were
returned by Aristotle project `bcefd810-9c50-479d-a8b3-d5c1eef964c7` and
semantically tightened during local integration.

Claim grade: `M [comp]` for the finite identities and conditional probability
theorem. No causal-set concentration or continuum theorem is claimed.
-/

namespace PhysicsSM.Draft.NullEdge.CausalOperatorKernelMoments

open MeasureTheory ProbabilityTheory

noncomputable section

/-- Polynomial in the exact Poisson mean of the four-dimensional kernel. -/
def poissonKernelPolynomial (z : ℝ) : ℝ :=
  1 - 9 * z + 8 * z ^ 2 - (4 / 3) * z ^ 3

/-- Broad-layer coefficients in the falling-factorial representation. -/
def broadCoefficient (epsilon : ℝ) : Fin 4 → ℝ
  | ⟨0, _⟩ => 1
  | ⟨1, _⟩ => -9 * epsilon / (1 - epsilon)
  | ⟨2, _⟩ => 8 * epsilon ^ 2 / (1 - epsilon) ^ 2
  | ⟨3, _⟩ => -(4 / 3) * epsilon ^ 3 / (1 - epsilon) ^ 3

/-- Exact finite degree-six polynomial multiplying
`exp(lambda*((1-epsilon)^2-1))` in the one-count Poisson second moment. -/
def poissonSecondMomentPolynomial (lambda epsilon : ℝ) : ℝ :=
  ∑ i : Fin 4, ∑ j : Fin 4,
    ∑ k ∈ Finset.range (min i.val j.val + 1),
      broadCoefficient epsilon i * broadCoefficient epsilon j *
        (Nat.choose i.val k : ℝ) * (Nat.choose j.val k : ℝ) *
        (Nat.factorial k : ℝ) *
        (((1 - epsilon) ^ 2 * lambda) ^ (i.val + j.val - k))

/-- Closed formula for the one-count Poisson second moment. -/
def poissonKernelSecondMoment (lambda epsilon : ℝ) : ℝ :=
  Real.exp (lambda * ((1 - epsilon) ^ 2 - 1)) *
    poissonSecondMomentPolynomial lambda epsilon

/-- Closed formula for the one-count Poisson mean. -/
def poissonKernelMean (lambda epsilon : ℝ) : ℝ :=
  Real.exp (-epsilon * lambda) *
    poissonKernelPolynomial (epsilon * lambda)

/-- Closed formula for the one-count Poisson variance. -/
def poissonKernelVariance (lambda epsilon : ℝ) : ℝ :=
  poissonKernelSecondMoment lambda epsilon -
    poissonKernelMean lambda epsilon ^ 2

/-- Coefficient of the leading small-epsilon variance at fixed
`z=epsilon*lambda`. The asymptotic expansion itself is not proved here. -/
def fixedZVarianceLeadingCoefficient (z : ℝ) : ℝ :=
  Real.exp (-2 * z) * z *
    (4 * z ^ 3 - 36 * z ^ 2 + 75 * z - 30) ^ 2 / 9

/-- The fixed-`z` leading coefficient is nonnegative for nonnegative `z`. -/
theorem fixedZVarianceLeadingCoefficient_nonneg
    {z : ℝ} (hz : 0 ≤ z) :
    0 ≤ fixedZVarianceLeadingCoefficient z := by
  unfold fixedZVarianceLeadingCoefficient
  positivity

/-- Finite-binomial tilted falling-factorial moment formula. -/
def binomialTiltedFallingMoment
    (population order : Nat) (q r : ℝ) : ℝ :=
  (population.descFactorial order : ℝ) * (q * r) ^ order *
    (1 - q + q * r) ^ (population - order)

/-- Exact finite-binomial broad-layer mean formula for fixed population. -/
def binomialKernelMean
    (population : Nat) (q epsilon : ℝ) : ℝ :=
  ∑ i : Fin 4,
    broadCoefficient epsilon i *
      binomialTiltedFallingMoment population i.val q (1 - epsilon)

/-- Product of two descending factorials, grouped by the number of shared
selected elements. -/
theorem fallingFactorial_product_identity (N i j : Nat) :
    N.descFactorial i * N.descFactorial j =
      ∑ k ∈ Finset.range (min i j + 1),
        Nat.choose i k * Nat.choose j k * Nat.factorial k *
          N.descFactorial (i + j - k) := by
  have h_desc_factorial : ∀ (N i j : ℕ), Nat.descFactorial N i * Nat.descFactorial N j = ∑ k ∈ Finset.range (min i j + 1), Nat.choose i k * Nat.choose j k * Nat.factorial k * Nat.descFactorial N (i + j - k) := by
    intro N i j;
    by_contra h_contra;
    have h_lhs : (N.descFactorial i) * (N.descFactorial j) = (Nat.factorial i) * (Nat.factorial j) * (Nat.choose N i) * (Nat.choose N j) := by
      rw [ Nat.descFactorial_eq_factorial_mul_choose, Nat.descFactorial_eq_factorial_mul_choose ] ; ring;
    have h_rhs : ∑ k ∈ Finset.range (min i j + 1), Nat.choose i k * Nat.choose j k * Nat.factorial k * (Nat.descFactorial N (i + j - k)) = Nat.factorial i * Nat.factorial j * ∑ k ∈ Finset.range (min i j + 1), (Nat.choose N (i + j - k)) * (Nat.choose (i + j - k) i) * (Nat.choose i k) := by
      rw [ Finset.mul_sum _ _ _ ] ; refine' Finset.sum_congr rfl fun x hx => _ ; rw [ Nat.descFactorial_eq_factorial_mul_choose ] ; ring_nf;
      rw [ ← Nat.choose_mul_factorial_mul_factorial ( show x ≤ i from Finset.mem_range_succ_iff.mp hx |> le_trans <| min_le_left _ _ ), ← Nat.choose_mul_factorial_mul_factorial ( show i ≤ i + j - x from Nat.le_sub_of_add_le <| by linarith [ Finset.mem_range.mp hx, min_le_right i j ] ) ] ; ring_nf;
      rw [ show j.factorial = j.choose x * x.factorial * ( j - x ).factorial by rw [ ← Nat.choose_mul_factorial_mul_factorial ( show x ≤ j from Finset.mem_range_succ_iff.mp hx |> le_trans <| min_le_right _ _ ) ] ] ; ring_nf;
      rw [ show i + j - x - i = j - x by omega ] ; rw [ show i.factorial = i.choose x * x.factorial * ( i - x ).factorial by rw [ ← Nat.choose_mul_factorial_mul_factorial ( show x ≤ i from Finset.mem_range_succ_iff.mp hx |> le_trans <| min_le_left _ _ ) ] ] ; ring;
    have h_rhs_simplified : ∑ k ∈ Finset.range (min i j + 1), (Nat.choose N (i + j - k)) * (Nat.choose (i + j - k) i) * (Nat.choose i k) = ∑ k ∈ Finset.range (min i j + 1), (Nat.choose N i) * (Nat.choose (N - i) (j - k)) * (Nat.choose i k) := by
      refine' Finset.sum_congr rfl fun k hk => _;
      by_cases hN : N < i + j - k <;> by_cases hN' : N < i <;> simp_all +decide [ Nat.choose_eq_zero_of_lt ];
      · exact Or.inl <| Or.inr <| Nat.choose_eq_zero_of_lt <| by omega;
      · omega;
      · rw [ Nat.choose_mul ];
        · exact Or.inl ( by rw [ show i + j - k - i = j - k by omega ] );
        · omega;
    have h_rhs_final : ∑ k ∈ Finset.range (min i j + 1), (Nat.choose N i) * (Nat.choose (N - i) (j - k)) * (Nat.choose i k) = (Nat.choose N i) * (Nat.choose N j) := by
      have h_rhs_final : ∑ k ∈ Finset.range (min i j + 1), (Nat.choose (N - i) (j - k)) * (Nat.choose i k) = Nat.choose N j := by
        by_cases hN : N < i;
        · simp_all +decide [ Nat.choose_eq_zero_of_lt hN ];
        · rw [ show N = i + ( N - i ) by rw [ Nat.add_sub_cancel' ( le_of_not_gt hN ) ] ] ; simp +decide [ Nat.add_choose_eq ];
          rw [ Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk ];
          rw [ ← Finset.sum_subset ( Finset.range_mono ( Nat.succ_le_succ ( min_le_right i j ) ) ) ] <;> simp +decide [ mul_comm ];
          exact fun x hx₁ hx₂ => if hx₃ : x ≤ i then Or.inr <| Nat.choose_eq_zero_of_lt <| by omega else Or.inl <| Nat.choose_eq_zero_of_lt <| by omega;
      simp +decide only [mul_assoc, ← h_rhs_final, Finset.mul_sum _ _ _];
    exact h_contra ( by rw [ h_lhs, h_rhs, h_rhs_simplified, h_rhs_final ] ; ring );
  exact h_desc_factorial N i j

/-- Conditional concentration for an averaged observable. The variance bound
is the entire geometric obligation and must already include every diagonal,
taper, finite-population, and shared-graph covariance source. -/
theorem conditional_averaged_chebyshev
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    [IsProbabilityMeasure μ]
    (A : Ω → ℝ) (hA : MemLp A 2 μ)
    (sigmaSq mEff delta : ℝ)
    (hsigmaSq : 0 ≤ sigmaSq) (hmEff : 0 < mEff)
    (hdelta : 0 < delta)
    (hvar : variance A μ ≤ sigmaSq / mEff) :
    μ {ω | delta ≤ |A ω - μ[A]|} ≤
      ENNReal.ofReal ((sigmaSq / mEff) / delta ^ 2) := by
  have hratio : 0 ≤ sigmaSq / mEff :=
    div_nonneg hsigmaSq hmEff.le
  rw [← max_eq_left hratio] at hvar ⊢
  convert ProbabilityTheory.meas_ge_le_variance_div_sq hA hdelta |> le_trans <| ENNReal.ofReal_le_ofReal ( ?_ ) using 1;
  gcongr

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CausalOperatorKernelMoments.fallingFactorial_product_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CausalOperatorKernelMoments.fallingFactorial_product_identity

/-- info: 'PhysicsSM.Draft.NullEdge.CausalOperatorKernelMoments.conditional_averaged_chebyshev' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CausalOperatorKernelMoments.conditional_averaged_chebyshev

end

end PhysicsSM.Draft.NullEdge.CausalOperatorKernelMoments
