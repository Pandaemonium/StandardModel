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
  project_id: pending
  task_id: pending
  target_file: AgentTasks/aristotle-standalone/finite-fourier-analytic-sign-20260710/FiniteFourierAnalyticSign/Core.lean
  expected_module: FiniteFourierAnalyticSign.Core
  submission_project: pending
  output_dir: pending
  status: prepared
```
