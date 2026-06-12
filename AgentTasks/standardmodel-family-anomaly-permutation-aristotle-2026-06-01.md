# Aristotle task: family anomaly invariance under list permutation

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `c27c87aa-0be2-4e4b-a51f-54e24d235a13`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave3-20260601-project`
**Output**: `AgentTasks/aristotle-output/standardmodel-family-anomaly-permutation-20260601`
**Integrated**: 2026-06-01
**Type**: Family/anomaly naturality polish

## Goal

Prove that the anomaly coefficients and anomaly-freedom predicates are
invariant under permutation of a multiplet list. This complements the existing
append/list-fold family results by showing that the order of family copies is
irrelevant.

## Requested file

Create:

```text
PhysicsSM/StandardModel/FamilyAnomalyPermutation.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.StandardModel.FamilyAnomalyListFold
```

Use namespace:

```lean
namespace PhysicsSM.StandardModel.FamilyAnomalyPermutation
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

From `AnomalyPackage` and family modules:

- `ChiralMultiplet`
- `gravitationalU1Anomaly`
- `u1CubedAnomaly`
- `su2SquaredU1Anomaly`
- `su3SquaredU1Anomaly`
- `su3CubedAnomaly`
- `weakDoubletCount`
- `LocalAnomalyFree`
- `WittenSU2AnomalyFree`
- `FamilyAnomalyListFold.anomalyFree_join`

Useful Mathlib/List API is likely:

- `List.Perm.map`
- `List.Perm.sum_eq`
- `List.Perm.length_eq`
- related `List.Perm` lemmas.

## Target declarations

For list permutations:

```lean
theorem gravitationalU1Anomaly_perm
    {xs ys : List ChiralMultiplet}
    (h : xs.Perm ys) :
    gravitationalU1Anomaly xs = gravitationalU1Anomaly ys := ...

theorem u1CubedAnomaly_perm
    {xs ys : List ChiralMultiplet}
    (h : xs.Perm ys) :
    u1CubedAnomaly xs = u1CubedAnomaly ys := ...

theorem su2SquaredU1Anomaly_perm
    {xs ys : List ChiralMultiplet}
    (h : xs.Perm ys) :
    su2SquaredU1Anomaly xs = su2SquaredU1Anomaly ys := ...

theorem su3SquaredU1Anomaly_perm
    {xs ys : List ChiralMultiplet}
    (h : xs.Perm ys) :
    su3SquaredU1Anomaly xs = su3SquaredU1Anomaly ys := ...

theorem su3CubedAnomaly_perm
    {xs ys : List ChiralMultiplet}
    (h : xs.Perm ys) :
    su3CubedAnomaly xs = su3CubedAnomaly ys := ...

theorem weakDoubletCount_perm
    {xs ys : List ChiralMultiplet}
    (h : xs.Perm ys) :
    weakDoubletCount xs = weakDoubletCount ys := ...
```

Predicate-level versions:

```lean
theorem LocalAnomalyFree.perm
    {xs ys : List ChiralMultiplet}
    (hperm : xs.Perm ys)
    (hxs : LocalAnomalyFree xs) :
    LocalAnomalyFree ys := ...

theorem WittenSU2AnomalyFree.perm
    {xs ys : List ChiralMultiplet}
    (hperm : xs.Perm ys)
    (hxs : WittenSU2AnomalyFree xs) :
    WittenSU2AnomalyFree ys := ...

theorem anomalyFree_perm
    {xs ys : List ChiralMultiplet}
    (hperm : xs.Perm ys)
    (hxs : LocalAnomalyFree xs ∧ WittenSU2AnomalyFree xs) :
    LocalAnomalyFree ys ∧ WittenSU2AnomalyFree ys := ...
```

Optional family-facing lemma, if straightforward:

```lean
theorem trialityRoleFamilies_join_anomalyFree_perm
    {roles roles' : List TrialityRole}
    (hperm : roles.Perm roles')
    (newLabel : TrialityRole -> ChiralMultiplet -> String) :
    LocalAnomalyFree
      (FamilyAnomalyListFold.trialityRoleFamilies roles' newLabel).flatten ∧
    WittenSU2AnomalyFree
      (FamilyAnomalyListFold.trialityRoleFamilies roles' newLabel).flatten := ...
```

The optional lemma may simply reuse
`FamilyAnomalyListFold.trialityRoleFamilies_join_anomalyFree`; do not spend a
large amount of time if the namespace/import setup is annoying.

Package:

```lean
structure FamilyAnomalyPermutationPackage where
  anomaly_free_perm :
    forall {xs ys : List ChiralMultiplet},
      xs.Perm ys ->
      LocalAnomalyFree xs ∧ WittenSU2AnomalyFree xs ->
      LocalAnomalyFree ys ∧ WittenSU2AnomalyFree ys

theorem familyAnomalyPermutationPackage :
    FamilyAnomalyPermutationPackage := ...
```

## Claim boundary

This proves finite list/order invariance for anomaly arithmetic. It does not
claim a physical family symmetry, a new anomaly-cancellation mechanism, or a
derivation of the Standard Model.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change definitions in `AnomalyPackage`.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/StandardModel/FamilyAnomalyPermutation.lean
lake build PhysicsSM.StandardModel.FamilyAnomalyPermutation
```
