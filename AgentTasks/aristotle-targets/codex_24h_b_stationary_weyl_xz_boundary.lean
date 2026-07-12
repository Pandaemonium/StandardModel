import PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylBoundaryScaffold

/-!
# Aristotle target: exact xz phase-minus-one boundary

Prove the exact iff without changing the live matrix, projectors, factor order,
or tangent convention. The scaffold already proves the forward witness
`weylStep (-1) 1 (-1) = 1`, `unitPhase 0 = 1`, and supplies explicit boundary
walk matrices. The hard direction is exclusion of every `ty != 0`.
-/

noncomputable section

open Matrix Complex Real Set

namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylXZBoundary

open StationaryAmplitudeWeylTangent
open StationaryAmplitudeWeylAlgebraicOffAxisAlias
open StationaryAmplitudeWeylBoundaryScaffold

theorem xz_boundary_identity_iff (ty : ℝ) :
    weylStep (-1) (unitPhase ty) (-1) = 1 ↔ ty = 0 := by
  sorry

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylXZBoundary
