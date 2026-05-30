# Aristotle task: Hermitian form and norm on ComplexTriple

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Integrated**: 2026-05-29
**Aristotle job ID**: `6a8919fa-1574-449e-ab7d-a0c9ce2d39d0`
**Submission project**: `AgentTasks/aristotle-submit/baez-next-linear-coordinate-20260529-project`
**Output**: `AgentTasks/aristotle-output/baez-complex-triple-hermitian-20260529-extracted`
**Type**: Baez `C^3` complement / Hermitian geometry prelude

## Goal

Define the standard Hermitian form and squared norm on the `C^3` complement
coordinates, then prove their basic behavior under complex scalar
multiplication.

This is a preparatory layer for the later target that maps fixing the chosen
octonion unit should act by unitary transformations on the complement. This
job should not claim unitarity yet.

## Current context

The project already has:

- `PhysicsSM.Algebra.Octonion.ComplexTripleModule`
- `ComplexTriple.toComplexVec`
- `ComplexTriple.complexSmul`
- `ComplexTriple.toComplexVec_complexSmul`

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Octonion/ComplexTripleHermitian.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.ComplexTripleModule
```

If the result is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Use declarations that match mathlib naming and are easy to reuse. Suggested
targets:

```lean
noncomputable def ComplexTriple.hermitian
    (u v : ComplexTriple) : Complex := ...

noncomputable def ComplexTriple.normSq
    (w : ComplexTriple) : Real := ...
```

Good definitions would be:

```lean
ComplexTriple.hermitian u v =
  sum over k : Fin 3 of Complex.conj (u.toComplexVec k) * v.toComplexVec k

ComplexTriple.normSq w =
  sum over k : Fin 3 of Complex.normSq (w.toComplexVec k)
```

Please prove as many of these as feasible:

```lean
theorem ComplexTriple.normSq_nonneg ...
theorem ComplexTriple.normSq_zero ...
theorem ComplexTriple.normSq_eq_zero_iff ...
theorem ComplexTriple.normSq_complexSmul ...
theorem ComplexTriple.hermitian_self_re ...
theorem ComplexTriple.hermitian_self_im ...
theorem ComplexTriple.hermitian_complexSmul_left ...
theorem ComplexTriple.hermitian_complexSmul_right ...
```

Expected scalar rule:

```lean
ComplexTriple.normSq (ComplexTriple.complexSmul z w) =
  Complex.normSq z * ComplexTriple.normSq w
```

For Hermitian scalar rules, use the convention
`hermitian u v = sum conj(u_k) * v_k`, so scalar multiplication in the first
slot introduces `Complex.conj z` and scalar multiplication in the second slot
introduces `z`.

## Constraints

- This is Hermitian coordinate geometry only.
- Do not claim `SU(3)`, `G2`, or Standard Model statements.
- Do not introduce `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Keep theorem statements compatible with the existing `ComplexTriple`
  coordinate convention.

## Verification

Run at least:

```bash
lake build PhysicsSM.Algebra.Octonion.ComplexTripleHermitian
lake env lean PhysicsSM/Algebra/Octonion/ComplexTripleHermitian.lean
```
