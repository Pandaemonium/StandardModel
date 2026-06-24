import Mathlib.Tactic
import Mathlib.Data.Matrix.Basic

/-!
# su(2) Lie algebra from the Pauli matrices

The Pauli matrices satisfy the su(2) commutation relations
`[sigma_i, sigma_j] = 2 i epsilon_{ijk} sigma_k`, the Lie algebra of weak isospin.
Together with the Clifford anticommutator (see `NullEdgePauliSlash`) this fixes the
2x2 gauge structure on the Standard-Model side of the program.

Standalone (Mathlib only).
-/

noncomputable section

namespace NullEdgeSU2Algebra

open Matrix Complex

/-- The three Pauli matrices. -/
def sigma : Fin 3 -> Matrix (Fin 2) (Fin 2) Complex
  | 0 => !![0, 1; 1, 0]
  | 1 => !![0, -I; I, 0]
  | 2 => !![1, 0; 0, -1]

/-- `[sigma_0, sigma_1] = 2 i sigma_2`. -/
theorem comm_01 : sigma 0 * sigma 1 - sigma 1 * sigma 0 = (2 * I) • sigma 2 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [sigma] <;> ring

/-- `[sigma_1, sigma_2] = 2 i sigma_0`. -/
theorem comm_12 : sigma 1 * sigma 2 - sigma 2 * sigma 1 = (2 * I) • sigma 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [sigma] <;> ring

/-- `[sigma_2, sigma_0] = 2 i sigma_1`. -/
theorem comm_20 : sigma 2 * sigma 0 - sigma 0 * sigma 2 = (2 * I) • sigma 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [sigma, mul_assoc, Complex.I_mul_I] <;> ring


end NullEdgeSU2Algebra
