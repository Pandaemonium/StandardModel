import PhysicsSM.Draft.NullEdge.Carrier.FiniteGibbsResponse

/-!
# Finite Gibbs variance and fluctuation response

For a nonempty finite canonical ensemble, the energy variance is a sum of
nonnegative centered squares and the derivative of the mean energy with respect
to inverse temperature is minus that variance. The definitions are connected
explicitly to `FiniteGibbsResponse`, so this module extends the landed partition
and logarithmic-response API rather than introducing an unrelated ensemble.

The Pluecker two-level gap `4/25` has variance `4/625` at `beta = 0`; a
degenerate spectrum has zero variance. These are exact finite fluctuation
identities. They do not establish a thermodynamic limit, irreversibility, heat
flow, or a physical temperature calibration.

Provenance: generic finite-ensemble proofs completed by Aristotle project
`6ca64d9b-2373-4842-8658-d76ff79af559`; clean-room integration and explicit
bridge to the live Gibbs-response definitions on 2026-07-10.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.Carrier.FiniteGibbsVariance

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
  ∑ i, probability E beta i * E i

noncomputable def meanSquareEnergy (E : Fin n → ℝ) (beta : ℝ) : ℝ :=
  ∑ i, probability E beta i * (E i) ^ 2

noncomputable def variance (E : Fin n → ℝ) (beta : ℝ) : ℝ :=
  meanSquareEnergy E beta - (meanEnergy E beta) ^ 2

theorem probability_sum_one (E : Fin n → ℝ) (beta : ℝ) :
    ∑ i, probability E beta i = 1 := by
  unfold probability
  rw [← Finset.sum_div _ _ _, div_eq_iff] <;> norm_num [partition]
  exact ne_of_gt <| Finset.sum_pos
    (fun _ _ => Real.exp_pos _) Finset.univ_nonempty

