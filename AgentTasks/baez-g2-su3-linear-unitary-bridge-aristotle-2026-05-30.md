# Aristotle task: G2 stabilizer to complex-linear C3 bridge

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `bfd39b50-830e-464d-ba44-d0bbdb5e219c`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-big-targets-20260530-min-project`
**Output**: `AgentTasks/aristotle-output/baez-g2-su3-linear-unitary-bridge-20260530`
**Type**: Baez octonion `G2 -> SU(3)` scaffold

## Integration result

Integrated 2026-05-30 into:

```text
PhysicsSM/Algebra/Octonion/G2SU3Bridge.lean
```

The merged module packages `FixingE111MulLinear.onComplexTriple` as a
complex-linear endomorphism of `ComplexTriple`, transports it to `Fin 3 -> C`,
and adds conservative norm/Hermitian preservation predicates plus the
Hermitian-implies-norm theorem. It intentionally does not claim the full
`Stab_G2(e111) ~= SU(3)` theorem.

## Goal

Build the next trusted bridge from Baez's observation

```text
Stab_G2(e111) acts on O_perp ~= C^3
```

to a reusable complex-linear and unitary action API.

The current project already proves that a multiplication-preserving real-linear
map fixing `e111` induces a complex-linear action on `ComplexTriple`. This job
should package that action as a genuine complex-linear endomorphism and prove
the strongest safe norm/Hermitian preservation statements available.

## Current context

Use:

```text
PhysicsSM.Algebra.Octonion.G2ComplexLine
PhysicsSM.Algebra.Octonion.G2ComplexTripleAction
PhysicsSM.Algebra.Octonion.ComplexTripleLinear
PhysicsSM.Algebra.Octonion.ComplexTripleHermitian
```

Important declarations include:

- `G2ComplexLine.FixingE111MulLinear`
- `FixingE111MulLinear.onComplexTriple`
- `FixingE111MulLinear.onComplexTriple_add`
- `FixingE111MulLinear.onComplexTriple_real_smul`
- `FixingE111MulLinear.onComplexTriple_complex_smul`
- `ComplexTriple.linearEquivComplexVec`
- `ComplexTriple.hermitian`
- `ComplexTriple.normSq`
- `ComplexTriple.normSq_complexSmul`

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Octonion/G2SU3Bridge.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2ComplexTripleAction
import PhysicsSM.Algebra.Octonion.ComplexTripleLinear
import PhysicsSM.Algebra.Octonion.ComplexTripleHermitian
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

First package the induced action as a complex-linear map:

```lean
noncomputable def FixingE111MulLinear.onComplexTripleLinear
    (g : FixingE111MulLinear) :
    ComplexTriple ->L[Complex] ComplexTriple := ...

@[simp] theorem FixingE111MulLinear.onComplexTripleLinear_apply
    (g : FixingE111MulLinear) (w : ComplexTriple) :
    g.onComplexTripleLinear w = g.onComplexTriple w := ...
```

Then transport it to the coordinate space:

```lean
noncomputable def FixingE111MulLinear.onComplexVecLinear
    (g : FixingE111MulLinear) :
    (Fin 3 -> Complex) ->L[Complex] (Fin 3 -> Complex) := ...
```

Prove apply/simp lemmas connecting this to `ComplexTriple.linearEquivComplexVec`.

If feasible, add predicates and theorems for norm/Hermitian preservation under
explicit hypotheses, for example:

```lean
def PreservesComplexTripleNorm (g : FixingE111MulLinear) : Prop :=
  forall w, ComplexTriple.normSq (g.onComplexTriple w) = ComplexTriple.normSq w

def PreservesComplexTripleHermitian (g : FixingE111MulLinear) : Prop :=
  forall u v, ComplexTriple.hermitian (g.onComplexTriple u) (g.onComplexTriple v) =
    ComplexTriple.hermitian u v
```

Then prove any easy consequences, such as norm preservation from Hermitian
preservation, or coordinate-space restatements.

## Claim boundary

Do not claim the full theorem `Stab_G2(e111) ~= SU(3)` unless the determinant,
orientation/volume, inverse, and unitary conditions are actually formalized.

It is acceptable and useful to define a conservative predicate such as
`ActsAsSU3OnC3 g : Prop` bundling:

- complex-linearity,
- Hermitian/norm preservation,
- determinant-one or volume-form preservation if available.

But do not assert that every `FixingE111MulLinear` satisfies that predicate
without proof.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not weaken existing theorem statements.
- Keep all octonion parenthesization explicit.
- Use the project XOR basis and chosen unit `e111`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2SU3Bridge.lean
lake build PhysicsSM.Algebra.Octonion.G2SU3Bridge
lake build PhysicsSM
```
