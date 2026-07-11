import PhysicsSM.Draft.NullEdge.ChannelRefinementTorsor

/-!
# Rigidity and finite-selector obstruction for channel refinements

This module gives a necessary-and-sufficient algebraic selector criterion for
the complete type-only channel-refinement fibre. An additive selector
rigidifies the fixed-total fibre exactly when it is injective on the group of
zero-sum shifts. If the retained type space contains a nonzero rational-module
direction, that shift group contains an injected copy of `ℚ`; consequently no
finite-valued additive selector can rigidify it.

The rational-module hypothesis in the finite-selector no-go is essential. The
analogous statement for arbitrary nonzero abelian groups is false because a
finite group can inject into a finite target.

Provenance: theorem statements prepared in the Paper F classification program;
proofs returned unchanged by Aristotle project
`904751e4-34f4-4798-8b13-134443e7d9c6` and independently checked after
adaptation to the live refinement API.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace PhysicsSM.Draft.NullEdge.ChannelSelectorRigidity

open ChannelRefinementTorsor

/-- A selector rigidifies the full fixed-total fibre exactly when it is
injective on the zero-sum shift group. -/
theorem selector_rigid_iff_injective
    {V A : Type*} [AddCommGroup V] [AddCommGroup A]
    {S : V} (sigma : ZeroSumShift V →+ A) :
    (forall b c : Refinement S,
      sigma (difference b c) = 0 -> b = c) <->
      Function.Injective sigma := by
  constructor
  · intro h
    rw [injective_iff_map_eq_zero]
    intro x hx
    let c : Refinement S := ⟨![S, 0, 0], by simp [Fin.sum_univ_three]⟩
    have hbc : difference (translate x c) c = x := translate_difference x c
    have hxc : translate x c = c := h (translate x c) c (by rw [hbc]; exact hx)
    have h0 : translate (0 : ZeroSumShift V) c = c := by
      apply Subtype.ext
      funext i
      simp [ChannelRefinementTorsor.translate]
    exact translate_injective c (hxc.trans h0.symm)
  · intro h b c hbc
    have h_eq : difference b c = 0 := h (hbc.trans (map_zero sigma).symm)
    rw [← difference_translate b c, h_eq]
    apply Subtype.ext
    funext i
    simp [ChannelRefinementTorsor.translate]

/-- Rational scaling of one nonzero admissible direction gives a family of
zero-sum shifts. -/
def rationalShift {V : Type*} [AddCommGroup V] [Module ℚ V]
    (v : V) (t : ℚ) : ZeroSumShift V :=
  ⟨![t • v, -(t • v), 0], by
    change Finset.univ.sum ![t • v, -(t • v), 0] = 0
    simp [Fin.sum_univ_three]⟩

/-- Scaling a nonzero rational-module direction injects `ℚ` into the shift
group. -/
theorem rationalShift_injective
    {V : Type*} [AddCommGroup V] [Module ℚ V]
    (v : V) (hv : v ≠ 0) : Function.Injective (rationalShift v) := by
  intro t1 t2 h_eq
  have h0 : t1 • v = t2 • v := by
    simpa [rationalShift] using congrFun (congrArg Subtype.val h_eq) 0
  have hz : (t1 - t2) • v = 0 := by rw [sub_smul, h0, sub_self]
  rcases smul_eq_zero.mp hz with h | h
  · exact sub_eq_zero.mp h
  · exact absurd h hv

/-- No finite-valued additive selector rigidifies a refinement fibre containing
a nonzero rational-module ambiguity direction. -/
theorem no_finite_selector_rigidifies
    {V A : Type*} [AddCommGroup V] [Module ℚ V]
    [AddCommGroup A] [Finite A]
    (sigma : ZeroSumShift V →+ A) (v : V) (hv : v ≠ 0) :
    ¬ Function.Injective sigma := by
  intro h_inj
  have h_comp : Function.Injective (fun t : ℚ => sigma (rationalShift v t)) :=
    h_inj.comp (rationalShift_injective v hv)
  exact not_injective_infinite_finite _ h_comp

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelSelectorRigidity.selector_rigid_iff_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms selector_rigid_iff_injective

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelSelectorRigidity.rationalShift_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rationalShift_injective

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelSelectorRigidity.no_finite_selector_rigidifies' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_finite_selector_rigidifies

end PhysicsSM.Draft.NullEdge.ChannelSelectorRigidity
