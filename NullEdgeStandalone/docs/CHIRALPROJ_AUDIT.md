# chiralProj Audit

Date: 2026-07-01

Target:

```text
PhysicsSM.Draft.NullEdgeHyperdiamondNoGo.chiralProj
```

## What chiralProj Is

`chiralProj` is a spinor-space map:

```text
(Spin -> Complex) -> (Spin -> Complex)
```

It is defined pointwise from `gamma5` and the model sign `g5 a`.

Lean-backed facts:

- `gamma5_chiralProj`: its image lies in the `gamma5 = g5 a` eigenspace.
- `chiralProj_forces_alignment`: if this projector is added, it supplies enough
  data to force a single selected chirality.
- `chiralProj_cuts_kernel`: it keeps one bare kernel mode and kills the
  independent opposite-chirality mode.
- `chiralProj_idempotent`: it is a genuine idempotent projector.

These are sufficiency and structural facts. They are not a physical release
theorem.

## What Is Still Missing

To upgrade `chiralProj` from sufficient chirality projector to physical
projected-operator data, the project still needs:

- Locality or finite range: the current object has no position-space kernel.
- Gauge covariance: no gauge connection or transformation law is in scope.
- Krein sign: the current object carries no indefinite metric or ghost-sign
  audit.
- Operator-derived branch data: `g5 a` is a model input, not a sign computed
  from `cliffordSymbol (branchP a)`.

The bare operator cannot supply the selected sign by itself:
`no_full_symbol_single_chirality` proves that the bare high-momentum branch
kernel is chirality-balanced.

## Claim Separation

- No-go: the bare symbol cannot fix a branch chirality sign.
- Sufficiency: `chiralProj` is an idempotent projector that selects one sign if
  it is added.
- Conditional schema: projected/Wilson release APIs remain frozen packaging.
- Physical release: absent until locality, gauge covariance, Krein sign, and
  operator-derived branch data are proved for a concrete operator.
