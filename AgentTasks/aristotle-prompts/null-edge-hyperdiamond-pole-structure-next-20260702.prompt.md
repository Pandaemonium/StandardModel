# Null-edge hyperdiamond pole-structure/source-convention Aristotle job

You are working in the standalone Lean 4 package `NullEdgeStandalone`.

## Build commands

Run the narrow check first:

```powershell
lake env lean PhysicsSM/Draft/NullEdgeHyperdiamondOperatorScaffold.lean
```

If it passes, run:

```powershell
lake build NullEdgeStandalone
```

## Current verified state

The operator scaffold includes:

- `HyperdiamondFirstOrderStencil`;
- `GateCPrincipalCrosswalk`;
- `gateCStencil` and `gateCStencil_crosswalk`;
- `BoriciCreutzConventionData`;
- `BoriciCreutzNearestPrincipalCrosswalk`;
- `boriciCreutzNearest_no_single_chirality`;
- `BoriciCreutzConventionData.RequiresFifthVector`;
- `BoriciCreutzConventionData.fullFirstOrderSymbol`;
- `HyperdiamondFirstOrderStencil.linearSymbol_zero`;
- `boriciCreutz_fullSymbol_ne_nearest_of_requiresFifthVector`.

Relevant docs:

```text
NullEdgeStandalone/docs/BORICI_CREUTZ_NEXT_CONVENTION_DATA.md
NullEdgeStandalone/docs/HYPERDIAMOND_BORICI_CREUTZ_LITERATURE_REVIEW.md
NullEdgeStandalone/docs/HYPERDIAMOND_OPERATOR_SCAFFOLD.md
NullEdgeStandalone/docs/GATE_C_ASSUMPTION_LEDGER.md
```

## Requested work

Work on the next hyperdiamond target:

```text
hyperdiamond_no_four_edge_pole_structure
```

Do as much Lean work as possible without inventing source constants. High-value
deliverables, in priority order:

1. Define source-side pole/excitation predicates that make a no-four-edge
   theorem precise. Keep them as data/predicates, not physical claims.
2. Prove any source-independent theorem showing that a four-edge
   nearest-neighbor stencil cannot represent a full first-order symbol with a
   required nonzero fifth-vector component.
3. If a stronger no-four-edge pole/excitation theorem is not yet formally
   possible, add the missing Lean predicate scaffold and a report explaining the
   exact source equations and finite hypotheses needed.
4. Recommend the next most important Lean statement, with claim labels:
   finite identity, no-go theorem, reconstruction target, analytic scaffold, or
   physical non-claim.

## Constraints

- Do not instantiate a named Borici-Creutz operator unless all signs, phases,
  normalization, pole locations, shifted onsite/fifth-vector data, basis order,
  and chirality convention are explicit.
- Do not claim `gateCStencil` is a Borici-Creutz equivalence.
- Keep the null-edge difference direction distinct from the dual covector
  Clifford soldering direction.
- Keep spacetime chirality and flavored/modified chirality separate.

## Desired output

Return:

1. modified Lean/docs files;
2. exact commands run and whether they passed;
3. semantic review of new theorem statements;
4. ranked next steps.
