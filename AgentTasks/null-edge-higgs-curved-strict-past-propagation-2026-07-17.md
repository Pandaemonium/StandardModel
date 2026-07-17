# Null-edge Higgs curved strict-past propagation

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: implemented

## Objective

Extend the exact strict-past measured Higgs resolvent to the position-dependent
effective insertion `(bareMassSq + xi * curvature x) * vertexMeasure x`.

## Result

`PhysicsSM/Draft/NullEdge/HiggsCurvedStrictPastPropagation.lean` proves:

- the curvature-dependent diagonal insertion is exactly a generic measured
  local mass matrix;
- both insertion orders remain nilpotent at the event-cardinality power;
- the curved finite response obeys exact left and right resolvent identities;
  and
- on a three-event control with curvature `[0, 2, 0]`, bare mass squared `1`,
  coupling `1`, and measure `[2, 3, 5]`, the direct endpoint entry remains zero
  while the measured endpoint response is `-9`.

Claim grade: `M [comp]`.

## Scope boundary

Curvature, measure, primitive kernel, bare mass, and coupling are supplied. The
result does not derive curvature from order, select a physical coupling, prove
a continuum curved-space scalar equation, or predict a Higgs pole mass.

## Provenance

Project-internal composition of
`HiggsCurvatureMassIdentifiability.lean` and
`HiggsStrictPastMeasuredResolvent.lean`. No external proof text or
implementation was copied.

## Verification

- Production SHA-256:
  `CB68AFF45033DA774B714D94FE1FDB66C5CE02122858C8E4BEE367094A8CF7DC`
- `lake env lean PhysicsSM/Draft/NullEdge/HiggsCurvedStrictPastPropagation.lean`
- `lake build PhysicsSM.Draft.NullEdge.HiggsCurvedStrictPastPropagation`
  (8,033 jobs)
- Lean LSP error diagnostics: empty
- `lean_verify` on `strictPast_curvedHiggs_two_sided_resolvent` and
  `threeLink_curved_intermediate_witness`: standard three axioms, no source
  warnings

There are no proof holes or linter warnings in this module. The targeted build
replayed inherited nonfatal linter suggestions from
`HiggsEdgeEulerOperator.lean`.
