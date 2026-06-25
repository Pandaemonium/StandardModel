import Mathlib

/-!
# NullStrand.Entanglement.DirectionProjector

Manifest node ENT-001: a unit Bloch direction `ω ∈ ℝ³` maps to the rank-one qubit
projector `½(I + ω·σ)`. Records the three defining properties used downstream by
the separability obstruction (ENT-002/004): unit trace, Hermitian, and idempotent
on the unit sphere (hence a rank-one orthogonal projector).

Provenance: clean-room statements; proofs from Aristotle project
`cca2a5c7-538b-47b2-b5ba-d63b74560350`, verified `sorry`/`axiom`-free and
statement-identical, integrated 2026-06-25.
-/

noncomputable section

namespace PhysicsSM.NullStrand.Entanglement

open Matrix Complex
open scoped BigOperators

/-- The Bloch projector `½(I + ω·σ)` for a direction `ω ∈ ℝ³`. -/
def pureDirectionProjector (ω : Fin 3 → ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![((1 + ω 2 : ℝ) : ℂ) / 2, ((ω 0 : ℂ) - I * (ω 1 : ℂ)) / 2;
     ((ω 0 : ℂ) + I * (ω 1 : ℂ)) / 2, ((1 - ω 2 : ℝ) : ℂ) / 2]

/-- ENT-001a. The Bloch projector has unit trace. -/
theorem pureDirectionProjector_trace_eq_one (ω : Fin 3 → ℝ) :
    (pureDirectionProjector ω).trace = 1 := by
  simp only [pureDirectionProjector, Matrix.trace_fin_two_of]
  push_cast
  ring

/-- ENT-001b. The Bloch projector is Hermitian. -/
theorem pureDirectionProjector_isHermitian (ω : Fin 3 → ℝ) :
    (pureDirectionProjector ω).IsHermitian := by
  unfold pureDirectionProjector
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.conjTranspose_apply, Complex.conj_I, Complex.conj_ofReal, sub_eq_add_neg]

/-- ENT-001c. On the unit sphere the Bloch projector is idempotent, hence a
rank-one orthogonal projector. -/
theorem pureDirectionProjector_idempotent (ω : Fin 3 → ℝ)
    (hω : ω 0 ^ 2 + ω 1 ^ 2 + ω 2 ^ 2 = 1) :
    pureDirectionProjector ω * pureDirectionProjector ω = pureDirectionProjector ω := by
  unfold pureDirectionProjector
  rw [Matrix.mul_fin_two]
  have hsq : ((ω 0 : ℂ)) ^ 2 + (ω 1 : ℂ) ^ 2 + (ω 2 : ℂ) ^ 2 = 1 := by exact_mod_cast hω
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp only [Matrix.of_apply, Matrix.cons_val'] <;>
    push_cast <;> ring_nf <;> rw [Complex.I_sq] <;>
    linear_combination (1 / 4 : ℂ) * hsq

end PhysicsSM.NullStrand.Entanglement
