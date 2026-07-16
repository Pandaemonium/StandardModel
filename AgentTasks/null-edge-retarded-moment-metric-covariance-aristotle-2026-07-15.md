# Retarded-moment metric covariance: Aristotle proof task

```yaml
aristotle:
  project_id: ffa543b4-ffa1-4dac-bb12-da77ac2bc68d
  task_id: 8efabf4b-dabc-47f2-a927-958063d73e7c
  target_file: PhysicsSM/Draft/NullEdge/RetardedMomentMetricDebias.lean
  expected_module: PhysicsSM.Draft.NullEdge.RetardedMomentMetricDebias
  submission_project: AgentTasks/aristotle-submit/retarded-moment-metric-covariance-20260715-project
  output_dir: AgentTasks/aristotle-output/ffa543b4-ffa1-4dac-bb12-da77ac2bc68d
  status: integrated
```

## Objective

Prove the exact affine-probe covariance algebra behind numerical Stages A29 and
A30 without changing any theorem statement or multiplication/transpose order.

## Locked interpretation

- Moments are column matrices and transform as `m -> A * m`.
- Contravariant inverse metrics transform as `G -> A * G * A^T`.
- Covariant metrics transform with the supplied inverse as
  `g -> AInv^T * g * AInv`.
- The hypothesis `AInv * A = 1` is the precise order needed by the moment-norm
  theorem.
- `q` and `dq` are scalar norm data; their derivation from an inverse metric and
  first jet is outside this focused target.
- The results are conditional finite matrix identities. They do not derive a
  metric, moment, response weight, chart, or continuum limit from a graph.
- Preserve the nonidentity rational witness; do not replace it with a trivial
  zero or identity case.

## Required work

1. Run only
   `lake env lean RetardedMomentMetricCovariance/Basic.lean` first.
2. Replace every executable proof hole with a kernel-checked proof.
3. Preserve all six public theorem statements exactly.
4. Avoid compiled evaluation in the rational witness; use a kernel-checked
   component calculation.
5. Report the exact dependency footprint and every remaining conditional geometric
   input.

## Intended live integration

After semantic review, the result will become
`PhysicsSM/Draft/NullEdge/RetardedMomentMetricDebias.lean` with a dependency
guard.

## Submission log

- 2026-07-15: the focused package passed
  `lake env lean RetardedMomentMetricCovariance/Basic.lean` with exactly the six
  expected proof-hole warnings.
- 2026-07-15: submitted as project
  `ffa543b4-ffa1-4dac-bb12-da77ac2bc68d`, task
  `8efabf4b-dabc-47f2-a927-958063d73e7c`; initial task state `QUEUED`.
- 2026-07-15: status check after Stage A31 documentation found project
  `RUNNING`, task `IN_PROGRESS`; no result has been integrated.
- 2026-07-15: Aristotle returned all six proof bodies without changing any
  public statement. The nonidentity rational witness uses a kernel-checked
  component calculation. Semantic review confirmed that the metric, moment,
  inverse, response, jets, chart, and continuum interpretation remain supplied.
- 2026-07-15: integrated the reviewed result as
  `PhysicsSM/Draft/NullEdge/RetardedMomentMetricDebias.lean` and added
  `RetardedMomentMetricDebiasAxiomGuard.lean`. The guard pins each theorem to
  `propext`, `Classical.choice`, and `Quot.sound`.
