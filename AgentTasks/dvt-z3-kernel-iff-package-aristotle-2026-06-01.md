# Aristotle task: DVT Z3 kernel iff package

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `bcb93d1e-ecc7-4f33-9ebc-c740bbd81ef1`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave10-20260601-project`
**Output**:
**Integrated**:
**Type**: DVT/Yokota kernel completion and polish

## Goal

Turn the one-way DVT determinant-one `Z3` kernel theorem into a cleaner
iff-style theorem package.

The current file `DVTTwoSidedActionKernelZ3.lean` proves that if the two-sided
matrix action is identity and `det A = det B = 1`, then `A` and `B` are
reciprocal scalar matrices for some `z : DVTZ3CentralScalar`. The converse is
also important for the paper: every such cube-root scalar pair acts trivially
and has determinant one.

## Requested file

Create:

```text
PhysicsSM/Algebra/Jordan/DVTTwoSidedActionKernelZ3Iff.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTTwoSidedActionKernelZ3
import PhysicsSM.Algebra.Jordan.DVTZ3CentralScalarGroup
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTAction
```

Do not edit `PhysicsSM.lean`; Codex will add imports during integration.

## Target declarations

First prove the converse direction:

```lean
theorem matrix_left_right_identity_of_z3_scalar
    (z : DVTZ3CentralScalar) :
    forall X : Matrix (Fin 3) (Fin 3) Complex,
      ((z : Complex) • (1 : Matrix (Fin 3) (Fin 3) Complex)) * X *
        ((z : Complex)^-1 • (1 : Matrix (Fin 3) (Fin 3) Complex)) = X := ...
```

Prove determinant facts:

```lean
theorem det_z3_scalar_matrix (z : DVTZ3CentralScalar) :
    (((z : Complex) • (1 : Matrix (Fin 3) (Fin 3) Complex)).det = 1) := ...

theorem det_z3_scalar_matrix_inv (z : DVTZ3CentralScalar) :
    (((z : Complex)^-1 • (1 : Matrix (Fin 3) (Fin 3) Complex)).det = 1) := ...
```

Then prove an iff-style predicate:

```lean
def DVTTwoSidedKernelDetOne
    (A B : Matrix (Fin 3) (Fin 3) Complex) : Prop :=
  (forall X : Matrix (Fin 3) (Fin 3) Complex, A * X * B = X) /\
  A.det = 1 /\ B.det = 1

theorem matrix_left_right_identity_kernel_z3_iff
    (A B : Units (Matrix (Fin 3) (Fin 3) Complex)) :
    DVTTwoSidedKernelDetOne
      (A : Matrix (Fin 3) (Fin 3) Complex)
      (B : Matrix (Fin 3) (Fin 3) Complex) <->
    exists z : DVTZ3CentralScalar,
      (A : Matrix (Fin 3) (Fin 3) Complex) =
        (z : Complex) • (1 : Matrix (Fin 3) (Fin 3) Complex) /\
      (B : Matrix (Fin 3) (Fin 3) Complex) =
        (z : Complex)^-1 • (1 : Matrix (Fin 3) (Fin 3) Complex) := ...
```

If the exact iff is too hard because of unit coercions, prove the two named
directions and package them.

## Package

Add:

```lean
structure DVTTwoSidedActionKernelZ3IffPackage where
  forward : ...
  converse : ...

noncomputable def dvtTwoSidedActionKernelZ3IffPackage :
    DVTTwoSidedActionKernelZ3IffPackage := ...
```

## Documentation cleanup

If the existing `hdetB` hypothesis in the forward theorem is redundant, add a
wrapper theorem with only the necessary determinant hypothesis or a lemma
explaining why the second determinant condition follows automatically from the
reciprocal-scalar form. Do not weaken the existing theorem silently.

## Claim boundary

This is a finite matrix-algebra kernel theorem. It does not prove compact Lie
group quotients, topological exactness, or the full DVT stabilizer theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted output.
- Do not change existing DVT definitions.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake build PhysicsSM.Algebra.Jordan.DVTTwoSidedActionKernelZ3Iff
```
