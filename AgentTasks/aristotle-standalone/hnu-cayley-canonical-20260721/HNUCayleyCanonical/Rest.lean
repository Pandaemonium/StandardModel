import Mathlib

open Matrix Complex

noncomputable section

namespace HNUCayleyCanonical

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

def beta : Mat4 :=
  !![1, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

def restU (a : Real) : Mat4 :=
  (Complex.cos a) • (1 : Mat4) -
    (Complex.I * Complex.sin a) • beta

def cayleyGenerator (U : Mat4) : Mat4 :=
  Complex.I • (U - 1) * (U + 1)⁻¹

/-- Exact inverse-Cayley rest formula on the principal mass-angle interval. -/
theorem rest_cayley_eq_tan_beta (a : Real)
    (ha0 : 0 < a) (hapi : a < Real.pi) :
    cayleyGenerator (restU a) =
      (Real.tan (a / 2) : Complex) • beta := by
  sorry

/-- The half-angle coefficient has the sign needed by the projector
convention. -/
theorem tan_half_pos (a : Real) (ha0 : 0 < a) (hapi : a < Real.pi) :
    0 < Real.tan (a / 2) := by
  sorry

end HNUCayleyCanonical
