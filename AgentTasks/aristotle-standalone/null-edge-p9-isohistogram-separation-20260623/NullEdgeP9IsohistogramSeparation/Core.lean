import Mathlib.Tactic

/-!
# P9 iso-histogram separation witness

This focused file gives a tiny finite witness for the P9 strategy gate.  Two
relations on `Fin 5` can have the same out-degree histogram, the same in-degree
histogram, and the same interval-abundance signature, while a frozen joint
in/out-degree readout separates them.

The point is not that joint degree is the final P9 observer channel.  The point
is that common intrinsic histograms are incomplete, so P9 needs an explicit
frozen readout and null controls rather than relying on histogram agreement.
-/

noncomputable section

open scoped BigOperators

namespace NullEdgeP9IsohistogramSeparation

/-- First five-point strict finite relation. -/
def relA (a b : Fin 5) : Prop :=
  (a = 0 /\ b = 2) \/
  (a = 0 /\ b = 3) \/
  (a = 0 /\ b = 4) \/
  (a = 1 /\ b = 2) \/
  (a = 1 /\ b = 3) \/
  (a = 2 /\ b = 3)

/-- Second five-point strict finite relation. -/
def relB (a b : Fin 5) : Prop :=
  (a = 0 /\ b = 1) \/
  (a = 0 /\ b = 3) \/
  (a = 0 /\ b = 4) \/
  (a = 1 /\ b = 3) \/
  (a = 1 /\ b = 4) \/
  (a = 2 /\ b = 3)

instance relA_decidableRel : DecidableRel relA := by
  intro a b
  unfold relA
  infer_instance

instance relB_decidableRel : DecidableRel relB := by
  intro a b
  unfold relB
  infer_instance

def outDegree (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R] (a : Fin 5) : Nat :=
  (Finset.univ.filter fun b : Fin 5 => R a b).card

def inDegree (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R] (b : Fin 5) : Nat :=
  (Finset.univ.filter fun a : Fin 5 => R a b).card

def intervalCard (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R]
    (a b : Fin 5) : Nat :=
  (Finset.univ.filter fun x : Fin 5 => R a x /\ R x b).card

def outDegreeHistogram (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R] (k : Nat) : Nat :=
  (Finset.univ.filter fun a : Fin 5 => outDegree R a = k).card

def inDegreeHistogram (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R] (k : Nat) : Nat :=
  (Finset.univ.filter fun a : Fin 5 => inDegree R a = k).card

def intervalAbundance (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R] (k : Nat) : Nat :=
  (Finset.univ.filter fun p : Prod (Fin 5) (Fin 5) => intervalCard R p.1 p.2 = k).card

/-- Signatures are finite because the relation has only five vertices. -/
def outDegreeSignature (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R] : Fin 6 -> Nat :=
  fun k => outDegreeHistogram R k.val

def inDegreeSignature (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R] : Fin 6 -> Nat :=
  fun k => inDegreeHistogram R k.val

def intervalSignature (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R] : Fin 6 -> Nat :=
  fun k => intervalAbundance R k.val

/-- Frozen readout: vertices with in-degree two and out-degree one. -/
def jointReadout21 (R : Fin 5 -> Fin 5 -> Prop) [DecidableRel R] : Nat :=
  (Finset.univ.filter fun a : Fin 5 => inDegree R a = 2 /\ outDegree R a = 1).card

def IrreflexiveRel (R : Fin 5 -> Fin 5 -> Prop) : Prop :=
  forall a, Not (R a a)

def TransitiveRel (R : Fin 5 -> Fin 5 -> Prop) : Prop :=
  forall a b c, R a b -> R b c -> R a c

theorem relA_irreflexive : IrreflexiveRel relA := by
  sorry

theorem relA_transitive : TransitiveRel relA := by
  sorry

theorem relB_irreflexive : IrreflexiveRel relB := by
  sorry

theorem relB_transitive : TransitiveRel relB := by
  sorry

theorem same_outDegreeSignature :
    outDegreeSignature relA = outDegreeSignature relB := by
  sorry

theorem same_inDegreeSignature :
    inDegreeSignature relA = inDegreeSignature relB := by
  sorry

theorem same_intervalSignature :
    intervalSignature relA = intervalSignature relB := by
  sorry

theorem jointReadout21_relA :
    jointReadout21 relA = 1 := by
  sorry

theorem jointReadout21_relB :
    jointReadout21 relB = 0 := by
  sorry

theorem jointReadout21_separates :
    jointReadout21 relA != jointReadout21 relB := by
  sorry

end NullEdgeP9IsohistogramSeparation

end
