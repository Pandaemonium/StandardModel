import Mathlib.Tactic

noncomputable section

namespace NullEdgeP1NormalizedBlochDet

def normalizedBlochDet (rx ry rz : Real) : Real :=
  ((1 + rz) / 2) * ((1 - rz) / 2) - (rx / 2) ^ 2 - (ry / 2) ^ 2

def blochRadiusSq (rx ry rz : Real) : Real :=
  rx ^ 2 + ry ^ 2 + rz ^ 2

theorem four_normalizedBlochDet_eq_one_sub_blochRadiusSq
    (rx ry rz : Real) :
    4 * normalizedBlochDet rx ry rz = 1 - blochRadiusSq rx ry rz := by
  sorry

end NullEdgeP1NormalizedBlochDet
