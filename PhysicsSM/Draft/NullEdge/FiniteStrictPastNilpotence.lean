import Mathlib

/-!
# Nilpotence of weighted past operators on finite strict orders

Every weighted strict-past incidence operator on a nonempty finite transitive
irreflexive relation is nilpotent by the event-cardinality power. A two-event
chain supplies a nonzero square-zero control.

Provenance: both public statements were prepared in the project and proved
unchanged by Aristotle project `cdb53c37-a5ad-4c72-9714-27136ce91f62`, task
`fc83b976-a463-422a-8c9e-5d97ea35f9a1`. The extracted proof was checked under
the pinned toolchain before integration.

Claim grade: `M [orig/comp]`, finite strict-relation algebra only.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence

/-- A finite transitive irreflexive relation. -/
structure FiniteStrictRelation (V : Type*) [Fintype V] where
  before : V -> V -> Prop
  transitive : forall {x y z}, before x y -> before y z -> before x z
  irrefl : forall x, Not (before x x)

/-- Weighted strict-past incidence operator. -/
noncomputable def weightedPastOperator
    {V : Type*} [Fintype V]
    (C : FiniteStrictRelation V) (weight : V -> V -> Real) :
    (V -> Real) →ₗ[Real] (V -> Real) := by
  classical
  refine {
    toFun := fun f x =>
      ∑ y, if C.before y x then weight y x * f y else 0
    map_add' := ?_
    map_smul' := ?_ }
  · intro f g
    funext x
    simp only [Pi.add_apply]
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro y _
    by_cases h : C.before y x <;> simp [h]
    ring
  · intro c f
    funext x
    simp only [RingHom.id_apply, Pi.smul_apply, smul_eq_mul]
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro y _
    by_cases h : C.before y x <;> simp [h]
    ring

set_option maxHeartbeats 1000000 in
/-- A weighted past operator on a nonempty finite strict order is nilpotent by
the event-cardinality power. -/
theorem weightedPastOperator_pow_card_eq_zero
    {V : Type*} [Fintype V] [Nonempty V]
    (C : FiniteStrictRelation V) (weight : V -> V -> Real) :
    weightedPastOperator C weight ^ Fintype.card V = 0 := by
  by_contra h_contra
  have h_card_V_ge_1 : 1 ≤ Fintype.card V := by
    exact Fintype.card_pos_iff.mpr ‹_›
  obtain ⟨x, hx⟩ : ∃ x : V, ∃ k : V → Real,
      k ≠ 0 ∧ (weightedPastOperator C weight ^ Fintype.card V) k x ≠ 0 := by
    contrapose! h_contra
    ext x
    by_cases hx : x = 0 <;> aesop
  obtain ⟨k, hk_ne_zero, hk_nonzero⟩ := hx
  have h_chain : ∃ (xs : Fin (Fintype.card V + 1) -> V),
      (∀ i : Fin (Fintype.card V),
        C.before (xs (Fin.castSucc i)) (xs (Fin.succ i))) ∧
      k (xs 0) ≠ 0 := by
    have h_chain : ∀ n : Nat, ∀ x : V,
        (weightedPastOperator C weight ^ n) k x ≠ 0 ->
        ∃ xs : Fin (n + 1) -> V,
          (∀ i : Fin n, C.before (xs (Fin.castSucc i)) (xs (Fin.succ i))) ∧
          k (xs 0) ≠ 0 ∧ xs (Fin.last n) = x := by
      intro n x hx_nonzero
      induction' n with n ih generalizing x
      · exact ⟨fun _ => x, by simp +decide, hx_nonzero, rfl⟩
      · simp_all +decide [pow_succ', weightedPastOperator]
        obtain ⟨y, hy⟩ := Finset.exists_ne_zero_of_sum_ne_zero hx_nonzero
        obtain ⟨xs, hxs₁, hxs₂, hxs₃⟩ := ih y (by aesop)
        refine ⟨Fin.snoc xs x, ?_, ?_, ?_⟩ <;> simp_all +decide [Fin.snoc]
        intro i
        split_ifs <;> simp_all +decide [Fin.castLT]
        · exact hxs₁ ⟨i, by linarith⟩
        · grind +qlia
        · linarith
        · linarith [Fin.is_lt i]
    exact Exists.imp (fun xs => And.imp_right And.left)
      (h_chain _ _ hk_nonzero)
  obtain ⟨xs, hxs₁, hxs₂⟩ := h_chain
  have h_distinct : Function.Injective xs := by
    have h_distinct : ∀ i j : Fin (Fintype.card V + 1),
        i < j -> C.before (xs i) (xs j) := by
      intro i j hij
      induction' j using Fin.inductionOn with j ih ih
      · aesop
      · grind +suggestions
    intro i j hij
    exact le_antisymm
      (le_of_not_gt fun hi => by
        have := h_distinct _ _ hi
        have := C.irrefl (xs j)
        aesop)
      (le_of_not_gt fun hj => by
        have := h_distinct _ _ hj
        have := C.irrefl (xs i)
        aesop)
  exact absurd (Fintype.card_le_of_injective xs h_distinct)
    (by simp +decide)

/-- The two-point strict chain. -/
def twoChain : FiniteStrictRelation (Fin 2) where
  before i j := i = 0 ∧ j = 1
  transitive := by
    intro x y z hxy hyz
    omega
  irrefl := by
    intro x h
    omega

/-- The two-point chain is a sharp nonzero square-zero control. -/
theorem twoChain_weightedPast_nonzero_and_square_zero :
    let N := weightedPastOperator twoChain (fun _ _ => 1)
    N ≠ 0 ∧ N ^ 2 = 0 := by
  constructor
  · intro h
    have := congrArg (fun f => f (fun _ => 1) 1) h
    norm_num [weightedPastOperator] at this
    simp +decide [twoChain] at this
  · convert weightedPastOperator_pow_card_eq_zero twoChain (fun _ _ => 1)
      using 1

end PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence.weightedPastOperator_pow_card_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence.weightedPastOperator_pow_card_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence.twoChain_weightedPast_nonzero_and_square_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteStrictPastNilpotence.twoChain_weightedPast_nonzero_and_square_zero
