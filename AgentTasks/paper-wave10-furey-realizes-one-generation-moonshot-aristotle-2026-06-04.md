# Aristotle task: moonshot Furey realizes one Standard Model generation

Date: 2026-06-04

## Goal

Close the main Furey claim boundary by proving a precise, convention-explicit
theorem connecting the Furey `J` and `Jbar` finite state data to the
conventional `standardModelOneGeneration` anomaly table.

Primary target file:

```text
PhysicsSM/Algebra/Furey/FureyRealizesOneGeneration.lean
```

Useful existing files:

```text
PhysicsSM/Algebra/Furey/AnomalyBridge.lean
PhysicsSM/Algebra/Furey/ElectroweakAnomalyBridge.lean
PhysicsSM/Algebra/Furey/ElectroweakCompletePackage.lean
PhysicsSM/Algebra/Furey/JbarCoordinateEquiv.lean
PhysicsSM/Algebra/Furey/JbarActionTable.lean
PhysicsSM/StandardModel/AnomalyPackage.lean
PhysicsSM/StandardModel/OneGenerationTable.lean
```

## Preferred theorem shape

Try to define and prove a theorem package along these lines:

```lean
structure FureyRealizesOneGenerationPackage where
  jbar_left_doublets_match :
    -- Jbar doublets have the same SU2/Y/Q data as the left-handed sector.
  right_singlet_boundary :
    ClaimBoundary
  one_generation_table_match :
    -- The Furey-derived/bridged multiplet list equals
    -- `standardModelOneGeneration` up to the documented handedness convention.
  local_anomaly_free :
    LocalAnomalyFree standardModelOneGeneration
  witten_anomaly_free :
    WittenSU2AnomalyFree standardModelOneGeneration
```

If the full equality to `standardModelOneGeneration` is too hard, prove a
clear finite equivalence between the Furey charge/hypercharge table and the
left-handed doublet part, and add an explicit claim-boundary theorem saying
which right-handed singlets remain conventional rather than algebraically
derived.

## Mathematical intent

This is the cleanest high-impact Furey theorem for the paper: it separates
what the algebra now proves from what is still a physical/conventional
identification.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not silently change charge, hypercharge, chirality, or particle/antiparticle
  conventions.
- If a statement is only true after charge conjugation, make that map explicit.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/FureyRealizesOneGeneration.lean
lake build PhysicsSM.Algebra.Furey.FureyRealizesOneGeneration
```

## Submission

Status: submitted.

Submission project: `AgentTasks/aristotle-submit/paper-wave10-20260604`

Canceled first attempt: `eee0edba-16aa-4aaa-a4fc-60f847045eb4`

Active job ID: `a0415283-fdfe-44e6-9832-33a1bcf0f8d8`
