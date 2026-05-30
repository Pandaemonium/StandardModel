# Aristotle task: Krasnov diagonal complex structure is unitary

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `1b237619-fc1e-45a9-be78-f60c06229cda`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-round-20260529-project`
**Output**: `AgentTasks/aristotle-output/krasnov-qubit-hermitian-unitary-20260529`
**Type**: Krasnov octonionic qubit / Hermitian form and unitary diagonal action

**Integrated**: 2026-05-30
**Integrated files**:
- `PhysicsSM/Spinor/KrasnovQubitHermitian.lean`
- `PhysicsSM.lean`

**Review note**: Aristotle's trusted theorem file was imported, locally
reviewed, provenance-cleaned, and checked with the pinned Lean toolchain.

## Goal

Define the standard Hermitian form and squared norm on the flattened
`Fin 8 -> Complex` coordinates of the octonionic qubit, and prove that the
diagonal form of right multiplication by `e111` preserves this norm.

This is a clean formal shadow of Krasnov's point that the chosen octonionic
imaginary unit defines a complex structure on `O^2`.

## Current context

The project already has:

- `PhysicsSM.Spinor.KrasnovQubitCoordinateFlattening`
- `QubitComplexCoordinates.rightMulE111Diagonal : (Fin 8 -> Complex) -> Fin 8 -> Complex`
- `QubitComplexCoordinates.rightMulE111Diagonal_sq_neg`
- `toComplexVec_toComplexCoordinates_rightMulE111`

## Sources and claim boundary

Source motivation:

- Kirill Krasnov, "SO(9) characterisation of the Standard Model gauge group",
  arXiv:1912.11282.
- Kirill Krasnov, "Octonions, complex structures and Standard Model fermions",
  arXiv:2504.16465.

Claim boundary:

- This job proves norm/Hermitian facts about the coordinate operator only.
- Do not claim the full `Spin(9)` or `Spin(10)` Standard Model centralizer
  theorem.

## Requested file

Create a trusted file:

```text
PhysicsSM/Spinor/KrasnovQubitHermitian.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Spinor.KrasnovQubitCoordinateFlattening
```

Use namespace:

```lean
namespace PhysicsSM.Spinor.KrasnovComplexStructure
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define:

```lean
noncomputable def QubitComplexCoordinates.flatHermitian
    (v w : Fin 8 -> Complex) : Complex :=
  Finset.univ.sum (fun i => star (v i) * w i)

noncomputable def QubitComplexCoordinates.flatNormSq
    (v : Fin 8 -> Complex) : Real :=
  Complex.re (QubitComplexCoordinates.flatHermitian v v)
```

Prove:

```lean
theorem QubitComplexCoordinates.flatNormSq_nonneg
    (v : Fin 8 -> Complex) : 0 <= flatNormSq v := ...

theorem QubitComplexCoordinates.flatNormSq_zero :
    flatNormSq 0 = 0 := ...

theorem QubitComplexCoordinates.flatNormSq_eq_zero_iff
    (v : Fin 8 -> Complex) :
    flatNormSq v = 0 <-> v = 0 := ...
```

Prove diagonal-unitary facts:

```lean
theorem QubitComplexCoordinates.flatHermitian_diagonal_left
    (v w : Fin 8 -> Complex) :
    flatHermitian (rightMulE111Diagonal v) (rightMulE111Diagonal w) =
      flatHermitian v w := ...

theorem QubitComplexCoordinates.flatNormSq_diagonal
    (v : Fin 8 -> Complex) :
    flatNormSq (rightMulE111Diagonal v) = flatNormSq v := ...
```

If the Hermitian theorem is hard, prove the norm theorem first and leave the
Hermitian theorem out rather than adding a placeholder.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Keep the theorem names discoverable and the coordinate ordering unchanged.
- Prefer `fin_cases`/`Finset.sum` proofs over expanding unrelated qubit code.

## Verification

Run:

```bash
lake env lean PhysicsSM/Spinor/KrasnovQubitHermitian.lean
lake build PhysicsSM.Spinor.KrasnovQubitHermitian
lake build PhysicsSM
```
