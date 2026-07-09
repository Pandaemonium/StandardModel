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

set_option grind.warning false

/-!
# The selecting axiom that makes the four-block carrier square decomposition UNIQUE

## Distilled mathematical content

The informal "null-edge program" describes the carrier square `2(D#D)` decomposing into
exactly four grade-typed blocks `Q_A + Q_C + 2E_# + 2Q_T`.  The prior result (not part of
this file) is a *type-count* statement: there are exactly four blocks, no fifth block.  The
follow-up question is whether the **split itself** is unique, and if not, which single extra
axiom forces uniqueness.

Stripped of the physics vocabulary, the genuine mathematical situation is:

* A finite-dimensional vector space `V` (the carrier square) is written as an **internal
  direct sum** of a family of subspaces `W i` (the grade-typed blocks).
* The *number* of blocks is fixed, but a direct-sum decomposition into a fixed number of
  blocks is **not unique** in general.

This file proves both halves precisely:

* `split_not_forced` : the number of blocks does **not** force the split — there are two
  genuinely different two-block (complementary) decompositions of `ℝ²`.  This is the honest
  no-go: base axioms (type-count) leave the split under-determined.

* `blocks_eq_eigenspaces` / `decomposition_unique` : the **selecting axiom** is candidate
  (a) — a *nondegenerate soldering*, formalized as a fixed grading operator `D` acting as a
  distinct scalar `μ i` on each block.  Under this axiom every block is **forced** to equal
  the corresponding eigenspace `D.eigenspace (μ i)` of `D`; hence any two decompositions
  graded by the same `(D, μ)` coincide.  So "unification is decomposition" becomes forced,
  not merely type-forced.

The verdict: a single natural axiom (nondegeneracy/faithfulness of the soldering =
existence of a grading operator with distinct grades) suffices, and the residual gauge
freedom is exactly the choice of that operator's grades.
-/

namespace NullEdgeCloser

open Module

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-
**Selecting axiom ⇒ forced blocks.**
If a family of subspaces `W` gives an internal direct sum decomposition of `V`, and there is
a fixed operator `D` (the *soldering / grading operator*) acting as the scalar `μ i` on each
block `W i`, with the grades `μ` pairwise distinct, then each block is *forced* to be the
`μ i`-eigenspace of `D`.

This is the precise sense in which the nondegeneracy axiom pins the split: the blocks are no
longer free data, they are recovered canonically from `(D, μ)`.
-/
theorem blocks_eq_eigenspaces
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (D : Module.End K V) (μ : ι → K) (hμ : Function.Injective μ)
    (W : ι → Submodule K V)
    (hInt : DirectSum.IsInternal W)
    (hgrade : ∀ i, ∀ x ∈ W i, D x = μ i • x) :
    ∀ i, W i = D.eigenspace (μ i) := by
  intro i
  apply le_antisymm;
  · exact fun x hx => by rw [ Module.End.mem_eigenspace_iff, hgrade i x hx ] ;
  · intro x hx
    obtain ⟨f, hf⟩ : ∃ f : ι →₀ V, x = ∑ i, f i ∧ ∀ i, f i ∈ W i := by
      have h_decomp : x ∈ ⨆ i, W i := by
        exact hInt.submodule_iSup_eq_top.ge ( by simp +decide );
      rw [ Submodule.mem_iSup_iff_exists_finsupp ] at h_decomp;
      obtain ⟨ f, hf₁, hf₂ ⟩ := h_decomp; use f; simp_all +decide [ Finsupp.sum_fintype ] ;
    -- Since $D$ maps each $W_j$ into itself, we have $D(f_j) = \mu_j f_j$ for each $j$.
    have hDf : ∑ j, (μ j - μ i) • f j = 0 := by
      simp_all +decide [ sub_smul, Finset.sum_sub_distrib ];
      simp_all +decide [ ← Finset.smul_sum ];
      rw [ ← hx, Finset.sum_congr rfl fun _ _ => hgrade _ _ ( hf.2 _ ), sub_self ];
    -- Since the W j are independent, each term (μ j - μ i) • f j must be zero.
    have h_zero : ∀ j, (μ j - μ i) • f j = 0 := by
      have h_zero : ∀ (s : Finset ι) (g : ι → V), (∀ j ∈ s, g j ∈ W j) → (∑ j ∈ s, g j = 0) → (∀ j ∈ s, g j = 0) := by
        intro s g hg hsum j hj
        have h_indep : ∀ (g : ι → V), (∀ j, g j ∈ W j) → (∑ j, g j = 0) → (∀ j, g j = 0) := by
          intro g hg hsum j
          have := hInt.injective
          simp_all +decide [ Function.Injective ];
          specialize @this ( ∑ j, DirectSum.of ( fun i => W i ) j ⟨ g j, hg j ⟩ ) 0 ; simp_all +decide [ DirectSum.coeAddMonoidHom ];
          replace this := congr_arg ( fun x => x j ) this ; simp_all +decide;
          rw [ DFinsupp.finset_sum_apply ] at this;
          rw [ Finset.sum_eq_single j ] at this <;> simp_all +decide [ DirectSum.of_apply ];
        contrapose! h_indep;
        refine' ⟨ fun i => if i ∈ s then g i else 0, _, _, j, _ ⟩ <;> simp_all +decide;
        intro j; split_ifs <;> simp_all +decide;
      specialize h_zero Finset.univ ( fun j => ( μ j - μ i ) • f j ) ; aesop;
    rw [ hf.1, Finset.sum_eq_single i ] <;> simp_all +decide [ sub_eq_zero, hμ.eq_iff ];
    exact fun j hj => Or.resolve_left ( h_zero j ) hj

