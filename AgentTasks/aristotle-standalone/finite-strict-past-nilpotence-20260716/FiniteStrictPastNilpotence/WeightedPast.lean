import Mathlib

/-!
# Nilpotence of weighted past operators on finite strict orders

Focused combinatorial target for the null-edge retarded causal operator.
-/

noncomputable section

namespace FiniteStrictPastNilpotence

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
  ·
    intro f g
    funext x
    simp only [Pi.add_apply]
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro y _
    by_cases h : C.before y x <;> simp [h]
    ring
  ·
    intro c f
    funext x
    simp only [RingHom.id_apply, Pi.smul_apply, smul_eq_mul]
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro y _
    by_cases h : C.before y x <;> simp [h]
    ring

/-- A weighted past operator on a nonempty finite strict order is nilpotent by
the event-cardinality power. -/
theorem weightedPastOperator_pow_card_eq_zero
    {V : Type*} [Fintype V] [Nonempty V]
    (C : FiniteStrictRelation V) (weight : V -> V -> Real) :
    weightedPastOperator C weight ^ Fintype.card V = 0 := by
  sorry

/-- The two-point chain is a sharp nonzero square-zero control. -/
def twoChain : FiniteStrictRelation (Fin 2) where
  before i j := i = 0 ∧ j = 1
  transitive := by
    intro x y z hxy hyz
    omega
  irrefl := by
    intro x h
    omega

theorem twoChain_weightedPast_nonzero_and_square_zero :
    let N := weightedPastOperator twoChain (fun _ _ => 1)
    N ≠ 0 ∧ N ^ 2 = 0 := by
  sorry

end FiniteStrictPastNilpotence
