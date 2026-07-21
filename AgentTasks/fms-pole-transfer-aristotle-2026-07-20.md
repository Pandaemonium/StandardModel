# Aristotle task: conditional finite FMS pole transfer

Date: 2026-07-20
Owner: Codex
Work item: `MASS-ORIGIN-001`
Status: integrated

## Objective

Complete all six proof holes in `FMSPoleTransfer.lean` without weakening any
statement. The centerpiece is the analytic finite residue theorem and its
application to a composite FMS observable whose remainder vanishes in one
simple spectral channel.

The cancellation witness is mandatory. It proves that the remainder hypothesis
is real acceptance data rather than decorative bookkeeping.

## Scientific scope

This is finite Kallen-Lehmann algebra. Do not claim a continuum pole, LSZ,
perturbative dominance, or an observed particle mass. The intended use is a
conditional observable-reconstruction rung in the origin-of-mass ladder.

## Verification

Run first:

```text
lake env lean FMSPoleTransfer.lean
```

Do not spend the proof budget on a broad build.

## Context

- `AgentTasks/context-packs/fms-pole-transfer-20260720-20260720-133011.md`
- `AutonomousLab/work/NE-DYNAMICS/CODEX_LITERATURE_FMS_MASS_OBSERVABLES_2026-07-20.md`
- `PhysicsSM/Draft/NullEdge/HiggsFMSRadialObservable.lean`
- `PhysicsSM/Draft/NullEdge/HiggsFMSVectorObservable.lean`
- `PhysicsSM/Draft/NullEdge/KallenLehmannRepresentation.lean`
- Primary source: Axel Maas, arXiv:2305.01960v2.

```yaml
aristotle:
  project_id: d1e11c02-a055-464a-abb6-d1c48a7dd4b7
  task_id: d4fc9bd1-cf2a-40f3-9cf8-2e2aec20585d
  target_file: FMSPoleTransfer.lean
  expected_module: FMSPoleTransfer
  submission_project: AgentTasks/aristotle-submit/fms-pole-transfer-20260720-project
  output_dir: AgentTasks/aristotle-output/d1e11c02-a055-464a-abb6-d1c48a7dd4b7
  status: integrated
```

## Integration result

The remote task was labelled `COMPLETE_WITH_ERRORS`, but the returned Lean
source itself passed local verification.  It landed as
`PhysicsSM/Draft/NullEdge/FMSPoleTransfer.lean`, with build-enforced guards.
The exact result transfers a simple finite spectral residue under a
channel-vanishing remainder hypothesis and includes a one-channel cancellation
witness showing why that hypothesis is indispensable.

The theorem is finite Kallen-Lehmann algebra.  It does not establish a
continuum LSZ pole, perturbative FMS dominance, or an observed Higgs/vector
mass.
