import Mathlib
import PhysicsSM.NullStrand.Entanglement.ProductNullRepresentation

/-!
# NullStrand.Entanglement.SeparabilityObstruction

Finite obstruction statement for local-positive-product-null representations.
-/

noncomputable section

namespace PhysicsSM.NullStrand.Entanglement

open scoped BigOperators

/-- Entangled finite states are those not admitting a separable product law. -/
def entangledState
    {A B : Type*} [Fintype A] [Fintype B] (ρ : Law (A × B)) : Prop :=
  ¬ separableState ρ

/-- Synonym for the finite null-direction local-positive product representation. -/
abbrev localPositiveProductNullRepresentation
    {A B : Type*} [Fintype A] [Fintype B] (ρ : Law (A × B)) : Prop :=
  productDirectionRepresentation ρ

/-- In this finite abstraction, entanglement blocks local product support. -/
theorem entangledState_has_no_localPositiveProductNullRepresentation
  {A B : Type*} [Fintype A] [Fintype B] (ρ : Law (A × B))
    (hEnt : entangledState (A := A) (B := B) ρ) :
    ¬ localPositiveProductNullRepresentation (A := A) (B := B) ρ := by
  -- `entangledState ρ = ¬ separableState ρ` and both `separableState` and
  -- `localPositiveProductNullRepresentation` reduce to `productDirectionRepresentation ρ`.
  intro h
  exact hEnt h

end PhysicsSM.NullStrand.Entanglement
