# Aristotle task: Krasnov qubit complex coordinate linear API

**Agent**: Aristotle
**Status**: Failed
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `7367c40a-97d5-4999-91e1-df9a4d422f83`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-round-20260529-project`
**Output**: `AgentTasks/aristotle-output/krasnov-qubit-coordinate-linear-20260529`
**Type**: Krasnov octonionic qubit / complex vector space scaffold

**Checked**: 2026-05-30
**Failure note**: Aristotle reports this job failed due to an internal error.
`aristotle result 7367c40a-97d5-4999-91e1-df9a4d422f83` did not provide a
downloadable result bundle, so there was no proof artifact to salvage.

## Goal

Promote `QubitComplexCoordinates` to a genuine complex vector space via its
flattening to `Fin 8 -> Complex`, and package the flattening as a complex-linear
equivalence.

This is a direct formal next step from Krasnov's description of the Standard
Model group as a centralizer of a complex structure on the octonionic spinor
space `O^2`.

## Current context

The project already has:

- `PhysicsSM.Spinor.KrasnovQubitComplexCoordinates`
- `PhysicsSM.Spinor.KrasnovQubitCoordinateFlattening`
- `QubitComplexCoordinates.toComplexVec : QubitComplexCoordinates -> Fin 8 -> Complex`
- `QubitComplexCoordinates.ofComplexVec : (Fin 8 -> Complex) -> QubitComplexCoordinates`
- round-trip theorems:
  - `QubitComplexCoordinates.ofComplexVec_toComplexVec`
  - `QubitComplexCoordinates.toComplexVec_ofComplexVec`
- `QubitComplexCoordinates.rightMulE111Diagonal`
- `QubitComplexCoordinates.toComplexVec_rightMulE111OnComplexCoordinates`
- `toComplexVec_toComplexCoordinates_rightMulE111`

## Sources and claim boundary

Source motivation:

- Kirill Krasnov, "SO(9) characterisation of the Standard Model gauge group",
  arXiv:1912.11282.
- John Baez, "Can We Understand the Standard Model Using Octonions?", 2021.

Claim boundary:

- This job is only linear algebra for the flattened complex coordinate model.
- Do not claim the full `Spin(9)` centralizer theorem or any Standard Model
  subgroup theorem.

## Requested file

Create a trusted file:

```text
PhysicsSM/Spinor/KrasnovQubitCoordinateLinear.lean
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

Define coordinatewise algebraic instances for `QubitComplexCoordinates` by
transporting the structure from `Fin 8 -> Complex`:

```lean
noncomputable instance : Zero QubitComplexCoordinates := ...
noncomputable instance : Add QubitComplexCoordinates := ...
noncomputable instance : Neg QubitComplexCoordinates := ...
noncomputable instance : Sub QubitComplexCoordinates := ...
noncomputable instance : SMul Complex QubitComplexCoordinates := ...
noncomputable instance : AddCommGroup QubitComplexCoordinates := ...
noncomputable instance : Module Complex QubitComplexCoordinates := ...
```

If direct instances are awkward, prefer explicit operations with theorem names
that make the transported structure clear, but do not weaken the mathematical
content.

Package the flattening as a linear equivalence:

```lean
noncomputable def QubitComplexCoordinates.linearEquivComplexVec :
    QubitComplexCoordinates ~=l[Complex] (Fin 8 -> Complex) := ...
```

Use the actual Lean notation for `LinearEquiv`.

Prove useful simp lemmas:

```lean
@[simp] theorem QubitComplexCoordinates.linearEquivComplexVec_apply ...
@[simp] theorem QubitComplexCoordinates.linearEquivComplexVec_symm_apply ...
@[simp] theorem QubitComplexCoordinates.toComplexVec_zero ...
@[simp] theorem QubitComplexCoordinates.toComplexVec_add ...
@[simp] theorem QubitComplexCoordinates.toComplexVec_neg ...
@[simp] theorem QubitComplexCoordinates.toComplexVec_sub ...
@[simp] theorem QubitComplexCoordinates.toComplexVec_smul ...
```

If feasible, prove that `rightMulE111OnComplexCoordinates` is compatible with
the flattened diagonal operator in the linear API:

```lean
theorem QubitComplexCoordinates.toComplexVec_rightMulE111OnComplexCoordinates_linear
    (c : QubitComplexCoordinates) :
    QubitComplexCoordinates.linearEquivComplexVec
      (rightMulE111OnComplexCoordinates c) =
      QubitComplexCoordinates.rightMulE111Diagonal
        (QubitComplexCoordinates.linearEquivComplexVec c) := ...
```

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Preserve the existing coordinate ordering exactly:
  `0=fstLine`, `1..3=fstComplement`, `4=sndLine`, `5..7=sndComplement`.
- Prefer small extensionality proofs over large generated coordinate blobs.

## Verification

Run:

```bash
lake env lean PhysicsSM/Spinor/KrasnovQubitCoordinateLinear.lean
lake build PhysicsSM.Spinor.KrasnovQubitCoordinateLinear
lake build PhysicsSM
```
