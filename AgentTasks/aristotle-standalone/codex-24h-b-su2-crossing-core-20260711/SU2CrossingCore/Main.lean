import Mathlib

/-!
# Exact determinant-one SU(2) crossing locking

This standalone target isolates the two load-bearing matrix lemmas from the
larger project job that stalled during a full-repository build.  Preserve both
theorem statements exactly.  Do not add hypotheses or replace matrix equality
with a weaker spectral statement.
-/

open Matrix Complex

noncomputable section

namespace SU2CrossingCore

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

def IsUnitary2 (U : M2) : Prop :=
  U.conjTranspose * U = 1 ∧ U * U.conjTranspose = 1

/-- In a determinant-one unitary two-band sector, a `+1` eigenvalue locks the
whole matrix to `+I`. -/
theorem det_sub_one_eq_zero_iff_eq_one (U : M2)
    (hU : IsUnitary2 U) (hdet : U.det = 1) :
    (U - 1).det = 0 ↔ U = 1 := by
  sorry

/-- In a determinant-one unitary two-band sector, a `-1` eigenvalue locks the
whole matrix to `-I`. -/
theorem det_add_one_eq_zero_iff_eq_neg_one (U : M2)
    (hU : IsUnitary2 U) (hdet : U.det = 1) :
    (U + 1).det = 0 ↔ U = -(1 : M2) := by
  sorry

end SU2CrossingCore
