import PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion

/-!
# Fixed-forest counting support

This file isolates a finite counting lemma returned by the old KP/Penrose
Aristotle lane.  The lemma is deliberately independent of the polymer weights:
it only counts root-plus-labelled-block layouts of `Fin n` and the internal
permutations of each block.

Important boundary: the honest labelled-block bound below has no extra `k!`.
The older informal route with a `k!` factor overcounts when blocks are already
labelled by `Fin k`.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace PolymerKPConclusion

/-- Map the abstract slots of a fixed root plus labelled blocks to `Fin n`.
The unit slot goes to the root; `(j, i)` goes to the `i`th element of block
`j` in increasing order. -/
def fixedForestBlockMap {n k : Nat} (m : Fin k → Nat)
    (root : Fin n) (block : Fin k → Finset (Fin n))
    (hcard : ∀ j, (block j).card = m j) :
    (Unit ⊕ (Σ j : Fin k, Fin (m j))) → Fin n :=
  Sum.elim (fun _ => root)
    (fun p => (((block p.1).orderIsoOfFin (hcard p.1)) p.2 : Fin n))

open Classical in
/-- Fixed-forest labelled-block counting theorem.

A root-plus-block layout of `Fin n` consists of a root, labelled disjoint
blocks of fixed sizes `m j`, and a cover condition saying the root plus all
blocks covers `Fin n`.  If different fibers yield different layouts, then the
number of fibers times the product of within-block factorials is bounded by
`n!`.

