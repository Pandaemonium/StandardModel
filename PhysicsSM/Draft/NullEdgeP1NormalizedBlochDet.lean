import Mathlib.Tactic

/-!
# P1 normalized Bloch determinant

This module records the normalized version of the celestial-moment determinant:
for a Bloch vector `r`, the determinant of the normalized `2 x 2` state is
`(1 - |r|^2) / 4`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP1NormalizedBlochDet

def normalizedBlochDet (rx ry rz : Real) : Real :=
  ((1 + rz) / 2) * ((1 - rz) / 2) - (rx / 2) ^ 2 - (ry / 2) ^ 2

def blochRadiusSq (rx ry rz : Real) : Real :=
  rx ^ 2 + ry ^ 2 + rz ^ 2

theorem four_normalizedBlochDet_eq_one_sub_blochRadiusSq
    (rx ry rz : Real) :
    4 * normalizedBlochDet rx ry rz = 1 - blochRadiusSq rx ry rz := by
  unfold normalizedBlochDet blochRadiusSq
  ring

end PhysicsSM.Draft.NullEdgeP1NormalizedBlochDet
