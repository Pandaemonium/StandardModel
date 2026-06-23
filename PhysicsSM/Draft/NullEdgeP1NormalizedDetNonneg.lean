import Mathlib.Tactic

/-!
# P1 normalized determinant nonnegativity

For a normalized Bloch vector, the determinant is nonnegative exactly inside the
unit Bloch ball. This makes the observer-conditioned `4 det(rho) = 1 - |r|^2`
boundary explicit.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP1NormalizedDetNonneg

def normalizedBlochDet (rx ry rz : Real) : Real :=
  ((1 + rz) / 2) * ((1 - rz) / 2) - (rx / 2) ^ 2 - (ry / 2) ^ 2

def blochRadiusSq (rx ry rz : Real) : Real :=
  rx ^ 2 + ry ^ 2 + rz ^ 2

theorem normalizedBlochDet_nonneg_iff_radius_le_one
    (rx ry rz : Real) :
    0 <= normalizedBlochDet rx ry rz <-> blochRadiusSq rx ry rz <= 1 := by
  unfold normalizedBlochDet blochRadiusSq
  constructor <;> intro h <;> nlinarith

end PhysicsSM.Draft.NullEdgeP1NormalizedDetNonneg
