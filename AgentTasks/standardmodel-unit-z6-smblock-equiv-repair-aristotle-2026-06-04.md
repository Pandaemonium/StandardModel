# Aristotle task: repair or isolate StandardModelUnitZ6SMBlockEquiv

Date: 2026-06-04

## Goal

Repair the trusted module:

```text
PhysicsSM/Gauge/StandardModelUnitZ6SMBlockEquiv.lean
```

or, if its older quotient construction is superseded by the true-product
construction, isolate the broken dependency so top-level publication modules
can avoid it.

## Context

The live repository now has a newer true-product quotient result:

```text
PhysicsSM/Gauge/StandardModelProductCoveringTrueQuotientSMBlock.lean
```

The older `StandardModelUnitZ6SMBlockEquiv.lean` still contains the desired
first-isomorphism theorem shape:

```lean
SMCoveringQuotient
smCoveringQuotientToSMBlockUnits
smCoveringQuotientToSMBlockUnits_injective
smCoveringQuotientToSMBlockUnits_surjective
smCoveringQuotientMulEquivSMBlockUnits
```

but it currently does not cleanly build in the live tree.

## Preferred outcome

Make this command pass:

```bash
lake env lean PhysicsSM/Gauge/StandardModelUnitZ6SMBlockEquiv.lean
```

without weakening theorem statements or introducing forbidden constructs.

If the old quotient construction is mathematically or architecturally obsolete,
then make the smallest safe change:

- remove this module from any top-level/publication imports that do not need it,
- add a clear module comment explaining that the trusted replacement is
  `StandardModelProductCoveringTrueQuotientSMBlock`,
- do not delete the file unless necessary.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the Standard Model determinant or quotient convention silently.
- Prefer reusing the true-product quotient results over duplicating a second
  quotient construction if the old file is fundamentally stale.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelUnitZ6SMBlockEquiv.lean
lake env lean PhysicsSM/Gauge/StandardModelProductCoveringTrueQuotientSMBlock.lean
```

## Submission

Status: submitted.

Submission project: `AgentTasks/aristotle-submit/paper-wave9-20260604`

Job ID: `3f463e49-5d98-445b-a064-b6294910eb1d`
