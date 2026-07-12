import PhysicsSM.Draft.NullEdge.SU2LocalCrossingCharge
import PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge

/-!
# Exact Jacobian of the ordered massless Weyl sector

This target extracts the real Pauli-vector Jacobian of the ordered positive
Weyl step. It supplies the analytic bridge from a live symbol to the existing
Jacobian-sign charge API.
-/

open Matrix

noncomputable section

namespace PhysicsSM.Draft.NullEdge.LiveWeylJacobian

abbrev V3 := Fin 3 -> Real
abbrev J3 := Matrix (Fin 3) (Fin 3) Real
abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

def u0 (q : V3) : Real :=
  Real.cos (q 0) * Real.cos (q 1) * Real.cos (q 2) -
    Real.sin (q 0) * Real.sin (q 1) * Real.sin (q 2)

def weylVector (q : V3) : V3
  | 0 => Real.sin (q 0) * Real.cos (q 1) * Real.cos (q 2) +
      Real.cos (q 0) * Real.sin (q 1) * Real.sin (q 2)
  | 1 => Real.cos (q 0) * Real.sin (q 1) * Real.cos (q 2) -
      Real.sin (q 0) * Real.cos (q 1) * Real.sin (q 2)
  | 2 => Real.cos (q 0) * Real.cos (q 1) * Real.sin (q 2) +
      Real.sin (q 0) * Real.sin (q 1) * Real.cos (q 2)

noncomputable def weylFactor (q : Real) (A : M2) : M2 :=
  (Real.cos q : Complex) • 1 -
    (Complex.I * (Real.sin q : Complex)) • A

noncomputable def weylStep (q : V3) : M2 :=
  weylFactor (q 0) CubicWeylSectorCharge.sigma1 *
    weylFactor (q 1) CubicWeylSectorCharge.sigma2 *
    weylFactor (q 2) CubicWeylSectorCharge.sigma3

noncomputable def pauliForm (q : V3) : M2 :=
  (u0 q : Complex) • 1 - Complex.I •
    ((weylVector q 0 : Complex) • CubicWeylSectorCharge.sigma1 +
      (weylVector q 1 : Complex) • CubicWeylSectorCharge.sigma2 +
      (weylVector q 2 : Complex) • CubicWeylSectorCharge.sigma3)

/-- Exact Pauli decomposition of the actual ordered positive Weyl symbol. -/
theorem weylStep_eq_pauliForm (q : V3) : weylStep q = pauliForm q := by
  sorry

def weylJacobian (q : V3) : J3 :=
  !![
    Real.cos (q 0) * Real.cos (q 1) * Real.cos (q 2) -
      Real.sin (q 0) * Real.sin (q 1) * Real.sin (q 2),
    -(Real.sin (q 0) * Real.sin (q 1) * Real.cos (q 2)) +
      Real.cos (q 0) * Real.cos (q 1) * Real.sin (q 2),
    -(Real.sin (q 0) * Real.cos (q 1) * Real.sin (q 2)) +
      Real.cos (q 0) * Real.sin (q 1) * Real.cos (q 2);
    -(Real.sin (q 0) * Real.sin (q 1) * Real.cos (q 2)) -
      Real.cos (q 0) * Real.cos (q 1) * Real.sin (q 2),
    Real.cos (q 0) * Real.cos (q 1) * Real.cos (q 2) +
      Real.sin (q 0) * Real.sin (q 1) * Real.sin (q 2),
    -(Real.sin (q 0) * Real.cos (q 1) * Real.cos (q 2)) -
      Real.cos (q 0) * Real.sin (q 1) * Real.sin (q 2);
    -(Real.sin (q 0) * Real.cos (q 1) * Real.sin (q 2)) +
      Real.cos (q 0) * Real.sin (q 1) * Real.cos (q 2),
    Real.sin (q 0) * Real.cos (q 1) * Real.cos (q 2) -
      Real.cos (q 0) * Real.sin (q 1) * Real.sin (q 2),
    Real.cos (q 0) * Real.cos (q 1) * Real.cos (q 2) -
      Real.sin (q 0) * Real.sin (q 1) * Real.sin (q 2)]

/-- The displayed matrix is the actual complete Frechet derivative, tested on
every coordinate basis vector and output coordinate. -/
theorem fderiv_weylVector_apply_single (q : V3) (i j : Fin 3) :
    fderiv Real weylVector q (Pi.single j 1) i = weylJacobian q i j := by
  sorry

theorem det_weylJacobian (q : V3) :
    (weylJacobian q).det =
      u0 q * (Real.cos (q 1) ^ 2 - Real.sin (q 1) ^ 2) := by
  sorry

def origin : V3 := 0
def rankDeficientControl : V3 := fun
  | 0 => 0
  | 1 => Real.pi / 4
  | 2 => 0

theorem origin_jacobian_det : (weylJacobian origin).det = 1 := by
  sorry

theorem origin_localCharge :
    PhysicsSM.Draft.NullEdge.SU2LocalCrossingCharge.localCrossingCharge
      (weylJacobian origin) = 1 := by
  sorry

theorem rankDeficientControl_det :
    (weylJacobian rankDeficientControl).det = 0 := by
  sorry

theorem rankDeficientControl_charge :
    PhysicsSM.Draft.NullEdge.SU2LocalCrossingCharge.localCrossingCharge
      (weylJacobian rankDeficientControl) = 0 := by
  sorry

end PhysicsSM.Draft.NullEdge.LiveWeylJacobian
