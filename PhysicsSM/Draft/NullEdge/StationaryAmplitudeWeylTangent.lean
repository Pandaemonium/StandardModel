import PhysicsSM.Draft.NullEdge.StationaryAmplitudeProjectorWalk

/-!
# A stationary-amplitude isotropic Weyl tangent

We build three explicit rational projector pairs. Each pair is noncommuting and
has a nonzero onsite Laurent coefficient, while its first Laurent moment is
exactly `3/5` times one Pauli matrix.  The ordered three-axis product is exactly
unitary on the three-torus and equals the identity at the origin.

The result does not claim a unique Weyl cone or a complete Brillouin-zone
classification; those are the immediate successor calculation.

Provenance: clean-room successor to the Gupta-Short-inspired stationary
amplitude primitive. Proofs by Aristotle project
`02fbf989-4080-4e0c-86c0-3eede23f9aaa`, independently rebuilt locally on
July 11, 2026.
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
  unfold gammaPlus gammaMinus complement
  noncomm_ring

theorem Px_isStarProjection : IsStarProjection Px := by
  constructor
  · change Px * Px = Px
    unfold Px; ext i j; fin_cases i <;> fin_cases j <;>
      · simp [Matrix.mul_apply, Fin.sum_univ_two]; norm_num
  · change star Px = Px
    unfold Px; ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.star_apply]

theorem Qx_isStarProjection : IsStarProjection Qx := by
  constructor
  · change Qx * Qx = Qx
    unfold Qx; ext i j; fin_cases i <;> fin_cases j <;>
      · simp [Matrix.mul_apply, Fin.sum_univ_two]; norm_num
  · change star Qx = Qx
    unfold Qx; ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.star_apply]

theorem Py_isStarProjection : IsStarProjection Py := by
  constructor
  · change Py * Py = Py
    unfold Py; ext i j; fin_cases i <;> fin_cases j <;>
      · simp [Matrix.mul_apply, Fin.sum_univ_two, Complex.ext_iff]; norm_num
  · change star Py = Py
    unfold Py; ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.star_apply]

theorem Qy_isStarProjection : IsStarProjection Qy := by
  constructor
  · change Qy * Qy = Qy
    unfold Qy; ext i j; fin_cases i <;> fin_cases j <;>
      · simp [Matrix.mul_apply, Fin.sum_univ_two, Complex.ext_iff]; norm_num
  · change star Qy = Qy
    unfold Qy; ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.star_apply]

theorem Pz_isStarProjection : IsStarProjection Pz := by
  constructor
  · change Pz * Pz = Pz
    unfold Pz; ext i j; fin_cases i <;> fin_cases j <;>
      · simp [Matrix.mul_apply, Fin.sum_univ_two]; norm_num
  · change star Pz = Pz
    unfold Pz; ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.star_apply]

theorem Qz_isStarProjection : IsStarProjection Qz := by
  constructor
  · change Qz * Qz = Qz
    unfold Qz; ext i j; fin_cases i <;> fin_cases j <;>
      · simp [Matrix.mul_apply, Fin.sum_univ_two]; norm_num
  · change star Qz = Qz
    unfold Qz; ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.star_apply]

theorem x_projectors_do_not_commute : Px * Qx ≠ Qx * Px := by
  unfold Px Qx
  intro h
  have h01 := congrFun (congrFun h 0) 1
  simp [Matrix.mul_apply, Fin.sum_univ_two] at h01
  norm_num at h01

theorem y_projectors_do_not_commute : Py * Qy ≠ Qy * Py := by
  unfold Py Qy
  intro h
  have h01 := congrFun (congrFun h 0) 1
  simp [Matrix.mul_apply, Fin.sum_univ_two, Complex.ext_iff] at h01
  norm_num at h01

theorem z_projectors_do_not_commute : Pz * Qz ≠ Qz * Pz := by
  unfold Pz Qz
  intro h
  have h01 := congrFun (congrFun h 0) 1
  simp [Matrix.mul_apply, Fin.sum_univ_two] at h01
  norm_num at h01

