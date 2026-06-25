import Mathlib

/-!
# NullStrand.Entanglement.ProductNullRepresentation

Finite convex-null representation of joint direction data.

This module is a conservative finite scaffold: it records the algebraic shape of
product-direction representations in a way that is easy to use in downstream
bridge lemmas while keeping all conventions explicit.
-/

noncomputable section

namespace PhysicsSM.NullStrand.Entanglement

open scoped BigOperators
open Finset

/-- Finite signed law on a finite set (not yet normalized). -/
abbrev Law (Q : Type*) [Fintype Q] := Q → ℝ

/-- A finite probability law: nonnegative entries summing to one. -/
def IsProbability {Q : Type*} [Fintype Q] (ρ : Law Q) : Prop :=
  (∀ q, 0 ≤ ρ q) ∧ (∑ q, ρ q = 1)

/-- Finite convex-weights for a mixture over an index set. -/
def IsConvexWeights {N : Type*} [Fintype N] (λ : N → ℝ) : Prop :=
  (∀ i, 0 ≤ λ i) ∧ (∑ i, λ i = 1)

/-- A finite product-law representation of a joint direction distribution. -/
def productDirectionRepresentation
    {A B : Type*} [Fintype A] [Fintype B] (ρ : Law (A × B)) : Prop :=
  ∃ (K : Type) (_ : Fintype K), ∃ w : K → ℝ, ∃ p : K → A → ℝ, ∃ q : K → B → ℝ,
    IsConvexWeights w ∧
    (∀ k, IsProbability (p k)) ∧ (∀ k, IsProbability (q k)) ∧
    (∀ x, ρ x = ∑ k, w k * (p k x.1 * q k x.2))

/-- A finite separable state is exactly a finite convex product representation. -/
def separableState
    {A B : Type*} [Fintype A] [Fintype B] (ρ : Law (A × B)) : Prop :=
  productDirectionRepresentation ρ

/-- In this finite abstraction, separability and product representation coincide. -/
theorem productDirectionRepresentation_iff_separable
    {A B : Type*} [Fintype A] [Fintype B] (ρ : Law (A × B)) :
    productDirectionRepresentation ρ ↔ separableState ρ := by
  rfl

end PhysicsSM.NullStrand.Entanglement
