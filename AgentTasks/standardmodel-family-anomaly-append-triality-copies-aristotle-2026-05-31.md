# Aristotle task: anomaly append closure and triality-role copies

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `0aef3caa-09a2-4ba6-a2ee-b40aeea5f287`
**Retry submitted**: 2026-05-31
**Retry job ID**: `182b35d5-fa77-4e25-8cbc-6dee9930900e`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-paper-goals-20260531-project`
**Output**: `AgentTasks/aristotle-output/standardmodel-family-anomaly-append-triality-20260531-result`
**Extracted output**: `AgentTasks/aristotle-output/standardmodel-family-anomaly-append-triality-20260531-extracted`
**Type**: family/anomaly theorem for the formalization paper

## Goal

Prove that local and Witten anomaly freedom are closed under appending
multiplet lists, then use that theorem to build three independently relabeled
one-generation tables indexed by the existing Furey triality-role labels.

This is a useful bridge for the paper: it makes the "three copies" result look
less like a bare natural-number replication theorem and more like a finite
role-labeled family construction.

## Requested file

Create:

```text
PhysicsSM/StandardModel/FamilyAnomalyAppendTriality.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.StandardModel.FamilyRelabeledCopies
import PhysicsSM.Algebra.Furey.TrialityRolePermutation
```

Use namespace:

```lean
namespace PhysicsSM.StandardModel.FamilyAnomalyAppendTriality
```

Useful opens:

```lean
open PhysicsSM.StandardModel.AnomalyPackage
open PhysicsSM.StandardModel.FamilyAnomalyNaturality
open PhysicsSM.StandardModel.FamilyRelabeledCopies
open PhysicsSM.Algebra.Furey
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Current context

Useful existing declarations:

- `standardModelOneGeneration`
- `standardModelOneGeneration_localAnomalyFree`
- `standardModelOneGeneration_wittenAnomalyFree`
- `standardModelOneGeneration_relabel_anomalyFree`
- `relabelMultiplets`
- `nCopies_anomalyFree`
- `relabeledNCopies_standardModelOneGeneration_anomalyFree`
- `TrialityRole.spinorPlus`
- `TrialityRole.spinorMinus`
- `TrialityRole.vector`
- `TrialityRole.cycle`

## Target declarations

First add append-linearity lemmas for the anomaly coefficients:

```lean
theorem gravitationalU1Anomaly_append
    (xs ys : List ChiralMultiplet) :
    gravitationalU1Anomaly (xs ++ ys) =
      gravitationalU1Anomaly xs + gravitationalU1Anomaly ys := ...

theorem u1CubedAnomaly_append
    (xs ys : List ChiralMultiplet) :
    u1CubedAnomaly (xs ++ ys) =
      u1CubedAnomaly xs + u1CubedAnomaly ys := ...

theorem su2SquaredU1Anomaly_append
    (xs ys : List ChiralMultiplet) :
    su2SquaredU1Anomaly (xs ++ ys) =
      su2SquaredU1Anomaly xs + su2SquaredU1Anomaly ys := ...

theorem su3SquaredU1Anomaly_append
    (xs ys : List ChiralMultiplet) :
    su3SquaredU1Anomaly (xs ++ ys) =
      su3SquaredU1Anomaly xs + su3SquaredU1Anomaly ys := ...

theorem su3CubedAnomaly_append
    (xs ys : List ChiralMultiplet) :
    su3CubedAnomaly (xs ++ ys) =
      su3CubedAnomaly xs + su3CubedAnomaly ys := ...

theorem weakDoubletCount_append
    (xs ys : List ChiralMultiplet) :
    weakDoubletCount (xs ++ ys) =
      weakDoubletCount xs + weakDoubletCount ys := ...
```

Then prove append closure:

```lean
theorem LocalAnomalyFree.append
    {xs ys : List ChiralMultiplet}
    (hx : LocalAnomalyFree xs) (hy : LocalAnomalyFree ys) :
    LocalAnomalyFree (xs ++ ys) := ...

theorem WittenSU2AnomalyFree.append
    {xs ys : List ChiralMultiplet}
    (hx : WittenSU2AnomalyFree xs) (hy : WittenSU2AnomalyFree ys) :
    WittenSU2AnomalyFree (xs ++ ys) := ...

theorem anomalyFree_append
    {xs ys : List ChiralMultiplet}
    (hx : LocalAnomalyFree xs /\ WittenSU2AnomalyFree xs)
    (hy : LocalAnomalyFree ys /\ WittenSU2AnomalyFree ys) :
    LocalAnomalyFree (xs ++ ys) /\ WittenSU2AnomalyFree (xs ++ ys) := ...
```

Finally define triality-role-labeled relabeled copies:

```lean
def trialityRoleRelabeledOneGeneration
    (newLabel : TrialityRole -> ChiralMultiplet -> String)
    (r : TrialityRole) : List ChiralMultiplet :=
  relabelMultiplets (newLabel r) standardModelOneGeneration

def trialityThreeRoleCopies
    (newLabel : TrialityRole -> ChiralMultiplet -> String) :
    List ChiralMultiplet :=
  trialityRoleRelabeledOneGeneration newLabel TrialityRole.spinorPlus ++
  trialityRoleRelabeledOneGeneration newLabel TrialityRole.spinorMinus ++
  trialityRoleRelabeledOneGeneration newLabel TrialityRole.vector

theorem trialityThreeRoleCopies_anomalyFree
    (newLabel : TrialityRole -> ChiralMultiplet -> String) :
    LocalAnomalyFree (trialityThreeRoleCopies newLabel) /\
      WittenSU2AnomalyFree (trialityThreeRoleCopies newLabel) := ...
```

Package the final theorem:

```lean
structure FamilyAnomalyAppendTrialityPackage where
  triality_three_role_copies_anomaly_free :
    forall newLabel : TrialityRole -> ChiralMultiplet -> String,
      LocalAnomalyFree (trialityThreeRoleCopies newLabel) /\
        WittenSU2AnomalyFree (trialityThreeRoleCopies newLabel)

theorem familyAnomalyAppendTrialityPackage :
    FamilyAnomalyAppendTrialityPackage := ...
```

## Claim boundary

This is a finite list theorem about relabeled Standard Model anomaly tables.
It does not claim that physical generations are literally triality roles, and
it does not formalize the full Furey-Hughes triality mechanism.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change anomaly definitions or hypercharge conventions.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/StandardModel/FamilyAnomalyAppendTriality.lean
lake build PhysicsSM.StandardModel.FamilyAnomalyAppendTriality
```

## Retry note

The initial job `0aef3caa-09a2-4ba6-a2ee-b40aeea5f287` failed with an
Aristotle internal-error message and produced no usable result bundle. It was
resubmitted unchanged as job `182b35d5-fa77-4e25-8cbc-6dee9930900e`.

## Integration result

Integrated on 2026-05-31 from retry job
`182b35d5-fa77-4e25-8cbc-6dee9930900e`.

Live file:

```text
PhysicsSM/StandardModel/FamilyAnomalyAppendTriality.lean
```

Root import added to `PhysicsSM.lean`, and the package was added to the
publication theorem index as `AnomalyNaturalityIndex.triality_role_copies`.

Verification run during integration:

```bash
lake env lean PhysicsSM/StandardModel/FamilyAnomalyAppendTriality.lean
lake build PhysicsSM.StandardModel.FamilyAnomalyAppendTriality
lake env lean PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean
```
