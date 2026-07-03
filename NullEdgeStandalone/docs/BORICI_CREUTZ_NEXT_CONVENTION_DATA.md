# Borici-Creutz Convention Data Still Needed

Date: 2026-07-01

This note records the result of the Aristotle job that tried to instantiate a
source Borici-Creutz convention into `BoriciCreutzConventionData` and prove
either `BoriciCreutzNearestPrincipalCrosswalk data` or a precise mismatch
theorem.

## Decision

Do not fake an instantiation. The standalone package does not yet contain the
numeric data required to instantiate a named Borici-Creutz operator honestly.
In particular it lacks:

1. an explicit gamma-matrix basis matching a chosen source, such as Creutz
   0712.1201 or Borici 0712.4401, with the ordering fixed against this package's
   `Spin = Fin 2 ⊕ Fin 2` block convention and `gamma5 = fromBlocks 1 0 0 (-1)`;
2. the four hopping covectors of the source in the same coordinates as the
   tetrahedral covectors `alpha a` used by `pCov` and `cliffordSymbol`;
3. the phase and normalization constants of the source kinetic term;
4. the fifth-vector term, including the source value of `Gamma` and its
   coefficient;
5. the shifted onsite or mass-counterterm data used to fix the pole locations;
6. the flavored mass or modified chirality operator, which is not plain
   spacetime `gamma5`.

Because the actual operator symbol is not present, neither a genuine
`GateCPrincipalCrosswalk (data.nearestNeighborStencil)` proof nor a genuine
source-operator mismatch theorem can be written without inventing constants.

## Added Lean Scaffold

`PhysicsSM.Draft.NullEdgeHyperdiamondOperatorScaffold` now contains:

- `BoriciCreutzConventionData.RequiresFifthVector`;
- `BoriciCreutzConventionData.fullFirstOrderSymbol`;
- `HyperdiamondFirstOrderStencil.linearSymbol_zero`;
- `boriciCreutz_fullSymbol_ne_nearest_of_requiresFifthVector`.

Interpretation: `nearestNeighborStencil` structurally omits the fifth-vector
data. If a convention has a nonzero fifth-vector coefficient, then its full
first-order symbol differs from the nearest-neighbor symbol. Therefore, even a
successful Gate C crosswalk for the truncated nearest-neighbor part would not be
a full Borici-Creutz operator equivalence.

## Exact Source Equations Needed Next

To move from scaffold mismatch to an honest crosswalk or refutation for a named
operator, the next handoff should supply, from one fixed source with one fixed
basis:

- the momentum-space Dirac operator with numeric gamma matrices, fifth-vector
  matrix, and all coefficients in this package's `Spin` block basis;
- the pole locations in the same coordinates as `cornerU` and `tasteCorner`;
- the intended chirality operator, distinguishing plain `gamma5` from a
  flavored or modified chirality operator.

With those in hand, `data.edgeCoeff`, `data.edgePhase`, `data.onsite`,
`data.fifthVectorCoeff`, `data.poleLocation`, `data.normalization`, and
`data.flavoredChirality` can be filled with source-backed values, and
`GateCPrincipalCrosswalk data.nearestNeighborStencil` becomes a concrete matrix
identity to prove or refute.
