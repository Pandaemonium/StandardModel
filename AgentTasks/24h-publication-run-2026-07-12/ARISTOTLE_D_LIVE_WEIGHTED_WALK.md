# Aristotle target: live weighted 3+1 walk bulk convergence

## Objective

Close both proof holes in
`AgentTasks/aristotle-targets/codex_24h_d_live_weighted_walk.lean` without
changing any statement.

Update: `mode_B4_le_refinementRadius`, `bulkRate`, and
`walkErrorEnvelope_le_bulkRate` are now proved locally. The handoff typechecks
with only the central `walkErrorEnvelope_tendsto_zero` hole. The remaining proof
should instantiate `growingWindow_countableWeightedL2_tendsto_zero` with
`r K = (bulkRate K)^2`, establish `bulkRate K -> 0` from
`tendsto_const_nhds.div_atTop`, and square
`walkErrorEnvelope_le_bulkRate` for domination. A hostile audit showed that
the generic theorem's pointwise hypothesis was redundant, so it has been
removed from the live API; there is no pointwise-convergence bullet to supply.
These helper results and this assembly plan were sent to Aristotle by
`continue --mode instruct`; do not spend remaining effort reproving or changing
the helper lemmas.

The first theorem proves that the schedule
`refinementRadius M N = 3*N + M + 1` dominates the live `B4` norm of every
integer momentum in `modeBox N` when `|m| <= M`.

The second theorem square-sums the actual quartic split-versus-exact matrix
error envelope over the expanding box against an arbitrary square-summable
mode profile and proves convergence to zero. Use the landed
`quartic_window_many_step_bound` and
`growingWindow_countableWeightedL2_tendsto_zero`; prove every rate and
domination obligation explicitly.

## Semantic boundary

- This is the live dynamic coefficient-space bulk theorem.
- It is not a position-space theorem, Fourier-isometry theorem, or final Dirac
  PDE limit.
- Do not replace the live matrix error by an arbitrary supplied error.
- Do not add assumptions beyond the frozen statement.
- Preserve `walkErrorEnvelope_nonzero_fixture` as the finite nontriviality
  control.

## Verification

Run first:

```text
lake env lean AgentTasks/aristotle-targets/codex_24h_d_live_weighted_walk.lean
```

Return the complete target file even if the full project build is slow.

```yaml
aristotle:
  project_id: 216ec89c-a5ec-4b08-b0e5-9a92e78df6a1
  task_id: pending
  target_file: AgentTasks/aristotle-targets/codex_24h_d_live_weighted_walk.lean
  expected_module: none-task-target
  submission_project: AgentTasks/aristotle-submit/codex-24h-d-live-weighted-walk-20260711-project
  output_dir: AgentTasks/aristotle-output/216ec89c-a5ec-4b08-b0e5-9a92e78df6a1
  status: submitted
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
