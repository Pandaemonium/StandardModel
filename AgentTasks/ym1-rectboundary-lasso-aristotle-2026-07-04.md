# Aristotle task: YM1 rectangular boundary lasso identity

```yaml
aristotle:
  project_id: 93758b7f-a303-407b-8fd3-274bd363d2e6
  task_id: 4e93e92e-5177-469d-915b-92e9a1962609
  target_file: PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryLasso.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.RectBoundaryLasso
  submission_project: AgentTasks/aristotle-submit/ym1-rectboundary-lasso-20260704-project
  output_dir: AgentTasks/aristotle-output/93758b7f-a303-407b-8fd3-274bd363d2e6
  status: submitted
```

## Purpose

Prove the accepted T11/Q11 tree-slice lasso identity for the concrete
`RectTreeGauge.rectLattice`. This is the next finite-geometry layer after the
already-landed boundary-walk convention pin.

Target declarations in
`PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryLasso.lean`:

- `IsCombTreeSlice`
- `reversedRowMajorPlaquetteProd`
- `rectBoundary_hol_eq_reversedRowMajorPlaquetteProd_of_treeSlice`
- `apply_rectBoundary_hol_eq_reversedRowMajorPlaquetteProd_of_treeSlice`

The first proof target currently has a documented draft proof placeholder. The
second target is already a direct `congrArg` consequence and should remain
lightweight.

## Context

- Accepted review thread:
  `AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md#review:t11-lasso-package`
- Semantic context pack:
  `AgentTasks/context-packs/ym1-rectboundary-lasso-20260704-20260704-121001.md`
- Prompt:
  `AgentTasks/aristotle-prompts/ym1-rectboundary-lasso-20260704.prompt.md`

## Local checks before submission

These commands were run on the live tree after adding the statement skeleton:

```powershell
lake env lean PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryLasso.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.RectBoundaryLasso
lake env lean PhysicsSM/Draft/NullEdge/GateYM.lean
```

Result: all passed. The first two commands report the intended draft proof
placeholder warning on
`rectBoundary_hol_eq_reversedRowMajorPlaquetteProd_of_treeSlice`.

## Submission record

Prepared package:

```powershell
pwsh Scripts/prepare_aristotle_submission.ps1 -JobName ym1-rectboundary-lasso-20260704 -TaskNote "AgentTasks/ym1-rectboundary-lasso-aristotle-2026-07-04.md" -ExtraPath "AgentTasks/aristotle-prompts/ym1-rectboundary-lasso-20260704.prompt.md;AgentTasks/context-packs/ym1-rectboundary-lasso-20260704-20260704-121001.md;AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md" -CheckPath PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryLasso.lean -NoRemoteSpherePacking
```

Package check reported exactly one proof placeholder line in the target file
and no `a x i o m`, `a d m i t`, or `u n s a f e` tokens.

First submit attempt returned an HTTP read error after upload began. Per repo
policy, `aristotle list --limit 10` was checked before retrying; no lasso
project had been created. The retry succeeded:

```text
Project created: 93758b7f-a303-407b-8fd3-274bd363d2e6
```

Task:

```text
4e93e92e-5177-469d-915b-92e9a1962609
```

## Guardrails for integration

- Do not accept any statement weakening, changed product order, or changed
  tree-slice predicate without a fresh semantic review.
- Do not integrate a proof of the expected-false pointwise identity at general
  tree values.
- If Aristotle changes `reversedRowMajorPlaquetteProd`, first check whether the
  order still matches: increasing row `j`, reversed horizontal index `i` inside
  each row.
- After harvest, run the exact target file, targeted module build, aggregate
  GateYM build, and an axiom audit for the lasso identity.
