import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionStrongScaffold

/-!
# Aristotle target: quantitative three-term projection estimate

Preserve the exact constants and hypotheses. Use projection subtraction,
the landed `L2` contraction, pointwise three-term norm control, integrability,
and `norm_sub_rev`. This is an analytic inequality, not the final convergence
theorem.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionThreeTerm

open ChangingMomentumCellIsometry
open ChangingMomentumCellProjectionStrongScaffold

theorem projectAt_sq_error_le_of_approx (N : Nat)
    (f g : Momentum3 -> Complex)
    (hf : MemLp f 2 volume) (hg : MemLp g 2 volume) :
    ∫ x, ‖projectAt N f x - f x‖ ^ 2 <=
      6 * (∫ x, ‖f x - g x‖ ^ 2) +
        3 * (∫ x, ‖projectAt N g x - g x‖ ^ 2) := by
  sorry

end PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionThreeTerm
