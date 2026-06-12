# Aristotle task: DVT two-sided action kernel refines to Z3

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Paper-critical
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `90301d1e-192b-4d0e-a61b-5e0cfd731a5d`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave9-20260601-project`
**Output**:
**Integrated**:
**Type**: DVT/Yokota central kernel refinement

## Goal

Refine the existing finite matrix kernel theorem to the determinant-one
`Z3` kernel expected in the DVT/Yokota `(SU(3) x SU(3)) / Z3` story.

The repo already proves:

```lean
matrix_left_right_identity_kernel_scalar
```

which says that if `X |-> A * X * B` is the identity on all `3 x 3` complex
matrices, then `A = z I` and `B = z^-1 I`.

This task should add the determinant-one refinement: if `det A = 1` and
`det B = 1`, then `z^3 = 1`, so the kernel scalar is a cube root of unity.

## Requested file

Create:

```text
PhysicsSM/Algebra/Jordan/DVTTwoSidedActionKernelZ3.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTMatrixLeftRightKernel
import PhysicsSM.Algebra.Jordan.DVTZ3CentralUnitEquiv
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTAction
```

Do not edit `PhysicsSM.lean`; Codex will add imports during integration.

## Target declarations

Add determinant facts for scalar matrices if needed:

```lean
theorem det_scalar_matrix_fin3 (z : Complex) :
    (z • (1 : Matrix (Fin 3) (Fin 3) Complex)).det = z ^ 3 := ...
```

Main kernel refinement:

```lean
theorem matrix_left_right_identity_kernel_z3
    (A B : Units (Matrix (Fin 3) (Fin 3) Complex))
    (hact :
      forall X : Matrix (Fin 3) (Fin 3) Complex,
        (A : Matrix (Fin 3) (Fin 3) Complex) * X *
            (B : Matrix (Fin 3) (Fin 3) Complex) = X)
    (hdetA : (A : Matrix (Fin 3) (Fin 3) Complex).det = 1)
    (hdetB : (B : Matrix (Fin 3) (Fin 3) Complex).det = 1) :
    exists z : DVTZ3CentralScalar,
      (A : Matrix (Fin 3) (Fin 3) Complex) =
        (z : Complex) • (1 : Matrix (Fin 3) (Fin 3) Complex) /\
      (B : Matrix (Fin 3) (Fin 3) Complex) =
        (z : Complex)^-1 • (1 : Matrix (Fin 3) (Fin 3) Complex) := ...
```

Transport to `H3OComplement` if feasible:

```lean
theorem h3oComplementTwoSidedAction_kernel_z3
    (A B : Units (Matrix (Fin 3) (Fin 3) Complex))
    (hact :
      h3oComplementTwoSidedAction
        (A : Matrix (Fin 3) (Fin 3) Complex)
        (B : Matrix (Fin 3) (Fin 3) Complex) =
      AddMonoidHom.id H3OComplement)
    (hdetA : (A : Matrix (Fin 3) (Fin 3) Complex).det = 1)
    (hdetB : (B : Matrix (Fin 3) (Fin 3) Complex).det = 1) :
    exists z : DVTZ3CentralScalar, ...
```

If the transport theorem is too much, prove the matrix theorem and package it.

## Package

Add:

```lean
structure DVTTwoSidedActionKernelZ3Package where
  matrix_kernel_z3 :
    forall A B : Units (Matrix (Fin 3) (Fin 3) Complex),
      (forall X : Matrix (Fin 3) (Fin 3) Complex,
        (A : Matrix (Fin 3) (Fin 3) Complex) * X *
          (B : Matrix (Fin 3) (Fin 3) Complex) = X) ->
      (A : Matrix (Fin 3) (Fin 3) Complex).det = 1 ->
      (B : Matrix (Fin 3) (Fin 3) Complex).det = 1 ->
      exists z : DVTZ3CentralScalar,
        (A : Matrix (Fin 3) (Fin 3) Complex) =
          (z : Complex) • (1 : Matrix (Fin 3) (Fin 3) Complex) /\
        (B : Matrix (Fin 3) (Fin 3) Complex) =
          (z : Complex)^-1 • (1 : Matrix (Fin 3) (Fin 3) Complex)

noncomputable def dvtTwoSidedActionKernelZ3Package :
    DVTTwoSidedActionKernelZ3Package := ...
```

## Claim boundary

This is an algebraic kernel theorem for the two-sided matrix action. It does
not prove compact Lie group quotients, topological exactness, or the full DVT
stabilizer theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted output.
- Do not change existing DVT complement definitions.
- Do not edit `PhysicsSM.lean`.
- Keep parenthesization explicit around matrix products.

## Verification

Run:

```bash
lake build PhysicsSM.Algebra.Jordan.DVTTwoSidedActionKernelZ3
```
