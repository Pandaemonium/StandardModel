import Mathlib.Tactic

/-!
# P9 coarse-map erasure guardrail

This draft module is a T2 guardrail for the P9 source-visibility program. The
T1 diamond-local witness shows that two six-point strict relations can match
global signatures while differing on a local diamond readout. This module adds
an explicit coarse map that collapses the critical swapped vertices and erases
that separator.

Scientific role: this is a failure-control theorem, not a positive
source-visibility theorem. It records that coarse stability is not automatic:
P9 must specify its coarse map before evaluating the observer channel.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail

/-- First six-point strict finite relation from the T1 diamond-local witness. -/
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

/-- Second six-point strict finite relation from the T1 diamond-local witness. -/
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

/--
Coarse map that identifies the two vertices exchanged between the T1 witnesses.
It sends `0,1,2,3,4,5` to `0,1,1,2,3,4`.
-/
def collapseCritical (a : Fin 6) : Fin 5 :=
  ![0, 1, 1, 2, 3, 4] a

/-- Existential image relation induced by a finite coarse map. -/
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

def diamondCard5 (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R]
    (x y : Fin 5) : Nat := by
  classical
  exact (Finset.univ.filter fun z : Fin 5 => inClosedDiamond5 R x y z).card

def localIntervalCard5 (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R]
    (x y a b : Fin 5) : Nat := by
  classical
  exact (Finset.univ.filter fun z : Fin 5 =>
    inClosedDiamond5 R x y z /\ R a z /\ R z b).card

def localIntervalAbundance5 (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R]
    (x y : Fin 5) (k : Nat) : Nat := by
  classical
  exact (Finset.univ.filter fun p : Prod (Fin 5) (Fin 5) =>
    inClosedDiamond5 R x y p.1 /\
    inClosedDiamond5 R x y p.2 /\
    localIntervalCard5 R x y p.1 p.2 = k).card

def localIntervalSignature5 (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R]
    (x y : Fin 5) : Fin 6 -> Nat :=
  fun k => localIntervalAbundance5 R x y k.val

/-- Generic sanity lemma: equal coarse relations have equal local signatures. -/
theorem coarseRel_equal_implies_localSignature_equal
    (R S : Fin 5 -> Fin 5 -> Prop) [DecidableRel R] [DecidableRel S]
    (h : R = S) (x y : Fin 5) :
    localIntervalSignature5 R x y = localIntervalSignature5 S x y := by
  convert rfl
  convert h.symm

theorem collapseCritical_identifies_swapped_vertices :
    collapseCritical 1 = collapseCritical 2 := by
  simp [collapseCritical]

theorem collapseCritical_preserves_endpoints :
    collapseCritical 0 = 0 /\ collapseCritical 4 = 3 := by
  simp [collapseCritical]

theorem collapseCritical_coarseRel_eq :
    coarseRel relA collapseCritical = coarseRel relB collapseCritical := by
  ext x y
  simp [coarseRel, collapseCritical]
  unfold relA relB
  fin_cases x <;> fin_cases y <;> simp +decide

theorem collapseCritical_diamondCard_eq :
    diamondCard5 (coarseRel relA collapseCritical) (collapseCritical 0) (collapseCritical 4) =
      diamondCard5 (coarseRel relB collapseCritical) (collapseCritical 0) (collapseCritical 4) := by
  unfold diamondCard5
  unfold inClosedDiamond5
  simp +decide [collapseCritical_coarseRel_eq]
  convert rfl

theorem collapseCritical_localIntervalSignature_eq :
    localIntervalSignature5 (coarseRel relA collapseCritical) (collapseCritical 0) (collapseCritical 4) =
      localIntervalSignature5 (coarseRel relB collapseCritical) (collapseCritical 0) (collapseCritical 4) := by
  convert coarseRel_equal_implies_localSignature_equal _ _ _ _ _ using 1
  unfold coarseRel
  ext x y
  fin_cases x <;> fin_cases y <;> simp +decide

theorem collapseCritical_erases_T1_at_one :
    localIntervalSignature5 (coarseRel relA collapseCritical) (collapseCritical 0) (collapseCritical 4) 1 =
      localIntervalSignature5 (coarseRel relB collapseCritical) (collapseCritical 0) (collapseCritical 4) 1 := by
  convert congr_arg (fun f : Fin 6 -> Nat => f 1) collapseCritical_localIntervalSignature_eq using 1

end PhysicsSM.Draft.NullEdgeP9CoarseMapErasureGuardrail

end
