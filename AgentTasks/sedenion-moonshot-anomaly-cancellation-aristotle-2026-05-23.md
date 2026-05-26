# Aristotle M4: anomaly-cancellation analogue moonshot

Create or modify the draft Lean module:

```text
PhysicsSM/Draft/Sedenions/AnomalyCancellationAnalogue.lean
```

## Big Goal

Test whether the zero-divisor plaquette system has an anomaly-cancellation-like
linear or cubic constraint structure.

This is not a claim about the Standard Model.  The aim is to produce a precise
finite analogue:

```text
zero-product cancellation channels impose parity or charge constraints whose
solution space is the Reed-Muller-derived code already seen in the support
geometry.
```

If a cubic charge analogue is too much, a clean linear/parity theorem is already
valuable.

## Existing Context

Use:

```text
PhysicsSM.Draft.Sedenions.ReedMullerCode
PhysicsSM.Draft.Sedenions.CocycleQuadraticPhase
PhysicsSM.Draft.Sedenions.GL32Action
```

Known existing facts include:

- `ReedMuller.cZD`
- `ReedMuller.cZD_eq_shortRM24`
- `ReedMuller.cZD_rank_eq`
- `ReedMuller.cZD_weightEnumerator`
- `ReedMuller.sameStrutSpan_eq_cZD`
- `CocycleQuadraticPhase.zeroProdSupportList`
- `CocycleQuadraticPhase.sameStrutList`

## Desired Theorems

Define a finite constraint system on `Fin 16` charges or binary fields.

Possible theorem targets:

- The span of zero-product cancellation constraints equals `cZD`.
- The orthogonal constraint space has a computed dimension and an explicit
  basis.
- The forced-zero coordinates `0` and `8` are exactly the distinguished fixed
  coordinates in the doubled-shortened RM(2,4) description.
- Optional: define a toy cubic sum over plaquettes and prove it vanishes for
  a canonical family of charge assignments.

Suggested public theorem names:

```lean
theorem cancellation_constraint_span_eq_cZD : ...
theorem cancellation_charge_nullspace_dim : ...
theorem forced_zero_coordinates_are_exactly_zero_and_eight : ...
```

## Constraints

- Keep physics language in docstrings and comments; theorem statements should
  be finite algebra/code statements.
- Do not assert Standard Model anomaly cancellation from this finite model.
- No axioms, opaque constants, unsafe code, or admits.
