# Hyperdiamond Operator Scaffold

Date: 2026-07-01

Lean module:
`PhysicsSM.Draft.NullEdgeHyperdiamondOperatorScaffold`.

## Purpose

The existing bridge proves exact frame, covector, and symbol-square facts, but
it does not define a named hyperdiamond or Borici-Creutz finite-difference
operator. This scaffold adds the missing Lean-facing landing zone without
claiming that the operator has been found.

## New Lean surface

- `HyperdiamondFirstOrderStencil`: four tetrahedral edge coefficients plus an
  onsite matrix.
- `fourierSymbol`: abstract finite Fourier symbol in edge phase variables.
- `linearSymbol`: linear/principal symbol extracted from edge coefficients.
- `coefficientSupport_card_le_four`: finite-support bookkeeping for the four
  edge coefficients.
- `GateCPrincipalCrosswalk`: exact predicate saying the stencil principal
  symbol equals the Gate C Clifford symbol.
- `crosswalk_linearSymbol_sq`: any such crosswalk inherits the Gate C kinetic
  square law.
- `crosswalk_branch_kernel_balanced`: any such crosswalk inherits the balanced
  bare branch kernel.
- `crosswalk_no_single_chirality`: any such crosswalk inherits the bare-symbol
  no-go, so a physical construction must add more than this principal symbol.
- `ProjectorAlgebraicAudit` and `chiralProj_algebraicAudit`: the current
  `chiralProj` supplies only algebraic sufficiency.
- `ProjectorPhysicalAudit`: locality, gauge covariance, Krein compatibility,
  and operator-derived branch data remain explicit obligations.
- `gateCStencil`: the Gate C Clifford symbol packaged as a four-edge first
  order stencil.
- `gateCStencil_crosswalk`: exact proof that this packaged Gate C stencil has
  the Gate C principal symbol.
- `gateCStencil_no_single_chirality`: inherited bare-symbol no-go for this
  packaged stencil.
- `BoriciCreutzConventionData`: explicit convention-data scaffold for a named
  Borici-Creutz/hyperdiamond operator comparison.
- `BoriciCreutzNearestPrincipalCrosswalk`: audit predicate for the four-edge
  nearest-neighbor principal part.
- `boriciCreutzNearest_no_single_chirality`: if that nearest-neighbor principal
  part equals Gate C, it inherits the same bare chirality no-go.
- `BoriciCreutzConventionData.RequiresFifthVector` and
  `BoriciCreutzConventionData.fullFirstOrderSymbol`: explicit full-symbol
  scaffold that records the fifth-vector term omitted by the nearest-neighbor
  stencil.
- `boriciCreutz_fullSymbol_ne_nearest_of_requiresFifthVector`: if the
  fifth-vector coefficient is nonzero, the full first-order symbol differs from
  the nearest-neighbor symbol.
- `FullFirstOrderSymbol`: abstract full first-order symbol with four edge
  variables and one fifth-vector variable.
- `IsExcitation`: source-side pole/excitation predicate, recorded as nonzero
  kernel data for an abstract symbol.
- `RealizedByFourEdgeStencil`: predicate that a full symbol is reproduced by a
  four-edge stencil.
- `GenuineFifthVectorDependence` and `PoleStructureNeedsFifthVector`: abstract
  source-side requirements that the fifth-vector variable changes the symbol or
  its excitation set.
- `not_realizedByFourEdgeStencil_of_genuineFifthVectorDependence` and
  `not_realizedByFourEdgeStencil_of_poleStructureNeedsFifthVector`: no-go
  theorems for four-edge stencils.
- `hyperdiamond_no_four_edge_pole_structure`: source-independent theorem that a
  convention requiring a nonzero fifth-vector term cannot have its full symbol
  realized by a four-edge nearest-neighbor stencil.

## Best next theorem

The generic API is now instantiated by `gateCStencil`, but that is only the Gate
C symbol repackaged as a stencil. The package also has
`BoriciCreutzConventionData`, which records the convention choices needed before
making a named-operator claim. The source-independent no-four-edge/fifth-vector
obstruction is now proved.

The next theorem needs a named convention from the hyperdiamond or Borici-Creutz
literature and should prove one of:

```lean
GateCPrincipalCrosswalk concreteStencil
```

or a precise mismatch theorem identifying the sign, phase, basis, or
normalization obstruction.

or:

```lean
PoleStructureNeedsFifthVector concreteData.fullSymbol
```

These are the main 3+1D reconstruction targets. They should precede any attempt
to claim a physical projected operator or a Nielsen-Ninomiya theorem instance.
The fifth-vector mismatch and no-four-edge pole-structure theorems already show
that a nearest-neighbor crosswalk, even if proved, would not by itself be a full
Borici-Creutz equivalence.
