import PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylTangent

/-!
# Exact corner alias in the stationary-amplitude Weyl construction

The stationary-amplitude construction combines strict range-one locality,
exact unitarity, nonzero onsite amplitudes, and an isotropic Weyl first moment.
It is nevertheless not unique-cone: the distinct torus phase
`(-1, 1, -1)` is another exact identity crossing.

This module proves only that decisive alias. A reproducible exact-coefficient
oracle (`Scripts/oracle/analyze_stationary_amplitude_weyl.py`) finds two more
off-corner identity roots numerically, but no completeness claim is imported
from that scan.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylAlias

open Matrix Complex
open StationaryAmplitudeProjectorWalk
open StationaryAmplitudeWeylTangent

/-- The non-origin `(-1,1,-1)` torus corner is an exact identity crossing. -/
theorem corner_alias :
    weylStep (-1) 1 (-1) = 1 := by
  unfold weylStep stationaryWalk forwardPhase backwardPhase complement
  unfold Px Qx Py Qy Pz Qz
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.sub_apply,
      Matrix.one_apply, Matrix.add_apply,
      Complex.ext_iff] <;> norm_num

/-- The alias phase is genuinely distinct from the designated origin phase. -/
theorem corner_phase_ne_origin :
    ((-1 : Complex), (1 : Complex), (-1 : Complex)) ≠ (1, 1, 1) := by
  intro h
  have hx := congrArg Prod.fst h
  norm_num at hx

/-- Exact nonconstancy control: at another physical torus point the symbol has
diagonal entry `16/25`, rather than the identity entry `1`. -/
theorem nonconstant_control_entry :
    (weylStep I 1 1) 0 0 = (16 : Complex) / 25 := by
  unfold weylStep stationaryWalk forwardPhase backwardPhase complement
  unfold Px Qx Py Qy Pz Qz
  simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.sub_apply,
    Matrix.one_apply, Matrix.add_apply, Complex.ext_iff]
  norm_num

theorem nonconstant_control : weylStep I 1 1 ≠ 1 := by
  intro h
  have h00 := congrArg
    (fun A : StationaryAmplitudeWeylTangent.M2 => A 0 0) h
  have h00' : (weylStep I 1 1) 0 0 = (1 : Complex) := by
    simpa using h00
  rw [nonconstant_control_entry] at h00'
  norm_num at h00'

/-- Nonvacuous unique-cone kill for this demonstrably nonconstant exact
construction. -/
theorem exists_distinct_identity_alias :
    ∃ z : Complex × Complex × Complex,
      z ≠ (1, 1, 1) ∧ weylStep z.1 z.2.1 z.2.2 = 1 := by
  exact ⟨(-1, 1, -1), corner_phase_ne_origin, corner_alias⟩

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylAlias.corner_alias' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms corner_alias

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylAlias.exists_distinct_identity_alias' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_distinct_identity_alias

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylAlias.nonconstant_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonconstant_control

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylAlias
