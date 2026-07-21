# Aristotle task: quantitative selected-sector leakage

Date: 2026-07-21
Owner: Codex
Work item: `QCA-3PLUS1-001`
Status: integrated

## Objective

Prove that one-step selected-sector commutator error accumulates at most
linearly under repeated contractive evolution, and that exponential suppression
with linearly increasing range beats that accumulation.

## Literature motivation

Brun and Mlodinow, arXiv:2503.05998, find a locality/positive-energy tension in
an interacting QCA and suppress unwanted-sector production exponentially by
increasing a finite interaction range. The full source pass is in
`AutonomousLab/work/NE-3PLUS1/CODEX_LITERATURE_INTERACTION_SECTOR_LEAKAGE_2026-07-21.md`.

## Claim boundary

This theorem consumes a commutator-error estimate; it does not derive that
estimate for HNU, select a physical projector, or prove interacting QFT.

Semantic context:
`AgentTasks/context-packs/sector-leakage-telescope-20260721-20260721-050439.md`.

```yaml
aristotle:
  project_id: 8bffcfa2-68af-4570-a536-3acdf0536db4
  task_id: 9f9f178f-cad2-4204-9c32-ccac8357d476
  target_file: SectorLeakageTelescope.lean
  expected_module: Mathlib-only normed-ring leakage theorem
  submission_project: AgentTasks/aristotle-submit/sector-leakage-telescope-20260721-project
  output_dir: AgentTasks/aristotle-output/8bffcfa2-68af-4570-a536-3acdf0536db4
  status: integrated
```

## Harvest and verification

Aristotle returned every theorem with unchanged statements and no proof holes.
The result was independently rechecked, integrated as
`PhysicsSM/Draft/NullEdge/SectorLeakageTelescope.lean`, root-imported through a
build-enforced axiom guard, and verified under the pinned toolchain. The exact
scope remains abstract: the HNU physical projector and its one-step interaction
commutator bound are still inputs to be derived.
