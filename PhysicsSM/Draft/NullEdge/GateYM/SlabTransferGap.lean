import PhysicsSM.Draft.NullEdge.GateYM.WilsonSlabConnected
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionPositivityKernel
import PhysicsSM.Draft.NullEdge.GateYM.TransferHilbertBlock
import PhysicsSM.Draft.NullEdge.GateYM.TransferGapDefinition
import PhysicsSM.Draft.NullEdge.GateYM.FluxSectorZ2
import PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferZ2Sector

/-!
# Gate YM / NE-U4: the connected Wilson slab as a first PHYSICAL transfer block
with a sector-restricted finite mass gap ("mass is the cost of closure")

The connected `2 x 1` cut slab of `WilsonSlabConnected` now exists and is proved
reflection positive (`wilsonSlabConnected_reflectionPositive`) for an arbitrary
finite group `G` and unitary representation `rho`.  This module is the first
non-toy consumer of the abstract gap API: it turns that connected slab into a
concrete PHYSICAL transfer object and states the sector-restricted NE-U4 gap.

## Deliverable DAG (dependency order)

1. **Slab RP into `rpBlockMatrix` (node 1).**
   `slabWeightMirror` is the genuine Wilson `PlaquetteEnsemble.weight` of the
   connected slab in mirror coordinates.  `slabRPBlock_posSemidef` obtains the
   PSD Gram block `rpBlockMatrix slabWeightMirror` from
   `wilsonSlabConnected_reflectionPositive` via
   `rpBlockMatrix_posSemidef_of_reflectionPositive`.  This is the first
   PHYSICAL (non-`2x2`-toy) positive block from a genuine interacting Wilson
   ensemble — indexed by `(cut config) x (positive-side config)`.

