# Aristotle task: P9 stochastic-source guardrail strategy

```yaml
aristotle:
  project_id: e818cb6b-006a-4b7b-9c1c-921d18946413
  target_file: NullEdgeP9StochasticSourceStrategy/Stub.lean
  expected_module: NullEdgeP9StochasticSourceStrategy.Stub
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-stochastic-source-strategy-20260623-project
  output_dir: AgentTasks/aristotle-output/e818cb6b-006a-4b7b-9c1c-921d18946413
  status: integrated
```

Payload docs:

- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `AgentTasks/null-edge-codex-overnight-run-ledger-2026-06-23.md`
- `AgentTasks/null-edge-codex-overnight-six-lane-aristotle-plan-2026-06-23.md`

Goal: use the stochastic-gravity guardrail `PRCWRMFC` to sharpen P9. We now
have finite theorems for mean-zero paired sources and nonzero second moments.
But stochastic gravity treats stress-tensor fluctuations as a noise-kernel
source, so mean-zero is not source invisibility.

Required output:

1. Propose the smallest finite `DiamondNoiseSource` API distinguishing mean
   source, second moment/noise source, boundary-exact source, and observer-
   invisible source.
2. Identify 5-8 Lean theorem targets that prevent the false inference
   "mean-zero means gravitationally invisible".
3. Recommend the next proof-only Aristotle job for P9 after the current
   weighted/fluctuation modules.
4. State which claims should be demoted unless the finite response/noise
   functional is proved.

Completion report requested:

- most important P9 correction:
- best finite definition:
- next theorem package:
- demotion criteria:
