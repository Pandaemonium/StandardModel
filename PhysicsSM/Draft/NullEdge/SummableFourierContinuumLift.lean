import PhysicsSM.Draft.NullEdge.FiniteFourierContinuumLift

/-!
# Countable Fourier lift under a summable mode envelope

A summable nonnegative envelope upgrades pointwise relative error to an exact
countable synthesis bound. If the scalar relative error tends to zero, the
synthesized fields converge in norm. This is the countable successor to the
fixed-grid theorem in `FiniteFourierContinuumLift`.

The theorem still assumes summability of every synthesized series and a
walk-specific mode envelope. It is not yet an infinite-volume Dirac PDE theorem,
an `L2` propagator statement, or a proof that the checkerboard walk supplies the
required envelope.

Provenance: theorem shape selected after Mathlib searches for
`tendstoUniformly_tsum`, summable tails, and geometric-series bounds; proof
completed by Aristotle project `30a9b761-a905-427f-a989-41afe9dc0a83` and
clean-room ported into the project namespace on 2026-07-10.
-/

open scoped BigOperators Topology
open Filter

namespace PhysicsSM.Draft.NullEdge.SummableFourierContinuumLift

variable {ι E : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]

/-- Countable Fourier synthesis for an explicitly summable mode family. -/
noncomputable def synthInfinite (phase : ι -> ℂ) (f : ι -> E) : E :=
  ∑' k, phase k • f k

/-- A summable mode envelope lifts a pointwise relative error to a countable
synthesis bound. -/
theorem infinite_fourier_error_bound
    (phase : ι -> ℂ) (approx exact : ι -> E)
    (g : ι -> ℝ) (ε : ℝ)
    (hg : Summable g) (hg0 : ∀ k, 0 ≤ g k) (hε : 0 ≤ ε)
    (hphase : ∀ k, ‖phase k‖ ≤ 1)
    (ha : Summable fun k => phase k • approx k)
    (he : Summable fun k => phase k • exact k)
    (herr : ∀ k, ‖approx k - exact k‖ ≤ ε * g k) :
    ‖synthInfinite phase approx - synthInfinite phase exact‖ ≤
      ε * ∑' k, g k := by
  have hεg : ∀ k, 0 ≤ ε * g k := fun k => mul_nonneg hε (hg0 k)
  have hTriangle :
      ‖∑' k, phase k • (approx k - exact k)‖ ≤
        ∑' k, ‖phase k‖ * ‖approx k - exact k‖ := by
    convert norm_tsum_le_tsum_norm _
    · rw [norm_smul]
    · exact Summable.of_nonneg_of_le
        (fun k => norm_nonneg _)
        (fun k => by
          simpa [norm_smul] using
            mul_le_mul (hphase k) (herr k) (norm_nonneg _) (by norm_num))
        (hg.mul_left ε)
  refine le_trans ?_ (hTriangle.trans ?_)
  · convert le_rfl
    exact Summable.tsum_sub ha he ▸ by
      congr
      ext
      simp +decide [smul_sub]
  · rw [← tsum_mul_left]
    exact Summable.tsum_le_tsum
      (fun k =>
        (mul_le_mul_of_nonneg_right (hphase k) (norm_nonneg _)).trans
          (by nlinarith [herr k, hg0 k]))
      (Summable.of_nonneg_of_le
        (fun k => mul_nonneg (norm_nonneg _) (norm_nonneg _))
        (fun k =>
          (mul_le_mul_of_nonneg_right (hphase k) (norm_nonneg _)).trans
            (by nlinarith [herr k, hεg k]))
        (hg.mul_left _))
      (hg.mul_left _)

/-- A vanishing relative envelope gives norm convergence of the countable
Fourier synthesis, provided every synthesized series is summable. -/
theorem infinite_fourier_tendsto
    (phase : ι -> ℂ) (approx : ℕ -> ι -> E) (exact : ι -> E)
    (g : ι -> ℝ) (ε : ℕ -> ℝ)
    (hg : Summable g) (hg0 : ∀ k, 0 ≤ g k)
    (hε0 : Tendsto ε atTop (nhds 0)) (hε : ∀ n, 0 ≤ ε n)
    (hphase : ∀ k, ‖phase k‖ ≤ 1)
    (ha : ∀ n, Summable fun k => phase k • approx n k)
    (he : Summable fun k => phase k • exact k)
    (herr : ∀ n k, ‖approx n k - exact k‖ ≤ ε n * g k) :
    Tendsto (fun n => synthInfinite phase (approx n)) atTop
      (nhds (synthInfinite phase exact)) := by
  rw [tendsto_iff_norm_sub_tendsto_zero]
  refine squeeze_zero
    (fun _ => norm_nonneg _)
    (fun n => infinite_fourier_error_bound phase (approx n) exact g (ε n)
      hg hg0 (hε n) hphase (ha n) he (herr n)) ?_
  simpa using hε0.mul tendsto_const_nhds

/-- A nontrivial normalized envelope for explicit countable controls. -/
noncomputable def geometricEnvelope (k : ℕ) : ℝ :=
  (1 / 2 : ℝ) ^ (k + 1)

theorem geometric_envelope_witness :
    Summable geometricEnvelope ∧
      (∑' k, geometricEnvelope k) = 1 ∧ geometricEnvelope 0 > 0 := by
  unfold geometricEnvelope
  norm_num [pow_succ', tsum_mul_left, tsum_geometric_two]
  exact Summable.mul_left _ summable_geometric_two

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.SummableFourierContinuumLift.infinite_fourier_error_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms infinite_fourier_error_bound

/-- info: 'PhysicsSM.Draft.NullEdge.SummableFourierContinuumLift.infinite_fourier_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms infinite_fourier_tendsto

/-- info: 'PhysicsSM.Draft.NullEdge.SummableFourierContinuumLift.geometric_envelope_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms geometric_envelope_witness

end PhysicsSM.Draft.NullEdge.SummableFourierContinuumLift
