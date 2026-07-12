# Aristotle: changing-cell `R^3` sampling convergence

Prove the concrete cell-center geometry, exact finite-union volume, explicit
global squared-`L2` error estimate, and changing-mesh convergence theorem in
`codex_24h_d_r3_cell_sampling_convergence.lean`. Preserve the actual half-open
cell sampler and the `h / 2` pointwise rate; do not replace them by an abstract
approximation hypothesis.

This is the compactly supported Lipschitz dense-core rung of D-R3-4. The
successor remains extension to arbitrary `L2(R^3)` data and inverse-Fourier
composition with the live Dirac flow. The Neo4j context-pack preflight was
attempted on July 11 and failed because the local service refused port 7687;
the focused package therefore carries the exact prerequisite module and the
run's D-R3 program memo directly.

Harvest verdict: all ten concrete results landed. In the live API, three
provably redundant hypotheses were removed as a strengthening: positivity is
not needed for the coordinate bound once cell membership is given;
Lipschitzness supplies continuity; and the uniform volume inequality supplies
the sign needed by the squeeze. The actual half-open sampler, exact union
volume, support coverage, and `V(Lh/2)^2` global rate are unchanged.

```yaml
aristotle:
  project_id: 6895852f-593b-4ab1-8832-9b1b424d3e20
  task_id: f1b994c8-1b9a-4d2f-b670-3489fe2f3030
  target_file: AgentTasks/aristotle-targets/codex_24h_d_r3_cell_sampling_convergence.lean
  expected_module: PhysicsSM.Draft.NullEdge.ChangingMomentumCellSampling
  submission_project: AgentTasks/aristotle-submit/codex-24h-d-r3-cell-sampling-convergence-20260711-project
  output_dir: AgentTasks/aristotle-output/6895852f-593b-4ab1-8832-9b1b424d3e20
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
