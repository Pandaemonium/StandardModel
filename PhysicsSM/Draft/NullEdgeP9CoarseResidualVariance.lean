import Mathlib.Tactic

/-!
# P9 coarse residual-variance identity

This module integrates Aristotle project
`5626ed17-206a-4c75-8073-a1aec026a458`.

Scientific role: finite coarse-graining algebra for the P9 source-visibility
branch. If independent fine residual-source cells are grouped into coarse
blocks, the variance carried by a coarse block is the sum of the fine variances
inside it, and the total coarse variance equals the original fine variance.

This supports the corrected discrete-first P9 gate: microscopic data may be
rough or ill-conditioned, but the large-scale residual statistic should be
specified by an explicit coarse-graining map and should have a stable finite
scaling law.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9CoarseResidualVariance

open BigOperators

/-- Sum of squared fine-cell amplitudes. -/
def amplitudeSqSum {N : Nat} (amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => amp i ^ 2

/--
The variance assigned to a coarse block is the sum of squared amplitudes of the
fine cells mapped to that block.
-/
def blockVariance {N M : Nat} (block : Fin N -> Fin M)
    (amp : Fin N -> Real) (k : Fin M) : Real :=
  (Finset.univ.filter fun i : Fin N => block i = k).sum fun i => amp i ^ 2

/-- Total variance after coarse-graining by a block map. -/
def coarseVariance {N M : Nat} (block : Fin N -> Fin M)
    (amp : Fin N -> Real) : Real :=
  Finset.univ.sum fun k : Fin M => blockVariance block amp k

/-- Every coarse block has nonnegative residual variance. -/
theorem blockVariance_nonneg {N M : Nat}
    (block : Fin N -> Fin M) (amp : Fin N -> Real) (k : Fin M) :
    0 <= blockVariance block amp k := by
  apply Finset.sum_nonneg
  intro i _
  exact pow_two_nonneg (amp i)

/-- Summing block variances over coarse cells recovers total fine variance. -/
theorem coarseVariance_eq_amplitudeSqSum {N M : Nat}
    (block : Fin N -> Fin M) (amp : Fin N -> Real) :
    coarseVariance block amp = amplitudeSqSum amp := by
  unfold coarseVariance amplitudeSqSum
  simp +decide [Finset.sum_filter, blockVariance]
  rw [Finset.sum_comm]
  aesop

/-- The same identity after dividing by a nonzero external scale. -/
theorem coarseVariance_density_eq_amplitudeSqSum_div_scale
    {N M : Nat} (block : Fin N -> Fin M) (amp : Fin N -> Real) (scale : Real)
    (_hscale : scale != 0) :
    coarseVariance block amp / scale = amplitudeSqSum amp / scale := by
  rw [coarseVariance_eq_amplitudeSqSum]

end PhysicsSM.Draft.NullEdgeP9CoarseResidualVariance

end
