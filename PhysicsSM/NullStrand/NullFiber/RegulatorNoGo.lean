import Mathlib
import PhysicsSM.NullStrand.Conventions

/-!
# NullStrand.NullFiber.RegulatorNoGo

Finite regulator obstruction in the convex finite setting.

The theorem below encodes the finite no-go idea: a non-zero uniform component
of a bounded direction law forces a strict suppression of the mean norm unless the
whole law is supported by the non-uniform part.
-/

noncomputable section

namespace PhysicsSM.NullStrand.NullFiber

open scoped BigOperators
open Finset

/-- Finite expectation operator for an explicit weight function. -/
def expectation {Ω : Type*} [Fintype Ω] {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (μ : Ω → ℝ) (direction : Ω → E) : E :=
  ∑ ω, μ ω • direction ω

/-- If a distribution has an `ε`-uniform component, then the mean norm is bounded by `1 - ε`.

This is the finite-algebraic backbone of the regulator no-go statement.
-/
theorem uniformComponent_bounds_meanNorm
    {Ω : Type*} [Fintype Ω] [DecidableEq Ω]
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (direction : Ω → E)
    (hdir_norm : ∀ ω, ‖direction ω‖ ≤ 1)
    (hUniformMean : ∑ ω, direction ω = 0)
    (q : Ω → ℝ)
    (hq_nonneg : ∀ ω, 0 ≤ q ω)
    (hq_sum : ∑ ω, q ω = 1)
    (ε : ℝ)
    (hε : 0 ≤ ε) (hε₁ : ε ≤ 1)
    (μ : Ω → ℝ)
    (hμ : ∀ ω, μ ω = ε / (Fintype.card Ω : ℝ) + (1 - ε) * q ω) :
    ‖expectation μ direction‖ ≤ 1 - ε := by
  have hsplit :
      expectation μ direction =
        ε / (Fintype.card Ω : ℝ) • (∑ ω, direction ω) +
          (1 - ε) • expectation q direction := by
    unfold expectation
    calc
      ∑ ω, μ ω • direction ω
          = ∑ ω, (ε / (Fintype.card Ω : ℝ) + (1 - ε) * q ω) • direction ω := by
              simp [hμ]
      _ = ∑ ω, (ε / (Fintype.card Ω : ℝ) • direction ω +
            ((1 - ε) * q ω) • direction ω) := by
          simp [add_smul]
      _ = ∑ ω, (ε / (Fintype.card Ω : ℝ)) • direction ω +
            ∑ ω, ((1 - ε) * q ω) • direction ω := by
          simpa [Finset.sum_add_distrib]
      _ = ε / (Fintype.card Ω : ℝ) • (∑ ω, direction ω) +
            (1 - ε) • expectation q direction := by
        congr 2
        · simpa using (smul_sum (ε / (Fintype.card Ω : ℝ)) (fun ω => direction ω))
        ·
          calc
            ∑ ω, ((1 - ε) * q ω) • direction ω
                = ∑ ω, ((1 - ε) : ℝ) • (q ω • direction ω) := by
                    refine Finset.sum_congr rfl ?_ ; intro ω hω
                    simp [smul_smul, mul_comm, mul_left_comm, mul_assoc]
            _ = (1 - ε) • expectation q direction := by
                  symm
                  exact smul_sum (1 - ε) (fun ω => q ω • direction ω)
  have hmean :
      expectation μ direction = (1 - ε) • expectation q direction := by
    calc
      expectation μ direction = ε / (Fintype.card Ω : ℝ) • (∑ ω, direction ω) +
          (1 - ε) • expectation q direction := hsplit
      _ = (1 - ε) • expectation q direction := by simp [hUniformMean]
  have hqBound : ‖expectation q direction‖ ≤ 1 := by
    calc
      ‖expectation q direction‖ = ‖∑ ω, q ω • direction ω‖ := rfl
      _ ≤ ∑ ω, ‖q ω • direction ω‖ := norm_sum_le
      _ = ∑ ω, |q ω| * ‖direction ω‖ := by
            refine Finset.sum_congr rfl ?_ ; intro ω hω
            simp [norm_smul, abs_of_nonneg (hq_nonneg ω)]
      _ ≤ ∑ ω, q ω * 1 := by
            refine Finset.sum_le_sum ?_
            intro ω hω
            exact mul_le_mul_of_nonneg_left (hdir_norm ω) (hq_nonneg ω)
      _ = 1 := by simpa using hq_sum
  have hε₂ : 0 ≤ 1 - ε := sub_nonneg.mpr hε₁
  calc
    ‖expectation μ direction‖ = ‖(1 - ε) • expectation q direction‖ := by simpa [hmean]
    _ = |1 - ε| * ‖expectation q direction‖ := by simp [norm_smul]
    _ = (1 - ε) * ‖expectation q direction‖ := by rw [abs_of_nonneg hε₂]
    _ ≤ (1 - ε) * 1 := mul_le_mul_of_nonneg_left hqBound hε₂
    _ = 1 - ε := by ring

end PhysicsSM.NullStrand.NullFiber