This is the labelled-block version: the child blocks are indexed by `Fin k`, so
there is no separate `k!` factor. -/
theorem fixed_forest_fiber_card_mul_le_factorial
    {n k : Nat} (m : Fin k → Nat)
    (Fib : Type*) [Fintype Fib]
    (root : Fib → Fin n)
    (block : Fib → Fin k → Finset (Fin n))
    (hcard : ∀ x j, (block x j).card = m j)
    (hroot_not_block : ∀ x j, root x ∉ block x j)
    (hdisj : ∀ x i j, i ≠ j → Disjoint (block x i) (block x j))
    (hcover : ∀ x,
      ({root x} : Finset (Fin n)) ∪
          (Finset.univ.biUnion (fun j : Fin k => block x j)) = Finset.univ)
    (hlayout_inj : Function.Injective fun x =>
      (root x, fun j : Fin k => block x j)) :
    Fintype.card Fib * (∏ j, Nat.factorial (m j)) ≤ Nat.factorial n := by
  rcases isEmpty_or_nonempty Fib with hE | hE
  · rw [Fintype.card_eq_zero, Nat.zero_mul]
    exact Nat.zero_le _
  obtain ⟨x0⟩ := hE
  have hn : n = 1 + ∑ j, m j := by
    have hbu : (Finset.univ.biUnion (fun j : Fin k => block x0 j)).card = ∑ j, m j := by
      rw [Finset.card_biUnion (fun i _ j _ hij => hdisj x0 i j hij)]
      exact Finset.sum_congr rfl (fun j _ => hcard x0 j)
    have hdisju : Disjoint ({root x0} : Finset (Fin n))
        (Finset.univ.biUnion (fun j : Fin k => block x0 j)) := by
      rw [Finset.disjoint_singleton_left, Finset.mem_biUnion]
      push_neg
      intro j _
      exact hroot_not_block x0 j
    have := congrArg Finset.card (hcover x0)
    rw [Finset.card_union_of_disjoint hdisju, Finset.card_singleton, hbu,
      Finset.card_univ, Fintype.card_fin] at this
    omega
  have hDn : Fintype.card (Unit ⊕ (Σ j : Fin k, Fin (m j))) = n := by
    simp [Fintype.card_sum, Fintype.card_sigma]
    omega
  let encFixed : (Unit ⊕ (Σ j : Fin k, Fin (m j))) ≃ Fin n := Fintype.equivFinOfCardEq hDn
  have gbij : ∀ x, Function.Bijective (fixedForestBlockMap m (root x) (block x) (hcard x)) := by
    intro x
    rw [Fintype.bijective_iff_injective_and_card, hDn, Fintype.card_fin]
    refine ⟨?_, rfl⟩
    rintro (a | ⟨ja, ia⟩) (b | ⟨jb, ib⟩) h <;>
      simp only [fixedForestBlockMap, Sum.elim_inl, Sum.elim_inr] at h
    · rfl
    · exact absurd (h ▸ ((block x jb).orderIsoOfFin (hcard x jb) ib).2) (hroot_not_block x jb)
    · exact absurd (h ▸ ((block x ja).orderIsoOfFin (hcard x ja) ia).2) (hroot_not_block x ja)
    · have hjj : ja = jb := by
        by_contra hne
        have hmem_a := ((block x ja).orderIsoOfFin (hcard x ja) ia).2
        have hmem_b := ((block x jb).orderIsoOfFin (hcard x jb) ib).2
        rw [h] at hmem_a
        exact (hdisj x ja jb hne).forall_ne_finset hmem_a hmem_b rfl
      subst hjj
      have : ia = ib := (block x ja).orderIsoOfFin (hcard x ja) |>.injective (Subtype.ext h)
      subst this
      rfl
  let E : Fib → ((Unit ⊕ (Σ j : Fin k, Fin (m j))) ≃ Fin n) :=
    fun x => Equiv.ofBijective _ (gbij x)
  have hEinl : ∀ x, E x (Sum.inl ()) = root x := fun _ => rfl
  have hEinr : ∀ x j i,
      E x (Sum.inr ⟨j, i⟩) = ((block x j).orderIsoOfFin (hcard x j) i : Fin n) :=
    fun _ _ _ => rfl
  have hblock_iff : ∀ x j a, a ∈ block x j ↔ ∃ i, (E x).symm a = Sum.inr ⟨j, i⟩ := by
    intro x j a
    constructor
    · intro ha
      refine ⟨((block x j).orderIsoOfFin (hcard x j)).symm ⟨a, ha⟩, ?_⟩
      rw [Equiv.symm_apply_eq, hEinr]
      simp
    · rintro ⟨i, hi⟩
      rw [Equiv.symm_apply_eq] at hi
      rw [hi, hEinr]
      exact ((block x j).orderIsoOfFin (hcard x j) i).2
  let act : (∀ j, Equiv.Perm (Fin (m j))) →
      Equiv.Perm (Unit ⊕ (Σ j : Fin k, Fin (m j))) :=
    fun ρ => Equiv.sumCongr (Equiv.refl Unit) (Equiv.sigmaCongrRight ρ)
  have hact_inl : ∀ ρ, act ρ (Sum.inl ()) = Sum.inl () := fun _ => rfl
  have hact_inr : ∀ ρ j i, act ρ (Sum.inr ⟨j, i⟩) = Sum.inr ⟨j, ρ j i⟩ := fun _ _ _ => rfl
  let F : Fib × (∀ j, Equiv.Perm (Fin (m j))) → Equiv.Perm (Fin n) :=
    fun p => ((E p.1).symm.trans (act p.2)).trans encFixed
  have hF : Function.Injective F := by
    rintro ⟨x, ρ⟩ ⟨x', ρ'⟩ hEq
    have hG : ∀ a, act ρ ((E x).symm a) = act ρ' ((E x').symm a) := by
      intro a
      have := Equiv.congr_fun hEq a
      simp only [F, Equiv.trans_apply] at this
      exact encFixed.injective this
    have hroot_eq : root x = root x' := by
      have h1 : act ρ ((E x).symm (root x)) = Sum.inl () := by
        have : (E x).symm (root x) = Sum.inl () := by
          rw [Equiv.symm_apply_eq, hEinl]
        rw [this, hact_inl]
      have h2 : act ρ' ((E x').symm (root x')) = Sum.inl () := by
        have : (E x').symm (root x') = Sum.inl () := by
          rw [Equiv.symm_apply_eq, hEinl]
        rw [this, hact_inl]
      have h3 := hG (root x')
      rw [h2] at h3
      have : act ρ ((E x).symm (root x')) = act ρ ((E x).symm (root x)) := by
        rw [h1, h3]
      exact ((E x).symm.injective ((act ρ).injective this)).symm
    have hblock_eq : (fun j => block x j) = (fun j => block x' j) := by
      funext j
      ext a
      rw [hblock_iff x j a, hblock_iff x' j a]
      constructor
      · rintro ⟨i, hi⟩
        have hga := hG a
        rw [hi, hact_inr] at hga
        set d := (E x').symm a with hd
        rcases d with _ | ⟨j2, i2⟩
        · rw [hact_inl] at hga
          exact absurd hga.symm (by simp)
        · rw [hact_inr] at hga
          have hj : j = j2 := congrArg Sigma.fst (Sum.inr.inj hga)
          subst hj
          exact ⟨i2, rfl⟩
      · rintro ⟨i, hi⟩
        have hga := hG a
        rw [hi, hact_inr] at hga
        set d := (E x).symm a with hd
        rcases d with _ | ⟨j2, i2⟩
        · rw [hact_inl] at hga
          exact absurd hga (by simp)
        · rw [hact_inr] at hga
          have hj : j2 = j := congrArg Sigma.fst (Sum.inr.inj hga)
          subst hj
          exact ⟨i2, rfl⟩
    have hxx : x = x' := hlayout_inj (by
      simp only []
      rw [hroot_eq, hblock_eq])
    subst hxx
    have hρ : ρ = ρ' := by
      funext j
      refine Equiv.ext (fun i => ?_)
      have hga := hG (E x (Sum.inr ⟨j, i⟩))
      rw [Equiv.symm_apply_apply, hact_inr, hact_inr] at hga
      have hs : (⟨j, ρ j i⟩ : Σ j, Fin (m j)) = ⟨j, ρ' j i⟩ := Sum.inr.inj hga
      exact eq_of_heq (Sigma.ext_iff.mp hs).2
    subst hρ
    rfl
  have hle := Fintype.card_le_of_injective F hF
  rw [Fintype.card_prod, Fintype.card_pi] at hle
  simp only [Fintype.card_perm, Fintype.card_fin] at hle
  exact hle

end PolymerKPConclusion
end GateYM
end NullEdge
end Draft
end PhysicsSM
