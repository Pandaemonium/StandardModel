import Mathlib.Tactic

/-!
# P9 paired mean-zero fluctuation positivity

Paired positive/negative hidden bookkeeping can have zero mean while retaining a
nonzero second moment. These finite lemmas prove the strict positivity direction
whenever at least one source amplitude is nonzero.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9PairedFluctuationPositive

open BigOperators

def sourceSqSum {N : Nat} (s : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => s i ^ 2

def pairedSqSum {N : Nat} (s : Fin N -> Real) : Real :=
  2 * sourceSqSum s

theorem sourceSqSum_pos_of_exists_nonzero {N : Nat} (s : Fin N -> Real)
    (h : Exists fun i => s i = 0 -> False) :
    0 < sourceSqSum s := by
  let i := Classical.choose h
  have hi : s i = 0 -> False := Classical.choose_spec h
  refine lt_of_lt_of_le (sq_pos_of_ne_zero hi) ?_
  exact Finset.single_le_sum (fun a _ => sq_nonneg (s a)) (Finset.mem_univ i)

theorem pairedSqSum_pos_of_exists_nonzero {N : Nat} (s : Fin N -> Real)
    (h : Exists fun i => s i = 0 -> False) :
    0 < pairedSqSum s := by
  exact mul_pos zero_lt_two (sourceSqSum_pos_of_exists_nonzero s h)

end PhysicsSM.Draft.NullEdgeP9PairedFluctuationPositive
