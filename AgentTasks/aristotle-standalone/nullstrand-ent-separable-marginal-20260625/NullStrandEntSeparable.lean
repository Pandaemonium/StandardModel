import Mathlib

/-!
# NullStrand separable finite-law marginal target

ENT-003 support theorem: a finite separable product representation has
probability marginals.
-/

noncomputable section

namespace NullStrandEntSeparable

open scoped BigOperators

/-- Finite law on a type. -/
abbrev Law (Q : Type*) := Q -> Real

/-- Probability predicate for a finite real-valued law. -/
def IsProbability {Q : Type*} [Fintype Q] (rho : Law Q) : Prop :=
  (∀ q, 0 <= rho q) ∧ (∑ q, rho q = 1)

/-- Finite convex weights. -/
def IsConvexWeights {N : Type*} [Fintype N] (w : N -> Real) : Prop :=
  (∀ n, 0 <= w n) ∧ (∑ n, w n = 1)

/-- A finite separable product representation of a joint law. -/
structure SeparableRep {A B : Type*} [Fintype A] [Fintype B]
    (rho : Law (A × B)) where
  N : Type
  [instN : Fintype N]
  w : N -> Real
  hW : IsConvexWeights w
  left : N -> Law A
  right : N -> Law B
  hLeft : ∀ n, IsProbability (left n)
  hRight : ∀ n, IsProbability (right n)
  law_eq : ∀ a b, rho (a, b) = ∑ n, w n * left n a * right n b

/-- First marginal of a finite joint law. -/
def marginalA {A B : Type*} [Fintype B] (rho : Law (A × B)) : Law A :=
  fun a => ∑ b, rho (a, b)

/-- Second marginal of a finite joint law. -/
def marginalB {A B : Type*} [Fintype A] (rho : Law (A × B)) : Law B :=
  fun b => ∑ a, rho (a, b)

/-- ENT-003. A separable finite product representation has a probability first marginal. -/
theorem separableRep_marginalA_probability
    {A B : Type*} [Fintype A] [Fintype B] (rho : Law (A × B))
    (rep : SeparableRep rho) :
    IsProbability (marginalA rho) := by
  constructor
  · exact fun a => Finset.sum_nonneg fun b _ => rep.law_eq a b ▸
      Finset.sum_nonneg fun n _ =>
        mul_nonneg (mul_nonneg (rep.hW.1 n) (rep.hLeft n |>.1 a)) (rep.hRight n |>.1 b)
  · convert rep.hW.2
    convert Finset.sum_comm using 1
    simp +decide only [rep.law_eq]
    simp +decide only [← Finset.sum_comm, ← Finset.sum_mul, ← Finset.mul_sum _ _ _]
    exact Finset.sum_congr rfl fun n _ => by
      rw [rep.hLeft n |>.2, rep.hRight n |>.2, mul_one, mul_one]

/-- ENT-003. A separable finite product representation has a probability second marginal. -/
theorem separableRep_marginalB_probability
    {A B : Type*} [Fintype A] [Fintype B] (rho : Law (A × B))
    (rep : SeparableRep rho) :
    IsProbability (marginalB rho) := by
  refine ⟨?_, ?_⟩
  · intro b
    unfold marginalB
    exact Finset.sum_nonneg fun a _ => rep.law_eq a b ▸
      Finset.sum_nonneg fun n _ =>
        mul_nonneg (mul_nonneg (rep.hW.1 n) (rep.hLeft n |>.1 a)) (rep.hRight n |>.1 b)
  · have h_marginalB : ∑ b, marginalB rho b = ∑ a, ∑ b, rho (a, b) := Finset.sum_comm
    convert (separableRep_marginalA_probability rho rep).2 using 1

end NullStrandEntSeparable
