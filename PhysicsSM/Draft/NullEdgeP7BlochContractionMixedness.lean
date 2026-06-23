import Mathlib.Tactic

/-!
# P7 Bloch contraction increases normalized mixedness

For a normalized celestial qubit, the scalar mixedness is `1 - r^2`. A unital
Bloch contraction `r |-> a r` with `0 <= a <= 1` cannot decrease this
mixedness. This is the finite qubit-channel guardrail for observer maps.
-/

namespace PhysicsSM.Draft.NullEdgeP7BlochContractionMixedness

def massRatioSqFromBlochRadius (r : Real) : Real :=
  1 - r ^ 2

theorem blochContraction_massRatioSq_monotone
    (a r : Real) (ha0 : 0 <= a) (ha1 : a <= 1) :
    massRatioSqFromBlochRadius r <= massRatioSqFromBlochRadius (a * r) := by
  unfold massRatioSqFromBlochRadius
  nlinarith [mul_le_mul_of_nonneg_left ha1 (sq_nonneg r)]

end PhysicsSM.Draft.NullEdgeP7BlochContractionMixedness
