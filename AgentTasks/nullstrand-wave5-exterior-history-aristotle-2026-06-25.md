# Aristotle task: wave 5 exterior-history mass and measure layer

Date: 2026-06-25

## Objective

Start the exterior-history layer named in the roadmap. Build as much of the
finite grade-2 Plucker/Sorkin history package as can be stated honestly with the
current finite APIs.

## Build instruction

The submission package intentionally omits `.lake`. Do not run full `lake build`.
If you add new modules, run only targeted checks of those modules if dependency
setup is already available. Otherwise return patchable Lean plus exact blockers.

## Requested output

- New modules, if feasible:
  - `PhysicsSM/NullStrand/Histories/ExteriorMassMeasure.lean`
  - `PhysicsSM/NullStrand/Histories/ExteriorRankMeasure.lean`
- Minimal finite definitions for history amplitudes, grade-2/exterior mass
  capacity, and rank/measure diagnostics that do not overclaim continuum
  physics.
- At least one nontrivial finite theorem, or a precise handoff scaffold if the
  project lacks the necessary linear-algebra API.
- A completion report that states whether this is ready for trusted code, draft
  code, or only a design note.

## Files and context

- `AgentTasks/context-packs/nullstrand-wave5-exterior-history-20260625-161747.md`
- `Sources/Plucker_Sorkin_Exterior_History_Theorem.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `Sources/NullStrand_Lean_Roadmap_Improved.md`
- `PhysicsSM/NullStrand/Probability/Finite.lean`
- `PhysicsSM/NullStrand/Graph/Support.lean`

## Aristotle metadata

```yaml
aristotle:
  project_id: 173234ac-d6ec-4925-8aee-213f5e9f5326
  task_id: e6d39c96-bf8b-468c-80ac-56024ca23d66
  target_file: PhysicsSM/NullStrand/Histories/ExteriorMassMeasure.lean
  expected_module: PhysicsSM.NullStrand.Histories.ExteriorMassMeasure
  submission_project: AgentTasks/aristotle-submit/nullstrand-wave5-exterior-history-20260625-project
  output_dir: AgentTasks/aristotle-output/173234ac-d6ec-4925-8aee-213f5e9f5326
  status: integrated
```

## Integration notes

2026-06-25 Codex integration pass:

- Added the finite exterior-history layer returned by Aristotle:
  - `PhysicsSM/NullStrand/Histories/ExteriorMassMeasure.lean`
  - `PhysicsSM/NullStrand/Histories/ExteriorRankMeasure.lean`
- Wired both modules into `PhysicsSM/NullStrand.lean`.
- Kept the statements finite and algebraic: grade-2 Plucker/Sorkin mass
  capacity, a general PSD Gram determinant layer, and no continuum claim.

Verification:

- `lake build PhysicsSM.NullStrand.Histories.ExteriorMassMeasure`
- `lake build PhysicsSM.NullStrand.Histories.ExteriorRankMeasure`
- `lake env lean PhysicsSM/NullStrand.lean`
