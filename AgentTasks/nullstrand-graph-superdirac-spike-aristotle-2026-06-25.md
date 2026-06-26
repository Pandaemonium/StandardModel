# Aristotle task: concrete graph super-Dirac spike

Date: 2026-06-25

## Objective

Attack the GRAPH-003/004/005 operator gate with a concrete finite spike. The
job is allowed to return either a candidate construction with verified support
and square lemmas, or a precise obstruction explaining why the current API
cannot yet host the proposed operator.

## Requested output

- A concrete finite operator candidate, preferably in or near
  `PhysicsSM/NullStrand/Graph/`.
- Verified support-transfer and square lemmas beyond the existing generic
  support lemmas, if feasible.
- A Lean-level decomposition target for the null-diamond super-Dirac proposal:
  first-order null symbol, square, curvature/frame-defect/Yukawa split.
- If impossible, return the smallest missing API and a proposed theorem list.

## Files to inspect first

- `PhysicsSM/NullStrand/Graph/Support.lean`
- `PhysicsSM/NullStrand/Graph/*.lean`
- `PhysicsSM/NullStrand/BellQFT/*.lean`
- `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean`
- `PhysicsSM/Draft/NullEdgeDiracSlashCore.lean`
- `PhysicsSM/Draft/NullEdgeBundleDiracPluckerCore.lean`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `AgentTasks/null-strand-roadmap-hardening-report-aristotle-2026-06-25.md`

## Constraints

- Do not let the already-easy support-transfer lemma stand in for the operator.
- Do not double-count Plucker mass as both kinetic square and zero-order mass.
- Prefer one concrete finite example over a broad abstract square identity.

## Aristotle metadata

```yaml
aristotle:
  project_id: 12232975-6826-4bf9-a977-9cd142159034
  task_id: 5e133d23-a24a-4ce7-822f-470bbbe5ecf1
  target_file: PhysicsSM/NullStrand/Graph
  expected_module: multiple
  submission_project: AgentTasks/aristotle-submit/nullstrand-graph-superdirac-spike-20260625-project
  output_dir: AgentTasks/aristotle-output/12232975-6826-4bf9-a977-9cd142159034
  status: failed_after_nudge_no_output
```

## 2026-06-25 nudge

Sent `aristotle continue --mode instruct` to project
`12232975-6826-4bf9-a977-9cd142159034`: skip full `lake build` and dependency
rebuilds; return patchable Lean or precise blockers.

## 2026-06-25 triage

The original task was canceled by the nudge path and its replacement failed
without patchable Lean output. No live integration was performed. This lane is
being resubmitted with an explicit instruction not to run full `lake build`.
