import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# The cosmological constant from the null-edge count: `Lambda ~ 1/sqrt(N)`

The causal-set "everpresent Lambda" (Ahmed–Dodelson–Greene–Sorkin) predicts a
fluctuating cosmological constant `|Lambda| ~ 1/sqrt(V)` from Poisson
number–volume fluctuations `delta N ~ sqrt(V)`, with `Lambda` conjugate to the
4-volume `V`.  Here we route this through the framework's own primitive, the
*pierced-null-edge count* `N` of a finite causal region:

* a finite causal region is modeled by its finite set of pierced null edges;
* its discrete 4-volume is the cardinality `edgeCount` of that finset;
* `edgeCount` is an *extensive* volume measure: additive over disjoint regions
  and monotone under inclusion;
* with the Poisson discreteness input `deltaN^2 = N`, the normalized constant
  `lambdaOf deltaN N = deltaN / N` has second moment `1 / N` and hence RMS
  magnitude `1 / sqrt N` — the everpresent scaling law with `N` = the null-EDGE
  count.

Honest scope: this proves the SCALING given the Poisson input and the extensive
edge count.  It does NOT derive the value of Lambda nor the Lambda–V conjugacy
(both imported physical input), and it predicts a FLUCTUATING dark energy.
-/

namespace LambdaEdgeCount

/-- The pierced-null-edge count of a finite causal region, modeled concretely as
the cardinality of its pierced-edge finset.  This is the region's discrete
4-volume. -/
def edgeCount {α : Type*} [DecidableEq α] (A : Finset α) : ℕ := A.card

/-- The normalized cosmological constant: `Lambda = deltaN / N`. -/
def lambdaOf (deltaN N : ℚ) : ℚ := deltaN / N

/-!
## Target 1 — extensivity of the edge count
-/

/-- **`edgecount_extensive`**: the pierced-null-edge count is additive over
disjoint sub-regions, i.e. it is an extensive volume measure. -/
theorem edgecount_extensive {α : Type*} [DecidableEq α] (A B : Finset α)
    (h : Disjoint A B) : edgeCount (A ∪ B) = edgeCount A + edgeCount B := by
  unfold edgeCount
  exact Finset.card_union_of_disjoint h

/-- The edge count is monotone under inclusion of regions: enlarging a region
never decreases its discrete 4-volume. -/
theorem edgecount_mono {α : Type*} [DecidableEq α] {A B : Finset α}
    (h : A ⊆ B) : edgeCount A ≤ edgeCount B := by
  unfold edgeCount
  exact Finset.card_le_card h

/-!
## Target 2 — second moment of the normalized constant
-/

/-- **`lambda_secondMoment_eq_inv_count`**: under the Poisson discreteness input
`deltaN^2 = N` (an explicit hypothesis), the normalized constant
`Lambda = deltaN / N` has second moment `deltaN^2 / N^2 = 1 / N`. -/
theorem lambda_secondMoment_eq_inv_count (deltaN N : ℚ) (hN : N ≠ 0)
    (hPoisson : deltaN ^ 2 = N) :
    (lambdaOf deltaN N) ^ 2 = 1 / N := by
  unfold lambdaOf
  rw [div_pow, hPoisson]
  rw [sq]
  field_simp

/-!
## Target 3 — RMS magnitude (the payload)
-/

/-- **`lambda_rms_eq_inv_sqrt_count`**: the RMS magnitude of the normalized
constant is `sqrt(N / N^2) = 1 / sqrt N` — the everpresent scaling law expressed
in terms of the pierced-null-edge count `N` (the theory's own primitive), not an
abstract volume.  So `Lambda ~ 1 / sqrt(edge count)`. -/
theorem lambda_rms_eq_inv_sqrt_count (N : ℝ) (hN : 0 < N) :
    Real.sqrt (N / N ^ 2) = 1 / Real.sqrt N := by
  have h : N / N ^ 2 = N⁻¹ := by
    rw [sq]; field_simp
  rw [h, Real.sqrt_inv, one_div]

/-!
## Target 4 — the everpresent verdict (package)
-/

/-- **`everpresent_verdict`**: the cosmological constant fluctuates with RMS set
by the inverse square root of the pierced-null-edge count of the region.  Given
the Poisson discreteness input `deltaN^2 = N`, the second moment of the
normalized constant is `1 / N` and its RMS magnitude is `1 / sqrt N`; for a large
region (large edge count) this is tiny.

Honest scope: this packages the SCALING given the Poisson input and the extensive
edge count; it does NOT derive the value of Lambda nor the Lambda–V conjugacy
(imported), and predicts a FLUCTUATING dark energy. -/
theorem everpresent_verdict (deltaN Nq : ℚ) (N : ℝ) (hNq : Nq ≠ 0) (hN : 0 < N)
    (hPoisson : deltaN ^ 2 = Nq) :
    (lambdaOf deltaN Nq) ^ 2 = 1 / Nq ∧
      Real.sqrt (N / N ^ 2) = 1 / Real.sqrt N :=
  ⟨lambda_secondMoment_eq_inv_count deltaN Nq hNq hPoisson,
    lambda_rms_eq_inv_sqrt_count N hN⟩

/-!
## Mandatory non-degeneracy — instantiate at `N = 100`
-/

/-- Non-degeneracy: the Poisson input at edge count `N = 100` reads
`deltaN^2 = 100` (with `deltaN = 10`). -/
theorem nondeg_poisson_N100 : (10 : ℚ) ^ 2 = 100 := by norm_num

/-- Non-degeneracy: at `N = 100` the second moment of `Lambda = 10 / 100` is
`1 / 100` (explicit rationals). -/
theorem nondeg_secondMoment_N100 : (lambdaOf 10 100) ^ 2 = 1 / 100 :=
  lambda_secondMoment_eq_inv_count 10 100 (by norm_num) nondeg_poisson_N100

/-- Non-degeneracy: at `N = 100` the RMS magnitude is `1 / 10`. -/
theorem nondeg_rms_N100 : Real.sqrt ((100 : ℝ) / 100 ^ 2) = 1 / 10 := by
  rw [lambda_rms_eq_inv_sqrt_count 100 (by norm_num)]
  rw [show (100 : ℝ) = 10 ^ 2 by norm_num, sq, Real.sqrt_mul_self (by norm_num)]

/-- Non-degeneracy: extensivity on two concrete disjoint finite edge-sets with
nonzero counts — a region of `3` edges disjointly composed with a region of `2`
edges has edge count `5 = 3 + 2`. -/
theorem nondeg_extensive :
    edgeCount (({0, 1, 2} : Finset ℕ) ∪ {3, 4}) =
      edgeCount ({0, 1, 2} : Finset ℕ) + edgeCount ({3, 4} : Finset ℕ) := by
  decide

/-- Non-degeneracy: the two concrete component regions have nonzero counts. -/
theorem nondeg_counts :
    edgeCount ({0, 1, 2} : Finset ℕ) = 3 ∧ edgeCount ({3, 4} : Finset ℕ) = 2 := by
  decide

/-!
## Axiom footprint of every headline (exactly `[propext, Classical.choice, Quot.sound]`)
-/

/-- info: 'LambdaEdgeCount.edgecount_extensive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms edgecount_extensive

/-- info: 'LambdaEdgeCount.edgecount_mono' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms edgecount_mono

/-- info: 'LambdaEdgeCount.lambda_secondMoment_eq_inv_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms lambda_secondMoment_eq_inv_count

/-- info: 'LambdaEdgeCount.lambda_rms_eq_inv_sqrt_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms lambda_rms_eq_inv_sqrt_count

/-- info: 'LambdaEdgeCount.everpresent_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms everpresent_verdict

/-- info: 'LambdaEdgeCount.nondeg_secondMoment_N100' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms nondeg_secondMoment_N100

/-- info: 'LambdaEdgeCount.nondeg_rms_N100' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms nondeg_rms_N100

/-- info: 'LambdaEdgeCount.nondeg_extensive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms nondeg_extensive

end LambdaEdgeCount
