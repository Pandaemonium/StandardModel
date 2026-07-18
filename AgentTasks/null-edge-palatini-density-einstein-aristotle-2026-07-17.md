# Aristotle job: Palatini density to scalar curvature

Date: 2026-07-17
Work item: `GR-PALATINI-COFRAME-002`

```yaml
aristotle:
  project_id: 269e0a3d-92bd-43ed-a035-114f52732c82
  task_id: cb93bd3c-4838-45a0-adf9-a65adde5c4fe
  target_file: PalatiniDensityEinstein/Target.lean
  expected_module: PalatiniDensityEinstein.Target
  submission_project: AgentTasks/aristotle-submit/null-edge-palatini-density-einstein-20260717-project
  output_dir: AgentTasks/aristotle-output/269e0a3d-92bd-43ed-a035-114f52732c82
  status: complete_harvested_audit_only
```

## Target

Prove the exact four-dimensional tetrad identity equating the repository's
ordered complementary Palatini density to minus the oriented coframe
determinant times the inverse-coframe scalar-curvature contraction.

This is the normalization-sensitive algebraic bridge needed to compose the
new ordinary coframe derivative of the concrete nonlinear holonomy action
with the existing finite Palatini-to-Einstein variation theorem.

## Convention lock

- coframe and inverse indices use order `(0,1,2,3)`;
- ordered bivector coordinates are `(12,13,23,01,02,03)`;
- internal metric signs are `(+,+,+,-,-,-)`;
- spacetime orientation is `0123`;
- curvature is antisymmetric in ordered spacetime faces;
- the final density identity carries the project's explicit overall minus
  sign.

## Inputs

- `AgentTasks/aristotle-standalone/null-edge-palatini-density-einstein-20260717/PalatiniDensityEinstein/Target.lean`
- `AgentTasks/aristotle-standalone/null-edge-palatini-density-einstein-20260717/ARISTOTLE_PROMPT.md`
- `AgentTasks/context-packs/null-edge-palatini-density-einstein-20260717-20260717-225711.md`
- `PhysicsSM/Draft/NullEdge/LorentzCoframePalatiniFace.lean`
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCoframeVariation.lean`
- `PhysicsSM/Draft/NullEdge/FinitePalatiniEinsteinHilbertVariation.lean`

## Preflight

The focused target passes under the pinned toolchain with exactly one intended
proof-hole warning and no other diagnostics:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-palatini-density-einstein-20260717/PalatiniDensityEinstein/Target.lean
```

An exact-rational nondiagonal determinant-one witness gives Palatini density
`-116` and scalar contraction `116`, fixing the target's sign and factor before
submission. This oracle check is not trusted as a proof.

## Submission

Submitted on 2026-07-17 as project
`269e0a3d-92bd-43ed-a035-114f52732c82`, task
`cb93bd3c-4838-45a0-adf9-a65adde5c4fe`. Initial status: `QUEUED`.
The focused-package missing-cache warning is expected; the package contains
only Mathlib plus copied definitions and the narrow target is the first
requested command.

The task entered `IN_PROGRESS` after the local coframe-variation and exact
curvature-extraction successors had both passed targeted Lean builds.

On 2026-07-18, an `ask` status query was sent after the task had run for more
than one hour. The local command timed out without a response. The latest
downloadable snapshot had nevertheless solved the headline density theorem
conditional on a newly isolated `alternating_coframe_two_minor` lemma. That
lemma was split into minimal parallel project
`3e802ea4-9a1a-4f14-ba74-f1d6a3d93b51` without canceling this task.

A subsequent instruction supplied the same determinant-multiplication route
to this task: retain the two inverse rows, replace the complementary rows by
oriented standard basis rows, and expand `det(A * coframe)` in two ways. This
kept the helper and headline statements unchanged.

## Harvest and audit

The task completed and was harvested with the conservative integration helper
to
`AgentTasks/aristotle-output/269e0a3d-92bd-43ed-a035-114f52732c82/`.
Its candidate contains no forbidden executable Lean tokens and passes:

```text
lake env lean AgentTasks/aristotle-output/269e0a3d-92bd-43ed-a035-114f52732c82/extracted/project-files.tar/null-edge-palatini-density-einstein-20260717-project_aristotle/PalatiniDensityEinstein/Target.lean
```

The output independently confirms the project sign and determinant
normalization. It proves the headline by sixteen explicit cofactor cases and
then a finite expansion. It is not integrated into live source because the
existing theorem `alternating_coframe_two_minor` is shorter and stronger: the
live determinant identity requires only a left inverse and no curvature-face
antisymmetry, whereas the returned target retains a right-inverse and an
unused antisymmetry hypothesis. The result is therefore retained as a
kernel-checked audit artifact, not as the production proof.
