import PhysicsSM.Draft.NullEdge.HiggsCoframeFirstVariation

/-!
# Local Higgs response to frame and measure perturbations

This module combines two supplied geometric perturbations of a finite local
Higgs functional: an affine variation of the real dual frame used to extract
complex derivative components, and affine variations of the kinetic and
potential measure weights. It proves the complete cubic polynomial expansion.
The linear coefficient separates into kinetic-measure, dual-frame, and
potential-measure responses and is invariant under a common anchor phase.

The frame, frame variation, and measure responses remain supplied data. No
metric or coframe reconstruction, stress-tensor index structure, conservation
law, Einstein equation, or continuum limit is claimed. Claim grade:
`M [orig/comp]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HiggsLocalStressResponse

open HiggsCoframeFirstVariation

variable {Y I : Type*} [Fintype Y] [Fintype I]

/-- A local Higgs functional with independently supplied kinetic and potential
measure weights. -/
def localHiggsFunctional
    (kineticWeight potentialWeight : Real)
    (sign : I -> Real)
    (dualMatrix : Matrix I Y Real)
    (samples : Y -> Complex)
    (potentialDensity : Real) : Real :=
  kineticWeight * signedKinetic sign (extractComponents dualMatrix samples) +
    potentialWeight * potentialDensity

/-- Linear response of the local Higgs functional under simultaneous kinetic
measure, dual-frame, and potential-measure perturbations. -/
def localHiggsFirstResponse
    (kineticWeight kineticResponse potentialResponse : Real)
    (sign : I -> Real)
    (derivative variation : I -> Complex)
    (potentialDensity : Real) : Real :=
  kineticResponse * signedKinetic sign derivative +
    kineticWeight * signedKineticFirstVariation sign derivative variation +
    potentialResponse * potentialDensity

/-- A signed kinetic contraction is invariant under one common anchor phase. -/
theorem signedKinetic_gauge_invariant
    (sign : I -> Real) (derivative : I -> Complex) (g0 : Circle) :
    signedKinetic sign (fun i => (g0 : Complex) * derivative i) =
      signedKinetic sign derivative := by
  unfold signedKinetic
  simp [Complex.normSq_eq_norm_sq]

/-- The exact simultaneous affine perturbation is cubic. Its linear
coefficient is `localHiggsFirstResponse`; the remaining terms are displayed
rather than discarded. -/
theorem localHiggsFunctional_affine_expansion
    (kineticWeight kineticResponse potentialWeight potentialResponse : Real)
    (sign : I -> Real)
    (dualMatrix dualVariation : Matrix I Y Real)
    (samples : Y -> Complex) (potentialDensity epsilon : Real) :
    localHiggsFunctional
        (kineticWeight + epsilon * kineticResponse)
        (potentialWeight + epsilon * potentialResponse)
        sign (dualMatrix + epsilon • dualVariation) samples potentialDensity =
      localHiggsFunctional kineticWeight potentialWeight sign dualMatrix
          samples potentialDensity +
        epsilon * localHiggsFirstResponse
          kineticWeight kineticResponse potentialResponse sign
          (extractComponents dualMatrix samples)
          (extractComponents dualVariation samples) potentialDensity +
        epsilon ^ 2 *
          (kineticWeight * signedKinetic sign
              (extractComponents dualVariation samples) +
            kineticResponse * signedKineticFirstVariation sign
              (extractComponents dualMatrix samples)
              (extractComponents dualVariation samples)) +
        epsilon ^ 3 *
          (kineticResponse * signedKinetic sign
            (extractComponents dualVariation samples)) := by
  unfold localHiggsFunctional localHiggsFirstResponse
  rw [extractedKinetic_affine_expansion]
  ring

/-- At the base of the affine path, the derivative of the complete local Higgs
functional is exactly the displayed three-channel first response. -/
theorem hasDerivAt_localHiggsFunctional_affine
    (kineticWeight kineticResponse potentialWeight potentialResponse : Real)
    (sign : I -> Real)
    (dualMatrix dualVariation : Matrix I Y Real)
    (samples : Y -> Complex) (potentialDensity : Real) :
    HasDerivAt
      (fun epsilon => localHiggsFunctional
        (kineticWeight + epsilon * kineticResponse)
        (potentialWeight + epsilon * potentialResponse)
        sign (dualMatrix + epsilon • dualVariation) samples potentialDensity)
      (localHiggsFirstResponse
        kineticWeight kineticResponse potentialResponse sign
        (extractComponents dualMatrix samples)
        (extractComponents dualVariation samples) potentialDensity)
      0 := by
  have hFunction :
      (fun epsilon => localHiggsFunctional
        (kineticWeight + epsilon * kineticResponse)
        (potentialWeight + epsilon * potentialResponse)
        sign (dualMatrix + epsilon • dualVariation) samples potentialDensity) =
      fun epsilon =>
        localHiggsFunctional kineticWeight potentialWeight sign dualMatrix
            samples potentialDensity +
          epsilon * localHiggsFirstResponse
            kineticWeight kineticResponse potentialResponse sign
            (extractComponents dualMatrix samples)
            (extractComponents dualVariation samples) potentialDensity +
          epsilon ^ 2 *
            (kineticWeight * signedKinetic sign
                (extractComponents dualVariation samples) +
              kineticResponse * signedKineticFirstVariation sign
                (extractComponents dualMatrix samples)
                (extractComponents dualVariation samples)) +
          epsilon ^ 3 *
            (kineticResponse * signedKinetic sign
              (extractComponents dualVariation samples)) := by
    funext epsilon
    exact localHiggsFunctional_affine_expansion
      kineticWeight kineticResponse potentialWeight potentialResponse sign
      dualMatrix dualVariation samples potentialDensity epsilon
  rw [hFunction]
  simpa using
    ((((hasDerivAt_const 0
      (localHiggsFunctional kineticWeight potentialWeight sign dualMatrix
        samples potentialDensity)).add
      ((hasDerivAt_id 0).mul_const
        (localHiggsFirstResponse
          kineticWeight kineticResponse potentialResponse sign
          (extractComponents dualMatrix samples)
          (extractComponents dualVariation samples) potentialDensity))).add
      (((hasDerivAt_id 0).pow 2).mul_const
        (kineticWeight * signedKinetic sign
            (extractComponents dualVariation samples) +
          kineticResponse * signedKineticFirstVariation sign
            (extractComponents dualMatrix samples)
            (extractComponents dualVariation samples)))).add
      (((hasDerivAt_id 0).pow 3).mul_const
        (kineticResponse * signedKinetic sign
          (extractComponents dualVariation samples))))

/-- The complete local first response is invariant when the derivative and its
frame variation acquire the same anchor phase. The potential density and
geometric weights are held fixed. -/
theorem localHiggsFirstResponse_gauge_invariant
    (kineticWeight kineticResponse potentialResponse : Real)
    (sign : I -> Real) (derivative variation : I -> Complex)
    (potentialDensity : Real) (g0 : Circle) :
    localHiggsFirstResponse kineticWeight kineticResponse potentialResponse sign
        (fun i => (g0 : Complex) * derivative i)
        (fun i => (g0 : Complex) * variation i) potentialDensity =
      localHiggsFirstResponse kineticWeight kineticResponse potentialResponse
        sign derivative variation potentialDensity := by
  unfold localHiggsFirstResponse
  rw [signedKinetic_gauge_invariant]
  rw [signedKineticFirstVariation_gauge_invariant]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsLocalStressResponse.signedKinetic_gauge_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms signedKinetic_gauge_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsLocalStressResponse.localHiggsFunctional_affine_expansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms localHiggsFunctional_affine_expansion

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsLocalStressResponse.hasDerivAt_localHiggsFunctional_affine' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_localHiggsFunctional_affine

/-- info: 'PhysicsSM.Draft.NullEdge.HiggsLocalStressResponse.localHiggsFirstResponse_gauge_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms localHiggsFirstResponse_gauge_invariant

end PhysicsSM.Draft.NullEdge.HiggsLocalStressResponse

end
