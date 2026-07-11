# Aristotle proof task: determinant-minor finite second quantization

Prove the unchanged theorem stack in
`FiniteCARSecondQuantization/Main.lean`, culminating in
`gamma_create_covariance`.  Start with:

`lake env lean FiniteCARSecondQuantization/Main.lean`

The imported live module already proves the full generic finite CAR algebra.
This target defines the determinant-minor lift `Gamma(U)`.  Prove its empty and
singleton controls, linearity, exact one-particle agreement, number and parity
conservation, then the creation covariance identity by finite Laplace/cofactor
expansion.  Small helper lemmas are encouraged.  Do not weaken a theorem,
specialize the generic mode type, replace determinants by a toy definition, or
use compiler-trust shortcuts.  If the covariance statement has a sign or index
error, return an exact finite counterexample and the corrected statement rather
than silently changing it.

Acceptance requires all proof holes closed and the target command passing.
Return the target immediately if broad package verification is slow.

```yaml
aristotle:
  project_id: b605f8b8-a75d-46b5-92b8-62fc57e82d79
  task_id: 7c42059e-416a-4de6-96e0-49ff3dada5a2
  target_file: FiniteCARSecondQuantization/Main.lean
  expected_module: FiniteCARSecondQuantization.Main
  submission_project: AgentTasks/aristotle-submit/finite-car-second-quantization-20260710-project
  output_dir: AgentTasks/aristotle-output/b605f8b8-a75d-46b5-92b8-62fc57e82d79
  status: submitted
```

## Live checkpoint

At 2026-07-10 16:58 PDT a noninterrupting snapshot showed that the empty minor,
vacuum, singleton minor, linearity, exact one-particle agreement, number, and
parity theorems were complete.  They were independently checked and harvested
into `PhysicsSM/Draft/NullEdge/FiniteCARSecondQuantization.lean`.  The running
task remains active on ordered-enumeration, Laplace/cofactor, repeated-column,
and `gamma_create_covariance` lemmas; it was not canceled or redirected.
