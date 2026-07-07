import Mathlib

/-!
# M4 Pauli/Pontryagin inertia certificate

Mathlib-only handoff certificate for the corrected M4(C) Pauli witness.  This
file does not import or edit Carrier code.  It supplies the concrete rank data
that upgrades the prose statement "J has inertia (2,2)" from the weaker
Hermitian-involution plus trace-zero ingredients to an explicit positive/negative
diagonal-slot count.

The full witness skeleton remains in the Aristotle output packet; this small
file records the extra certificate requested by the Claude review
`AgentTasks/model-calls/claude/2026-07-07-031041-m4-pontryagin-witness-review.md`.
-/

noncomputable section

open Matrix Complex

namespace M4PauliPontryaginInertiaCertificate

abbrev M := Matrix (Fin 4) (Fin 4) ℂ

/-- The fundamental symmetry `J = diag(1,1,-1,-1)` from the M4 witness. -/
def Jc : M := !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]

/-- The positive diagonal slots of `Jc`. -/
def JcPositiveIndices : Finset (Fin 4) := {0, 1}

/-- The negative diagonal slots of `Jc`. -/
def JcNegativeIndices : Finset (Fin 4) := {2, 3}

/-- The named positive slots are exactly the diagonal entries equal to `1`. -/
theorem Jc_positiveIndices_spec (i : Fin 4) :
    i ∈ JcPositiveIndices ↔ Jc i i = (1 : ℂ) := by
  fin_cases i <;> simp [JcPositiveIndices, Jc] <;> norm_num [Complex.ext_iff]

/-- The named negative slots are exactly the diagonal entries equal to `-1`. -/
theorem Jc_negativeIndices_spec (i : Fin 4) :
    i ∈ JcNegativeIndices ↔ Jc i i = (-1 : ℂ) := by
  fin_cases i <;> simp [JcNegativeIndices, Jc] <;> norm_num [Complex.ext_iff]

/-- Explicit inertia certificate for the diagonal fundamental symmetry:
two positive and two negative slots, hence Pontryagin index `kappa = 2` for this
finite diagonal model. -/
theorem Jc_inertia_two_two :
    JcPositiveIndices.card = 2 ∧ JcNegativeIndices.card = 2 := by
  simp [JcPositiveIndices, JcNegativeIndices]

end M4PauliPontryaginInertiaCertificate

end
