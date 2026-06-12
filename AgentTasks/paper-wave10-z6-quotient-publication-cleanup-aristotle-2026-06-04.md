# Aristotle task: publication cleanup for Z6 quotient equivalence

Date: 2026-06-04

## Goal

Make the newly repaired unit-level Standard Model Z6 quotient equivalence
publication-clean without changing its mathematical content.

Target file:

```text
PhysicsSM/Gauge/StandardModelUnitZ6SMBlockEquiv.lean
```

Context:

Job `c58fe468-721a-440f-9c24-39b3f6cecf7c` repaired this file so it builds.
The proof is kernel-checked, but the file has many linter warnings, generated
tactic style, a missing explanatory comment for a heartbeat bump, and a
weakened module docstring compared to the original.

## Preferred outcome

Keep the same public declarations:

```lean
SMCoveringTriple.instGroup
SMCoveringQuotient
smCoveringQuotientToSMBlockUnits
smCoveringQuotientToSMBlockUnits_injective
smCoveringQuotientToSMBlockUnits_surjective
smCoveringQuotientMulEquivSMBlockUnits
standardModelUnitZ6SMBlockEquivPackage
```

Then:

1. Restore or improve the module docstring and claim boundary.
2. Add a real comment explaining any required `set_option maxHeartbeats`.
3. Remove avoidable unused simp arguments and long-line warnings in the target
   file.
4. Replace fragile generated proof fragments with readable helper lemmas where
   possible.
5. Preserve all theorem statements and names.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the Z6 quotient convention.
- Do not replace this theorem with the true-product quotient theorem; both are
  useful and should coexist.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelUnitZ6SMBlockEquiv.lean
lake build PhysicsSM.Gauge.StandardModelUnitZ6SMBlockEquiv
```

## Submission

Status: submitted.

Submission project: `AgentTasks/aristotle-submit/paper-wave10-20260604`

Canceled first attempt: `60219a2c-a51d-4b3f-abb7-6813760f049f`

Active job ID: `4eab911e-9f42-4209-a2f4-298c132f8264`
