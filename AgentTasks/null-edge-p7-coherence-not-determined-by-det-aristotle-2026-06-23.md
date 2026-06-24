# Aristotle proof job: P7 coherence is not determined by determinant

```yaml
job_name: null-edge-p7-coherence-not-determined-by-det-20260623
status: integrated
project_id: c8076caa-ae7f-4bb0-99d2-0856f5bfe786
task_id: 855b5ab6-6047-4324-ad6a-2716922a2380
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p7-coherence-not-determined-by-det-20260623
submission_project: AgentTasks/aristotle-submit/null-edge-p7-coherence-not-determined-by-det-20260623-project
target_file: NullEdgeP7CoherenceNotDeterminedByDet/Core.lean
expected_module: NullEdgeP7CoherenceNotDeterminedByDet.Core
expected_check: lake env lean NullEdgeP7CoherenceNotDeterminedByDet/Core.lean
integrated_module: PhysicsSM.Draft.NullEdgeP7CoherenceNotDeterminedByDet
```

## Physics context

- Program lane / paper: P7/P1 observer-channel proper-time and origin-of-mass
  bridge.
- Four-layer status: exact finite counterexample. This does not prove a
  dynamical rate law.
- Why this theorem matters physically: the normalized determinant/mass-ratio
  observable does not determine the off-diagonal chirality coherence. The
  theorem prevents overclaiming that mass alone reconstructs the hidden
  observer-channel story.
- What would weaken or falsify the interpretation: if positivity or density
  constraints later rule out the witness in the intended physical channel, the
  statement must be strengthened to a positive semidefinite density class.
- Relevant conventions or sources: real symmetric two-state density proxies
  with trace one, determinant `a*b - c*c`, and squared coherence `c*c`.

## Task

Close the proof holes in:

```text
NullEdgeP7CoherenceNotDeterminedByDet/Core.lean
```

Do not change definitions or theorem statements unless one is false, and report
any such issue explicitly.

## Target declarations

- `rhoDiag_trace_one`
- `rhoCoh_trace_one`
- `rhoDiag_det`
- `rhoCoh_det`
- `same_det`
- `different_coherenceSq`
- `determinant_does_not_determine_coherenceSq`

## Completion report requested

Please end with:

```text
Completion report:
- solved targets:
- unchanged theorem statements? yes/no, list changes:
- remaining proof holes:
- assumptions or escape hatches used:
- suggested next theorem:
- suggested next physics/context check:
- suggested literature or convention check:
- highest-risk remaining gap:
```

## Integration note

Codex solved the finite arithmetic target locally while Aristotle was running;
Aristotle returned an equivalent proof. The result is integrated as:

```text
PhysicsSM.Draft.NullEdgeP7CoherenceNotDeterminedByDet
```

Verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p7-coherence-not-determined-by-det-20260623/NullEdgeP7CoherenceNotDeterminedByDet/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP7CoherenceNotDeterminedByDet.lean
lake build PhysicsSM.Draft.NullEdgeP7CoherenceNotDeterminedByDet
lake env lean PhysicsSMDraft.lean
```

Scientific significance: this is a finite counterexample showing that
trace-one determinant mass does not determine off-diagonal chirality coherence.
It sharpens the observer-channel claim boundary: the static mass-ratio
observable is not enough to reconstruct hidden coherence.
