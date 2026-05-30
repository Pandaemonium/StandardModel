# Aristotle task: flatten Krasnov qubit complex coordinates

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Integrated**: 2026-05-29
**Aristotle job ID**: `3156280f-61d4-4885-81f9-2b34065a1d5f`
**Submission project**: `AgentTasks/aristotle-submit/baez-next-linear-coordinate-20260529-project`
**Aristotle status**: `OUT_OF_BUDGET` but produced a useful checked artifact
**Output**: `AgentTasks/aristotle-output/krasnov-qubit-coordinate-flattening-20260529-oob-extracted`
**Type**: Krasnov octonionic qubit / eight complex coordinate API

## Goal

Package the `QubitComplexCoordinates` record as an ordinary function
`Fin 8 -> Complex`, and express `rightMulE111` as a diagonal coordinate
operator with eigenvalue `I` on the two line coordinates and `-I` on the six
complement coordinates.

This prepares the Krasnov side for later centralizer and representation
bookkeeping.

## Current context

The project already has:

- `PhysicsSM.Spinor.KrasnovQubitComplexCoordinates`
- `QubitComplexCoordinates`
- `toComplexCoordinates`
- `rightMulE111OnComplexCoordinates`
- `toComplexCoordinates_rightMulE111`
- `rightMulE111OnComplexCoordinates_sq_neg`

## Requested file

Create a trusted file:

```text
PhysicsSM/Spinor/KrasnovQubitCoordinateFlattening.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Spinor.KrasnovQubitComplexCoordinates
```

If the result is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define a flattening and inverse:

```lean
noncomputable def QubitComplexCoordinates.toComplexVec
    (c : QubitComplexCoordinates) : Fin 8 -> Complex := ...

noncomputable def QubitComplexCoordinates.ofComplexVec
    (v : Fin 8 -> Complex) : QubitComplexCoordinates := ...
```

Use the ordering:

```text
0 = fstLine
1,2,3 = fstComplement 0,1,2
4 = sndLine
5,6,7 = sndComplement 0,1,2
```

Prove round trips:

```lean
theorem QubitComplexCoordinates.ofComplexVec_toComplexVec ...
theorem QubitComplexCoordinates.toComplexVec_ofComplexVec ...
```

Define or prove the diagonal action:

```lean
noncomputable def QubitComplexCoordinates.rightMulE111Diagonal
    (v : Fin 8 -> Complex) : Fin 8 -> Complex := ...

theorem QubitComplexCoordinates.toComplexVec_rightMulE111OnComplexCoordinates ...
```

The diagonal action should multiply coordinates 0 and 4 by `Complex.I`, and
coordinates 1,2,3,5,6,7 by `-Complex.I`.

If feasible, prove the flattened version of the qubit-level theorem:

```lean
theorem toComplexVec_toComplexCoordinates_rightMulE111
    (q : OctonionicQubit) :
    (toComplexCoordinates (rightMulE111 q)).toComplexVec =
      QubitComplexCoordinates.rightMulE111Diagonal
        (toComplexCoordinates q).toComplexVec := ...
```

Also prove the diagonal square is negation if it is short.

## Constraints

- This job is coordinate bookkeeping only.
- Do not claim a `Spin(9)` centralizer theorem or Standard Model subgroup
  theorem.
- Do not introduce `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Keep the coordinate ordering documented in the module docstring.

## Verification

Run at least:

```bash
lake build PhysicsSM.Spinor.KrasnovQubitCoordinateFlattening
lake env lean PhysicsSM/Spinor/KrasnovQubitCoordinateFlattening.lean
```
