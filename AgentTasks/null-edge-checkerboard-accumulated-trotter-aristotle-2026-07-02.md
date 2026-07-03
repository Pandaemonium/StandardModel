# Null-edge checkerboard accumulated Trotter Aristotle job

Date: 2026-07-02
Status: integrated.

## Purpose

Ask Aristotle to prove the next accumulated checkerboard-to-Dirac stability
layer. Codex has integrated the one-step finite and continuum bridges, proved
finite-product unitarity, proved the continuum-step power identity, and added
concrete finite stability wrappers. The remaining high-value work is choosing
uniform/eventual factor bounds and assembling the pointwise fixed-time Trotter
estimate.

## Submission packet

- Prompt:
  `AgentTasks/aristotle-prompts/null-edge-checkerboard-accumulated-trotter-20260702.prompt.md`
- Expected focused package:
  `AgentTasks/aristotle-submit/null-edge-checkerboard-accumulated-trotter-20260702-project`
- Source root:
  `NullEdgeStandalone`
- Target file:
  `PhysicsSM/Draft/CheckerboardDiracScaling.lean`

## Context-pack preflight

Attempted to refresh the Neo4j-backed doc index and create a semantic context
pack on 2026-07-02, but the local Neo4j service at `127.0.0.1:7687` refused the
connection. The Aristotle prompt is therefore self-contained and points to the
exact checked target file.

## Aristotle metadata

```yaml
aristotle:
  project_id: 130705c7-9455-41d1-92fc-c7360a411bf0
  task_id: 025b5006-6120-41c6-8044-a735de39e3ae
  target_file: PhysicsSM/Draft/CheckerboardDiracScaling.lean
  expected_module: PhysicsSM
  submission_project: AgentTasks/aristotle-submit/null-edge-checkerboard-accumulated-trotter-20260702-project
  output_dir: AgentTasks/aristotle-output/130705c7-9455-41d1-92fc-c7360a411bf0
  status: submitted
```

## Preflight

Local work before submission:

- integrated Aristotle exponential-bridge, L-infinity, and L2/unitarity jobs;
- added `momentumEvolution_mem_unitaryGroup` and
  `l2OpNorm_momentumEvolution`;
- added `continuumStepSymbol_pow_eq_diracEvolutionSymbol`;
- added `linftyOpNorm_momentumEvolution_sub_continuumPow_le` and
  `linftyOpNorm_momentumEvolution_sub_diracEvolution_le`;
- added `linftyOpNorm_exp_le` and
  `linftyOpNorm_continuumStepSymbol_le_exp`;
- recorded cycle-09 literature notes.

## Package smoke test

The live standalone target was checked with:

```text
lake env lean PhysicsSM/Draft/CheckerboardDiracScaling.lean
```

The clean submission copy was also probed, but because it has no local `.lake`
cache it began rebuilding Mathlib from scratch. That check was stopped after it
timed out; no target-file Lean error was observed in the live standalone check.

## Submission result

Submitted on 2026-07-02.

```text
Project created: 130705c7-9455-41d1-92fc-c7360a411bf0
Task: 025b5006-6120-41c6-8044-a735de39e3ae
Initial status: QUEUED
```

The Aristotle CLI warned that the focused package has no `.lake` folder. This
is intentional for the slim standalone package; it includes Lake metadata and
Lean source but not the local dependency cache.

## Running-task update

After submission, Codex proved `linftyOpNorm_nullShiftSymbol_le_one` locally.
An Aristotle `continue --mode instruct` update was sent on 2026-07-02 asking the
running job to focus remaining effort on the isotropic mass-step/raw-step
L-infinity factor bounds and accumulated fixed-time Trotter assembly.

## Integration result

Integrated on 2026-07-03 into
`NullEdgeStandalone/PhysicsSM/Draft/CheckerboardDiracScaling.lean`.

Kernel-checked results incorporated:

- `linftyOpNorm_nullShiftSymbol_eq_one`
- `linftyOpNorm_isotropicStep_eq`
- `linftyOpNorm_momentumStepSymbolRaw_le_exp`
- `linftyOpNorm_momentumEvolution_sub_diracEvolution_exp_bound`
- `exists_eventually_stepDiscrepancy_le`
- `linftyOpNorm_momentumEvolution_sub_diracEvolution_tendsto_zero`

Verification:

```text
lake env lean ..\AgentTasks\aristotle-output\130705c7-9455-41d1-92fc-c7360a411bf0\extracted\project-files.tar\null-edge-checkerboard-accumulated-trotter-20260702-project_aristotle\PhysicsSM\Draft\CheckerboardDiracScaling.lean
lake env lean PhysicsSM\Draft\CheckerboardDiracScaling.lean
lake build PhysicsSM.Draft.CheckerboardDiracScaling
lake env lean PhysicsSM.lean
lake build NullEdgeStandalone
```

Placeholder/escape-hatch scan was clean. Dependency audit for
`linftyOpNorm_momentumStepSymbolRaw_le_exp`,
`linftyOpNorm_momentumEvolution_sub_diracEvolution_exp_bound`,
`exists_eventually_stepDiscrepancy_le`, and
`linftyOpNorm_momentumEvolution_sub_diracEvolution_tendsto_zero` reported
`[propext, Classical.choice, Quot.sound]`.

Post-integration note: `lake build NullEdgeStandalone` does not rebuild this
module because the default root does not import `CheckerboardDiracScaling`; use
`lake build PhysicsSM.Draft.CheckerboardDiracScaling` for this target.

## Codex follow-up: matrixL1 boundary theorem

After integrating the Aristotle return, Codex added the finite two-row norm
bridge

```text
matrixL1Norm_le_two_mul_linftyOpNorm
```

and used it to promote the previously commented boundary into the proved theorem

```text
checkerboard_dirac_limit_statement
```

This gives pointwise-in-momentum convergence in the original `matrixL1Norm` to
the continuum Dirac evolution at the matching discrete total time
`(R.data k).totalTime`.

Verification:

```text
lake build PhysicsSM.Draft.CheckerboardDiracScaling
lake env lean PhysicsSM.lean
lake build NullEdgeStandalone
```

Placeholder/escape-hatch scan was clean. Dependency audit for
`matrixL1Norm_le_two_mul_linftyOpNorm` and
`checkerboard_dirac_limit_statement` reported
`[propext, Classical.choice, Quot.sound]`.
