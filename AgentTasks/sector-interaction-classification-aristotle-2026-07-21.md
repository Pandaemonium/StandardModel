# Aristotle task: interaction-sector preservation classification

Date: 2026-07-21
Owner: Codex
Work item: `QCA-3PLUS1-001`
Status: integrated from the completed Aristotle return

## Objective

Classify exactly when a finite interaction Hamiltonian preserves a declared
selected/complement split, lift the condition to the exact time exponential,
and retain a nonzero Pluecker pair-transfer counterexample.

## Claim boundary

This is a finite algebraic criterion. It does not select the HNU physical
sector, prove interaction positivity/locality, or establish an interacting
continuum limit.

Semantic context:
`AgentTasks/context-packs/sector-interaction-classification-20260721-20260721-045941.md`.

```yaml
aristotle:
  project_id: 4dfca880-8f38-4917-9ebb-2c3cc93358f1
  task_id: 7801b281-1672-428e-a30f-84b8b4b7f9e2
  target_file: PhysicsSM/Draft/NullEdge/SectorInteractionClassification.lean
  expected_module: Mathlib-only finite matrix classification
  submission_project: AgentTasks/aristotle-submit/sector-interaction-classification-20260721-project
  output_dir: AgentTasks/aristotle-output/4dfca880-8f38-4917-9ebb-2c3cc93358f1
  status: integrated
```

## Landed result

For an arbitrary finite coordinate sector, the return proves that a matrix
Hamiltonian commutes with the diagonal sector projector exactly when every
selected/complement cross entry vanishes in both directions. The exact matrix
exponential then commutes with the projector. In the explicit two-state
Hermitian pair-transfer control, commutation holds exactly when `z = 0`; the
nonzero `3+4i` witness therefore mixes the declared pair sector.

The result is integrated with a build-enforced axiom guard. It classifies exact
sector preservation but does not identify the physical HNU projector or prove
that leakage is small when exact commutation fails.

## Verification

- `lake env lean` on the completed Aristotle return under the pinned root
  environment (passed).
- `lake build PhysicsSM.Draft.NullEdge.SectorInteractionClassificationAxiomGuard`
  (passed, 8027 jobs).
