import Mathlib.Tactic

/-!
# P9 weighted finite noise-response bound

This draft module combines two P9 noise estimates into one reusable bound. If an
observer test is uniformly bounded and each cell weight is at most `eps`, then
the weighted diagonal noise response is bounded by `T * eps * ampSqSum`.

Proven by Aristotle project `9812606b-fbd9-4207-8833-3fc79a33e1bf` on
2026-06-23 from the focused package `null-edge-p9-weighted-noise-bound-20260623`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9WeightedNoiseBound

open BigOperators

def ampSqSum {N : Nat} (amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => amp i ^ 2

def weightedAmpSqSum {N : Nat} (weight amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => weight i * amp i ^ 2

def weightedDiagonalNoiseResponse {N : Nat}
    (weight test amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => weight i * test i ^ 2 * amp i ^ 2

theorem weightedDiagonalNoiseResponse_nonneg {N : Nat}
    (weight test amp : Fin N -> Real)
    (hweight : forall i, 0 <= weight i) :
    0 <= weightedDiagonalNoiseResponse weight test amp := by
  exact Finset.sum_nonneg fun i _ =>
    mul_nonneg (mul_nonneg (hweight i) (sq_nonneg _)) (sq_nonneg _)

theorem weightedDiagonalNoiseResponse_le_testBound_mul_weightedAmpSqSum
    {N : Nat} (weight test amp : Fin N -> Real) (T : Real)
    (_hT : 0 <= T)
    (hweight : forall i, 0 <= weight i)
    (htest : forall i, test i ^ 2 <= T) :
    weightedDiagonalNoiseResponse weight test amp <=
      T * weightedAmpSqSum weight amp := by
  unfold weightedDiagonalNoiseResponse weightedAmpSqSum
  rw [Finset.mul_sum _ _ _]
  exact Finset.sum_le_sum fun i _ =>
    by nlinarith only [hweight i, mul_nonneg (hweight i) (sq_nonneg (amp i)),
      mul_le_mul_of_nonneg_left (htest i) (hweight i)]

theorem weightedAmpSqSum_le_eps_mul_ampSqSum
    {N : Nat} (weight amp : Fin N -> Real) (eps : Real)
    (_hweight : forall i, 0 <= weight i)
    (hmax : forall i, weight i <= eps) :
    weightedAmpSqSum weight amp <= eps * ampSqSum amp := by
  unfold weightedAmpSqSum ampSqSum
  simpa only [Finset.mul_sum _ _ _] using
    Finset.sum_le_sum fun i _ =>
      mul_le_mul_of_nonneg_right (hmax i) (sq_nonneg _)

theorem weightedDiagonalNoiseResponse_le_testBound_mul_eps_mul_ampSqSum
    {N : Nat} (weight test amp : Fin N -> Real) (T eps : Real)
    (hT : 0 <= T)
    (hweight : forall i, 0 <= weight i)
    (hmax : forall i, weight i <= eps)
    (htest : forall i, test i ^ 2 <= T) :
    weightedDiagonalNoiseResponse weight test amp <=
      T * eps * ampSqSum amp := by
  convert
    weightedDiagonalNoiseResponse_le_testBound_mul_weightedAmpSqSum
      weight test amp T hT hweight htest |>.trans
        (mul_le_mul_of_nonneg_left
          (weightedAmpSqSum_le_eps_mul_ampSqSum weight amp eps hweight hmax) hT)
    using 1
  ring

end PhysicsSM.Draft.NullEdgeP9WeightedNoiseBound
