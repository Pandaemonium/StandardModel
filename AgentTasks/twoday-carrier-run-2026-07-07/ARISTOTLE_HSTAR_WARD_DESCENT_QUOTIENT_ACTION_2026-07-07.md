# Aristotle task - HSTAR Ward/descent quotient action

## Job

- Requested job name:
  `ne-next-hstar-ward-descent-quotient-action-proof-20260707`
- Lane: HSTAR / Q01 finite Ward-descent model
- Type: proof/strategy

```yaml
aristotle:
  project_id: b1980b93-dc5c-4adc-803d-c229a7d2220e
  task_id: 95086d97-2155-4d92-b46c-d49787d1e712
  target_file: PhysicsSM/Draft/NullEdge/Carrier/CarrierWardDescentWitness.lean
  expected_module: PhysicsSM.Draft.NullEdge.Carrier.CarrierWardDescentWitness
  submission_project: AgentTasks/aristotle-submit/ne-next-hstar-ward-descent-quotient-action-proof-20260707-project
  output_dir: AgentTasks/aristotle-output/b1980b93-dc5c-4adc-803d-c229a7d2220e
  status: submitted
```

## Context

`PhysicsSM/Draft/NullEdge/Carrier/CarrierWardDescentWitness.lean` now proves a
nonvacuous finite Ward/descent witness on the `(2,1)` positive-sector model.
For every phase `a`, `Uop a` commutes with `Qop`, is `Jpos`-unitary, preserves
`ker Qop`, preserves `range Qop`, preserves `kreinForm Jpos`, and fixes `e2`.

The next useful theorem is to make the descent literal on the physical
quotient, rather than only at representative level.

## Target

Prove, or isolate the exact missing API for, an induced map on
`LinearMap.ker Qop / LinearMap.range Qop` coming from `Uop a`, together with
the finite preservation statement for the induced form.

Preferred result shape:

1. A linear map or linear equivalence on the quotient induced by `Uop a`.
2. A proof that the induced map fixes the class represented by `e2`.
3. A proof that the induced map preserves the Kugo-Ojima quotient form, or the
   closest available finite statement using the existing quotient-form API.

If the existing definitions make this awkward, return the smallest reusable
quotient-action lemma and a precise blocker.

## Boundary

This is finite model algebra only.  Do not claim physical Ward identities,
carrier/Gauss completeness, BRST cohomology, or physical positivity.

## Files To Inspect

- `PhysicsSM/Draft/NullEdge/Carrier/KugoOjima.lean`
- `PhysicsSM/Draft/NullEdge/Carrier/KreinPositiveSectorWitness.lean`
- `PhysicsSM/Draft/NullEdge/Carrier/CarrierWardDescentWitness.lean`
- `AgentTasks/HSTAR_MODEL_AUDIT_2026-07-07.md`
- `AgentTasks/twoday-carrier-run-2026-07-07/THREAD_BOARD.md`
- `AgentTasks/twoday-carrier-run-2026-07-07/GOAL_PROMPT_CODEX.md`

## Desired Output

- A Lean patch if feasible, preferably extending
  `PhysicsSM/Draft/NullEdge/Carrier/CarrierWardDescentWitness.lean`.
- If no full proof is feasible, a precise blocker and the exact theorem
  statement that should be submitted next.
- A short completion report listing solved targets, unchanged/changed theorem
  statements, remaining holes, and any footprint concerns.
