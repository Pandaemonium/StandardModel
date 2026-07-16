# Aristotle proof job: exact Dirac flow time group

## Context

The continuum lane has landed exact pointwise unitarity, momentum continuity,
and a representative-safe momentum-space `L2` isometry for the live Dirac
multiplier. A generic theorem lifting pointwise composition to `L2` is running
in parallel as Aristotle project `63e6b14f`. The missing algebraic input is the
time-group law for the actual matrix flow.

## Immutable targets

Prove `exactFlow_add_time`, `exactFlow_mul_neg_time`, and
`exactFlow_neg_time_mul` in
`AgentTasks/aristotle-standalone/exact-flow-time-group-20260713/ExactFlowTimeGroup.lean`.
Preserve every signature and the existing `exactFlow` definition.

## Boundary

Pointwise matrix group law only. No `L2` group, strong time continuity,
generator identity, Fourier theorem, or PDE claim.

## Submission metadata

- Lab work item: `CONT-FOURIER-001`
- Semantic context pack:
  `AgentTasks/context-packs/exact-flow-time-group-20260713-20260713-023257.md`
- Expected module: `ExactFlowTimeGroup`
- Trust target: ordinary project/Mathlib axioms only
- Submission project:
  `AgentTasks/aristotle-submit/afpl-exact-flow-time-group-20260713-project`
- Aristotle project: `0704b7da-df6b-4dba-bc5c-fc22168d931f`
- Status: externally RUNNING, submitted 2026-07-13 02:34 PDT
