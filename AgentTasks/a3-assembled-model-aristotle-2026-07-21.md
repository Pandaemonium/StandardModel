# Aristotle task: one finite model assembling all A3 obligations

Date: 2026-07-21
Owner: Codex
Work item: `MASS-ORIGIN-001`
Status: integrated from a locally verified in-progress return

## Objective

Construct one explicit finite model that simultaneously has a positive-definite
transfer matrix, a simple vacuum and strict first gap, a gauge-invariant
observable, nonzero first-excited overlap, and an exact correlation-mass law.

```yaml
aristotle:
  project_id: 43ae3d92-5b5e-4620-b18f-47085022ffa8
  target_file: PhysicsSM/Draft/NullEdge/CompositeMassBridge.lean
  expected_module: Mathlib-only finite A3 assembled witness
  submission_project: AgentTasks/aristotle-standalone/a3-assembled-model-20260721
  output_dir: AgentTasks/aristotle-output/43ae3d92-5b5e-4620-b18f-47085022ffa8
  status: integrated
```

## Landed result

`CompositeMassBridge.lean` gives one three-state model with
`T = A.transpose * A`, injective `A.mulVec`, strict positive definiteness, a
simple top eigenvalue `9`, first excited eigenvalue `4`, a nonconstant
observable invariant under `(ZMod 3)ˣ`, overlap `6`, and the exact normalized
correlator `6 * (4 / 9)^n`. Its finite correlation mass is `log (9 / 4)`.

The capstone is pinned by
`CompositeMassBridgeAxiomGuard.lean` to Mathlib's standard logical footprint.

## Claim boundary

This closes the finite same-model assembly problem only. The gauge group is the
two-element unit group of `ZMod 3`; this is not an `SU(3)` transfer model,
Wilson action, reflection-positive lattice gauge theory, thermodynamic limit,
or derivation of the QCD mass gap.

## Verification

- `lake env lean` on Aristotle's in-progress snapshot under the pinned root
  environment (passed).
- `lake build PhysicsSM.Draft.NullEdge.CompositeMassBridgeAxiomGuard`
  (passed, 8027 jobs).
