import Mathlib

/-!
# Leakage through a moving sequence of finite sectors

This module formalizes the finite algebra underlying adiabatic or spectral-flow
sector transport. A time-ordered product of contractive updates is compared
with a moving family of contractive projectors. Final selected-to-complement
leakage is bounded by the sum of the one-step transport defects.

The projector idempotence hypothesis is essential. Without it, the zero-step
case is false: over the reals, `P k = 1 / 2` and `U k = 0` satisfy the relevant
norm and exact-step conditions but leave initial leakage `1 / 4`.

This file does not construct spectral projectors, prove a quasienergy gap,
prove quasi-locality, or instantiate the HNU regulator.

Provenance: Aristotle project `4f8edbcc-b25b-48df-ba57-9613c016e8bb`, task
`e66d42b7-1d2d-4017-a283-526a9966774a`, locally integrated with the returned
statement repair. The theorem shape is the algebraic telescope used beneath
discrete adiabatic transport; no external code was copied.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.MovingSectorLeakage

variable {A : Type*} [NormedRing A]

/-- Time-ordered product with the latest update on the left. -/
def walkProduct (U : Nat -> A) : Nat -> A
  | 0 => 1
  | n + 1 => U n * walkProduct U n

/-- A product of contractions is a contraction. The explicit unit hypothesis
is needed because a generic `NormedRing` does not require `norm 1 <= 1`. -/
theorem norm_walkProduct_le_one
    (U : Nat -> A) (hOne : norm (1 : A) <= 1)
    (hU : forall k, norm (U k) <= 1) (n : Nat) :
    norm (walkProduct U n) <= 1 := by
  induction n with
  | zero => simpa [walkProduct] using hOne
  | succ n ih =>
      rw [walkProduct]
      exact (norm_mul_le _ _).trans (mul_le_one₀ (hU n) (norm_nonneg _) ih)

/-- A time-ordered product applied to a contraction is a contraction, without
requiring the ring unit itself to have norm at most one. -/
theorem norm_walkProduct_mul_le_one
    (U : Nat -> A) (x : A)
    (hU : forall k, norm (U k) <= 1) (hx : norm x <= 1) (n : Nat) :
    norm (walkProduct U n * x) <= 1 := by
  induction' n with n ih
  · simpa [walkProduct] using hx
  · rw [show walkProduct U (n + 1) * x =
        U n * (walkProduct U n * x) by
          rw [show walkProduct U (n + 1) = U n * walkProduct U n from rfl]
          rw [← mul_assoc]]
    exact le_trans (norm_mul_le _ _)
      (mul_le_one₀ (hU n) (norm_nonneg _) ih)

/-- Exact decomposition of the next-step leakage into the new transport defect
and the previously accumulated leakage. -/
theorem leakage_step_identity
    (U P : Nat -> A) (n : Nat) :
    (1 - P (n + 1)) * walkProduct U (n + 1) * P 0 =
      (1 - P (n + 1)) * U n * P n * walkProduct U n * P 0 +
      (1 - P (n + 1)) * U n * (1 - P n) *
        walkProduct U n * P 0 := by
  simp +decide [mul_assoc, sub_mul, mul_sub]
  simp +decide only [walkProduct, ← mul_assoc]

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
  have h_triangle :
      norm ((1 - P (n + 1)) * walkProduct U (n + 1) * P 0) <=
        norm ((1 - P (n + 1)) * U n * P n * walkProduct U n * P 0) +
        norm ((1 - P (n + 1)) * U n * (1 - P n) *
          walkProduct U n * P 0) := by
    convert norm_add_le _ _ using 2
    rw [leakage_step_identity]
  refine le_trans h_triangle (add_le_add ?_ ?_)
  · have hfirst :
        norm ((1 - P (n + 1)) * U n * P n * walkProduct U n * P 0) <=
          norm ((1 - P (n + 1)) * U n * P n) *
            norm (walkProduct U n * P 0) := by
      simpa only [mul_assoc] using
        norm_mul_le ((1 - P (n + 1)) * U n * P n)
          (walkProduct U n * P 0)
    exact hfirst.trans (mul_le_of_le_one_right (norm_nonneg _)
      (norm_walkProduct_mul_le_one U (P 0) hU (hPn 0) n))
  · have hnorm :
        norm ((1 - P (n + 1)) * U n * (1 - P n) *
          walkProduct U n * P 0) <=
          norm (1 - P (n + 1)) * norm (U n) *
            norm ((1 - P n) * walkProduct U n * P 0) := by
      simpa only [mul_assoc] using norm_mul_le _ _ |>.trans
        (mul_le_mul_of_nonneg_left (norm_mul_le _ _) (by positivity))
    exact hnorm.trans (mul_le_of_le_one_left (norm_nonneg _)
      (mul_le_one₀ (hPcn _) (norm_nonneg _) (hU _)))

/-- Final leakage is bounded by the sum of all one-step moving-sector
transport defects. Idempotence is explicit because the base case uses
`(1 - P 0) * P 0 = 0`; norm bounds alone do not imply this identity. -/
theorem norm_moving_leakage_le_sum
    (U P : Nat -> A)
    (hU : forall k, norm (U k) <= 1)
    (hPn : forall k, norm (P k) <= 1)
    (hPcn : forall k, norm (1 - P k) <= 1)
    (hP_idem : forall k, P k * P k = P k)
    (n : Nat) :
    norm ((1 - P n) * walkProduct U n * P 0) <=
      Finset.sum (Finset.range n) fun k =>
        norm ((1 - P (k + 1)) * U k * P k) := by
  induction' n with n ih
  · simp +decide [walkProduct]
    rw [sub_mul, one_mul, sub_eq_zero, hP_idem]
  · convert le_trans (norm_leakage_succ_le U P hU hPn hPcn n) _ using 1
    rw [Finset.sum_range_succ]
    linarith

/-- A uniform one-step defect budget gives the simple depth-times-defect
estimate used by changing-regulator schedules. -/
theorem norm_moving_leakage_le_nat_mul
    (U P : Nat -> A) (epsilon : Real)
    (hU : forall k, norm (U k) <= 1)
    (hPn : forall k, norm (P k) <= 1)
    (hPcn : forall k, norm (1 - P k) <= 1)
    (hP_idem : forall k, P k * P k = P k)
    (hDefect : forall k,
      norm ((1 - P (k + 1)) * U k * P k) <= epsilon)
    (n : Nat) :
    norm ((1 - P n) * walkProduct U n * P 0) <=
      (n : Real) * epsilon := by
  convert norm_moving_leakage_le_sum U P hU hPn hPcn hP_idem n |>.trans
    (Finset.sum_le_sum fun i _ => hDefect i) using 1
  simp +decide [mul_comm]

/-- Exact moving-sector intertwining gives zero accumulated leakage. -/
theorem moving_leakage_eq_zero_of_exact
    (U P : Nat -> A)
    (hP_idem : forall k, P k * P k = P k)
    (hExact : forall k, (1 - P (k + 1)) * U k * P k = 0)
    (n : Nat) :
    (1 - P n) * walkProduct U n * P 0 = 0 := by
  induction' n with n ih
  · simp +decide [walkProduct, sub_mul, hP_idem]
  · convert congrArg
      (fun x =>
        (1 - P (n + 1)) * U n * P n * walkProduct U n * P 0 +
        (1 - P (n + 1)) * U n * (1 - P n) *
          walkProduct U n * P 0) ih using 1
    · exact leakage_step_identity U P n
    · simp_all +decide [mul_assoc]

end PhysicsSM.Draft.NullEdge.MovingSectorLeakage
