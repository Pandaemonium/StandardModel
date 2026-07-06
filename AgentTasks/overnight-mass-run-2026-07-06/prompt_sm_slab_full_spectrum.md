Close the ONE documented handoff of the NE-U4 closure-gap rung: extend the
sector-restricted mass gap from the exactly-solvable Z2 ONE-LINK center sector to
the FULL connected two-plaquette Wilson slab's own Gram spectrum. This upgrades
"mass is the cost of closure" from the one-link toy to the genuine connected slab.

START: read `PhysicsSM/Draft/NullEdge/GateYM/SlabTransferGap.lean` (just landed):
it proves `slabRPBlock_posSemidef` (the PSD Gram block of the connected slab, arb
G), `slabTransferBlock` (PSD + Hermitian), and `neU4_closure_gap_pos` on the Z2
one-link center sector; the documented handoff at the END of the file is exactly
the full-block extension. Also read `WilsonSlabConnected.lean` (the slab),
`ReflectionPositivityKernel.lean` (`rpBlockMatrix`), `FluxSectorZ2.lean` /
`TwoStateTransferZ2Sector.lean` (center sectors, `fluxGap`). Check with
`lake env lean`. If broader `lake build` stalls, SKIP.

Create a NEW module `PhysicsSM/Draft/NullEdge/GateYM/SlabFullSpectrumGap.lean`
(do NOT edit SlabTransferGap in place).

## Target

For the connected two-plaquette slab over `G = Z2` with the trivial rep,
diagonalize the connected slab's OWN transfer Gram block
(`slabTransferBlock (G := Z2)` / the `rpBlockMatrix` of `slabWeightMirror`) into
its Z2 CENTER sectors, and prove:

1. `slabFullBlock_sector_decomp` : the connected-slab transfer block restricted to
   each center sector (vacuum / nontrivial-flux) acts as a scalar (its center
   eigenvalue), analogous to `TwoStateTransferZ2Sector.transfer_scalar_on_*`.
2. `slabFullClosureGap` (def) + `slabFullClosureGap_pos` : the gap between the
   vacuum center-sector eigenvalue and the lightest nontrivial center-flux
   eigenvalue of the FULL connected block is strictly positive - the honest
   `FluxSectorZ2.fluxGap` of the two connected-block center eigenvalues (NOT
   `localGlueballGap`; keep sectors disjoint).
3. If clean, tie it to the one-link result: relate `slabFullClosureGap` to
   `neU4ClosureGap` (they should agree up to the two-plaquette multiplicity /
   the `-log tanh` scaling), or state the relationship as a proved corollary.

## Constraints

- Reuse `SlabTransferGap`, `WilsonSlabConnected`, `ReflectionPositivityKernel`,
  `FluxSectorZ2`, `TwoStateTransferZ2Sector`; do not redefine them.
- Respect the center-vs-local honesty fix: gap between DISTINCT center sectors.
- Do NOT claim a physical mass gap beyond a finite sector-restricted spectral
  ratio on this concrete connected slab. F-YM-CONFLATE; continuum out.
- No new `a x i o m`, `n a t i v e _ d e c i d e`, statement weakening. A
  documented handoff `s o r r y` on the hardest node (the explicit
  eigen-decomposition) is acceptable if you prove the sector-scalar structure and
  reduce the gap to a concrete residual.
- Claim label: finite identity (full connected-slab center-flux gap). If
  `lake build` stalls, SKIP; return source.
