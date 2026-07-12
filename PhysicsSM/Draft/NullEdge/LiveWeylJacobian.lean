import PhysicsSM.Draft.NullEdge.SU2LocalCrossingCharge
import PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge

/-!
# Exact Jacobian of the ordered massless Weyl sector

This module extracts the real Pauli-vector Jacobian of the ordered positive
Weyl step. It supplies the analytic bridge from a live symbol to the existing
Jacobian-sign charge API.

Provenance: internal extraction from the live ordered Weyl step; all proof
bodies were completed by Aristotle project
`6a25f9f7-4036-47ea-95a6-d677f0b812ce` on 2026-07-11.
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
  simp only [weylStep, pauliForm, weylFactor, CubicWeylSectorCharge.sigma1,
    CubicWeylSectorCharge.sigma2, CubicWeylSectorCharge.sigma3, u0, weylVector]
  ext i j
  fin_cases i <;> fin_cases j <;>
    (apply Complex.ext) <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply, Complex.add_re, Complex.add_im,
      Complex.sub_re, Complex.sub_im, Complex.mul_re, Complex.mul_im,
      Complex.I_re, Complex.I_im] <;>
    ring

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

/-- The continuous linear map `v ↦ weylJacobian q *ᵥ v`, the candidate Frechet
derivative of `weylVector` at `q`. -/
noncomputable def weylJacobianCLM (q : V3) : V3 →L[ℝ] V3 :=
  LinearMap.toContinuousLinearMap (weylJacobian q).mulVecLin

