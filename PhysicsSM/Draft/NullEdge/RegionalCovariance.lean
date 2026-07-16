import Mathlib

/-!
# Exact regional covariance bookkeeping

This draft module records the finite identity used by the A44 regional
causal-operator branch. The square of a regional mean is the diagonal row
contribution plus every ordered off-diagonal pair contribution. Therefore a
same-graph average cannot be assigned independent-row error bars unless the
off-diagonal term is separately controlled.

The responses and finite pivot set are supplied. This file proves no
causal-set probability law, effective sample size, or unconditional
concentration theorem. The final results instead give a conditional covariance
bound when an explicit dependency graph and entrywise bounds have already been
proved for the supplied ordered covariance ledger.

The dependency-degree proof was returned by Aristotle project
`24bb1a3f-a6b2-4f6e-9e9a-2e24a2b1f92c` and reviewed locally without changing
its hypotheses.

Claim grade: `M [comp]` for the finite identities and conditional probability
theorem. No causal-set concentration or continuum theorem is claimed.
-/

namespace PhysicsSM.Draft.NullEdge.RegionalCovariance

open MeasureTheory ProbabilityTheory
open scoped BigOperators

noncomputable section

/-- The unnormalized square of a finite response sum splits into diagonal and
ordered off-diagonal pair contributions. -/
theorem sum_sq_eq_diagonal_add_offDiagonal
    {ι : Type*} [DecidableEq ι]
    (pivots : Finset ι) (response : ι → ℝ) :
    (∑ i ∈ pivots, response i) ^ 2 =
      (∑ i ∈ pivots, (response i) ^ 2) +
      ∑ i ∈ pivots, ∑ j ∈ pivots.erase i, response i * response j := by
  rw [pow_two, Finset.sum_mul_sum]
  calc
    (∑ i ∈ pivots, ∑ j ∈ pivots, response i * response j) =
        ∑ i ∈ pivots,
          (response i * response i +
            ∑ j ∈ pivots.erase i, response i * response j) := by
      apply Finset.sum_congr rfl
      intro i hi
      exact (Finset.add_sum_erase pivots
        (fun j => response i * response j) hi).symm
    _ = (∑ i ∈ pivots, response i * response i) +
          ∑ i ∈ pivots, ∑ j ∈ pivots.erase i,
            response i * response j := by
      rw [Finset.sum_add_distrib]
    _ = (∑ i ∈ pivots, (response i) ^ 2) +
          ∑ i ∈ pivots, ∑ j ∈ pivots.erase i,
            response i * response j := by
      congr 1
      apply Finset.sum_congr rfl
      intro i _
      ring

/-- Dividing by the squared pivot count gives the exact decomposition of the
squared uniform regional mean. The identity also holds for the empty set under
Lean's totalized division, although the intended application uses a nonempty
pivot set. -/
theorem regionalMean_sq_eq_diagonal_add_offDiagonal
    {ι : Type*} [DecidableEq ι]
    (pivots : Finset ι) (response : ι → ℝ) :
    ((∑ i ∈ pivots, response i) / (pivots.card : ℝ)) ^ 2 =
      (∑ i ∈ pivots, (response i) ^ 2) / (pivots.card : ℝ) ^ 2 +
      (∑ i ∈ pivots, ∑ j ∈ pivots.erase i,
        response i * response j) / (pivots.card : ℝ) ^ 2 := by
  rw [div_pow, sum_sq_eq_diagonal_add_offDiagonal]
  ring

/-! ## Conditional dependency-degree bound -/

/-- Ordered covariance contribution of an equal-weight mean. -/
def averageCovariance (m : Nat) (C : Fin m → Fin m → ℝ) : ℝ :=
  (∑ i, ∑ j, C i j) / (m : ℝ) ^ 2

/-- Variance scale implied by a maximum dependency degree and covariance
ratio. This is only a bound once the hypotheses of
`averageCovariance_le_of_dependency` have been established. -/
def dependencyVarianceBound
    (m degree : Nat) (sigmaSq kappa : ℝ) : ℝ :=
  sigmaSq * (1 + (degree : ℝ) * kappa) / (m : ℝ)

/-- The conservative dependency graph when every row reads shared global
information: every other pivot is a neighbor. -/
def completeNeighbors (m : Nat) (i : Fin m) : Finset (Fin m) :=
  Finset.univ.erase i

/-- A complete self-excluding dependency graph has degree `m - 1`. -/
theorem completeNeighbors_card {m : Nat} (i : Fin m) :
    (completeNeighbors m i).card = m - 1 := by
  simp [completeNeighbors]

/-- With complete dependence, the degree bound separates into a persistent
neighbor-covariance term and a diagonal `1 / m` term. Thus this bound alone
can certify concentration only when the supplied covariance ratio also
decays (or vanishes). -/
theorem dependencyVarianceBound_complete
    {m : Nat} (hm : 0 < m) (sigmaSq kappa : ℝ) :
    dependencyVarianceBound m (m - 1) sigmaSq kappa =
      sigmaSq * kappa + sigmaSq * (1 - kappa) / (m : ℝ) := by
  have hm1 : 1 ≤ m := hm
  simp only [dependencyVarianceBound, Nat.cast_sub hm1, Nat.cast_one]
  field_simp
  ring

/-- Complete dependency still permits concentration when the number of pivots
diverges, the one-row variance scale has a finite limit, and the normalized
cross-covariance bound tends to zero. These are precisely the asymptotic debts
left by the current globally selected A44 regional estimator. -/
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
      Filter.Tendsto (fun n => sigmaSq n * kappa n) Filter.atTop (nhds 0) := by
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

/-- Algebraic normalized-covariance expression obtained from the centered
identity `E[(X-Y)^2] = Var(X) + Var(Y) - 2 Cov(X,Y)`. -/
def normalizedCovarianceFromDifference
    (normalizedVarX normalizedVarY normalizedMeanSquareDifference : ℝ) : ℝ :=
  (normalizedVarX + normalizedVarY - normalizedMeanSquareDifference) / 2

/-- **Conditional coalescing-row obstruction endpoint.** If two normalized
row variances tend to one and their normalized mean-square difference tends to
zero, then their normalized covariance tends to one rather than zero.

The theorem does not prove that deepest A44 pivots coalesce or that the exact
globally selected/tapered residual is stochastically `L2`-continuous under
their displacement. Those are the substantive Poisson/binomial hypotheses. -/
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

/-- A finite ordered covariance ledger is bounded by its diagonal scale and a
maximum dependency degree. Negative covariance outside the declared neighbor
set is retained rather than replaced by an absolute-value bound.

The theorem does not assert that causal rows realize `C`, that a proposed
overlap graph has bounded degree, or that undeclared causal-row covariances are
nonpositive. -/
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
by the supplied ordered covariance ledger. Every probabilistic and geometric
obligation remains a visible hypothesis. -/
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

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.RegionalCovariance.averageCovariance_le_of_dependency' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RegionalCovariance.averageCovariance_le_of_dependency

/-- info: 'PhysicsSM.Draft.NullEdge.RegionalCovariance.dependencyVarianceBound_complete' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RegionalCovariance.dependencyVarianceBound_complete

/-- info: 'PhysicsSM.Draft.NullEdge.RegionalCovariance.dependencyVarianceBound_complete_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RegionalCovariance.dependencyVarianceBound_complete_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.RegionalCovariance.normalizedCovarianceFromDifference_tendsto_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RegionalCovariance.normalizedCovarianceFromDifference_tendsto_one

/-- info: 'PhysicsSM.Draft.NullEdge.RegionalCovariance.dependency_averaged_chebyshev' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RegionalCovariance.dependency_averaged_chebyshev

end

end PhysicsSM.Draft.NullEdge.RegionalCovariance
