import Mathlib
import PhysicsSM.Algebra.Jordan.H3O

/-!
# Algebra.Jordan.Automorphism

Trusted automorphisms of the exceptional Jordan algebra `h_3(O)`.

## Overview

A Jordan automorphism of `h_3(O)` is a linear equivalence that preserves
the Jordan product and the trace.

Claim boundary: this module defines and proves facts about the concrete group
of Jordan-product/trace-preserving equivalences of the coordinate type `H3O`.
It does not prove the external compact Lie group identification
`Aut(h_3(O)) ~= F4`; that requires Lie group, topology, manifold, and
connected-component infrastructure outside the current trusted development.

This module provides:
- `H3OAutomorphism` — the structure for Jordan automorphisms.
- `Group H3OAutomorphism` — the trusted group instance.
- Preservation lemmas for projections, trace-one points, trace-two lines,
  and incidence.

## Status

This is a **trusted** module: all definitions and theorems are fully proved.
-/

namespace PhysicsSM.Algebra.Jordan.Automorphism

open PhysicsSM.Algebra.Jordan.H3O

local infixl:70 " ○ " => jordanProduct

/-! ## The automorphism structure -/

/--
A Jordan automorphism of `h_3(O)`.

This is the concrete algebraic automorphism group used as a stand-in for the
future compact `F4` comparison theorem. No Lie group isomorphism with `F4` is
proved in this module.
-/
structure H3OAutomorphism where
  /-- The underlying equivalence. -/
  toEquiv : H3O ≃ H3O
  /-- The equivalence preserves the Jordan product. -/
  map_jordan : ∀ a b, toEquiv (a ○ b) = toEquiv a ○ toEquiv b
  /-- The equivalence preserves the trace. -/
  map_trace : ∀ a, trace (toEquiv a) = trace a

instance : CoeFun H3OAutomorphism (fun _ => H3O → H3O) where
  coe g := g.toEquiv

@[ext]
theorem H3OAutomorphism.ext {g h : H3OAutomorphism}
    (heq : ∀ a, g a = h a) : g = h := by
  cases g; cases h
  simp only [mk.injEq]
  exact Equiv.ext heq

/-! ## Group structure -/

/-- The group structure on Jordan automorphisms of `h_3(O)`. -/
noncomputable instance : Group H3OAutomorphism where
  mul g h :=
    { toEquiv := h.toEquiv.trans g.toEquiv
      map_jordan := fun a b => by
        simp [Equiv.trans_apply, h.map_jordan, g.map_jordan]
      map_trace := fun a => by
        simp [Equiv.trans_apply, g.map_trace, h.map_trace] }
  one :=
    { toEquiv := Equiv.refl H3O
      map_jordan := fun _ _ => rfl
      map_trace := fun _ => rfl }
  inv g :=
    { toEquiv := g.toEquiv.symm
      map_jordan := fun a b => by
        apply g.toEquiv.injective
        simp [Equiv.apply_symm_apply, g.map_jordan]
      map_trace := fun a => by
        have := g.map_trace (g.toEquiv.symm a)
        simp [Equiv.apply_symm_apply] at this
        exact this.symm }
  mul_assoc _ _ _ := H3OAutomorphism.ext fun _ => rfl
  one_mul _ := H3OAutomorphism.ext fun _ => rfl
  mul_one _ := H3OAutomorphism.ext fun _ => rfl
  inv_mul_cancel g := H3OAutomorphism.ext fun a => g.toEquiv.symm_apply_apply a

/-! ## Automorphism application lemmas -/

theorem H3OAutomorphism.one_apply (a : H3O) :
    (1 : H3OAutomorphism) a = a := rfl

theorem H3OAutomorphism.mul_apply (g h : H3OAutomorphism) (a : H3O) :
    (g * h) a = g (h a) := rfl

theorem H3OAutomorphism.inv_apply (g : H3OAutomorphism) (a : H3O) :
    g⁻¹ a = g.toEquiv.symm a := rfl

theorem H3OAutomorphism.inv_toEquiv (g : H3OAutomorphism) :
    (g⁻¹).toEquiv = g.toEquiv.symm := rfl

/-! ## Preservation lemmas -/

/-- An automorphism preserves the `IsProjection` predicate. -/
theorem H3OAutomorphism.map_isProjection (g : H3OAutomorphism)
    {p : H3O} (hp : IsProjection p) : IsProjection (g p) := by
  unfold IsProjection at *
  rw [← g.map_jordan, hp]

/-- An automorphism preserves trace-one elements. -/
theorem H3OAutomorphism.map_trace_one (g : H3OAutomorphism)
    {p : H3O} (ht : trace p = 1) : trace (g p) = 1 := by
  rw [g.map_trace]; exact ht

/-- An automorphism preserves trace-two elements. -/
theorem H3OAutomorphism.map_trace_two (g : H3OAutomorphism)
    {p : H3O} (ht : trace p = 2) : trace (g p) = 2 := by
  rw [g.map_trace]; exact ht

/-- An automorphism preserves the incidence relation `p ○ ℓ = p`. -/
theorem H3OAutomorphism.map_incidence (g : H3OAutomorphism)
    {p ell : H3O} (h : p ○ ell = p) : g p ○ g ell = g p := by
  rw [← g.map_jordan, h]

/-! ## Stabilizer of a set -/

/-- An automorphism stabilizes a set of H3O elements setwise. -/
def H3OAutomorphism.Stabilizes (g : H3OAutomorphism) (S : Set H3O) : Prop :=
  ∀ a, a ∈ S ↔ g a ∈ S

/-- The identity stabilizes any set. -/
theorem H3OAutomorphism.one_stabilizes (S : Set H3O) :
    H3OAutomorphism.Stabilizes 1 S := fun _ => Iff.rfl

/-- Composition of stabilizing automorphisms stabilizes the same set. -/
theorem H3OAutomorphism.comp_stabilizes {g h : H3OAutomorphism} {S : Set H3O}
    (hg : g.Stabilizes S) (hh : h.Stabilizes S) :
    (g * h).Stabilizes S := by
  intro a
  constructor
  · intro ha
    exact (hg (h a)).mp ((hh a).mp ha)
  · intro (ha : g (h a) ∈ S)
    exact (hh a).mpr ((hg (h a)).mpr ha)

/-- The inverse of a stabilizing automorphism stabilizes the same set. -/
theorem H3OAutomorphism.inv_stabilizes {g : H3OAutomorphism} {S : Set H3O}
    (hg : g.Stabilizes S) : g⁻¹.Stabilizes S := by
  intro a
  constructor
  · intro ha
    change g.toEquiv.symm a ∈ S
    have h1 : a = g (g.toEquiv.symm a) := (g.toEquiv.apply_symm_apply a).symm
    rw [h1] at ha
    exact (hg (g.toEquiv.symm a)).mpr ha
  · intro (ha : g.toEquiv.symm a ∈ S)
    have h2 : g (g.toEquiv.symm a) = a := g.toEquiv.apply_symm_apply a
    rw [← h2]
    exact (hg (g.toEquiv.symm a)).mp ha

end PhysicsSM.Algebra.Jordan.Automorphism
