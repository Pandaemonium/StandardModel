import Mathlib

/-!
# C110a path-shell kernel bridge

This standalone Aristotle target is a finite Mathlib-only bridge for the
non-ultralocal Gate C1 path-sum program.

It does not claim locality, gauge covariance, a branch observable, or a physical
release. It only isolates the finite shell estimate needed before a path-count
envelope can be used as an operator-kernel contribution bound.
-/

namespace C110aPathShellKernel

open scoped BigOperators

variable {Path : Type*}

/-- The total contribution of one finite path shell. -/
def ShellContribution (s : Finset Path) (weight : Path -> Real) : Real :=
  s.sum weight

/--
If every path in a finite shell has contribution at most `ampBound`, and the
number of paths in the shell is at most `pathCountBound`, then the shell's total
contribution is at most `pathCountBound * ampBound`.

This is a scalar finite bridge from a path-count/per-path envelope to an actual
shell contribution. Later C110/C111 work must add normed kernel estimates,
gauge transport, matrix norms, and regulator limits.
-/
theorem shell_contribution_le_count_mul_amplitude
    (s : Finset Path) (weight : Path -> Real)
    (pathCountBound ampBound : Real)
    (hAmpNonneg : 0 <= ampBound)
    (hCard : (s.card : Real) <= pathCountBound)
    (hWeightBound : forall p, p ∈ s -> weight p <= ampBound) :
    ShellContribution s weight <= pathCountBound * ampBound := by
  have h1 : ShellContribution s weight <= (s.card : Real) * ampBound := by
    unfold ShellContribution
    calc
      s.sum weight <= s.sum (fun _p => ampBound) := by
        exact Finset.sum_le_sum hWeightBound
      _ = (s.card : Real) * ampBound := by
        rw [Finset.sum_const, nsmul_eq_mul]
  exact h1.trans (mul_le_mul_of_nonneg_right hCard hAmpNonneg)

/--
Length-indexed form of `shell_contribution_le_count_mul_amplitude`.

This is the shape expected in the null-edge path-sum application: a shell at
length `n`, a combinatorial path-count envelope, and a per-path amplitude
envelope.
-/
theorem shell_contribution_le_length_envelope
    (s : Finset Path) (weight : Path -> Real)
    (pathCount ampBound : Nat -> Real) (n : Nat)
    (hAmpNonneg : 0 <= ampBound n)
    (hCard : (s.card : Real) <= pathCount n)
    (hWeightBound : forall p, p ∈ s -> weight p <= ampBound n) :
    ShellContribution s weight <= pathCount n * ampBound n :=
  shell_contribution_le_count_mul_amplitude s weight (pathCount n) (ampBound n)
    hAmpNonneg hCard hWeightBound

end C110aPathShellKernel
