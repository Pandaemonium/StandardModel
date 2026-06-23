import Mathlib

/-!
# Null-step quantum-walk unitarity

The null-step walk uses closed-form Pauli rotations. This module certifies
unitarity of those rotations and their one-step product before treating the
walk as a genuine finite quantum evolution operator.
-/

open Complex Matrix
open scoped Matrix

noncomputable section

namespace PhysicsSM.Draft.NullEdgeQWUnitarity

abbrev CMat2 := Matrix (Fin 2) (Fin 2) ℂ

def IsUnitary2 (M : CMat2) : Prop :=
  M.conjTranspose * M = 1

def Rz (theta : ℝ) : CMat2 :=
  !![Complex.exp (-(theta : ℂ) * I), 0; 0, Complex.exp ((theta : ℂ) * I)]

def Rx (theta : ℝ) : CMat2 :=
  !![Complex.cos (theta : ℂ), -(I * Complex.sin (theta : ℂ));
     -(I * Complex.sin (theta : ℂ)), Complex.cos (theta : ℂ)]

def Ua (a k mu : ℝ) : CMat2 :=
  Rz (k * a) * Rx (mu * a)

theorem Rz_unitary (theta : ℝ) :
    IsUnitary2 (Rz theta) := by
  unfold IsUnitary2 Rz
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Complex.ext_iff, Matrix.mul_apply, Complex.exp_re, Complex.exp_im]
  all_goals
    exact ⟨by rw [← sq, ← sq, Real.cos_sq_add_sin_sq], by ring⟩

theorem Rx_unitary (theta : ℝ) :
    IsUnitary2 (Rx theta) := by
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [Rx]
  · norm_num [Matrix.mul_apply, Complex.ext_iff]
    norm_cast
    ring_nf
    norm_num
  · norm_num [Matrix.mul_apply, Complex.ext_iff]
    ring
  · norm_num [Matrix.mul_apply, Complex.ext_iff]
    ring
  · norm_num [Matrix.mul_apply, Complex.ext_iff]
    norm_cast
    ring_nf
    norm_num

theorem Ua_unitary (a k mu : ℝ) :
    IsUnitary2 (Ua a k mu) := by
  unfold IsUnitary2 Ua
  rw [Matrix.conjTranspose_mul, Matrix.mul_assoc,
    ← Matrix.mul_assoc (Rz (k * a)).conjTranspose, Rz_unitary (k * a),
    Matrix.one_mul, Rx_unitary (mu * a)]

end PhysicsSM.Draft.NullEdgeQWUnitarity
