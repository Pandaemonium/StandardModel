import Mathlib

open Matrix Complex

noncomputable section

namespace HNUCayleyCanonical

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

def cayleyGenerator (U : Mat4) : Mat4 :=
  Complex.I • (U - 1) * (U + 1)⁻¹

/-- Commutation with the inverse Cayley generator implies commutation with the
original unitary whenever the branch denominator is invertible. The unitary
hypothesis is retained to match the live HNU wrapper. -/
theorem commute_unitary_of_commute_cayley (U eps : Mat4)
    (hU : U ∈ Matrix.unitaryGroup (Fin 4) Complex)
    (hpi : (U + 1).det ≠ 0)
    (hcomm : eps * cayleyGenerator U = cayleyGenerator U * eps) :
    eps * U = U * eps := by
  sorry

end HNUCayleyCanonical
