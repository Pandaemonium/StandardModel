# Aristotle task note: Q2 block-matrix shift covariance

```yaml
aristotle:
  project_id: 8e1e11b0-9f24-4384-ada1-ca19de7d7869
  task_id: 2781513b-303a-41e6-95b3-81302a0500f1
  target_file: PhysicsSM/Draft/NullEdge/GateYM/TransferHilbertBlockShift.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.TransferHilbertBlockShift
  submission_project: AgentTasks/aristotle-submit/ym-q2-block-shift-covariance-20260704-project
  output_dir: AgentTasks/aristotle-output/8e1e11b0-9f24-4384-ada1-ca19de7d7869
  status: harvested+integrated
```

## Purpose

Submit the next Q2/Q3 bridge after `TransferHilbertBlock.lean`: an abstract
center-shift covariance theorem for the concrete block matrix
`rpBlockMatrix W`.

Expected theorem shape:

- define a product shift system on `C x A`;
- assume `W a c b` is invariant under simultaneous shifts of `a`, `c`, and
  `b`;
- prove `rpBlockMatrix W` is shift-invariant / commutes with the shift
  matrices;
- derive preservation of `TransferHilbert.rpHilbertSpace (rpBlockMatrix W)`.

## Context Pack

```text
AgentTasks/context-packs/ym-q2-block-shift-covariance-20260704-143656.md
```

## Local State

`TransferHilbertBlock.lean` is integrated and verified.  This job must not
claim a physical transfer matrix, Hamiltonian, continuum Hilbert space, or
spectral gap.

## Submission Record

Prompt:

```text
AgentTasks/aristotle-prompts/ym-q2-block-shift-covariance-20260704.prompt.md
```

Focused package:

```text
AgentTasks/aristotle-submit/ym-q2-block-shift-covariance-20260704-project
```

Package command:

```text
pwsh Scripts/prepare_aristotle_focused_submission.ps1 -JobName ym-q2-block-shift-covariance-20260704 -RootModule PhysicsSM -SourceRoot . -LeanPath PhysicsSM/Draft/NullEdge/GateYM/CenterFluxSector.lean,PhysicsSM/Draft/NullEdge/GateYM/HermitianFromRealQuadraticForm.lean,PhysicsSM/Draft/NullEdge/GateYM/ReflectionPositivityKernel.lean,PhysicsSM/Draft/NullEdge/GateYM/TransferHilbert.lean,PhysicsSM/Draft/NullEdge/GateYM/TransferHilbertBlock.lean -TaskNote AgentTasks/ym-q2-block-shift-covariance-aristotle-2026-07-04.md -ExtraPath AgentTasks/aristotle-prompts/ym-q2-block-shift-covariance-20260704.prompt.md,AgentTasks/context-packs/ym-q2-block-shift-covariance-20260704-143656.md,AgentTasks/ym-q2-transfer-hilbert-block-instantiation-aristotle-2026-07-04.md
```

The package check found no proof placeholders in the included Q2/Q3 files.  It
reported one `a x i o m` token in `HermitianFromRealQuadraticForm.lean`; that is
pre-existing prose/scanner text in the dependency, not a new declaration from
this submission.

A local package build attempt timed out while compiling dependencies in the
fresh focused package.  The package was regenerated afterward to remove the
temporary `.lake` state before submission.  The included live repo modules had
already passed the integration checks recorded in the Q2 block-instantiation
harvest note.

Submission:

```text
Project created: 8e1e11b0-9f24-4384-ada1-ca19de7d7869
Task: 2781513b-303a-41e6-95b3-81302a0500f1
Project status after submit: RUNNING
```

## Harvest / Integration

Aristotle returned COMPLETE and supplied
`PhysicsSM/Draft/NullEdge/GateYM/TransferHilbertBlockShift.lean`.

Integrated declarations:

- `blockShiftSystem`
- `blockShiftSystem_shiftConfig`
- `BlockWeightInvariantUnderShifts`
- `rpBlockMatrix_kernelInvariantUnderBlockShifts`
- `rpBlockMatrix_commutes_blockShifts`
- `shiftOp_preserves_rpHilbertSpace_rpBlockMatrix`

Semantic review: accepted.  The file proves exactly the requested abstract
Q2/Q3 bridge: simultaneous invariance of a block weight `W a c b` under cut
and positive/mirror shifts implies `rpBlockMatrix W` is invariant/commutes
with product block shifts, hence the corresponding shift operators preserve
`rpHilbertSpace (rpBlockMatrix W)`.  It does not claim a physical transfer
matrix, Hamiltonian, concrete torus/Z2 Wilson-transfer invariance, or spectral
gap.

Local verification:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/TransferHilbertBlockShift.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.TransferHilbertBlockShift
lake env lean PhysicsSM/Draft/NullEdge/GateYM.lean
lake build PhysicsSM.Draft.NullEdge.GateYM
```

The direct check, targeted build, aggregator check, and aggregate GateYM build
all passed.  The aggregate build reported only existing warnings and the known
Q6 draft proof placeholders in `PolymerKPConclusion.lean`.

Placeholder/escape-hatch scan on `TransferHilbertBlockShift.lean`: no hits.

Axiom audit:

```text
rpBlockMatrix_kernelInvariantUnderBlockShifts:
  [propext, Classical.choice, Quot.sound]
rpBlockMatrix_commutes_blockShifts:
  [propext, Classical.choice, Quot.sound]
shiftOp_preserves_rpHilbertSpace_rpBlockMatrix:
  [propext, Classical.choice, Quot.sound]
```
