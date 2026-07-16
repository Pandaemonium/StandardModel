import Mathlib

/-!
# Complete-dependency covariance-decay criterion

This standalone file isolates the exact asymptotic endpoint for the A44
regional causal-operator covariance audit. It proves no Poisson covariance
estimate. The submitted research task must determine whether the current
globally selected estimator can satisfy `kappa n -> 0`, or whether its
information flow requires redesign.
-/

namespace RegionalCovarianceDecayAudit

noncomputable section

/-- Variance scale implied by a maximum dependency degree and covariance
ratio. -/
def dependencyVarianceBound
    (m degree : Nat) (sigmaSq kappa : ℝ) : ℝ :=
  sigmaSq * (1 + (degree : ℝ) * kappa) / (m : ℝ)

/-- With complete dependence, the degree bound separates into a persistent
neighbor-covariance term and a diagonal `1 / m` term. -/
theorem dependencyVarianceBound_complete
    {m : Nat} (hm : 0 < m) (sigmaSq kappa : ℝ) :
    dependencyVarianceBound m (m - 1) sigmaSq kappa =
      sigmaSq * kappa + sigmaSq * (1 - kappa) / (m : ℝ) := by
  have hm1 : 1 ≤ m := hm
  simp only [dependencyVarianceBound, Nat.cast_sub hm1, Nat.cast_one]
  field_simp
  ring

/-- Complete dependency permits concentration if pivot count diverges, the
one-row variance scale has a finite limit, and normalized cross-covariance
tends to zero. The last premise is the substantive A44 research debt. -/
theorem dependencyVarianceBound_complete_tendsto_zero
    (m : ℕ → ℕ) (sigmaSq kappa : ℕ → ℝ) (sigmaLimit : ℝ)
    (hm_pos : ∀ n, 0 < m n)
    (hm : Filter.Tendsto (fun n => (m n : ℝ)) Filter.atTop Filter.atTop)
    (hsigma : Filter.Tendsto sigmaSq Filter.atTop (nhds sigmaLimit))
    (hkappa : Filter.Tendsto kappa Filter.atTop (nhds 0)) :
    Filter.Tendsto
      (fun n => dependencyVarianceBound (m n) (m n - 1)
        (sigmaSq n) (kappa n))
      Filter.atTop (nhds 0) := by
  have hinv :
      Filter.Tendsto (fun n => ((m n : ℝ))⁻¹) Filter.atTop (nhds 0) :=
    tendsto_inv_atTop_zero.comp hm
  have hfirst :
      Filter.Tendsto (fun n => sigmaSq n * kappa n)
        Filter.atTop (nhds 0) := by
    simpa using hsigma.mul hkappa
  have hnumerator :
      Filter.Tendsto (fun n => sigmaSq n * (1 - kappa n))
        Filter.atTop (nhds (sigmaLimit * (1 - 0))) :=
    hsigma.mul (tendsto_const_nhds.sub hkappa)
  have hsecond :
      Filter.Tendsto
        (fun n => sigmaSq n * (1 - kappa n) * ((m n : ℝ))⁻¹)
        Filter.atTop (nhds 0) := by
    simpa using hnumerator.mul hinv
  have heq :
      (fun n => dependencyVarianceBound (m n) (m n - 1)
        (sigmaSq n) (kappa n)) =
      (fun n => sigmaSq n * kappa n +
        sigmaSq n * (1 - kappa n) * ((m n : ℝ))⁻¹) := by
    funext n
    rw [dependencyVarianceBound_complete (hm_pos n), div_eq_mul_inv]
  rw [heq]
  simpa using hfirst.add hsecond

/-- Algebraic normalized-covariance expression obtained from
`E[(X - Y)^2] = Var(X) + Var(Y) - 2 Cov(X,Y)` for centered variables. -/
def normalizedCovarianceFromDifference
    (normalizedVarX normalizedVarY normalizedMeanSquareDifference : ℝ) : ℝ :=
  (normalizedVarX + normalizedVarY - normalizedMeanSquareDifference) / 2

/-- Conditional obstruction endpoint: if two normalized variances tend to one
and their normalized mean-square difference tends to zero, then their
normalized covariance tends to one, not zero. Applying this to A44 would
still require a genuine Poisson theorem establishing those premises. -/
theorem normalizedCovarianceFromDifference_tendsto_one
    (normalizedVarX normalizedVarY normalizedMeanSquareDifference : ℕ → ℝ)
    (hX : Filter.Tendsto normalizedVarX Filter.atTop (nhds 1))
    (hY : Filter.Tendsto normalizedVarY Filter.atTop (nhds 1))
    (hDifference : Filter.Tendsto normalizedMeanSquareDifference
      Filter.atTop (nhds 0)) :
    Filter.Tendsto
      (fun n => normalizedCovarianceFromDifference
        (normalizedVarX n) (normalizedVarY n)
        (normalizedMeanSquareDifference n))
      Filter.atTop (nhds 1) := by
  simpa [normalizedCovarianceFromDifference] using
    (hX.add hY).sub hDifference |>.div_const 2

end

end RegionalCovarianceDecayAudit
