import PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionStrongScaffold

/-!
# Aristotle target: compact-support geometry for Gate D cell projections

Preserve both statements and the explicit schedule. The full scheduled box has
growing volume, so the second theorem must localize to `activeModes`; do not
replace it by a false uniform bound on all `scheduledModes`.
-/

noncomputable section

open scoped BigOperators ENNReal
open MeasureTheory Set Filter Topology

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionGeometry

open ChangingMomentumCellIsometry
open ChangingMomentumCellSampling
open ChangingMomentumCellProjection
open ChangingMomentumCellProjectionStrongScaffold
open ScaledChangingMomentumWalk

theorem compactSupport_eventually_covered {g : Momentum3 -> Complex}
    (hgK : HasCompactSupport g) :
    ∀ᶠ N in atTop,
      Function.support g ⊆
        cellUnion (physicalSpacing N) (scheduledModes N) := by
  sorry

theorem active_cellUnion_volume_eventually_bounded
    {g : Momentum3 -> Complex} (hgK : HasCompactSupport g) :
    ∃ V : Real, 0 <= V ∧
      ∀ᶠ N in atTop,
        (volume
          (cellUnion (physicalSpacing N) (activeModes N g))).toReal <= V := by
  sorry

end PhysicsSM.Draft.NullEdge.ChangingMomentumCellProjectionGeometry
