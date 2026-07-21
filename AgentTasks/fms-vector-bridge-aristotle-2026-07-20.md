# Aristotle task: finite FMS custodial-vector bridge

Date: 2026-07-20
Owner: Codex
Work item: `MASS-ORIGIN-001`
Status: integrated

## Objective

Complete the focused theorem suite in
`FMSVectorBridge/FMSVectorBridge.lean`. Preserve every statement unless one is
mathematically false or malformed; in that case return the strongest corrected
statement with an explicit counterexample or exact semantic diagnosis.

The high-value content is the conjunction of:

1. exact simultaneous local-gauge cancellation;
2. the exact leading/mixed/quadratic finite FMS expansion;
3. bijectivity of the leading two-by-two bridge for nonzero vacuum;
4. a noninjective three-to-two representation-mismatch control.

This is finite matrix algebra, not a pole theorem. Do not add physical claims,
new assumptions, or an arbitrary mass parameter.

## Verification

Run first:

```text
lake env lean FMSVectorBridge/FMSVectorBridge.lean
```

Do not spend the proof budget on a broad build.

## Context

- `AgentTasks/context-packs/fms-vector-bridge-20260720-122148.md`
- `AutonomousLab/work/NE-DYNAMICS/CODEX_LITERATURE_FMS_MASS_OBSERVABLES_2026-07-20.md`
- Primary source: Axel Maas, arXiv:2305.01960v2, sections on the FMS mechanism.

```yaml
aristotle:
  project_id: f7a9f5ec-a24b-458a-bc1b-cd1335625919
  task_id: 823b672e-6b4e-447d-83e5-98733e22b5e4
  target_file: FMSVectorBridge.lean
  expected_module: FMSVectorBridge
  submission_project: AgentTasks/aristotle-submit/fms-vector-bridge-20260720-project
  output_dir: AgentTasks/aristotle-output/f7a9f5ec-a24b-458a-bc1b-cd1335625919
  status: integrated
```

## Integration result

Aristotle completed all nine proof holes without changing a theorem statement.
The production integration is
`PhysicsSM/Draft/NullEdge/HiggsFMSVectorObservable.lean`, with project
namespace, primary-source provenance, proposition-level nonzero hypotheses,
and build-enforced axiom guards. The focused return proves finite observable
algebra only; it does not prove perturbative dominance or a physical pole.
