# Aristotle task: finite Fourier to analytic sign bridge

Prove all six targets in

`FiniteFourierAnalyticSign/Core.lean`.

Preserve the positive-exponential plane-wave convention and the displayed
negative lattice momentum.  The quarter-zone `-i` control is load-bearing:
do not change its sign.  This theorem is the convention bridge between the
kernel-checked finite character block of the live local walk and the analytic
Clifford symbol used by the compact-momentum estimate.

Run `lake env lean FiniteFourierAnalyticSign/Core.lean` first.  Add helper
lemmas as needed.  Report a malformed statement rather than weakening one.

## Metadata

```yaml
aristotle:
  project_id: 9620f01b-c5e6-4006-ac98-093967404821
  task_id: df8b67c2-4a03-4cb4-8fb3-12967918b09b
  target_file: AgentTasks/aristotle-standalone/finite-fourier-analytic-sign-20260710/FiniteFourierAnalyticSign/Core.lean
  expected_module: FiniteFourierAnalyticSign.Core
  submission_project: AgentTasks/aristotle-submit/codex-finite-fourier-analytic-sign-20260710-project
  output_dir: AgentTasks/aristotle-output/9620f01b-c5e6-4006-ac98-093967404821
  status: submitted
```
