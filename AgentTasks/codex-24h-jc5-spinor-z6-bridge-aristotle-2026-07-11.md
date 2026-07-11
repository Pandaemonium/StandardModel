# Aristotle proof job: five-mode hypercharge to finite and gauge Z6 kernels

Name this project `codex-24h-jc5-spinor-z6-bridge-20260711`.

Run first:

```text
lake env lean AgentTasks/aristotle-targets/codex_24h_jc5_spinor_z6_bridge.lean
```

Close all three proof holes without changing public statements. The first
theorem is the mathematical core: for every subset of the five Fock indices,
prove that the explicit sum of index weights equals
`3 * weakCount - 2 * colorCount`, expressed as `centralPhase 0 0 1`.

Then compose with `SpinorFockHypercharge.hypercharge6_matches` for even states.
The final theorem deliberately proves only a cardinality alignment between
the finite bidegree kernel and the existing gauge-cover kernel package; do not
turn it into an equality of unrelated types.

Required semantic checks:

- weak indices are `{3,4}` and color indices are `{0,1,2}`;
- the all-left table and GUT sixth-units convention are preserved;
- `centralPhase` takes weak degree first and color degree second;
- no claim is made that the Jordan flag derives the split;
- no claim is made that a cardinality alignment transports the group action.

Small helper lemmas about membership in the two index finsets are allowed.
Do not use compiled evaluation. Return all solved declarations, any statement
problem, the axiom footprint, and the exact command run.

```yaml
aristotle:
  project_id: 14528672-95da-4707-9ef2-d814a587c9ce
  task_id: pending
  target_file: AgentTasks/aristotle-targets/codex_24h_jc5_spinor_z6_bridge.lean
  expected_module: none-handoff
  submission_project: AgentTasks/aristotle-submit/codex-24h-jc5-spinor-z6-bridge-20260711-project
  output_dir: AgentTasks/aristotle-output/14528672-95da-4707-9ef2-d814a587c9ce
  status: submitted
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
