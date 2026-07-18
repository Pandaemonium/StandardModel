import PhysicsSM.Draft.NullEdge.CorrectedPairingCarrierInertiaWitness
import PhysicsSM.Draft.NullEdge.RankFourCarrierProbeSector

/-!
# Five-event corrected-pairing witness in the selected-sector API

`CorrectedPairingCarrierInertiaWitness.lean` proves exact Lorentzian inertia
for the full zero-sum probe space of one five-event carrier.  The whole-space
frame interface cannot survive an interior refinement: a `Fin 4` basis of the
full zero-sum carrier space forces the carrier to have exactly five events.

This module moves the concrete witness into the successor
`RankFourCarrierProbeSector` interface.  On the five-event control the selected
space is `top`, so no probe modes are discarded.  The old normalized carrier
frame maps canonically to a frame of that selected space, and its sector Gram
matrix is definitionally the same production corrected-pairing matrix.

This is an API bridge, not a selector theorem.  It does not derive a rank-four
subspace on a larger carrier, a spectral gap, overlap compatibility, refinement
persistence, or continuum convergence.

Claim grade: `M [orig]` finite API bridge.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CorrectedPairingSelectedSectorWitness

open PhysicsSM.Draft.NullEdge.CorrectedPairingCarrierInertiaWitness
open PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates
open PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator
open PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace
open PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge
open PhysicsSM.Draft.NullEdge.RankFourProbeSector

/-- The selected rank-four sector on the five-event control is the entire
zero-sum carrier probe space. -/
def fiveEventTopSector :
    RankFourCarrierProbeSector fiveEventLorentzDiamond where
  space := ⊤
  finrank_eq_four := by
    rw [finrank_top]
    simpa using Module.finrank_eq_card_basis fiveEventCarrierProbeBasis

/-- The canonical linear equivalence from the full carrier probe space to the
top selected subspace. -/
def fiveEventTopSectorLinearEquiv :
    carrierProbeSubspace fiveEventLorentzDiamond ≃ₗ[Real]
      fiveEventTopSector.space := by
  change carrierProbeSubspace fiveEventLorentzDiamond ≃ₗ[Real]
    (⊤ : Submodule Real (carrierProbeSubspace fiveEventLorentzDiamond))
  exact Submodule.topEquiv.symm

/-- A whole-carrier frame maps canonically into the top selected sector. -/
def fiveEventTopSectorFrameOfCarrierFrame
    (b : CarrierProbeFrame fiveEventLorentzDiamond) :
    SectorFrame fiveEventTopSector :=
  b.map fiveEventTopSectorLinearEquiv

/-- The included selected-sector frame vector is the original carrier frame
vector. -/
@[simp] theorem fiveEventTopSectorFrameOfCarrierFrame_apply_coe
    (b : CarrierProbeFrame fiveEventLorentzDiamond) (i : Fin 4) :
    ((fiveEventTopSectorFrameOfCarrierFrame b i).1 :
        carrierProbeSubspace fiveEventLorentzDiamond) = b i := by
  change b i = b i
  rfl

/-- Passing a carrier frame to the top selected sector leaves its production
corrected-pairing Gram matrix exactly unchanged. -/
theorem fiveEventTopSector_gram_eq_carrierGram
    (ell nonlocalityScale : Real)
    (x : ClosedCarrier fiveEventLorentzDiamond)
    (b : CarrierProbeFrame fiveEventLorentzDiamond) :
    sectorGram fiveEventLorentzDiamond fiveEventTopSector
        ell nonlocalityScale x
        (fiveEventTopSectorFrameOfCarrierFrame b) =
      carrierProbeGram fiveEventLorentzDiamond
        ell nonlocalityScale x b := by
  ext i j
  rw [sectorGram_apply, carrierProbeGram_apply]
  simp

/-- The concrete normalized five-event carrier satisfies the corrected
selected-sector Lorentzian-inertia gate at equal nonzero scales. -/
theorem fiveEventTopSector_hasLorentzianInertia
    (ell : Real) (hell : ell ≠ 0) :
    HasSectorLorentzianInertia fiveEventLorentzDiamond fiveEventTopSector
      ell ell (carrierTop fiveEventLorentzDiamond) := by
  rcases fiveEventLorentzDiamond_hasLorentzianInertia ell hell with
    ⟨b, hb⟩
  refine ⟨fiveEventTopSectorFrameOfCarrierFrame b, ?_⟩
  unfold IsSectorLorentzNormalized
  rw [fiveEventTopSector_gram_eq_carrierGram]
  exact hb

end PhysicsSM.Draft.NullEdge.CorrectedPairingSelectedSectorWitness

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingSelectedSectorWitness.fiveEventTopSector_hasLorentzianInertia' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingSelectedSectorWitness.fiveEventTopSector_hasLorentzianInertia
