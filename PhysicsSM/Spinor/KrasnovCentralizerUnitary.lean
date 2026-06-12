import Mathlib
import PhysicsSM.Spinor.KrasnovComplexModuleInstance
import PhysicsSM.Spinor.KrasnovHermitianSesquilinear
import PhysicsSM.Spinor.KrasnovQubitCoordinateFlattening

/-!
# Spinor.KrasnovCentralizerUnitary

The centralizer theorem for real-linear maps on `𝕆²` with respect to the
Krasnov complex structure `J = rightMulE111`, stated with Mathlib's
`LinearMap` infrastructure.

## Main result

A real-linear endomorphism `T : OctonionicQubit →ₗ[ℝ] OctonionicQubit`
commutes with `rightMulE111` if and only if it is ℂ-linear with respect
to the Krasnov complex module structure (i.e., `T (z • q) = z • T q` for
all `z : ℂ`).

## Claim boundary

This is a linear-algebra theorem about the Krasnov complex structure. It
does not define `Spin(9)`, prove a centralizer–Spin intersection theorem,
or prove a Standard Model gauge group identification.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Spinor.KrasnovComplexStructure

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Spinor.OctonionicQubit

/-! ## Complex-linearity predicate -/

/-- A real-linear map `T : OctonionicQubit →ₗ[ℝ] OctonionicQubit` is
    **ℂ-linear for the Krasnov structure** if it commutes with the
    complex scalar action `z • q` induced by `rightMulE111`. -/
def IsComplexLinearForKrasnovStructure
    (T : OctonionicQubit →ₗ[ℝ] OctonionicQubit) : Prop :=
  ∀ (z : ℂ) (q : OctonionicQubit), T (z • q) = z • T q

/-! ## The centralizer theorem -/

/-- **Forward direction**: a real-linear map that commutes with
    `rightMulE111` is ℂ-linear for the Krasnov structure.

    The ℂ-action is `z • q = z.re • q + z.im • J(q)`. Real-linearity
    distributes `T` over the sum, and the commutation hypothesis handles
    the `J` term. -/
theorem commutes_rightMulE111_of_complexLinear
    (T : OctonionicQubit →ₗ[ℝ] OctonionicQubit)
    (hT : ∀ q, T (rightMulE111 q) = rightMulE111 (T q)) :
    IsComplexLinearForKrasnovStructure T := by
  intro z q
  simp only [complex_smul_def, complexSmul]
  rw [map_add, map_smul, map_smul, hT]

/-- **Reverse direction**: a real-linear map that is ℂ-linear for the
    Krasnov structure commutes with `rightMulE111`.

    Since `rightMulE111 q = I • q`, we have
    `T(J q) = T(I • q) = I • T q = J(T q)`. -/
theorem complexLinear_of_commutes_rightMulE111
    (T : OctonionicQubit →ₗ[ℝ] OctonionicQubit)
    (hT : IsComplexLinearForKrasnovStructure T) :
    ∀ q, T (rightMulE111 q) = rightMulE111 (T q) := by
  intro q
  rw [rightMulE111_eq_I_smul, hT, rightMulE111_eq_I_smul]

/-- **The centralizer theorem**: a real-linear endomorphism of `𝕆²`
    commutes with `rightMulE111` if and only if it is ℂ-linear with
    respect to the Krasnov complex module structure. -/
theorem realLinearMap_commutes_rightMulE111_iff_complexLinear
    (T : OctonionicQubit →ₗ[ℝ] OctonionicQubit) :
    (∀ q, T (rightMulE111 q) = rightMulE111 (T q)) ↔
      IsComplexLinearForKrasnovStructure T :=
  ⟨commutes_rightMulE111_of_complexLinear T,
   complexLinear_of_commutes_rightMulE111 T⟩

end PhysicsSM.Spinor.KrasnovComplexStructure
