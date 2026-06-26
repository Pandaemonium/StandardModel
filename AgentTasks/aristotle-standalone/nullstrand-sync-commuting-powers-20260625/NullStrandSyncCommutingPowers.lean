import Mathlib

/-!
# NullStrand synchronization commuting-powers target

Finite algebraic path-independence core: if two synchronization kernels commute,
then repeated alternating updates split into separate powers.
-/

noncomputable section

namespace NullStrandSyncCommutingPowers

/-- A synchronization update kernel, represented by a square matrix. -/
abbrev SyncKernel (Alpha : Type*) [Fintype Alpha] := Matrix Alpha Alpha Real

/-- Commuting two-step updates split into powers. -/
theorem commuting_two_step_pow {Alpha : Type*} [Fintype Alpha]
    [DecidableEq Alpha]
    (A B : SyncKernel Alpha) (hcomm : A * B = B * A) (n : Nat) :
    (A * B) ^ n = A ^ n * B ^ n := by
  exact (Commute.mul_pow hcomm n)

/-- The same power identity in the opposite order. -/
theorem commuting_two_step_pow_swap {Alpha : Type*} [Fintype Alpha]
    [DecidableEq Alpha]
    (A B : SyncKernel Alpha) (hcomm : A * B = B * A) (n : Nat) :
    (B * A) ^ n = A ^ n * B ^ n := by
  have hC : Commute A B := hcomm
  rw [Commute.mul_pow hcomm.symm n]
  exact (hC.pow_pow n n).symm

end NullStrandSyncCommutingPowers
