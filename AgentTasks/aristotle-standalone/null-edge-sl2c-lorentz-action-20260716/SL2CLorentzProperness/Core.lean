import Mathlib

/-!
# Focused SL(2,C) Lorentz properness target

The matrix below is the standard mostly-minus Hermitian congruence action in
explicit real Pauli coordinates.  The target is the finite polynomial theorem
that its four-by-four real determinant is one whenever the two-by-two complex
spin matrix has determinant one.
-/

open Matrix Complex
open scoped MatrixGroups

noncomputable section

namespace SL2CLorentzProperness

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

/-- Real coordinates inverse to `pauliLift` on Hermitian matrices. -/
def hermitianCoords
    (X : Matrix (Fin 2) (Fin 2) Complex) : Minkowski4 :=
  ![(X 0 0).re / 2 + (X 1 1).re / 2,
    (X 0 1).re / 2 + (X 1 0).re / 2,
    (X 1 0).im / 2 - (X 0 1).im / 2,
    (X 0 0).re / 2 - (X 1 1).re / 2]

/-- Standard real coordinate vector. -/
def basisVector (j : Fin 4) : Minkowski4 :=
  Pi.single j 1

/-- Four-by-four real matrix induced by `X |-> A X A^dagger`. -/
def lorentzMatrix (A : SL2C) : Matrix (Fin 4) (Fin 4) Real :=
  fun i j => hermitianCoords
    ((A : Matrix (Fin 2) (Fin 2) Complex) * pauliLift (basisVector j) *
      Matrix.conjTranspose (A : Matrix (Fin 2) (Fin 2) Complex)) i

/-- Main target: the Hermitian `SL(2,C)` action is proper Lorentz. -/
theorem lorentzMatrix_det_one (A : SL2C) :
    (lorentzMatrix A).det = 1 := by
  sorry

end SL2CLorentzProperness
