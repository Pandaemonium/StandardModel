import PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge
import PhysicsSM.Draft.NullEdge.RelativeScaleTetradBridge

/-!
# Weyl scale of the operator-reconstructed probe metric

The active four-dimensional smeared causal operator depends on a discreteness
scale `ell` and a nonlocality scale `L`. Simultaneously multiplying both by a
nonzero factor `r` leaves the dimensionless smearing ratio `(ell / L)^4`
unchanged and multiplies the operator by `r^-2`. This module propagates that
identity through the corrected principal-symbol pairing, its bilinear-form
packaging, and the four-probe Gram matrix.

The result supplies the inverse-metric half of the finite tetrad bridge. The
row-coframe metric in `RelativeScaleTetradBridge` has covariant Weyl weight
`r^2`, while the operator-reconstructed Gram matrix has contravariant Weyl
weight `r^-2`. Composing both with the count-derived `relativeCountScale`
therefore gives reciprocal factors `relativeAreaScale` and
`relativeAreaScale^-1`. The sixteen-to-one count witness realizes these as
`4` and `1/4`.

These are exact finite identities, not a proof that a bare graph supplies the
carriers, a rank-four probe space, Lorentzian inertia, smooth convergence, or
an absolute unit. Claim grade: `M [orig/comp]`. Provenance: program-internal
composition of the active Benincasa-Dowker operator, corrected carrier pairing,
probe-frame Gram construction, and count-derived relative scale bridge.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ProbeFrameWeylScaleBridge

open AlexandrovAlgebraGerm
open AlexandrovGermPacking
open AlexandrovGermInternalOperator
open FiniteCausalOrderOperator
open IntrinsicProbeSubspace
open Matrix
open ProbeFrameLorentzGauge
open PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction
open PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction
open PhysicsSM.Draft.NullEdge.RelativeScaleTetradBridge

variable {V : Type} [Fintype V]

/-! ## Exact simultaneous scaling of the active operator -/

/-- Simultaneous rescaling of the two length parameters leaves the smearing
ratio unchanged. -/
theorem smearingEpsilon_simultaneous_scale
    (lambda ell nonlocalityScale : Real) (hlambda : lambda ≠ 0) :
    smearingEpsilon (lambda * ell) (lambda * nonlocalityScale) =
      smearingEpsilon ell nonlocalityScale := by
  unfold smearingEpsilon
  rw [mul_div_mul_left _ _ hlambda]

/-- The local prefactor has inverse-square weight even when the unscaled
length is zero; only the rescaling factor must be nonzero. -/
theorem sourceLocal4DPrefactor_scale_total
    (lambda ell : Real) (hlambda : lambda ≠ 0) :
    sourceLocal4DPrefactor (lambda * ell) =
      (lambda ^ 2)⁻¹ * sourceLocal4DPrefactor ell := by
  by_cases hell : ell = 0
  · subst ell
    simp [sourceLocal4DPrefactor]
  · exact sourceLocal4DPrefactor_scale lambda ell hlambda hell

/-- Totalized extension of the local operator's inverse-square scale law. -/
theorem sourceLocal4DOperator_scale_total
    (C : FiniteCausalOrder V) (lambda ell : Real) (hlambda : lambda ≠ 0)
    (phi : V -> Real) (x : V) :
    sourceLocal4DOperator C (lambda * ell) phi x =
      (lambda ^ 2)⁻¹ * sourceLocal4DOperator C ell phi x := by
  unfold sourceLocal4DOperator FiniteCausalOrder.layeredOperator
  rw [sourceLocal4DPrefactor_scale_total lambda ell hlambda]
  ring

/-- Simultaneous length rescaling preserves the local-versus-broad branch and
gives the full source-native smeared operator inverse-square weight. -/
theorem sourceSmeared4DOperator_simultaneous_scale
    (C : FiniteCausalOrder V) (lambda ell nonlocalityScale : Real)
    (hlambda : lambda ≠ 0) (phi : V -> Real) (x : V) :
    sourceSmeared4DOperator C (lambda * ell) (lambda * nonlocalityScale) phi x =
      (lambda ^ 2)⁻¹ *
        sourceSmeared4DOperator C ell nonlocalityScale phi x := by
  rw [sourceSmeared4DOperator, sourceSmeared4DOperator,
    smearingEpsilon_simultaneous_scale lambda ell nonlocalityScale hlambda]
  by_cases hepsilon : smearingEpsilon ell nonlocalityScale = 1
  · simp only [hepsilon, if_true]
    exact sourceLocal4DOperator_scale_total C lambda ell hlambda phi x
  · simp only [hepsilon, if_false]
    change
      C.layeredOperator
          (sourceLocal4DPrefactor (lambda * nonlocalityScale)) (-1)
          (sourceSmeared4DCoefficient
            (smearingEpsilon ell nonlocalityScale)) phi x =
        (lambda ^ 2)⁻¹ *
          C.layeredOperator
            (sourceLocal4DPrefactor nonlocalityScale) (-1)
            (sourceSmeared4DCoefficient
              (smearingEpsilon ell nonlocalityScale)) phi x
    unfold FiniteCausalOrder.layeredOperator
    rw [sourceLocal4DPrefactor_scale_total lambda nonlocalityScale hlambda]
    ring

/-- The active project-sign smeared operator has the same inverse-square
simultaneous scale law. -/
theorem projectSmeared4DOperator_simultaneous_scale
    (C : FiniteCausalOrder V) (lambda ell nonlocalityScale : Real)
    (hlambda : lambda ≠ 0) (phi : V -> Real) (x : V) :
    projectSmeared4DOperator C (lambda * ell) (lambda * nonlocalityScale) phi x =
      (lambda ^ 2)⁻¹ *
        projectSmeared4DOperator C ell nonlocalityScale phi x := by
  unfold projectSmeared4DOperator
  rw [sourceSmeared4DOperator_simultaneous_scale C lambda ell nonlocalityScale
    hlambda phi x]
  ring

/-- Linear-map form of the active operator's simultaneous scale law. -/
theorem projectSmeared4DLinearMap_simultaneous_scale
    (C : FiniteCausalOrder V) (lambda ell nonlocalityScale : Real)
    (hlambda : lambda ≠ 0) :
    projectSmeared4DLinearMap C (lambda * ell) (lambda * nonlocalityScale) =
      (lambda ^ 2)⁻¹ •
        projectSmeared4DLinearMap C ell nonlocalityScale := by
  ext phi x
  simp only [projectSmeared4DLinearMap_apply, LinearMap.smul_apply,
    Pi.smul_apply, smul_eq_mul]
  exact projectSmeared4DOperator_simultaneous_scale C lambda ell
    nonlocalityScale hlambda phi x

/-! ## Inverse-metric Weyl weight of the carrier pairing -/

/-- The basis-free corrected carrier pairing inherits inverse-square Weyl
weight from the active operator. -/
theorem carrierProbePairing_simultaneous_scale
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (lambda ell nonlocalityScale : Real) (hlambda : lambda ≠ 0)
    (x : ClosedCarrier A) (f h : carrierProbeSubspace A) :
    carrierProbePairing A (lambda * ell) (lambda * nonlocalityScale) x f h =
      (lambda ^ 2)⁻¹ *
        carrierProbePairing A ell nonlocalityScale x f h := by
  have hscale (phi : ClosedCarrier A -> Real) :
      projectSmeared4DOperator (inducedOrder A)
          (lambda * ell) (lambda * nonlocalityScale) phi x =
        (lambda ^ 2)⁻¹ *
          projectSmeared4DOperator (inducedOrder A)
            ell nonlocalityScale phi x :=
    projectSmeared4DOperator_simultaneous_scale
      (inducedOrder A) lambda ell nonlocalityScale hlambda phi x
  unfold carrierProbePairing correctedPairingAt
  rw [hscale, hscale, hscale, hscale]
  ring

/-- Bilinear-form packaging of the carrier pairing has inverse-square Weyl
weight. -/
theorem carrierProbeBilinForm_simultaneous_scale
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (lambda ell nonlocalityScale : Real) (hlambda : lambda ≠ 0)
    (x : ClosedCarrier A) :
    carrierProbeBilinForm A (lambda * ell) (lambda * nonlocalityScale) x =
      (lambda ^ 2)⁻¹ • carrierProbeBilinForm A ell nonlocalityScale x := by
  ext f h
  simp only [carrierProbeBilinForm_apply, LinearMap.smul_apply, smul_eq_mul]
  exact carrierProbePairing_simultaneous_scale A lambda ell nonlocalityScale
    hlambda x f h

/-- In a fixed four-probe frame, the reconstructed Gram matrix transforms as
an inverse metric under simultaneous length rescaling. -/
theorem carrierProbeGram_simultaneous_scale
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (lambda ell nonlocalityScale : Real) (hlambda : lambda ≠ 0)
    (x : ClosedCarrier A) (b : CarrierProbeFrame A) :
    carrierProbeGram A (lambda * ell) (lambda * nonlocalityScale) x b =
      (lambda ^ 2)⁻¹ • carrierProbeGram A ell nonlocalityScale x b := by
  ext i j
  simp only [carrierProbeGram_apply, Matrix.smul_apply, smul_eq_mul]
  exact carrierProbePairing_simultaneous_scale A lambda ell nonlocalityScale
    hlambda x (b i) (b j)

