# Aristotle strategy job: decorated carrier quotient after the finite Ward model

Name this project `codex-24h-f-decorated-quotient-strategy-20260711`.

Read these live modules and their imports:

- `PhysicsSM/Draft/NullEdge/Carrier/WardQuotientFactorization.lean`;
- `PhysicsSM/Draft/NullEdge/Carrier/WardAutomorphismQuotient.lean`;
- `PhysicsSM/Draft/NullEdge/Carrier/WardPhysicalCohomology.lean`;
- `PhysicsSM/Draft/NullEdge/ChannelPositiveComplementDisk.lean`;
- `PhysicsSM/Draft/NullEdge/ChannelPositiveSectorModuli.lean`;
- `PhysicsSM/Draft/NullEdge/ChannelRefinementTorsor.lean`;
- `PhysicsSM/Draft/NullEdge/ChannelSelectorDescentNoGo.lean`;
- `AgentTasks/24h-publication-run-2026-07-12/RUN_PLAN.md`, Paper F.

Design the smallest next typechecking theorem that extends the exact finite
Ward quotient to a decorated datum retaining at least one genuinely physical
decoration: locality support, soldering/frame data, grading, gauge action, or
positive-sector choice. The theorem must either:

1. classify the resulting equivalence by explicit invariants, or
2. prove an exact obstruction showing why physical-line compression ceases to
   be complete once that decoration is retained.

Required output:

- exact imports, definitions, and theorem statements;
- explicit equivalence relation and invariant;
- two inequivalent nonzero witnesses and one equivalence control;
- a typechecking Lean scaffold with proof holes only at the genuine new core;
- comparison with finite spectral-triple/Dirac-operator moduli;
- a kill condition preventing a repackaged finite Ward theorem from counting
  as progress.

Do not alter existing modules and do not claim a continuum classification.
Return the design and scaffold even if the positive classification fails.

```yaml
aristotle:
  project_id: 8fe0ab85-f4f2-4fc5-989f-41b91c12693b
  task_id: pending
  target_file: AgentTasks/aristotle-targets/codex_24h_f_decorated_quotient_strategy.lean
  expected_module: none-strategy
  submission_project: AgentTasks/aristotle-submit/codex-24h-f-decorated-quotient-strategy-20260711-project
  output_dir: AgentTasks/aristotle-output/8fe0ab85-f4f2-4fc5-989f-41b91c12693b
  status: submitted
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
