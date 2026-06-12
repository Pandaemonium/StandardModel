# Aristotle task: DVT two-sided SU3 quotient/stabilizer moonshot

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Moonshot
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `074cdea5-eaf8-492e-9207-ef91d45ca799`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave11-20260601-project`
**Output**:
**Integrated**:
**Type**: DVT exceptional-Jordan stabilizer frontier

## Goal

Push the DVT complement action from a kernel theorem toward a quotient action
theorem of the form:

```text
(SU(3) x SU(3)) / Z3 acts faithfully on the DVT complement.
```

The current trusted chain proves:

- the transported two-sided action
  `h3oComplementTwoSidedAction A B : H3OComplement ->+ H3OComplement`;
- the composition law
  `(A1 * A2, B2 * B1)` for composing two-sided actions;
- scalar cancellation;
- the matrix left-right identity kernel is scalar;
- under determinant-one hypotheses the scalar kernel is `Z3`;
- central cube-root packages, group structure, and finite cardinality.

The missing hard step is to organize these facts as an actual quotient by the
central `Z3` kernel and prove the induced action is faithful.

## Requested file

Create:

```text
PhysicsSM/Algebra/Jordan/DVTTwoSidedSU3QuotientStabilizer.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTTwoSidedActionKernelZ3
import PhysicsSM.Algebra.Jordan.DVTBlockActionMonoid
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTAction
```

Do not edit `PhysicsSM.lean`.

## Target design

Define a determinant-one unit matrix package:

```lean
structure SU3MatrixUnit where
  unit : Units (Matrix (Fin 3) (Fin 3) Complex)
  det_one : (unit : Matrix (Fin 3) (Fin 3) Complex).det = 1
```

Give it a group structure if possible, then define the two-sided domain:

```lean
abbrev DVTTwoSidedSU3Pair := SU3MatrixUnit * SU3MatrixUnit
```

The action should use the convention already proved in
`h3oComplementTwoSidedAction_mul`, namely product
`(A1 * A2, B2 * B1)` for composition.

Build:

```lean
noncomputable def dvtTwoSidedSU3ActionHom :
    DVTTwoSidedSU3Pair ->* AddMonoid.End H3OComplement := ...
```

Then define image equivalence and quotient:

```lean
def DVTTwoSidedSU3Pair.ImageEquivalent
    (x y : DVTTwoSidedSU3Pair) : Prop :=
  dvtTwoSidedSU3ActionHom x = dvtTwoSidedSU3ActionHom y

abbrev DVTTwoSidedSU3Quotient :=
  Quotient DVTTwoSidedSU3Pair.imageSetoid
```

Prove:

```lean
noncomputable instance : Group DVTTwoSidedSU3Quotient := ...

noncomputable def dvtTwoSidedSU3QuotientMulEquivImage :
    MulEquiv DVTTwoSidedSU3Quotient
      dvtTwoSidedSU3ActionHom.range := ...
```

Finally, connect the identity fiber to the `DVTZ3CentralScalar` package:

```lean
theorem dvtTwoSidedSU3_identityFiber_z3
    (x : DVTTwoSidedSU3Pair)
    (hx : dvtTwoSidedSU3ActionHom x = 1) :
    exists z : DVTZ3CentralScalar, ... := ...
```

Use the exact scalar-pair statement that fits existing APIs.

## Fallback

This may be too large because of opposite multiplication in the second factor.
If so, return any trusted prefix:

- `SU3MatrixUnit` group structure;
- the pair domain with the correct opposite multiplication convention;
- the action hom;
- quotient group by image equivalence;
- the quotient-to-image equivalence;
- identity-fiber-to-`Z3` theorem.

Draft `sorry` is allowed only in:

```text
PhysicsSM/Draft/DVTTwoSidedSU3QuotientStabilizerHandoff.lean
```

No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted files.

## Claim boundary

This is an algebraic quotient action on the coordinate complement scaffold. It
does not prove the full exceptional Jordan automorphism stabilizer theorem,
topological quotient structure, or any Lie group smoothness result.

## Verification

Run:

```bash
lake build PhysicsSM.Algebra.Jordan.DVTTwoSidedSU3QuotientStabilizer
```
