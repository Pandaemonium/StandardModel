import Mathlib.Tactic

/-!
# P1 positivity of observer-axis two-null energies

After the observer-axis two-null split, this target records the elementary
positivity guardrail: the two null components have nonnegative energies when
the corresponding `E + s` and `E - s` factors are nonnegative.
-/

namespace NullEdgeP1TwoNullEnergyPositive

noncomputable section

structure Vec2 where
  t : Real
  x : Real

def kPlus (E s : Real) : Vec2 :=
  { t := (E + s) / 2, x := (E + s) / 2 }

def kMinus (E s : Real) : Vec2 :=
  { t := (E - s) / 2, x := -((E - s) / 2) }

theorem kPlus_energy_nonneg_of_sum_nonneg
    (E s : Real) (h : 0 <= E + s) :
    0 <= (kPlus E s).t := by
  sorry

theorem kMinus_energy_nonneg_of_diff_nonneg
    (E s : Real) (h : 0 <= E - s) :
    0 <= (kMinus E s).t := by
  sorry

theorem split_energies_nonneg
    (E s : Real) (hplus : 0 <= E + s) (hminus : 0 <= E - s) :
    And (0 <= (kPlus E s).t) (0 <= (kMinus E s).t) := by
  sorry

end

end NullEdgeP1TwoNullEnergyPositive
