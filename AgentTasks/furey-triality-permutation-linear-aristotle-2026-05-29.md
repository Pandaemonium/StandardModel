# Aristotle task: triality permutation linear equivalences

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Integrated**: 2026-05-29
**Job ID**: `22f1a9eb-7eb3-4b0f-9b90-79b159492197`
**Submission project**: `AgentTasks/aristotle-submit/furey-triality-permutation-linear-20260529-project`
**Aristotle status**: `OUT_OF_BUDGET` but produced a useful checked artifact
**Output**: `AgentTasks/aristotle-output/furey-triality-permutation-linear-20260529-oob-extracted`
**Type**: linear algebra scaffold / triality roles

## Goal

Upgrade the finite role-permutation API to a linear-equivalence API on
`TrialityTriple M`.

The project now has:

- componentwise `Module K (TrialityTriple M)` in
  `PhysicsSM.Algebra.Furey.TrialityTripleModule`,
- role permutations and `TrialityTriple.permute` in
  `PhysicsSM.Algebra.Furey.TrialityRolePermutation`.

The next theorem layer should prove that every role permutation is a genuine
linear automorphism of the triality-triple module.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Furey/TrialityPermutationLinear.lean
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.TrialityTripleModule
import PhysicsSM.Algebra.Furey.TrialityRolePermutation
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define:

```lean
def TrialityTriple.permuteLinearEquiv
    (K : Type*) [Semiring K] [AddCommMonoid M] [Module K M]
    (e : Equiv.Perm TrialityRole) :
    TrialityTriple M ≃ₗ[K] TrialityTriple M
```

with forward map `fun t => t.permute e` and inverse map
`fun t => t.permute e.symm`.

Prove useful simp/structural lemmas, with exact names if feasible:

```lean
theorem TrialityTriple.permuteLinearEquiv_apply ...
theorem TrialityTriple.permuteLinearEquiv_symm_apply ...
theorem TrialityTriple.permuteLinearEquiv_refl ...
theorem TrialityTriple.permuteLinearEquiv_trans ...
```

Then specialize to the triality cycle:

```lean
def TrialityTriple.cycleLinearEquiv
    (K : Type*) [Semiring K] [AddCommMonoid M] [Module K M] :
    TrialityTriple M ≃ₗ[K] TrialityTriple M

theorem TrialityTriple.cycleLinearEquiv_apply ...
theorem TrialityTriple.cycleLinearEquiv_three ...
```

The `cycleLinearEquiv_three` theorem should express that the third power of the
linear equivalence is the identity. Choose the cleanest Lean statement, for
example equality of functions on all triples if equality of linear equivalences
is awkward.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- This is a finite module/linear algebra theorem only; do not claim Spin(8)
  triality or a Standard Model action theorem.
- Keep proofs by extensionality and cases over `TrialityRole`.
- Preserve the pullback convention from `TrialityTriple.permute`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/TrialityPermutationLinear.lean
lake build PhysicsSM.Algebra.Furey.TrialityPermutationLinear
lake build PhysicsSM
```

## Deliverable

Return files changed, theorem names proved, whether the output is sorry-free,
and exact verification commands run.
