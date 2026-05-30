# Aristotle task: Krasnov qubit splitting coordinates

**Agent**: Aristotle
**Status**: Complete and integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `bb89c7fa-f693-48fe-ad94-dfa8174f6657`
**Submission project**: `AgentTasks/aristotle-submit/baez-parallel-c3-20260529-project`
**Output**: `AgentTasks/aristotle-output/krasnov-qubit-splitting-coordinates-20260529`
**Extracted output**: `AgentTasks/aristotle-output/krasnov-qubit-splitting-coordinates-20260529-extracted`
**Integrated file**: `PhysicsSM/Spinor/KrasnovQubitSplittingCoordinates.lean`
**Type**: Baez/Krasnov `O^2` coordinate splitting / finite proof

## Integration result

Integrated Aristotle job `bb89c7fa-f693-48fe-ad94-dfa8174f6657` into trusted
source as `PhysicsSM.Spinor.KrasnovQubitSplittingCoordinates`.

Main declarations added:

- `rotateChosenComplexRight`.
- `rotateComplexTripleRight`.
- `rightMulE111OnSplitting`.
- `splitQubit_rightMulE111`.
- `rightMulE111OnSplitting_sq_neg`.
- `rightMulE111OnSplitting_toQubit`.

Verification run during integration:

```bash
lake env lean PhysicsSM\Spinor\KrasnovQubitSplittingCoordinates.lean
```

Status: trusted integration. The only placeholder-token hit is the word
`sorry` in the module status docstring.

## Goal

Make the componentwise splitting

```text
O^2 = (C + C^3)^2
```

usable for the Krasnov/Baez octonionic-qubit route.

The project already has:

- `PhysicsSM.Spinor.OctonionicQubit`
- `PhysicsSM.Spinor.KrasnovComplexStructure`
- `OctonionicQubit`
- `rightMulE111`
- `splitQubit`
- `OctonionicQubitSplitting`
- `rightMulE111_line_coords`
- `rightMulE111_complement_coords`

This job should prove a clean coordinate theorem describing how
`rightMulE111` acts on all four pieces of the split qubit.

## Sources and claim boundary

Source motivation:

- Krasnov, "SO(9) characterization of the Standard Model gauge group",
  J. Math. Phys. 62, 021703, 2021.
- John Baez, "Can We Understand the Standard Model Using Octonions?", 2021.

Claim boundary:

- This is only the coordinate behavior of the complex structure on `O^2`.
- Do not define or claim a `Spin(9)` centralizer theorem.
- Do not claim Standard Model representation matching.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Spinor/KrasnovQubitSplittingCoordinates.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Spinor.KrasnovComplexStructure
```

Use namespace:

```lean
namespace PhysicsSM.Spinor.KrasnovComplexStructure
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define rotations on the two coordinate pieces:

```lean
def rotateChosenComplexRight (z : ChosenComplex) : ChosenComplex :=
  { re := -z.im, im := z.re }

def rotateComplexTripleRight (w : ComplexTriple) : ComplexTriple :=
  { w1_re := w.w1_im,  w1_im := -w.w1_re,
    w2_re := w.w2_im,  w2_im := -w.w2_re,
    w3_re := w.w3_im,  w3_im := -w.w3_re }
```

Then define the induced action on a split qubit:

```lean
def rightMulE111OnSplitting
    (s : OctonionicQubitSplitting) : OctonionicQubitSplitting :=
  { fst_line := rotateChosenComplexRight s.fst_line
    fst_complement := rotateComplexTripleRight s.fst_complement
    snd_line := rotateChosenComplexRight s.snd_line
    snd_complement := rotateComplexTripleRight s.snd_complement }
```

Prove the coordinate theorem:

```lean
theorem splitQubit_rightMulE111
    (q : OctonionicQubit) :
    splitQubit (rightMulE111 q) =
      rightMulE111OnSplitting (splitQubit q)
```

Prove the squaring theorem in split coordinates:

```lean
theorem rightMulE111OnSplitting_sq_neg
    (s : OctonionicQubitSplitting) :
    rightMulE111OnSplitting (rightMulE111OnSplitting s) =
      { fst_line := -s.fst_line
        fst_complement := -s.fst_complement
        snd_line := -s.snd_line
        snd_complement := -s.snd_complement }
```

If negation is not available on `OctonionicQubitSplitting`, the record literal
target above is fine. If additional component simp lemmas are helpful, add
them.

Also prove reconstruction compatibility:

```lean
theorem rightMulE111OnSplitting_toQubit
    (s : OctonionicQubitSplitting) :
    (rightMulE111OnSplitting s).toQubit =
      rightMulE111 s.toQubit
```

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change `OctonionicQubit`, `rightMulE111`, or `splitQubit`.
- Keep all claims finite and coordinate-level.
- Prefer record extensionality and `simp` with the existing coordinate lemmas.
- Do not depend on active triality or Q-op Aristotle jobs.

## Verification

Run:

```bash
lake env lean PhysicsSM/Spinor/KrasnovQubitSplittingCoordinates.lean
lake build PhysicsSM.Spinor.KrasnovQubitSplittingCoordinates
lake build PhysicsSM
```

## Deliverable

Return files changed, theorem names proved, whether the file is sorry-free,
and exact verification commands run.
