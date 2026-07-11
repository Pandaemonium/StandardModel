import Mathlib

open scoped BigOperators

set_option autoImplicit false

namespace SelectorRigidity

abbrev Coord := Fin 3

def Refinement {V : Type*} [AddCommGroup V] (S : V) :=
  {b : Coord -> V // Finset.univ.sum b = S}

def ZeroSumShift (V : Type*) [AddCommGroup V] : AddSubgroup (Coord -> V) where
  carrier := {h | Finset.univ.sum h = 0}
  zero_mem' := by simp
  add_mem' := by
    intro a b ha hb
    change Finset.univ.sum a = 0 at ha
    change Finset.univ.sum b = 0 at hb
    change Finset.univ.sum (fun i => a i + b i) = 0
    rw [Finset.sum_add_distrib, ha, hb, add_zero]
  neg_mem' := by
    intro a ha
    simpa using congrArg Neg.neg ha

def translate {V : Type*} [AddCommGroup V] {S : V}
    (h : ZeroSumShift V) (b : Refinement S) : Refinement S :=
  ⟨fun i => h.1 i + b.1 i, by
    rw [Finset.sum_add_distrib, h.2, b.2, zero_add]⟩

def difference {V : Type*} [AddCommGroup V] {S : V}
    (b c : Refinement S) : ZeroSumShift V :=
  ⟨fun i => b.1 i - c.1 i, by
    change Finset.univ.sum (fun i => b.1 i - c.1 i) = 0
    rw [Finset.sum_sub_distrib, b.2, c.2, sub_self]⟩

theorem difference_translate {V : Type*} [AddCommGroup V] {S : V}
    (b c : Refinement S) : translate (difference b c) c = b := by
  apply Subtype.ext
  funext i
  simp [translate, difference]

theorem translate_injective {V : Type*} [AddCommGroup V] {S : V}
    (base : Refinement S) :
    Function.Injective (fun h : ZeroSumShift V => translate h base) := by
  intro h k heq
  apply Subtype.ext
  funext i
  have hi := congrFun (congrArg Subtype.val heq) i
  simpa [translate] using add_right_cancel hi

/-- A selector rigidifies the full fixed-total fibre exactly when it is
injective on the zero-sum shift group. -/
theorem selector_rigid_iff_injective
    {V A : Type*} [AddCommGroup V] [AddCommGroup A]
    {S : V} (sigma : ZeroSumShift V →+ A) :
    (forall b c : Refinement S,
      sigma (difference b c) = 0 -> b = c) <->
      Function.Injective sigma := by
  sorry

/-- Rational scaling of one nonzero admissible direction injects `Q` into the
zero-sum shift group. -/
def rationalShift {V : Type*} [AddCommGroup V] [Module ℚ V]
    (v : V) (t : ℚ) : ZeroSumShift V :=
  ⟨![t • v, -(t • v), 0], by
    change Finset.univ.sum ![t • v, -(t • v), 0] = 0
    simp [Fin.sum_univ_three]⟩

theorem rationalShift_injective
    {V : Type*} [AddCommGroup V] [Module ℚ V]
    (v : V) (hv : v ≠ 0) : Function.Injective (rationalShift v) := by
  sorry

/-- No finite-valued selector can rigidify a nontrivial rational-module
refinement fibre. The rational-module hypothesis is essential: the analogous
statement for arbitrary finite abelian groups is false. -/
theorem no_finite_selector_rigidifies
    {V A : Type*} [AddCommGroup V] [Module ℚ V]
    [AddCommGroup A] [Finite A]
    (sigma : ZeroSumShift V →+ A) (v : V) (hv : v ≠ 0) :
    ¬ Function.Injective sigma := by
  sorry

end SelectorRigidity
