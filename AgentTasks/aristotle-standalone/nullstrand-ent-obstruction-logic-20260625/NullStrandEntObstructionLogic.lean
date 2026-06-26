import Mathlib

/-!
# NullStrand entanglement obstruction logic target

Focused ENT-004 logic layer: once entanglement is defined as nonseparability,
absence of a positive local product representation is just the contrapositive
of the product-representation definition.
-/

noncomputable section

namespace NullStrandEntObstructionLogic

open scoped BigOperators

/-- Finite signed law on a finite set. -/
abbrev Law (Q : Type*) [Fintype Q] := Q -> Real

/-- A finite probability law. -/
def IsProbability {Q : Type*} [Fintype Q] (rho : Law Q) : Prop :=
  (∀ q, 0 <= rho q) ∧ (∑ q, rho q = 1)

/-- Convex weights for a finite mixture. -/
def IsConvexWeights {K : Type*} [Fintype K] (w : K -> Real) : Prop :=
  (∀ k, 0 <= w k) ∧ (∑ k, w k = 1)

/-- A finite convex product-law representation. -/
def productDirectionRepresentation
    {A B : Type*} [Fintype A] [Fintype B] (rho : Law (A × B)) : Prop :=
  ∃ (K : Type) (_ : Fintype K), ∃ w : K -> Real, ∃ p : K -> A -> Real,
    ∃ q : K -> B -> Real,
      IsConvexWeights w ∧
      (∀ k, IsProbability (p k)) ∧
      (∀ k, IsProbability (q k)) ∧
      (∀ x, rho x = ∑ k, w k * (p k x.1 * q k x.2))

/-- Finite separability is represented by a convex product-law representation. -/
def separableState
    {A B : Type*} [Fintype A] [Fintype B] (rho : Law (A × B)) : Prop :=
  productDirectionRepresentation rho

/-- Entangled finite states are nonseparable states. -/
def entangledState
    {A B : Type*} [Fintype A] [Fintype B] (rho : Law (A × B)) : Prop :=
  ¬ separableState rho

/-- ENT-004 core: an entangled state has no positive local product representation. -/
theorem entangled_no_productDirectionRepresentation
    {A B : Type*} [Fintype A] [Fintype B] (rho : Law (A × B)) :
    entangledState rho -> ¬ productDirectionRepresentation rho := by
  intro h
  exact h

/-- In this finite abstraction, no product representation is equivalent to entanglement. -/
theorem no_productDirectionRepresentation_iff_entangled
    {A B : Type*} [Fintype A] [Fintype B] (rho : Law (A × B)) :
    (¬ productDirectionRepresentation rho) ↔ entangledState rho := by
  rfl

end NullStrandEntObstructionLogic
