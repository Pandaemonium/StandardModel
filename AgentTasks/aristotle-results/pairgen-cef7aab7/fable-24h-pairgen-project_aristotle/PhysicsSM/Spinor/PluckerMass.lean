import Mathlib

/-!
# Primitive two-component spinor wedge (Pluecker) data

Clean-room reconstruction of the trusted spinor wedge used by the phase-sensitive
Pluecker quartic interaction.  A `CSpinor` is a two-component complex spinor and
`spinorWedge` is the antisymmetric primitive Pluecker coordinate.

Lean 4.28.0.
-/

noncomputable section

namespace PhysicsSM.Spinor.PluckerMass

/-- A two-component complex spinor. -/
abbrev CSpinor := Fin 2 → Complex

/-- The primitive antisymmetric wedge (Pluecker coordinate) of two spinors. -/
def spinorWedge (psi phi : CSpinor) : Complex :=
  psi 0 * phi 1 - psi 1 * phi 0

/-- The complex modulus-squared, `u * conj u`. -/
def complexAbsSq (u : Complex) : Complex :=
  u * (starRingEnd Complex) u

/-- `complexAbsSq` is the (real) squared norm, cast to `Complex`. -/
theorem complexAbsSq_eq_ofReal_normSq (u : Complex) :
    complexAbsSq u = ((Complex.normSq u : ℝ) : Complex) := by
  rw [complexAbsSq, Complex.mul_conj]

end PhysicsSM.Spinor.PluckerMass
