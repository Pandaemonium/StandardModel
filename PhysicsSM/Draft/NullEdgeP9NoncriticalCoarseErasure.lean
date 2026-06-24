import Mathlib.Tactic

/-!
# P9 noncritical coarse-erasure counterexample

This draft module records a negative result for an overly strong P9 coarse-map
claim. The banked critical-collapse map erases the T1 operational separator by
identifying the two swapped vertices. A tempting strengthening is:

```text
coarse erasure iff the coarse map collapses the critical swapped pair.
```

That statement is false for unrestricted surjective coarse maps. The explicit
surjective map below keeps the critical pair distinct, but its induced coarse
relations still have equal bucket-one local interval signatures on the coarse
observer diamond. This is a useful demotion guardrail: P9 coarse stability needs
a named admissible class, not unrestricted surjective-map universality.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9NoncriticalCoarseErasure

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
  next => exact Exists.intro 0 (by simp [nonCriticalErasingMap])
  next => exact Exists.intro 1 (by simp [nonCriticalErasingMap])
  next => exact Exists.intro 2 (by simp [nonCriticalErasingMap])
  next => exact Exists.intro 3 (by simp [nonCriticalErasingMap])
  next => exact Exists.intro 5 (by simp [nonCriticalErasingMap])

theorem nonCriticalErasingMap_preserves_critical_pair_distinct :
    nonCriticalErasingMap 1 != nonCriticalErasingMap 2 := by
  simp [nonCriticalErasingMap]

theorem nonCriticalErasingMap_preserves_endpoints :
    nonCriticalErasingMap 0 = 0 /\ nonCriticalErasingMap 4 = 3 := by
  simp [nonCriticalErasingMap]

/--
The noncritical map keeps vertices `1` and `2` distinct but erases the
bucket-one operational separator after taking induced coarse relations.
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

end PhysicsSM.Draft.NullEdgeP9NoncriticalCoarseErasure

end
