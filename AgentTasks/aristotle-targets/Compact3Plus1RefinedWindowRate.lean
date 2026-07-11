import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate

/-!
# Small-step-sensitive 3+1 continuum rate

Handoff target for Paper D.  The existing compact-box constant contains
`exp(B4)`, which is unsuitable when the momentum cutoff grows with lattice
refinement.  The underlying proof first obtains `exp(|eps| * B4)`.  Preserve
that dependence through the one-step and telescoping estimates.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.Compact3Plus1RefinedWindowRate

open scoped Matrix.Norms.L2Operator
open PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate

/-- Refined split-product remainder retaining the small-step exponent. -/
theorem splitStep_sub_lin_bound_refined (kx ky kz m eps : Real) :
    ‖splitStep kx ky kz m eps -
        (1 + ((-(eps : Complex)) •
          ((Complex.I : Complex) • H kx ky kz m)))‖ <=
      eps ^ 2 * B4 kx ky kz m ^ 2 *
        Real.exp (|eps| * B4 kx ky kz m) := by
  sorry

/-- Refined exact-flow remainder with the same small-step exponent. -/
theorem exactFlow_sub_lin_bound_refined (kx ky kz m eps : Real) :
    ‖exactFlow kx ky kz m eps -
        (1 + ((-(eps : Complex)) •
          ((Complex.I : Complex) • H kx ky kz m)))‖ <=
      eps ^ 2 * B4 kx ky kz m ^ 2 *
        Real.exp (|eps| * B4 kx ky kz m) := by
  sorry

/-- Refined local Trotter estimate. -/
theorem one_step_to_exact_flow_bound_refined (kx ky kz m eps : Real) :
    ‖splitStep kx ky kz m eps - exactFlow kx ky kz m eps‖ <=
      2 * eps ^ 2 * B4 kx ky kz m ^ 2 *
        Real.exp (|eps| * B4 kx ky kz m) := by
  sorry

/-- Refined many-step estimate suitable for a momentum window growing slower
than the step count. -/
theorem fixed_time_many_step_bound_refined
    (kx ky kz m t : Real) (n : Nat) (hn : 0 < n) :
    ‖(splitStep kx ky kz m (t / (n : Real))) ^ n -
        exactFlow kx ky kz m t‖ <=
      2 * B4 kx ky kz m ^ 2 * t ^ 2 / n *
        Real.exp (|t| * B4 kx ky kz m / n) := by
  sorry

end PhysicsSM.Draft.NullEdge.Compact3Plus1RefinedWindowRate