/-! ## Composition with count-derived relative scale -/

/-- Count reconstruction gives the probe-frame Gram matrix the inverse of the
count-derived covariant metric factor. -/
theorem carrierProbeGram_relativeCountScale
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (ell nonlocalityScale : Real)
    (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0)
    (x : ClosedCarrier A) (b : CarrierProbeFrame A) :
    carrierProbeGram A
        (relativeCountScale n e n0 e0 * ell)
        (relativeCountScale n e n0 e0 * nonlocalityScale) x b =
      (relativeAreaScale n e n0 e0)⁻¹ •
        carrierProbeGram A ell nonlocalityScale x b := by
  have hscale : relativeCountScale n e n0 e0 ≠ 0 :=
    ne_of_gt (relativeCountScale_pos n e n0 e0 hn hn0 he he0)
  simpa only [relativeAreaScale] using
    carrierProbeGram_simultaneous_scale A
      (relativeCountScale n e n0 e0) ell nonlocalityScale hscale x b

/-- **Covariant/contravariant count-scale package.** The same positive
count-derived length factor multiplies a supplied coframe metric by the area
factor and the fixed-probe principal-symbol Gram matrix by its inverse. -/
theorem countWeylTransition_probeGram_package
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (eta L : Mat4) (ell nonlocalityScale : Real)
    (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0)
    (hLorentz : L * eta * Lᵀ = eta)
    (x : ClosedCarrier A) (b : CarrierProbeFrame A) :
    0 < relativeCountScale n e n0 e0 ∧
      countWeylTransition n e n0 e0 L * eta *
          (countWeylTransition n e n0 e0 L)ᵀ =
        relativeAreaScale n e n0 e0 • eta ∧
      carrierProbeGram A
          (relativeCountScale n e n0 e0 * ell)
          (relativeCountScale n e n0 e0 * nonlocalityScale) x b =
        (relativeAreaScale n e n0 e0)⁻¹ •
          carrierProbeGram A ell nonlocalityScale x b := by
  have hmetric := countWeylTransition_metric_package
    n e n0 e0 eta L hn hn0 he he0 hLorentz
  exact ⟨hmetric.1, hmetric.2,
    carrierProbeGram_relativeCountScale A n e n0 e0 ell nonlocalityScale
      hn hn0 he he0 x b⟩

/-- Sixteen events relative to one give covariant metric factor four and
contravariant probe-Gram factor one quarter. -/
theorem countWeylTransition_probeGram_nonunit_witness
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : Real)
    (x : ClosedCarrier A) (b : CarrierProbeFrame A) :
    countWeylTransition 16 (1 : Coframe4) 1 (1 : Coframe4) 1 ≠ 1 ∧
      countWeylTransition 16 (1 : Coframe4) 1 (1 : Coframe4) 1 * eta4 *
          (countWeylTransition 16 (1 : Coframe4) 1 (1 : Coframe4) 1)ᵀ =
        (4 : Real) • eta4 ∧
      carrierProbeGram A
          (relativeCountScale 16 (1 : Coframe4) 1 (1 : Coframe4) * ell)
          (relativeCountScale 16 (1 : Coframe4) 1 (1 : Coframe4) *
            nonlocalityScale) x b =
        (1 / 4 : Real) • carrierProbeGram A ell nonlocalityScale x b := by
  have hwitness := countWeylTransition_nonunit_witness
  have hscale :
      relativeCountScale 16 (1 : Coframe4) 1 (1 : Coframe4) = 2 :=
    relative_scale_unit_witness.1
  refine ⟨hwitness.1, hwitness.2, ?_⟩
  rw [hscale]
  have hgram := carrierProbeGram_simultaneous_scale A
    2 ell nonlocalityScale (by norm_num) x b
  norm_num at hgram
  exact hgram

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ProbeFrameWeylScaleBridge.sourceSmeared4DOperator_simultaneous_scale' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProbeFrameWeylScaleBridge.sourceSmeared4DOperator_simultaneous_scale

/-- info: 'PhysicsSM.Draft.NullEdge.ProbeFrameWeylScaleBridge.countWeylTransition_probeGram_package' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProbeFrameWeylScaleBridge.countWeylTransition_probeGram_package

/-- info: 'PhysicsSM.Draft.NullEdge.ProbeFrameWeylScaleBridge.countWeylTransition_probeGram_nonunit_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProbeFrameWeylScaleBridge.countWeylTransition_probeGram_nonunit_witness

end PhysicsSM.Draft.NullEdge.ProbeFrameWeylScaleBridge
