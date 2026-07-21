# Aristotle task: finite transfer operator to reflection-positive pole

Date: 2026-07-20
Owner: Codex
Work item: `MASS-ORIGIN-001`
Status: integrated and verified

## Objective

Replace positive diagonal spectral weights as primitive finite input by an
actual symmetric transfer operator and observable vector. Prove the exact
orbit-Gram identity, reflected-kernel positivity, eigenmode correlation law,
positive resolvent residue, and the nondegenerate `diag(1,1/2)` control.

## Claim boundary

This is a finite operator theorem. It is not interacting lattice-action
reflection positivity, infinite-volume reconstruction, atom persistence under
a changing-lattice limit, LSZ, or a physical QCD/Higgs pole.

Semantic context pack:
`AgentTasks/context-packs/mass-transfer-operator-reflection-20260720-20260720-233716.md`.

## Verification

```text
lake env lean TransferOperatorReflection/Main.lean
```

Aristotle returned a hole-free proof artifact. The task was reported as
`COMPLETE_WITH_ERRORS` only at the packaging/push stage; the returned target
itself was independently scanned and replayed. It is integrated, with the
claim boundary tightened, as:

`PhysicsSM/Draft/NullEdge/FiniteSelfAdjointTransferReflectionPole.lean`

Local verification:

```text
lake env lean PhysicsSM/Draft/NullEdge/FiniteSelfAdjointTransferReflectionPole.lean
lake build PhysicsSM.Draft.NullEdge.FiniteSelfAdjointTransferReflectionPole
```

Both commands passed. The targeted build completed all 8,026 jobs. The
headline reflected-kernel theorem and the exact two-level control are guarded
to the standard three axioms.

```yaml
aristotle:
  project_id: 51983ddf-7ca0-4881-8127-9fa112822814
  task_id: 80e574fc-7737-421a-95a7-1f00df02f8ad
  target_file: TransferOperatorReflection/Main.lean
  expected_module: TransferOperatorReflection.Main
  submission_project: AgentTasks/aristotle-submit/mass-transfer-operator-reflection-20260720-project
  output_dir: AgentTasks/aristotle-output/51983ddf-7ca0-4881-8127-9fa112822814
  status: integrated
```
