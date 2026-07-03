# No-Four-Edge Pole Structure Report

Date: 2026-07-02

Lean module:
`PhysicsSM.Draft.NullEdgeHyperdiamondOperatorScaffold`.

## What Was Proved

The target `hyperdiamond_no_four_edge_pole_structure` is now represented and
proved in a source-independent form. No source constants were invented: signs,
phases, normalization, pole locations, shifted onsite/fifth-vector matrices,
basis order, and chirality convention all remain explicit future data.

New source-side predicates:

- `FullFirstOrderSymbol`: an abstract full first-order symbol in four
  tetrahedral edge variables and one fifth-vector variable.
- `IsExcitation`: the symbol has a nonzero kernel vector at the given momentum
  data.
- `RealizedByFourEdgeStencil`: a full symbol is reproduced by some four-edge
  `HyperdiamondFirstOrderStencil`.
- `GenuineFifthVectorDependence`: the symbol changes when the fifth-vector
  variable changes.
- `PoleStructureNeedsFifthVector`: the excitation/pole set changes when the
  fifth-vector variable changes.

New theorems:

- `RealizedByFourEdgeStencil.const_in_fifth`;
- `RealizedByFourEdgeStencil.isExcitation_w_indep`;
- `not_realizedByFourEdgeStencil_of_genuineFifthVectorDependence`;
- `not_realizedByFourEdgeStencil_of_poleStructureNeedsFifthVector`;
- `boriciCreutz_fullSymbol_genuineFifthVectorDependence`;
- `hyperdiamond_no_four_edge_pole_structure`.

## Meaning

A four-edge nearest-neighbor stencil has a linear symbol depending only on the
four edge variables. It cannot carry a genuine fifth-vector variable. Therefore
any full first-order symbol whose fifth-vector coefficient is required and
nonzero cannot be realized by such a four-edge stencil.

This is a no-go theorem for an abstract source-side convention datum. It is not
a named Borici-Creutz equivalence theorem, and it does not yet prove a concrete
source pole location.

## Missing Source Data

To turn the abstract no-go into a named-operator pole-structure no-go, one fixed
source convention must provide:

- gamma-matrix basis matched to `Spin = Fin 2 Sum Fin 2` and project `gamma5`;
- four source hopping covectors in the same coordinates as `alpha`;
- kinetic phase and normalization constants;
- fifth-vector matrix and coefficient;
- shifted onsite or mass-counterterm data fixing pole locations;
- chirality convention, including whether it is plain spacetime `gamma5` or a
  flavored/modified chirality operator.

With that data, the next finite identity is:

```text
PoleStructureNeedsFifthVector data.fullSymbol
```

This requires an explicit nonzero kernel vector at one source pole and a
contrasting non-pole or trivial-kernel point.

## Ranked Next Steps

1. `hyperdiamond_fullSymbol_excitation_finite_identity`
   Claim type: finite identity. Instantiate source constants and prove the
   explicit pole/non-pole kernel facts.

2. `hyperdiamond_operator_crosswalk_exact`
   Claim type: reconstruction / equivalence. Instantiate
   `BoriciCreutzConventionData` and prove the nearest-principal crosswalk or a
   precise source-specific mismatch.

3. `chiralProj_physical_audit`
   Claim type: structural guardrail. Replace free locality, gauge, Krein, and
   operator-derived branch-data obligations with concrete predicates.

4. `nielsenNinomiya_assumption_instance`
   Claim type: no-go / audit theorem. Promote the represented-data ledger only
   after locality, Krein self-adjointness, exact chiral symmetry, index
   transport, and gauge covariance have Lean referents.
