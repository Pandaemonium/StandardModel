# Aristotle task: Krasnov qubit complex-coordinate API

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Integrated**: 2026-05-29
**Aristotle job ID**: `0e97a9dc-0619-45dc-a4bb-15083c7c9f2c`
**Submission project**: `AgentTasks/aristotle-submit/baez-next-c3-action-20260529-project`
**Output**: `AgentTasks/aristotle-output/krasnov-qubit-complex-coordinate-api-20260529-extracted`
**Type**: Krasnov/Baez octonionic qubit / complex-coordinate bookkeeping

## Goal

Package the split octonionic qubit `O^2 = (C + C^3)^2` into ordinary complex
coordinate data, and prove the coordinate action of `rightMulE111`.

The project already has:

- `PhysicsSM.Spinor.KrasnovComplexStructure`
- `PhysicsSM.Spinor.KrasnovQubitSplittingCoordinates`
- `PhysicsSM.Algebra.Octonion.ChosenComplexAlgebra`
- `PhysicsSM.Algebra.Octonion.ComplexTripleModule`
- `splitQubit`
- `rightMulE111OnSplitting`
- `splitQubit_rightMulE111`

This job should give downstream representation-theory files a clean complex
coordinate API for the Krasnov/Baez left-handed fermion count.

## Sources and claim boundary

Source motivation:

- Krasnov, "SO(9) characterization of the Standard Model gauge group",
  J. Math. Phys. 62, 021703, 2021.
- John Baez, "Can We Understand the Standard Model Using Octonions?", 2021.

Claim boundary:

- This is only coordinate bookkeeping for `O^2`.
- Do not define or claim a `Spin(9)` centralizer theorem.
- Do not claim Standard Model representation matching.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Spinor/KrasnovQubitComplexCoordinates.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Spinor.KrasnovQubitSplittingCoordinates
import PhysicsSM.Algebra.Octonion.ChosenComplexAlgebra
import PhysicsSM.Algebra.Octonion.ComplexTripleModule
```

Use namespace:

```lean
namespace PhysicsSM.Spinor.KrasnovComplexStructure
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define a complex-coordinate record:

```lean
structure QubitComplexCoordinates where
  fstLine : Complex
  fstComplement : Fin 3 -> Complex
  sndLine : Complex
  sndComplement : Fin 3 -> Complex
```

Define conversion from a splitting:

```lean
noncomputable def OctonionicQubitSplitting.toComplexCoordinates
    (s : OctonionicQubitSplitting) : QubitComplexCoordinates
```

using:

- `ChosenComplex.toComplex`
- `ComplexTriple.toComplexVec`

Define conversion directly from a qubit:

```lean
noncomputable def OctonionicQubit.toComplexCoordinates
    (q : OctonionicQubit) : QubitComplexCoordinates :=
  (splitQubit q).toComplexCoordinates
```

Define the coordinate action of right multiplication:

```lean
noncomputable def rightMulE111OnComplexCoordinates
    (c : QubitComplexCoordinates) : QubitComplexCoordinates :=
  { fstLine := Complex.I * c.fstLine
    fstComplement := fun k => -Complex.I * c.fstComplement k
    sndLine := Complex.I * c.sndLine
    sndComplement := fun k => -Complex.I * c.sndComplement k }
```

Prove:

```lean
theorem toComplexCoordinates_rightMulE111
    (q : OctonionicQubit) :
    (rightMulE111 q).toComplexCoordinates =
      rightMulE111OnComplexCoordinates q.toComplexCoordinates
```

Also prove the split-coordinate version:

```lean
theorem splitting_toComplexCoordinates_rightMulE111OnSplitting
    (s : OctonionicQubitSplitting) :
    (rightMulE111OnSplitting s).toComplexCoordinates =
      rightMulE111OnComplexCoordinates s.toComplexCoordinates
```

Prove the dimension count in this coordinate language:

```lean
theorem qubit_complex_coordinate_count :
    (1 : Nat) + 3 + 1 + 3 = 8
```

Optional if easy: prove the coordinate action squares to negation:

```lean
theorem rightMulE111OnComplexCoordinates_sq_neg
    (c : QubitComplexCoordinates) :
    rightMulE111OnComplexCoordinates
      (rightMulE111OnComplexCoordinates c) =
    { fstLine := -c.fstLine
      fstComplement := fun k => -c.fstComplement k
      sndLine := -c.sndLine
      sndComplement := fun k => -c.sndComplement k }
```

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change existing qubit or splitting definitions.
- Keep all claims coordinate-level.
- Prefer extensionality and finite `Fin 3` case splits.

## Verification

Run:

```bash
lake env lean PhysicsSM/Spinor/KrasnovQubitComplexCoordinates.lean
lake build PhysicsSM.Spinor.KrasnovQubitComplexCoordinates
lake build PhysicsSM
```

## Deliverable

Return files changed, theorem names proved, whether the file is sorry-free,
and exact verification commands run.
