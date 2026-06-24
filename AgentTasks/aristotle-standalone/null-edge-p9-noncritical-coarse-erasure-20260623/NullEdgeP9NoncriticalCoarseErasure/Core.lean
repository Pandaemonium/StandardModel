import Mathlib.Tactic

/-!
# P9 noncritical coarse-erasure counterexample

Physics context: the P9 source-visibility program has a six-point witness with
a diamond-local operational gap, and a known critical-collapse coarse map that
erases that gap by identifying the two swapped vertices. A tempting
strengthening says: erasure happens exactly when the coarse map collapses the
critical swapped pair. Finite search found that this is too strong.

This focused file asks Aristotle to prove one explicit counterexample: the
surjective map `0,1,2,3,4,5 |-> 0,1,2,3,3,4` keeps the critical pair `1,2`
distinct but still erases the bucket-one local interval signature after taking
the induced coarse relations.
-/

noncomputable section

namespace NullEdgeP9NoncriticalCoarseErasure

def relA (a b : Fin 6) : Prop :=
  (a = 0 /\ b = 1) \/
  (a = 0 /\ b = 3) \/
  (a = 0 /\ b = 4) \/
  (a = 0 /\ b = 5) \/
  (a = 1 /\ b = 4) \/
  (a = 1 /\ b = 5) \/
  (a = 2 /\ b = 3) \/
  (a = 2 /\ b = 4) \/
  (a = 3 /\ b = 4)

def relB (a b : Fin 6) : Prop :=
  (a = 0 /\ b = 2) \/
  (a = 0 /\ b = 3) \/
  (a = 0 /\ b = 4) \/
  (a = 0 /\ b = 5) \/
  (a = 1 /\ b = 4) \/
  (a = 1 /\ b = 5) \/
  (a = 2 /\ b = 3) \/
  (a = 2 /\ b = 4) \/
  (a = 3 /\ b = 4)

instance relA_decidableRel : DecidableRel relA := by
  intro a b
  unfold relA
  infer_instance

instance relB_decidableRel : DecidableRel relB := by
  intro a b
  unfold relB
  infer_instance

def nonCriticalErasingMap (a : Fin 6) : Fin 5 :=
  ![0, 1, 2, 3, 3, 4] a

def coarseRel (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R]
    (c : Fin 6 -> Fin 5) (x y : Fin 5) : Prop :=
  exists a b : Fin 6, c a = x /\ c b = y /\ R a b

instance coarseRel_decidableRel (R : Fin 6 -> Fin 6 -> Prop) [DecidableRel R]
    (c : Fin 6 -> Fin 5) : DecidableRel (coarseRel R c) := by
  intro x y
  unfold coarseRel
  infer_instance

def inClosedDiamond5 (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R]
    (x y z : Fin 5) : Prop :=
  (z = x \/ R x z) /\ (z = y \/ R z y)

instance inClosedDiamond5_decidable (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R]
    (x y z : Fin 5) : Decidable (inClosedDiamond5 R x y z) := by
  unfold inClosedDiamond5
  infer_instance

def localIntervalCard5 (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R]
    (x y a b : Fin 5) : Nat :=
  (Finset.univ.filter fun z : Fin 5 =>
    inClosedDiamond5 R x y z /\ R a z /\ R z b).card

def localIntervalAbundance5 (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R]
    (x y : Fin 5) (k : Nat) : Nat :=
  (Finset.univ.filter fun p : Prod (Fin 5) (Fin 5) =>
    inClosedDiamond5 R x y p.1 /\
    inClosedDiamond5 R x y p.2 /\
    localIntervalCard5 R x y p.1 p.2 = k).card

def localIntervalSignature5 (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R]
    (x y : Fin 5) : Fin 6 -> Nat :=
  fun k => localIntervalAbundance5 R x y k.val

theorem nonCriticalErasingMap_surjective :
    Function.Surjective nonCriticalErasingMap := by
  intro y
  fin_cases y
  · exact Exists.intro 0 (by simp [nonCriticalErasingMap])
  · exact Exists.intro 1 (by simp [nonCriticalErasingMap])
  · exact Exists.intro 2 (by simp [nonCriticalErasingMap])
  · exact Exists.intro 3 (by simp [nonCriticalErasingMap])
  · exact Exists.intro 5 (by simp [nonCriticalErasingMap])

theorem nonCriticalErasingMap_preserves_critical_pair_distinct :
    nonCriticalErasingMap 1 != nonCriticalErasingMap 2 := by
  simp [nonCriticalErasingMap]

theorem nonCriticalErasingMap_preserves_endpoints :
    nonCriticalErasingMap 0 = 0 /\ nonCriticalErasingMap 4 = 3 := by
  simp [nonCriticalErasingMap]

/--
Main target: the noncritical map keeps vertices `1` and `2` distinct but erases
the bucket-one operational separator after taking induced coarse relations.
-/
theorem nonCriticalErasingMap_erases_bucket_one :
    localIntervalSignature5 (coarseRel relA nonCriticalErasingMap)
        (nonCriticalErasingMap 0) (nonCriticalErasingMap 4) 1 =
      localIntervalSignature5 (coarseRel relB nonCriticalErasingMap)
        (nonCriticalErasingMap 0) (nonCriticalErasingMap 4) 1 := by
  decide

theorem nonCriticalErasingMap_is_noncritical_erasure :
    nonCriticalErasingMap 1 != nonCriticalErasingMap 2 /\
      localIntervalSignature5 (coarseRel relA nonCriticalErasingMap)
          (nonCriticalErasingMap 0) (nonCriticalErasingMap 4) 1 =
        localIntervalSignature5 (coarseRel relB nonCriticalErasingMap)
          (nonCriticalErasingMap 0) (nonCriticalErasingMap 4) 1 := by
  exact And.intro nonCriticalErasingMap_preserves_critical_pair_distinct
    nonCriticalErasingMap_erases_bucket_one

end NullEdgeP9NoncriticalCoarseErasure

end
