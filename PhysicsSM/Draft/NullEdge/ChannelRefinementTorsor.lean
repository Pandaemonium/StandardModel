import Mathlib

/-!
# The full affine space of type-only channel refinements

Once the chirality-even carrier-square sector is fixed, a type-only ordered
three-channel refinement is simply a triple of admissible vectors with that
fixed total. This module classifies the entire fibre: after choosing any base
refinement, it is equivalent to the additive group of zero-sum shifts.

The ambient additive group `V` should be instantiated by the space of
operators satisfying the retained per-channel linear subspace constraints (for
example the chirality-even, adjoint-self-adjoint subspace). The theorem also
retains the displayed fixed-total relation. It does not encode arbitrary other
cross-channel relations or quotient by gauge, edge relabeling, locality,
positivity, or any other physical selector.

Provenance: elementary affine algebra, motivated by the hostile classification
review in Aristotle project `cb571b0d-b79a-41a2-ad6a-3294b9c13a76`.
-/

open scoped BigOperators

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace PhysicsSM.Draft.NullEdge.ChannelRefinementTorsor

/-- Coordinates of the three chirality-even channels. -/
abbrev Coord := Fin 3

/-- Ordered three-channel refinements with prescribed total `S`. -/
def Refinement {V : Type*} [AddCommGroup V] (S : V) :=
  {b : Coord -> V // (Finset.univ.sum b) = S}

/-- Type-preserving shifts that do not change the total channel budget. -/
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

/-- Translate a refinement by a zero-sum admissible shift. -/
def translate {V : Type*} [AddCommGroup V] {S : V}
    (h : ZeroSumShift V) (b : Refinement S) : Refinement S :=
  ⟨fun i => h.1 i + b.1 i, by
    rw [Finset.sum_add_distrib, h.2, b.2, zero_add]⟩

/-- The difference of two refinements is a zero-sum shift. -/
def difference {V : Type*} [AddCommGroup V] {S : V}
    (b c : Refinement S) : ZeroSumShift V :=
  ⟨fun i => b.1 i - c.1 i, by
    change Finset.univ.sum (fun i => b.1 i - c.1 i) = 0
    rw [Finset.sum_sub_distrib, b.2, c.2, sub_self]⟩

/-- Every fixed-total fibre is inhabited. -/
instance refinementNonempty {V : Type*} [AddCommGroup V] {S : V} :
    Nonempty (Refinement S) :=
  ⟨⟨fun i => if i = 0 then S else 0, by simp⟩⟩

/-- Zero-sum shifts act additively on fixed-total refinements. -/
instance refinementAddAction {V : Type*} [AddCommGroup V] {S : V} :
    AddAction (ZeroSumShift V) (Refinement S) where
  vadd h b := translate h b
  zero_vadd b := by
    apply Subtype.ext
    funext i
    show (0 : ZeroSumShift V).1 i + b.1 i = b.1 i
    simp
  add_vadd h₁ h₂ b := by
    apply Subtype.ext
    funext i
    show (h₁ + h₂).1 i + b.1 i = h₁.1 i + (h₂.1 i + b.1 i)
    rw [AddSubgroup.coe_add]
    simp [add_assoc]

/-- The full fixed-total refinement fibre is an additive torsor over its group
of zero-sum shifts. -/
instance refinementAddTorsor {V : Type*} [AddCommGroup V] {S : V} :
    AddTorsor (ZeroSumShift V) (Refinement S) where
  vsub b c := difference b c
  vsub_vadd' b c := by
    apply Subtype.ext
    funext i
    show (difference b c).1 i + c.1 i = b.1 i
    simp [difference]
  vadd_vsub' h b := by
    apply Subtype.ext
    funext i
    show (difference (translate h b) b).1 i = h.1 i
    simp [difference, translate]

/-- Translating by the difference from `c` to `b` recovers `b`. -/
theorem difference_translate {V : Type*} [AddCommGroup V] {S : V}
    (b c : Refinement S) :
    translate (difference b c) c = b := by
  apply Subtype.ext
  funext i
  simp [translate, difference]

/-- Taking the difference after translation recovers the shift. -/
theorem translate_difference {V : Type*} [AddCommGroup V] {S : V}
    (h : ZeroSumShift V) (b : Refinement S) :
    difference (translate h b) b = h := by
  apply Subtype.ext
  funext i
  simp [translate, difference]

/-- After choosing a base refinement, the complete type-only refinement fibre
is equivalent to the additive group of zero-sum shifts. -/
def refinementEquivZeroSumShift {V : Type*} [AddCommGroup V] {S : V}
    (base : Refinement S) : ZeroSumShift V ≃ Refinement S where
  toFun h := translate h base
  invFun b := difference b base
  left_inv h := translate_difference h base
  right_inv b := difference_translate b base

/-- The translation action is free at every base refinement. -/
theorem translate_injective {V : Type*} [AddCommGroup V] {S : V}
    (base : Refinement S) : Function.Injective (fun h : ZeroSumShift V => translate h base) :=
  (refinementEquivZeroSumShift base).injective

/-- The translation action is transitive: any refinement is obtained from any
other by a unique zero-sum shift. -/
theorem existsUnique_translate {V : Type*} [AddCommGroup V] {S : V}
    (base target : Refinement S) :
    ∃! h : ZeroSumShift V, translate h base = target := by
  refine ⟨difference target base, difference_translate target base, ?_⟩
  intro h hh
  apply translate_injective base
  calc
    translate h base = target := hh
    _ = translate (difference target base) base :=
      (difference_translate target base).symm

/-- A nonzero admissible vector produces a nonzero zero-sum tangent direction,
so the type-only refinement fibre is not a singleton. -/
theorem nontrivial_shift_of_nonzero {V : Type*} [AddCommGroup V]
    (v : V) (hv : v ≠ 0) :
    ∃ h : ZeroSumShift V, h ≠ 0 := by
  let h : ZeroSumShift V :=
    ⟨![v, -v, 0], by
      change Finset.univ.sum ![v, -v, 0] = 0
      simp [Fin.sum_univ_three]⟩
  refine ⟨h, ?_⟩
  intro hz
  apply hv
  have h0 := congrArg (fun k : ZeroSumShift V => k.1 0) hz
  simpa [h] using h0

/-- With a nonzero admissible direction, every refinement has a distinct
type-compatible refinement with the same total. -/
theorem refinement_not_unique_of_nonzero {V : Type*} [AddCommGroup V]
    {S : V} (base : Refinement S) (v : V) (hv : v ≠ 0) :
    ∃ target : Refinement S, target ≠ base := by
  obtain ⟨h, hh⟩ := nontrivial_shift_of_nonzero v hv
  refine ⟨translate h base, ?_⟩
  intro heq
  apply hh
  apply translate_injective base
  calc
    translate h base = base := heq
    _ = translate (0 : ZeroSumShift V) base := by
      apply Subtype.ext
      funext i
      simp [translate]

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelRefinementTorsor.refinementEquivZeroSumShift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms refinementEquivZeroSumShift

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelRefinementTorsor.refinementAddTorsor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms refinementAddTorsor

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelRefinementTorsor.existsUnique_translate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms existsUnique_translate

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelRefinementTorsor.refinement_not_unique_of_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms refinement_not_unique_of_nonzero

end PhysicsSM.Draft.NullEdge.ChannelRefinementTorsor
