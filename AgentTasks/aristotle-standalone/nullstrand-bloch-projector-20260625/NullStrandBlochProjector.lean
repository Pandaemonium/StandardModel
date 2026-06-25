import Mathlib

/-!
# NullStrand Bloch direction projector (manifest node ENT-001)

`pureDirectionProjector`: a unit Bloch direction `ω ∈ ℝ³` maps to the
corresponding rank-one qubit projector `½(I + ω·σ)`. We record the three
defining properties used downstream by the separability obstruction (ENT-002/004):
trace one, Hermitian, and idempotent on the unit sphere (hence a rank-one
orthogonal projector).

Convention: `½(I + ω·σ)` with Pauli matrices `σ = (σx, σy, σz)`; entries written
explicitly. Mathlib-only; intended as a focused Aristotle target.
-/

noncomputable section

namespace NullStrand.Entanglement

open Matrix Complex
open scoped BigOperators

/-- The Bloch projector `½(I + ω·σ)` for a direction `ω ∈ ℝ³`. -/
def pureDirectionProjector (ω : Fin 3 → ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![((1 + ω 2 : ℝ) : ℂ) / 2, ((ω 0 : ℂ) - I * (ω 1 : ℂ)) / 2;
     ((ω 0 : ℂ) + I * (ω 1 : ℂ)) / 2, ((1 - ω 2 : ℝ) : ℂ) / 2]

/-- ENT-001a. The Bloch projector has unit trace. -/
theorem pureDirectionProjector_trace_eq_one (ω : Fin 3 → ℝ) :
    (pureDirectionProjector ω).trace = 1 := by
  sorry

/-- ENT-001b. The Bloch projector is Hermitian. -/
theorem pureDirectionProjector_isHermitian (ω : Fin 3 → ℝ) :
    (pureDirectionProjector ω).IsHermitian := by
  sorry

/-- ENT-001c. On the unit sphere the Bloch projector is idempotent, hence a
rank-one orthogonal projector. -/
theorem pureDirectionProjector_idempotent (ω : Fin 3 → ℝ)
    (hω : ω 0 ^ 2 + ω 1 ^ 2 + ω 2 ^ 2 = 1) :
    pureDirectionProjector ω * pureDirectionProjector ω = pureDirectionProjector ω := by
  sorry

end NullStrand.Entanglement
