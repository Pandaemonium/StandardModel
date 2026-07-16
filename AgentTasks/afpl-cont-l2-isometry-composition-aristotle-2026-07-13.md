# Aristotle proof job: variable pointwise L2 composition

## Context

The null-edge continuum program now has a completed generic construction that
lifts an almost-everywhere strongly measurable family of fibrewise complex
linear isometries to a representative-safe linear isometry of vector-valued
`L2`. The next reusable rung is functoriality: lifting pointwise composition
must agree with composing the two induced `L2` maps.

## Immutable targets

Prove the three declarations marked as immutable or controls in
`AgentTasks/aristotle-standalone/cont-l2-isometry-composition-20260713/VariablePointwiseL2Composition.lean`:

- `variablePointwiseL2Isometry_comp`;
- `variablePointwiseL2Isometry_comp_id_control`;
- `variablePointwiseL2Isometry_comp_neg_control`.

Preserve all signatures. The likely proof uses `Lp.ext`, the almost-everywhere
representative theorem for each lift, and pointwise continuous-linear-map
composition.

## Boundaries

This target does not prove a multiplier time-group law, strong continuity,
Fourier transport, a generator identity, or a position-space PDE. It only
proves the generic quotient-safe `L2` composition law that those later results
can instantiate.

## Non-degeneracy

The identity/identity and negative-identity/negative-identity controls must both
reduce to the identity map. They prevent a proof from ignoring the supplied
families or reversing the composition order.

## Submission metadata

- Lab work item: `CONT-FOURIER-001`
- Source root:
  `AgentTasks/aristotle-standalone/cont-l2-isometry-composition-20260713/`
- Semantic context pack:
  `AgentTasks/context-packs/cont-l2-isometry-composition-20260713-20260713-020528.md`
- Expected module: `VariablePointwiseL2Composition`
- Trust target: ordinary Mathlib axioms only
- Submission project:
  `AgentTasks/aristotle-submit/afpl-cont-l2-isometry-composition-20260713-project`
- Aristotle project: `63e6b14f-f7a1-4db8-a39d-a9c50971f5b9`
- Status: integrated, 2026-07-13 02:48 PDT. All three target signatures were
  preserved; the returned proof replayed cleanly and was promoted to the
  guarded live `VariablePointwiseL2Isometry` module. The 8,422-job aggregate
  axiom guard passes with the standard footprint.
