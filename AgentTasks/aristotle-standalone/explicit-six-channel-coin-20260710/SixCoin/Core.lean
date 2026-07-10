import Mathlib

open Matrix Complex

namespace SixCoin

abbrev Direction := Fin 6
abbrev Coin := Matrix Direction Direction ℂ

/-- Three identical normalized checkerboard blocks, one for each spatial axis.
Each block mixes the two opposite directions on that axis. -/
noncomputable def axisBlockCoin : Coin :=
  fun finish start =>
    if finish.val / 2 = start.val / 2 then
      if finish.val % 2 = start.val % 2 then ((3 / 5 : ℝ) : ℂ)
      else I * ((4 / 5 : ℝ) : ℂ)
    else 0

def IsUnitary (U : Coin) : Prop :=
  U.conjTranspose * U = 1 ∧ U * U.conjTranspose = 1

theorem axis_block_coin_unitary : IsUnitary axisBlockCoin := by
  sorry

/-- The coin is nontrivial, mixes the x-plus/x-minus pair, and has no
cross-axis leakage in the displayed ordering. -/
theorem axis_block_coin_controls :
    axisBlockCoin ≠ 1 ∧
      axisBlockCoin (0 : Direction) (1 : Direction) = I * (4 / 5 : ℝ) ∧
      axisBlockCoin (0 : Direction) (2 : Direction) = 0 := by
  sorry

end SixCoin
