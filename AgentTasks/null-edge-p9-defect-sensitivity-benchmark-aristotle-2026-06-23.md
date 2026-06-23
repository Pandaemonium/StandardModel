# Aristotle focused job: P9 defect-sensitivity benchmark

```yaml
job_name: null-edge-p9-defect-sensitivity-benchmark-20260623
status: integrated
project_id: aca96818-d575-44e4-97cb-949aa461dfe6
task_id: d899a2a1-0ace-4926-833f-a305b80c22c3
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-defect-sensitivity-benchmark-20260623
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-defect-sensitivity-benchmark-20260623-project
target_module: NullEdgeP9DefectSensitivityBenchmark.Core
target_file: NullEdgeP9DefectSensitivityBenchmark/Core.lean
expected_check: lake env lean NullEdgeP9DefectSensitivityBenchmark/Core.lean
```

## Task

Fill the proof holes in
`NullEdgeP9DefectSensitivityBenchmark/Core.lean` without changing definitions
or theorem statements.

Scientific target: this is the minimal two-triangle P9 defect-sensitivity
benchmark. A common-mode curvature/source perturbation is invisible to the
linearized diamond-defect readout, while a differential perturbation changes
the readout. This is a finite kinematic test object, not a continuum gravity
claim.

## Targets

```lean
defectReadout_add_commonMode
defectReadout_add_differentialMode
defectReadout_eq_zero_iff_equal
defectResponse_nonneg
differentialMode_creates_defect_of_ne_zero
```

## Constraints

- Do not weaken, rename, or restate theorems or definitions.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9DefectSensitivityBenchmark/Core.lean
```

## Completion report requested

Please end with a brief report listing:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.

## Submission note

Local preflight:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-defect-sensitivity-benchmark-20260623/NullEdgeP9DefectSensitivityBenchmark/Core.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" AgentTasks/aristotle-standalone/null-edge-p9-defect-sensitivity-benchmark-20260623/NullEdgeP9DefectSensitivityBenchmark/Core.lean
rg -n "[^\\x00-\\x7F]" AgentTasks/aristotle-standalone/null-edge-p9-defect-sensitivity-benchmark-20260623/NullEdgeP9DefectSensitivityBenchmark/Core.lean
```

The Lean preflight found exactly the five intended proof-hole warnings and no
other errors. Non-ASCII scan was clean.

Prepared focused project:

```text
AgentTasks/aristotle-submit/null-edge-p9-defect-sensitivity-benchmark-20260623-project
```

Submitted as Aristotle project `aca96818-d575-44e4-97cb-949aa461dfe6`, task
`d899a2a1-0ace-4926-833f-a305b80c22c3`.

## Completion and integration

Aristotle completed all five targets with no statement or definition changes,
no remaining proof holes, and no added assumptions or nonstandard constructs.

Integrated live module:

```text
PhysicsSM.Draft.NullEdgeP9DefectSensitivityBenchmark
```

Live verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9DefectSensitivityBenchmark.lean
lake build PhysicsSM.Draft.NullEdgeP9DefectSensitivityBenchmark
lake env lean PhysicsSMDraft.lean
rg -n "^\\s*sorry\\b|^\\s*admit\\b|\\baxiom\\b|\\bopaque\\b|\\bunsafe\\b|\\bnative_decide\\b" PhysicsSM/Draft/NullEdgeP9DefectSensitivityBenchmark.lean
rg -n "[^\\x00-\\x7F]" PhysicsSM/Draft/NullEdgeP9DefectSensitivityBenchmark.lean
```

All targeted checks passed. The first draft-root check raced the targeted build
and failed before the `.olean` existed; rerunning after the targeted build
passed. The live proof removes Aristotle's linter warnings from the final
nonzero-differential-defect theorem and uses ASCII Lean syntax.
