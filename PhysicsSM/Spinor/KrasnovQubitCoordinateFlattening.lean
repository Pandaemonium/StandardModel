import Mathlib
import PhysicsSM.Spinor.KrasnovQubitComplexCoordinates

/-!
# Spinor.KrasnovQubitCoordinateFlattening

Flatten `QubitComplexCoordinates` to a plain function `Fin 8 → ℂ` and express
`rightMulE111` as a diagonal coordinate operator.

## Coordinate ordering

The flattening uses the following index convention:

| Index | Field                |
|-------|----------------------|
| 0     | `fstLine`            |
| 1     | `fstComplement 0`    |
| 2     | `fstComplement 1`    |
| 3     | `fstComplement 2`    |
| 4     | `sndLine`            |
| 5     | `sndComplement 0`    |
| 6     | `sndComplement 1`    |
| 7     | `sndComplement 2`    |

## Eigenvalue structure

Under this flattening, `rightMulE111` acts diagonally:

- indices 0, 4 (line coordinates): eigenvalue `Complex.I`
- indices 1, 2, 3, 5, 6, 7 (complement coordinates): eigenvalue `-Complex.I`

## Claim boundary

This is coordinate bookkeeping only. No `Spin(9)` centralizer theorem or
Standard Model subgroup theorem is claimed.

Status: trusted — no `sorry`.

Provenance: integrated from Aristotle job
`3156280f-61d4-4885-81f9-2b34065a1d5f`; see
`AgentTasks/krasnov-qubit-coordinate-flattening-aristotle-2026-05-29.md`.
-/

namespace PhysicsSM.Spinor.KrasnovComplexStructure

open Complex
open PhysicsSM.Spinor.OctonionicQubit

/-! ## Flattening and unflattening -/

/-- Flatten `QubitComplexCoordinates` to a function `Fin 8 → ℂ`.

    Index mapping:
    `0 = fstLine`, `1..3 = fstComplement 0..2`,
    `4 = sndLine`, `5..7 = sndComplement 0..2`. -/
noncomputable def QubitComplexCoordinates.toComplexVec
    (c : QubitComplexCoordinates) : Fin 8 → ℂ :=
  fun i =>
    match i with
    | ⟨0, _⟩ => c.fstLine
    | ⟨1, _⟩ => c.fstComplement 0
    | ⟨2, _⟩ => c.fstComplement 1
    | ⟨3, _⟩ => c.fstComplement 2
    | ⟨4, _⟩ => c.sndLine
    | ⟨5, _⟩ => c.sndComplement 0
    | ⟨6, _⟩ => c.sndComplement 1
    | ⟨7, _⟩ => c.sndComplement 2

/-- Construct `QubitComplexCoordinates` from a function `Fin 8 → ℂ`.

    Index mapping:
    `0 = fstLine`, `1..3 = fstComplement 0..2`,
    `4 = sndLine`, `5..7 = sndComplement 0..2`. -/
noncomputable def QubitComplexCoordinates.ofComplexVec
    (v : Fin 8 → ℂ) : QubitComplexCoordinates :=
  { fstLine := v 0
    fstComplement := fun k =>
      match k with
      | 0 => v 1
      | 1 => v 2
      | 2 => v 3
    sndLine := v 4
    sndComplement := fun k =>
      match k with
      | 0 => v 5
      | 1 => v 6
      | 2 => v 7 }

/-! ## Round-trip lemmas -/

/-- Round trip: `ofComplexVec ∘ toComplexVec = id`. -/
theorem QubitComplexCoordinates.ofComplexVec_toComplexVec
    (c : QubitComplexCoordinates) :
    QubitComplexCoordinates.ofComplexVec c.toComplexVec = c := by
  simp only [ofComplexVec, toComplexVec]
  apply QubitComplexCoordinates.ext <;> try rfl
  all_goals { ext k; fin_cases k <;> rfl }

/-- Round trip: `toComplexVec ∘ ofComplexVec = id`. -/
theorem QubitComplexCoordinates.toComplexVec_ofComplexVec
    (v : Fin 8 → ℂ) :
    (QubitComplexCoordinates.ofComplexVec v).toComplexVec = v := by
  funext i; fin_cases i <;> simp [ofComplexVec, toComplexVec]

/-! ## Diagonal action -/

/-- The diagonal action of `rightMulE111` on flattened coordinates.

    Multiplies line coordinates (indices 0, 4) by `Complex.I` and
    complement coordinates (indices 1, 2, 3, 5, 6, 7) by `-Complex.I`. -/
noncomputable def QubitComplexCoordinates.rightMulE111Diagonal
    (v : Fin 8 → ℂ) : Fin 8 → ℂ :=
  fun i =>
    match i with
    | ⟨0, _⟩ => I * v ⟨0, by omega⟩
    | ⟨1, _⟩ => -I * v ⟨1, by omega⟩
    | ⟨2, _⟩ => -I * v ⟨2, by omega⟩
    | ⟨3, _⟩ => -I * v ⟨3, by omega⟩
    | ⟨4, _⟩ => I * v ⟨4, by omega⟩
    | ⟨5, _⟩ => -I * v ⟨5, by omega⟩
    | ⟨6, _⟩ => -I * v ⟨6, by omega⟩
    | ⟨7, _⟩ => -I * v ⟨7, by omega⟩

/-- Flattening commutes with `rightMulE111OnComplexCoordinates`:
    applying the coordinate action and then flattening is the same as
    flattening first and applying the diagonal action. -/
theorem QubitComplexCoordinates.toComplexVec_rightMulE111OnComplexCoordinates
    (c : QubitComplexCoordinates) :
    (rightMulE111OnComplexCoordinates c).toComplexVec =
      QubitComplexCoordinates.rightMulE111Diagonal c.toComplexVec := by
  funext i; fin_cases i <;>
    simp [toComplexVec, rightMulE111OnComplexCoordinates, rightMulE111Diagonal]

/-! ## Flattened qubit-level theorem -/

/-- The fully flattened version of the qubit-level `rightMulE111` theorem:
    converting an octonionic qubit to complex coordinates, flattening,
    and comparing with the diagonal action.

    ```
    𝕆²  ──rightMulE111──▶  𝕆²
     │                       │
     │ toComplexVec ∘        │ toComplexVec ∘
     │ toComplexCoordinates  │ toComplexCoordinates
     ▼                       ▼
    ℂ⁸  ──rightMulE111Diagonal──▶  ℂ⁸
    ```
-/
theorem toComplexVec_toComplexCoordinates_rightMulE111
    (q : OctonionicQubit) :
    (toComplexCoordinates (rightMulE111 q)).toComplexVec =
      QubitComplexCoordinates.rightMulE111Diagonal
        (toComplexCoordinates q).toComplexVec := by
  rw [toComplexCoordinates_rightMulE111,
      QubitComplexCoordinates.toComplexVec_rightMulE111OnComplexCoordinates]

/-! ## Diagonal squared is negation -/

/-- The diagonal action squares to pointwise negation.
    This is the flattened form of `rightMulE111OnComplexCoordinates_sq_neg`. -/
theorem QubitComplexCoordinates.rightMulE111Diagonal_sq_neg
    (v : Fin 8 → ℂ) :
    QubitComplexCoordinates.rightMulE111Diagonal
      (QubitComplexCoordinates.rightMulE111Diagonal v) =
    fun i => -(v i) := by
  funext i; fin_cases i <;>
    simp [rightMulE111Diagonal, ← mul_assoc, neg_mul, mul_neg, I_mul_I]

end PhysicsSM.Spinor.KrasnovComplexStructure
