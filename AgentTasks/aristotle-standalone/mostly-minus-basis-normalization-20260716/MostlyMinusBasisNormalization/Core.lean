import Mathlib

/-!
# Exact normalization of a diagonal mostly-minus bilinear form

Focused Mathlib-only package for the final algebraic normalization step in the
marked-shell `1+3` proposal. If a real bilinear form has one basis whose Gram
matrix is `diag(timeNorm, -spaceNorm, -spaceNorm, -spaceNorm)` with both scales
strictly positive, then rescaling that basis gives the exact Minkowski matrix
`diag(1, -1, -1, -1)`.

This theorem does not construct the basis, prove that a causal selector finds
one, or establish any continuum or Lorentz-invariance claim.
-/

noncomputable section

namespace MostlyMinusBasisNormalization

variable {E : Type*} [AddCommGroup E] [Module Real E]

/-- The mostly-minus Minkowski matrix in the fixed `Fin 4` ordering. -/
def mostlyMinusEta : Matrix (Fin 4) (Fin 4) Real :=
  fun i j => if i = j then if i = 0 then 1 else -1 else 0

/-- A diagonal Gram matrix with one positive time scale and one common
positive magnitude for the three negative spatial entries. -/
def diagonalMostlyMinusGram
    (timeNorm spaceNorm : Real) : Matrix (Fin 4) (Fin 4) Real :=
  fun i j =>
    if i = j then if i = 0 then timeNorm else -spaceNorm else 0

/-- A bilinear form admits an exact mostly-minus normalized basis. -/
def HasMinkowskiNormalizedBasis
    (B : LinearMap.BilinForm Real E) : Prop :=
  exists b : Module.Basis (Fin 4) Real E,
    LinearMap.BilinForm.toMatrix b B = mostlyMinusEta

/-- Positive diagonal scales can be removed by reciprocal square-root basis
rescaling, producing the exact mostly-minus Minkowski matrix. -/
theorem hasMinkowskiNormalizedBasis_of_diagonalMostlyMinus
    (B : LinearMap.BilinForm Real E)
    (b : Module.Basis (Fin 4) Real E)
    (timeNorm spaceNorm : Real)
    (htime : 0 < timeNorm) (hspace : 0 < spaceNorm)
    (hgram : LinearMap.BilinForm.toMatrix b B =
      diagonalMostlyMinusGram timeNorm spaceNorm) :
    HasMinkowskiNormalizedBasis B := by
  sorry

end MostlyMinusBasisNormalization
