# Aristotle task - Q10 d = 4 self-dual positive corner

## Job

- Requested job name:
  `ne-next-q10-spinweyl-d4-selfdual-positive-corner-proof-20260707`
- Lane: Q10 scalar amplitude / signature-dimension boundary
- Type: proof/strategy

```yaml
aristotle:
  project_id: fbdbe43f-b8c4-4edc-9f28-d09bbdbf824c
  task_id: c3b0786e-f990-4110-8b00-f7f0770b4acc
  target_file: PhysicsSM/Draft/NullEdge/GateI1/SameChiralityScalarAmplitude.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateI1.SameChiralityScalarAmplitude
  submission_project: AgentTasks/aristotle-submit/ne-next-q10-spinweyl-d4-selfdual-positive-corner-proof-20260707-project
  output_dir: AgentTasks/aristotle-output/fbdbe43f-b8c4-4edc-9f28-d09bbdbf824c
  status: submitted
```

## Context

`PhysicsSM/Draft/NullEdge/GateI1/SameChiralityScalarAmplitude.lean` now proves a
finite diagonal-Cartan obstruction: if the diagonal spectrum is not invariant
under negation, then there is no invertible self-duality intertwiner for that
diagonal action.  The landed examples rule out the encoded `d = 6` and `d = 10`
census vectors.

The current claim boundary is deliberately conservative: this is finite
linear algebra, not a real `Spin(1,d-1)` Weyl-module classification and not a
standalone physical dimension-selection theorem.

## Target

Prove the positive corner suggested by the obstruction:

1. Give an explicit `d = 4` finite-spectrum witness with negation-symmetric
   weights.
2. Construct an invertible linear self-duality/intertwiner for the relevant
   diagonal action, or prove the cleanest reusable criterion turning
   negation-symmetric paired weights into such an intertwiner.
3. If the current abstraction is missing structure, return the smallest
   theorem that is both kernel-checkable and semantically honest.

## Important Boundary

Do not promote this to a physical `Spin(1,3)` theorem unless the statement
actually contains the relevant representation structure.  A finite diagonal
linear-algebra positive example is still useful and should be named as such.

Do not silently change the existing obstruction statements.  Any modified
definition or theorem statement must be justified in the completion report.

## Files To Inspect

- `PhysicsSM/Draft/NullEdge/GateI1/SameChiralityScalarAmplitude.lean`
- `PhysicsSM/Draft/NullEdge/GateI1.lean`
- `AgentTasks/twoday-carrier-run-2026-07-07/ARISTOTLE_Q10_SPINWEYL_SCALAR_AMPLITUDE_HARVEST_2026-07-07.md`
- `AgentTasks/twoday-carrier-run-2026-07-07/THREAD_BOARD.md`
- `AgentTasks/twoday-carrier-run-2026-07-07/GOAL_PROMPT_CODEX.md`

## Desired Output

- A Lean patch if feasible, preferably extending
  `PhysicsSM/Draft/NullEdge/GateI1/SameChiralityScalarAmplitude.lean`.
- If no full proof is feasible, a precise blocker and an alternative theorem
  statement that would honestly capture the positive `d = 4` corner.
- A short completion report listing solved targets, unchanged/changed theorem
  statements, remaining holes, and any footprint concerns.
