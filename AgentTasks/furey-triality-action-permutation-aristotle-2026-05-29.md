# Aristotle task: triality action permutation intertwiner

**Agent**: Aristotle
**Status**: Complete and integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `aa3f9867-36d3-4ada-9e7e-42d59e12c820`
**Submission project**: `AgentTasks/aristotle-submit/furey-triality-action-permutation-20260529-project`
**Output**: `AgentTasks/aristotle-output/furey-triality-action-permutation-20260529`
**Extracted output**: `AgentTasks/aristotle-output/furey-triality-action-permutation-20260529-extracted`
**Integrated file**: `PhysicsSM/Algebra/Furey/TrialityActionPermutation.lean`
**Type**: linear action scaffold / finite equivariance

## Goal

Prove the finite equivariance law relating:

- a role permutation on `TrialityTriple`,
- a corresponding role permutation of `TrialityActionData`,
- the componentwise action `TrialityActionData.actTriple`.

This is still only scaffolding. It does not assert a Spin(8) triality theorem.
It says that if we relabel the three roles and relabel the three component
endomorphisms in the matching way, then acting and relabeling commute.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Furey/TrialityActionPermutation.lean
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.TrialityTripleModule
import PhysicsSM.Algebra.Furey.TrialityRolePermutation
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define a role-indexed accessor for the three endomorphisms:

```lean
def TrialityActionData.actAtRole
    (rho : TrialityActionData K M) : TrialityRole -> Module.End K M
```

with convention:

```text
spinorPlus  -> actC
spinorMinus -> actH
vector      -> actO
```

Define a constructor from role-indexed endomorphisms:

```lean
def TrialityActionData.ofRoleEnd
    (f : TrialityRole -> Module.End K M) : TrialityActionData K M
```

Define role permutation of action data by pullback:

```lean
def TrialityActionData.permuteRoles
    (e : Equiv.Perm TrialityRole) (rho : TrialityActionData K M) :
    TrialityActionData K M :=
  TrialityActionData.ofRoleEnd (fun r => rho.actAtRole (e.symm r))
```

Prove projection/accessor lemmas and the main intertwining theorem:

```lean
theorem TrialityActionData.actAtRole_actTriple ...

theorem TrialityActionData.actTriple_permuteRoles
    (e : Equiv.Perm TrialityRole) (rho : TrialityActionData K M)
    (t : TrialityTriple M) :
    (rho.permuteRoles e).actTriple (t.permute e) =
      (rho.actTriple t).permute e
```

Also prove identity/cycle sanity lemmas if feasible:

```lean
theorem TrialityActionData.permuteRoles_refl ...
theorem TrialityActionData.permuteRoles_trans ...
```

Adjust theorem orientation if Lean's `Equiv.trans` convention makes another
statement cleaner, but document it.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not depend on the separate `TrialityPermutationLinear` job; this job
  should be able to run in parallel.
- Use only finite role cases and extensionality.
- Do not claim any Standard Model gauge embedding.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/TrialityActionPermutation.lean
lake build PhysicsSM.Algebra.Furey.TrialityActionPermutation
lake build PhysicsSM
```

## Deliverable

Return files changed, theorem names proved, whether the output is sorry-free,
and exact verification commands run.

## Integration result

Integrated on 2026-05-29 into trusted code as
`PhysicsSM.Algebra.Furey.TrialityActionPermutation`.

Main declarations added:

- `TrialityActionData.actAtRole`
- `TrialityActionData.ofRoleEnd`
- `TrialityActionData.ofRoleEnd_actAtRole`
- `TrialityActionData.actAtRole_ofRoleEnd`
- `TrialityActionData.actAtRole_actTriple`
- `TrialityActionData.ext_actAtRole`
- `TrialityActionData.permuteRoles`
- `TrialityActionData.actAtRole_permuteRoles`
- `TrialityActionData.actTriple_permuteRoles`
- `TrialityActionData.permuteRoles_refl`
- `TrialityActionData.permuteRoles_trans`

Verification run during integration:

```bash
lake env lean PhysicsSM\Algebra\Furey\TrialityActionPermutation.lean
lake build PhysicsSM.Algebra.Furey.QopElectroweakConsistency PhysicsSM.Algebra.Furey.TrialityActionPermutation PhysicsSM.Algebra.Jordan.DVTStabilizerPrelude
pre-commit run --all-files
lake build
```

Status: sorry-free trusted integration. The generated proof of
`actTriple_permuteRoles` was locally simplified and rechecked. The full build
passed with pre-existing warnings in older modules.
