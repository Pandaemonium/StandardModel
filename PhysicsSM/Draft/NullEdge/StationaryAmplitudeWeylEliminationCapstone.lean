import PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylEliminationCertificate
import PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylLiveMatrixNumeratorBridge

/-!
# Live stationary-Weyl elimination capstone

This on-demand module composes the imported live matrix-to-numerator bridge
with the generated 522-term exact elimination certificate.  It is intentionally
kept out of `PhysicsSMDraft.lean`: rebuilding the generated certificate's exact
normalization is expensive, while its separate guard records the same standard
axiom footprint as the surrounding draft theory.

The conclusion is a necessary branch condition, not a complete node census or
a sufficiency theorem.  The mandatory `(1 + tz^2)^2` chart factor remains in
the underlying certificate and is canceled only by real positivity there.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylEliminationCapstone

open StationaryAmplitudeWeylTangent
open StationaryAmplitudeWeylAlgebraicOffAxisAlias
open StationaryAmplitudeWeylEliminationCertificate
open StationaryAmplitudeWeylLiveMatrixNumeratorBridge

/-- The live bridge and generated certificate use exactly the same three
primitive tangent-chart numerator polynomials. -/
theorem live_numerators_eq_certificate (tx ty tz : Real) :
    Fx tx ty tz = certFx tx ty tz ∧
      Fy tx ty tz = certFy tx ty tz ∧
      Fz tx ty tz = certFz tx ty tz := by
  constructor
  · unfold Fx certFx
    ring
  · constructor
    · unfold Fy certFy
      ring
    · unfold Fz certFz
      ring

/-- Every identity crossing of the imported live matrix lies on the zero,
quintic, or sextic branch of the generated exact elimination certificate. -/
theorem live_alias_forces_certificate_branch {tx ty tz : Real}
    (hLive : weylStep (unitPhase tx) (unitPhase ty) (unitPhase tz) = 1) :
    tz = 0 ∨ certRootPoly tx ty tz = 0 ∨ certExcludedPoly tx ty tz = 0 := by
  rcases live_eq_one_implies_numerators_zero hLive with ⟨hx, hy, hz⟩
  rcases live_numerators_eq_certificate tx ty tz with ⟨hFx, hFy, hFz⟩
  exact eliminationFactorNecessaryOfNumeratorsZero tx ty tz
    (hFx.symm.trans hx) (hFy.symm.trans hy) (hFz.symm.trans hz)

/-- The same live necessary condition expressed in the canonical quintic and
sextic names used by the stationary-Weyl algebraic branch modules. -/
theorem live_alias_forces_elimination_branch {tx ty tz : Real}
    (hLive : weylStep (unitPhase tx) (unitPhase ty) (unitPhase tz) = 1) :
    tz = 0 ∨ rootPoly tz = 0 ∨ excludedPoly tz = 0 := by
  simpa [rootPoly, certRootPoly, excludedPoly, certExcludedPoly] using
    (live_alias_forces_certificate_branch hLive)

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylEliminationCapstone
