import PhysicsSM.Draft.NullEdge.SummableFourierContinuumLift

/-!
# Explicit nonzero countable geometric-mode synthesis

An exact normalized geometric envelope defines a nonzero countable complex mode
family whose synthesis is `1/(n+1)` and therefore converges to zero. Constant
mode weights fail the summability gate.

This is an executable infinite-mode witness for the generic summable synthesis
theorem. It contains no checkerboard walk data, volume limit, Fourier integral,
`L2` estimate, or PDE recovery.

Provenance: proof completed by Aristotle project
`0a050dc1-051d-412b-8a86-3b061e3acaa4` after the countable-continuum audit.
-/

open scoped BigOperators Topology
open Filter

namespace PhysicsSM.Draft.NullEdge.GeometricModeSynthesis

noncomputable def envelope (k : ℕ) : ℝ :=
  (1 / 2 : ℝ) ^ (k + 1)

noncomputable def approx (n k : ℕ) : ℂ :=
  (((1 : ℝ) / (n + 1)) * envelope k : ℝ)

noncomputable def synthesis (n : ℕ) : ℂ :=
  ∑' k, approx n k

theorem envelope_summable_and_normalized :
    Summable envelope ∧ (∑' k, envelope k) = 1 ∧ envelope 0 > 0 := by
  unfold envelope
  ring_nf
  norm_num
  rw [tsum_mul_right, tsum_geometric_of_lt_one] <;> norm_num
  exact Summable.mul_right _ summable_geometric_two

/-- Exact nonzero countable-mode synthesis at every finite approximation
index. -/
theorem synthesis_exact (n : ℕ) :
    synthesis n = ((1 : ℝ) / (n + 1) : ℂ) := by
  unfold synthesis approx
  have h := envelope_summable_and_normalized
  norm_cast at *
  simp_all +decide [tsum_mul_left]

theorem synthesis_tendsto_zero :
    Tendsto synthesis atTop (nhds 0) := by
  convert Complex.continuous_ofReal.continuousAt.tendsto.comp
    tendsto_one_div_add_atTop_nhds_zero_nat using 2
  funext n
  simp [synthesis_exact, one_div]

/-- Constant mode weights fail the summability gate. -/
theorem constant_envelope_not_summable :
    ¬ Summable (fun _ : ℕ => (1 : ℝ)) := by
  norm_num [summable_const_iff]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.GeometricModeSynthesis.synthesis_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms synthesis_exact

/-- info: 'PhysicsSM.Draft.NullEdge.GeometricModeSynthesis.synthesis_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms synthesis_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.GeometricModeSynthesis.constant_envelope_not_summable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms constant_envelope_not_summable

end PhysicsSM.Draft.NullEdge.GeometricModeSynthesis
