# Aristotle task: Furey triality family naturality

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `39ceac88-09c8-4cce-909c-dfe3f4f29c6a`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-wave-20260531-project`
**Output**: `AgentTasks/aristotle-output/furey-triality-family-naturality-20260531-result`
**Extracted output**: `AgentTasks/aristotle-output/furey-triality-family-naturality-20260531-extracted`
**Type**: triality instantiation of family-symmetry naturality

## Integration

Integrated on 2026-05-31 from Aristotle job
`39ceac88-09c8-4cce-909c-dfe3f4f29c6a`.

Live file:

```text
PhysicsSM/Algebra/Furey/TrialityFamilyNaturality.lean
```

Root import added to `PhysicsSM.lean`.

## Goal

Instantiate the new family-symmetry naturality idea for the existing
Furey-Hughes triality role-permutation API.

This should be a generic finite-role theorem package. It should not claim that
the project has formalized the full `tri(C) + tri(H) + tri(O)` Lie algebra, nor
that triality physically explains the three generations.

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Furey/TrialityFamilyNaturality.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.StandardModel.FamilySymmetry
import PhysicsSM.Algebra.Furey.TrialityPermutationRepresentation
import PhysicsSM.Algebra.Furey.TrialityActionMonoid
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.TrialityFamilyNaturality
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Current context

Useful existing declarations include:

- `TrialityRole`
- `TrialityRole.cycle`
- `TrialityRole.cycle_three`
- `TrialityRole.cycleEquiv`
- `TrialityTriple`
- `TrialityTriple.permute`
- `TrialityTriple.cycle`
- `TrialityTriple.cycle_three`
- `TrialityTriple.permuteLinearEquiv`
- `TrialityTriple.cycleLinearEquiv`
- `TrialityTriple.cycleLinearEquiv_three`
- `TrialityTriple.cycleLinearEquiv_trans_three`
- `TrialityActionData`
- `TrialityActionData.toLinearEndMonoidHom`
- `PhysicsSM.StandardModel.FamilySymmetry.ChargeTable`
- `ChargeTable.SatisfiesGMN`

## Target declarations

First add a plain linear version of eigenvalue transport if the continuous
linear map API in `FamilySymmetry` is too topological for the existing
triality API:

```lean
def CommutesWithLinearEquivPlain
    {K M : Type*} [Semiring K] [AddCommMonoid M] [Module K M]
    (A : M →ₗ[K] M) (e : M ≃ₗ[K] M) : Prop :=
  forall x, A (e x) = e (A x)

theorem eigenvector_transport_plain
    {K M : Type*} [Semiring K] [AddCommMonoid M] [Module K M]
    (A : M →ₗ[K] M) (e : M ≃ₗ[K] M) (lambda : K) (x : M)
    (hcomm : CommutesWithLinearEquivPlain A e)
    (heig : A x = lambda • x) :
    A (e x) = lambda • e x := ...
```

Then instantiate it for the triality cycle:

```lean
theorem triality_cycle_eigenvector_transport
    {K M : Type*} [Semiring K] [AddCommMonoid M] [Module K M]
    (A : Module.End K (TrialityTriple M)) (lambda : K)
    (x : TrialityTriple M)
    (hcomm :
      CommutesWithLinearEquivPlain A
        (TrialityTriple.cycleLinearEquiv (M := M) K))
    (heig : A x = lambda • x) :
    A (TrialityTriple.cycleLinearEquiv (M := M) K x) =
      lambda • TrialityTriple.cycleLinearEquiv (M := M) K x := ...
```

Also add charge-table naturality over `TrialityRole`. A useful lightweight
version is:

```lean
def TrialityRoleChargeTable :=
  PhysicsSM.StandardModel.FamilySymmetry.ChargeTable TrialityRole

def RoleConstant (t : TrialityRoleChargeTable) : Prop := ...

theorem RoleConstant.cycle_invariant_electric ...
theorem RoleConstant.cycle_invariant_weakT3 ...
theorem RoleConstant.cycle_invariant_hypercharge ...

theorem roleConstant_gmn_cycle
    (t : TrialityRoleChargeTable)
    (hconst : RoleConstant t)
    (hgmn : t.SatisfiesGMN)
    (r : TrialityRole) :
    t.electric (TrialityRole.cycle r) =
      t.weakT3 (TrialityRole.cycle r) +
        t.hypercharge (TrialityRole.cycle r) / 2 := ...
```

If convenient, add the same theorem for `cycleEquiv`.

## Claim boundary

This is a formal naturality theorem for role permutations and role-constant
charge tables. It does not assert that Furey-Hughes triality is the physical
origin of generations.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Preserve the existing pullback convention for `TrialityTriple.permute`.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/TrialityFamilyNaturality.lean
lake build PhysicsSM.Algebra.Furey.TrialityFamilyNaturality
```
