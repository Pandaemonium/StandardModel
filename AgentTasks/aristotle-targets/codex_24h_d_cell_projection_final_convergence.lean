import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionGeometry
import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionThreeTerm

/-!
# Aristotle target: final strong convergence of changing cell projections

Prove both statements without weakening them. The first theorem must use the
explicit schedule and active-cell volume localization; the full scheduled box
has unbounded volume. The second theorem must use compact smooth Lipschitz
density and the exact three-term estimate with constants `6` and `3`.

This is a strong squared-`L2(R^3)` projection theorem. It does not yet identify
the cell-average coefficients with coefficients evolved by the live walk, nor
does it prove a position-space Dirac PDE limit.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionFinalConvergence

open ChangingMomentumCellIsometry
open ChangingMomentumCellSampling
open ChangingMomentumCellProjection
open ChangingMomentumCellProjectionStrongScaffold
open ChangingMomentumCellProjectionGeometry
open ChangingMomentumCellProjectionThreeTerm
open ScaledChangingMomentumWalk

/-- Compactly supported globally Lipschitz fields form a strong-convergence
core for the explicit scheduled cell-average projections. -/
theorem compact_lipschitz_projectAt_tendsto_sq_error_zero
    (g : Momentum3 -> Complex) (L : Real)
    (hgK : HasCompactSupport g) (hL : 0 <= L)
    (hLip : forall x y, ‖g x - g y‖ <= L * ‖x - y‖) :
    Tendsto
      (fun N => ∫ x, ‖projectAt N g x - g x‖ ^ 2)
      atTop (nhds 0) := by
  sorry

/-- **Gate D cell-projection strong convergence.** The normalized finite
cell-average projections on the explicit refining and exhausting Gate D
schedule converge strongly in squared `L2(R^3)` error to every complex `L2`
field. -/
theorem projectAt_tendsto_strong_L2
    (f : Momentum3 -> Complex) (hf : MemLp f 2 volume) :
    Tendsto
      (fun N => ∫ x, ‖projectAt N f x - f x‖ ^ 2)
      atTop (nhds 0) := by
  sorry

end PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionFinalConvergence
