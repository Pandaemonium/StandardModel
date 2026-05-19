import PhysicsSM.Draft.E8ThetaDim8MF
import PhysicsSM.Draft.E8ThetaSPLBridge

/-!
# Bridge from thetaE8_MF_eq_E4 to the SPL coefficient formula

This helper file connects the modular form identity `thetaE8_MF = E₄`
(proved in `E8ThetaDim8MF.lean`) to the SPL coefficient infrastructure
in `E8ThetaSPLBridge.lean`.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option maxHeartbeats 400000

open PhysicsSM.Coding.E8ThetaDim8
open PhysicsSM.Coding.E8ThetaSPLBridge
open SpherePacking.ModularForms
open scoped CongruenceSubgroup

namespace PhysicsSM.Coding.E8ThetaSPLBridge

/--
The q-expansion of `thetaE8_MF` equals `splThetaE4Series`.

This follows directly from `thetaE8_MF_eq_E4` (the modular form equality)
and `E₄_eq_thetaE4` (SPL's identity).
-/
theorem qExpansion_thetaE8_eq_splThetaE4 :
    ModularFormClass.qExpansion (1 : ℝ)
      (↑thetaE8_MF : UpperHalfPlane → ℂ) =
      splThetaE4Series := by
  have h1 : ModularFormClass.qExpansion (1 : ℝ)
      (↑thetaE8_MF : UpperHalfPlane → ℂ) =
      ModularFormClass.qExpansion (1 : ℝ)
      (↑(E₄ : ModularForm (CongruenceSubgroup.Gamma 1) 4) : UpperHalfPlane → ℂ) := by
    congr 1; exact congrArg _ thetaE8_MF_eq_E4
  rw [h1]
  change ModularFormClass.qExpansion (1 : ℝ) (↑(E₄ : ModularForm _ 4) : UpperHalfPlane → ℂ) =
    ModularFormClass.qExpansion (1 : ℝ) thetaE4
  rw [E₄_eq_thetaE4]

/--
The q-expansion coefficients of `thetaE8_MF` are the E₄ coefficients.
-/
theorem qExpansion_thetaE8_coeff (n : ℕ) :
    (ModularFormClass.qExpansion (1 : ℝ)
      (↑thetaE8_MF : UpperHalfPlane → ℂ)).coeff n =
      if n = 0 then 1 else (240 : ℂ) * (sigma3 n : ℂ) := by
  rw [qExpansion_thetaE8_eq_splThetaE4]
  exact splThetaE4Series_coeff_eq_local_e4 n

end PhysicsSM.Coding.E8ThetaSPLBridge
