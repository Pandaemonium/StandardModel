import PhysicsSM.Draft.NullEdge.ChangingModeEmbedding

/-!
# Quantitative max-radius weighted tail rate on changing 3D mode boxes

This module upgrades qualitative square-summable exhaustion to an explicit
three-dimensional cutoff rate. It is still a coefficient-space theorem, not
Shannon interpolation, a lattice-spacing identification, or position-space
Dirac convergence.

Provenance: all theorem statements were prepared locally. Proofs were returned
in the in-progress snapshot of Aristotle project
`a827ab8e-13c7-48ba-8c4e-c7d2b26a7223`, then independently compiled against
the live project before integration. The statements are unchanged.
-/

noncomputable section

open scoped BigOperators Topology

namespace PhysicsSM.Draft.NullEdge.SobolevTailRate

open ChangingModeEmbedding

/-- Max-coordinate radius of an integer three-momentum. -/
def modeRadius (k : Mode) : Nat :=
  k.1.1.natAbs ⊔ k.1.2.natAbs ⊔ k.2.natAbs

/-- Order-`s` max-coordinate polynomial weighted squared mode energy. -/
def weightedModeEnergy {E : Type*} [Norm E]
    (s : Nat) (f : Mode -> E) : Real :=
  ∑' k, ((1 + modeRadius k : Nat) ^ s : Real) * ‖f k‖ ^ 2

theorem mem_modeBox_iff_radius_le (k : Mode) (N : Nat) :
    k ∈ modeBox N ↔ modeRadius k ≤ N := by
  obtain ⟨⟨x, y⟩, z⟩ := k
  unfold modeRadius
  simp +decide [mem_modeBox_iff]
  omega

theorem radius_ge_succ_of_not_mem {k : Mode} {N : Nat}
    (hk : k ∉ modeBox N) : N + 1 ≤ modeRadius k := by
  exact Nat.succ_le_of_lt
    (lt_of_not_ge fun h => hk <| (mem_modeBox_iff_radius_le _ _).2 h)

theorem cutoff_weight_le {k : Mode} {N s : Nat}
    (hk : k ∉ modeBox N) :
    ((N + 2 : Nat) ^ s : Real) ≤
      ((1 + modeRadius k : Nat) ^ s : Real) := by
  exact pow_le_pow_left₀ (by positivity)
    (by
      norm_cast
      linarith [radius_ge_succ_of_not_mem hk]) _

theorem residual_energy_eq_tail {E : Type*} [NormedAddCommGroup E]
    (N : Nat) (f : Mode -> E) :
    modeEnergy (fun k => f k - interpolate N (sample N f) k) =
      ∑' k, if k ∈ modeBox N then 0 else ‖f k‖ ^ 2 := by
  convert tsum_congr _
  intro k
  split_ifs <;> simp_all +decide [interpolate, sample]

/-- An order-`s` max-radius coefficient weight controls the squared tail by
the inverse `s`th power of the box radius. -/
theorem residual_energy_le_weighted_rate
    {E : Type*} [NormedAddCommGroup E]
    (s N : Nat) (f : Mode -> E)
    (hf : Summable
      (fun k => ((1 + modeRadius k : Nat) ^ s : Real) * ‖f k‖ ^ 2)) :
    modeEnergy (fun k => f k - interpolate N (sample N f) k) ≤
      (((N + 2 : Nat) ^ s : Real)⁻¹) * weightedModeEnergy s f := by
  rw [residual_energy_eq_tail N f]
  simp +decide only [weightedModeEnergy]
  rw [← tsum_mul_left]
  refine Summable.tsum_le_tsum ?_ ?_ ?_
  · intro k
    split_ifs <;> simp_all +decide [mul_comm, mul_left_comm]
    · positivity
    · refine le_mul_of_one_le_right (sq_nonneg _) ?_
      rw [inv_mul_eq_div, one_le_div (by positivity)]
      exact_mod_cast Nat.pow_le_pow_left
        (by linarith [radius_ge_succ_of_not_mem ‹_›]) _
  · refine Summable.of_nonneg_of_le (fun k => ?_) (fun k => ?_) hf
    · positivity
    · split_ifs
      · exact mul_nonneg (by positivity) (sq_nonneg _)
      · exact le_mul_of_one_le_left (sq_nonneg _)
          (one_le_pow₀ (mod_cast Nat.le_add_right _ _))
  · exact hf.mul_left _

/-- Finite first-order weighted mode energy forces the changing-box
interpolation residual to vanish in squared coefficient norm. This is the
quantitative ultraviolet-tail limit paired with
`residual_energy_le_weighted_rate`; it is still a coefficient-space result. -/
theorem residual_energy_tendsto_zero_of_weighted_one
    {E : Type*} [NormedAddCommGroup E]
    (f : Mode -> E)
    (hf : Summable
      (fun k => ((1 + modeRadius k : Nat) : Real) * ‖f k‖ ^ 2)) :
    Filter.Tendsto
      (fun N : Nat =>
        modeEnergy (fun k => f k - interpolate N (sample N f) k))
      Filter.atTop (nhds 0) := by
  refine squeeze_zero
    (g := fun N : Nat => weightedModeEnergy 1 f / (N + 2 : Real))
    (fun N => tsum_nonneg fun _ => sq_nonneg _)
    (fun N => ?_) ?_
  · have h := residual_energy_le_weighted_rate 1 N f (by
      simpa using hf)
    simpa [div_eq_mul_inv, mul_comm, weightedModeEnergy] using h
  · exact tendsto_const_nhds.div_atTop
      (Filter.tendsto_atTop_add_const_right _ _ tendsto_natCast_atTop_atTop)

/-- Sharp nonzero boundary control: a delta mode just beyond the positive
x-face saturates the pointwise cutoff weight. -/
theorem boundary_delta_weight_control (s N : Nat) :
    let q : Mode := ((((N + 1 : Nat) : Int), 0), 0)
    weightedModeEnergy s (deltaAt q (1 : Real)) =
      ((N + 2 : Nat) ^ s : Real) ∧
    modeEnergy (fun k =>
      deltaAt q (1 : Real) k -
        interpolate N (sample N (deltaAt q (1 : Real))) k) = 1 := by
  unfold weightedModeEnergy
  constructor
  · rw [tsum_eq_single (((N + 1 : Int), 0), 0)] <;>
      norm_num [deltaAt]
    · unfold modeRadius
      norm_num [add_comm, add_left_comm, add_assoc]
      rw [abs_of_nonneg (by positivity)]
      ring_nf
    · aesop
  · rw [outside_mode_killed]
    unfold modeEnergy deltaAt
    norm_num

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.SobolevTailRate.residual_energy_le_weighted_rate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms residual_energy_le_weighted_rate

/-- info: 'PhysicsSM.Draft.NullEdge.SobolevTailRate.residual_energy_tendsto_zero_of_weighted_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms residual_energy_tendsto_zero_of_weighted_one

/-- info: 'PhysicsSM.Draft.NullEdge.SobolevTailRate.boundary_delta_weight_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms boundary_delta_weight_control

end PhysicsSM.Draft.NullEdge.SobolevTailRate
