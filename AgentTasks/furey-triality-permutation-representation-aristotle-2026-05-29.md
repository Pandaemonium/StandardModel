# Aristotle task: triality role permutations as a linear representation

**Agent**: Aristotle
**Status**: Integrated after OUT_OF_BUDGET
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `3a8a8fce-12cc-482b-9b4d-f457c08aeeae`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-round-20260529-project`
**Output**: `AgentTasks/aristotle-output/furey-triality-permutation-representation-20260529`
**Downloaded output**: `AgentTasks/aristotle-output/3a8a8fce-20260530-oob`
**Extracted output**: `AgentTasks/aristotle-output/3a8a8fce-20260530-oob-extracted`
**Integrated file**: `PhysicsSM/Algebra/Furey/TrialityPermutationRepresentation.lean`
**Type**: Furey-Hughes triality scaffold / finite linear representation

## Integration note

The Aristotle job ended with status `OUT_OF_BUDGET`. The downloaded artifact
contained the original submission project but did not contain the requested
`TrialityPermutationRepresentation.lean` file or a usable Lean patch.

The target was small enough to integrate locally using the existing trusted
`TrialityPermutationLinear` API. The integrated file records the OOB provenance
and proves the representation-style identity/composition aliases and the
third-power law for the canonical cycle as a linear equivalence.

## Goal

Package the action of finite triality-role permutations on
`TrialityTriple M` as a reusable linear representation API.

The previous integrated job produced `TrialityTriple.permuteLinearEquiv`; this
job should make the representation behavior explicit and convenient for later
Furey-Hughes triality-action work.

## Current context

The project already has:

- `PhysicsSM.Algebra.Furey.TrialityRolePermutation`
- `PhysicsSM.Algebra.Furey.TrialityTripleModule`
- `PhysicsSM.Algebra.Furey.TrialityPermutationLinear`
- `TrialityTriple.permuteLinearEquiv`
- `TrialityTriple.permuteLinearEquiv_refl`
- `TrialityTriple.permuteLinearEquiv_trans`
- `TrialityTriple.cycleLinearEquiv`
- `TrialityTriple.cycleLinearEquiv_three`

There is also a separate active job,
`furey-triality-linear-equivariance-aristotle-2026-05-29.md`, for
equivariance of `TrialityActionData.toLinearEnd`. Do not duplicate that target.

## Sources and claim boundary

Source motivation:

- Cohl Furey and Mia Hughes, "Three Generations and a Trio of Trialities",
  arXiv:2409.17948.

Claim boundary:

- This is finite role-permutation linear algebra only.
- Do not claim this is the full `tri(C) + tri(H) + tri(O)` Lie algebra or a
  Standard Model group action theorem.

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Furey/TrialityPermutationRepresentation.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.TrialityPermutationLinear
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define a monoid/group-hom style map from role permutations to linear
automorphisms:

```lean
def TrialityTriple.permuteLinearRepresentation
    (K : Type*) [Semiring K] [AddCommMonoid M] [Module K M] :
    Equiv.Perm TrialityRole ->* (TrialityTriple M ~=l[K] TrialityTriple M) := ...
```

Use the actual Lean notation/type for `LinearEquiv`.

If `LinearEquiv` multiplication orientation is awkward, define a bundled
`MonoidHom` only if it fits naturally; otherwise prove the following explicit
theorems:

```lean
theorem TrialityTriple.permuteLinearEquiv_map_refl ...

theorem TrialityTriple.permuteLinearEquiv_map_trans
    (e f : Equiv.Perm TrialityRole) :
    (TrialityTriple.permuteLinearEquiv K e).trans
      (TrialityTriple.permuteLinearEquiv K f) =
    TrialityTriple.permuteLinearEquiv K (e.trans f) := ...
```

Also prove cycle-power theorems in the linear-equivalence API:

```lean
theorem TrialityTriple.cycleLinearEquiv_pow_three_apply
    (t : TrialityTriple M) :
    TrialityTriple.cycleLinearEquiv K
      (TrialityTriple.cycleLinearEquiv K
        (TrialityTriple.cycleLinearEquiv K t)) = t := ...

theorem TrialityTriple.cycleLinearEquiv_trans_three :
    ((TrialityTriple.cycleLinearEquiv K).trans
      (TrialityTriple.cycleLinearEquiv K)).trans
      (TrialityTriple.cycleLinearEquiv K) =
    LinearEquiv.refl K (TrialityTriple M) := ...
```

If `trans` associativity or coercions are awkward, choose the cleanest
kernel-checked statement and document it.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not duplicate the active `TrialityLinearEquivariance` job.
- Use extensionality and the existing permutation-linear theorems.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/TrialityPermutationRepresentation.lean
lake build PhysicsSM.Algebra.Furey.TrialityPermutationRepresentation
lake build PhysicsSM
```
