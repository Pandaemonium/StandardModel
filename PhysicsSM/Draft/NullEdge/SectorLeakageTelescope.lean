import Mathlib

/-!
# Quantitative accumulation of selected-sector leakage

This module gives the relaxed complement to exact interaction-sector
invariance. It proves a commutator telescope for powers of a contraction,
turns it into a leakage bound for an idempotent sector projector, and packages
a changing-regulator criterion under which accumulated leakage vanishes.

The result consumes a projector and a one-step commutator estimate. It does not
derive the physical HNU projector, an interaction-range estimate, positivity,
or an interacting continuum limit.

Provenance: Aristotle project `8bffcfa2-68af-4570-a536-3acdf0536db4`, task
`9f9f178f-cad2-4204-9c32-ccac8357d476`, locally rechecked under the pinned
toolchain on 2026-07-21. Claim grade M, [comp].
-/

open Filter
open scoped Topology

noncomputable section

namespace SectorLeakageTelescope

variable {A : Type*} [NormedRing A]

/-- Exact noncommutative telescope for the commutator of a power. -/
theorem commutator_pow_telescope (U P : A) (n : Nat) :
    U ^ n * P - P * U ^ n =
      Finset.sum (Finset.range n) fun k =>
        U ^ k * (U * P - P * U) * U ^ (n - 1 - k) := by
  induction' n with n ih;
  · simp +decide;
  · simp_all +decide [mul_sub, sub_mul, Finset.sum_range_succ'];
    simp_all +decide [sub_eq_iff_eq_add, mul_assoc, add_sub_add_comm];
    convert congr_arg (fun x => U * x) ih using 1 <;>
      simp +decide [pow_succ', mul_assoc] ; abel_nf;
    simp +decide [mul_add, Finset.mul_sum _ _ _, tsub_tsub, add_comm]

/-- A contraction accumulates at most linearly the one-step failure to commute
with a declared sector projector. -/
theorem norm_commutator_pow_le
    (U P : A) (n : Nat) (hU : norm U <= 1) :
    norm (U ^ n * P - P * U ^ n) <=
      (n : Real) * norm (U * P - P * U) := by
  by_contra h_contra
  have ih (n : Nat) (h_n : 1 <= n) :
      norm (U ^ n * P - P * U ^ n) <=
        n * norm (U * P - P * U) := by
    induction' h_n with n hn ih <;>
      simp_all +decide [pow_succ, mul_assoc]
    have h_triangle :
        norm (U ^ n * (U * P) - P * (U ^ n * U)) <=
          norm (U ^ n * (U * P - P * U)) +
            norm ((U ^ n * P - P * U ^ n) * U) := by
      convert norm_add_le
        (U ^ n * (U * P - P * U))
        ((U ^ n * P - P * U ^ n) * U) using 2 <;>
          simp +decide [mul_sub, sub_mul, mul_assoc]
    refine le_trans h_triangle
      (le_trans (add_le_add (norm_mul_le _ _) (norm_mul_le _ _)) ?_)
    refine le_trans
      (add_le_add
        (mul_le_mul_of_nonneg_right
          (show norm (U ^ n) <= 1 from ?_) (norm_nonneg _))
        (mul_le_mul_of_nonneg_left hU (norm_nonneg _))) ?_
    · exact le_trans (norm_pow_le' _ (by linarith))
        (pow_le_one₀ (norm_nonneg _) hU)
    · linarith
  exact h_contra (if hn : 1 <= n then ih n hn else by aesop)

/-- Algebraic identity converting selected-to-complement leakage into the
commutator with an idempotent projector. -/
theorem leakage_eq_commutator
    (U P : A) (n : Nat) (hP : P * P = P) :
    (1 - P) * U ^ n * P =
      (1 - P) * (U ^ n * P - P * U ^ n) * P := by
  simp +decide [sub_mul, mul_sub, mul_assoc, hP]
  simp +decide [← mul_assoc, hP]

/-- Quantitative leakage bound for a contractive step and a normalized
idempotent projector. -/
theorem norm_leakage_pow_le
    (U P : A) (n : Nat)
    (hU : norm U <= 1) (hP : P * P = P)
    (hPn : norm P <= 1) (hPcn : norm (1 - P) <= 1) :
    norm ((1 - P) * U ^ n * P) <=
      (n : Real) * norm (U * P - P * U) := by
  rw [leakage_eq_commutator U P n hP, mul_assoc]
  refine le_trans (norm_mul_le _ _) ?_
  refine le_trans
    (mul_le_mul_of_nonneg_left (norm_mul_le _ _) (norm_nonneg _)) ?_
  refine le_trans
    (mul_le_mul_of_nonneg_right hPcn
      (mul_nonneg (norm_nonneg _) (norm_nonneg _))) ?_
  exact le_trans
    (mul_le_mul_of_nonneg_left
      (mul_le_of_le_one_right (norm_nonneg _) hPn) zero_le_one)
    (by simpa using norm_commutator_pow_le U P n hU)

/-- A changing-regulator family has vanishing selected-sector leakage whenever
its one-step commutator budget beats the accumulated depth. -/
theorem leakage_tendsto_of_budget
    (U : Nat -> A) (P : A) (epsilon : Nat -> Real)
    (hU : forall n, norm (U n) <= 1)
    (hP : P * P = P) (hPn : norm P <= 1)
    (hPcn : norm (1 - P) <= 1)
    (hComm : forall n, norm (U n * P - P * U n) <= epsilon n)
    (hBudget : Tendsto (fun n : Nat => (n : Real) * epsilon n)
      atTop (nhds 0)) :
    Tendsto (fun n : Nat => norm ((1 - P) * (U n) ^ n * P))
      atTop (nhds 0) := by
  refine squeeze_zero (fun n => norm_nonneg _) (fun n => ?_) hBudget
  exact norm_leakage_pow_le (U n) P n (hU n) hP hPn hPcn |>
    le_trans <| mul_le_mul_of_nonneg_left (hComm n) <| Nat.cast_nonneg _

/-- Exponential suppression in a linearly growing interaction range beats
linear accumulation in the number of steps. -/
theorem nat_mul_exp_neg_tendsto (c : Real) (hc : 0 < c) :
    Tendsto (fun n : Nat => (n : Real) * Real.exp (-c * (n : Real)))
      atTop (nhds 0) := by
  convert Tendsto.const_mul c⁻¹
    (Real.tendsto_pow_mul_exp_neg_atTop_nhds_zero 1 |>
      Filter.Tendsto.comp <|
        tendsto_natCast_atTop_atTop.const_mul_atTop hc) using 2 <;> ring_nf
  grind

/-- Ready-to-use exponentially suppressed leakage schedule. -/
theorem leakage_tendsto_of_exponential_commutator
    (U : Nat -> A) (P : A) (c : Real)
    (hU : forall n, norm (U n) <= 1)
    (hP : P * P = P) (hPn : norm P <= 1)
    (hPcn : norm (1 - P) <= 1)
    (hc : 0 < c)
    (hComm : forall n,
      norm (U n * P - P * U n) <= Real.exp (-c * (n : Real))) :
    Tendsto (fun n : Nat => norm ((1 - P) * (U n) ^ n * P))
      atTop (nhds 0) := by
  apply leakage_tendsto_of_budget U P
    (fun n => Real.exp (-c * n)) hU hP hPn hPcn hComm
  convert nat_mul_exp_neg_tendsto c hc

end SectorLeakageTelescope

end
