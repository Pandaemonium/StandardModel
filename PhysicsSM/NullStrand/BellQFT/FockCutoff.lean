import Mathlib

/-!
# NullStrand.BellQFT.FockCutoff

Abstract finite creation/annihilation interfaces for Fock-cutoff models.

This is a conservative scaffold that records the finite API shape needed by the
roadmap while keeping proof obligations explicit in hypotheses.
-/

noncomputable section

namespace PhysicsSM.NullStrand.BellQFT

open scoped BigOperators

/-- Finite base data on a configuration × direction family. -/
abbrev FockDensity (Q : Type*) [Fintype Q] (Γ : Type*) [Fintype Γ] := Q → Γ → ℝ

/-- Generic creation lift operator. -/
abbrev CreationLift
    {Q : Type*} [Fintype Q] {Γ : Type*} [Fintype Γ] :=
  (Q → Γ → ℝ) → (Q → Γ → ℝ)

/-- Generic annihilation lift operator. -/
abbrev AnnihilationLift
    {Q : Type*} [Fintype Q] {Γ : Type*} [Fintype Γ] :=
  (Q → Γ → ℝ) → (Q → Γ → ℝ)

/- Marginal consistency for a creation lift is an explicit hypothesis in this abstraction. -/
theorem creationLift_targetDirectionMarginal
    {Q : Type*} [Fintype Q] {Γ : Type*} [Fintype Γ]
    (C : CreationLift (Q := Q) (Γ := Γ)) (ρ : Q → Γ → ℝ)
    (hC : ∀ ρ q, ∑ ω, C ρ q ω = ∑ ω, ρ q ω) :
    ∀ q : Q, (∑ ω, C ρ q ω) = ∑ ω, ρ q ω := by
  intro q
  exact hC ρ q

/- Forgetting the destination direction under annihilation is an explicit hypothesis in this abstraction. -/
theorem annihilationLift_forgetsDirection
    {Q : Type*} [Fintype Q] {Γ : Type*} [Fintype Γ]
    (A : AnnihilationLift (Q := Q) (Γ := Γ)) (ρ : Q → Γ → ℝ)
    (hA : ∀ ρ q, ∑ ω, A ρ q ω = ∑ ω, ρ q ω) :
    ∀ q : Q, (∑ ω, A ρ q ω) = ∑ ω, ρ q ω := by
  intro q
  exact hA ρ q

/- Equivariance for a finite Fock lift: preservation of total marginal mass. -/
theorem fockNullLift_equivariant
    {Q : Type*} [Fintype Q] {Γ : Type*} [Fintype Γ]
    (L : (Q → Γ → ℝ) → (Q → Γ → ℝ)) (ρ : Q → Γ → ℝ)
    (hMarg : ∀ ρ q, (∑ ω, L ρ q ω) = ∑ ω, ρ q ω) :
    (∑ q, ∑ ω, L ρ q ω) = ∑ q, ∑ ω, ρ q ω := by
  calc
    (∑ q, ∑ ω, L ρ q ω) = ∑ q, ∑ ω, ρ q ω := by
      refine Finset.sum_congr rfl ?_
      intro q hq
      exact hMarg ρ q

end PhysicsSM.NullStrand.BellQFT
