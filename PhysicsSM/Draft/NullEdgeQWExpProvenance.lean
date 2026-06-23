import Mathlib

/-!
# Null-step quantum-walk exponential provenance

This focused handoff asks Aristotle to connect the closed-form rotation gates
used in the null-step quantum-walk core to literal matrix exponentials of Pauli
generators.

The already-integrated core deliberately defines `Rz` and `Rx` by Euler closed
forms because those are enough for trace, determinant, quasienergy, and
continuum-coherence theorems. These two provenance lemmas are optional, but they
make the paper-facing notation

```text
U_a(k) = exp(-i k a sigma_z) exp(-i mu a sigma_x)
```

match the formal definitions directly.
-/

open Complex Matrix
open scoped Matrix

noncomputable section

namespace PhysicsSM.Draft.NullEdgeQWExpProvenance

abbrev CMat2 := Matrix (Fin 2) (Fin 2) ℂ

/-- Pauli `sigma_x`. -/
def sigmaX : CMat2 :=
  !![(0 : ℂ), 1; 1, 0]

/-- Pauli `sigma_z`. -/
def sigmaZ : CMat2 :=
  !![(1 : ℂ), 0; 0, -1]

/-- Closed-form `z` rotation gate. -/
def Rz (theta : ℝ) : CMat2 :=
  !![Complex.exp (-(theta : ℂ) * I), 0; 0, Complex.exp ((theta : ℂ) * I)]

/-- Closed-form `x` rotation gate. -/
def Rx (theta : ℝ) : CMat2 :=
  !![Complex.cos (theta : ℂ), -(I * Complex.sin (theta : ℂ));
     -(I * Complex.sin (theta : ℂ)), Complex.cos (theta : ℂ)]

/-
The closed-form `Rz` gate is the matrix exponential of `-i theta sigma_z`.
-/
theorem Rz_eq_exp (theta : ℝ) :
    Rz theta = NormedSpace.exp (((-(theta : ℂ) * I) : ℂ) • sigmaZ) := by
  -- `(-theta i) • sigma_z` is diagonal, so its exponential is the diagonal of exponentials.
  have hdiag : ((-(theta : ℂ) * I) : ℂ) • sigmaZ
      = Matrix.diagonal ![-(theta : ℂ) * I, (theta : ℂ) * I] := by
    ext i j; fin_cases i <;> fin_cases j <;> simp [sigmaZ, Matrix.diagonal]
  rw [hdiag, Matrix.exp_diagonal]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Rz, Matrix.diagonal, Complex.exp_eq_exp_ℂ]

/-
The closed-form `Rx` gate is the matrix exponential of `-i theta sigma_x`.
-/
theorem Rx_eq_exp (theta : ℝ) :
    Rx theta = NormedSpace.exp (((-(theta : ℂ) * I) : ℂ) • sigmaX) := by
  -- Diagonalize `sigma_x = U * sigma_z * U⁻¹` with the (unnormalized) Hadamard `U`,
  -- then use `exp_conj` and `exp_diagonal`.
  set c : ℂ := -(theta : ℂ) * I with hc
  have hUinv : (!![1, 1; 1, -1] : CMat2)⁻¹ = !![1/2, 1/2; 1/2, -(1/2)] := by
    rw [Matrix.inv_def]
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Matrix.det_fin_two_of, Matrix.adjugate_fin_two] <;> norm_num
  have hUunit : IsUnit (!![1, 1; 1, -1] : CMat2) := by
    rw [Matrix.isUnit_iff_isUnit_det]
    norm_num [Matrix.det_fin_two_of]
  have hconj : c • sigmaX
      = (!![1, 1; 1, -1] : CMat2) * (c • sigmaZ) * (!![1, 1; 1, -1] : CMat2)⁻¹ := by
    rw [hUinv]
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [sigmaX, sigmaZ, Matrix.mul_apply, Fin.sum_univ_two] <;> ring
  have hexpZ : NormedSpace.exp (c • sigmaZ)
      = Matrix.diagonal ![Complex.exp c, Complex.exp (-c)] := by
    have hdiag : c • sigmaZ = Matrix.diagonal ![c, -c] := by
      ext i j; fin_cases i <;> fin_cases j <;> simp [sigmaZ, Matrix.diagonal]
    rw [hdiag, Matrix.exp_diagonal]
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Matrix.diagonal, Complex.exp_eq_exp_ℂ]
  rw [hconj, Matrix.exp_conj _ _ hUunit, hexpZ, hUinv]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Rx, Matrix.mul_apply, Fin.sum_univ_two, Matrix.vecMul_diagonal, hc,
      Complex.cos, Complex.sin, Complex.exp_neg] <;>
    ring_nf <;> simp [Complex.I_sq] <;> ring

/-- Exponential provenance for the one-step walk. -/
theorem Ua_eq_exp_product (a k mu : ℝ) :
    Rz (k * a) * Rx (mu * a)
      =
    NormedSpace.exp (((-(k * a : ℝ) : ℂ) * I) • sigmaZ)
      * NormedSpace.exp (((-(mu * a : ℝ) : ℂ) * I) • sigmaX) := by
  rw [Rz_eq_exp, Rx_eq_exp]

end PhysicsSM.Draft.NullEdgeQWExpProvenance
