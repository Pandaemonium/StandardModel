# Null-edge Higgs radial-curvature control

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: implemented and verified

## Question

What supplies the mass of the Higgs excitation itself if a parallel Higgs
vacuum has zero null-edge kinetic cost?

## Exact result

`PhysicsSM/Draft/NullEdge/HiggsRadialCurvature.lean` expands the existing
one-component radial potential along `phi(h) = vacuum + h` and identifies its
quadratic coefficient as

```text
(1 / 2) * radialMassSquared * h^2,
radialMassSquared = 8 * lam * vacuum^2.
```

Thus a positive supplied quartic coupling and nonzero supplied vacuum give a
positive radial mass squared even though the parallel vacuum has zero edge
kinetic response. Conversely, the vacuum value alone is insufficient: the
radial mass vanishes when the quartic coupling does.

## Scope boundary

The factor eight is specific to the one-component potential convention
`lam * (normSq phi - vacuum^2)^2`. It must not be quoted as the Standard Model
doublet normalization without an explicit field/coupling conversion. This is
not a derivation of the potential, electroweak vacuum, running coupling,
continuum Higgs pole, or measured 125 GeV mass.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/HiggsRadialCurvature.lean`
- `lake build PhysicsSM.Draft.NullEdge.HiggsRadialCurvature` (8028 jobs)
- Lean MCP diagnostics: clean
- Lean MCP axiom/source audit: standard three axioms and no source warnings for
  the exact expansion, mass-term normalization, and positivity theorem
