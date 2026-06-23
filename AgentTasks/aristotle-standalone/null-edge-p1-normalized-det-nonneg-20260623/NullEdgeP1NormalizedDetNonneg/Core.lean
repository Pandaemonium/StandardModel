import Mathlib.Tactic

noncomputable section

namespace NullEdgeP1NormalizedDetNonneg

def normalizedBlochDet (rx ry rz : Real) : Real :=
  ((1 + rz) / 2) * ((1 - rz) / 2) - (rx / 2) ^ 2 - (ry / 2) ^ 2

def blochRadiusSq (rx ry rz : Real) : Real :=
  rx ^ 2 + ry ^ 2 + rz ^ 2

theorem normalizedBlochDet_nonneg_iff_radius_le_one
    (rx ry rz : Real) :
    0 <= normalizedBlochDet rx ry rz <-> blochRadiusSq rx ry rz <= 1 := by
  sorry

end NullEdgeP1NormalizedDetNonneg
