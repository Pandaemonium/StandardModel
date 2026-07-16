import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionCompactCore
import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionThreeTerm

/-!
# Strong L2 convergence for changing momentum-cell projections

This module closes the final representative-safe projection rung of the Gate D
changing-cell continuum program. It composes:

- compact smooth globally Lipschitz density in complex `L2(R^3)`;
- the active-cell compact-core convergence theorem;
- the exact quantitative `6 + 3` projection-error estimate.

The result is strong convergence of the concrete refining and exhausting
cell-average projections. It does not identify their coefficients with the
live walk's evolved coefficients, apply inverse Fourier transport, or prove a
position-space Dirac PDE limit.

Provenance: exact target first submitted to Aristotle project
`b7405f03-7bf4-47c2-9b3a-71ce9040df3f`. After the project remained stalled on
both final statements, Codex factored and kernel-checked the compact core and
this density transfer during the AFPL continuum lane on July 12, 2026. The
statement and constants were not weakened.
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

/-- **Gate D cell-projection strong convergence.** The normalized finite
cell-average projections on the explicit refining and exhausting Gate D
schedule converge strongly in squared `L2(R^3)` error to every complex `L2`
field. -/
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

/-! ## Build-enforced assumption pin -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionStrongL2.projectAt_tendsto_strong_L2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projectAt_tendsto_strong_L2

end PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionStrongL2
