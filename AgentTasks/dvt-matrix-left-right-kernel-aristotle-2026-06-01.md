# Aristotle task: DVT two-sided matrix action kernel converse

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Moonshot
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `2e516f5b-761e-44a7-aa89-dad22fd2b77d`
**Submission project**: `AgentTasks/aristotle-submit/paper-stretch-wave8-20260601-project`
**Output**: `AgentTasks/aristotle-output/dvt-matrix-left-right-kernel-20260601`
**Integrated**: 2026-06-01
**Type**: DVT/Yokota central-kernel converse

## Goal

Prove the hard converse behind the DVT central-kernel story at the finite matrix
level: if a left-right action `X |-> A * X * B` on all `3 x 3` complex matrices
is the identity and `A`, `B` are units, then `A` and `B` are reciprocal scalar
matrices.

This is a substantial algebra theorem and a direct bridge toward the
`(SU(3) x SU(3)) / Z3` kernel story. It is intentionally difficult.

## Requested file

Create:

```text
PhysicsSM/Algebra/Jordan/DVTMatrixLeftRightKernel.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTComplementTwoSidedAction
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTAction
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Target theorem

The main target is:

```lean
theorem matrix_left_right_identity_kernel_scalar
    (A B : Units (Matrix (Fin 3) (Fin 3) Complex))
    (h :
      forall X : Matrix (Fin 3) (Fin 3) Complex,
        (A : Matrix (Fin 3) (Fin 3) Complex) * X *
            (B : Matrix (Fin 3) (Fin 3) Complex) = X) :
    exists z : Complex,
      z != 0 /\
      (A : Matrix (Fin 3) (Fin 3) Complex) =
        z • (1 : Matrix (Fin 3) (Fin 3) Complex) /\
      (B : Matrix (Fin 3) (Fin 3) Complex) =
        z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) Complex) := ...
```

Use Lean's `≠` in place of the ASCII `!=` in actual code.

Then transport it to the existing complement action:

```lean
theorem h3oComplementTwoSidedAction_kernel_scalar_converse
    (A B : Units (Matrix (Fin 3) (Fin 3) Complex))
    (h :
      h3oComplementTwoSidedAction
        (A : Matrix (Fin 3) (Fin 3) Complex)
        (B : Matrix (Fin 3) (Fin 3) Complex) =
      AddMonoidHom.id H3OComplement) :
    exists z : Complex,
      z != 0 /\
      (A : Matrix (Fin 3) (Fin 3) Complex) =
        z • (1 : Matrix (Fin 3) (Fin 3) Complex) /\
      (B : Matrix (Fin 3) (Fin 3) Complex) =
        z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) Complex) := ...
```

## Suggested proof strategy

1. From `h 1`, get `A * B = 1`, so `B = A⁻¹` as units/matrices.
2. From `A * X * B = X`, multiply on the right by `B⁻¹` or use `B = A⁻¹` to
   show `A * X = X * A` for every matrix `X`.
3. Prove a `3 x 3` central-matrix lemma by evaluating at matrix units:

```lean
theorem matrix_commutes_all_iff_scalar
    (A : Matrix (Fin 3) (Fin 3) Complex)
    (h : forall X : Matrix (Fin 3) (Fin 3) Complex, A * X = X * A) :
    exists z : Complex, A = z • 1 := ...
```

A coordinate proof using `Matrix.stdBasisMatrix` or explicit `Fin 3` cases is
fine. This is the heart of the task.

4. Recover the inverse scalar formula for `B`.

## Package

Add:

```lean
structure DVTMatrixLeftRightKernelPackage where
  kernel_scalar :
    forall A B : Units (Matrix (Fin 3) (Fin 3) Complex),
      (forall X : Matrix (Fin 3) (Fin 3) Complex,
        (A : Matrix (Fin 3) (Fin 3) Complex) * X *
          (B : Matrix (Fin 3) (Fin 3) Complex) = X) ->
      exists z : Complex,
        z != 0 /\
        (A : Matrix (Fin 3) (Fin 3) Complex) =
          z • (1 : Matrix (Fin 3) (Fin 3) Complex) /\
        (B : Matrix (Fin 3) (Fin 3) Complex) =
          z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) Complex)

noncomputable def dvtMatrixLeftRightKernelPackage :
    DVTMatrixLeftRightKernelPackage := ...
```

Use `≠` in Lean code.

## Claim boundary

This is a finite matrix-algebra kernel theorem. It does not prove unitarity,
determinant-one constraints, quotient topology, compact Lie groups, or the full
DVT stabilizer theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted output.
- Do not change existing DVT complement definitions.
- Do not edit `PhysicsSM.lean`.
- If the transported theorem is too hard, prove the matrix theorem first and
  leave a draft handoff for transport.

## Verification

Run:

```bash
lake build PhysicsSM.Algebra.Jordan.DVTMatrixLeftRightKernel
```
