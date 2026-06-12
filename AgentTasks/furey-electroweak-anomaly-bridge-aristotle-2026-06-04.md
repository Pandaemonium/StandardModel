# Aristotle task: bridge Furey electroweak table to anomaly package

Date: 2026-06-04

## Goal

Create a trusted bridge from the Furey electroweak finite-state table to the
existing Standard Model anomaly-cancellation package.

Target module:

```text
PhysicsSM/Algebra/Furey/ElectroweakAnomalyBridge.lean
```

## Context

Relevant modules:

- `PhysicsSM.Algebra.Furey.ElectroweakCompletePackage`
- `PhysicsSM.Algebra.Furey.ElectroweakPaperPackage`
- `PhysicsSM.StandardModel.OneGenerationTable`
- `PhysicsSM.StandardModel.AnomalyPackage`
- `PhysicsSM.StandardModel.FamilyAnomalyNaturality`

## Preferred outcome

Prove that the Furey finite-state electroweak package is compatible with the
existing one-generation anomaly-free table. A good target is a package theorem
that combines:

- the Furey charge/weak-isospin assignments,
- the existing one-generation anomaly freedom theorem,
- an explicit statement that the Furey labels are a relabeling or refinement
of the Standard Model one-generation multiplet table.

Do not force a false bijection if the current Furey state type omits color,
chirality, antiparticles, or multiplicities needed by the anomaly package.

## Fallback

If a full table bridge is not present, prove a smaller compatibility theorem
for the electroweak quantum numbers already represented in both places, and
add a package with an explicit claim boundary naming the missing data.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/ElectroweakAnomalyBridge.lean
```

## Submission

Status: submitted.

Submission project: `AgentTasks/aristotle-submit/paper-wave8-20260604`

Job ID: `e693f741-94bf-446c-8779-c99e7609c616`
