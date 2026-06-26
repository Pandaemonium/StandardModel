import Mathlib

/-!
# NullStrand finite flux reweighting normalization target

Focused KIN-005 algebra: reweighting finite weights by a positive observer
factor and dividing by the total produces total mass one.
-/

noncomputable section

namespace NullStrandFluxReweightNormalize

open scoped BigOperators

/-- Weighted total before normalization. -/
def weightedTotal {Omega : Type*} [Fintype Omega]
    (a w : Omega -> Real) : Real :=
  ∑ omega, a omega * w omega

/-- Reweighted finite law. -/
def reweightedLaw {Omega : Type*} [Fintype Omega]
    (a w : Omega -> Real) (Z : Real) : Omega -> Real :=
  fun omega => a omega * w omega / Z

/-- Normalizing by the weighted total gives total mass one. -/
theorem reweightedLaw_sum_eq_one {Omega : Type*} [Fintype Omega]
    (a w : Omega -> Real) (Z : Real)
    (hZ : Z = weightedTotal a w) (hZne : Z ≠ 0) :
    ∑ omega, reweightedLaw a w Z omega = 1 := by
  unfold reweightedLaw
  rw [← Finset.sum_div]
  rw [div_eq_one_iff_eq hZne]
  rw [hZ]
  rfl

/-- Reweighted entries are nonnegative when weights and observer factors are. -/
theorem reweightedLaw_nonneg {Omega : Type*} [Fintype Omega]
    (a w : Omega -> Real) (Z : Real)
    (ha : ∀ omega, 0 <= a omega) (hw : ∀ omega, 0 <= w omega) (hZ : 0 < Z) :
    ∀ omega, 0 <= reweightedLaw a w Z omega := by
  intro omega
  unfold reweightedLaw
  apply div_nonneg
  · exact mul_nonneg (ha omega) (hw omega)
  · exact le_of_lt hZ

end NullStrandFluxReweightNormalize
