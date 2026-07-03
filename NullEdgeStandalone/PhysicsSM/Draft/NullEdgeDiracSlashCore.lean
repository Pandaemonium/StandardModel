import Mathlib

/-!
# Draft.NullEdgeDiracSlashCore

Finite Dirac-slash square-root algebra for the null-edge program.

This draft module records the static operator-level square root of a `2 x 2`
visible momentum block. It proves, in explicit `(+---)` and Weyl-block
conventions, that the chiral Dirac slash of a finite four-momentum squares to
the determinant/Minkowski scalar. This is finite matrix algebra only; it is not
a continuum Dirac equation.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeDiracSlashCore

open Matrix Complex

/-- Minkowski scalar in the `(+---)` convention. -/
def minkowskiNorm (p : Fin 4 -> Complex) : Complex :=
  p 0 * p 0 - p 1 * p 1 - p 2 * p 2 - p 3 * p 3

/-- The `p_mu sigma^mu` Weyl block. -/
def sigmaMomentum (p : Fin 4 -> Complex) : Matrix (Fin 2) (Fin 2) Complex :=
  fun a b =>
    if a = 0 /\ b = 0 then p 0 + p 3
    else if a = 0 /\ b = 1 then p 1 - Complex.I * p 2
    else if a = 1 /\ b = 0 then p 1 + Complex.I * p 2
    else p 0 - p 3

/-- The `p_mu bar(sigma)^mu` Weyl block. -/
def barSigmaMomentum (p : Fin 4 -> Complex) : Matrix (Fin 2) (Fin 2) Complex :=
  fun a b =>
    if a = 0 /\ b = 0 then p 0 - p 3
    else if a = 0 /\ b = 1 then -p 1 + Complex.I * p 2
    else if a = 1 /\ b = 0 then -p 1 - Complex.I * p 2
    else p 0 + p 3

/-- Chiral `4 x 4` slash operator with off-diagonal Weyl blocks. -/
def chiralDiracSlash (p : Fin 4 -> Complex) :
    Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex :=
  fun a b =>
    match a, b with
    | Sum.inl _, Sum.inl _ => 0
    | Sum.inl i, Sum.inr j => sigmaMomentum p i j
    | Sum.inr i, Sum.inl j => barSigmaMomentum p i j
    | Sum.inr _, Sum.inr _ => 0

/-- The determinant of the Weyl momentum block is the Minkowski scalar. -/
theorem sigmaMomentum_det_eq_minkowskiNorm (p : Fin 4 -> Complex) :
    (sigmaMomentum p).det = minkowskiNorm p := by
  simp only [minkowskiNorm, sigmaMomentum, Matrix.det_fin_two]
  norm_num
  ring_nf
  simp [Complex.I_sq]
  ring

/-- First Weyl block in the Dirac-square identity. -/
theorem sigma_mul_barSigma_eq_norm (p : Fin 4 -> Complex) :
    sigmaMomentum p * barSigmaMomentum p =
      minkowskiNorm p • (1 : Matrix (Fin 2) (Fin 2) Complex) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp only [sigmaMomentum, barSigmaMomentum, minkowskiNorm, Matrix.mul_apply,
      Fin.sum_univ_two, Matrix.smul_apply, Matrix.one_apply, smul_eq_mul] <;>
    simp [Complex.ext_iff] <;> constructor <;> ring

/-- Second Weyl block in the Dirac-square identity. -/
theorem barSigma_mul_sigma_eq_norm (p : Fin 4 -> Complex) :
    barSigmaMomentum p * sigmaMomentum p =
      minkowskiNorm p • (1 : Matrix (Fin 2) (Fin 2) Complex) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp only [sigmaMomentum, barSigmaMomentum, minkowskiNorm, Matrix.mul_apply,
      Fin.sum_univ_two, Matrix.smul_apply, Matrix.one_apply, smul_eq_mul] <;>
    simp [Complex.ext_iff] <;> constructor <;> ring

/-- Static finite Dirac square root of the momentum determinant. -/
theorem chiralDiracSlash_sq_eq_norm (p : Fin 4 -> Complex) :
    chiralDiracSlash p * chiralDiracSlash p =
      minkowskiNorm p •
        (1 : Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex) := by
  ext a b
  rcases a with a | a <;> rcases b with b | b <;>
    simp only [Matrix.mul_apply, Fintype.sum_sum_type, chiralDiracSlash,
      Matrix.smul_apply, Matrix.one_apply, smul_eq_mul]
  · have := congrFun (congrFun (sigma_mul_barSigma_eq_norm p) a) b
    simpa [Matrix.mul_apply, Matrix.smul_apply, Matrix.one_apply] using this
  · simp
  · simp
  · have := congrFun (congrFun (barSigma_mul_sigma_eq_norm p) a) b
    simpa [Matrix.mul_apply, Matrix.smul_apply, Matrix.one_apply] using this

/--
Bridge theorem: if an external Plucker theorem identifies the momentum scalar
with a mass functional, the chiral slash squares to that mass functional.
-/
theorem chiralDiracSlash_sq_eq_mass_of_norm_eq
    (p : Fin 4 -> Complex) (mass : Complex)
    (h : minkowskiNorm p = mass) :
    chiralDiracSlash p * chiralDiracSlash p =
      mass •
        (1 : Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex) := by
  rw [← h, chiralDiracSlash_sq_eq_norm]

end PhysicsSM.Draft.NullEdgeDiracSlashCore

end
