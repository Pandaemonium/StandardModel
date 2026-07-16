import Mathlib

/-!
# Dependency-degree bound for regional covariance

This standalone draft isolates the conditional finite inequality needed by the
A44 regional causal-operator program. The matrix `C` is intended to be an
ordered covariance matrix after subtracting one finite continuum target per
pivot. The theorem does not assert that causal rows satisfy the displayed
neighbor, degree, or covariance hypotheses.
-/

namespace RegionalCovarianceBound

open MeasureTheory ProbabilityTheory
open scoped BigOperators

noncomputable section

/-- Ordered covariance contribution of the equal-weight mean. -/
def averageCovariance (m : Nat) (C : Fin m → Fin m → ℝ) : ℝ :=
  (∑ i, ∑ j, C i j) / (m : ℝ) ^ 2

/-- Variance scale implied by maximum dependency degree and covariance ratio. -/
def dependencyVarianceBound
    (m degree : Nat) (sigmaSq kappa : ℝ) : ℝ :=
  sigmaSq * (1 + (degree : ℝ) * kappa) / (m : ℝ)

/-- A finite ordered covariance matrix is bounded by its diagonal scale and a
maximum dependency degree. Negative covariance outside the declared neighbor
set is retained rather than replaced by an absolute value. -/
theorem averageCovariance_le_of_dependency
    {m degree : Nat} (hm : 0 < m)
    (C : Fin m → Fin m → ℝ)
    (neighbors : Fin m → Finset (Fin m))
    (sigmaSq kappa : ℝ)
    (hsigmaSq : 0 ≤ sigmaSq) (hkappa : 0 ≤ kappa)
    (hself : ∀ i, i ∉ neighbors i)
    (hdegree : ∀ i, (neighbors i).card ≤ degree)
    (hdiag : ∀ i, C i i ≤ sigmaSq)
    (hneighbor : ∀ i j, j ∈ neighbors i → C i j ≤ kappa * sigmaSq)
    (houtside : ∀ i j, i ≠ j → j ∉ neighbors i → C i j ≤ 0) :
    averageCovariance m C ≤
      dependencyVarianceBound m degree sigmaSq kappa := by
  have h_sum_bound : ∀ i, ∑ j, C i j ≤ sigmaSq + kappa * sigmaSq * degree := by
    intro i
    have h_sum_bound_i : ∑ j ∈ Finset.univ.erase i, C i j ≤ kappa * sigmaSq * degree := by
      have h_sum_bound_i : ∑ j ∈ Finset.univ.erase i, C i j ≤ ∑ j ∈ neighbors i, kappa * sigmaSq := by
        rw [ ← Finset.sum_sdiff ( show neighbors i ⊆ Finset.univ.erase i from fun j hj => Finset.mem_erase_of_ne_of_mem ( by aesop ) ( Finset.mem_univ j ) ) ];
        exact le_trans ( add_le_of_nonpos_left <| Finset.sum_nonpos fun x hx => houtside i x ( by aesop ) <| by aesop ) <| Finset.sum_le_sum fun x hx => hneighbor i x hx;
      exact h_sum_bound_i.trans ( by simpa [ mul_comm ] using mul_le_mul_of_nonneg_left ( Nat.cast_le.mpr ( hdegree i ) ) ( mul_nonneg hkappa hsigmaSq ) );
    rw [ ← Finset.sum_erase_add _ _ ( Finset.mem_univ i ) ] ; linarith [ hdiag i ];
  convert div_le_div_of_nonneg_right ( Finset.sum_le_sum fun i ( hi : i ∈ Finset.univ ) ↦ h_sum_bound i ) ( by positivity : ( 0 :ℝ ) ≤ m ^ 2 ) using 1 ; norm_num [ averageCovariance, dependencyVarianceBound ] ; ring_nf;
  simp +decide [ sq, mul_assoc, hm.ne' ]

/-- Conditional concentration once a physical observable's variance is bounded
by the ordered covariance ledger above. Positivity and every geometric debt are
visible hypotheses. -/
theorem dependency_averaged_chebyshev
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω)
    [IsProbabilityMeasure μ]
    {m degree : Nat} (hm : 0 < m)
    (A : Ω → ℝ) (hA : MemLp A 2 μ)
    (C : Fin m → Fin m → ℝ)
    (neighbors : Fin m → Finset (Fin m))
    (sigmaSq kappa delta : ℝ)
    (hsigmaSq : 0 ≤ sigmaSq) (hkappa : 0 ≤ kappa)
    (hdelta : 0 < delta)
    (hself : ∀ i, i ∉ neighbors i)
    (hdegree : ∀ i, (neighbors i).card ≤ degree)
    (hdiag : ∀ i, C i i ≤ sigmaSq)
    (hneighbor : ∀ i j, j ∈ neighbors i → C i j ≤ kappa * sigmaSq)
    (houtside : ∀ i j, i ≠ j → j ∉ neighbors i → C i j ≤ 0)
    (hvar : variance A μ ≤ averageCovariance m C) :
    μ {ω | delta ≤ |A ω - μ[A]|} ≤
      ENNReal.ofReal
        (dependencyVarianceBound m degree sigmaSq kappa / delta ^ 2) := by
  refine' le_trans _ ( ENNReal.ofReal_le_ofReal _ );
  convert ProbabilityTheory.meas_ge_le_variance_div_sq hA hdelta using 1;
  gcongr;
  exact hvar.trans ( averageCovariance_le_of_dependency hm C neighbors sigmaSq kappa hsigmaSq hkappa hself hdegree hdiag hneighbor houtside )

end

end RegionalCovarianceBound
