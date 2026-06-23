import Mathlib.Tactic

/-!
# P9 weighted finite noise-response bound

This focused package combines two P9 noise estimates into one reusable bound.
If an observer test is uniformly bounded and each cell weight is at most `eps`,
then the weighted diagonal noise response is bounded by
`T * eps * ampSqSum`.
-/

noncomputable section

namespace NullEdgeP9WeightedNoiseBound

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
  sorry

theorem weightedDiagonalNoiseResponse_le_testBound_mul_weightedAmpSqSum
    {N : Nat} (weight test amp : Fin N -> Real) (T : Real)
    (hT : 0 <= T)
    (hweight : forall i, 0 <= weight i)
    (htest : forall i, test i ^ 2 <= T) :
    weightedDiagonalNoiseResponse weight test amp <=
      T * weightedAmpSqSum weight amp := by
  sorry

theorem weightedAmpSqSum_le_eps_mul_ampSqSum
    {N : Nat} (weight amp : Fin N -> Real) (eps : Real)
    (hweight : forall i, 0 <= weight i)
    (hmax : forall i, weight i <= eps) :
    weightedAmpSqSum weight amp <= eps * ampSqSum amp := by
  sorry

theorem weightedDiagonalNoiseResponse_le_testBound_mul_eps_mul_ampSqSum
    {N : Nat} (weight test amp : Fin N -> Real) (T eps : Real)
    (hT : 0 <= T)
    (hweight : forall i, 0 <= weight i)
    (hmax : forall i, weight i <= eps)
    (htest : forall i, test i ^ 2 <= T) :
    weightedDiagonalNoiseResponse weight test amp <=
      T * eps * ampSqSum amp := by
  sorry

end NullEdgeP9WeightedNoiseBound