theorem variance_centered_identity (E : Fin n → ℝ) (beta : ℝ) :
    variance E beta =
      ∑ i, probability E beta i * (E i - meanEnergy E beta) ^ 2 := by
  unfold variance meanSquareEnergy meanEnergy
  simp_all +decide [Finset.sum_add_distrib, Finset.mul_sum _ _ _,
    Finset.sum_mul, sub_mul, mul_sub, pow_two]
  simp +decide [← Finset.mul_sum _ _ _, ← Finset.sum_mul, mul_assoc,
    mul_comm, mul_left_comm, probability_sum_one]
  simp +decide [← mul_assoc, ← Finset.mul_sum _ _ _, ← Finset.sum_mul,
    ← Finset.sum_comm, ← Finset.sum_product', probability_sum_one]

theorem variance_nonnegative (E : Fin n → ℝ) (beta : ℝ) :
    0 ≤ variance E beta := by
  exact variance_centered_identity E beta ▸
    Finset.sum_nonneg fun _ _ =>
      mul_nonneg
        (div_nonneg (Real.exp_nonneg _)
          (Finset.sum_nonneg fun _ _ => Real.exp_nonneg _))
        (sq_nonneg _)

/-- Finite fluctuation-response: changing inverse temperature changes the mean
energy by minus the energy variance. -/
theorem meanEnergy_hasDerivAt (E : Fin n → ℝ) (beta : ℝ) :
    HasDerivAt (meanEnergy E) (-variance E beta) beta := by
  convert HasDerivAt.congr_of_eventuallyEq _ ?_ using 1
  exact fun x =>
    (∑ i, Real.exp (-x * E i) * E i) /
      (∑ i, Real.exp (-x * E i))
  · convert HasDerivAt.div (hasDerivAt_deriv_iff.mpr _)
      (hasDerivAt_deriv_iff.mpr _) _ using 1 <;> norm_num [mul_comm]
    · unfold variance
      unfold meanSquareEnergy meanEnergy
      norm_num [← mul_assoc, ← sq, ← Finset.sum_mul _ _ _, weight,
        partition, probability]
      ring
      simp +decide [sq, mul_assoc, mul_comm, mul_left_comm,
        Finset.mul_sum _ _ _, Finset.sum_mul,
        ne_of_gt (show 0 < ∑ i, Real.exp (-(beta * E i)) from
          Finset.sum_pos (fun _ _ => Real.exp_pos _)
            Finset.univ_nonempty)]
      ring
    · exact ne_of_gt <| Finset.sum_pos
        (fun _ _ => Real.exp_pos _) Finset.univ_nonempty
  · filter_upwards [] with x
    unfold meanEnergy
    simp +decide [probability, partition, weight, mul_div_right_comm,
      Finset.sum_div _ _ _]

/-- The variance ensemble uses exactly the same weights and partition function
as `FiniteGibbsResponse`. -/
theorem partition_eq_response (E : Fin n → ℝ) (beta : ℝ) :
    partition E beta = FiniteGibbsResponse.partition E beta := by
  rfl

theorem probability_eq_response (E : Fin n → ℝ) (beta : ℝ) (i : Fin n) :
    probability E beta i = FiniteGibbsResponse.probability E beta i := by
  rfl

/-- The two mean-energy presentations, normalized weighted sum and quotient,
are equal. -/
theorem meanEnergy_eq_response (E : Fin n → ℝ) (beta : ℝ) :
    meanEnergy E beta = FiniteGibbsResponse.meanEnergy E beta := by
  unfold meanEnergy probability partition weight
  unfold FiniteGibbsResponse.meanEnergy FiniteGibbsResponse.partition
    FiniteGibbsResponse.weight
  calc
    ∑ i, (Real.exp (-beta * E i) / ∑ j, Real.exp (-beta * E j)) * E i =
        ∑ i, (E i * Real.exp (-beta * E i)) /
          (∑ j, Real.exp (-beta * E j)) := by
      apply Finset.sum_congr rfl
      intro i _
      ring
    _ = (∑ i, E i * Real.exp (-beta * E i)) /
        (∑ i, Real.exp (-beta * E i)) :=
      (Finset.sum_div Finset.univ
        (fun i : Fin n => E i * Real.exp (-beta * E i))
        (∑ i, Real.exp (-beta * E i))).symm

def twoLevelEnergy (gap : ℝ) : Fin 2 → ℝ
  | 0 => 0
  | 1 => gap

theorem rational_two_level_variance_control :
    variance (twoLevelEnergy (4 / 25)) 0 = 4 / 625 ∧
      0 < variance (twoLevelEnergy (4 / 25)) 0 := by
  norm_num [Fin.sum_univ_succ, variance, meanEnergy, meanSquareEnergy,
    probability, partition, weight, twoLevelEnergy]

theorem degenerate_spectrum_zero_control (c beta : ℝ) :
    variance (fun _ : Fin n => c) beta = 0 := by
  unfold variance meanEnergy meanSquareEnergy
  simp_all +decide [← Finset.sum_mul, probability_sum_one]

theorem probability_positive (E : Fin n → ℝ) (beta : ℝ) (i : Fin n) :
    0 < probability E beta i := by
  exact div_pos (Real.exp_pos _)
    (Finset.sum_pos (fun _ _ => Real.exp_pos _) Finset.univ_nonempty)

/-- Gibbs variance vanishes exactly for a constant finite energy spectrum. -/
theorem variance_eq_zero_iff_constant (E : Fin n → ℝ) (beta : ℝ) :
    variance E beta = 0 ↔ ∃ c : ℝ, ∀ i, E i = c := by
  constructor
  · intro h_var_zero
    have h_eq_mean : ∀ i, (E i - meanEnergy E beta) ^ 2 = 0 := by
      have hsum :
          ∑ i, probability E beta i *
            (E i - meanEnergy E beta) ^ 2 = 0 := by
        rw [← h_var_zero, variance_centered_identity]
      rw [Finset.sum_eq_zero_iff_of_nonneg fun _ _ =>
        mul_nonneg (le_of_lt (probability_positive E beta _))
          (sq_nonneg _)] at hsum
      exact fun i => eq_zero_of_ne_zero_of_mul_left_eq_zero
        (ne_of_gt (probability_positive E beta i))
        (hsum i (Finset.mem_univ i))
    exact ⟨meanEnergy E beta, fun i =>
      sub_eq_zero.mp (sq_eq_zero_iff.mp (h_eq_mean i))⟩
  · rintro ⟨c, hc⟩
    rw [show E = _ from funext hc]
    simpa using degenerate_spectrum_zero_control c beta

/-- Strict fluctuation positivity is equivalent to spectral nondegeneracy. -/
theorem variance_pos_iff_nonconstant (E : Fin n → ℝ) (beta : ℝ) :
    0 < variance E beta ↔ ∃ i j, E i ≠ E j := by
  constructor <;> intro h
  · contrapose! h
    convert (variance_eq_zero_iff_constant E beta).2
      ⟨E 0, fun i => h i 0⟩ |> le_of_eq
  · exact lt_of_le_of_ne (variance_nonnegative E beta) (Ne.symm <| by
      rintro hzero
      exact h.elim fun i hi => hi.elim fun j hj => hj <| by
        have hrigid := variance_eq_zero_iff_constant E beta
        aesop)

theorem rational_two_level_rigidity_control :
    (∃ i j, twoLevelEnergy (4 / 25) i ≠
      twoLevelEnergy (4 / 25) j) ∧
      0 < variance (twoLevelEnergy (4 / 25)) 0 := by
  exact ⟨⟨0, 1, by norm_num [twoLevelEnergy]⟩,
    rational_two_level_variance_control.2⟩

/-- The nonzero two-level fluctuation is the same Pluecker gap used by the
finite action and response modules. -/
theorem rational_plucker_variance_control :
    variance
        (FiniteGibbsResponse.pluckerTwoLevel edge0 (edge1 (2 / 5))) 0 =
        4 / 625 ∧
      0 < variance
        (FiniteGibbsResponse.pluckerTwoLevel edge0 (edge1 (2 / 5))) 0 := by
  have henergy :
      FiniteGibbsResponse.pluckerTwoLevel edge0 (edge1 (2 / 5)) =
        twoLevelEnergy (4 / 25) := by
    funext i
    fin_cases i <;>
      norm_num [FiniteGibbsResponse.pluckerTwoLevel, twoLevelEnergy, massSq,
        edge0, edge1, spinorWedge, Complex.normSq]
  rw [henergy]
  exact rational_two_level_variance_control

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteGibbsVariance.meanEnergy_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms meanEnergy_hasDerivAt

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteGibbsVariance.variance_pos_iff_nonconstant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms variance_pos_iff_nonconstant

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteGibbsVariance.rational_plucker_variance_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_plucker_variance_control

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteGibbsVariance.rational_two_level_rigidity_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_two_level_rigidity_control

end PhysicsSM.Draft.NullEdge.Carrier.FiniteGibbsVariance
