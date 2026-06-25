import Mathlib

/-!
# NullStrand.Synchronization.DiamondDefect

Finite algebraic interface for the synchronization diamond defect.

This module records the order-dependence defect for two transition kernels as a
single kernel-valued expression and proves the basic characterization
`defect = 0 ↔ order independence`.

Conservativity note:
The current definition is intentionally generic and finite-dimensional; it is
meant as a stable algebraic layer for later, physically constrained
hidden-kernel formulations.
-/

noncomputable section

namespace PhysicsSM.NullStrand.Synchronization

open scoped BigOperators

/-- A synchronization update kernel, represented by a square matrix. -/
abbrev SyncKernel (α : Type*) [Fintype α] := Matrix α α ℝ

/-- Composition of finite update kernels. -/
def composeKernel {α : Type*} [Fintype α] (K₁ K₂ : SyncKernel α) : SyncKernel α :=
  K₂ * K₁

/-- Diamond defect between two ordered updates: `A ∘ B - B ∘ A`. -/
def synchronizationDiamondDefect {α : Type*} [Fintype α]
    (K_A K_B : SyncKernel α) : SyncKernel α :=
  K_B * K_A - K_A * K_B

/-- Kernel order commutator vanishing is exactly vanishing defect. -/
theorem synchronizationDiamondDefect_eq_zero_iff_orderIndependent
    {α : Type*} [Fintype α] (K_A K_B : SyncKernel α) :
    synchronizationDiamondDefect K_A K_B = 0 ↔ K_B * K_A = K_A * K_B := by
  simpa [synchronizationDiamondDefect] using
    (sub_eq_zero : K_B * K_A - K_A * K_B = 0 ↔ K_B * K_A = K_A * K_B)

/-- Defect is alternating in its inputs by construction. -/
theorem synchronizationDiamondDefect_swap {I : Type*} [Fintype I] (K_A K_B : SyncKernel I) :
    synchronizationDiamondDefect K_A K_B = - synchronizationDiamondDefect K_B K_A := by
  ext i j
  simp [synchronizationDiamondDefect, sub_eq_add_neg]

end PhysicsSM.NullStrand.Synchronization
