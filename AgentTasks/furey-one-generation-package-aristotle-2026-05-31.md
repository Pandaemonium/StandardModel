# Aristotle task: Furey one-generation package

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `12e21221-4c8c-433d-94f2-747bc46ed347`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-wave-20260531-project`
**Output**: `AgentTasks/aristotle-output/furey-one-generation-package-20260531-result`
**Extracted output**: `AgentTasks/aristotle-output/furey-one-generation-package-20260531-extracted`
**Type**: Furey one-generation theorem package

## Integration

Integrated on 2026-05-31 from Aristotle job
`12e21221-4c8c-433d-94f2-747bc46ed347`.

Live file:

```text
PhysicsSM/Algebra/Furey/OneGenerationPackage.lean
```

Root import added to `PhysicsSM.lean`.

## Goal

Create a trusted theorem package that bundles the existing Furey charge,
electroweak, anomaly, and conventional one-generation table results into a
single citation-friendly landing page.

The purpose is not to claim the full Furey program is complete. The theorem
package should clearly separate:

- what is already proved from the Furey operator/eigenvalue tables;
- what is conventional Standard Model bookkeeping;
- what remains an explicit right-handed-sector/open-realization boundary.

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Furey/OneGenerationPackage.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.AnomalyBridge
import PhysicsSM.Algebra.Furey.ElectroweakBridge
import PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly
import PhysicsSM.Algebra.Furey.QopElectroweakConsistency
import PhysicsSM.StandardModel.AnomalyPackage
import PhysicsSM.StandardModel.OneGenerationTable
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.OneGenerationPackage
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Current context

Useful existing declarations include:

- `ElectroweakBridge.Jbar_left_multiplets_match_Q_L_L_L`
- `ElectroweakBridge.gellMannNishijima_all`
- `ElectroweakBridge.targetY_values`
- `ElectroweakBridge.FureyRightHandedSectorOpen`
- `JbarElectroweakAnomaly.JbarLeftDoubletMultiplets`
- `JbarElectroweakAnomaly.JbarLeftDoublet_su2SquaredU1Anomaly`
- `JbarElectroweakAnomaly.JbarLeftDoublet_matches_Q_L_L_L`
- `QopElectroweakConsistency.Q_op_eigenvalue_matches_electroweak_raw_table`
- `AnomalyBridge.combined_gravitational_anomaly_vanishes`
- `AnomalyBridge.combined_cubic_anomaly_vanishes`
- `AnomalyBridge.sm_localAnomalyFree`
- `AnomalyBridge.sm_wittenAnomalyFree`
- `OneGenerationTable.allLeftList15_toChiralMultiplet_eq`
- `OneGenerationTable.gellMannNishijima_all_left`
- `AnomalyPackage.standardModelOneGeneration_anomalyFree`

## Target declarations

Please create a small package structure with fields close to these:

```lean
structure FureyOneGenerationPackage where
  jbar_left_matches_Q_L_L_L : Prop
  jbar_su2_squared_u1 : su2SquaredU1Anomaly JbarLeftDoubletMultiplets = 0
  all_left_table_eq :
    allLeftList15.map AllLeftMultiplet.toChiralMultiplet =
      standardModelOneGeneration
  standard_model_anomaly_free :
    LocalAnomalyFree standardModelOneGeneration /\
    WittenSU2AnomalyFree standardModelOneGeneration
  combined_charge_sum_zero :
    (-1 : Rat) * 1 + (-2/3) * 3 + (-1/3) * 3 + 0 * 1 +
    1 * 1 + (2/3) * 3 + (1/3) * 3 + 0 * 1 = 0
  combined_charge_cube_sum_zero :
    (-1 : Rat) ^ 3 * 1 + (-2/3) ^ 3 * 3 + (-1/3) ^ 3 * 3 +
    0 ^ 3 * 1 +
    (1 : Rat) ^ 3 * 1 + (2/3) ^ 3 * 3 + (1/3) ^ 3 * 3 +
    0 ^ 3 * 1 = 0
  right_handed_sector_boundary : FureyRightHandedSectorOpen
```

Adjust field types if needed to avoid namespace friction, but keep the
semantic content.

Then instantiate it:

```lean
theorem fureyOneGenerationPackage : FureyOneGenerationPackage := ...
```

Also add source-facing wrapper theorems, if easy:

```lean
theorem furey_jbar_left_doublets_match_standard_model :
    ... := ...

theorem furey_all_left_table_is_standardModelOneGeneration :
    allLeftList15.map AllLeftMultiplet.toChiralMultiplet =
      standardModelOneGeneration := ...

theorem furey_standardModelOneGeneration_anomalyFree :
    LocalAnomalyFree standardModelOneGeneration /\
    WittenSU2AnomalyFree standardModelOneGeneration := ...
```

## Claim boundary

This package should not claim that Furey's algebra has fully derived the
physical one-generation Standard Model. It should be a theorem index over the
current trusted bridge results and should explicitly preserve the
right-handed-sector/open-realization boundary.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Prefer wrappers and bundled theorems over re-proving coordinate facts.
- Do not weaken existing theorem statements.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/OneGenerationPackage.lean
lake build PhysicsSM.Algebra.Furey.OneGenerationPackage
```
