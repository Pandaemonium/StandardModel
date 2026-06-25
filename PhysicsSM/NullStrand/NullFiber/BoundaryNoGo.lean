import Mathlib

/-!
# NullStrand.NullFiber.BoundaryNoGo

Manifest node KIN-011: a finite probability law on unit directions in a real
inner-product space whose mean has norm exactly `1` must be supported on a single
direction. This is the equality/strict-convexity companion to KIN-010
(`uniformComponent_bounds_meanNorm`): the massless limit can only be reached by a
Dirac (single-direction) law, not by a uniformly elliptic family.

Provenance: clean-room statement; proof from Aristotle project
`d0f54ae9-f214-478d-bf17-a0d7fa7f2e9e`, verified `sorry`/`axiom`-free and
statement-identical, integrated 2026-06-25.
-/

namespace PhysicsSM.NullStrand.NullFiber

open scoped BigOperators RealInnerProductSpace
open Finset

/-- KIN-011. A finite unit-direction probability law with mean-norm one is
supported on a single direction. -/
theorem meanNorm_eq_one_implies_support_collinear
    {Ω : Type*} [Fintype Ω] {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (dir : Ω → E) (hdir : ∀ ω, ‖dir ω‖ = 1)
    (p : Ω → ℝ) (hp : ∀ ω, 0 ≤ p ω) (hsum : ∑ ω, p ω = 1)
    (hmean : ‖∑ ω, p ω • dir ω‖ = 1) :
    ∀ ω ω', 0 < p ω → 0 < p ω' → dir ω = dir ω' := by
  have h_inner : ∀ ω ω', 0 < p ω → 0 < p ω' → inner ℝ (dir ω) (dir ω') = 1 := by
    have h_inner_sum : ∑ ω, ∑ ω', p ω * p ω' * (1 - inner ℝ (dir ω) (dir ω')) = 0 := by
      have h_inner : ∑ ω, ∑ ω', p ω * p ω' * inner ℝ (dir ω) (dir ω') = 1 := by
        have h_inner : inner ℝ (∑ ω, p ω • dir ω) (∑ ω, p ω • dir ω) = ∑ ω, ∑ ω', p ω * p ω' * inner ℝ (dir ω) (dir ω') := by
          simp +decide only [inner_sum, inner_smul_right, sum_inner, inner_smul_left]
          simp +decide only [real_inner_comm, Finset.mul_sum _ _ _, mul_assoc]
          rfl
        rw [← h_inner, real_inner_self_eq_norm_sq, hmean, one_pow]
      simp_all +decide [mul_sub, ← Finset.mul_sum _ _ _]
    rw [Finset.sum_eq_zero_iff_of_nonneg] at h_inner_sum
    · intro ω ω' hω hω'
      have := h_inner_sum ω (Finset.mem_univ ω)
      rw [Finset.sum_eq_zero_iff_of_nonneg] at this
      · exact mul_left_cancel₀ (mul_ne_zero hω.ne' hω'.ne') (by linarith [this ω' (Finset.mem_univ ω')])
      · exact fun i _ => mul_nonneg (mul_nonneg hω.le (hp i)) (sub_nonneg.2 (by nlinarith only [abs_le.mp (abs_real_inner_le_norm (dir ω) (dir i)), hdir ω, hdir i]))
    · exact fun ω _ => Finset.sum_nonneg fun ω' _ => mul_nonneg (mul_nonneg (hp ω) (hp ω')) (sub_nonneg.2 (by nlinarith only [abs_le.mp (abs_real_inner_le_norm (dir ω) (dir ω')), hdir ω, hdir ω']))
  intro ω ω' hω hω'
  have h_eq : ‖dir ω - dir ω'‖ ^ 2 = 0 := by
    rw [@norm_sub_sq ℝ]; simp +decide [*]
    norm_num
  exact sub_eq_zero.mp (norm_eq_zero.mp (sq_eq_zero_iff.mp h_eq))

end PhysicsSM.NullStrand.NullFiber