/-- Exact isotropic Weyl first moments. -/
theorem x_gammaMoment :
    gammaPlus Px Qx - gammaMinus Px Qx = (3 / 5 : Complex) • sigmaX := by
  rw [gammaMoment_eq]
  unfold Px Qx sigmaX
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.sub_apply, Matrix.smul_apply] <;> norm_num

theorem y_gammaMoment :
    gammaPlus Py Qy - gammaMinus Py Qy = (3 / 5 : Complex) • sigmaY := by
  rw [gammaMoment_eq]
  unfold Py Qy sigmaY
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.sub_apply, Matrix.smul_apply, Complex.ext_iff] <;> norm_num

theorem z_gammaMoment :
    gammaPlus Pz Qz - gammaMinus Pz Qz = (3 / 5 : Complex) • sigmaZ := by
  rw [gammaMoment_eq]
  unfold Pz Qz sigmaZ
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.sub_apply, Matrix.smul_apply] <;> norm_num

/-- Every axis carries a genuine onsite amplitude. -/
theorem axis_gammaZero_nonzero :
    gammaZero Px Qx ≠ 0 ∧ gammaZero Py Qy ≠ 0 ∧ gammaZero Pz Qz ≠ 0 := by
  refine ⟨?_, ?_, ?_⟩
  · intro h
    have h00 := congrFun (congrFun h 0) 0
    unfold gammaZero complement Px Qx at h00
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.sub_apply, Matrix.one_apply,
      Matrix.add_apply, Matrix.vecMul, dotProduct] at h00
    norm_num at h00
  · intro h
    have h00 := congrFun (congrFun h 0) 0
    unfold gammaZero complement Py Qy at h00
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.sub_apply, Matrix.one_apply,
      Matrix.add_apply, Matrix.vecMul, dotProduct, Complex.ext_iff] at h00
    norm_num at h00
  · intro h
    have h00 := congrFun (congrFun h 0) 0
    unfold gammaZero complement Pz Qz at h00
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.sub_apply, Matrix.one_apply,
      Matrix.add_apply, Matrix.vecMul, dotProduct] at h00
    norm_num at h00

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
  unfold weylStep
  exact isUnitary_mul (isUnitary_mul
    (stationaryWalk_unitary zx Px Qx hx0 Px_isStarProjection Qx_isStarProjection hxc)
    (stationaryWalk_unitary zy Py Qy hy0 Py_isStarProjection Qy_isStarProjection hyc))
    (stationaryWalk_unitary zz Pz Qz hz0 Pz_isStarProjection Qz_isStarProjection hzc)

/-- The designated low-momentum point is exactly an identity crossing. -/
theorem weylStep_one : weylStep 1 1 1 = 1 := by
  have h : ∀ P Q : M2, stationaryWalk (1 : Complex) P Q = 1 := by
    intro P Q
    unfold stationaryWalk forwardPhase backwardPhase complement
    simp
  unfold weylStep
  rw [h, h, h, Matrix.mul_one, Matrix.mul_one]

/-- Nonvacuous capstone: isotropic nonzero Pauli moments coexist with exact
unitarity and nonzero stationary amplitude. -/
theorem exists_stationary_amplitude_isotropic_weyl_fixture :
    (gammaPlus Px Qx - gammaMinus Px Qx = (3 / 5 : Complex) • sigmaX) ∧
    (gammaPlus Py Qy - gammaMinus Py Qy = (3 / 5 : Complex) • sigmaY) ∧
    (gammaPlus Pz Qz - gammaMinus Pz Qz = (3 / 5 : Complex) • sigmaZ) ∧
    gammaZero Px Qx ≠ 0 ∧ gammaZero Py Qy ≠ 0 ∧ gammaZero Pz Qz ≠ 0 ∧
    weylStep 1 1 1 = 1 := by
  exact ⟨x_gammaMoment, y_gammaMoment, z_gammaMoment,
    axis_gammaZero_nonzero.1, axis_gammaZero_nonzero.2.1, axis_gammaZero_nonzero.2.2,
    weylStep_one⟩

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylTangent.weylStep_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weylStep_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylTangent.exists_stationary_amplitude_isotropic_weyl_fixture' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_stationary_amplitude_isotropic_weyl_fixture

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylTangent
