import Mathlib

open Matrix Complex

noncomputable section

namespace ContinuousProjectorRank

/-- The concrete matrix size needed by the HNU four-spinor band projector. -/
abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- An idempotent complex matrix has trace equal to its finite rank. -/
theorem trace_eq_rank_of_idempotent (P : Mat4) (hP : P * P = P) :
    Matrix.trace P = ((Matrix.rank P : Nat) : Complex) := by
  sorry

/-- A continuous real-parameter family of idempotent four-by-four complex
matrices has constant rank.  No Hermitian hypothesis should be needed. -/
theorem continuous_idempotent_rank_constant
    (P : Real -> Mat4)
    (hcont : Continuous P)
    (hidem : forall t, P t * P t = P t) :
    forall t, Matrix.rank (P t) = Matrix.rank (P 0) := by
  sorry

/-- The specialization needed after identifying the HNU rest projector as a
rank-two projector. -/
theorem continuous_rank_two_of_rest
    (P : Real -> Mat4)
    (hcont : Continuous P)
    (hidem : forall t, P t * P t = P t)
    (hrest : Matrix.rank (P 0) = 2) :
    forall t, Matrix.rank (P t) = 2 := by
  sorry

end ContinuousProjectorRank