/-- **Uniqueness of the graded split.**
Any two internal direct sum decompositions of `V` that are graded by the *same* operator `D`
with the same distinct grades `μ` are equal.  Under the selecting axiom the four-block split
is unique. -/
theorem decomposition_unique
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (D : Module.End K V) (μ : ι → K) (hμ : Function.Injective μ)
    (W W' : ι → Submodule K V)
    (hInt : DirectSum.IsInternal W) (hInt' : DirectSum.IsInternal W')
    (hgrade : ∀ i, ∀ x ∈ W i, D x = μ i • x)
    (hgrade' : ∀ i, ∀ x ∈ W' i, D x = μ i • x) :
    W = W' := by
  funext i
  rw [blocks_eq_eigenspaces D μ hμ W hInt hgrade i,
      blocks_eq_eigenspaces D μ hμ W' hInt' hgrade' i]

/-
**No-go: the type-count does NOT force the split.**
There are two genuinely different complementary (two-block, internal direct sum)
decompositions of `ℝ²`: they share the block `A = span e₁` but differ in the second block.
So merely fixing the number of blocks leaves the decomposition under-determined — a selecting
axiom is genuinely needed.
-/
theorem split_not_forced :
    ∃ A B B' : Submodule ℝ (Fin 2 → ℝ),
      IsCompl A B ∧ IsCompl A B' ∧ B ≠ B' := by
  use Submodule.span ℝ { ![1, 0] }, Submodule.span ℝ { ![0, 1] }, Submodule.span ℝ { ![1, 1] };
  refine' ⟨ _, _, _ ⟩;
  · refine' ⟨ _, _ ⟩;
    · norm_num [ Submodule.disjoint_def, Submodule.mem_span_singleton ];
      ext i ; fin_cases i;
    · rw [ codisjoint_iff, Submodule.eq_top_iff' ];
      norm_num [ Submodule.mem_sup, Submodule.mem_span_singleton ];
      exact fun x => ⟨ x 0, x 1, by ext i; fin_cases i <;> rfl ⟩;
  · refine' ⟨ _, _ ⟩;
    · norm_num [ Submodule.disjoint_def, Submodule.mem_span_singleton ];
      ext i ; fin_cases i;
    · rw [ codisjoint_iff, Submodule.eq_top_iff' ];
      intro x; rw [ Submodule.mem_sup ] ; norm_num [ Submodule.mem_span_singleton ];
      exact ⟨ x 0 - x 1, x 1, by ext i; fin_cases i <;> norm_num ⟩;
  · norm_num [ Submodule.ext_iff, Submodule.mem_span_singleton ];
    use ![1, 1]; simp

end NullEdgeCloser

/-- info: 'NullEdgeCloser.blocks_eq_eigenspaces' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms NullEdgeCloser.blocks_eq_eigenspaces

/-- info: 'NullEdgeCloser.decomposition_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms NullEdgeCloser.decomposition_unique

/-- info: 'NullEdgeCloser.split_not_forced' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms NullEdgeCloser.split_not_forced
