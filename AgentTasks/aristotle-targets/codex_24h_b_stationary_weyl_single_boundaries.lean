import PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylBoundaryScaffold

/-!
# Aristotle target: three single phase-minus-one boundary exclusions

Prove all three live matrix statements exactly. Preserve the imported
projectors, factor order, tangent chart, and theorem statements. The scaffold
provides explicit `-1` axis walks and tangent-chart support. These are exact
finite matrix/polynomial exclusions, not numerical root claims.
-/

noncomputable section

open Matrix Complex Real Set

namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylSingleBoundaries

open StationaryAmplitudeWeylTangent
open StationaryAmplitudeWeylAlgebraicOffAxisAlias
open StationaryAmplitudeWeylBoundaryScaffold

theorem no_x_boundary_identity (ty tz : ℝ) :
    ¬ (weylStep (-1) (unitPhase ty) (unitPhase tz) = 1) := by
  sorry

theorem no_y_boundary_identity (tx tz : ℝ) :
    ¬ (weylStep (unitPhase tx) (-1) (unitPhase tz) = 1) := by
  sorry

theorem no_z_boundary_identity (tx ty : ℝ) :
    ¬ (weylStep (unitPhase tx) (unitPhase ty) (-1) = 1) := by
  sorry

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylSingleBoundaries
