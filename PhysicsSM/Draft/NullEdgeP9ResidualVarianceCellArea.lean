import Mathlib.Tactic

/-!
# Residual variance scaling with cell area

Proof targets for the P9 residual variance scaling.
Shows that the second moment of a weighted configuration (variance) is bounded by
the maximum cell weight (area) times the sum of cell weights.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9ResidualVarianceCellArea

open BigOperators

/-- Sum of squared weights. -/
def weightSqSum {N : Nat} (w : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => w i ^ 2

/-- Total sum of weights. -/
def weightSum {N : Nat} (w : Fin N -> Real) : Real :=
  Finset.univ.sum w

/-- Maximum weight in the finite ensemble. -/
def maxWeight {N : Nat} (w : Fin N -> Real) : Real :=
  -- If N is zero, return 0, else compute max
  if h : N > 0 then
    haveI : Nonempty (Fin N) := Fin.pos_iff_nonempty.mp h
    Finset.univ.sup' Finset.univ_nonempty w
  else
    0

/--
The sum of squared weights is bounded by the maximum weight times the total sum of weights,
provided the weights are non-negative.
-/
theorem weightSqSum_le_maxWeight_mul_weightSum {N : Nat} (w : Fin N -> Real)
    (hnonneg : ∀ i, 0 ≤ w i) :
    weightSqSum w ≤ maxWeight w * weightSum w := by
  rcases N with _ | N
  · simp only [weightSqSum, weightSum, maxWeight, Finset.univ_eq_empty, Finset.sum_empty,
      mul_zero, le_refl]
  · have hmax : ∀ i, w i ≤ maxWeight w := by
      intro i
      simp only [maxWeight, Nat.succ_pos, dif_pos]
      exact Finset.le_sup' w (Finset.mem_univ i)
    rw [weightSqSum, weightSum, Finset.mul_sum]
    refine Finset.sum_le_sum fun i _ => ?_
    rw [sq]
    exact mul_le_mul_of_nonneg_right (hmax i) (hnonneg i)

end PhysicsSM.Draft.NullEdgeP9ResidualVarianceCellArea
