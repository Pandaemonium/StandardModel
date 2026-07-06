VERIFY (truth, not just proof) then prove-or-refute the one open handoff of the
NE-U4 full-slab extension: `slabFullBlock_centerWitness` in
`PhysicsSM/Draft/NullEdge/GateYM/SlabFullSpectrumGap.lean`. It CLAIMS the full
connected two-plaquette Wilson block (`slabFullBlock beta`, over G=Z2, trivial
rep) reduces to a two-state `FiniteFluxGapWitness` on its Z2 center sectors. This
is an EXISTENCE `s o r r y` whose TRUTH is not established - and two other
spectral/analytic `s o r r y`s this run turned out FALSE, so CHECK IT.

START: read `SlabFullSpectrumGap.lean` (esp. `slabFullBlock`,
`slabFullBlock_centerWitness` header + caveat), `SlabTransferGap.lean`,
`WilsonSlabConnected.lean`, `TwoStateTransferZ2Sector.lean` (FiniteFluxGapWitness).
Check with `lean env lean`. If broader `lake build` stalls, SKIP.

## Task

1. Compute `slabFullBlock beta` EXPLICITLY as a concrete finite matrix (it is the
   rpBlockMatrix of the connected slab's Wilson weight over Z2, trivial rep -
   finite and computable). Determine its actual spectrum / center-sector
   decomposition.
2. DECIDE: does it genuinely reduce to a TWO-STATE `FiniteFluxGapWitness` on the
   Z2 center sectors (vacuum + one flux), or does the connected block have MORE
   than two relevant eigenvalues / a different center structure?
   - If TRUE: PROVE `slabFullBlock_centerWitness` (construct the explicit witness
     W with W.transfer = slabFullBlock.mulVecLin), discharging the sorry ->
     `slabFullClosureGap_pos` becomes unconditional.
   - If FALSE: produce a kernel-checked REFUTATION (like the run's other verified
     negatives) + the corrected statement (the true center structure of the full
     block), and report it.

## Constraints

- Do not edit `SlabFullSpectrumGap` in place if refuting; put the resolution in a
  NEW module `SlabCenterWitness.lean` (proof) or report the refutation. No new
  `a x i o m`, `n a t i v e _ d e c i d e`, weakening. Standard axioms for the
  proof; a documented negative is a valid result. If `lake build` stalls, SKIP;
  return the explicit matrix + verdict.
