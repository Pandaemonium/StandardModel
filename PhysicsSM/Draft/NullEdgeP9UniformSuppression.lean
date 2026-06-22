import PhysicsSM.Draft.NullEdgeP9WeightedFluctuation

/-!
# Uniform finite residual-source suppression

This draft module packages the finite suppression corollary for the P9
cosmological-constant/source-visibility branch.

If a fixed total source scale `A` is spread uniformly over `N` independent
two-sign cells, each cell has amplitude `A / N`. The weighted fluctuation theorem
then gives normalized second moment `A^2 / N`.

This is still finite algebra, not a cosmological-constant theorem. Its value is
that it states the exact large-`N` suppression law that any later diamond/cell
model would have to justify physically.

Aristotle project `3b956553-e339-40e4-8790-fe7baabe2469` proved the standalone
version on 2026-06-22. The repo version below reuses the integrated weighted
fluctuation theorem and uses propositional nonzero hypotheses for readability.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9UniformSuppression

open BigOperators

/-- Uniform amplitude per cell for total scale `A`. -/
def uniformAmp (N : Nat) (A : Real) (_ : Fin N) : Real :=
  A / (N : Real)

/-- Uniformly weighted total sign source of an `N`-cell configuration. -/
def uniformTotalSource (N : Nat) (A : Real) (cfg : Fin N -> Bool) : Real :=
  PhysicsSM.Draft.NullEdgeP9WeightedFluctuation.weightedTotalSource (uniformAmp N A) cfg

/-- Unnormalized second moment over all uniform sign configurations. -/
def uniformEnsembleSecondMoment (N : Nat) (A : Real) : Real :=
  PhysicsSM.Draft.NullEdgeP9WeightedFluctuation.weightedEnsembleSecondMoment (uniformAmp N A)

/-- Uniform amplitudes have squared-amplitude sum `A^2 / N`. -/
theorem uniformAmp_sq_sum_eq_totalSq_div_card {N : Nat} (A : Real)
    (hN : Not ((N : Real) = 0)) :
    PhysicsSM.Draft.NullEdgeP9WeightedFluctuation.amplitudeSqSum (uniformAmp N A) =
      A ^ 2 / (N : Real) := by
  unfold PhysicsSM.Draft.NullEdgeP9WeightedFluctuation.amplitudeSqSum uniformAmp
  rw [Finset.sum_const]
  simp only [Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
  field_simp [hN]

/--
Normalized uniform residual-source variance.

If the total scale `A` is spread uniformly over `N` independent sign cells, the
normalized second moment is `A^2 / N`.
-/
theorem normalizedUniformSecondMoment_eq_totalSq_div_card
    {N : Nat} (A : Real) (hN : Not ((N : Real) = 0)) :
    uniformEnsembleSecondMoment N A / (2 : Real) ^ N = A ^ 2 / (N : Real) := by
  unfold uniformEnsembleSecondMoment
  rw [PhysicsSM.Draft.NullEdgeP9WeightedFluctuation.normalizedWeightedSecondMoment_eq_amplitudeSqSum]
  exact uniformAmp_sq_sum_eq_totalSq_div_card A hN

end PhysicsSM.Draft.NullEdgeP9UniformSuppression
