import Mathlib

/-!
# NullStrand finite Fock lift iteration target

Finite marginal-preservation theorem for iterating a creation/annihilation-style
direction lift.
-/

noncomputable section

namespace NullStrandFockIterate

open scoped BigOperators

/-- Generic finite direction lift. -/
abbrev Lift (Q Gamma : Type*) [Fintype Q] [Fintype Gamma] :=
  (Q -> Gamma -> Real) -> Q -> Gamma -> Real

/-- A lift preserves the direction marginal at each base configuration. -/
def PreservesDirectionMarginal {Q Gamma : Type*} [Fintype Q] [Fintype Gamma]
    (L : Lift Q Gamma) : Prop :=
  ∀ rho q, (∑ omega, L rho q omega) = ∑ omega, rho q omega

/-- The identity lift preserves direction marginals. -/
theorem preservesDirectionMarginal_id
    {Q Gamma : Type*} [Fintype Q] [Fintype Gamma] :
    PreservesDirectionMarginal (fun rho : Q -> Gamma -> Real => rho) := by
  intro rho q
  rfl

/-- Composition of marginal-preserving finite Fock lifts preserves the marginal. -/
theorem preservesDirectionMarginal_comp
    {Q Gamma : Type*} [Fintype Q] [Fintype Gamma]
    (L1 L2 : Lift Q Gamma)
    (h1 : PreservesDirectionMarginal L1)
    (h2 : PreservesDirectionMarginal L2) :
    PreservesDirectionMarginal (fun rho q omega => L2 (L1 rho) q omega) := by
  intro rho q
  simp only
  rw [h2 (L1 rho) q, h1 rho q]

/-- Iterating a marginal-preserving finite Fock lift preserves the marginal. -/
theorem preservesDirectionMarginal_iterate
    {Q Gamma : Type*} [Fintype Q] [Fintype Gamma]
    (L : Lift Q Gamma) (hL : PreservesDirectionMarginal L) (n : Nat) :
    PreservesDirectionMarginal (L^[n]) := by
  induction n with
  | zero =>
      intro rho q
      simp
  | succ k ih =>
      intro rho q
      rw [Function.iterate_succ']
      simp only [Function.comp_apply]
      rw [hL (L^[k] rho) q, ih rho q]

end NullStrandFockIterate
