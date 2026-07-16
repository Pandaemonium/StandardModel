import Mathlib

/-!
# Classical Shannon subadditivity (finite)

For a finite nonnegative normalized joint distribution `p` on `k x l`, the
Shannon entropy of the joint is at most the sum of the entropies of its two
marginals:

`H(p) <= H(p_1) + H(p_2)`.

The proof constructs the product of the marginals and applies a finite Gibbs
inequality proved directly from `Real.log_le_sub_one_of_pos`. Zero-probability
terms use Mathlib's `Real.log 0 = 0` convention.

## Trust and scope

Draft-trust by kernel: `shannon_subadditivity` is proof-hole-free and depends
only on `[propext, Classical.choice, Quot.sound]`, pinned below. This is standard
finite classical information theory. It is a convenient two-system API and is
not independent evidence for quantum strong subadditivity, holography, gravity,
or a physical coarse-graining channel.

## Provenance

Statement authored in-project during AFPL run 2026-07-12. Proof search by
Aristotle project `66d571db-27d7-4723-a65d-e0ebcb28271d`; the returned statement
was unchanged and the proof was independently replayed under the pinned
toolchain before integration. Clean-room formalization of the standard
relative-entropy proof.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ShannonSubadditivity

open scoped BigOperators

variable {k l : Type*} [Fintype k] [Fintype l]

/-- A finite Gibbs inequality allowing zero entries in the first vector. -/
lemma gibbs_sum {ι : Type*} [Fintype ι] (p q : ι → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hq : ∀ i, 0 ≤ q i)
    (hsupp : ∀ i, 0 < p i → 0 < q i)
    (hsum : ∑ i, q i ≤ ∑ i, p i) :
    ∑ i, p i * Real.log (q i / p i) ≤ 0 := by
  refine' le_trans _ (sub_nonpos_of_le hsum)
  rw [← Finset.sum_sub_distrib]
  gcongr
  by_cases hi : p ‹_› = 0 <;> by_cases hi' : q ‹_› = 0 <;> simp_all +decide
  · exact absurd
      (hsupp _ (lt_of_le_of_ne (hp _) (Ne.symm hi)))
      (by linarith [hq ‹_›])
  · nlinarith [
      hp ‹_›,
      hq ‹_›,
      Real.log_le_sub_one_of_pos
        (div_pos
          (lt_of_le_of_ne (hq ‹_›) (Ne.symm hi'))
          (lt_of_le_of_ne (hp ‹_›) (Ne.symm hi))),
      mul_div_cancel₀ (q ‹_›) hi]

/-- Classical Shannon subadditivity for a finite joint probability vector. -/
theorem shannon_subadditivity (p : k × l → ℝ)
    (hp : ∀ x, 0 ≤ p x) (hps : ∑ x, p x = 1) :
    (∑ x, Real.negMulLog (p x))
      ≤ (∑ i, Real.negMulLog (∑ j, p (i, j)))
        + (∑ j, Real.negMulLog (∑ i, p (i, j))) := by
  set p1 : k → ℝ := fun i => ∑ j, p (i, j)
  set p2 : l → ℝ := fun j => ∑ i, p (i, j)
  set q : k × l → ℝ := fun x => p1 x.1 * p2 x.2
  have h_gibbs : ∑ x, p x * Real.log (q x / p x) ≤ 0 := by
    apply gibbs_sum p q hp
      (fun x => mul_nonneg
        (Finset.sum_nonneg (fun _ _ => hp _))
        (Finset.sum_nonneg (fun _ _ => hp _)))
      (fun x hx => ?_)
      (by
        simp +zetaDelta at *
        simp +decide [hps]
        erw [Finset.sum_product] at *
        simp +decide [← Finset.mul_sum _ _ _, ← Finset.sum_mul, hps]
        rw [← hps, Finset.sum_comm])
    exact mul_pos
      (lt_of_lt_of_le hx
        (Finset.single_le_sum
          (fun j _ => hp (x.1, j)) (Finset.mem_univ x.2)))
      (lt_of_lt_of_le hx
        (Finset.single_le_sum
          (fun i _ => hp (i, x.2)) (Finset.mem_univ x.1)))
  have h_key : ∑ x, p x * Real.log (q x / p x) =
      (∑ i, p1 i * Real.log (p1 i)) +
        (∑ j, p2 j * Real.log (p2 j)) -
          (∑ x, p x * Real.log (p x)) := by
    have h_term : ∀ x, p x * Real.log (q x / p x) =
        p x * Real.log (p1 x.1) + p x * Real.log (p2 x.2) -
          p x * Real.log (p x) := by
      intro x
      by_cases hx : p x = 0
      · simp [hx]
      · rw [Real.log_div, Real.log_mul] <;> ring <;> norm_num [hx]
        · exact ne_of_gt
            (lt_of_lt_of_le
              (lt_of_le_of_ne (hp x) (Ne.symm hx))
              (Finset.single_le_sum
                (fun j _ => hp (x.1, j)) (Finset.mem_univ x.2)))
        · exact ne_of_gt
            (lt_of_lt_of_le
              (lt_of_le_of_ne (hp _) (Ne.symm hx))
              (Finset.single_le_sum
                (fun i _ => hp (i, x.2)) (Finset.mem_univ x.1)))
        · exact mul_ne_zero
            (ne_of_gt
              (lt_of_lt_of_le
                (lt_of_le_of_ne (hp x) (Ne.symm hx))
                (Finset.single_le_sum
                  (fun j _ => hp (x.1, j)) (Finset.mem_univ x.2))))
            (ne_of_gt
              (lt_of_lt_of_le
                (lt_of_le_of_ne (hp x) (Ne.symm hx))
                (Finset.single_le_sum
                  (fun i _ => hp (i, x.2)) (Finset.mem_univ x.1))))
    simp +decide only [h_term, Finset.sum_sub_distrib, Finset.sum_add_distrib]
    simp +decide only [p1, p2]
    erw [Finset.sum_product, Finset.sum_product]
    simp +decide only [Finset.sum_mul _ _ _]
    exact congrArg₂ _ (congrArg₂ _ rfl Finset.sum_comm) rfl
  simp_all +decide [Real.negMulLog_def]
  linarith

end PhysicsSM.Draft.NullEdge.ShannonSubadditivity

/--
info: 'PhysicsSM.Draft.NullEdge.ShannonSubadditivity.shannon_subadditivity' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ShannonSubadditivity.shannon_subadditivity
