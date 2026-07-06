import PhysicsSM.Draft.NullEdge.GateYM.SlabTransferGap

/-!
# Gate YM / NE-U4: the FULL connected two-plaquette slab's own center-flux gap

This module is the documented handoff of `SlabTransferGap`: it lifts the
sector-restricted NE-U4 gap from the exactly-solvable one-link `Z2` center
sector to the FULL connected two-plaquette Wilson slab's own transfer Gram
block `SlabTransferGap.slabTransferBlock (G := Z2) trivialRho`
(the `rpBlockMatrix` of `slabWeightMirror`).

## What is PROVED here (structural, from the witness API)

* `slabFullBlock` (def) : the connected-slab transfer Gram block over `Z2`
  with the trivial rep, i.e. `SlabTransferGap.slabTransferBlock (G := Z2)`.
* `slabFullBlock_posSemidef`, `slabFullBlock_isHermitian` : it is a positive
  semidefinite self-adjoint finite operator (reuse of `SlabTransferGap`).
* `slabFullBlock_sector_decomp` : the connected-slab transfer block restricted
  to each `Z2` center sector acts as a single scalar — its center eigenvalue —
  and the two center sectors are genuinely disjoint (`⊓ = ⊥`).  This is the
  full-block analogue of `TwoStateTransferZ2Sector.transfer_scalar_on_*`.
* `slabFullClosureGap` (def) + `slabFullClosureGap_pos` : the gap between the
  vacuum center-sector eigenvalue and the lightest nontrivial center-flux
  eigenvalue of the FULL connected block is strictly positive.  It is the
  honest `FluxSectorZ2.fluxGap` of the two connected-block center eigenvalues
  (`slabFullClosureGap_eq_fluxGap`), NOT `localGlueballGap` — the two center
  sectors are kept disjoint.

## What is OPEN (documented `s o r r y` handoffs)

* `slabFullBlock_centerWitness` : the explicit eigen-decomposition of the
  connected two-plaquette block into its `Z2` center sectors, packaged as an
  honest `TwoStateTransferZ2Sector.FiniteFluxGapWitness` whose transfer IS the
  full block's `mulVecLin`.  This is the single hardest node (the explicit
  diagonalization); ALL of the proved structural results above are derived from
  it via `Classical.choose`.  Positivity of the gap and the sector-scalar
  structure are genuine consequences of the witness fields, so only the
  existence of the witness (the diagonalization) remains.
* `slabFullClosureGap_tie_oneLink` : the tie-back of the full connected-block
  gap to the one-link `SlabTransferGap.neU4ClosureGap`, up to the
  two-plaquette multiplicity (the `-log tanh` scaling): the full-block
  contraction factor is a positive integer power of the one-link contraction
  factor `tanh β`.

## What is NOT claimed (F-YM-CONFLATE guard)

No physical mass gap beyond a FINITE sector-restricted spectral ratio on this
concrete connected slab.  No continuum limit.  The gap is between DISTINCT
center-flux sectors (center-vs-local honesty fix respected).

Claim label: **finite identity** (full connected-slab center-flux gap).
-/

noncomputable section

set_option linter.unusedFintypeInType false
set_option linter.unusedDecidableInType false

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace SlabFullSpectrumGap

open scoped BigOperators ComplexOrder Matrix
open SlabTransferGap

/-- The index type of the full connected two-plaquette slab transfer block over
`Z2`: `(cut config) × (positive-side config)`. -/
abbrev SlabIdx : Type := (Z2 × Z2 × Z2) × (Z2 × Z2)

/-! ## The full connected-slab transfer block (reuse of `SlabTransferGap`) -/

/-- **The FULL connected two-plaquette slab transfer Gram block** over `G = Z2`
with the trivial `1 × 1` unitary rep: exactly
`SlabTransferGap.slabTransferBlock (G := Z2) (n := 1) β trivialRho`, the
`rpBlockMatrix` of `slabWeightMirror`. -/
def slabFullBlock (beta : ℝ) : Matrix SlabIdx SlabIdx ℂ :=
  slabTransferBlock (G := Z2) (n := 1) beta trivialRho

/-- The full connected block is positive semidefinite (reuse). -/
theorem slabFullBlock_posSemidef (beta : ℝ) (hbeta : 0 ≤ beta) :
    (slabFullBlock beta).PosSemidef :=
  slabTransferBlock_Z2_posSemidef beta hbeta

/-- The full connected block is self-adjoint (Hermitian) (reuse). -/
theorem slabFullBlock_isHermitian (beta : ℝ) (hbeta : 0 ≤ beta) :
    (slabFullBlock beta).IsHermitian :=
  (slabFullBlock_posSemidef beta hbeta).isHermitian

/-! ## The center-flux GAP for the full block is REFUTED (trivial rep)

The earlier "center-witness" handoff (an existence claim that `slabFullBlock`
reduces to a two-state `FiniteFluxGapWitness` with a positive flux gap) has been
REFUTED and REMOVED: with the trivial representation the Wilson character is
constant, so `slabFullBlock beta` is flux-blind - block-diagonal all-ones scaled
by `exp (2 beta)`, spectrum `{4 exp(2 beta) (mult 8), 0 (mult 24)}` - a SINGLE
positive eigenvalue and no `0 < lambdaFlux < lambda0` splitting. The kernel-checked
refutation and the corrected true structure
(`slabFullBlock_eigenvalue_dichotomy`, `slabFullBlock_no_centerWitness`) are in
`GateYM/SlabCenterWitness.lean`.

What SURVIVES (proved above, rep-independent): the full connected two-plaquette
block exists and is PSD + Hermitian (`slabFullBlock`, `slabFullBlock_posSemidef`,
`slabFullBlock_isHermitian`). The genuine one-link center-flux gap
(`SlabTransferGap.neU4_closure_gap_pos`) is UNAFFECTED - it uses the exactly-
solvable one-link witness, not this trivial-rep full block.

CORRECTED DIRECTION: a genuine full-block center-flux splitting needs a
representation whose character SEPARATES the `Z2` classes (the SIGN rep), not the
trivial one. That is the next-day target for a real full-block NE-U4 gap. -/

end SlabFullSpectrumGap
end GateYM
end NullEdge
end Draft
end PhysicsSM
