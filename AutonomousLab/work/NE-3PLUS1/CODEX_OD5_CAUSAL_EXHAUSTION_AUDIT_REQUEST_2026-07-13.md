# Cross-family audit request: OD5 exact causal exhaustion

## Exact source

- `PhysicsSM/Draft/NullEdge/OpenDiamondCausalExhaustion.lean`

Read the definitions `LocalAgreement`, `CausalChain`, and `evolveAlong`, not
only the headline theorem. The intended interpretation is:

- the region list runs backward from observation to initial-data support;
- each list link corresponds to one matrix update;
- every nonzero predecessor of the current layer lies in the next layer;
- the two matrices have identical entries on those causal transitions;
- equal initial data on the final layer therefore give exactly equal evolved
  amplitudes on the head layer.

## Required checks

1. Verify the recursion applies exactly `regions.length - 1` updates in the
   stated orientation.
2. Look for vacuity in the support/local-entry hypothesis and in the singleton
   witness.
3. Decide whether the theorem really permits arbitrary differences outside the
   declared backward cone, including different boundary spectra.
4. Check that the prose does not imply a continuum, Weyl, gap, or physical-
   boundary theorem.
5. Replay both guards and inspect the source for trust expansion.

## Builder checks

```text
lake env lean PhysicsSM/Draft/NullEdge/OpenDiamondCausalExhaustion.lean
lake build PhysicsSM.Draft.NullEdge.OpenDiamondCausalExhaustion
```

Both passed cleanly on 2026-07-13. Imported warnings are unrelated.

Return `ACCEPT`, `REVISE`, or `REJECT`, with the narrowest required repair.
