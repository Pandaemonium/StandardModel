import Mathlib

/-!
# Finite Fourier lift of uniform symbol convergence

A uniform modewise error bound on a fixed finite momentum grid lifts to an
explicit position-space synthesis bound with one factor equal to the number of
modes. In particular, a uniform `D/n` symbol estimate implies convergence of
the synthesized finite-grid field.

This is the exact finite-Fourier successor to
`BoundedMomentumManyStepContinuum`. It is not an infinite-volume inverse
Fourier theorem, an `L2` propagator estimate, or a continuum Dirac PDE.

Provenance: theorem shapes checked against Mathlib's finite-sum and Fourier
norm APIs; proof completed by Aristotle project
`92331c27-1f0a-40c3-824e-28c432756f8e` after the 2026-07-10 literature pass.
-/

open scoped BigOperators Topology
open Filter

namespace PhysicsSM.Draft.NullEdge.FiniteFourierContinuumLift

variable {ι E : Type*} [Fintype ι]
  [NormedAddCommGroup E] [NormedSpace ℂ E]

noncomputable def synth (phase : ι -> ℂ) (f : ι -> E) : E :=
  ∑ k, phase k • f k

theorem synth_sub (phase : ι -> ℂ) (f g : ι -> E) :
    synth phase f - synth phase g = synth phase (fun k => f k - g k) := by
  simp only [synth, smul_sub, Finset.sum_sub_distrib]

/-- Uniform modewise error on a finite momentum grid lifts to a synthesized
position-space error with the explicit cardinality factor. -/
theorem finite_fourier_error_bound (phase : ι -> ℂ) (approx exact : ι -> E)
    (ε : ℝ) (hphase : ∀ k, ‖phase k‖ ≤ 1)
    (herr : ∀ k, ‖approx k - exact k‖ ≤ ε) :
    ‖synth phase approx - synth phase exact‖ ≤ (Fintype.card ι : ℝ) * ε := by
  rw [synth_sub]
  unfold synth
  calc
    ‖∑ k, phase k • (approx k - exact k)‖
        ≤ ∑ k, ‖phase k • (approx k - exact k)‖ := norm_sum_le _ _
    _ ≤ ∑ _k : ι, ε := by
      apply Finset.sum_le_sum
      intro k _
      rw [norm_smul]
      calc
        ‖phase k‖ * ‖approx k - exact k‖
            ≤ 1 * ε :=
              mul_le_mul (hphase k) (herr k) (norm_nonneg _) (by norm_num)
        _ = ε := one_mul ε
    _ = (Fintype.card ι : ℝ) * ε := by
      rw [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]

/-- A uniform `D/n` symbol estimate on a fixed finite momentum grid implies
convergence of the finite Fourier synthesis. -/
theorem finite_fourier_tendsto (phase : ι -> ℂ)
    (approx : ℕ -> ι -> E) (exact : ι -> E) (D : ℝ)
    (hphase : ∀ k, ‖phase k‖ ≤ 1)
    (herr : ∀ n, 0 < n -> ∀ k,
      ‖approx n k - exact k‖ ≤ D / (n : ℝ)) :
    Tendsto (fun n => synth phase (approx n)) atTop
      (nhds (synth phase exact)) := by
  have hg : Tendsto (fun n : ℕ => (Fintype.card ι : ℝ) * (D / n))
      atTop (nhds 0) := by
    have h0 : Tendsto (fun n : ℕ => D / (n : ℝ)) atTop (nhds 0) :=
      tendsto_const_div_atTop_nhds_zero_nat D
    simpa using h0.const_mul (Fintype.card ι : ℝ)
  have key : ∀ᶠ n : ℕ in atTop,
      ‖synth phase (approx n) - synth phase exact‖ ≤
        (Fintype.card ι : ℝ) * (D / n) := by
    filter_upwards [eventually_gt_atTop 0] with n hn
    exact finite_fourier_error_bound phase (approx n) exact (D / n)
      hphase (herr n hn)
  rw [tendsto_iff_norm_sub_tendsto_zero]
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le'
    tendsto_const_nhds hg ?_ key
  exact Eventually.of_forall (fun n => norm_nonneg _)

def twoPhase : Fin 2 -> ℂ := ![1, 1]
def twoModes : Fin 2 -> ℂ := ![1, 1]

/-- Two aligned modes saturate the cardinality factor, so the finite-grid bound
is not a vacuous consequence of cancellation. -/
theorem two_mode_sharp_witness :
    synth twoPhase twoModes = 2 ∧
      ‖synth twoPhase twoModes‖ = (Fintype.card (Fin 2) : ℝ) * 1 := by
  constructor
  · simp [synth, twoPhase, twoModes, Fin.sum_univ_two]
    norm_num
  · have h : synth twoPhase twoModes = 2 := by
      simp [synth, twoPhase, twoModes, Fin.sum_univ_two]
      norm_num
    rw [h]
    simp [Fintype.card_fin]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteFourierContinuumLift.finite_fourier_error_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finite_fourier_error_bound

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteFourierContinuumLift.finite_fourier_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finite_fourier_tendsto

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteFourierContinuumLift.two_mode_sharp_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms two_mode_sharp_witness

end PhysicsSM.Draft.NullEdge.FiniteFourierContinuumLift