/-- `weylVector` is Frechet differentiable at every `q` with derivative given by
the matrix `weylJacobian q` acting by multiplication. -/
theorem hasFDerivAt_weylVector (q : V3) :
    HasFDerivAt weylVector (weylJacobianCLM q) q := by
  have p0 : HasFDerivAt (fun q : V3 => q 0)
      (ContinuousLinearMap.proj (0 : Fin 3) : V3 →L[ℝ] ℝ) q :=
    (ContinuousLinearMap.proj (0 : Fin 3) : V3 →L[ℝ] ℝ).hasFDerivAt
  have p1 : HasFDerivAt (fun q : V3 => q 1)
      (ContinuousLinearMap.proj (1 : Fin 3) : V3 →L[ℝ] ℝ) q :=
    (ContinuousLinearMap.proj (1 : Fin 3) : V3 →L[ℝ] ℝ).hasFDerivAt
  have p2 : HasFDerivAt (fun q : V3 => q 2)
      (ContinuousLinearMap.proj (2 : Fin 3) : V3 →L[ℝ] ℝ) q :=
    (ContinuousLinearMap.proj (2 : Fin 3) : V3 →L[ℝ] ℝ).hasFDerivAt
  rw [hasFDerivAt_pi']
  intro i
  fin_cases i
  · show HasFDerivAt (fun q : V3 => weylVector q 0)
      ((ContinuousLinearMap.proj (0 : Fin 3)).comp (weylJacobianCLM q)) q
    have h := (((p0.sin.mul p1.cos).mul p2.cos).add ((p0.cos.mul p1.sin).mul p2.sin))
    convert h using 1
    ext v
    simp only [ContinuousLinearMap.comp_apply, ContinuousLinearMap.proj_apply,
      weylJacobianCLM, LinearMap.coe_toContinuousLinearMap', Matrix.mulVecLin_apply]
    simp [weylJacobian, Matrix.mulVec, dotProduct, Fin.sum_univ_three, Matrix.vecHead,
      Matrix.vecTail]
    ring
  · show HasFDerivAt (fun q : V3 => weylVector q 1)
      ((ContinuousLinearMap.proj (1 : Fin 3)).comp (weylJacobianCLM q)) q
    have h := (((p0.cos.mul p1.sin).mul p2.cos).sub ((p0.sin.mul p1.cos).mul p2.sin))
    convert h using 1
    ext v
    simp only [ContinuousLinearMap.comp_apply, ContinuousLinearMap.proj_apply,
      weylJacobianCLM, LinearMap.coe_toContinuousLinearMap', Matrix.mulVecLin_apply]
    simp [weylJacobian, Matrix.mulVec, dotProduct, Fin.sum_univ_three, Matrix.vecHead,
      Matrix.vecTail]
    ring
  · show HasFDerivAt (fun q : V3 => weylVector q 2)
      ((ContinuousLinearMap.proj (2 : Fin 3)).comp (weylJacobianCLM q)) q
    have h := (((p0.cos.mul p1.cos).mul p2.sin).add ((p0.sin.mul p1.sin).mul p2.cos))
    convert h using 1
    ext v
    simp only [ContinuousLinearMap.comp_apply, ContinuousLinearMap.proj_apply,
      weylJacobianCLM, LinearMap.coe_toContinuousLinearMap', Matrix.mulVecLin_apply]
    simp [weylJacobian, Matrix.mulVec, dotProduct, Fin.sum_univ_three, Matrix.vecHead,
      Matrix.vecTail]
    ring

/-- The displayed matrix is the actual complete Frechet derivative, tested on
every coordinate basis vector and output coordinate. -/
theorem fderiv_weylVector_apply_single (q : V3) (i j : Fin 3) :
    fderiv Real weylVector q (Pi.single j 1) i = weylJacobian q i j := by
  rw [(hasFDerivAt_weylVector q).fderiv]
  simp only [weylJacobianCLM, LinearMap.coe_toContinuousLinearMap', Matrix.mulVecLin_apply]
  simp [Matrix.mulVec_single]

theorem det_weylJacobian (q : V3) :
    (weylJacobian q).det =
      u0 q * (Real.cos (q 1) ^ 2 - Real.sin (q 1) ^ 2) := by
  simp only [weylJacobian, Matrix.det_fin_three, u0, Matrix.of_apply, Matrix.cons_val',
    Matrix.cons_val_zero, Matrix.empty_val', Matrix.cons_val_fin_one, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.head_fin_const, Matrix.cons_val_two, Matrix.tail_cons]
  linear_combination
    ((Real.sin (q 2) ^ 2 + Real.cos (q 2) ^ 2) * (Real.cos (q 1) ^ 2 - Real.sin (q 1) ^ 2) *
      (Real.cos (q 0) * Real.cos (q 1) * Real.cos (q 2) -
        Real.sin (q 0) * Real.sin (q 1) * Real.sin (q 2)))
        * Real.sin_sq_add_cos_sq (q 0)
    + ((Real.cos (q 1) ^ 2 - Real.sin (q 1) ^ 2) *
      (Real.cos (q 0) * Real.cos (q 1) * Real.cos (q 2) -
        Real.sin (q 0) * Real.sin (q 1) * Real.sin (q 2)))
        * Real.sin_sq_add_cos_sq (q 2)

def origin : V3 := 0
def rankDeficientControl : V3 := fun
  | 0 => 0
  | 1 => Real.pi / 4
  | 2 => 0

theorem origin_jacobian_det : (weylJacobian origin).det = 1 := by
  rw [det_weylJacobian]
  simp [origin, u0]

theorem origin_localCharge :
    PhysicsSM.Draft.NullEdge.SU2LocalCrossingCharge.localCrossingCharge
      (weylJacobian origin) = 1 := by
  apply SU2LocalCrossingCharge.localCrossingCharge_eq_one
  rw [origin_jacobian_det]
  norm_num

theorem rankDeficientControl_det :
    (weylJacobian rankDeficientControl).det = 0 := by
  rw [det_weylJacobian]
  simp [rankDeficientControl, Real.cos_pi_div_four, Real.sin_pi_div_four]

theorem rankDeficientControl_charge :
    PhysicsSM.Draft.NullEdge.SU2LocalCrossingCharge.localCrossingCharge
      (weylJacobian rankDeficientControl) = 0 :=
  SU2LocalCrossingCharge.localCrossingCharge_eq_zero _ rankDeficientControl_det

end PhysicsSM.Draft.NullEdge.LiveWeylJacobian
