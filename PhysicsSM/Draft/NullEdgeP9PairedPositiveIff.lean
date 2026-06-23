import Mathlib.Tactic

/-!
# P9 positive second moment iff some source amplitude is nonzero

This combines the positivity and zero-characterization lanes into a single
finite scalar statement.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9PairedPositiveIff

open BigOperators

def sourceSqSum {N : Nat} (s : Fin N -> Real) : Real :=
  Finset.univ.sum fun i => s i ^ 2

def pairedSqSum {N : Nat} (s : Fin N -> Real) : Real :=
  2 * sourceSqSum s

theorem sourceSqSum_pos_iff_exists_nonzero {N : Nat} (s : Fin N -> Real) :
    0 < sourceSqSum s <-> Exists fun i => s i = 0 -> False := by
  constructor
  · intro hpos
    by_contra hnone
    have hall : forall i, s i = 0 := by
      intro i
      by_contra hi
      exact hnone ⟨i, hi⟩
    have hz : sourceSqSum s = 0 := by
      simp [sourceSqSum, hall]
    linarith
  · rintro ⟨i, hi⟩
    exact lt_of_lt_of_le (sq_pos_of_ne_zero hi)
      (Finset.single_le_sum (fun j _ => sq_nonneg (s j)) (Finset.mem_univ i))

theorem pairedSqSum_pos_iff_exists_nonzero {N : Nat} (s : Fin N -> Real) :
    0 < pairedSqSum s <-> Exists fun i => s i = 0 -> False := by
  unfold pairedSqSum
  have htwo : (0 : Real) < 2 := by norm_num
  rw [mul_pos_iff_of_pos_left htwo]
  exact sourceSqSum_pos_iff_exists_nonzero s

end PhysicsSM.Draft.NullEdgeP9PairedPositiveIff
