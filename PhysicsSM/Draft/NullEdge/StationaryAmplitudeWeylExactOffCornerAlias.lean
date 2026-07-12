import PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylTangent

/-!
# Exact off-corner alias for the stationary-amplitude Weyl walk

The stationary-amplitude fixture has an exact identity crossing away from the
corner phases.  The witness is the Gaussian-rational `9-40-41` pair

`z_x = (-9 - 40 i) / 41`, `z_y = (-9 + 40 i) / 41`, `z_z = 1`.

The negative control keeps the second phase equal to the first.  Its nonzero
off-diagonal matrix entry shows that conjugate phase pairing is load-bearing.

Provenance: the candidate was obtained by exact elimination on the symmetric
slice `q_y = -q_x`, `q_z = 0`; proofs were completed by Aristotle task
`5633e105-7eac-442c-ac08-1e5edf00c04d` and integrated after statement review.
This is a finite exact crossing witness, not a complete Brillouin-zone census
or a topological charge theorem.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylExactOffCornerAlias

open StationaryAmplitudeWeylTangent
open PhysicsSM.Draft.NullEdge.StationaryAmplitudeProjectorWalk

/-- The first exact phase in the off-corner alias pair. -/
def phaseX : Complex :=
  -(9 : Complex) / 41 - I * ((40 : Complex) / 41)

/-- The conjugate phase paired with `phaseX`. -/
def phaseY : Complex :=
  -(9 : Complex) / 41 + I * ((40 : Complex) / 41)

theorem phaseX_conj_eq_phaseY : starRingEnd Complex phaseX = phaseY := by
  unfold phaseX phaseY
  apply Complex.ext <;>
    simp [Complex.div_re, Complex.div_im, Complex.normSq,
      Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im] <;> norm_num

theorem phases_on_unit_circle :
    starRingEnd Complex phaseX * phaseX = 1 ∧
      starRingEnd Complex phaseY * phaseY = 1 := by
  refine ⟨?_, ?_⟩ <;>
  · apply Complex.ext <;>
      simp [phaseX, phaseY, Complex.div_re, Complex.div_im, Complex.normSq, Complex.sub_re,
        Complex.sub_im, Complex.add_re, Complex.add_im, Complex.mul_re, Complex.mul_im] <;>
      norm_num

/-- The `9-40-41` candidate is an exact identity crossing. -/
theorem exact_offCorner_alias :
    weylStep phaseX phaseY 1 = 1 := by
  unfold weylStep stationaryWalk forwardPhase backwardPhase complement phaseX phaseY
    Px Qx Py Qy Pz Qz
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply, Matrix.add_apply,
      Matrix.smul_apply, Matrix.sub_apply, Complex.ext_iff, Complex.div_re, Complex.div_im,
      Complex.normSq, Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im,
      Complex.sub_re, Complex.sub_im] <;> norm_num

theorem offCorner_phase_ne_origin :
    phaseX ≠ 1 ∧ phaseY ≠ 1 := by
  refine ⟨?_, ?_⟩ <;>
  · simp only [phaseX, phaseY]
    rw [Ne, Complex.ext_iff]
    push_neg
    intro h
    simp [Complex.sub_re, Complex.add_re, Complex.mul_re] at h
    norm_num at h

/-- Using the same orientation on both axes gives an exact nonzero
off-diagonal entry and therefore destroys the alias. -/
theorem wrongOrientation_entry :
    (weylStep phaseX phaseX 1) 0 1 = -(1104 : Complex) / 1681 := by
  unfold weylStep stationaryWalk forwardPhase backwardPhase complement phaseX
    Px Qx Py Qy Pz Qz
  simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.one_apply, Matrix.add_apply,
    Matrix.smul_apply, Matrix.sub_apply, Complex.ext_iff,
    Complex.normSq, Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im,
    Complex.sub_re, Complex.sub_im] <;> norm_num

theorem wrongOrientation_not_alias :
    weylStep phaseX phaseX 1 ≠ 1 := by
  intro h
  have hh := congrFun (congrFun h 0) 1
  rw [wrongOrientation_entry] at hh
  simp at hh

/-- Nondegenerate packaged witness for the manuscript and later root census. -/
theorem exists_exact_nonorigin_unitCircle_alias :
    ∃ zx zy : Complex,
      starRingEnd Complex zx * zx = 1 ∧
      starRingEnd Complex zy * zy = 1 ∧
      zx ≠ 1 ∧ zy ≠ 1 ∧ weylStep zx zy 1 = 1 := by
  exact ⟨phaseX, phaseY, phases_on_unit_circle.1, phases_on_unit_circle.2,
    offCorner_phase_ne_origin.1, offCorner_phase_ne_origin.2, exact_offCorner_alias⟩

/-! ## Assumption-footprint audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylExactOffCornerAlias.exact_offCorner_alias' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exact_offCorner_alias

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylExactOffCornerAlias.wrongOrientation_not_alias' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms wrongOrientation_not_alias

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylExactOffCornerAlias.exists_exact_nonorigin_unitCircle_alias' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_exact_nonorigin_unitCircle_alias

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylExactOffCornerAlias
