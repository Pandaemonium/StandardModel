import Mathlib
import PhysicsSM.Draft.NullEdge.FiniteUniformMaxEntropy
import PhysicsSM.Draft.NullEdge.FiniteGibbsInequality
import PhysicsSM.Draft.NullEdge.ChannelQuadraticSelectorFamily
import PhysicsSM.Draft.NullEdge.ChannelNaturalityNoGo

/-!
# Is there an information-natural selector for the three-channel fibre?

The type-only three-channel fixed-total fibre is affine (see
`ChannelRefinementTorsor`). `ChannelQuadraticSelectorFamily` shows a positive
diagonal quadratic cost picks a unique point of each scalar fibre, that the
fully permutation-symmetric member picks equal thirds, and that a different
positive metric picks the distinct control split `(6/11, 3/11, 2/11)`. This
module asks the pre-registered information-theoretic question: does maximum
Shannon entropy or minimum Kullback–Leibler divergence to a *named uniform
prior* select the equal-third point, and in exactly what sense is that
selector natural?

## Verdict (see the companion memo `afpl_information_selector_memo.md`)

The positive selector exists but is **prior-relative**, not absolute:

* **Positive (prior-relative) selector.** On nonnegative normalized shares,
  equal thirds is the unique maximizer of Shannon entropy
  (`entropy_maximizer_iff_equalThirds`) and, equivalently, the unique
  minimizer of KL divergence to the uniform prior
  (`kl_uniform_zero_iff_equalThirds`, `kl_uniform_eq_logCard_sub_entropy`).
  It coincides with every strictly transverse, fully permutation-symmetric
  quadratic selector (`entropy_selector_eq_symmetric_quadratic`).

* **The prior is load-bearing (honesty kill).** Minimum KL divergence to the
  *skew* prior `(6/11, 3/11, 2/11)` selects that skew prior itself, not equal
  thirds (`skew_kl_minimizer_is_skew`, `equalThirds_not_kl_min_of_skew`).
  The uniform prior does for the KL selector exactly what the symmetric metric
  does for the quadratic selector; indeed the same control point
  `(6/11, 3/11, 2/11)` occurs as both a KL fixed prior and the value of the
  `(1,2,3)`-weighted quadratic selector (`skewPrior_eq_quadratic_selector`).
  So information theory supplies **no** canonical decomposition on its own — it
  supplies a canonical decomposition *given* a reference measure, and the
  reference measure is extra structure.

* **Why entropy escapes the translation no-go.** `ChannelNaturalityNoGo`
  proves that a selector invariant under every zero-sum refinement translation
  is constant, hence cannot select a unique point. Entropy is not such a
  selector: it is *not* invariant under zero-sum shifts of the shares
  (`shannonEntropy_not_constant_on_fibre`). Entropy selects only by breaking
  precisely the symmetry the no-go says a selector must break; it breaks it via
  the affine coordinate/prior structure, which is exactly the extra input.

* **Separation from convexity (deepest kill).** The coincidence of the entropy
  maximizer with the symmetric quadratic minimizer is not a special feature of
  information: both are instances of a strictly concave, permutation-symmetric
  objective on the simplex, and any such objective is maximized at the
  barycenter. `entropy_and_symmetric_quadratic_agree_at_barycenter` records the
  concrete coincidence. The information-theoretic content, over and above
  permutation symmetry plus strict concavity, is only the *choice of prior*.

This module does **not** restate the diagonal quadratic minimizer theorem
(`ChannelQuadraticSelectorFamily.selected_unique_of_cost_le`) or the active
six-coefficient S3 commutator classification
(`ChannelCommutatorSelectorClassification`); it imports and cites them.

Provenance: composition of kernel-checked Paper F information and selector
modules named in the imports. Lean 4.28.0.
-/

noncomputable section

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace PhysicsSM.Draft.NullEdge.ChannelInformationSelectorClassification

open scoped BigOperators
open PhysicsSM.Draft.NullEdge.FiniteUniformMaxEntropy (shannonEntropy)
open PhysicsSM.Draft.NullEdge.FiniteGibbsInequality (relEntropy)
open PhysicsSM.Draft.NullEdge.ChannelQuadraticSelectorFamily
  (selectedX selectedY selectedZ)

/-! ## The named reference measures and witness points -/

/-- The named uniform prior on the three chirality-even channels. -/
def uniformThree : Fin 3 → Real := fun _ => 1 / 3

/-- The skew control prior `(6/11, 3/11, 2/11)`: the exact unequal-metric
control point, reused here as a *reference measure*. -/
def skewPrior : Fin 3 → Real := ![6 / 11, 3 / 11, 2 / 11]

/-- A non-uniform normalized share vector, used to certify that entropy is not
constant on a fixed-total fibre. -/
def skewShares : Fin 3 → Real := ![1 / 2, 1 / 4, 1 / 4]

theorem uniformThree_nonneg : ∀ i, 0 ≤ uniformThree i := by
  intro i; unfold uniformThree; norm_num

theorem uniformThree_pos : ∀ i, 0 < uniformThree i := by
  intro i; unfold uniformThree; norm_num

theorem uniformThree_sum : ∑ i, uniformThree i = 1 := by
  simp [uniformThree, Fin.sum_univ_three]

theorem skewPrior_nonneg : ∀ i, 0 ≤ skewPrior i := by
  intro i; fin_cases i <;> norm_num [skewPrior]

theorem skewPrior_pos : ∀ i, 0 < skewPrior i := by
  intro i; fin_cases i <;> norm_num [skewPrior]

theorem skewPrior_sum : ∑ i, skewPrior i = 1 := by
  simp [skewPrior, Fin.sum_univ_three]; norm_num

theorem skewShares_nonneg : ∀ i, 0 ≤ skewShares i := by
  intro i; fin_cases i <;> norm_num [skewShares]

theorem skewShares_sum : ∑ i, skewShares i = 1 := by
  simp [skewShares, Fin.sum_univ_three]; norm_num

/-! ## Ladder rung 1 — the entropy maximizer is equal thirds -/

/-- Every normalized nonnegative three-channel share vector has Shannon
entropy at most `log 3`. -/
theorem entropy_le_logThree (p : Fin 3 → Real)
    (hp : ∀ i, 0 ≤ p i) (hpsum : ∑ i, p i = 1) :
    shannonEntropy p ≤ Real.log 3 := by
  have hcard : (Fintype.card (Fin 3) : ℝ) = 3 := by simp
  have h := FiniteUniformMaxEntropy.entropy_le_log_card p hp hpsum
  rwa [hcard] at h

/-- On nonnegative normalized shares, Shannon entropy attains its maximum
`log 3` exactly at the equal-thirds point. This is the positive Shannon
selector: the maximizer is unique and equals `(1/3, 1/3, 1/3)`. -/
theorem entropy_maximizer_iff_equalThirds (p : Fin 3 → Real)
    (hp : ∀ i, 0 ≤ p i) (hpsum : ∑ i, p i = 1) :
    shannonEntropy p = Real.log 3 ↔ ∀ i, p i = 1 / 3 := by
  have hcard : (Fintype.card (Fin 3) : ℝ) = 3 := by simp
  have h := FiniteUniformMaxEntropy.entropy_eq_log_card_iff p hp hpsum
  rw [hcard] at h
  rw [h]
  constructor <;> intro hi i <;> have := hi i <;> simpa [one_div] using this

/-- The equal-thirds point achieves the entropy maximum. -/
theorem entropy_uniformThree : shannonEntropy uniformThree = Real.log 3 := by
  exact (entropy_maximizer_iff_equalThirds uniformThree uniformThree_nonneg
    uniformThree_sum).mpr (fun _ => rfl)

/-! ## Ladder rung 2 — minimum KL to the uniform prior is equal thirds -/

/-- KL divergence to the uniform prior is nonnegative (Gibbs). -/
theorem kl_uniform_nonneg (p : Fin 3 → Real)
    (hp : ∀ i, 0 ≤ p i) (hpsum : ∑ i, p i = 1) :
    0 ≤ relEntropy p uniformThree :=
  FiniteGibbsInequality.relEntropy_nonneg p uniformThree hp uniformThree_pos
    hpsum uniformThree_sum

/-- On nonnegative normalized shares, KL divergence to the uniform prior
vanishes exactly at the equal-thirds point: equal thirds is the unique KL
minimizer relative to the uniform prior. -/
theorem kl_uniform_zero_iff_equalThirds (p : Fin 3 → Real)
    (hp : ∀ i, 0 ≤ p i) (hpsum : ∑ i, p i = 1) :
    relEntropy p uniformThree = 0 ↔ ∀ i, p i = 1 / 3 := by
  rw [FiniteGibbsInequality.relEntropy_eq_zero_iff p uniformThree hp
    uniformThree_pos hpsum uniformThree_sum]
  constructor
  · intro h i; exact congrFun h i
  · intro h; funext i; exact h i

/-! ## Ladder rung 3 — the KL/entropy bridge -/

/-- Minimum KL to the uniform prior is the same variational problem as maximum
Shannon entropy: `relEntropy p uniform = log 3 − H(p)`. This is why "minimum KL
to uniform" and "maximum entropy" name the same selector. The identity needs
only normalization, not nonnegativity. -/
theorem kl_uniform_eq_logCard_sub_entropy (p : Fin 3 → Real)
    (hpsum : ∑ i, p i = 1) :
    relEntropy p uniformThree = Real.log 3 - shannonEntropy p := by
  unfold relEntropy shannonEntropy
  unfold uniformThree
  norm_num [Fin.sum_univ_three] at *
  by_cases h0 : p 0 = 0 <;> by_cases h1 : p 1 = 0 <;> by_cases h2 : p 2 = 0 <;>
    simp_all +decide [Real.log_div, Real.log_mul, Real.negMulLog] <;>
    linear_combination hpsum * Real.log 3

/-! ## Ladder rung 4 — coincidence with the symmetric quadratic selector -/

/-- The information selector coincides with every strictly transverse
(`0 < a`), fully permutation-symmetric (`a = b = c`) quadratic selector: both
return equal thirds. -/
theorem entropy_selector_eq_symmetric_quadratic (a : Real) (ha : 0 < a) :
    (selectedX a a a 1, selectedY a a a 1, selectedZ a a a 1)
      = (1 / 3, 1 / 3, 1 / 3) := by
  obtain ⟨hx, hy, hz⟩ :=
    ChannelQuadraticSelectorFamily.symmetric_weights_select_equal_thirds
      (a := a) ha.ne' (s := 1)
  rw [hx, hy, hz]

/-- The entropy maximizer and the symmetric quadratic minimizer agree at the
barycenter of the fibre: both are `(1/3, 1/3, 1/3)`. This records that the
coincidence is not special to information — it is shared by every strictly
concave / strictly convex symmetric objective. -/
theorem entropy_and_symmetric_quadratic_agree_at_barycenter (a : Real)
    (ha : 0 < a) :
    (∀ i, uniformThree i = 1 / 3)
      ∧ (selectedX a a a 1, selectedY a a a 1, selectedZ a a a 1)
          = (1 / 3, 1 / 3, 1 / 3) :=
  ⟨fun _ => rfl, entropy_selector_eq_symmetric_quadratic a ha⟩

/-
**Deepest kill / separation theorem.** Equal thirds is forced by
permutation symmetry plus uniqueness of the maximizer *alone*, with no
appeal to entropy, KL, concavity, or convexity. Any objective `f` invariant
under coordinate relabelling whose maximizer on the fixed-total fibre is
unique must select the barycenter. Hence the equal-thirds output of the
entropy/KL selector is not information-theoretic content: it is exactly what
permutation symmetry delivers once the reference measure is chosen symmetric.
The only genuinely information-theoretic input is the choice of prior.
-/
theorem symmetric_unique_maximizer_is_equalThirds
    (f : (Fin 3 → Real) → Real)
    (hf : ∀ (σ : Equiv.Perm (Fin 3)) (q : Fin 3 → Real), f (q ∘ σ) = f q)
    (p : Fin 3 → Real) (hpsum : ∑ i, p i = 1)
    (huniq : ∀ q, (∑ i, q i = 1) → f q = f p → q = p) :
    ∀ i, p i = 1 / 3 := by
  -- By permutation symmetry, we have $p \circ \sigma = p$ for any permutation $\sigma$.
  have h_perm : ∀ σ : Equiv.Perm (Fin 3), p ∘ σ = p := by
    exact fun σ => huniq _ ( by simpa [ Finset.sum_apply, Equiv.sum_comp ] using hpsum ) ( hf σ p );
  simp_all +decide [ funext_iff, Fin.forall_fin_succ ];
  have := h_perm ( Equiv.swap 0 1 ) ; ( have := h_perm ( Equiv.swap 0 2 ) ; ( have := h_perm ( Equiv.swap 1 2 ) ; ( norm_num [ Fin.sum_univ_three ] at * ; exact ⟨ by linarith !, by linarith !, by linarith ! ⟩ ; ) ) )

/-! ## Ladder rung 5 — the prior is load-bearing (honesty kill) -/

/-- The skew control prior equals the `(1,2,3)`-weighted quadratic selector
output: the *same* point `(6/11, 3/11, 2/11)` is simultaneously a KL reference
measure and the value of an unequal quadratic metric. Prior and metric are the
same kind of extra structure. -/
theorem skewPrior_eq_quadratic_selector :
    (skewPrior 0, skewPrior 1, skewPrior 2)
      = (selectedX 1 2 3 1, selectedY 1 2 3 1, selectedZ 1 2 3 1) := by
  obtain ⟨hx, hy, hz⟩ := ChannelQuadraticSelectorFamily.unequalWeight_selector
  have e0 : skewPrior 0 = 6 / 11 := rfl
  have e1 : skewPrior 1 = 3 / 11 := rfl
  have e2 : skewPrior 2 = 2 / 11 := rfl
  rw [e0, e1, e2, hx, hy, hz]

