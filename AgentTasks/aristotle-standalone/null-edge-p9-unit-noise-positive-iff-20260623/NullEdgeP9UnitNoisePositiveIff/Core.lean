import Mathlib.Tactic

/-!
# P9 unit-test noise positivity iff a residual is nonzero

For the unit observer test, diagonal noise response is just the residual
amplitude square sum.
-/

noncomputable section

namespace NullEdgeP9UnitNoisePositiveIff

open BigOperators

def ampSqSum {N : Nat} (amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => amp i ^ 2

def diagonalNoiseResponse {N : Nat} (test amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => test i ^ 2 * amp i ^ 2

theorem diagonalNoiseResponse_eq_ampSqSum_for_unit_test {N : Nat}
    (amp : Fin N -> Real) :
    diagonalNoiseResponse (fun _ => 1) amp = ampSqSum amp := by
  sorry

theorem unitNoiseResponse_pos_iff_exists_nonzero {N : Nat}
    (amp : Fin N -> Real) :
    0 < diagonalNoiseResponse (fun _ => 1) amp <->
      Exists fun i => amp i = 0 -> False := by
  sorry

end NullEdgeP9UnitNoisePositiveIff
