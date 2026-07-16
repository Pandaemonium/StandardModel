import Mathlib

/-!
# The log-sum inequality (finite)

Draft module (information-theory foundation for the null-edge program). For finite nonnegative `a` and strictly positive `b`,
`(sum a) * log((sum a)/(sum b)) <= sum_i a_i * log(a_i / b_i)`, with the
convention `0 * log 0 = 0` inherited from `Real.log 0 = 0`. This underpins Gibbs'
inequality, the data-processing inequality, and subadditivity.

Route: the map `x |-> x * log x` (`- Real.negMulLog`) is convex on `[0, inf)`;
apply Jensen with weights `b_i / (sum b)` to the points `a_i / b_i`, or use the
tangent/`Real.add_one_le_exp` (`Real.log_le_sub_one_of_pos`) bound on
`(a_i/b_i) / ((sum a)/(sum b))` summed against the `b_i`. Handle `a_i = 0` by the
`0 * log 0 = 0` convention. Do not use `n a t i v e _ d e c i d e`.

## Trust status

Draft-trust by kernel: `log_sum_inequality` has no proof hole and depends only
on `[propext, Classical.choice, Quot.sound]` (no compiled-evaluator trust),
pinned by the `#print axioms` guard block at the end.

## Provenance

Statement authored in-project (AFPL run 2026-07-12). Proof search by Aristotle
(project `46b29862-f7f0-447d-8e7e-8e3d5cf00119`), independently re-checked
(`lake env lean`; axiom footprint kernel-only). Route: per-index tangent bound
`Real.log_le_sub_one_of_pos` summed. Clean-room formalization.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.LogSumInequality

open scoped BigOperators

variable {k : Type*} [Fintype k]

/-
Per-term tangent bound. With `A = ∑ a`, `B = ∑ b`, for each `i`:
`aᵢ·log(A/B) + aᵢ - A·bᵢ/B ≤ aᵢ·log(aᵢ/bᵢ)`.
-/
lemma log_sum_term (ai bi A B : ℝ)
    (hai : 0 ≤ ai) (hbi : 0 < bi) (hA : 0 < A) (hB : 0 < B) :
    ai * Real.log (A / B) + ai - A * bi / B ≤ ai * Real.log (ai / bi) := by
  rcases eq_or_lt_of_le hai with rfl | hai <;> norm_num at *;
  · positivity;
  · have := Real.log_le_sub_one_of_pos ( show 0 < ( A * bi ) / ( B * ai ) by positivity );
    rw [ mul_comm B ai, Real.log_div ( by positivity ) ( by positivity ), Real.log_mul ( by positivity ) ( by positivity ), Real.log_mul ( by positivity ) ( by positivity ) ] at this;
    rw [ Real.log_div, Real.log_div ] <;> try positivity;
    rw [ div_sub_one, le_div_iff₀ ] at this <;> nlinarith [ mul_div_cancel₀ ( A * bi ) hB.ne' ]

/-
**TARGET: the log-sum inequality.**
-/
theorem log_sum_inequality (a b : k → ℝ)
    (ha : ∀ i, 0 ≤ a i) (hb : ∀ i, 0 < b i) (hA : 0 < ∑ i, a i) :
    (∑ i, a i) * Real.log ((∑ i, a i) / (∑ i, b i))
      ≤ ∑ i, a i * Real.log (a i / b i) := by
  convert Finset.sum_le_sum fun i _ => log_sum_term ( a i ) ( b i ) ( ∑ i, a i ) ( ∑ i, b i ) ( ha i ) ( hb i ) hA ( Finset.sum_pos ( fun i _ => hb i ) ⟨ Classical.choose ( Finset.nonempty_of_sum_ne_zero hA.ne' ), Finset.mem_univ _ ⟩ ) using 1;
  simp +decide [ Finset.sum_add_distrib, Finset.sum_mul ];
  simp +decide [ ← Finset.sum_div _ _ _, ← Finset.mul_sum _ _ _, ← Finset.sum_mul, ne_of_gt ( Finset.sum_pos ( fun i _ => hb i ) ( Finset.univ_nonempty_iff.mpr ⟨ Classical.choose ( Finset.nonempty_of_sum_ne_zero hA.ne' ) ⟩ ) ) ]

end PhysicsSM.Draft.NullEdge.LogSumInequality

-- Axiom-footprint guard (draft-trust by kernel): kernel axioms only.
/--
info: 'PhysicsSM.Draft.NullEdge.LogSumInequality.log_sum_inequality' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.LogSumInequality.log_sum_inequality