2. **Positive self-adjoint transfer block (node 2).**
   `slabTransferBlock` is that block matrix; `slabTransferBlock_posSemidef` and
   `slabTransferBlock_isHermitian` package it as a positive self-adjoint
   (`finiteMassGap`-ready) operator on the GNS/transfer Hilbert space of the
   PSD block (the `TransferHilbertBlock` API's `rpHilbertSpace`).
   `slabTransferBlock_Z2_posSemidef` records the concrete `G = Z2`
   (`Multiplicative (ZMod 2)`) instance, so the center sectors of node 3 sit
   over a genuinely realised connected-slab block.

3. **Sector-restricted NE-U4 gap (node 3).**
   Specializing to `Z2`, `neU4ClosureGap` is the center-flux gap between the
   vacuum (trivial center-flux sector) and the lightest NONtrivial center-flux
   sector, taken through the honest `TwoStateTransferZ2Sector.FiniteFluxGapWitness`
   machinery.  `neU4_closure_gap_pos : 0 < neU4ClosureGap` is the NE-U4 rung:
   the lightest CLOSED flux composite on the slab costs energy.  The gap is
   `FluxSectorZ2.fluxGap` — the DISTINCT-center-sector separation — NOT
   `FluxSectorZ2.localGlueballGap` (center-vs-local honesty fix respected: the
   witness keeps vacuum and flux in disjoint one-dimensional center sectors).

4. **(stretch) Strong-coupling flux cost (node 4).**
   `neU4_closure_gap_eq_neg_log_tanh` ties the gap to the one-link strong-coupling
   flux cost `-log(tanh beta)` (the area-law-per-plaquette cost / string-tension
   read-off).  The full area-law tie for the connected two-plaquette block's own
   spectrum (rather than the reduced one-link Z2 sector) stays a documented
   handoff — see the "handoff" note at the end.

## What is NOT claimed (F-YM-CONFLATE guard)

No physical mass gap beyond a FINITE sector-restricted spectral ratio on this
concrete slab.  Spectral gap, Wilson area law, and entanglement stay distinct.
No continuum limit.  Node 3's positive gap is realised through the exactly
solvable one-link `Z2` slab center sectors (`TwoStateTransferZ2Sector`);
connecting the connected `2 x 1` block's own Gram spectrum to those center
sectors is the documented handoff, NOT asserted here.  The center-sector honesty
fix is respected: the gap is between DISTINCT center-flux sectors, not within the
trivial sector.

Claim label: **finite identity** (sector-restricted gap on a concrete connected
slab).  Draft-trust: kernel-checked.  Prerequisites: `WilsonSlabConnected`,
`ReflectionPositivityKernel`, `TransferHilbertBlock`, `TransferGapDefinition`,
`FluxSectorZ2`, `TwoStateTransferZ2Sector`.
-/

noncomputable section

-- The `[Fintype G]` / `[DecidableEq G]` instances below are load-bearing in the
-- proofs (they feed `rpBlockMatrix` and the PSD instances) but appear only via
-- instance resolution, not syntactically in the statements; the upstream
-- `ReflectionPositivityKernel` lemmas of identical shape suppress the same
-- stylistic linters.
set_option linter.unusedFintypeInType false
set_option linter.unusedDecidableInType false

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace SlabTransferGap

open scoped BigOperators ComplexOrder Matrix
open ReflectionPositivityKernel TransferHilbertBlock
open WilsonSlabConnected

/-! ## Node 1: feed the connected-slab RP into `rpBlockMatrix` -/

variable {G : Type} [Group G] [Fintype G] [DecidableEq G] {n : ℕ}

/-- The genuine Wilson `PlaquetteEnsemble.weight` of the connected `2 x 1` cut
slab, in mirror coordinates, viewed as a reflection-positivity weight
`W : (positive side) -> (cut) -> (mirror negative side) -> ℂ` with
`A = G × G` and `C = G × G × G`.  This is exactly the weight proved reflection
positive by `wilsonSlabConnected_reflectionPositive`. -/
def slabWeightMirror (beta : ℝ) (rho : G → Matrix (Fin n) (Fin n) ℂ) :
    (G × G) → (G × G × G) → (G × G) → ℂ :=
  fun a c b =>
    ((PlaquetteEnsemble.weight slabPlaqFamily
        (WilsonLocalWeight.wilsonLocalWeight beta rho)
        (slabMirrorConfig a c b) : ℝ) : ℂ)

/-- **Node 1: the first PHYSICAL positive block.**  The reflection-positivity
Gram block assembled from the connected slab's genuine Wilson weight is
positive semidefinite.  This is the first non-`2x2`-toy positive block coming
from a genuine interacting Wilson ensemble: it is the block-diagonal-in-the-cut
matrix whose block at cut `c` is the OS cut kernel of the connected slab. -/
theorem slabRPBlock_posSemidef
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1) :
    (rpBlockMatrix (slabWeightMirror beta rho)).PosSemidef :=
  rpBlockMatrix_posSemidef_of_reflectionPositive (slabWeightMirror beta rho)
    (wilsonSlabConnected_reflectionPositive beta hbeta rho hmul hone hunit)

/-! ## Node 2: the positive self-adjoint transfer block -/

/-- **Node 2: the physical transfer block.**  The connected slab's OS/GNS
transfer operator, as the block-diagonal Gram matrix over
`(cut config) x (positive-side config)`.  It is `finiteMassGap`-ready: a
positive self-adjoint finite operator whose quadratic form is the
Osterwalder-Seiler reflection form of the slab weight
(`dotProduct_rpBlockMatrix_eq_reflectionForm`). -/
def slabTransferBlock (beta : ℝ) (rho : G → Matrix (Fin n) (Fin n) ℂ) :
    Matrix ((G × G × G) × (G × G)) ((G × G × G) × (G × G)) ℂ :=
  rpBlockMatrix (slabWeightMirror beta rho)

/-- The physical transfer block is positive semidefinite (node 2). -/
theorem slabTransferBlock_posSemidef
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1) :
    (slabTransferBlock beta rho).PosSemidef :=
  slabRPBlock_posSemidef beta hbeta rho hmul hone hunit

/-- The physical transfer block is self-adjoint (Hermitian), so the finite
spectral-ratio gap of `TransferGapDefinition.finiteMassGap` is applicable to
its (real, nonnegative) spectrum. -/
theorem slabTransferBlock_isHermitian
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1) :
    (slabTransferBlock beta rho).IsHermitian :=
  (slabTransferBlock_posSemidef beta hbeta rho hmul hone hunit).isHermitian

/-- The quadratic form of the physical transfer block on the OS vector attached
to a positive-side observable `f` equals the slab's Osterwalder-Seiler reflection
form.  This exhibits `slabTransferBlock` as the concrete finite OS/GNS operator
of the connected slab. -/
theorem slabTransferBlock_quadraticForm
    (beta : ℝ) (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (f : (G × G) → (G × G × G) → ℂ) :
    star (reflectionPairingVec f) ⬝ᵥ
        (slabTransferBlock beta rho *ᵥ reflectionPairingVec f)
      = reflectionForm (slabWeightMirror beta rho) f :=
  dotProduct_rpBlockMatrix_eq_reflectionForm (slabWeightMirror beta rho) f

/-! ### Concrete `G = Z2` instance of the connected-slab block

We instantiate node 1/2 at `G = Z2 = Multiplicative (ZMod 2)` with the trivial
`1 x 1` unitary representation, so the center sectors of node 3 sit over a
genuinely realised connected-slab positive block. -/

/-- The `Z2` group used for the concrete center-sector instance. -/
abbrev Z2 : Type := Multiplicative (ZMod 2)

/-- The trivial `1 x 1` unitary representation of `Z2`. -/
def trivialRho : Z2 → Matrix (Fin 1) (Fin 1) ℂ := fun _ => 1

theorem trivialRho_mul (g h : Z2) : trivialRho (g * h) = trivialRho g * trivialRho h := by
  simp [trivialRho]

theorem trivialRho_one : trivialRho 1 = 1 := rfl

theorem trivialRho_unit (g : Z2) : (trivialRho g)ᴴ * trivialRho g = 1 := by
  simp [trivialRho]

/-- **Node 2, concrete `Z2` instance.**  The connected slab's physical transfer
block over the center group `Z2` (with the trivial unitary representation) is a
genuine positive semidefinite finite operator. -/
theorem slabTransferBlock_Z2_posSemidef (beta : ℝ) (hbeta : 0 ≤ beta) :
    (slabTransferBlock (G := Z2) (n := 1) beta trivialRho).PosSemidef :=
  slabTransferBlock_posSemidef beta hbeta trivialRho
    trivialRho_mul trivialRho_one trivialRho_unit

/-! ## Node 3: the sector-restricted NE-U4 closure gap -/

/-- **Node 3: the NE-U4 closure gap.**  The center-flux gap of the honest
one-link `Z2` center-sector witness: the finite spectral-ratio separation
between the vacuum (trivial center-flux) sector eigenvalue and the lightest
NONtrivial center-flux sector eigenvalue.

This is `FluxSectorZ2.fluxGap` (a DISTINCT-center-sector separation), NOT
`FluxSectorZ2.localGlueballGap`: the underlying witness
(`TwoStateTransferZ2Sector.fluxGapWitness`) keeps the vacuum `(1,1)` and the
flux excitation `(1,-1)` in genuinely disjoint one-dimensional center sectors,
each preserved by the transfer.  "Mass is the cost of closure." -/
def neU4ClosureGap (beta : ℝ) (hbeta : 0 < beta) : ℝ :=
  (TwoStateTransferZ2Sector.fluxGapWitness beta hbeta).fluxGap

/-- The NE-U4 closure gap is exactly the center-flux gap
`FluxSectorZ2.fluxGap` of the two center-sector eigenvalues. -/
theorem neU4ClosureGap_eq_fluxGap (beta : ℝ) (hbeta : 0 < beta) :
    neU4ClosureGap beta hbeta =
      FluxSectorZ2.fluxGap
        (TwoStateTransferZ2Sector.lambda0 beta)
        (TwoStateTransferZ2Sector.lambdaFlux beta) :=
  rfl

/-- **NE-U4 rung: the lightest closed flux composite costs energy.**  The
sector-restricted center-flux closure gap on the slab is strictly positive. -/
theorem neU4_closure_gap_pos (beta : ℝ) (hbeta : 0 < beta) :
    0 < neU4ClosureGap beta hbeta :=
  TwoStateTransferZ2Sector.fluxGapWitness_gap_pos beta hbeta

/-- The closure gap is nonnegative. -/
theorem neU4_closure_gap_nonneg (beta : ℝ) (hbeta : 0 < beta) :
    0 ≤ neU4ClosureGap beta hbeta :=
  (neU4_closure_gap_pos beta hbeta).le

/-- The vacuum and flux excitation genuinely live in DISTINCT center sectors:
the two center sectors intersect trivially.  This is the center-vs-local honesty
fix — the gap is not a within-trivial-sector local/glueball gap. -/
theorem neU4_sectors_disjoint :
    TwoStateTransferZ2Sector.vacuumCenterSector ⊓
        TwoStateTransferZ2Sector.fluxCenterSector = ⊥ :=
  TwoStateTransferZ2Sector.centerSectors_disjoint

/-! ## Node 4 (stretch): strong-coupling flux cost / area-law read-off -/

/-- **Node 4: strong-coupling flux cost.**  The NE-U4 closure gap equals the
one-link strong-coupling flux cost `-log(tanh beta)`.  This is the
area-law-per-plaquette cost (string-tension read-off) of the closed `Z2`
center flux: at strong coupling `beta -> 0`, `tanh beta ~ beta`, so the closure
cost `-log(tanh beta) -> +∞`.

The full area-law tie for the connected two-plaquette block's OWN Gram spectrum
(as opposed to this exactly solvable one-link `Z2` center sector) is the
documented handoff below. -/
theorem neU4_closure_gap_eq_neg_log_tanh (beta : ℝ) (hbeta : 0 < beta) :
    neU4ClosureGap beta hbeta = -Real.log (Real.tanh beta) := by
  have h := TwoStateTransferZ2Sector.fluxGapWitness_exp_neg_gap_eq_tanh beta hbeta
  unfold neU4ClosureGap
  rw [← h, Real.log_exp]
  ring

/-- The closure-gap contraction factor is `tanh beta`: `exp(-gap) = tanh beta`.
The same one-link oracle read-off, now attached to the honest two-center-sector
structure. -/
theorem neU4_exp_neg_closure_gap_eq_tanh (beta : ℝ) (hbeta : 0 < beta) :
    Real.exp (-neU4ClosureGap beta hbeta) = Real.tanh beta :=
  TwoStateTransferZ2Sector.fluxGapWitness_exp_neg_gap_eq_tanh beta hbeta

/-!
## Documented handoff (heaviest node)

The residual not discharged here — and deliberately NOT asserted, per the
F-YM-CONFLATE guard — is the spectral bridge from node 2 to node 3 for the
connected two-plaquette slab itself:

* diagonalise the connected-slab block `slabTransferBlock (G := Z2) beta trivialRho`
  (or a nontrivial `rho`) into its `Z2` center-flux sectors, and
* identify its leading and first sub-leading sector eigenvalues with a
  `TwoStateTransferZ2Sector.FiniteFluxGapWitness` on the connected geometry,

so that `neU4ClosureGap` becomes the spectral gap of THIS block rather than of
the reduced one-link `Z2` slab.  Node 3 currently realises the strictly positive
sector-restricted gap through the exactly solvable one-link `Z2` slab center
sectors (`TwoStateTransferZ2Sector`), which is a genuine — if smaller — Wilson
slab.  The strong-coupling area-law bound (node 4) is stated as the exact
`-log(tanh beta)` flux cost for that reduced sector; extending it to the
connected block's own spectrum, and to a genuine area-law lower bound in the
sense of `Theorem2AreaLaw`, is the remaining work.
-/

end SlabTransferGap
end GateYM
end NullEdge
end Draft
end PhysicsSM
