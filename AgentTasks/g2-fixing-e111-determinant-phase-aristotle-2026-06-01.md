# Aristotle task: G2 fixing-e111 determinant phase package

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `db1958a9-b01e-4ff7-a79e-24544bd72626`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave6-20260601-project`
**Output**: `AgentTasks/aristotle-output/g2-fixing-e111-determinant-phase-20260601`
**Integrated**: 2026-06-01
**Type**: Baez octonion-to-C3 determinant API

## Goal

Package the determinant consequences that follow from the newly trusted theorem
that every `FixingE111MulLinear` map preserves the Hermitian form on `C^3`.

The current GUT-square bridge still correctly keeps the stronger hypothesis
`g.onComplexVecMatrix.det = 1` explicit. This task should prove the weaker but
important fact that the determinant is a nonzero complex number of squared norm
one.

## Requested file

Create:

```text
PhysicsSM/Algebra/Octonion/G2FixingE111Determinant.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.G2HermitianPreservation
import PhysicsSM.Algebra.Octonion.G2C3GUTUnitary
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion.G2ComplexLine
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

- `FixingE111MulLinear`
- `FixingE111MulLinear.onComplexVecMatrix`
- `fixingE111MulLinear_preservesHermitian`
- `PreservesComplexTripleHermitian.matrixActsUnitary`
- `MatrixActsUnitaryOnC3.det_normSq_eq_one`
- `MatrixActsUnitaryOnC3.det_normSq_eq_one_gutSquare`
- `MatrixActsUnitaryOnC3.det_ne_zero`

## Target declarations

Prove determinant norm and nonzero lemmas:

```lean
theorem fixingE111MulLinear_det_normSq_eq_one
    (g : FixingE111MulLinear) :
    Complex.normSq g.onComplexVecMatrix.det = 1 := ...

theorem fixingE111MulLinear_det_ne_zero
    (g : FixingE111MulLinear) :
    Ne g.onComplexVecMatrix.det 0 := ...
```

Package the determinant as a unit:

```lean
noncomputable def FixingE111MulLinear.detUnit
    (g : FixingE111MulLinear) : Complex.Units := ...

@[simp] theorem FixingE111MulLinear.detUnit_val
    (g : FixingE111MulLinear) :
    (g.detUnit : Complex) = g.onComplexVecMatrix.det := ...

theorem FixingE111MulLinear.detUnit_normSq_eq_one
    (g : FixingE111MulLinear) :
    Complex.normSq (g.detUnit : Complex) = 1 := ...
```

If `Complex.Units` is not the right notation in this project, use the
equivalent `Complex` unit type accepted by Lean, normally `Complexˣ` or
`Units Complex`.

Add a bundled package:

```lean
structure G2FixingE111DeterminantPackage where
  det_normSq_one :
    forall g : FixingE111MulLinear,
      Complex.normSq g.onComplexVecMatrix.det = 1
  det_ne_zero :
    forall g : FixingE111MulLinear,
      Ne g.onComplexVecMatrix.det 0
  det_unit : FixingE111MulLinear -> Units Complex
  det_unit_val :
    forall g : FixingE111MulLinear,
      ((det_unit g : Units Complex) : Complex) = g.onComplexVecMatrix.det

noncomputable def g2FixingE111DeterminantPackage :
    G2FixingE111DeterminantPackage := ...
```

## Claim boundary

This proves that the determinant lies on the complex unit circle. It does not
prove determinant one, `Stab_G2(e111) = SU(3)`, a connectedness theorem, or a
Lie group isomorphism.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change `ActsAsSU3OnC3` or the GUT-square determinant-one hypotheses.
- Do not claim `g.onComplexVecMatrix.det = 1`.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Octonion/G2FixingE111Determinant.lean
lake build PhysicsSM.Algebra.Octonion.G2FixingE111Determinant
```
