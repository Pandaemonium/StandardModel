import Mathlib

/-!
# Finite Dirac-slash square root core

Standalone finite algebra for the null-edge program.

This file isolates the static operator-level square root of a `2 x 2`
Hermitian momentum block.  The target is not a continuum Dirac equation.
It is the finite Clifford identity saying that the chiral Dirac slash of a
visible four-momentum squares to the determinant/Minkowski scalar.
-/

noncomputable section

namespace NullEdgeDiracSlashCore

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
  sorry

/-- First Weyl block in the Dirac-square identity. -/
theorem sigma_mul_barSigma_eq_norm (p : Fin 4 -> Complex) :
    sigmaMomentum p * barSigmaMomentum p =
      minkowskiNorm p • (1 : Matrix (Fin 2) (Fin 2) Complex) := by
  sorry

/-- Second Weyl block in the Dirac-square identity. -/
theorem barSigma_mul_sigma_eq_norm (p : Fin 4 -> Complex) :
    barSigmaMomentum p * sigmaMomentum p =
      minkowskiNorm p • (1 : Matrix (Fin 2) (Fin 2) Complex) := by
  sorry

/-- Static finite Dirac square root of the momentum determinant. -/
theorem chiralDiracSlash_sq_eq_norm (p : Fin 4 -> Complex) :
    chiralDiracSlash p * chiralDiracSlash p =
      minkowskiNorm p •
        (1 : Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) Complex) := by
  sorry

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
  sorry

end NullEdgeDiracSlashCore

end
