import Mathlib

/-!
# NullStrand.NullFiber.RegulatorMeanNorm

Manifest node KIN-010: a finite probability law on unit directions containing an
`ε`-fraction of a mean-zero uniform component cannot have a mean-direction norm
exceeding `1 - ε` — the finite, kernel-checkable core of the guardrail that exact
mean matching is incompatible with a uniform positive floor (improved roadmap §7.1).

Provenance: clean-room statement; proof from Aristotle project
`68ecc789-21c3-4a72-909a-9945791182d1`, verified `sorry`/`axiom`-free and
statement-identical, integrated 2026-06-25.
-/

namespace PhysicsSM.NullStrand.NullFiber

open scoped BigOperators
open Finset

/-- KIN-010. A finite probability law on unit directions with a mean-zero
`ε`-uniform component has mean-direction norm at most `1 - ε`. -/
theorem uniformComponent_bounds_meanNorm
    {Ω : Type*} [Fintype Ω] {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (dir : Ω → E) (hdir : ∀ ω, ‖dir ω‖ = 1)
    (u q : Ω → ℝ) (ε : ℝ) (hε0 : 0 ≤ ε) (hε1 : ε ≤ 1)
    (hu_mean : ∑ ω, u ω • dir ω = 0)
    (hq_nonneg : ∀ ω, 0 ≤ q ω) (hq_sum : ∑ ω, q ω = 1) :
    ‖∑ ω, (ε * u ω + (1 - ε) * q ω) • dir ω‖ ≤ 1 - ε := by
  simp +decide only [add_smul, mul_smul]
  rw [Finset.sum_add_distrib, ← Finset.smul_sum, ← Finset.smul_sum, hu_mean, smul_zero, zero_add]
  rw [norm_smul, Real.norm_of_nonneg (sub_nonneg.2 hε1)]
  exact mul_le_of_le_one_right (sub_nonneg.2 hε1)
    (le_trans (norm_sum_le _ _) (by simp +decide [norm_smul, abs_of_nonneg, *]))

end PhysicsSM.NullStrand.NullFiber
