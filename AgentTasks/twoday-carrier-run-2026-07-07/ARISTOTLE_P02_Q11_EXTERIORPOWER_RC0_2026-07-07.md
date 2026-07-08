# Aristotle task - P02 Q11 exterior-power RC0 route

## Job

- Requested job name:
  `ne-hard-p02-q11-exteriorpower-cauchybinet-rc0-proof-20260707`
- Lane: Q11 real structure / RC0 / group-level unimodularity
- Type: proof/strategy

```yaml
aristotle:
  project_id: 4b4d1f1b-389d-4e90-ade3-36a9d1183869
  task_id: b2a6ee2d-07d7-4230-a652-f6112044fe88
  target_file: PhysicsSM/Draft/NullEdge/GateI1/Q11GroupAction.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateI1.Q11GroupAction
  submission_project: AgentTasks/aristotle-submit/ne-hard-p02-q11-exteriorpower-cauchybinet-rc0-proof-20260707-project
  output_dir: AgentTasks/aristotle-output/4b4d1f1b-389d-4e90-ade3-36a9d1183869
  status: submitted
```

## Context

`Q11GroupAction.lean` now has the structural exterior-functor coefficient
model: `minorDet`, `lambdaAction`, `lambdaLinearMap`, identity action,
conjugation compatibility, and cardinality-support scaffolding.  The next
missing rung is finite Cauchy-Binet/functoriality, then determinant cocycle /
group-level RC0.

Fable recommends not proving Cauchy-Binet by hand-minor combinatorics.  Re-base
on Mathlib exterior-power functoriality if available:

- `exteriorPower.map`,
- `exteriorPower.map_comp`,
- `exteriorPower.linearMap_ext`.

Verify exact names in the submitted project before relying on them.

## Target

Prove, or isolate the exact blocker for, the functoriality statement:

```text
lambdaLinearMap (g * h) = (lambdaLinearMap g).comp (lambdaLinearMap h)
```

Prefer an API layer:

```text
compoundMatrixOfExteriorMap
compoundMatrix_map_id
compoundMatrix_map_comp
compoundMatrix_det_exteriorPower
```

Then use it to connect `lambdaAction` to exterior-power matrices.  If the
determinant cocycle is reachable, prove the relevant Sylvester-Franke style
formula or return the exact next theorem.  Decide explicitly whether Jacobi
complementary minors are load-bearing for RC0; if not, park Jacobi.

## Desired output

- Lean patch to `Q11GroupAction.lean` if feasible.
- Otherwise, a precise theorem statement and Mathlib blocker list.
- Do not weaken the target into only identity action or support preservation;
  those already landed.
- Claim boundary: no group-level RC0/unimodularity claim unless determinant
  cocycle is actually proved and semantically reviewed.

## Required patch layer

Use:

- `AgentTasks/twoday-carrier-run-2026-07-07/FABLE_HANDOFF_HARDEST_PIECES.md`,
- `AgentTasks/twoday-carrier-run-2026-07-07/ARISTOTLE_HARDEST_PIECES_PRO_PATCHES_2026-07-07.md`.