/-- Minimum KL divergence relative to the skew prior selects the skew prior
itself: its self-divergence is zero. -/
theorem skew_kl_minimizer_is_skew : relEntropy skewPrior skewPrior = 0 :=
  (FiniteGibbsInequality.relEntropy_eq_zero_iff skewPrior skewPrior
    skewPrior_nonneg skewPrior_pos skewPrior_sum skewPrior_sum).mpr rfl

/-- The two named priors are distinct, so the KL selector is genuinely
prior-dependent: the uniform prior is the extra structure that produces equal
thirds. -/
theorem skewPrior_ne_uniformThree : skewPrior ≠ uniformThree := by
  intro h
  have := congrFun h 0
  norm_num [skewPrior, uniformThree] at this

/-- Relative to the skew prior, the equal-thirds point has strictly positive KL
divergence, hence is **not** the KL minimizer. Changing the prior moves the
selected point exactly as changing the quadratic metric does
(`ChannelQuadraticSelectorFamily.positive_quadratic_selectors_disagree`). -/
theorem equalThirds_not_kl_min_of_skew :
    0 < relEntropy uniformThree skewPrior := by
  have hnn := FiniteGibbsInequality.relEntropy_nonneg uniformThree skewPrior
    uniformThree_nonneg skewPrior_pos uniformThree_sum skewPrior_sum
  have hne : relEntropy uniformThree skewPrior ≠ 0 := by
    rw [ne_eq, FiniteGibbsInequality.relEntropy_eq_zero_iff uniformThree skewPrior
      uniformThree_nonneg skewPrior_pos uniformThree_sum skewPrior_sum]
    intro h
    exact skewPrior_ne_uniformThree h.symm
  exact lt_of_le_of_ne hnn (Ne.symm hne)

/-! ## Ladder rung 6 — entropy escapes the translation no-go by breaking it -/

/-- Concrete strict-drop witness: the non-uniform split `(1/2, 1/4, 1/4)` has
strictly smaller entropy than equal thirds, certifying non-invariance under the
zero-sum shift connecting them. -/
theorem skewShares_entropy_lt_uniform :
    shannonEntropy skewShares < shannonEntropy uniformThree := by
  rw [entropy_uniformThree]
  have hle := entropy_le_logThree skewShares skewShares_nonneg skewShares_sum
  have hne : shannonEntropy skewShares ≠ Real.log 3 := by
    rw [ne_eq, entropy_maximizer_iff_equalThirds skewShares skewShares_nonneg
      skewShares_sum]
    intro h
    have := h 0
    norm_num [skewShares] at this
  exact lt_of_le_of_ne hle hne

/-- Entropy is not constant on a fixed-total fibre: two normalized share
vectors related by a nonzero zero-sum shift have different entropy. By
`ChannelNaturalityNoGo.invariant_selector_constant`, any selector invariant
under every zero-sum translation is constant; entropy is not, so it selects
only by using the affine coordinate/prior structure the no-go isolates. -/
theorem shannonEntropy_not_constant_on_fibre :
    ∃ p q : Fin 3 → Real,
      (∑ i, p i = 1) ∧ (∑ i, q i = 1) ∧ shannonEntropy p ≠ shannonEntropy q :=
  ⟨uniformThree, skewShares, uniformThree_sum, skewShares_sum,
    (skewShares_entropy_lt_uniform).ne'⟩

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelInformationSelectorClassification.entropy_maximizer_iff_equalThirds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms entropy_maximizer_iff_equalThirds

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelInformationSelectorClassification.kl_uniform_zero_iff_equalThirds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kl_uniform_zero_iff_equalThirds

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelInformationSelectorClassification.kl_uniform_eq_logCard_sub_entropy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kl_uniform_eq_logCard_sub_entropy

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelInformationSelectorClassification.equalThirds_not_kl_min_of_skew' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms equalThirds_not_kl_min_of_skew

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelInformationSelectorClassification.skewPrior_eq_quadratic_selector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms skewPrior_eq_quadratic_selector

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelInformationSelectorClassification.skewShares_entropy_lt_uniform' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms skewShares_entropy_lt_uniform

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelInformationSelectorClassification.symmetric_unique_maximizer_is_equalThirds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms symmetric_unique_maximizer_is_equalThirds

end PhysicsSM.Draft.NullEdge.ChannelInformationSelectorClassification
