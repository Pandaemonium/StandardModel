# Aristotle task: real finite i.i.d. null-strand G1 master

Date: 2026-06-25

## Objective

Replace the current abstract G1 shell with a real, concrete-hypothesis
`finiteIIDNullStrand_master` theorem or the smallest viable scaffold for it.

The target is not a tautological projection from arbitrary `Prop` fields. It
should connect banked finite ingredients such as `iidNullSteps_empiricalMean_tendsto`,
trajectory probability infrastructure, null-step lemmas, and concrete vector
types into one honest master statement.

## Requested output

- Patchable Lean for `PhysicsSM/NullStrand/Master/FiniteModel.lean` and helper
  files if needed.
- A concrete model structure only if its fields are actual data/lemmas, not
  restated physical conclusions.
- A theorem named `finiteIIDNullStrand_master` if possible.
- If the full theorem is too large, return the exact intermediate lemmas and
  proof blockers, with the smallest next Aristotle follow-up.

## Files to inspect first

- `PhysicsSM/NullStrand/Master/FiniteModel.lean`
- `PhysicsSM/NullStrand/Ergodic/IIDStrongLaw.lean`
- `PhysicsSM/NullStrand/Probability/Trajectory.lean`
- `PhysicsSM/NullStrand/ZigZag/LatticeBeable.lean`
- `PhysicsSM/NullStrand/NullFiber/FluxFinite.lean`
- `AgentTasks/null-strand-roadmap-hardening-report-aristotle-2026-06-25.md`

## Constraints

- Do not weaken the physics claim into a projection shell.
- Do not add new assumptions merely to make the theorem pass.
- Leave draft/handoff code clearly marked if a proof is blocked.
- Prefer finite, concrete statements over continuum generality.

## Aristotle metadata

```yaml
aristotle:
  project_id: 7c52ed82-5947-4327-93ae-edb8f1372fc0
  task_id: 2754e5a2-ae71-4fc8-b4be-2a1c1c936f85
  target_file: PhysicsSM/NullStrand/Master/FiniteModel.lean
  expected_module: PhysicsSM.NullStrand.Master.FiniteModel
  submission_project: AgentTasks/aristotle-submit/nullstrand-g1-iid-master-20260625-project
  output_dir: AgentTasks/aristotle-output/7c52ed82-5947-4327-93ae-edb8f1372fc0
  status: integrated
```

## 2026-06-25 nudge

Sent `aristotle continue --mode instruct` to project
`7c52ed82-5947-4327-93ae-edb8f1372fc0`: skip full `lake build` and dependency
rebuilds; return patchable Lean or precise blockers.

## 2026-06-25 integration

Integrated into `PhysicsSM/NullStrand/Master/FiniteModel.lean`.

Primary additions:

- `FiniteIIDNullStrandModel`
- `finiteIIDNullStrand_master`
- `octaWitnessModel`
- `finiteIIDNullStrandModel_nonempty`

Copied report:
`AgentTasks/nullstrand-g1-iid-master-completion-report-2026-06-25.md`.
