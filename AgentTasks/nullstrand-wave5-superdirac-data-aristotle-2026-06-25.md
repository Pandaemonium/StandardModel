# Aristotle task: wave 5 concrete finite super-Dirac data spike

Date: 2026-06-25

## Objective

Push beyond support lemmas by proposing and, if feasible, implementing the
smallest honest finite data structure for a graph super-Dirac operator. The goal
is not to prove the full physics synthesis, but to find one precise finite
operator API whose square can later carry Laplacian, holonomy-defect, and
Yukawa-like blocks without conflating them.

## Build instruction

The submission package intentionally omits `.lake`. Do not run full `lake build`.
If targeted checks work, use only:

```powershell
lake env lean PhysicsSM/NullStrand/Graph/Support.lean
```

or a targeted check of any new graph module you create. If build setup is slow,
skip build and return patchable Lean or a no-go report with exact API blockers.

## Requested output

- A new trusted finite graph module or an extension of
  `PhysicsSM/NullStrand/Graph/Support.lean` if the definitions are clearly
  non-speculative.
- A record or structure for finite super-Dirac data with explicit fields for
  grading, odd operator support, square support, and named block projections.
- At least one kernel-checkable theorem about the square of a graded-odd
  operator or a block-support decomposition.
- A clear semantic boundary saying what is proven finite linear algebra and what
  remains speculative super-Dirac interpretation.
- If this cannot be made honest yet, return a minimal API proposal and a no-go
  explanation rather than weakening the claim.

## Files and context

- `AgentTasks/context-packs/nullstrand-wave5-superdirac-20260625-161740.md`
- `PhysicsSM/NullStrand/Graph/Support.lean`
- `PhysicsSM/NullStrand/BellQFT/BlockSupport.lean`
- `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean`
- `Sources/NullStrand_Lean_Roadmap_Improved.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`

## Aristotle metadata

```yaml
aristotle:
  project_id: 1a891baa-e207-4818-8f79-4ce9839f5090
  task_id: 1909c1f5-7aa9-47d2-b8c4-0d29d13603cb
  target_file: PhysicsSM/NullStrand/Graph/Support.lean
  expected_module: PhysicsSM.NullStrand.Graph.Support
  submission_project: AgentTasks/aristotle-submit/nullstrand-wave5-superdirac-data-20260625-project
  output_dir: AgentTasks/aristotle-output/1a891baa-e207-4818-8f79-4ce9839f5090
  status: completed_not_integrated
```

## Integration notes

2026-06-25 Codex integration pass:

- Aristotle returned exploratory super-Dirac data outputs, but the integration
  helper found placeholder-token blockers in returned draft modules and no clean
  trusted live-module patch.
- No super-Dirac code was promoted from this job.
- The next wave resubmits a larger but more explicit target for a trusted finite
  `Graph.SuperDirac` API with square/block-support theorems and a no-go option
  if the statement is not yet honest.
