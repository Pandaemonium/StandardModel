import Mathlib

/-!
# Dirac two-sheet projector core

Standalone finite algebra for the branch structure forced by a Dirac square
root.  If an operator `D` satisfies `D^2 = m^2 I`, then the plus and minus
projectors `(1/2) * (I plus/minus m^{-1} D)` split the finite space into the two square-root
sheets.
-/

noncomputable section

namespace NullEdgeDiracTwoSheetCore

open Matrix Complex

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

def plusProjector (D : Matrix ι ι Complex) (m : Complex) :
    Matrix ι ι Complex :=
  ((2 : Complex)⁻¹) • ((1 : Matrix ι ι Complex) + m⁻¹ • D)

def minusProjector (D : Matrix ι ι Complex) (m : Complex) :
    Matrix ι ι Complex :=
  ((2 : Complex)⁻¹) • ((1 : Matrix ι ι Complex) - m⁻¹ • D)

theorem plusProjector_add_minusProjector
    (D : Matrix ι ι Complex) (m : Complex) :
    plusProjector D m + minusProjector D m =
      (1 : Matrix ι ι Complex) := by
  sorry

theorem plusProjector_sub_minusProjector
    (D : Matrix ι ι Complex) (m : Complex) :
    plusProjector D m - minusProjector D m = m⁻¹ • D := by
  sorry

theorem plusProjector_idempotent_of_sq
    (D : Matrix ι ι Complex) (m : Complex) (hm : m != 0)
    (hD : D * D = (m * m) • (1 : Matrix ι ι Complex)) :
    plusProjector D m * plusProjector D m = plusProjector D m := by
  sorry

theorem minusProjector_idempotent_of_sq
    (D : Matrix ι ι Complex) (m : Complex) (hm : m != 0)
    (hD : D * D = (m * m) • (1 : Matrix ι ι Complex)) :
    minusProjector D m * minusProjector D m = minusProjector D m := by
  sorry

theorem plus_minus_orthogonal_of_sq
    (D : Matrix ι ι Complex) (m : Complex) (hm : m != 0)
    (hD : D * D = (m * m) • (1 : Matrix ι ι Complex)) :
    plusProjector D m * minusProjector D m = 0 := by
  sorry

theorem dirac_acts_on_plusProjector
    (D : Matrix ι ι Complex) (m : Complex) (hm : m != 0)
    (hD : D * D = (m * m) • (1 : Matrix ι ι Complex)) :
    D * plusProjector D m = m • plusProjector D m := by
  sorry

theorem dirac_acts_on_minusProjector
    (D : Matrix ι ι Complex) (m : Complex) (hm : m != 0)
    (hD : D * D = (m * m) • (1 : Matrix ι ι Complex)) :
    D * minusProjector D m = (-m) • minusProjector D m := by
  sorry

end NullEdgeDiracTwoSheetCore

end
