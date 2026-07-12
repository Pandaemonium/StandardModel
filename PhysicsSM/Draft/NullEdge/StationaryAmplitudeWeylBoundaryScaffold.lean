import PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylAlgebraicOffAxisAlias

/-!
# Exact phase-minus-one boundary scaffold for the live Weyl symbol

This module contains shared tangent-chart surjectivity and explicit
phase-minus-one walk calculations, together with four completed boundary
controls harvested from the first census attempt.

The exact oracle and primitive polynomial equations are recorded in
`B_STATIONARY_WEYL_TANGENT_BOUNDARY_ORACLE_2026-07-12.md`. Prove the live matrix
statements, not a copied fixture. Keep the unit-circle hypotheses and the
boundary disjunction unchanged.
-/

noncomputable section

open Matrix Complex Real Set

namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylBoundaryScaffold

open StationaryAmplitudeWeylTangent
open StationaryAmplitudeWeylAlgebraicOffAxisAlias
open StationaryAmplitudeProjectorWalk

/-! ## Scaffolding: explicit boundary walks and the tangent chart -/

/-- `unitPhase` at the origin is the trivial phase `1`. -/
theorem unitPhase_zero : unitPhase 0 = 1 := by
  unfold unitPhase
  norm_num

/-- The `stationaryWalk` at the trivial phase `1` is the identity. -/
theorem walk_one (P Q : StationaryAmplitudeWeylTangent.M2) :
    stationaryWalk (1 : ℂ) P Q = 1 := by
  unfold stationaryWalk forwardPhase backwardPhase complement
  simp

/-- Explicit `-1`-phase walk on the x axis. -/
theorem walk_neg1_x :
    stationaryWalk (-1 : ℂ) Px Qx = !![(7 / 25 : ℂ), -24 / 25; 24 / 25, 7 / 25] := by
  unfold stationaryWalk forwardPhase backwardPhase complement Px Qx
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.add_apply, Matrix.sub_apply,
      Matrix.smul_apply, Matrix.one_apply] <;> norm_num

/-- Explicit `-1`-phase walk on the y axis. -/
theorem walk_neg1_y :
    stationaryWalk (-1 : ℂ) Py Qy = !![(7 / 25 : ℂ), (24 / 25) * I; (24 / 25) * I, 7 / 25] := by
  unfold stationaryWalk forwardPhase backwardPhase complement Py Qy
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.add_apply, Matrix.sub_apply,
      Matrix.smul_apply, Matrix.one_apply, Complex.ext_iff] <;> norm_num

/-- Explicit `-1`-phase walk on the z axis. -/
theorem walk_neg1_z :
    stationaryWalk (-1 : ℂ) Pz Qz = !![(7 / 25 : ℂ), 24 / 25; -24 / 25, 7 / 25] := by
  unfold stationaryWalk forwardPhase backwardPhase complement Pz Qz
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.add_apply, Matrix.sub_apply,
      Matrix.smul_apply, Matrix.one_apply] <;> norm_num

/-- Every unit complex phase other than `-1` is represented by a finite real
tangent coordinate. -/
theorem unitPhase_surjective {z : ℂ} (hz : normSq z = 1) (hne : z ≠ -1) :
    ∃ t : ℝ, unitPhase t = z := by
  use z.im / (1 + z.re)
  by_cases h : 1 + z.re = 0 <;> simp_all +decide [Complex.ext_iff, unitPhase]
  · simp_all +decide [Complex.normSq_apply]
    exact False.elim <| hne (by linarith) (by nlinarith)
  · norm_cast
    simp_all +decide [Complex.normSq, sq]
    ring_nf at *
    norm_cast
    simp_all +decide [sq, mul_assoc, mul_comm, mul_left_comm]
    ring_nf at *
    grind +qlia

theorem no_xy_boundary_identity (tz : ℝ) :
    ¬ (weylStep (-1) (-1) (unitPhase tz) = 1) := by
  unfold weylStep stationaryWalk forwardPhase backwardPhase complement unitPhase
  norm_num [Complex.ext_iff, Matrix.mul_apply]
  intro h
  have h00 := congrFun (congrFun h 0) 0
  norm_num [Matrix.mul_apply, Px, Qx, Py, Qy, Pz, Qz] at h00
  ring_nf at h00
  norm_num at h00
  norm_num [Complex.normSq, Complex.ext_iff, sq] at h00
  grind

theorem no_yz_boundary_identity (tx : ℝ) :
    ¬ (weylStep (unitPhase tx) (-1) (-1) = 1) := by
  by_contra h
  unfold weylStep stationaryWalk forwardPhase backwardPhase complement at h
  unfold Px Qx Py Qy Pz Qz at h
  norm_num [← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply] at h
  grind +splitImp

theorem all_neg_one_not_identity :
    ¬ (weylStep (-1) (-1) (-1) = 1) := by
  unfold weylStep
  rw [walk_neg1_x, walk_neg1_y, walk_neg1_z]
  intro h
  have h00 := congrFun (congrFun h 0) 0
  simp [Matrix.mul_apply, Fin.sum_univ_two, Complex.ext_iff] at h00
  norm_num at h00

theorem weylStep_neg_one_one_neg_one :
    weylStep (-1) 1 (-1) = 1 := by
  unfold weylStep
  rw [walk_neg1_x, walk_one, walk_neg1_z, Matrix.mul_one]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two] <;> norm_num

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylBoundaryScaffold
