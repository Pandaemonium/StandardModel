# Aristotle task: TrialityTriple module and linear action API

**Agent**: Aristotle
**Status**: Complete and integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `d6740f6d-59c8-47a4-a733-6c1f9a5f4202`
**Submission project**: `AgentTasks/aristotle-submit/furey-triality-triple-module-20260529-project`
**Output**: `AgentTasks/aristotle-output/furey-triality-triple-module-20260529`
**Extracted output**: `AgentTasks/aristotle-output/furey-triality-triple-module-20260529-extracted`
**Integrated file**: `PhysicsSM/Algebra/Furey/TrialityTripleModule.lean`
**Type**: linear algebra scaffold / triality action

## Goal

Upgrade the generic `TrialityTriple` scaffold so that triples inherit the
expected additive and module structure componentwise, and show that a
`TrialityActionData` induces a genuine linear endomorphism of the triple
module.

This is the natural next theorem layer after
`PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold`: it turns the current
componentwise function `actTriple` into a linear map on triples.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Furey/TrialityTripleModule.lean
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.TrialityTripleModule
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Existing declarations

Useful names include:

```lean
PhysicsSM.Algebra.Furey.TrialityRole
PhysicsSM.Algebra.Furey.TrialityTriple
PhysicsSM.Algebra.Furey.TrialityTriple.proj
PhysicsSM.Algebra.Furey.TrialityTriple.ofFun
PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold.TrialityActionData
PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold.TrialityActionData.actTriple
PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold.TrialityActionData.id
PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold.TrialityActionData.comp
```

`TrialityTriple.lean` already provides pointwise `Zero`, `Add`, `Neg`, and
`SMul` instances. This task should add the missing algebraic laws.

## Target statements

Provide componentwise instances, as feasible:

```lean
instance instAddCommMonoidTrialityTriple [AddCommMonoid M] :
    AddCommMonoid (TrialityTriple M) := ...

instance instAddCommGroupTrialityTriple [AddCommGroup M] :
    AddCommGroup (TrialityTriple M) := ...

instance instModuleTrialityTriple
    (K : Type*) [Semiring K] [AddCommMonoid M] [Module K M] :
    Module K (TrialityTriple M) := ...
```

Then define:

```lean
def TrialityActionData.toLinearEnd
    (rho : TrialityActionData K M) :
    Module.End K (TrialityTriple M)
```

Prove:

```lean
theorem TrialityActionData.toLinearEnd_apply
    (rho : TrialityActionData K M) (t : TrialityTriple M) :
    rho.toLinearEnd t = rho.actTriple t := ...

theorem TrialityActionData.toLinearEnd_id :
    (TrialityActionData.id (K := K) (M := M)).toLinearEnd =
      LinearMap.id := ...

theorem TrialityActionData.toLinearEnd_comp
    (rho sigma : TrialityActionData K M) :
    (rho.comp sigma).toLinearEnd =
      rho.toLinearEnd.comp sigma.toLinearEnd := ...
```

Projection lemmas for addition and scalar multiplication are also useful:

```lean
theorem proj_add ...
theorem proj_smul ...
```

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Keep all definitions generic in `K` and `M`.
- Do not claim any Standard Model gauge embedding.
- Prefer simple extensionality proofs over automation-heavy code.
- If adding instances inside a child namespace is awkward, use the parent
  `PhysicsSM.Algebra.Furey` namespace for instances but keep theorem names
  descriptive.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/TrialityTripleModule.lean
lake env lean PhysicsSM.lean
```

## Deliverable

Return files changed, theorem names proved, whether the output is sorry-free,
and exact verification commands run.

## Integration result

Integrated on 2026-05-29 into trusted code as
`PhysicsSM.Algebra.Furey.TrialityTripleModule`.

Main declarations added:

- `TrialityTriple.proj_zero`
- `TrialityTriple.proj_add`
- `TrialityTriple.proj_neg`
- `TrialityTriple.proj_smul`
- `instSubTrialityTriple`
- `instAddCommMonoidTrialityTriple`
- `instAddCommGroupTrialityTriple`
- `instModuleTrialityTriple`
- `TrialityActionData.toLinearEnd`
- `TrialityActionData.toLinearEnd_apply`
- `TrialityActionData.toLinearEnd_id`
- `TrialityActionData.toLinearEnd_comp`

Verification run during integration:

```bash
lake env lean PhysicsSM\Algebra\Furey\TrialityTripleModule.lean
lake build PhysicsSM.Algebra.Furey.QopJbarEigenBridge PhysicsSM.Algebra.Furey.TrialityTripleModule PhysicsSM.Algebra.Furey.TrialityRolePermutation
lake build PhysicsSM
```

Status: sorry-free trusted integration. The root build passed with pre-existing
warnings in older modules.
