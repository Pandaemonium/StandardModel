import PhysicsSM.Draft.NullEdge.RankFourCarrierProbeSector
import PhysicsSM.Draft.NullEdge.ProbeFrameWeylScaleBridge

/-!
# Weyl scale on selected rank-four probe sectors

`ProbeFrameWeylScaleBridge.lean` proves the correct inverse-square scaling law
for the causal-operator pairing, but its Gram-matrix statements use a
`CarrierProbeFrame` of the entire zero-sum carrier space.  The semantic audit
in `RankFourCarrierProbeSector.lean` shows that such a frame forces a
five-event carrier.

This module ports the useful scale identities to a selected rank-four sector.
The causal-operator pairing and its sector Gram matrix have contravariant Weyl
weight `lambda^-2`, while the supplied coframe metric in
`RelativeScaleTetradBridge.lean` has covariant weight `lambda^2`.  The
count-derived relative scale therefore acts by reciprocal area factors on the
two sides, now without requiring the whole zero-sum space to have rank four.

These remain conditional finite identities.  They do not derive the selected
sector, the coframe-volume inputs, an absolute unit, Lorentzian inertia, or a
continuum metric from a bare graph.

Claim grade: `M [orig/comp]`.  Provenance: program-internal correction of the
existing Weyl-scale bridge using its kernel-checked basis-free pairing law.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.RankFourSectorWeylScaleBridge

open AlexandrovAlgebraGerm
open AlexandrovGermInternalOperator
open FiniteCausalOrderOperator
open IntrinsicProbeSubspace
open Matrix
open PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction
open PhysicsSM.Draft.NullEdge.ProbeFrameWeylScaleBridge
open PhysicsSM.Draft.NullEdge.RankFourProbeSector
open PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction
open PhysicsSM.Draft.NullEdge.RelativeScaleTetradBridge

variable {V : Type} [Fintype V]

/-! ## Selected-sector inverse-metric scaling -/

/-- The corrected pairing restricted to a selected rank-four sector inherits
the active operator's inverse-square Weyl weight. -/
theorem sectorBilinForm_simultaneous_scale
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (lambda ell nonlocalityScale : ℝ) (hlambda : lambda ≠ 0)
    (x : ClosedCarrier A) :
    sectorBilinForm A P (lambda * ell) (lambda * nonlocalityScale) x =
      (lambda ^ 2)⁻¹ • sectorBilinForm A P ell nonlocalityScale x := by
  ext f h
  simp only [sectorBilinForm_apply, LinearMap.smul_apply, smul_eq_mul]
  exact carrierProbePairing_simultaneous_scale A lambda ell nonlocalityScale
    hlambda x f.1 h.1

/-- In a fixed frame of a selected rank-four sector, the reconstructed Gram
matrix transforms as an inverse metric. -/
theorem sectorGram_simultaneous_scale
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (lambda ell nonlocalityScale : ℝ) (hlambda : lambda ≠ 0)
    (x : ClosedCarrier A) (b : SectorFrame P) :
    sectorGram A P (lambda * ell) (lambda * nonlocalityScale) x b =
      (lambda ^ 2)⁻¹ • sectorGram A P ell nonlocalityScale x b := by
  ext i j
  simp only [sectorGram_apply, Matrix.smul_apply, smul_eq_mul]
  exact carrierProbePairing_simultaneous_scale A lambda ell nonlocalityScale
    hlambda x (b i).1 (b j).1

/-! ## Count-derived reciprocal scale -/

