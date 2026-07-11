import Mathlib

/-!
# Coordinate stabilizer of the upper `2 x 2` Hermitian block

Clean-room coordinate rung modeled on the first-factor calculation in
Baez--Schwahn, arXiv:2606.15235, Theorem 1. This target is deliberately only a
matrix theorem inside `SU(3)`; it does not claim the intrinsic `F4` theorem or
the identity-component glue.
-/

noncomputable section

namespace JCH2BlockStabilizer

open Matrix Complex

abbrev Mat3 := Matrix (Fin 3) (Fin 3) Complex

/-- Matrices supported in the upper-left `2 x 2` block. -/
def SupportedUpperBlock (X : Mat3) : Prop :=
  forall i j, (i = 2 ∨ j = 2) -> X i j = 0

/-- Conjugation by `U` preserves the upper-left block. -/
def StabilizesUpperBlock (U : Mat3) : Prop :=
  forall X : Mat3, SupportedUpperBlock X ->
    SupportedUpperBlock (U * X * Uᴴ)

/-- The coordinate block-diagonal condition for a `2 + 1` split. -/
def IsBlockDiagonal21 (U : Mat3) : Prop :=
  (forall i : Fin 3, i ≠ 2 -> U i 2 = 0) ∧
    (forall j : Fin 3, j ≠ 2 -> U 2 j = 0)

/-- Exact unitarity, stated on both sides to keep the coordinate proof direct. -/
def IsUnitary3 (U : Mat3) : Prop := Uᴴ * U = 1 ∧ U * Uᴴ = 1

/-- Coordinate stabilizer theorem: a unitary `3 x 3` matrix preserves the
upper `2 x 2` matrix block under conjugation iff it is block diagonal for the
`2 + 1` split. -/
theorem stabilizesUpperBlock_iff_blockDiagonal
    (U : Mat3) (hU : IsUnitary3 U) :
    StabilizesUpperBlock U <-> IsBlockDiagonal21 U := by
  sorry

/-- Determinant factorization for the resulting `2 + 1` block. This is the
coordinate `S(U(2) x U(1))` determinant relation. -/
theorem det_eq_upperBlock_det_mul_corner
    (U : Mat3) (hBlock : IsBlockDiagonal21 U) :
    U.det =
      (U.submatrix (Fin.castLE (by omega : 2 ≤ 3))
        (Fin.castLE (by omega : 2 ≤ 3))).det * U 2 2 := by
  sorry

/-- A nonidentity block-diagonal special-unitary witness. -/
def phaseWitness : Mat3 :=
  !![Complex.I, 0, 0; 0, -Complex.I, 0; 0, 0, 1]

theorem phaseWitness_unitary : IsUnitary3 phaseWitness := by
  sorry

theorem phaseWitness_det : phaseWitness.det = 1 := by
  sorry

theorem phaseWitness_stabilizes : StabilizesUpperBlock phaseWitness := by
  sorry

/-- A unitary control that swaps one upper-block axis with the complement. -/
def mixingControl : Mat3 :=
  !![1, 0, 0; 0, 0, 1; 0, 1, 0]

theorem mixingControl_unitary : IsUnitary3 mixingControl := by
  sorry

theorem mixingControl_not_stabilizes :
    Not (StabilizesUpperBlock mixingControl) := by
  sorry

end JCH2BlockStabilizer
