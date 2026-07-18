# Corrected-pairing selected-sector witness

Date: 2026-07-16
Work item: `GRAV-ORDER-OPERATOR-001`
Status: kernel-checked

## Result

`PhysicsSM/Draft/NullEdge/CorrectedPairingSelectedSectorWitness.lean`
bridges the normalized five-event production carrier witness into the
`RankFourCarrierProbeSector` API used by the refinement program.

- `fiveEventTopSector` packages the full five-event zero-sum carrier space as
  a selected rank-four sector.
- `fiveEventTopSector_gram_eq_carrierGram` proves that the selected-sector Gram
  matrix is exactly the existing production carrier Gram matrix.
- `fiveEventTopSector_hasLorentzianInertia` proves the exact
  `HasSectorLorentzianInertia` predicate at equal nonzero scales.

This is an API bridge only. It does not derive a selector on larger carriers,
a four-mode gap, overlap compatibility, refinement persistence, or a continuum
limit.

Lean source SHA-256:
`fd9e202b9ac07983364b4dc941e2dbbcdfbc1faccf790d6d295c2e27d69b1046`.

## Verification

`lake build PhysicsSM.Draft.NullEdge.CorrectedPairingSelectedSectorWitness`
passed 8,040 jobs. The flagship theorem's in-file axiom guard pins exactly
`propext`, `Classical.choice`, and `Quot.sound`.
