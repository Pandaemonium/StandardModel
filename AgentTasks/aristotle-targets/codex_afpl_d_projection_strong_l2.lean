import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionCompactCore
import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionThreeTerm

/-!
# AFPL Gate D arbitrary-L2 density transfer

This isolated target composes the kernel-checked compact-Lipschitz projection
limit with the landed compact smooth density theorem and exact `6 + 3`
three-term estimate. It proves strong squared-`L2(R^3)` convergence for the
explicit cell-average projections, without asserting a live-walk or PDE limit.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionStrongL2

open ChangingMomentumCellIsometry
open ChangingMomentumCellProjectionStrongScaffold
open ChangingMomentumCellProjectionThreeTerm
open ChangingMomentumCellProjectionCompactCore
open ScaledChangingMomentumWalk

/-- The explicit refining and exhausting finite cell-average projections
converge strongly in squared `L2(R^3)` error to every complex `L2` field. -/
theorem projectAt_tendsto_strong_L2
    (f : Momentum3 -> Complex) (hf : MemLp f 2 volume) :
    Tendsto
      (fun N => ∫ x, ‖projectAt N f x - f x‖ ^ 2)
      atTop (nhds 0) := by
  rw [Metric.tendsto_atTop]
  intro ε hε
  obtain ⟨g, L, hgK, hgC, hL, hLip, hg, happrox⟩ :=
    memLp_exists_compact_smooth_lipschitz_sq_approx hf
      (show 0 < ε / 12 by positivity)
  have hgT :=
    compact_lipschitz_projectAt_tendsto_sq_error_zero g L hgK hL hLip
  rw [Metric.tendsto_atTop] at hgT
  obtain ⟨N, hN⟩ := hgT (ε / 12) (by positivity)
  refine ⟨N, ?_⟩
  intro n hn
  have hgerr_nonneg :
      0 <= ∫ x, ‖projectAt n g x - g x‖ ^ 2 :=
    MeasureTheory.integral_nonneg fun x => sq_nonneg _
  have hgerr : ∫ x, ‖projectAt n g x - g x‖ ^ 2 < ε / 12 := by
    have := hN n hn
    rw [Real.dist_eq, sub_zero, abs_of_nonneg hgerr_nonneg] at this
    exact this
  have hbound := projectAt_sq_error_le_of_approx n f g hf hg
  have herr_nonneg :
      0 <= ∫ x, ‖projectAt n f x - f x‖ ^ 2 :=
    MeasureTheory.integral_nonneg fun x => sq_nonneg _
  rw [Real.dist_eq, sub_zero, abs_of_nonneg herr_nonneg]
  linarith

end PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionStrongL2