/-- Count reconstruction gives a selected-sector Gram matrix the inverse of
the count-derived covariant metric area factor. -/
theorem sectorGram_relativeCountScale
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (ell nonlocalityScale : ℝ)
    (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0)
    (x : ClosedCarrier A) (b : SectorFrame P) :
    sectorGram A P
        (relativeCountScale n e n0 e0 * ell)
        (relativeCountScale n e n0 e0 * nonlocalityScale) x b =
      (relativeAreaScale n e n0 e0)⁻¹ •
        sectorGram A P ell nonlocalityScale x b := by
  have hscale : relativeCountScale n e n0 e0 ≠ 0 :=
    ne_of_gt (relativeCountScale_pos n e n0 e0 hn hn0 he he0)
  simpa only [relativeAreaScale] using
    sectorGram_simultaneous_scale A P
      (relativeCountScale n e n0 e0) ell nonlocalityScale hscale x b

/-- Covariant/contravariant count-scale package on the corrected selected
sector interface. -/
theorem countWeylTransition_sectorGram_package
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (eta L : Mat4) (ell nonlocalityScale : ℝ)
    (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0)
    (hLorentz : L * eta * Lᵀ = eta)
    (x : ClosedCarrier A) (b : SectorFrame P) :
    0 < relativeCountScale n e n0 e0 ∧
      countWeylTransition n e n0 e0 L * eta *
          (countWeylTransition n e n0 e0 L)ᵀ =
        relativeAreaScale n e n0 e0 • eta ∧
      sectorGram A P
          (relativeCountScale n e n0 e0 * ell)
          (relativeCountScale n e n0 e0 * nonlocalityScale) x b =
        (relativeAreaScale n e n0 e0)⁻¹ •
          sectorGram A P ell nonlocalityScale x b := by
  have hmetric := countWeylTransition_metric_package
    n e n0 e0 eta L hn hn0 he he0 hLorentz
  exact ⟨hmetric.1, hmetric.2,
    sectorGram_relativeCountScale A P n e n0 e0 ell nonlocalityScale
      hn hn0 he he0 x b⟩

/-- Sixteen events relative to one give covariant metric factor four and
selected-sector contravariant Gram factor one quarter. -/
theorem countWeylTransition_sectorGram_nonunit_witness
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ)
    (x : ClosedCarrier A) (b : SectorFrame P) :
    countWeylTransition 16 (1 : Coframe4) 1 (1 : Coframe4) 1 ≠ 1 ∧
      countWeylTransition 16 (1 : Coframe4) 1 (1 : Coframe4) 1 * eta4 *
          (countWeylTransition 16 (1 : Coframe4) 1 (1 : Coframe4) 1)ᵀ =
        (4 : ℝ) • eta4 ∧
      sectorGram A P
          (relativeCountScale 16 (1 : Coframe4) 1 (1 : Coframe4) * ell)
          (relativeCountScale 16 (1 : Coframe4) 1 (1 : Coframe4) *
            nonlocalityScale) x b =
        (1 / 4 : ℝ) • sectorGram A P ell nonlocalityScale x b := by
  have hwitness := countWeylTransition_nonunit_witness
  have hscale :
      relativeCountScale 16 (1 : Coframe4) 1 (1 : Coframe4) = 2 :=
    relative_scale_unit_witness.1
  refine ⟨hwitness.1, hwitness.2, ?_⟩
  rw [hscale]
  have hgram := sectorGram_simultaneous_scale A P
    2 ell nonlocalityScale (by norm_num) x b
  norm_num at hgram
  exact hgram

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.RankFourSectorWeylScaleBridge.sectorGram_simultaneous_scale' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RankFourSectorWeylScaleBridge.sectorGram_simultaneous_scale

/-- info: 'PhysicsSM.Draft.NullEdge.RankFourSectorWeylScaleBridge.countWeylTransition_sectorGram_package' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RankFourSectorWeylScaleBridge.countWeylTransition_sectorGram_package

/-- info: 'PhysicsSM.Draft.NullEdge.RankFourSectorWeylScaleBridge.countWeylTransition_sectorGram_nonunit_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RankFourSectorWeylScaleBridge.countWeylTransition_sectorGram_nonunit_witness

end PhysicsSM.Draft.NullEdge.RankFourSectorWeylScaleBridge
