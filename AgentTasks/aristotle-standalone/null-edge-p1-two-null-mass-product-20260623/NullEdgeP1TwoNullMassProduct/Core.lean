import Mathlib.Tactic

/-!
# P1 two-null mass product

In the observer-axis `1+1` split, the product of the right/left null energies
recovers the timelike mass square.
-/

namespace NullEdgeP1TwoNullMassProduct

noncomputable section

structure Vec2 where
  t : Real
  x : Real

def momentum (E s : Real) : Vec2 :=
  { t := E, x := s }

def minkowskiSq (v : Vec2) : Real :=
  v.t ^ 2 - v.x ^ 2

def kPlusEnergy (E s : Real) : Real :=
  (E + s) / 2

def kMinusEnergy (E s : Real) : Real :=
  (E - s) / 2

theorem split_energy_product_eq_massSq_div_four (E s : Real) :
    kPlusEnergy E s * kMinusEnergy E s =
      minkowskiSq (momentum E s) / 4 := by
  sorry

theorem four_mul_split_energy_product_eq_massSq (E s : Real) :
    4 * kPlusEnergy E s * kMinusEnergy E s =
      minkowskiSq (momentum E s) := by
  sorry

theorem split_energy_product_nonneg_of_timelike
    (E s : Real) (h : 0 <= minkowskiSq (momentum E s)) :
    0 <= kPlusEnergy E s * kMinusEnergy E s := by
  sorry

end

end NullEdgeP1TwoNullMassProduct
