# Aristotle proof job: variable pointwise L2 isometry lift

## Context

The landed theorem
`PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE.momMult_isometry` proves exact
Euclidean-spinor norm preservation for the Dirac multiplier at each momentum.
Continuum F2 next needs a representative-safe operator on vector-valued `L2`.
The focused target abstracts the quotient/measurability argument away from the
physics imports so Aristotle can work against Mathlib alone.

## Immutable target

Prove the four marked declarations in
`AgentTasks/aristotle-standalone/cont-mom-mult-l2-isometry-20260713/VariablePointwiseL2Isometry.lean`:

- `variablePointwiseL2Isometry`;
- `variablePointwiseL2Isometry_coeFn`;
- `variablePointwiseL2Isometry_id`;
- `variablePointwiseL2Isometry_neg`.

The theorem packages a supplied almost-everywhere strongly measurable family
of pointwise complex-linear isometries as a complex-linear isometry of
`Lp E 2 mu`. The almost-everywhere representative theorem is part of the
contract. Do not strengthen quotient coercion into a pointwise physical claim.

## Boundaries

This rung does not prove surjectivity, strong continuity, Fourier transport,
the generator identity, or the Dirac PDE. The live specialization will prove
separately that the exact multiplier family is continuous and instantiate this
generic lift.

## Required controls

The constant identity family must lift to the identity and the constant
negative-identity family must lift to negation. These controls rule out maps
that silently return the input or zero regardless of the supplied family.

## Submission metadata

- Lab work item: `CONT-FOURIER-001`
- Source root:
  `AgentTasks/aristotle-standalone/cont-mom-mult-l2-isometry-20260713/`
- Semantic context pack:
  `AgentTasks/context-packs/cont-mom-mult-l2-isometry-20260713-20260713-012609.md`
- Expected module: `VariablePointwiseL2Isometry`
- Submission project:
  `AgentTasks/aristotle-submit/afpl-cont-mom-mult-l2-isometry-20260713-project`
- Independent statement audit: Claude ACCEPT,
  `msg-20260713-013752-e2a76ef7`
- Aristotle project: `1271173b-0275-4250-9a34-56fd7977649c`
- Status: integrated, 2026-07-13 02:23 PDT. All four target signatures were
  preserved. The returned proof was independently replayed and accepted by
  Claude message `msg-20260713-020816-31db330b`, then promoted to
  `PhysicsSM/Draft/NullEdge/VariablePointwiseL2Isometry.lean`. The live
  specialization in `ChangingCellFourierPDE.lean` and the 8,421-job aggregate
  axiom guard both build successfully.
