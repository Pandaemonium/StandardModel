Turn the newly-built CONNECTED Wilson slab into a first PHYSICAL transfer
operator with a sector-restricted finite mass gap - the NE-U4 rung ("mass is the
cost of closure"). This is a PROOF job on a concrete object (not a design job):
the connected slab now exists, so the abstract gap API finally has a non-toy
consumer.

START: read `PhysicsSM/Draft/NullEdge/GateYM/WilsonSlabConnected.lean` (just
landed): the connected `2x1` cut slab `slabLattice` / `slabReflection`, the
two-plaquette family `slabPlaqFamily` sharing cross-cut link `cut1`, the mirror
config `slabMirrorConfig`, and the proved
`wilsonSlabConnected_reflectionPositive`
(`ReflectionPositivityKernel.IsReflectionPositive` for arbitrary finite `G`).
Also read `ReflectionPositivityKernel.lean` (`rpBlockMatrix`,
`rpBlockMatrix_posSemidef_of_reflectionPositive`),
`TransferHilbertBlock.lean` / `TransferGapDefinition.lean`
(`finiteMassGap`, `FiniteGapAssembly`), `FluxSectorZ2.lean` /
`TwoStateTransferZ2Sector.lean` (the honest center-flux gap: `FluxSectorZ2.fluxGap`,
the sector membership/disjointness fields, and the local-vs-center-sector
honesty fix - RESPECT it). Check with `lake env lean`. If broader `lake build`
stalls, SKIP and return source.

Create a NEW module `PhysicsSM/Draft/NullEdge/GateYM/SlabTransferGap.lean`.

## Deliverable (in dependency order; prove as far as you get, freeze the rest)

1. **Feed the slab RP into `rpBlockMatrix`.** From
   `wilsonSlabConnected_reflectionPositive`, obtain the PSD Gram matrix
   `rpBlockMatrix ... |>.PosSemidef` for the connected slab weight, via
   `rpBlockMatrix_posSemidef_of_reflectionPositive`. This is the first PHYSICAL
   (non-2x2-toy) positive block from a genuine interacting Wilson ensemble.
2. **Construct the positive self-adjoint transfer operator** on the GNS/transfer
   Hilbert space of that PSD block (reuse `TransferHilbertBlock` API). State it
   as `slabTransfer_posSemidef` / a `finiteMassGap`-ready operator.
3. **The SECTOR-RESTRICTED NE-U4 gap.** Specialize `G = Z2` (`Fin 2`) so the
   center sectors are concrete, and state + prove (or reduce to the existing
   `TwoStateTransferZ2Sector` machinery) that the gap between the vacuum
   (trivial center-flux sector) and the lightest NONtrivial center-flux sector
   is strictly positive: `neU4_closure_gap_pos : 0 < <sector-restricted gap>`.
   The honest reading is "the lightest CLOSED flux composite on the slab costs
   energy" - use `FluxSectorZ2.fluxGap`, NOT `localGlueballGap` (respect the
   center-vs-local honesty fix).
4. **(stretch) strong-coupling lower bound** tying the gap to the YM1 area-law
   flux cost, as a separate statement (may stay a documented handoff).

## Constraints

- Do NOT claim a physical mass gap beyond a finite sector-restricted
  spectral-ratio on this concrete slab. F-YM-CONFLATE: spectral gap vs Wilson
  area law vs entanglement stay distinct. Continuum out.
- Respect the center-sector honesty fix: the gap is between DISTINCT center-flux
  sectors, not within the trivial sector.
- Reuse `WilsonSlabConnected`, `ReflectionPositivityKernel`, `TransferHilbertBlock`,
  `TransferGapDefinition`, `FluxSectorZ2`, `TwoStateTransferZ2Sector` - do not
  redefine them.
- No new `a x i o m`, `n a t i v e _ d e c i d e`, statement weakening. A
  documented handoff `s o r r y` on the heaviest node (e.g. the GNS
  self-adjointness or the strong-coupling bound) is acceptable if you assemble
  nodes 1-2 and reduce node 3 to a concrete residual.
- Claim label: finite identity (sector-restricted gap on a concrete connected
  slab); draft-trust. If `lake build` stalls, SKIP; return source + DAG.
