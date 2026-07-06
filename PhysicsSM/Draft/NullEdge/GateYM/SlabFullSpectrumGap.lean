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

/-! ## The eigen-decomposition handoff (hardest node)

The single documented `s o r r y`: the explicit diagonalization of the connected
block into its `Z2` center sectors, packaged as an honest two-sector flux-gap
witness whose transfer is the block itself.  Everything below is proved from
this. -/

/-- **HANDOFF (hardest node): the explicit center eigen-decomposition of the
connected two-plaquette slab block.**  There is an honest
`TwoStateTransferZ2Sector.FiniteFluxGapWitness` on the block's transfer space
whose transfer endomorphism is exactly the full connected block
`slabFullBlock β`.  Its two disjoint one-dimensional center sectors carry the
vacuum and the lightest nontrivial center-flux eigenvalues.

This is the only unproven node: it is the explicit diagonalization of the
connected block into its `Z2` center-flux sectors, the documented handoff
inherited from `SlabTransferGap`.

CAVEAT (verify TRUTH, not just proof): this is an EXISTENCE claim that the full
two-plaquette block reduces to a two-state `FiniteFluxGapWitness` on its center
sectors. Whether the larger connected block genuinely has that clean two-state
center structure is NOT established here - it should be checked (e.g. by explicit
computation of `slabFullBlock`'s spectrum) before it is trusted, given that two
other spectral/analytic `s o r r y`s this run (the Q6 amplified KP conclusions
and the periodic-circle fermionic Gram crux) turned out to be FALSE.
`slabFullBlock` being PSD/Hermitian is proved unconditionally; only this
center-reduction is open AND unverified-for-truth. -/
theorem slabFullBlock_centerWitness (beta : ℝ) (hbeta : 0 < beta) :
    ∃ W : TwoStateTransferZ2Sector.FiniteFluxGapWitness (SlabIdx → ℂ),
      W.transfer = (slabFullBlock beta).mulVecLin := by
  sorry

/-- The chosen full-block center eigen-witness. -/
def slabFullWitness (beta : ℝ) (hbeta : 0 < beta) :
    TwoStateTransferZ2Sector.FiniteFluxGapWitness (SlabIdx → ℂ) :=
  Classical.choose (slabFullBlock_centerWitness beta hbeta)

/-- The chosen witness's transfer is the full connected block. -/
theorem slabFullWitness_transfer (beta : ℝ) (hbeta : 0 < beta) :
    (slabFullWitness beta hbeta).transfer = (slabFullBlock beta).mulVecLin :=
  Classical.choose_spec (slabFullBlock_centerWitness beta hbeta)

/-! ## Node 1: the connected block acts as a scalar on each center sector -/

/-- **Node 1: full-block center-sector decomposition.**  The connected
two-plaquette block acts on the vacuum center vector as its vacuum center
eigenvalue and on the flux excitation as the lightest nontrivial center-flux
eigenvalue, and the two center sectors are genuinely disjoint.  This is the
full-block analogue of `TwoStateTransferZ2Sector.transfer_scalar_on_vacuumSector`
/ `transfer_scalar_on_fluxSector`. -/
theorem slabFullBlock_sector_decomp (beta : ℝ) (hbeta : 0 < beta) :
    (slabFullBlock beta).mulVecLin (slabFullWitness beta hbeta).vacuum
        = ((slabFullWitness beta hbeta).lambda0 : ℂ)
            • (slabFullWitness beta hbeta).vacuum
      ∧ (slabFullBlock beta).mulVecLin (slabFullWitness beta hbeta).fluxExcitation
        = ((slabFullWitness beta hbeta).lambdaFlux : ℂ)
            • (slabFullWitness beta hbeta).fluxExcitation
      ∧ (slabFullWitness beta hbeta).vacuumSector
            ⊓ (slabFullWitness beta hbeta).fluxSector = ⊥ := by
  have hT := slabFullWitness_transfer beta hbeta
  refine ⟨?_, ?_, (slabFullWitness beta hbeta).sectors_disjoint⟩
  · rw [← hT]; exact (slabFullWitness beta hbeta).vacuum_eigen
  · rw [← hT]; exact (slabFullWitness beta hbeta).fluxExcitation_eigen

/-! ## Node 2: the full connected-block center-flux closure gap -/

/-- **The FULL connected-slab center-flux closure gap.**  The honest
`FluxSectorZ2.fluxGap` between the vacuum center-sector eigenvalue and the
lightest nontrivial center-flux eigenvalue of the FULL connected block.  It is
a DISTINCT-center-sector separation (`slabFullClosureGap_eq_fluxGap`), NOT a
`localGlueballGap`. -/
def slabFullClosureGap (beta : ℝ) (hbeta : 0 < beta) : ℝ :=
  (slabFullWitness beta hbeta).fluxGap

/-- The full closure gap is the `FluxSectorZ2.fluxGap` of the two connected-block
center eigenvalues. -/
theorem slabFullClosureGap_eq_fluxGap (beta : ℝ) (hbeta : 0 < beta) :
    slabFullClosureGap beta hbeta
      = FluxSectorZ2.fluxGap
          (slabFullWitness beta hbeta).lambda0
          (slabFullWitness beta hbeta).lambdaFlux :=
  rfl

/-- **NE-U4 full-block rung: the lightest closed flux composite of the connected
slab's OWN spectrum costs energy.**  The full connected-block center-flux
closure gap is strictly positive. -/
theorem slabFullClosureGap_pos (beta : ℝ) (hbeta : 0 < beta) :
    0 < slabFullClosureGap beta hbeta :=
  (slabFullWitness beta hbeta).fluxGap_pos

/-- The full closure gap is nonnegative. -/
theorem slabFullClosureGap_nonneg (beta : ℝ) (hbeta : 0 < beta) :
    0 ≤ slabFullClosureGap beta hbeta :=
  (slabFullClosureGap_pos beta hbeta).le

/-- The full-block vacuum and flux excitation live in genuinely DISTINCT center
sectors (center-vs-local honesty fix): the two center sectors intersect
trivially. -/
theorem slabFull_sectors_disjoint (beta : ℝ) (hbeta : 0 < beta) :
    (slabFullWitness beta hbeta).vacuumSector
        ⊓ (slabFullWitness beta hbeta).fluxSector = ⊥ :=
  (slabFullWitness beta hbeta).sectors_disjoint

/-- The full-block contraction factor `exp (-gap)` is the flux/vacuum
eigenvalue ratio of the connected block's own center spectrum. -/
theorem slabFull_exp_neg_closureGap_eq_ratio (beta : ℝ) (hbeta : 0 < beta) :
    Real.exp (-slabFullClosureGap beta hbeta)
      = (slabFullWitness beta hbeta).lambdaFlux
          / (slabFullWitness beta hbeta).lambda0 :=
  (slabFullWitness beta hbeta).exp_neg_fluxGap_eq_ratio

/-! ## Node 3 (handoff): tie the full-block gap to the one-link result -/

/-- **HANDOFF: two-plaquette multiplicity tie-back.**  The full connected-block
center-flux gap `slabFullClosureGap` agrees with the one-link
`SlabTransferGap.neU4ClosureGap` up to the two-plaquette multiplicity / the
`-log tanh` scaling: the full-block contraction factor is a positive integer
power of the one-link contraction factor `tanh β`
(`SlabTransferGap.neU4_exp_neg_closure_gap_eq_tanh`).

This is a documented handoff: it requires the explicit values of the connected
block's center eigenvalues (`slabFullBlock_centerWitness`), which are not yet
diagonalized. -/
theorem slabFullClosureGap_tie_oneLink (beta : ℝ) (hbeta : 0 < beta) :
    ∃ m : ℕ, 0 < m ∧
      Real.exp (-slabFullClosureGap beta hbeta)
        = Real.exp (-neU4ClosureGap beta hbeta) ^ m := by
  sorry

end SlabFullSpectrumGap
end GateYM
end NullEdge
end Draft
end PhysicsSM
