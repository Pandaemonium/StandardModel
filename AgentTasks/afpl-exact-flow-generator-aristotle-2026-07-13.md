# Aristotle proof job: pointwise exact-flow generator

## Context

The live null-edge continuum lane has the exact finite-dimensional Dirac flow
and a representative-safe norm-preserving momentum-space `L2` lift.  This job
identifies the actual fibrewise infinitesimal generator before any unbounded
operator-domain or Fourier/PDE claim is attempted.

## Immutable targets

Prove `exactFlow_hasDerivAt` and `momMult_apply_hasDerivAt_zero` in
`AgentTasks/aristotle-standalone/exact-flow-generator-20260713/ExactFlowGenerator.lean`.

## Boundary

Pointwise finite-dimensional time differentiation only.  No full-`L2`
generator, domain, Stone theorem, Fourier transport, position-space PDE,
continuum limit, or Lorentz-restoration claim.

## Submission metadata

- Lab work item: `CONT-FOURIER-001`
- Semantic context pack:
  `AgentTasks/context-packs/exact-flow-generator-20260713-20260713-032538.md`
- Expected module: `ExactFlowGenerator`
- Trust target: ordinary project/Mathlib axioms only
- Submission project:
  `AgentTasks/aristotle-submit/afpl-exact-flow-generator-20260713-project`
- Aristotle project: `c2da9ae1-b3ef-48a1-b2a8-e0d72f2f30b3`
- Status: INTEGRATED. Both immutable targets returned placeholder-free,
  replayed locally with `lake env lean`, and passed Claude-family semantic
  review `msg-20260713-040843-544c239d`. They are live in
  `PhysicsSM/Draft/NullEdge/ExactFlowGenerator.lean` with module-local and
  aggregate axiom pins. The 8426-job aggregate guard build passed.
