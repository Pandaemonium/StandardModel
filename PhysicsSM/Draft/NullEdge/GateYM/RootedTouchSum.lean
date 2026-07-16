import PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion

/-!
# Gate YM: rooted-touch normalization bridge (R0)

This module proves the first ("R0") rung of the repaired rooted-touch route
toward the Kotecky-Preiss cluster bound.  The audit project
`535c94a2-a856-4797-8196-2f4c6ac6f107` produced an exact two-type
counterexample to the open *unrooted* recurrence `pairSum_le_expBound`; that
theorem, its exponential weakening `boundedTouchSum_succ_le`, and everything
depending on their open proof hole must not be used here.

R0 is only a normalization bridge: replacing the ordered normalization `1/n!`
by the rooted normalization `1/(n-1)!` can only increase the (nonnegative)
cluster sum, because `(n-1)! ≤ n!` and every summand is nonnegative.  It does
*not* prove the rooted exponential recurrence R1, the size-to-height bridge,
the KP criterion, cluster summability, or a Yang–Mills mass gap.

The proof is termwise:

* if a cluster touches `g`, both normalizations produce nonnegative summands
  and `spanningTreeCount / n! * absWeight ≤ spanningTreeCount / (n-1)! *
  absWeight` because `(n-1)! ≤ n!`;
* if the cluster is not connected, its `spanningTreeCount` vanishes, so the
  left summand is `0` and the right summand is nonnegative;
* if the cluster does not touch `g`, both summands are `0`.

The truncated `Nat` subtraction at `n = 0` and `n = 1` is handled explicitly by
the arithmetic controls `factorial_pred_eq_factorial_of_le_one` (equality at the
empty/singleton boundary) and `factorial_pred_le_factorial` (monotonicity for
all `n`); `factorial_pred_lt_factorial_two` records the first strict gap.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace RootedTouchSum

open scoped BigOperators
open PolymerKPCriterion
open PolymerKPConclusion

variable {Gamma : Type*} [Fintype Gamma]

/-
Boundary control: at cluster size `0` or `1` the two normalizations agree.
Truncated `Nat` subtraction sends both `0 - 1` and `1 - 1` to `0`, so both
denominators are `0! = 1`.
-/
lemma factorial_pred_eq_factorial_of_le_one {n : Nat} (hn : n ≤ 1) :
    Nat.factorial (n - 1) = Nat.factorial n := by
  interval_cases n <;> rfl

/-- Monotonicity control: `(n - 1)! ≤ n!` for every `n`, including the
truncated cases `n = 0` and `n = 1` where `(n - 1)! = 0! = n!`. -/
lemma factorial_pred_le_factorial (n : Nat) :
    Nat.factorial (n - 1) ≤ Nat.factorial n :=
  Nat.factorial_le (Nat.sub_le n 1)

/-- Strict control at the first size where the factorials differ:
`(2 - 1)! = 1 < 2 = 2!`. -/
lemma factorial_pred_lt_factorial_two :
    Nat.factorial (2 - 1) < Nat.factorial 2 := by
  decide +revert

/-- The rooted-touch cluster sum.

Same summation domain, touch predicate, spanning-tree count, and absolute
weight as `boundedTouchSum`, but normalized by `1/(n-1)!` instead of `1/n!`
and guarded only by the touch predicate (the connectedness guard is dropped;
non-connected clusters contribute `0` anyway because their `spanningTreeCount`
vanishes). -/
noncomputable def rootedTouchSum (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (K : Nat) (g : Gamma) : Real := by
  classical
  exact ∑ p : (Σ m : Fin (K + 2), (Fin m.val -> Gamma)),
    if Cluster.Touches S ⟨p.1.val, p.2⟩ g
      then (spanningTreeCount S hdec ⟨p.1.val, p.2⟩ : Real)
             / (Nat.factorial (((⟨p.1.val, p.2⟩ : Cluster S).n) - 1) : Real)
             * (⟨p.1.val, p.2⟩ : Cluster S).absWeight S
      else 0

/-- **R0 normalization bridge.**  Replacing the ordered `1/n!` normalization by
the rooted `1/(n-1)!` normalization can only increase the nonnegative cluster
sum. -/
theorem boundedTouchSum_le_rootedTouchSum
    (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (K : Nat) (g : Gamma) :
    boundedTouchSum S hdec K g <= rootedTouchSum S hdec K g := by
  apply Finset.sum_le_sum; intro p _; split_ifs <;> simp_all +decide [ treeTerm ] ;
  · gcongr;
    · exact Cluster.absWeight_nonneg S _;
    · exact Nat.pred_le _;
  · exact mul_nonneg ( div_nonneg ( Nat.cast_nonneg _ ) ( Nat.cast_nonneg _ ) ) ( Cluster.absWeight_nonneg _ _ )

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.RootedTouchSum.boundedTouchSum_le_rootedTouchSum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms boundedTouchSum_le_rootedTouchSum

end RootedTouchSum
end GateYM
end NullEdge
end Draft
end PhysicsSM

end
