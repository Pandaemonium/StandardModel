# Finite Higgs massive retarded propagation

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Claim grade: `M [comp]`

## Objective

Turn the qualitative distinction between primitive null-link transport and a
massive Higgs excitation into one finite theorem. Combine strict-past kernel
nilpotence, the finite massive retarded series, and the radial curvature of the
one-component Higgs control potential.

## Result

`strictPast_radialHiggs_resolvent` proves exact left and right finite resolvent
identities for the radial Higgs mass parameter on every weighted finite strict
order. `unitRadialMass_threeLink_multiedge_witness` supplies an explicit model:
the primitive endpoint entry vanishes, its two-link chain amplitude is one,
and the unit-radial-mass retarded endpoint amplitude is minus one.

This supports the interpretation that a Higgs excitation propagates through a
sum over causal link chains rather than occupying one null edge. It does not
prove a continuum pole, observed mass, or Standard Model field normalization.

## Provenance

Project-internal composition of:

- `FiniteStrictPastKernelMatrix.weightedPastKernelMatrix_pow_card_add_one_eq_zero`;
- `MassiveRetardedLinkSeries` (Aristotle task
  `a5d949fc-a102-48bb-ac34-824874df32f7`); and
- `HiggsRadialCurvature.radialMassSquared`.

The massive-series algebra is based on the clean-room causal-set constructions
documented in `MassiveRetardedLinkSeries.lean`.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/HiggsMassiveRetardedPropagation.lean`
- `lake build PhysicsSM.Draft.NullEdge.HiggsMassiveRetardedPropagation`
  (8,032 jobs)
- Lean LSP diagnostics: empty.
- `lean_verify` on `unitRadialMass_threeLink_multiedge_witness`: only
  `propext`, `Classical.choice`, and `Quot.sound`; no source-scan warnings.
- Headline results carry build-enforced assumption-footprint guards.
