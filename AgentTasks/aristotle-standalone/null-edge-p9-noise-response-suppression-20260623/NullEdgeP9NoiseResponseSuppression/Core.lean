import Mathlib.Tactic

/-!
# P9 observer-visible noise response suppression

This scalar finite model ties weighted residual second moments to an
observer-visible diagonal noise response.
-/

noncomputable section

namespace NullEdgeP9NoiseResponseSuppression

open BigOperators

def ampSqSum {N : Nat} (amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => amp i ^ 2

def diagonalNoiseResponse {N : Nat} (test amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => test i ^ 2 * amp i ^ 2

theorem diagonalNoiseResponse_nonneg {N : Nat}
    (test amp : Fin N -> Real) :
    0 <= diagonalNoiseResponse test amp := by
  sorry

theorem diagonalNoiseResponse_le_testBound_mul_ampSqSum {N : Nat}
    (test amp : Fin N -> Real) (T : Real)
    (hT : 0 <= T) (htest : forall i, test i ^ 2 <= T) :
    diagonalNoiseResponse test amp <= T * ampSqSum amp := by
  sorry

theorem diagonalNoiseResponse_eq_ampSqSum_for_unit_test {N : Nat}
    (amp : Fin N -> Real) :
    diagonalNoiseResponse (fun _ => 1) amp = ampSqSum amp := by
  sorry

end NullEdgeP9NoiseResponseSuppression
