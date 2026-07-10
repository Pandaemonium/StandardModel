import PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian

/-!
# A finite canonical ensemble and exact response identity

For every nonempty finite energy spectrum, the canonical partition function is
positive, the Gibbs probabilities are nonnegative and normalized, and the
derivative of `log Z` with respect to inverse temperature is minus the mean
energy. The two-level Pluecker model uses energies `0` and the finite action
Hessian, with a nonzero rational gap `4/25`.

This is an exact finite thermodynamic model. It does not produce irreversibility,
a thermodynamic limit, a time arrow, or a physical temperature calibration.

Provenance: generic finite-ensemble proofs completed by Aristotle project
`3f5974b4-bfc1-4092-bc6f-4b9da615f61d`; clean-room Pluecker instantiation on
2026-07-10, informed by canonical-ensemble theorem shapes.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier.FiniteGibbsResponse

open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary
open PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian

variable {n : ℕ} [NeZero n]

noncomputable def weight (E : Fin n → ℝ) (beta : ℝ) (i : Fin n) : ℝ :=
  Real.exp (-beta * E i)

noncomputable def partition (E : Fin n → ℝ) (beta : ℝ) : ℝ :=
  ∑ i, weight E beta i

noncomputable def probability (E : Fin n → ℝ) (beta : ℝ) (i : Fin n) : ℝ :=
  weight E beta i / partition E beta

noncomputable def meanEnergy (E : Fin n → ℝ) (beta : ℝ) : ℝ :=
  (∑ i, E i * weight E beta i) / partition E beta

theorem partition_pos (E : Fin n → ℝ) (beta : ℝ) :
    0 < partition E beta := by
  exact Finset.sum_pos (fun _ _ => Real.exp_pos _) Finset.univ_nonempty

omit [NeZero n] in
theorem probability_nonnegative (E : Fin n → ℝ) (beta : ℝ) (i : Fin n) :
    0 ≤ probability E beta i := by
  exact div_nonneg (Real.exp_nonneg _)
    (Finset.sum_nonneg fun _ _ => Real.exp_nonneg _)

theorem probability_sum_one (E : Fin n → ℝ) (beta : ℝ) :
    ∑ i, probability E beta i = 1 := by
  unfold probability weight partition
  rw [← Finset.sum_div]
  exact div_self (ne_of_gt <| Finset.sum_pos
    (fun _ _ => Real.exp_pos _) Finset.univ_nonempty)

/-- Exact finite response identity `d log Z / d beta = -<E>`. -/
theorem log_partition_hasDerivAt (E : Fin n → ℝ) (beta : ℝ) :
    HasDerivAt (fun b => Real.log (partition E b))
      (-meanEnergy E beta) beta := by
  convert HasDerivAt.log (hasDerivAt_deriv_iff.mpr _) _ using 1;
  · unfold meanEnergy
    unfold weight partition
    unfold weight
    norm_num [mul_comm]
    ring
  · unfold partition
    norm_num [weight]
  · exact ne_of_gt (partition_pos E beta)

def pluckerTwoLevel (psi phi : CSpinor) : Fin 2 → ℝ
  | 0 => 0
  | 1 => massSq psi phi

theorem plucker_two_level_partition (psi phi : CSpinor) (beta : ℝ) :
    partition (pluckerTwoLevel psi phi) beta =
      1 + Real.exp (-beta * massSq psi phi) := by
  convert Fin.sum_univ_two _ using 2
  norm_num [partition, weight, pluckerTwoLevel]

theorem rational_plucker_gibbs_control (beta : ℝ) :
    partition (pluckerTwoLevel edge0 (edge1 (2 / 5))) beta =
        1 + Real.exp (-beta * (4 / 25)) ∧
      0 < partition (pluckerTwoLevel edge0 (edge1 (2 / 5))) beta := by
  constructor
  · rw [plucker_two_level_partition]
    norm_num [massSq, edge0, edge1, spinorWedge, Complex.normSq]
  · exact partition_pos _ _

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteGibbsResponse.log_partition_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms log_partition_hasDerivAt

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteGibbsResponse.rational_plucker_gibbs_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_plucker_gibbs_control

end PhysicsSM.Draft.NullEdge.Carrier.FiniteGibbsResponse
