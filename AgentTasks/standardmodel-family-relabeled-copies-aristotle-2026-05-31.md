# Aristotle task: family-relabeled copies anomaly package

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `ff1e2968-a2a0-4baf-ac2c-6100d775605b`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-wave-20260531-project`
**Type**: family-symmetry/anomaly naturality strengthening

## Goal

Prove that any number of relabeled one-generation Standard Model tables remains
anomaly-free. This connects the existing `nCopies` theorem in
`AnomalyPackage` with the relabeling naturality theorem in
`FamilyAnomalyNaturality`.

This is a clean manuscript theorem: family copies that preserve gauge data do
not disturb the already verified anomaly cancellation arithmetic.

## Requested file

Create:

```text
PhysicsSM/StandardModel/FamilyRelabeledCopies.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.StandardModel.AnomalyPackage
import PhysicsSM.StandardModel.FamilyAnomalyNaturality
```

Use namespace:

```lean
namespace PhysicsSM.StandardModel.FamilyRelabeledCopies
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Target declarations

First prove Witten anomaly freedom is preserved by `nCopies`:

```lean
theorem WittenSU2AnomalyFree.nCopies
    (n : Nat) (ms : List ChiralMultiplet)
    (h : WittenSU2AnomalyFree ms) :
    WittenSU2AnomalyFree (nCopies n ms) := ...
```

Then package local plus Witten anomaly freedom for arbitrary copies:

```lean
theorem nCopies_anomalyFree
    (n : Nat) (ms : List ChiralMultiplet)
    (hlocal : LocalAnomalyFree ms)
    (hwitten : WittenSU2AnomalyFree ms) :
    LocalAnomalyFree (nCopies n ms) /\
      WittenSU2AnomalyFree (nCopies n ms) := ...
```

Finally specialize to arbitrary relabelings of the conventional one-generation
table:

```lean
theorem relabeledNCopies_standardModelOneGeneration_anomalyFree
    (n : Nat) (newLabel : ChiralMultiplet -> String) :
    LocalAnomalyFree
        (nCopies n
          (relabelMultiplets newLabel standardModelOneGeneration)) /\
      WittenSU2AnomalyFree
        (nCopies n
          (relabelMultiplets newLabel standardModelOneGeneration)) := ...
```

Add a paper-facing package:

```lean
structure FamilyRelabeledCopiesPackage where
  relabeled_copies_anomaly_free :
    forall (n : Nat) (newLabel : ChiralMultiplet -> String),
      LocalAnomalyFree
          (nCopies n
            (relabelMultiplets newLabel standardModelOneGeneration)) /\
        WittenSU2AnomalyFree
          (nCopies n
            (relabelMultiplets newLabel standardModelOneGeneration))

theorem familyRelabeledCopiesPackage :
    FamilyRelabeledCopiesPackage := ...
```

Useful existing declarations:

- `nCopies_localAnomalyFree`
- `weakDoubletCount_nCopies`
- `standardModelOneGeneration_relabel_anomalyFree`

## Claim boundary

This proves a finite table/anomaly theorem. It does not prove that a particular
family symmetry is physically realized and does not derive the Standard Model.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Keep the theorem about finite lists of `ChiralMultiplet`s.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/StandardModel/FamilyRelabeledCopies.lean
lake build PhysicsSM.StandardModel.FamilyRelabeledCopies
```

## Integration result

**Completed**: 2026-05-31
**Result bundle**: `AgentTasks/aristotle-output/standardmodel-family-relabeled-copies-20260531-result`
**Extracted project**: `AgentTasks/aristotle-output/standardmodel-family-relabeled-copies-20260531-extracted/octonion-sm-next-wave-20260531-project_aristotle`
**Integrated file**: `PhysicsSM/StandardModel/FamilyRelabeledCopies.lean`
**Root import**: `PhysicsSM.StandardModel.FamilyRelabeledCopies`

Aristotle proved that anomaly freedom is preserved by any number of relabeled
copies of the one-generation table. This stays at the finite table/anomaly
layer and does not assert a physical family-symmetry mechanism.

Verification run during integration:

```bash
lake env lean PhysicsSM/StandardModel/FamilyRelabeledCopies.lean
lake build PhysicsSM.StandardModel.FamilyRelabeledCopies
```
