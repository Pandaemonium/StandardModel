import Mathlib

/-!
# NullStrand finite flux variance target

Abstract finite weighted-variance identity used by KIN-007.
-/

noncomputable section

namespace NullStrandFluxVariance

open scoped BigOperators RealInnerProductSpace

/-- Finite weighted mean in a real inner product space. -/
def weightedMean {Omega V : Type*} [Fintype Omega]
    [NormedAddCommGroup V] [InnerProductSpace Real V]
    (w : Omega -> Real) (x : Omega -> V) : V :=
  ∑ omega, w omega • x omega

/-- KIN-007 core. Unit-direction variance is `1 - ||mean||^2`. -/
theorem weighted_variance_eq_one_sub_normSq
    {Omega V : Type*} [Fintype Omega]
    [NormedAddCommGroup V] [InnerProductSpace Real V]
    (w : Omega -> Real) (x : Omega -> V)
    (hsum : (∑ omega, w omega) = 1)
    (hunit : ∀ omega, ‖x omega‖ = 1) :
    (∑ omega, w omega * ‖x omega - weightedMean w x‖ ^ 2) =
      1 - ‖weightedMean w x‖ ^ 2 := by
  have key : (∑ omega, w omega * ⟪x omega, weightedMean w x⟫)
      = ‖weightedMean w x‖ ^ 2 := by
    rw [show (∑ omega, w omega * ⟪x omega, weightedMean w x⟫)
          = ⟪∑ omega, w omega • x omega, weightedMean w x⟫ by
      rw [sum_inner]
      exact Finset.sum_congr rfl (fun i _ => by rw [real_inner_smul_left])]
    rw [← weightedMean, real_inner_self_eq_norm_sq]
  have expand : ∀ omega, w omega * ‖x omega - weightedMean w x‖ ^ 2
      = w omega - 2 * (w omega * ⟪x omega, weightedMean w x⟫)
        + w omega * ‖weightedMean w x‖ ^ 2 := by
    intro omega
    rw [norm_sub_sq_real, hunit]
    ring
  rw [Finset.sum_congr rfl (fun i _ => expand i),
    Finset.sum_add_distrib, Finset.sum_sub_distrib,
    ← Finset.mul_sum, ← Finset.sum_mul, hsum, key]
  ring

end NullStrandFluxVariance
