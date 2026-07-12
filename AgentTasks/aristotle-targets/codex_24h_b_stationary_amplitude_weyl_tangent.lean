import PhysicsSM.Draft.NullEdge.StationaryAmplitudeProjectorWalk

/-!
# Aristotle target: a stationary-amplitude isotropic Weyl tangent

Build three explicit rational projector pairs.  Each pair is noncommuting and
has a nonzero onsite Laurent coefficient, while its first Laurent moment is
exactly `3/5` times one Pauli matrix.  The ordered three-axis product is exactly
unitary on the three-torus and equals the identity at the origin.

Preserve all explicit matrices and nonzero controls.  This target does not
claim a unique Weyl cone or a complete Brillouin-zone classification; those are
the immediate successor calculation.
-/

open Matrix Complex

noncomputable section

namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylTangent

open StationaryAmplitudeProjectorWalk

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

def sigmaX : M2 := !![0, 1; 1, 0]
def sigmaY : M2 := !![0, -I; I, 0]
def sigmaZ : M2 := !![1, 0; 0, -1]

def Px : M2 := !![9 / 10, 3 / 10; 3 / 10, 1 / 10]
def Qx : M2 := !![1 / 10, 3 / 10; 3 / 10, 9 / 10]

def Py : M2 := !![9 / 10, -(3 / 10) * I; (3 / 10) * I, 1 / 10]
def Qy : M2 := !![1 / 10, -(3 / 10) * I; (3 / 10) * I, 9 / 10]

def Pz : M2 := !![4 / 5, 2 / 5; 2 / 5, 1 / 5]
def Qz : M2 := !![4 / 5, -2 / 5; -2 / 5, 1 / 5]

/-- Generic first Laurent moment of a stationary-amplitude axis. -/
theorem gammaMoment_eq (P Q : M2) :
    gammaPlus P Q - gammaMinus P Q = P + Q - 1 := by
  sorry

theorem Px_isStarProjection : IsStarProjection Px := by
  sorry

theorem Qx_isStarProjection : IsStarProjection Qx := by
  sorry

theorem Py_isStarProjection : IsStarProjection Py := by
  sorry

theorem Qy_isStarProjection : IsStarProjection Qy := by
  sorry

theorem Pz_isStarProjection : IsStarProjection Pz := by
  sorry

theorem Qz_isStarProjection : IsStarProjection Qz := by
  sorry

theorem x_projectors_do_not_commute : Px * Qx ≠ Qx * Px := by
  sorry

theorem y_projectors_do_not_commute : Py * Qy ≠ Qy * Py := by
  sorry

theorem z_projectors_do_not_commute : Pz * Qz ≠ Qz * Pz := by
  sorry

/-- Exact isotropic Weyl first moments. -/
theorem x_gammaMoment :
    gammaPlus Px Qx - gammaMinus Px Qx = (3 / 5 : Complex) • sigmaX := by
  sorry

theorem y_gammaMoment :
    gammaPlus Py Qy - gammaMinus Py Qy = (3 / 5 : Complex) • sigmaY := by
  sorry

theorem z_gammaMoment :
    gammaPlus Pz Qz - gammaMinus Pz Qz = (3 / 5 : Complex) • sigmaZ := by
  sorry

/-- Every axis carries a genuine onsite amplitude. -/
theorem axis_gammaZero_nonzero :
    gammaZero Px Qx ≠ 0 ∧ gammaZero Py Qy ≠ 0 ∧ gammaZero Pz Qz ≠ 0 := by
  sorry

/-- Ordered three-axis stationary-amplitude Weyl step. -/
def weylStep (zx zy zz : Complex) : M2 :=
  stationaryWalk zx Px Qx * stationaryWalk zy Py Qy *
    stationaryWalk zz Pz Qz

/-- Exact all-torus unitarity, without commuting the axis projectors. -/
theorem weylStep_unitary (zx zy zz : Complex)
    (hx0 : zx ≠ 0) (hy0 : zy ≠ 0) (hz0 : zz ≠ 0)
    (hxc : starRingEnd Complex zx = zx⁻¹)
    (hyc : starRingEnd Complex zy = zy⁻¹)
    (hzc : starRingEnd Complex zz = zz⁻¹) :
    IsUnitary (weylStep zx zy zz) := by
  sorry

/-- The designated low-momentum point is exactly an identity crossing. -/
theorem weylStep_one : weylStep 1 1 1 = 1 := by
  sorry

/-- Nonvacuous capstone: isotropic nonzero Pauli moments coexist with exact
unitarity and nonzero stationary amplitude. -/
theorem exists_stationary_amplitude_isotropic_weyl_fixture :
    (gammaPlus Px Qx - gammaMinus Px Qx = (3 / 5 : Complex) • sigmaX) ∧
    (gammaPlus Py Qy - gammaMinus Py Qy = (3 / 5 : Complex) • sigmaY) ∧
    (gammaPlus Pz Qz - gammaMinus Pz Qz = (3 / 5 : Complex) • sigmaZ) ∧
    gammaZero Px Qx ≠ 0 ∧ gammaZero Py Qy ≠ 0 ∧ gammaZero Pz Qz ≠ 0 ∧
    weylStep 1 1 1 = 1 := by
  sorry

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylTangent
