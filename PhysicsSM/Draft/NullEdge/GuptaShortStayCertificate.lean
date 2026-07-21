import PhysicsSM.Draft.NullEdge.StayLaurentUnitarityClassification
import PhysicsSM.Draft.NullEdge.StationaryAmplitudeProjectorWalk

/-!
# Projector-factorized stay walk certificate

This module composes the existing clean-room projector factorization motivated
by Gupta and Short, arXiv:2601.15885v3, with the repository's complete Laurent
unitarity classification. No implementation text is copied from the paper.

The target is one-axis finite algebra. It does not claim that the corresponding
3+1 product walk is free of all low-energy aliases; Gupta and Short explicitly
find residual isolated solutions in their 3+1 family.
-/

open Matrix Complex

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GuptaShortStayCertificate

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- The already-verified projector-factorized coefficients satisfy all ten
exact Laurent identities. The two star projections need not commute. -/
theorem projector_factorization_certificate
    (P Q : StationaryAmplitudeProjectorWalk.Mat n) (hP : IsStarProjection P)
    (hQ : IsStarProjection Q) :
    StayLaurentUnitarityClassification.Certificate
      (StationaryAmplitudeProjectorWalk.gammaPlus P Q)
      (StationaryAmplitudeProjectorWalk.gammaZero P Q)
      (StationaryAmplitudeProjectorWalk.gammaMinus P Q) := by
  apply StayLaurentUnitarityClassification.certificate_of_unitary_on_circle
  intro z hz
  unfold StayLaurentUnitarityClassification.symbol
  rw [← StationaryAmplitudeProjectorWalk.stationaryWalk_expansion z P Q hz.1]
  have h := StationaryAmplitudeProjectorWalk.stationaryWalk_unitary
    z P Q hz.1 hP hQ hz.2
  simpa [StayLaurentUnitarityClassification.IsUnitary,
    StationaryAmplitudeProjectorWalk.IsUnitary] using h

/-- The certificate and all-circle unitarity descriptions agree for the
projector-factorized walk. -/
theorem projector_factorization_classification
    (P Q : StationaryAmplitudeProjectorWalk.Mat n) (hP : IsStarProjection P)
    (hQ : IsStarProjection Q) :
    StayLaurentUnitarityClassification.Certificate
        (StationaryAmplitudeProjectorWalk.gammaPlus P Q)
        (StationaryAmplitudeProjectorWalk.gammaZero P Q)
        (StationaryAmplitudeProjectorWalk.gammaMinus P Q) ∧
      ∀ z, StayLaurentUnitarityClassification.OnCircle z →
        StayLaurentUnitarityClassification.IsUnitary
          (StayLaurentUnitarityClassification.symbol
            (StationaryAmplitudeProjectorWalk.gammaPlus P Q)
            (StationaryAmplitudeProjectorWalk.gammaZero P Q)
            (StationaryAmplitudeProjectorWalk.gammaMinus P Q) z) := by
  have hcert := projector_factorization_certificate P Q hP hQ
  exact ⟨hcert,
    StayLaurentUnitarityClassification.unitary_of_certificate _ _ _ hcert⟩

/-- Explicit nondegenerate rational witness: the two projectors do not commute
and the onsite branch is genuinely nonzero. -/
theorem rational_projector_stay_control :
    StationaryAmplitudeProjectorWalk.projA *
        StationaryAmplitudeProjectorWalk.projB ≠
      StationaryAmplitudeProjectorWalk.projB *
        StationaryAmplitudeProjectorWalk.projA ∧
      StationaryAmplitudeProjectorWalk.gammaZero
        StationaryAmplitudeProjectorWalk.projA
        StationaryAmplitudeProjectorWalk.projB ≠ 0 := by
  exact ⟨StationaryAmplitudeProjectorWalk.projectors_do_not_commute,
    StationaryAmplitudeProjectorWalk.gammaZero_nonzero.2⟩

/-- The explicit rational witness satisfies the complete ten-identity
certificate, not merely a one-phase unitary check. -/
theorem rational_projector_certificate :
    StayLaurentUnitarityClassification.Certificate
      (StationaryAmplitudeProjectorWalk.gammaPlus
        StationaryAmplitudeProjectorWalk.projA
        StationaryAmplitudeProjectorWalk.projB)
      (StationaryAmplitudeProjectorWalk.gammaZero
        StationaryAmplitudeProjectorWalk.projA
        StationaryAmplitudeProjectorWalk.projB)
      (StationaryAmplitudeProjectorWalk.gammaMinus
        StationaryAmplitudeProjectorWalk.projA
        StationaryAmplitudeProjectorWalk.projB) := by
  exact projector_factorization_certificate _ _
    StationaryAmplitudeProjectorWalk.projA_isStarProjection
    StationaryAmplitudeProjectorWalk.projB_isStarProjection

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.GuptaShortStayCertificate.projector_factorization_certificate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projector_factorization_certificate

/-- info: 'PhysicsSM.Draft.NullEdge.GuptaShortStayCertificate.rational_projector_certificate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_projector_certificate

end PhysicsSM.Draft.NullEdge.GuptaShortStayCertificate
