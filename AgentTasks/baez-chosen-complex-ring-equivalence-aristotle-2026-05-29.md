# Aristotle task: chosen complex ring equivalence

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Integrated**: 2026-05-29
**Aristotle job ID**: `80f37a8c-8a03-469e-b43d-1fe099297efa`
**Submission project**: `AgentTasks/aristotle-submit/baez-next-c3-action-20260529-project`
**Output**: `AgentTasks/aristotle-output/baez-chosen-complex-ring-equivalence-20260529-extracted`
**Type**: Baez chosen complex line / algebra infrastructure

## Goal

Upgrade the coordinate type `ChosenComplex` from a collection of operations to
a reusable algebraic object equivalent to ordinary Lean `Complex`.

The project already has:

- `PhysicsSM.Algebra.Octonion.ChosenComplexAlgebra`
- `ChosenComplex.toComplex`
- `ChosenComplex.ofComplex`
- `ChosenComplex.toComplex_mul`
- round-trip theorems between `ChosenComplex` and `Complex`

This job should add conservative algebra/typeclass infrastructure for
`ChosenComplex`, then package the equivalence with `Complex`.

## Sources and claim boundary

Source motivation:

- John Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
- Baez, "The Octonions", Bull. Amer. Math. Soc. 2002.

Claim boundary:

- This is only the chosen complex line `span_R {1, e111}`.
- Do not claim any `G2`, `SU(3)`, or Standard Model theorem.
- Preserve the project XOR basis and existing `e111` convention.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Octonion/ChosenComplexRing.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Octonion.ChosenComplexAlgebra
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Octonion
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Add any missing instances needed for a ring-like API, preferably:

```lean
instance : AddCommGroup ChosenComplex
instance : CommRing ChosenComplex
```

If `CommRing` is too heavy under the current local definitions, use the
strongest standard mathlib structure that is straightforward and sorry-free,
but do not weaken silently: document in the module docstring which structure
was achieved.

Then define an equivalence with ordinary complex numbers:

```lean
noncomputable def ChosenComplex.ringEquivComplex : ChosenComplex ~=+* Complex
```

If the exact notation is awkward, use the standard mathlib `RingEquiv` type.

Prove simp/apply lemmas:

```lean
@[simp] theorem ChosenComplex.ringEquivComplex_apply
    (z : ChosenComplex) :
    ChosenComplex.ringEquivComplex z = z.toComplex

@[simp] theorem ChosenComplex.ringEquivComplex_symm_apply
    (z : Complex) :
    ChosenComplex.ringEquivComplex.symm z = ChosenComplex.ofComplex z
```

Also prove or re-export:

```lean
theorem ChosenComplex.toComplex_add ...
theorem ChosenComplex.toComplex_mul ...
theorem ChosenComplex.toComplex_one ...
theorem ChosenComplex.toComplex_zero ...
```

The goal is for downstream files to use ring reasoning over `ChosenComplex`
without unfolding every coordinate by hand.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change existing definitions in `ChosenComplexAlgebra`.
- Do not use octonion associativity beyond the already proved restriction to
  the chosen complex line.
- Prefer `ext <;> simp [...] <;> ring` proofs.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Octonion/ChosenComplexRing.lean
lake build PhysicsSM.Algebra.Octonion.ChosenComplexRing
lake build PhysicsSM
```

## Deliverable

Return files changed, theorem names proved, whether the file is sorry-free,
and exact verification commands run.
