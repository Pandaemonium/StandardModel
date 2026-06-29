import Mathlib

/-!
# C111 shell summability bridge

This standalone Aristotle target is the summability successor to C110b.

C110b proves a finite shell norm bound.  C111 asks for the standard Banach-space
upgrade: if the scalar envelope over shell lengths is summable, then the
Banach-valued shell kernel series is summable, with a total norm bound by the
scalar envelope sum.

This file does not claim gauge covariance, locality, a branch observable, or a
physical C1 release.
-/

namespace C111ShellSummability

open scoped BigOperators
open scoped ENNReal

variable {Path E : Type*} [NormedAddCommGroup E] [CompleteSpace E]

/-- The vector-valued contribution of one finite path shell. -/
def ShellKernel (s : Finset Path) (amplitude : Path -> E) : E :=
  s.sum amplitude

omit [CompleteSpace E] in
/--
Finite shell norm bound, repeated locally so this standalone file does not need
to import the C110b standalone package.

The proof is a `calc` chain: the triangle inequality bounds the norm of the sum
by the sum of norms, the termwise amplitude bound turns this into a constant sum,
`Finset.sum_const`/`nsmul_eq_mul` evaluate it as `(s.card) * ampBound`, and
`mul_le_mul_of_nonneg_right` replaces the cardinality by `pathCountBound`.
-/
theorem shell_kernel_norm_le_count_mul_amplitude
    (s : Finset Path) (amplitude : Path -> E)
    (pathCountBound ampBound : Real)
    (hAmpNonneg : 0 <= ampBound)
    (hCard : (s.card : Real) <= pathCountBound)
    (hAmplitudeBound : forall p, p ∈ s -> ‖amplitude p‖ <= ampBound) :
    ‖ShellKernel s amplitude‖ <= pathCountBound * ampBound := by
  -- Bound the sum of amplitude norms termwise by the constant `ampBound`.
  have hTermwise : (∑ p ∈ s, ‖amplitude p‖) ≤ ∑ _p ∈ s, ampBound :=
    Finset.sum_le_sum hAmplitudeBound
  -- The constant sum is exactly `(s.card) * ampBound`.
  have hConst : (∑ _p ∈ s, ampBound) = (s.card : Real) * ampBound := by
    rw [Finset.sum_const, nsmul_eq_mul]
  -- Replace the cardinality by its upper bound `pathCountBound`.
  have hCardMul : (s.card : Real) * ampBound ≤ pathCountBound * ampBound :=
    mul_le_mul_of_nonneg_right hCard hAmpNonneg
  calc
    ‖ShellKernel s amplitude‖ = ‖∑ p ∈ s, amplitude p‖ := rfl
    _ ≤ ∑ p ∈ s, ‖amplitude p‖ := norm_sum_le _ _
    _ ≤ ∑ _p ∈ s, ampBound := hTermwise
    _ = (s.card : Real) * ampBound := hConst
    _ ≤ pathCountBound * ampBound := hCardMul

/--
If the scalar envelope `pathCount n * ampBound n` is summable, and every finite
shell kernel is bounded by that envelope, then the series of shell kernels is
summable and the total kernel norm is bounded by the scalar envelope sum.
-/
theorem total_shell_kernel_summable
    (shell : Nat -> Finset Path) (amplitude : Path -> E)
    (pathCount ampBound : Nat -> Real)
    (hAmpNonneg : forall n, 0 <= ampBound n)
    (hCard : forall n, ((shell n).card : Real) <= pathCount n)
    (hAmpBound : forall n p, p ∈ shell n -> ‖amplitude p‖ <= ampBound n)
    (hSummable : Summable (fun n => pathCount n * ampBound n)) :
    Summable (fun n => ShellKernel (shell n) amplitude) ∧
    ‖∑' n, ShellKernel (shell n) amplitude‖ <=
      ∑' n, pathCount n * ampBound n := by
  -- Pointwise: each shell kernel norm is bounded by the scalar envelope term.
  have hNormBound :
      ∀ n, ‖ShellKernel (shell n) amplitude‖ ≤ pathCount n * ampBound n := by
    intro n
    exact shell_kernel_norm_le_count_mul_amplitude (shell n) amplitude
      (pathCount n) (ampBound n) (hAmpNonneg n) (hCard n) (hAmpBound n)
  -- Each shell kernel norm is nonnegative.
  have hNormNonneg : ∀ n, 0 ≤ ‖ShellKernel (shell n) amplitude‖ :=
    fun n => norm_nonneg _
  -- The series of shell kernel norms is summable, by comparison with the envelope.
  have hSummableNorm :
      Summable (fun n => ‖ShellKernel (shell n) amplitude‖) :=
    Summable.of_nonneg_of_le hNormNonneg hNormBound hSummable
  refine ⟨Summable.of_norm hSummableNorm, ?_⟩
  -- Triangle inequality for the infinite sum, then termwise comparison of sums.
  calc
    ‖∑' n, ShellKernel (shell n) amplitude‖
        ≤ ∑' n, ‖ShellKernel (shell n) amplitude‖ :=
          norm_tsum_le_tsum_norm hSummableNorm
    _ ≤ ∑' n, pathCount n * ampBound n :=
          Summable.tsum_le_tsum hNormBound hSummableNorm hSummable

end C111ShellSummability
