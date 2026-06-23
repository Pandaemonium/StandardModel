import Mathlib.Tactic

/-!
# P1 positivity of observer-axis two-null energies

After the observer-axis two-null split, the two null components have
nonnegative energies when the corresponding `E + s` and `E - s` factors are
nonnegative. This is a positivity guardrail for the frame-conditioned split.
-/

namespace PhysicsSM.Draft.NullEdgeP1TwoNullEnergyPositive

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
  simp only [kPlus]
  linarith

theorem kMinus_energy_nonneg_of_diff_nonneg
    (E s : Real) (h : 0 <= E - s) :
    0 <= (kMinus E s).t := by
  simp only [kMinus]
  linarith

theorem split_energies_nonneg
    (E s : Real) (hplus : 0 <= E + s) (hminus : 0 <= E - s) :
    And (0 <= (kPlus E s).t) (0 <= (kMinus E s).t) := by
  exact And.intro
    (kPlus_energy_nonneg_of_sum_nonneg E s hplus)
    (kMinus_energy_nonneg_of_diff_nonneg E s hminus)

end

end PhysicsSM.Draft.NullEdgeP1TwoNullEnergyPositive
