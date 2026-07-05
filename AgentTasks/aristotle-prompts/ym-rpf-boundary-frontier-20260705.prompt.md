# Frontier job: RP-F reflected Wilson boundary coupling

Advance or sharply narrow Lane 5: the fermionic reflection-positivity
reflected-boundary block. The current source has an abstract boundary-coupling
slot; the frontier is to instantiate or precisely characterize the concrete
Wilson boundary coupling and reflection-hermiticity hypothesis.

## Included context

This package includes the current `PhysicsSM/` tree plus:

- `AgentTasks/context-packs/ym-rpf-boundary-frontier-20260705-20260705-142650.md`
- `AgentTasks/fourday-ym-run-2026-07-05/GOAL_STATEMENT_ACHIEVABLE_WORK.md`

Key files:

- `PhysicsSM/Draft/NullEdge/GateYM/FermionicReflection.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/WilsonProjectors.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/WilsonDiracOperator.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/BerezinMatthewsSalam.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/ReflectionPositivityKernel.lean`

## Desired result

Try to produce one of the following, in order of preference:

1. A small kernel-checked helper theorem in `FermionicReflection.lean` that
   advances the concrete reflected boundary-coupling layer.
2. A precise new theorem statement with a documented proof plan and no hidden
   physical assumptions.
3. A no-go report explaining why the current interface is missing data, with
   the exact missing definition/hypothesis named.

Do not add new assumptions just to make the theorem pass. Do not claim
fermionic RP measure positivity unless the reflected Wilson block and
reflection-hermiticity bridge are actually present.

## Output format

Return:

- `Integrated patch` if you changed Lean;
- otherwise `No-patch design report`;
- exact theorem names;
- exact Lean errors if blocked;
- next smallest target.
