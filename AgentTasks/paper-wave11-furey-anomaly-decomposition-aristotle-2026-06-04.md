# Aristotle task: Furey one-generation anomaly decomposition package

Date: 2026-06-04

## Goal

Strengthen `FureyRealizesOneGenerationPackage` with a paper-facing package
that separates the anomaly contributions of:

1. the Furey/Jbar left-handed doublet table,
2. the conventional right-handed singlet completion,
3. the combined all-left one-generation table.

Primary target file:

```text
PhysicsSM/Algebra/Furey/FureyAnomalyDecomposition.lean
```

Useful imports:

```text
PhysicsSM.Algebra.Furey.FureyRealizesOneGeneration
PhysicsSM.Algebra.Furey.ElectroweakAnomalyBridge
PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly
PhysicsSM.Algebra.Furey.OneGenerationPackage
PhysicsSM.StandardModel.AnomalyPackage
PhysicsSM.StandardModel.OneGenerationTable
```

## Preferred theorem shape

Create a trusted package like:

```lean
structure FureyAnomalyDecompositionPackage where
  doublet_su2_squared_u1 :
    su2SquaredU1Anomaly fureyDoubletTable = 0
  completed_table_eq_standard :
    fureyDoubletTable ++ rightHandedSingletCompletion =
      standardModelOneGeneration
  completed_local_anomaly_free :
    LocalAnomalyFree (fureyDoubletTable ++ rightHandedSingletCompletion)
  completed_witten_anomaly_free :
    WittenSU2AnomalyFree
      (fureyDoubletTable ++ rightHandedSingletCompletion)
  all_left_table_match :
    allLeftList15.map AllLeftMultiplet.toChiralMultiplet =
      standardModelOneGeneration
```

Please use actual names from the current modules. If the exact table names
differ, adapt them without weakening the intended claims.

## Stretch target

If APIs exist, prove separate equalities for each perturbative anomaly
coefficient after completion:

- `SU(3)^2-U(1)`
- `SU(2)^2-U(1)`
- gravitational-`U(1)`
- cubic `U(1)^3`
- mixed local anomaly package fields

## Claim boundary

Keep the right-handed singlet sector explicitly marked as a conventional
completion, not an algebraic derivation from the Furey ladder algebra.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the definitions of `standardModelOneGeneration`,
  `fureyDoubletTable`, or `rightHandedSingletCompletion`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/FureyAnomalyDecomposition.lean
lake build PhysicsSM.Algebra.Furey.FureyAnomalyDecomposition
```

## Submission

Status: integrated.

Submission project:

```text
AgentTasks/aristotle-submit/paper-wave11-20260604
```

Job ID:

```text
bfd5890f-c30a-4ded-aa8d-095662184cb7
```

Integrated result:

```text
PhysicsSM/Algebra/Furey/FureyAnomalyDecomposition.lean
```

Verification run after integration:

```bash
lake build PhysicsSM.Algebra.Furey.FureyAnomalyDecomposition
```
