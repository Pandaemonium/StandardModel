import Mathlib

/-!
# NullStrand finite joint-law marginal target

Finite probability algebra: every finite probability law on a product has
probability marginals.
-/

noncomputable section

namespace NullStrandJointMarginals

open scoped BigOperators

/-- Finite signed law on a finite set. -/
abbrev Law (Q : Type*) [Fintype Q] := Q -> Real

/-- A finite probability law. -/
def IsProbability {Q : Type*} [Fintype Q] (rho : Law Q) : Prop :=
  (∀ q, 0 <= rho q) ∧ (∑ q, rho q = 1)

/-- First marginal of a finite joint law. -/
def marginalA {A B : Type*} [Fintype A] [Fintype B] (rho : Law (A × B)) : Law A :=
  fun a => ∑ b, rho (a, b)

/-- Second marginal of a finite joint law. -/
def marginalB {A B : Type*} [Fintype A] [Fintype B] (rho : Law (A × B)) : Law B :=
  fun b => ∑ a, rho (a, b)

/-- A finite probability joint law has a probability first marginal. -/
theorem marginalA_probability
    {A B : Type*} [Fintype A] [Fintype B] (rho : Law (A × B))
    (hrho : IsProbability rho) :
    IsProbability (marginalA rho) := by
  obtain ⟨hnonneg, hsum⟩ := hrho
  refine ⟨fun a => Finset.sum_nonneg fun b _ => hnonneg (a, b), ?_⟩
  rw [← hsum, Fintype.sum_prod_type]
  rfl

/-- A finite probability joint law has a probability second marginal. -/
theorem marginalB_probability
    {A B : Type*} [Fintype A] [Fintype B] (rho : Law (A × B))
    (hrho : IsProbability rho) :
    IsProbability (marginalB rho) := by
  obtain ⟨hnonneg, hsum⟩ := hrho
  refine ⟨fun b => Finset.sum_nonneg fun a _ => hnonneg (a, b), ?_⟩
  rw [← hsum, Fintype.sum_prod_type_right]
  rfl

end NullStrandJointMarginals
