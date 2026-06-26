import Mathlib

/-!
# NullStrand finite Fock lift composition target

Finite marginal-preservation theorem for composing creation/annihilation-style
direction lifts.
-/

noncomputable section

namespace NullStrandFockCompose

open scoped BigOperators

/-- Generic finite direction lift. -/
abbrev Lift (Q Gamma : Type*) [Fintype Q] [Fintype Gamma] :=
  (Q -> Gamma -> Real) -> Q -> Gamma -> Real

/-- A lift preserves the direction marginal at each base configuration. -/
def PreservesDirectionMarginal {Q Gamma : Type*} [Fintype Q] [Fintype Gamma]
    (L : Lift Q Gamma) : Prop :=
  ∀ rho q, (∑ omega, L rho q omega) = ∑ omega, rho q omega

/-- Composition of marginal-preserving finite Fock lifts preserves the marginal. -/
theorem preservesDirectionMarginal_comp
    {Q Gamma : Type*} [Fintype Q] [Fintype Gamma]
    (L1 L2 : Lift Q Gamma)
    (h1 : PreservesDirectionMarginal L1)
    (h2 : PreservesDirectionMarginal L2) :
    PreservesDirectionMarginal (fun rho q omega => L2 (L1 rho) q omega) := by
  intro rho q
  rw [h2, h1]

end NullStrandFockCompose
