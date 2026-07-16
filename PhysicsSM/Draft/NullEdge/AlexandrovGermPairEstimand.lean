import PhysicsSM.Draft.NullEdge.AlexandrovGermPacking
import PhysicsSM.Draft.NullEdge.RegionalCovariance

/-!
# Canonical ordered-pair estimands for separated Alexandrov germs

This module turns the maximum separated-germ ensemble into the population
estimand requested by the A44 covariance audit.  For each maximum packing it
sums an observable over all distinct ordered germ pairs, then averages over
the complete maximum-packing ensemble and divides by the corresponding exact
pair count.  Weighting neither vertices nor a preferred packing requires a
label choice.

The principal observable is the squared difference of two local germ scores.
After normalization by a supplied positive marginal variance, this gives the
finite `q` statistic used in the exact identity

`normalized covariance = 1 - q / 2`

when the two ordered-pair marginals have equal unit normalized variance.  The
definitions are totalized when no distinct pair exists; physical use should
establish a packing-size lower bound of at least two.

The construction and its relabeling identities are finite and exact.  It does
not prove that a chosen stochastic graph law makes separated germ scores
independent, that the marginal variance is positive, or that `q` has a
continuum limit.

Claim grade: `M [orig]` for the finite estimands and covariance identity.
Provenance: program-internal implementation of the selected ordered-pair
estimand recommended by the regional covariance audit.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.AlexandrovGermPairEstimand

open scoped BigOperators

open AlexandrovAlgebraGerm
open AlexandrovGermPacking
open FiniteCausalOrderOperator
open RegionalCovariance

variable {V W : Type*} [Fintype V] [Fintype W]

/-! ## Ordered distinct-pair sums -/

/-- Sum a real observable over all distinct ordered pairs in a finite set. -/
def orderedDistinctPairSum {A : Type*}
    (P : Finset A) (observable : A → A → ℝ) : ℝ := by
  classical
  exact ∑ a ∈ P, ∑ b ∈ P,
    if a = b then 0 else observable a b

/-- Exact number of distinct ordered pairs in a finite set. -/
def orderedDistinctPairCount {A : Type*} (P : Finset A) : Nat :=
  P.card * (P.card - 1)

/-- Ordered distinct-pair sums commute with a carrier equivalence. -/
theorem orderedDistinctPairSum_equiv
    {A B : Type*} (e : A ≃ B) (P : Finset A)
    (observableA : A → A → ℝ) (observableB : B → B → ℝ)
    (hobservable : ∀ a b,
      observableB (e a) (e b) = observableA a b) :
    orderedDistinctPairSum (e.finsetCongr P) observableB =
      orderedDistinctPairSum P observableA := by
  classical
  symm
  unfold orderedDistinctPairSum
  apply Finset.sum_equiv e
  · intro a
    simp [Equiv.finsetCongr_apply]
  · intro a ha
    apply Finset.sum_equiv e
    · intro b
      simp [Equiv.finsetCongr_apply]
    · intro b hb
      by_cases heq : a = b
      · simp [heq]
      · simp [heq, hobservable a b]

/-- The exact ordered-pair count is invariant under carrier equivalence. -/
@[simp] theorem orderedDistinctPairCount_finsetCongr
    {A B : Type*} (e : A ≃ B) (P : Finset A) :
    orderedDistinctPairCount (e.finsetCongr P) =
      orderedDistinctPairCount P := by
  simp [orderedDistinctPairCount]

/-- Relabeling a finite causal order preserves every equivariant ordered-pair
sum on a separated-germ packing. -/
theorem orderedDistinctPairSum_mapPacking
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (P : Finset (MarkedDiamond C))
    (observableC : MarkedDiamond C → MarkedDiamond C → ℝ)
    (observableD : MarkedDiamond D → MarkedDiamond D → ℝ)
    (hobservable : ∀ a b,
      observableD (a.map e) (b.map e) =
        observableC a b) :
    orderedDistinctPairSum (mapPacking e P) observableD =
      orderedDistinctPairSum P observableC := by
  exact orderedDistinctPairSum_equiv (markedDiamondEquiv e) P
    observableC observableD hobservable

/-! ## Canonical maximum-packing pair averages -/

/-- Average an ordered-pair observable over every maximum packing and divide
by the correspondingly averaged exact pair count. -/
def maximumPackingOrderedPairAverage
    (C : FiniteCausalOrder V) (minimumInteriorCount : Nat)
    (observable : MarkedDiamond C → MarkedDiamond C → ℝ) : ℝ :=
  maximumPackingAverage C minimumInteriorCount
      (fun P => orderedDistinctPairSum P observable) /
    maximumPackingAverage C minimumInteriorCount
      (fun P => (orderedDistinctPairCount P : ℝ))

/-- The canonical ordered-pair average of an equivariant observable is a
bare-order invariant. -/
theorem maximumPackingOrderedPairAverage_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (minimumInteriorCount : Nat)
    (observableC : MarkedDiamond C → MarkedDiamond C → ℝ)
    (observableD : MarkedDiamond D → MarkedDiamond D → ℝ)
    (hobservable : ∀ a b,
      observableD (a.map e) (b.map e) =
        observableC a b) :
    maximumPackingOrderedPairAverage D minimumInteriorCount observableD =
      maximumPackingOrderedPairAverage C minimumInteriorCount observableC := by
  unfold maximumPackingOrderedPairAverage
  rw [maximumPackingAverage_equivariant e minimumInteriorCount
    (fun P => orderedDistinctPairSum P observableC)
    (fun P => orderedDistinctPairSum P observableD)]
  · rw [maximumPackingAverage_equivariant e minimumInteriorCount
      (fun P => (orderedDistinctPairCount P : ℝ))
    (fun P => (orderedDistinctPairCount P : ℝ))]
    intro P
    simp [mapPacking, orderedDistinctPairCount]
  · intro P
    exact orderedDistinctPairSum_mapPacking e P
      observableC observableD hobservable

/-! ## Mean-square difference and normalized covariance -/

/-- Canonical selected-pair mean-square difference for a local germ score. -/
def maximumPackingMeanSquareDifference
    (C : FiniteCausalOrder V) (minimumInteriorCount : Nat)
    (score : MarkedDiamond C → ℝ) : ℝ :=
  maximumPackingOrderedPairAverage C minimumInteriorCount
    (fun a b => (score a - score b) ^ 2)

/-- The selected-pair mean-square difference is intrinsic whenever the germ
score itself is intrinsic. -/
theorem maximumPackingMeanSquareDifference_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (minimumInteriorCount : Nat)
    (scoreC : MarkedDiamond C → ℝ) (scoreD : MarkedDiamond D → ℝ)
    (hscore : ∀ A, scoreD (A.map e) = scoreC A) :
    maximumPackingMeanSquareDifference D minimumInteriorCount scoreD =
      maximumPackingMeanSquareDifference C minimumInteriorCount scoreC := by
  apply maximumPackingOrderedPairAverage_equivariant e
    minimumInteriorCount
  intro a b
  rw [hscore a, hscore b]

/-- Mean-square difference normalized by a supplied marginal score variance.
Totalized division records zero variance explicitly. -/
def normalizedMeanSquareDifference
    (C : FiniteCausalOrder V) (minimumInteriorCount : Nat)
    (score : MarkedDiamond C → ℝ) (marginalVariance : ℝ) : ℝ :=
  maximumPackingMeanSquareDifference C minimumInteriorCount score /
    marginalVariance

/-- Equal unit normalized marginal variances convert the selected-pair
mean-square difference into the exact normalized covariance estimand. -/
def normalizedCovarianceEstimand
    (C : FiniteCausalOrder V) (minimumInteriorCount : Nat)
    (score : MarkedDiamond C → ℝ) (marginalVariance : ℝ) : ℝ :=
  RegionalCovariance.normalizedCovarianceFromDifference 1 1
    (normalizedMeanSquareDifference C minimumInteriorCount
      score marginalVariance)

/-- Exact finite identity behind the audit statistic `q`: normalized
covariance is one minus half the normalized mean-square difference. -/
theorem normalizedCovarianceEstimand_eq_one_sub_half
    (C : FiniteCausalOrder V) (minimumInteriorCount : Nat)
    (score : MarkedDiamond C → ℝ) (marginalVariance : ℝ) :
    normalizedCovarianceEstimand C minimumInteriorCount
        score marginalVariance =
      1 - normalizedMeanSquareDifference C minimumInteriorCount
        score marginalVariance / 2 := by
  simp [normalizedCovarianceEstimand,
    RegionalCovariance.normalizedCovarianceFromDifference]
  ring

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.AlexandrovGermPairEstimand.maximumPackingMeanSquareDifference_equivariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AlexandrovGermPairEstimand.maximumPackingMeanSquareDifference_equivariant

/-- info: 'PhysicsSM.Draft.NullEdge.AlexandrovGermPairEstimand.normalizedCovarianceEstimand_eq_one_sub_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AlexandrovGermPairEstimand.normalizedCovarianceEstimand_eq_one_sub_half

end PhysicsSM.Draft.NullEdge.AlexandrovGermPairEstimand
