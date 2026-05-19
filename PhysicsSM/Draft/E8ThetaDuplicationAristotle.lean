import PhysicsSM.Draft.E8ThetaWeightEnumeratorBridgeAristotle
import PhysicsSM.Draft.ThetaDuplicationProof

/-!
# Aristotle target: Jacobi theta duplication identities

This draft file isolates the two classical theta-constant duplication
identities needed by the Hamming Construction A / SPL theta-polynomial bridge.

The surrounding bridge is already packaged in
`PhysicsSM.Draft.E8ThetaWeightEnumeratorBridgeAristotle`: once these two
identities and the separate q-expansion coefficient bridge are proved, the
project-local `Theta_E8 = E4` theorem follows through the existing conditional
theorems there.

The proofs are developed in `ThetaDuplicationProof.lean` using Mathlib-only
imports (defining local `myΘ₂`, `myΘ₃`, `myΘ₄` matching SPL's conventions),
and connected here to SPL's definitions.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false
set_option linter.style.setOption false

open SpherePacking.ModularForms

namespace PhysicsSM.Coding
namespace E8ThetaSPLBridge

/-- SPL's `Θ₂` agrees with the local `myΘ₂` definition. -/
private theorem Θ₂_eq_myΘ₂ (tau : UpperHalfPlane) : Θ₂ tau = myΘ₂ (tau : ℂ) := by
  simp [Θ₂, myΘ₂, Θ₂_term]

/-- SPL's `Θ₃` agrees with the local `myΘ₃` definition. -/
private theorem Θ₃_eq_myΘ₃ (tau : UpperHalfPlane) : Θ₃ tau = myΘ₃ (tau : ℂ) := by
  simp [Θ₃, myΘ₃, Θ₃_term]

/-- SPL's `Θ₄` agrees with the local `myΘ₄` definition. -/
private theorem Θ₄_eq_myΘ₄ (tau : UpperHalfPlane) : Θ₄ tau = myΘ₄ (tau : ℂ) := by
  simp [Θ₄, myΘ₄, Θ₄_term]

/-- Classical theta duplication identity for `Theta2`. -/
theorem theta2_sq_duplication (tau : UpperHalfPlane) :
    (Θ₂ tau) ^ 2 = (2 : Complex) * Θ₂ (twoTau tau) * Θ₃ (twoTau tau) := by
  rw [Θ₂_eq_myΘ₂ tau, Θ₂_eq_myΘ₂ (twoTau tau), Θ₃_eq_myΘ₃ (twoTau tau)]
  show myΘ₂ ↑tau ^ 2 = 2 * myΘ₂ (↑(twoTau tau)) * myΘ₃ (↑(twoTau tau))
  simp only [twoTau, UpperHalfPlane.coe_mk]
  exact myTheta2_sq_duplication tau.im_pos

/-- Classical theta duplication identity for `Theta4`. -/
theorem theta4_sq_duplication (tau : UpperHalfPlane) :
    (Θ₄ tau) ^ 2 = (Θ₃ (twoTau tau)) ^ 2 - (Θ₂ (twoTau tau)) ^ 2 := by
  rw [Θ₄_eq_myΘ₄ tau, Θ₃_eq_myΘ₃ (twoTau tau), Θ₂_eq_myΘ₂ (twoTau tau)]
  show myΘ₄ ↑tau ^ 2 = myΘ₃ (↑(twoTau tau)) ^ 2 - myΘ₂ (↑(twoTau tau)) ^ 2
  simp only [twoTau, UpperHalfPlane.coe_mk]
  exact myTheta4_sq_duplication tau.im_pos

/--
With the duplication identities, the Hamming theta-constant polynomial is
SPL's `thetaE4` polynomial.
-/
theorem hammingThetaConstantPolynomial_eq_thetaE4_from_duplication
    (tau : UpperHalfPlane) :
    hammingThetaConstantPolynomial tau = SpherePacking.ModularForms.thetaE4 tau :=
  hammingThetaConstantPolynomial_eq_thetaE4_of_duplication
    theta2_sq_duplication theta4_sq_duplication tau

end E8ThetaSPLBridge
end PhysicsSM.Coding
