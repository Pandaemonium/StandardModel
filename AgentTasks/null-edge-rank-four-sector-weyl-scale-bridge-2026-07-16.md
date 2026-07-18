# Null-edge selected-sector Weyl scale bridge

Date: 2026-07-16

Work item: `GRAV-GROWING-ATLAS-001`

Status: kernel-checked; graph-native scale inputs open

## Correction

The existing operator scaling law is basis-free and valid on carriers of any
size, but its Gram-matrix corollaries were stated using a four-frame of the
entire zero-sum probe space. The rank-four semantic audit shows that this old
frame type can exist only on five-event carriers.

`RankFourSectorWeylScaleBridge.lean` ports the Gram statements to a frame of a
selected rank-four sector. No operator formula or scale exponent changes.

## Finite result

If both length parameters of the active smeared causal operator are multiplied
by a nonzero factor `lambda`, then:

```text
sector corrected pairing -> lambda^(-2) times the pairing
sector Gram matrix        -> lambda^(-2) times the Gram matrix.
```

The row-coframe metric bridge transforms covariantly with `lambda^2`.
Therefore the same count-derived relative length scale produces reciprocal
area factors on the covariant and contravariant objects.

The exact sixteen-to-one control remains:

```text
covariant metric factor = 4
selected-sector Gram factor = 1/4.
```

## What remains open

This is not yet bare-graph scale reconstruction. The finite theorem still
receives:

1. the selected rank-four sector;
2. a frame inside that sector;
3. coframe-volume data entering `relativeCountScale`;
4. positive count and volume hypotheses;
5. the local carrier and operator scales.

The next scale gate must separate what causal interval counts determine from
what a tetrad/coframe decoration supplies. In Malament language, causal order
continues to provide conformal information; the scale decoration owes the
missing volume normalization. An absolute unit remains outside the theorem.

## Claim boundary

- Simultaneous operator/sector scaling: finite `M` identity.
- Reciprocal count-scale factors: finite conditional `M` package.
- Bare-graph derivation of the scale inputs: open reconstruction gate.
- Continuum metric and Einstein constants: closed.

## Verification record

- Module SHA-256:
  `9b7609f5840c3d15b06a8b7ef51cfeba4d01ebe866a4f9896db93d2c0fa6bc81`.
- `lake env lean PhysicsSM/Draft/NullEdge/RankFourSectorWeylScaleBridge.lean`
  passed with no diagnostics.
- `lake build PhysicsSM.Draft.NullEdge.RankFourSectorWeylScaleBridge` passed
  (`8044` jobs).
- Build-enforced guards report only `propext`, `Classical.choice`, and
  `Quot.sound` for sector Gram scaling, the reciprocal count/Weyl package, and
  the nonunit `4` versus `1/4` witness.
