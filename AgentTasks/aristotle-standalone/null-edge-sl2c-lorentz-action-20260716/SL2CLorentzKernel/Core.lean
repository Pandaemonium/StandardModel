import Mathlib

/-!
# Focused SL(2,C) Lorentz exact-kernel target

The Pauli/Hermitian congruence action of a determinant-one two-by-two complex
matrix is assumed to fix every real Minkowski four-vector.  The target is the
finite algebraic statement that the matrix is `+I` or `-I`.
-/

open Matrix Complex
open scoped MatrixGroups

noncomputable section

namespace SL2CLorentzKernel

/-- Mathlib's determinant-one two-by-two complex matrix group. -/
abbrev SL2C := SL(2, Complex)

/-- Real Minkowski four-vectors. -/
abbrev Minkowski4 := Fin 4 -> Real

/-- Mostly-minus Pauli/Hermitian lift. -/
def pauliLift (p : Minkowski4) : Matrix (Fin 2) (Fin 2) Complex :=
  !![((p 0 + p 3 : Real) : Complex),
      (p 1 : Complex) - Complex.I * (p 2 : Complex);
     (p 1 : Complex) + Complex.I * (p 2 : Complex),
      ((p 0 - p 3 : Real) : Complex)]

/-- Hermitian congruence by one spin matrix. -/
def hermitianCongruence
    (A : SL2C) (X : Matrix (Fin 2) (Fin 2) Complex) :
    Matrix (Fin 2) (Fin 2) Complex :=
  (A : Matrix (Fin 2) (Fin 2) Complex) * X *
    Matrix.conjTranspose (A : Matrix (Fin 2) (Fin 2) Complex)

/-- Main target: the Hermitian Lorentz action has exactly the central kernel. -/
theorem hermitianCongruence_kernel (A : SL2C)
    (hfix : forall p : Minkowski4,
      hermitianCongruence A (pauliLift p) = pauliLift p) :
    Or (A = 1) (A = -(1 : SL2C)) := by
  sorry

end SL2CLorentzKernel
