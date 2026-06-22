import Mathlib

/-!
# Finite super-Dirac block-square core

Standalone block-matrix algebra for the null-edge program.

This file isolates the first-order operator pattern needed for the causal
super-Dirac proposal:

* an odd off-diagonal operator on `L ⊕ R`;
* its square has diagonal mass/Laplacian blocks;
* the grading anticommutes with the odd operator;
* the `d + delta` and Higgs/Yukawa flip cases are both instances.
-/

noncomputable section

namespace NullEdgeSuperDiracCore

open Matrix Complex

variable {L R : Type*} [Fintype L] [Fintype R] [DecidableEq L] [DecidableEq R]

/-- Off-diagonal operator on a finite `L ⊕ R` space. -/
def offDiagonal
    (phi : Matrix R L Complex) (psi : Matrix L R Complex) :
    Matrix (Sum L R) (Sum L R) Complex :=
  fun a b =>
    match a, b with
    | Sum.inl _, Sum.inl _ => 0
    | Sum.inl l, Sum.inr r => psi l r
    | Sum.inr r, Sum.inl l => phi r l
    | Sum.inr _, Sum.inr _ => 0

/-- Chirality grading: `+1` on `L`, `-1` on `R`. -/
def chirality :
    Matrix (Sum L R) (Sum L R) Complex :=
  fun a b =>
    match a, b with
    | Sum.inl l, Sum.inl l' => if l = l' then 1 else 0
    | Sum.inr r, Sum.inr r' => if r = r' then -1 else 0
    | _, _ => 0

/-- The left block of an off-diagonal square is `psi * phi`. -/
theorem offDiagonal_sq_leftBlock
    (phi : Matrix R L Complex) (psi : Matrix L R Complex) (l l' : L) :
    (offDiagonal phi psi * offDiagonal phi psi) (Sum.inl l) (Sum.inl l') =
      (psi * phi) l l' := by
  sorry

/-- The right block of an off-diagonal square is `phi * psi`. -/
theorem offDiagonal_sq_rightBlock
    (phi : Matrix R L Complex) (psi : Matrix L R Complex) (r r' : R) :
    (offDiagonal phi psi * offDiagonal phi psi) (Sum.inr r) (Sum.inr r') =
      (phi * psi) r r' := by
  sorry

/-- The off-diagonal blocks of the square vanish. -/
theorem offDiagonal_sq_offBlock_zero_left
    (phi : Matrix R L Complex) (psi : Matrix L R Complex) (l : L) (r : R) :
    (offDiagonal phi psi * offDiagonal phi psi) (Sum.inl l) (Sum.inr r) = 0 := by
  sorry

/-- The other off-diagonal block of the square vanishes. -/
theorem offDiagonal_sq_offBlock_zero_right
    (phi : Matrix R L Complex) (psi : Matrix L R Complex) (r : R) (l : L) :
    (offDiagonal phi psi * offDiagonal phi psi) (Sum.inr r) (Sum.inl l) = 0 := by
  sorry

/-- The chirality grading anticommutes with any off-diagonal operator. -/
theorem chirality_anticommutes_offDiagonal
    (phi : Matrix R L Complex) (psi : Matrix L R Complex) :
    chirality * offDiagonal phi psi + offDiagonal phi psi * chirality = 0 := by
  sorry

/-- The canonical self-adjoint odd operator attached to a rectangular map. -/
def hodgeDirac (d : Matrix R L Complex) :
    Matrix (Sum L R) (Sum L R) Complex :=
  offDiagonal d d.conjTranspose

/-- The left Hodge-Laplacian block of `(d + delta)^2`. -/
theorem hodgeDirac_sq_leftBlock
    (d : Matrix R L Complex) (l l' : L) :
    (hodgeDirac d * hodgeDirac d) (Sum.inl l) (Sum.inl l') =
      (d.conjTranspose * d) l l' := by
  sorry

/-- The right Hodge-Laplacian block of `(d + delta)^2`. -/
theorem hodgeDirac_sq_rightBlock
    (d : Matrix R L Complex) (r r' : R) :
    (hodgeDirac d * hodgeDirac d) (Sum.inr r) (Sum.inr r') =
      (d * d.conjTranspose) r r' := by
  sorry

/-- Scalar Higgs/Yukawa flip block squares to `m^2` on both chiralities. -/
theorem scalarFlip_sq_eq_massSq
    {X : Type*} [Fintype X] [DecidableEq X] (m : Complex) :
    offDiagonal (L := X) (R := X)
        (m • (1 : Matrix X X Complex))
        (m • (1 : Matrix X X Complex)) *
      offDiagonal (L := X) (R := X)
        (m • (1 : Matrix X X Complex))
        (m • (1 : Matrix X X Complex)) =
      (m * m) •
        (1 : Matrix (Sum X X) (Sum X X) Complex) := by
  sorry

end NullEdgeSuperDiracCore

end
