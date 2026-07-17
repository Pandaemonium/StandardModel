# Gauge-invariant finite Higgs radial propagation

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Claim grade: `M [comp]`

## Objective

Compose the finite strict-past radial Higgs resolvent with the corrected
gauge-invariant FMS leading-response kernel.

## Result

For the one-component control vacuum, the leading gauge-invariant radial
kernel obeys the same exact left and right finite resolvent equations as the
elementary massive radial response. At nonzero vacuum it has exactly the same
entrywise support. The three-event control has no primitive endpoint hop, an
elementary two-link massive response `-1`, and leading FMS endpoint response
`-4` in the supplied unnormalized radial coordinate.

This does not prove higher-term suppression, a continuum pole, LSZ
normalization, or the observed Higgs mass.

## Provenance

Project-internal composition of `HiggsFMSRadialObservable` and
`HiggsMassiveRetardedPropagation`. The scalar finite-series orientation is
documented in the predecessor module.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/HiggsGaugeInvariantRetardedPropagation.lean`
- `lake build PhysicsSM.Draft.NullEdge.HiggsGaugeInvariantRetardedPropagation`
  (8,034 jobs)
- Lean LSP error diagnostics: empty
- Axiom/source audit of `unitRadialMass_threeLink_fms_multiedge_witness`:
  only `propext`, `Classical.choice`, and `Quot.sound`; no warnings
