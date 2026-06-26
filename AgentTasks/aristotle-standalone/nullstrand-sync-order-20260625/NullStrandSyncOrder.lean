import Mathlib

/-!
# NullStrand synchronization order-independence target

Finite matrix-kernel formulation for SYNC-001/SYNC-002.
-/

noncomputable section

namespace NullStrandSyncOrder

open scoped BigOperators
open Matrix

/-- A finite synchronization kernel. -/
abbrev SyncKernel (I : Type*) [Fintype I] := Matrix I I Real

/-- Apply a row-law to a kernel. -/
def applyKernel {I : Type*} [Fintype I] (p : I -> Real) (K : SyncKernel I) : I -> Real :=
  fun j => ∑ i, p i * K i j

/-- Ordered-update defect. -/
def synchronizationDiamondDefect {I : Type*} [Fintype I]
    (K_A K_B : SyncKernel I) : SyncKernel I :=
  K_A * K_B - K_B * K_A

/-- Applying two kernels is the same as applying their matrix product. -/
theorem applyKernel_applyKernel {I : Type*} [Fintype I]
    (p : I -> Real) (K_A K_B : SyncKernel I) :
    applyKernel (applyKernel p K_A) K_B = applyKernel p (K_A * K_B) := by
  funext j
  simp +decide [applyKernel, Matrix.mul_apply, Finset.sum_mul, mul_assoc, Finset.mul_sum]
  rw [Finset.sum_comm]

/-- SYNC core. Vanishing defect is equivalent to order-independent action on every finite law. -/
theorem defect_zero_iff_all_initial_laws {I : Type*} [Fintype I] [DecidableEq I] [Nonempty I]
    (K_A K_B : SyncKernel I) :
    synchronizationDiamondDefect K_A K_B = 0 ↔
      ∀ p : I -> Real,
        applyKernel (applyKernel p K_A) K_B =
          applyKernel (applyKernel p K_B) K_A := by
  simp +decide only [synchronizationDiamondDefect, sub_eq_zero]
  constructor <;> intro h <;> simp_all +decide [funext_iff, applyKernel_applyKernel]
  ext i j
  specialize h (fun k => if k = i then 1 else 0) j
  simp_all +decide [applyKernel]

end NullStrandSyncOrder
