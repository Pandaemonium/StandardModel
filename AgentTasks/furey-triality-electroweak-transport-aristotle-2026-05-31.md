# Aristotle task: Furey triality electroweak transport package

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `68039429-c89b-4ed4-98bc-22dfb07e1504`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-wave-20260531-project`
**Type**: manuscript-facing bridge between Furey electroweak and triality naturality

## Goal

Create a small trusted bridge package joining the Furey electroweak paper
package to the existing triality role-constant GMN transport theorem.

This is intended for the manuscript's family-symmetry section: it should say
that the finite Furey electroweak theorem island is available alongside the
conditional role-constant triality transport lemmas.

## Requested file

Create:

```text
PhysicsSM/Algebra/Furey/TrialityElectroweakTransport.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.ElectroweakPaperPackage
import PhysicsSM.Algebra.Furey.TrialityFamilyNaturality
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.TrialityElectroweakTransport
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Target declarations

Add wrapper theorems around the role-constant GMN transport lemmas:

```lean
theorem roleConstant_triality_cycle_gmn
    (t : TrialityFamilyNaturality.TrialityRoleChargeTable)
    (hconst : TrialityFamilyNaturality.RoleConstant t)
    (hgmn : t.SatisfiesGMN)
    (r : TrialityRole) :
    t.electric (TrialityRole.cycle r) =
      t.weakT3 (TrialityRole.cycle r) +
        t.hypercharge (TrialityRole.cycle r) / 2 := ...

theorem roleConstant_triality_cycle_gmn_inv
    (t : TrialityFamilyNaturality.TrialityRoleChargeTable)
    (hconst : TrialityFamilyNaturality.RoleConstant t)
    (hgmn : t.SatisfiesGMN)
    (r : TrialityRole) :
    t.electric (TrialityRole.cycle r) =
      t.weakT3 r + t.hypercharge r / 2 := ...
```

Package these together with the Furey electroweak package:

```lean
structure TrialityElectroweakTransportPackage where
  furey_electroweak :
    ElectroweakPaperPackage.FureyElectroweakPaperPackage
  cycle_gmn :
    forall
      (t : TrialityFamilyNaturality.TrialityRoleChargeTable)
      (hconst : TrialityFamilyNaturality.RoleConstant t)
      (hgmn : t.SatisfiesGMN)
      (r : TrialityRole),
      t.electric (TrialityRole.cycle r) =
        t.weakT3 (TrialityRole.cycle r) +
          t.hypercharge (TrialityRole.cycle r) / 2
  cycle_gmn_inv :
    forall
      (t : TrialityFamilyNaturality.TrialityRoleChargeTable)
      (hconst : TrialityFamilyNaturality.RoleConstant t)
      (hgmn : t.SatisfiesGMN)
      (r : TrialityRole),
      t.electric (TrialityRole.cycle r) =
        t.weakT3 r + t.hypercharge r / 2

theorem trialityElectroweakTransportPackage :
    TrialityElectroweakTransportPackage := ...
```

Use existing declarations:

- `ElectroweakPaperPackage.fureyElectroweakPaperPackage`
- `TrialityFamilyNaturality.roleConstant_gmn_cycle`
- `TrialityFamilyNaturality.roleConstant_gmn_cycle_inv`

## Claim boundary

This is a conditional transport package. It does not prove that triality is the
physical origin of generations and does not formalize the full
`tri(C) + tri(H) + tri(O)` Lie algebra.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Prefer wrappers and delegation to existing theorem names.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/TrialityElectroweakTransport.lean
lake build PhysicsSM.Algebra.Furey.TrialityElectroweakTransport
```

## Integration result

**Completed**: 2026-05-31
**Result bundle**: `AgentTasks/aristotle-output/furey-triality-electroweak-transport-20260531-result`
**Extracted project**: `AgentTasks/aristotle-output/furey-triality-electroweak-transport-20260531-extracted/octonion-sm-next-wave-20260531-project_aristotle`
**Integrated file**: `PhysicsSM/Algebra/Furey/TrialityElectroweakTransport.lean`
**Root import**: `PhysicsSM.Algebra.Furey.TrialityElectroweakTransport`

Aristotle produced the requested wrapper package connecting the Furey
electroweak theorem island with the role-constant triality GMN transport
lemmas. The theorem remains conditional on role-constant charge tables.

Verification run during integration:

```bash
lake env lean PhysicsSM/Algebra/Furey/TrialityElectroweakTransport.lean
lake build PhysicsSM.Algebra.Furey.TrialityElectroweakTransport
```
