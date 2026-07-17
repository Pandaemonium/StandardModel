# Higgs vacuum stress and equation of state

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Claim grade: `M [comp]`

## Objective

Specialize the finite Higgs Hilbert-stress bridge to a covariantly constant
configuration and isolate the vacuum-energy channel.

## Result

For zero supplied derivative components and constant potential density `V0`,
the finite stress coefficient is exactly `T_ab = V0 * g_ab`. In the supplied
orthonormal `(+---)` metric, the energy density is `V0` and every principal
pressure is `-V0`, so `p = -rho`. The determinant-compatible inverse-metric
response remains exactly one half of the measure-weighted stress pairing.

This proves that zero Higgs link variation does not erase a nonzero vacuum
source. It does not derive, predict, or suppress `V0`, identify a graph-derived
metric, or prove a continuum Einstein equation.

## Provenance

Project-internal specialization of
`HiggsHilbertStress.volumeCompatible_response_eq_hilbert_pairing` using the
project's inverse-metric response and mostly-minus conventions.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/HiggsVacuumStress.lean`
- `lake build PhysicsSM.Draft.NullEdge.HiggsVacuumStress` (8,027 jobs)
- Lean LSP diagnostics: empty
- Axiom audit of `constantVacuum_mostlyMinus_equationOfState`: only
  `propext`, `Quot.sound`, and `Classical.choice`; no warnings
