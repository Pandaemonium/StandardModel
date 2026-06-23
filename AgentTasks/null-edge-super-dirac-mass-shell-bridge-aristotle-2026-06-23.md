# Aristotle task: super-Dirac mass-shell bridge

Date: 2026-06-23

## Goal

Fill the proof holes in the standalone Lean file:

```text
NullEdgeSuperDiracMassShellBridge/Core.lean
```

This proves the finite no-double-count bridge: the kinetic Pluecker symbol and
the Yukawa square are equated on shell, not added as separate mass terms.

## Instructions for Aristotle

- Keep the theorem statements semantically unchanged.
- You may add small helper lemmas if useful.
- Do not add new assumptions unless clearly explained.
- Run the narrow command first:

```text
lake env lean NullEdgeSuperDiracMassShellBridge/Core.lean
```

## Metadata

```yaml
aristotle:
  project_id: 1de5924b-07e9-4052-bc88-161e881d896b
  task_id: cbcc71ba-d156-477c-8fd5-5f1ee0777adf
  target_file: NullEdgeSuperDiracMassShellBridge/Core.lean
  expected_module: NullEdgeSuperDiracMassShellBridge.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-super-dirac-mass-shell-bridge-20260623-project
  output_dir: AgentTasks/aristotle-output/1de5924b-07e9-4052-bc88-161e881d896b
  status: submitted
```
