# Null-edge Higgs gauge-invariant measured propagation

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: implemented

## Objective

Lift the nonuniform measured strict-past radial Higgs resolvent to the leading
gauge-invariant FMS observable. Preserve exact two-sided resolvent equations
and entrywise support, and provide a nonzero finite control.

## Result

`PhysicsSM/Draft/NullEdge/HiggsGaugeInvariantMeasuredPropagation.lean` proves:

- the leading FMS kernel obeys the same exact left/right measured resolvent;
- at nonzero vacuum it has exactly the same entrywise support as the elementary
  measured response; and
- in the nonuniform three-event control, the primitive endpoint entry is zero,
  the elementary measured response is `-3`, and the leading FMS response is
  `-12` in the supplied unnormalized radial coordinate.

Claim grade: `M [comp]`.

## Scope boundary

This is finite leading-response algebra. It does not control higher FMS terms,
derive a continuum scalar pole, establish LSZ normalization, derive a vertex
measure, or predict the observed Higgs mass.

## Provenance

Project-internal composition of
`HiggsGaugeInvariantRetardedPropagation.lean` and
`HiggsStrictPastMeasuredResolvent.lean`. No external proof text or
implementation was copied.

## Verification

- Production SHA-256:
  `4EA1F707A6CC54E7696CD1EEA84F90B9792256044F2259DC453EE022159001D2`
- `lake env lean PhysicsSM/Draft/NullEdge/HiggsGaugeInvariantMeasuredPropagation.lean`
- `lake build PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantMeasuredPropagation`
  (8,038 jobs)
- Lean LSP error diagnostics: empty
- `lean_verify` on `strictPast_fmsLeading_measured_two_sided_resolvent` and
  `threeLink_fmsLeading_measured_intermediate_witness`: standard three axioms,
  no source warnings

There are no proof holes or linter warnings in this module. The targeted build
replayed inherited nonfatal linter suggestions from dependencies.
