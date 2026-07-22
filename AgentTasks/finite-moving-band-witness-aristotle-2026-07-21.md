# Aristotle task: finite gapped moving-band witness

Date: 2026-07-21
Owner: Codex
Work item: `QCA-3PLUS1-001`
Status: integrated with scope correction and fixed-path continuation

## Objective

Prove an exact two-level Hamiltonian family with fixed gap `2`, a moving
rank-one low-energy projector, nonzero finite-step leakage, and an explicit
slow schedule whose accumulated leakage budget vanishes.

## Scientific role

This is an exact gapped moving-projector control for the literature-guided
physical-sector relaxation. It proves that the finite-step mismatch can be
nonzero while a changing-regulator budget vanishes. The displayed schedule,
however, moves only a total parameter distance `1/N`; it therefore does not
establish autonomy along a fixed macroscopic path. It is not the HNU projector,
an adiabatic theorem, or an interaction theorem.

Sources and interpretation:
`AutonomousLab/work/NE-3PLUS1/CODEX_LITERATURE_QUASILOCAL_PHYSICAL_SECTOR_2026-07-21.md`.

Semantic context pack reused from the immediately preceding abstract rung:
`AgentTasks/context-packs/moving-sector-leakage-20260721-20260721-054716.md`.

```yaml
aristotle:
  project_id: a46bd268-cf90-4173-b904-a82d5d596218
  task_id: 74f3357b-00b7-4b75-8fac-0005bac8076d
  target_file: PhysicsSM/Draft/NullEdge/FiniteMovingBandWitness.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteMovingBandWitness
  submission_project: AgentTasks/aristotle-submit/finite-moving-band-witness-20260721-project
  output_dir: AgentTasks/aristotle-output/a46bd268-cf90-4173-b904-a82d5d596218
  status: integrated
```

## Close-out and semantic audit

Aristotle returned all requested proofs and preserved every theorem signature.
The exact fixed gap, projector identities, overlap formula, and nonzero finite
step are substantive and were integrated. The original description of the
vanishing sum as a nondegenerate adiabatic witness was too strong: because
`slowParameter N N = 1/N`, the full path collapses as the regulator grows.
The live module header and theorem docs now call this a shrinking-schedule
control and preregister that a fixed-endpoint schedule still requires genuine
adiabatic cancellation.

Verification:

- `lake env lean PhysicsSM/Draft/NullEdge/FiniteMovingBandWitness.lean`
- `lake build PhysicsSM.Draft.NullEdge.FiniteMovingBandWitnessAxiomGuard`

The guard pins only `propext`, `Classical.choice`, and `Quot.sound`. There are
no executable placeholders or expanded-trust evaluation shortcuts.

## Fixed-path continuation

At 08:01 PDT the completed project was reopened with task
`8c569d24-62fd-43aa-9311-19bc9fe9bb88`. The successor target follows Kato's
projector-intertwining viewpoint and asks for an exact `0 -> 1` parameter path:

- adjacent projectors must genuinely differ;
- an explicit orthogonal `bandTransport s t` must intertwine them;
- actual cross-band transport defect and accumulated leakage must be zero;
- the endpoint must stay fixed at `1` as `N` grows;
- a nonidentity transport witness is mandatory.

This continuation repairs the shrinking-path weakness without claiming that
the live HNU walk already realizes the transporter.

At 08:34 PDT a current archive was preserved at
`AgentTasks/aristotle-output/a46bd268-cf90-4173-b904-a82d5d596218/fixed-path-in-progress-snapshot-0834.zip`.
The continuation has now returned hole-free and is integrated. The project
module preserves its reviewed namespace and provenance header while adding the
exact transporter, fixed `0 -> 1` schedule, nonzero adjacent projector motion,
projector intertwining, exact zero transported leakage, and a nonidentity
control. The expanded axiom guard pins the fixed-path capstone to only
`propext`, `Classical.choice`, and `Quot.sound`.

This remains an exact supplied-transporter witness, not a derivation of that
transporter from the live HNU dynamics or a discrete adiabatic theorem.
