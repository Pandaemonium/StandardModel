import Mathlib.Tactic
import Mathlib.Data.Matrix.Basic

/-!
# Fermionic oscillator: CAR algebra and number operator

The single-mode fermionic creation/annihilation operators satisfy the canonical
anticommutation relations: `a^2 = 0` (Pauli exclusion / nilpotency),
`{a, a-dagger} = 1`, and the number operator `N = a-dagger a` is a projector
(`N^2 = N`, occupation `0` or `1`). The kernel-checked anchor for the fermionic /
Grassmann sector of the program.

Standalone (Mathlib only).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeFermionOscillator

open Matrix

/-- Annihilation operator. -/
def a : Matrix (Fin 2) (Fin 2) Real := !![0, 1; 0, 0]

/-- Creation operator. -/
def adag : Matrix (Fin 2) (Fin 2) Real := !![0, 0; 1, 0]

/-- Nilpotency: Pauli exclusion. -/
theorem a_sq_zero : a * a = 0 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [a, mul_apply, Fin.sum_univ_two]

/-- Canonical anticommutation relation. -/
theorem car_anticomm : a * adag + adag * a = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [a, adag]

/-- Number operator. -/
def N : Matrix (Fin 2) (Fin 2) Real := adag * a

/-- The number operator is a projector (occupation 0 or 1). -/
theorem N_idempotent : N * N = N := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [N, a, adag, mul_apply, Fin.sum_univ_two]

end PhysicsSM.Draft.NullEdgeFermionOscillator
