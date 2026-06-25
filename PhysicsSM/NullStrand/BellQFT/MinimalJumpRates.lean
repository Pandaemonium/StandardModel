import Mathlib
import PhysicsSM.NullStrand.BellQFT.FiniteCurrent

/-!
# NullStrand.BellQFT.MinimalJumpRates

Finite Bell-type jump-rate layer built from current-like kernels.
-/

noncomputable section

namespace PhysicsSM.NullStrand.BellQFT

open scoped BigOperators
open Finset

/-- Minimal positive rate from a signed branch current value. -/
def minimalBellRate {Q : Type*} [Fintype Q] (J : Q → Q → ℝ) (ρ : Q → ℝ) (q q' : Q) : ℝ :=
  realPos (J q q') / ρ q

/-- Positive/negative branch split in terms of numerator sign. -/
def minimalBellRate_neg {Q : Type*} [Fintype Q] (J : Q → Q → ℝ) (ρ : Q → ℝ) (q q' : Q) : ℝ :=
  realPos (-J q q') / ρ q

lemma minimalBellRate_mul_density {Q : Type*} [Fintype Q] (J : Q → Q → ℝ) (ρ : Q → ℝ)
    (q q' : Q) (hρ : ρ q ≠ 0) :
    minimalBellRate J ρ q q' * ρ q = realPos (J q q') := by
  unfold minimalBellRate
  field_simp [hρ]

lemma minimalBellRate_neg_mul_density {Q : Type*} [Fintype Q] (J : Q → Q → ℝ) (ρ : Q → ℝ)
    (q q' : Q) (hρ : ρ q ≠ 0) :
    minimalBellRate_neg J ρ q q' * ρ q = realPos (-J q q') := by
  unfold minimalBellRate_neg
  field_simp [hρ]

theorem realPos_sub_realPos_neg (x : ℝ) : realPos x - realPos (-x) = x := by
  by_cases hx : 0 ≤ x
  · simp [realPos, max_eq_left hx, max_eq_right (neg_nonpos.mpr hx)]
  · have hx' : x < 0 := lt_of_not_ge hx
    simp [realPos, max_eq_right (le_of_lt hx'), max_eq_left (neg_nonneg.mpr (le_of_lt hx'))]

theorem minimalBellRate_nonneg {Q : Type*} [Fintype Q] (J : Q → Q → ℝ) (ρ : Q → ℝ)
    (q q' : Q) (hρ : 0 ≤ ρ q) :
    0 ≤ minimalBellRate J ρ q q' := by
  unfold minimalBellRate
  exact div_nonneg (realPos_nonneg (J q q')) hρ

theorem minimalBellRate_zero_of_current_zero {Q : Type*} [Fintype Q] (J : Q → Q → ℝ) (ρ : Q → ℝ)
    (q q' : Q) (hJ : J q q' = 0) :
    minimalBellRate J ρ q q' = 0 := by
  simp [minimalBellRate, hJ, realPos]

/-- Master equation for minimal rates at each configuration from signed current decomposition. -/
theorem minimalBellRate_masterEquation
    {Q : Type*} [Fintype Q] (J : Q → Q → ℝ) (ρ : Q → ℝ) (F : Q → ℝ)
    (hρne : ∀ q, ρ q ≠ 0) (hρpos : ∀ q, 0 ≤ ρ q) (hAnti : ∀ q q', J q q' = -J q' q)
    (hcont : ∀ q, F q = ∑ q', J q q') (q : Q) :
    (∑ q', minimalBellRate J ρ q q' * ρ q) - (∑ q', minimalBellRate J ρ q' q * ρ q') = F q := by
  have hOut :
      (∑ q', minimalBellRate J ρ q q' * ρ q) = ∑ q', realPos (J q q') := by
    refine Finset.sum_congr rfl ?_
    intro q' hq'
    exact minimalBellRate_mul_density (J := J) (ρ := ρ) q q' (hρne q)
  have hIn :
      (∑ q', minimalBellRate J ρ q' q * ρ q') = ∑ q', realPos (J q' q) := by
    refine Finset.sum_congr rfl ?_
    intro q' hq'
    exact minimalBellRate_mul_density (J := J) (ρ := ρ) q' q (hρne q')
  have hIn' : (∑ q', realPos (J q' q)) = ∑ q', realPos (-J q q') := by
    refine Finset.sum_congr rfl ?_
    intro q' hq'
    simpa [hAnti q' q]
  calc
    (∑ q', minimalBellRate J ρ q q' * ρ q) - (∑ q', minimalBellRate J ρ q' q * ρ q')
        = (∑ q', realPos (J q q')) - (∑ q', realPos (J q' q)) := by
            rw [hOut, hIn]
    _ = (∑ q', realPos (J q q')) - (∑ q', realPos (-J q q')) := by
            rw [hIn']
    _ = ∑ q', (realPos (J q q') - realPos (-J q q')) := by
            simpa using
              (Finset.sum_sub_distrib (s := Finset.univ) (f := fun q' => realPos (J q q'))
                (g := fun q' => realPos (-J q q')))
    _ = ∑ q', J q q' := by
          refine Finset.sum_congr rfl ?_
          intro q' hq'
          exact (realPos_sub_realPos_neg (J q q'))
    _ = F q := by
          simpa using (hcont q).symm

/-- Equivariance under relabeling by a finite permutation. -/
theorem minimalBellRate_equivariant {Q : Type*} [Fintype Q] (J : Q → Q → ℝ) (ρ : Q → ℝ)
    (q q' : Q) (σ : Equiv Q Q) (hρ : ∀ q, ρ (σ q) = ρ q)
    (hJ : ∀ q q', J (σ q) (σ q') = J q q') :
    minimalBellRate J ρ (σ q) (σ q') = minimalBellRate J ρ q q' := by
  unfold minimalBellRate
  simp [hρ, hJ]

end PhysicsSM.NullStrand.BellQFT
