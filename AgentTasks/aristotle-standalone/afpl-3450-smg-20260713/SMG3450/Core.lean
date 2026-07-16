import Mathlib

/-!
# Finite 3-4-5-0 symmetric-mass-generation laboratory

This standalone file is intentionally only a seed.  The Aristotle task note
asks for a faithful finite fermionic Fock model, an explicit gauge-invariant
many-body interaction, and a nonvacuous spectral-gap theorem.
-/

namespace SMG3450

/-- The anomaly-free integer charge tuple used by the finite laboratory. -/
def charge : Fin 4 -> Int
  | 0 => 3
  | 1 => 4
  | 2 => 5
  | 3 => 0

theorem quadratic_charge_balance :
    charge 0 ^ 2 + charge 1 ^ 2 - charge 2 ^ 2 - charge 3 ^ 2 = 0 := by
  norm_num [charge]

end SMG3450
