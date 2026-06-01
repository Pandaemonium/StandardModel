# Aristotle task: finite-family anomaly closure by list join

**Agent**: Aristotle
**Status**: Submitted
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `cf9cfcbe-21fd-4c88-bb91-d0c599446943`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-paper-goals-20260531-project`
**Type**: finite-family anomaly theorem for the formalization paper

## Goal

Generalize append closure of anomaly freedom from two lists to any finite list
of multiplet lists, using `List.join`. Then specialize it to arbitrary finite
families of relabeled one-generation tables, including triality-role-indexed
families.

This is a good paper theorem: it separates the algebraic anomaly calculation
from the choice of finite family labels.

## Requested file

Create:

```text
PhysicsSM/StandardModel/FamilyAnomalyListFold.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.StandardModel.FamilyAnomalyAppendTriality
```

Use namespace:

```lean
namespace PhysicsSM.StandardModel.FamilyAnomalyListFold
```

Useful opens:

```lean
open PhysicsSM.StandardModel.AnomalyPackage
open PhysicsSM.StandardModel.FamilyAnomalyNaturality
open PhysicsSM.StandardModel.FamilyRelabeledCopies
open PhysicsSM.StandardModel.FamilyAnomalyAppendTriality
open PhysicsSM.Algebra.Furey
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Current context

Useful existing declarations:

- `LocalAnomalyFree.append`
- `WittenSU2AnomalyFree.append`
- `anomalyFree_append`
- `standardModelOneGeneration_relabel_anomalyFree`
- `trialityRoleRelabeledOneGeneration`
- `TrialityRole`

## Target declarations

First prove empty-list base cases:

```lean
theorem LocalAnomalyFree.nil : LocalAnomalyFree [] := ...

theorem WittenSU2AnomalyFree.nil : WittenSU2AnomalyFree [] := ...

theorem anomalyFree_nil :
    LocalAnomalyFree [] /\ WittenSU2AnomalyFree [] := ...
```

Then prove finite join closure:

```lean
theorem LocalAnomalyFree.join
    {families : List (List ChiralMultiplet)}
    (h : families.Forall LocalAnomalyFree) :
    LocalAnomalyFree families.join := ...

theorem WittenSU2AnomalyFree.join
    {families : List (List ChiralMultiplet)}
    (h : families.Forall WittenSU2AnomalyFree) :
    WittenSU2AnomalyFree families.join := ...

theorem anomalyFree_join
    {families : List (List ChiralMultiplet)}
    (h : families.Forall
      (fun ms => LocalAnomalyFree ms /\ WittenSU2AnomalyFree ms)) :
    LocalAnomalyFree families.join /\
      WittenSU2AnomalyFree families.join := ...
```

Specialize to arbitrary finite relabeled one-generation families:

```lean
def relabeledOneGenerationFamilies
    (labels : List (ChiralMultiplet -> String)) :
    List (List ChiralMultiplet) :=
  labels.map (fun newLabel =>
    relabelMultiplets newLabel standardModelOneGeneration)

theorem relabeledOneGenerationFamilies_join_anomalyFree
    (labels : List (ChiralMultiplet -> String)) :
    LocalAnomalyFree (relabeledOneGenerationFamilies labels).join /\
      WittenSU2AnomalyFree (relabeledOneGenerationFamilies labels).join := ...
```

Specialize again to finite triality-role-indexed families:

```lean
def trialityRoleFamilies
    (roles : List TrialityRole)
    (newLabel : TrialityRole -> ChiralMultiplet -> String) :
    List (List ChiralMultiplet) :=
  roles.map (trialityRoleRelabeledOneGeneration newLabel)

theorem trialityRoleFamilies_join_anomalyFree
    (roles : List TrialityRole)
    (newLabel : TrialityRole -> ChiralMultiplet -> String) :
    LocalAnomalyFree (trialityRoleFamilies roles newLabel).join /\
      WittenSU2AnomalyFree (trialityRoleFamilies roles newLabel).join := ...
```

Package the result:

```lean
structure FamilyAnomalyListFoldPackage where
  finite_relabel_family_anomaly_free :
    forall labels : List (ChiralMultiplet -> String),
      LocalAnomalyFree (relabeledOneGenerationFamilies labels).join /\
        WittenSU2AnomalyFree (relabeledOneGenerationFamilies labels).join
  finite_triality_role_family_anomaly_free :
    forall (roles : List TrialityRole)
      (newLabel : TrialityRole -> ChiralMultiplet -> String),
      LocalAnomalyFree (trialityRoleFamilies roles newLabel).join /\
        WittenSU2AnomalyFree (trialityRoleFamilies roles newLabel).join

theorem familyAnomalyListFoldPackage :
    FamilyAnomalyListFoldPackage := ...
```

## Claim boundary

This is a finite list theorem about anomaly tables and relabeling. It does not
claim that a physical family symmetry exists, and it does not prove the full
Furey-Hughes triality mechanism.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change anomaly definitions or hypercharge conventions.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/StandardModel/FamilyAnomalyListFold.lean
lake build PhysicsSM.StandardModel.FamilyAnomalyListFold
```
