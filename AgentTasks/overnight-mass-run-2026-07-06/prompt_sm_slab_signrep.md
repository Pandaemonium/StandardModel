Establish a GENUINE full-slab center-flux gap using the CORRECTED representation.
A prior job proved that the full connected two-plaquette Wilson block is
flux-BLIND for the TRIVIAL rep (constant character -> no flux gap; see
`GateYM/SlabCenterWitness.lean`, `slabFullBlock_no_centerWitness`). The corrected
direction (stated there): use the SIGN representation of Z2, whose character
SEPARATES the Z2 classes, so the Wilson weight becomes flux-DEPENDENT and the
block genuinely splits into vacuum + flux center sectors with a positive gap.

Create a NEW module `PhysicsSM/Draft/NullEdge/GateYM/SlabSignRepGap.lean`. Check
with `lake env lean`. If broader `lake build` stalls, SKIP.

## Task

Use `G = Z2 = Multiplicative (ZMod 2)` with the SIGN representation
`signRho : Z2 -> Matrix (Fin 1) (Fin 1) C`, `signRho g = (if g = 1 then 1 else -1)`
(the nontrivial 1-dim rep; character `reChar signRho g = +-1`, separating the two
classes) - contrast the trivial rep's constant `+1`.
1. Compute the full connected block `slabSignBlock beta := rpBlockMatrix
   (slabWeightMirror beta signRho)` explicitly (as `SlabCenterWitness` did for
   the trivial rep). With the sign character the slab Wilson weight now DEPENDS on
   the cut/flux, so the block is NOT flux-blind.
2. Show it genuinely has a TWO-STATE center-flux structure: exhibit the vacuum
   (trivial center) and flux (nontrivial center) eigenvectors with eigenvalues
   `lambda0 > lambdaFlux > 0`, and construct the honest
   `TwoStateTransferZ2Sector.FiniteFluxGapWitness` whose transfer is the block
   (the analogue of the REFUTED trivial-rep center-witness, now TRUE).
3. Conclude `slabSignBlock_closureGap_pos : 0 < (that witness).fluxGap` - the
   genuine full-block NE-U4 gap.

## Constraints

- VERIFY the sign-rep block genuinely splits (compute eigenvalues explicitly); do
  NOT assume it. If it ALSO fails to give a two-state gap (e.g. more than 2
  positive eigenvalues), REPORT that as a documented negative + the true structure
  - a valid result. Reuse `slabWeightMirror`, `rpBlockMatrix`, `wilsonKernel`,
  `FiniteFluxGapWitness`; do not redefine.
- No new `a x i o m`, `n a t i v e _ d e c i d e`, weakening. Standard axioms.
  A documented handoff `s o r r y` on the heaviest eigen-step is OK if the
  flux-dependence + two-state structure is established. If `lake build` stalls,
  SKIP; return the explicit block + verdict.
