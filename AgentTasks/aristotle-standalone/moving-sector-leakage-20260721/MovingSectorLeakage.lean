import Mathlib

/-!
# Leakage through a moving sequence of finite sectors

This focused target formalizes the finite algebra underlying adiabatic or
spectral-flow sector transport. A time-ordered product of contractive updates
is compared against a moving family of normalized projectors. The desired
bound says that final selected-to-complement leakage is at most the sum of the
one-step transport defects.

This file does not construct spectral projectors, prove a gap estimate, prove
quasi-locality, or instantiate the HNU regulator.
-/

noncomputable section

namespace MovingSectorLeakage

variable {A : Type*} [NormedRing A]

/-- Time-ordered product with the latest update on the left. -/
def walkProduct (U : Nat -> A) : Nat -> A
  | 0 => 1
  | n + 1 => U n * walkProduct U n

/-- A product of contractions is a contraction. -/
theorem norm_walkProduct_le_one
    (U : Nat -> A) (hU : forall k, norm (U k) <= 1) (n : Nat) :
    norm (walkProduct U n) <= 1 := by
  sorry

/-- Exact decomposition of the next-step leakage into the new transport defect
and the previously accumulated leakage. -/
theorem leakage_step_identity
    (U P : Nat -> A) (n : Nat) :
    (1 - P (n + 1)) * walkProduct U (n + 1) * P 0 =
      (1 - P (n + 1)) * U n * P n * walkProduct U n * P 0 +
      (1 - P (n + 1)) * U n * (1 - P n) *
        walkProduct U n * P 0 := by
  sorry

/-- One moving-sector step increases leakage by at most its local transport
defect. -/
theorem norm_leakage_succ_le
    (U P : Nat -> A)
    (hU : forall k, norm (U k) <= 1)
    (hPn : forall k, norm (P k) <= 1)
    (hPcn : forall k, norm (1 - P k) <= 1)
    (n : Nat) :
    norm ((1 - P (n + 1)) * walkProduct U (n + 1) * P 0) <=
      norm ((1 - P (n + 1)) * U n * P n) +
      norm ((1 - P n) * walkProduct U n * P 0) := by
  sorry

/-- Final leakage is bounded by the sum of all one-step moving-sector
transport defects. -/
theorem norm_moving_leakage_le_sum
    (U P : Nat -> A)
    (hU : forall k, norm (U k) <= 1)
    (hPn : forall k, norm (P k) <= 1)
    (hPcn : forall k, norm (1 - P k) <= 1)
    (n : Nat) :
    norm ((1 - P n) * walkProduct U n * P 0) <=
      Finset.sum (Finset.range n) fun k =>
        norm ((1 - P (k + 1)) * U k * P k) := by
  sorry

/-- A uniform one-step defect budget gives the simple depth-times-defect
estimate used by changing-regulator schedules. -/
theorem norm_moving_leakage_le_nat_mul
    (U P : Nat -> A) (epsilon : Real)
    (hU : forall k, norm (U k) <= 1)
    (hPn : forall k, norm (P k) <= 1)
    (hPcn : forall k, norm (1 - P k) <= 1)
    (hDefect : forall k,
      norm ((1 - P (k + 1)) * U k * P k) <= epsilon)
    (n : Nat) :
    norm ((1 - P n) * walkProduct U n * P 0) <=
      (n : Real) * epsilon := by
  sorry

/-- Exact moving-sector intertwining gives zero accumulated leakage. -/
theorem moving_leakage_eq_zero_of_exact
    (U P : Nat -> A)
    (hExact : forall k, (1 - P (k + 1)) * U k * P k = 0)
    (n : Nat) :
    (1 - P n) * walkProduct U n * P 0 = 0 := by
  sorry

end MovingSectorLeakage

end
