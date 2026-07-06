Design + statement-freeze the bridge from the EXISTING reflection-positive
Wilson cut-plaquette ensemble to a PHYSICAL transfer operator with a
sector-restricted finite mass gap - the NE-U4 rung ("the mass gap as closure
cost"). This is a DESIGN / statement-layer job: compiling theorem signatures and
a lemma DAG, proofs optional where heavy.

Existing pieces (reuse; do not redefine):
- `WilsonCutPlaquetteEnsemble.reflectionPositive_of_hol_factorization` : gives
  `ReflectionPositivityKernel.IsReflectionPositive` for a factorizing Wilson
  ensemble.
- `ReflectionPositivityKernel.rpBlockMatrix` + `rpBlockMatrix_posSemidef_of_
  reflectionPositive` : the PSD Gram matrix from an RP kernel.
- `TransferHilbertBlock` / `TransferGapDefinition.finiteMassGap` /
  `FiniteGapAssembly` / `TwoStateTransferZ2L1` : the transfer-Hilbert-space and
  finite-gap API (currently instantiated only on the 2x2 toy).
- `FluxSectorZ2` and `TwoStateTransferZ2Sector` (the honest CENTER-sector
  bridge: `FluxSectorZ2.fluxGap`, sector membership/disjointness fields).

Create a NEW module `PhysicsSM/Draft/NullEdge/GateYM/TransferGapFromRP.lean`.
Check with `lake env lean`. If broader `lake build` stalls, SKIP and return
source.

## Deliverable (design + statement freeze)

1. **The bridge signature.** State the theorem shape: from an
   `IsReflectionPositive` Wilson ensemble on a cut lattice, construct (via
   `rpBlockMatrix` PSD) a positive self-adjoint transfer operator on the
   GNS/transfer Hilbert space, and define its spectral gap. Freeze the
   statement `rp_ensemble -> exists positive self-adjoint transfer operator T
   with finiteMassGap`.
2. **The SECTOR-RESTRICTED NE-U4 gap statement.** The physically honest shape:
   the gap is between the vacuum (trivial center-flux sector) and the lightest
   NONtrivial center-flux sector state - "the lightest CLOSED flux composite
   costs energy." Use the honest sector bridge (`FluxSectorZ2.fluxGap`,
   NOT `localGlueballGap`; the `TwoStateTransferZ2Sector` module already fixed
   the local-vs-center-sector conflation - respect it). State
   `neU4_gap_is_closure_cost : sector-restricted finiteMassGap > 0` as the
   target, with the strong-coupling lower bound tied to the YM1 area-law flux
   cost as a separate frozen statement.
3. **Lemma DAG** (node : status : deps) mapping the path from
   `reflectionPositive_of_hol_factorization` output to the sector-restricted
   gap, marking which nodes are HAVE (already proved in the tree) vs NEW.
4. **Prove whatever falls cheaply** - especially the pure plumbing nodes
   (rpBlockMatrix instantiation, sector-membership discharge on a concrete
   ensemble). Heavy nodes may stay documented handoff `s o r r y`s.

## Constraints

- Do NOT claim a physical mass gap beyond a finite sector-restricted
  spectral-ratio definition. Every `finiteMassGap` positivity that is not on a
  concrete instance stays a frozen statement. F-YM-CONFLATE: keep spectral gap
  vs Wilson area law vs entanglement distinct.
- Respect the center-sector honesty fix: gap is between DISTINCT center-flux
  sectors, not within the trivial sector (that conflation is a known kill
  condition - see `TwoStateTransferZ2Sector`).
- No new `a x i o m`, `n a t i v e _ d e c i d e`, statement weakening.
  Draft-trust; label frozen statements clearly.
- If `lake build` stalls, SKIP; return source + DAG + proved-vs-frozen note.
