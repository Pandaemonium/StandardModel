import Mathlib

/-!
# C110b normed path-shell kernel bridge

This standalone Aristotle target is the normed successor to C110a.

C110a only bounded a scalar shell contribution. For kernel control we need the
standard finite norm estimate: the norm of a finite sum is bounded by the sum of
the per-path norm bounds, which is then bounded by path-count times amplitude.

This file does not claim locality, gauge covariance, a branch observable, or a
physical C1 release.
-/

namespace C110bPathShellKernel

open scoped BigOperators

variable {Path E : Type*} [SeminormedAddCommGroup E]

/-- The vector-valued contribution of one finite path shell. -/
def ShellKernel (s : Finset Path) (amplitude : Path -> E) : E :=
  s.sum amplitude

/--
If every path amplitude in a finite shell has norm at most `ampBound`, and the
number of paths in the shell is at most `pathCountBound`, then the norm of the
shell's total amplitude is at most `pathCountBound * ampBound`.
-/
theorem shell_kernel_norm_le_count_mul_amplitude
    (s : Finset Path) (amplitude : Path -> E)
    (pathCountBound ampBound : Real)
    (hAmpNonneg : 0 <= ampBound)
    (hCard : (s.card : Real) <= pathCountBound)
    (hAmplitudeBound : forall p, p ∈ s -> ‖amplitude p‖ <= ampBound) :
    ‖ShellKernel s amplitude‖ <= pathCountBound * ampBound := by
  exact le_trans ( norm_sum_le _ _ ) ( le_trans ( Finset.sum_le_sum hAmplitudeBound ) ( by simp +decide [ mul_comm, ← @Nat.cast_smul_eq_nsmul ℝ ] ; nlinarith ) )

/--
Length-indexed form of `shell_kernel_norm_le_count_mul_amplitude`, using an
explicit shell family `shell n`.
-/
theorem shell_kernel_norm_le_length_envelope
    (shell : Nat -> Finset Path) (amplitude : Path -> E)
    (pathCount ampBound : Nat -> Real) (n : Nat)
    (hAmpNonneg : 0 <= ampBound n)
    (hCard : ((shell n).card : Real) <= pathCount n)
    (hAmplitudeBound :
      forall p, p ∈ shell n -> ‖amplitude p‖ <= ampBound n) :
    ‖ShellKernel (shell n) amplitude‖ <= pathCount n * ampBound n := by
  exact shell_kernel_norm_le_count_mul_amplitude (shell n) amplitude
    (pathCount n) (ampBound n) hAmpNonneg hCard hAmplitudeBound

end C110bPathShellKernel
