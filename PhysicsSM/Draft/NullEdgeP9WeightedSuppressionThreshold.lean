import Mathlib.Tactic

/-!
# P9 weighted residual suppression threshold

This module establishes the necessary condition threshold for weighted residual
noise to beat $1/\sqrt{V}$ everpresent-Lambda scaling in the P9 cosmological-constant branch.

It proves the Cauchy-Schwarz lower bound `(totalScale amp)^2 / N ≤ amplitudeSqSum amp`
and shows that if the total scale is at least `N`, then no weight distribution
can suppress the residual noise below the everpresent-Lambda scale `N`. Thus,
sub-extensivity of total scale is a strict necessary condition for any
suppression distribution to work.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9WeightedSuppressionThreshold

open BigOperators

/-- Sum of squared cell amplitudes. -/
def amplitudeSqSum {N : Nat} (amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => amp i ^ 2

/-- Total scale (sum of amplitudes). -/
def totalScale {N : Nat} (amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => amp i

/-- Everpresent-Lambda residual second moment. -/
def everpresentSecondMoment (N : Nat) : Real := (N : Real)

/-- Cauchy-Schwarz inequality for amplitudes: the square of the total scale divided by N
is a lower bound for the sum of squares. -/
theorem amplitudeSqSum_ge_totalScale_sq_div_card {N : Nat} (hN : 0 < N) (amp : Fin N -> Real) :
    (totalScale amp) ^ 2 / (N : Real) <= amplitudeSqSum amp := by
  rw [div_le_iff₀' (by positivity)]
  have := Finset.univ.sum_le_sum fun i _ => pow_two_nonneg (amp i - (∑ j, amp j) / N)
  simp_all +decide [sub_sq, Finset.sum_add_distrib]
  simp_all +decide [← Finset.mul_sum _ _ _, ← Finset.sum_mul, totalScale, amplitudeSqSum]
  nlinarith [mul_div_cancel₀ (∑ i, amp i) (by positivity : (N : ℝ) ≠ 0)]

/-- A necessary condition threshold: if the total scale A is at least N,
then the weighted residual second moment cannot be strictly less than the everpresent one. -/
theorem weighted_residual_cannot_beat_everpresent_of_extensive {N : Nat} (hN : 0 < N)
    (amp : Fin N -> Real) (hext : (N : Real) <= totalScale amp) :
    Not (amplitudeSqSum amp < everpresentSecondMoment N) := by
  have h_cauchy_schwarz :
      (Finset.sum Finset.univ (fun i => amp i)) ^ 2
        ≤ N * Finset.sum Finset.univ (fun i => amp i ^ 2) := by
    have h := fun (u v : Fin N → ℝ) => Finset.sum_mul_sq_le_sq_mul_sq Finset.univ u v
    simpa using h 1 amp
  unfold totalScale amplitudeSqSum everpresentSecondMoment at *
  nlinarith! [(by norm_cast : (1 : ℝ) ≤ N)]

/-- If the weighted residual second moment beats the everpresent one,
then the total scale must be strictly sub-extensive (less than N). -/
theorem sub_extensive_of_beats_everpresent {N : Nat} (hN : 0 < N) (amp : Fin N -> Real)
    (hbeat : amplitudeSqSum amp < everpresentSecondMoment N) :
    totalScale amp < (N : Real) := by
  contrapose! hbeat
  have := weighted_residual_cannot_beat_everpresent_of_extensive hN amp
  aesop

end PhysicsSM.Draft.NullEdgeP9WeightedSuppressionThreshold
