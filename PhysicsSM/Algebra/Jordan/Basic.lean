import Mathlib

/-!
# Algebra.Jordan.Basic

Minimal Jordan algebra vocabulary for the Baez 2021 octonion-to-Standard-Model
formalization.

## Mathematical context

A (real) Jordan algebra is a commutative (but not necessarily associative)
algebra `(V, ∘)` satisfying the Jordan identity:

  `(a ∘ b) ∘ a² = a ∘ (b ∘ a²)`

This is strictly weaker than associativity. The Jordan product on self-adjoint
matrices is `a ∘ b = (1/2)(ab + ba)`.

This module provides only the lightweight definitions needed for the concrete
`h₂(𝕆)` and `h₃(𝕆)` models:
- `IsJordanIdempotent`: `p ∘ p = p`
- `IsJordanTraceOneProjection`: idempotent with trace one

We do NOT attempt the full Euclidean Jordan algebra classification (JvNW
theorem). That is source context for why `h₃(𝕆)` is exceptional, not a
near-term Lean dependency.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021,
slides 4–6.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Algebra.Jordan

/-! ## Jordan idempotent and projection predicates -/

/--
A Jordan idempotent (projection) in a type with a binary product.

An element `p` is a Jordan idempotent if `p ∘ p = p`, where `∘` is the
Jordan product. This is the abstract version; concrete instances for `H2O`
and `H3O` will use their specific Jordan product definitions.
-/
def IsJordanIdempotent {α : Type*} (prod : α → α → α) (p : α) : Prop :=
  prod p p = p

/--
A trace-one Jordan projection.

In a Euclidean Jordan algebra, trace-one projections correspond to pure
states (rank-one idempotents). For `h₂(𝕆)`, they correspond to points of
`𝕆P¹`; for `h₃(𝕆)`, they correspond to points of `𝕆P²`.
-/
def IsJordanTraceOneProjection {α : Type*}
    (prod : α → α → α) (tr : α → ℝ) (p : α) : Prop :=
  IsJordanIdempotent prod p ∧ tr p = 1

/--
A trace-two Jordan projection.

In `h₃(𝕆)`, trace-two projections correspond to lines of `𝕆P²`.
-/
def IsJordanTraceTwoProjection {α : Type*}
    (prod : α → α → α) (tr : α → ℝ) (p : α) : Prop :=
  IsJordanIdempotent prod p ∧ tr p = 2

/--
The Jordan product on any associative `*`-algebra over `ℝ`, defined as
`a ∘ b = (1/2)(a * b + b * a)`.

This is not used for octonions directly (which are nonassociative), but is the
standard formula for `h_n(ℂ)` and `h_n(ℝ)` subalgebras.
-/
noncomputable def assocJordanProduct {α : Type*} [Mul α] [Add α] [SMul ℝ α]
    (a b : α) : α :=
  (1/2 : ℝ) • (a * b + b * a)

/--
Commutativity of the associative Jordan product.

For any algebra, `(1/2)(ab + ba) = (1/2)(ba + ab)`.
-/
theorem assocJordanProduct_comm {α : Type*} [Mul α] [AddCommMonoid α] [SMul ℝ α]
    (a b : α) : assocJordanProduct a b = assocJordanProduct b a := by
  simp [assocJordanProduct, add_comm]

end PhysicsSM.Algebra.Jordan
