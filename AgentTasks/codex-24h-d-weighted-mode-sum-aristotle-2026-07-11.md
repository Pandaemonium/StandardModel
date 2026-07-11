# Aristotle proof job: weighted countable aggregate after the growing-window bound

Name this project `codex-24h-d-weighted-mode-sum-20260711`.

Run first:

```text
lake env lean AgentTasks/aristotle-targets/codex_24h_d_weighted_mode_sum.lean
```

Close the single proof hole without changing the statement. The intended proof
uses Tannery dominated convergence. From `hr`, obtain an eventual bound
`r n <= 1`; combine it with `hdom` and nonnegativity of the Sobolev envelope
to obtain eventual domination by the fixed summable envelope `hSob`. Derive
pointwise convergence of squared norms from `hpoint`, then apply
`tendsto_tsum_of_dominated_convergence`.

Do not add a global `r n <= 1` hypothesis merely to simplify the proof. Do not
replace countable summation with a finite sum. Small helper lemmas are allowed.

Required boundary:

- this is coefficient-space `l2` aggregation only;
- it does not supply the walk-specific `hpoint` or `hdom` hypotheses;
- it does not construct Shannon sampling/interpolation;
- it does not identify the multiplier with the position-space Dirac PDE.

The nonvacuous controls for eventual composition are
`Compact3Plus1GrowingWindowRate.quartic_window_nonzero_control` and
`SobolevTailRate.boundary_delta_weight_control`; do not claim they instantiate
this theorem without the missing mode-indexed walk bridge.

```yaml
aristotle:
  project_id: 37c30afc-8b04-4eb5-b1da-ebe7b195a675
  task_id: pending
  target_file: AgentTasks/aristotle-targets/codex_24h_d_weighted_mode_sum.lean
  expected_module: none-handoff
  submission_project: AgentTasks/aristotle-submit/codex-24h-d-weighted-mode-sum-20260711-project
  output_dir: AgentTasks/aristotle-output/37c30afc-8b04-4eb5-b1da-ebe7b195a675
  status: submitted
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
