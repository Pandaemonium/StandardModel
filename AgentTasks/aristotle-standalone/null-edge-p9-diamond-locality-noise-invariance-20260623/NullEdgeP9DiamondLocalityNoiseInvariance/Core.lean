import Mathlib.Tactic

/-!
# P9 diamond-locality / noise-invariance lemma

This focused file states a generic finite locality theorem for the P9
diamond-local observer channel. If two finite relations have the same closed
diamond and agree on all relation entries among vertices in that diamond, then
the local interval-size signature of that diamond is unchanged.

Scientific role: this is the clean T3 spine. It says geometry-blind relation
noise outside the measured diamond cannot affect the frozen local interval
readout, provided the diamond membership and internal relation data are
unchanged.
-/

noncomputable section

open scoped BigOperators

namespace NullEdgeP9DiamondLocalityNoiseInvariance

variable {V : Type} [Fintype V] [DecidableEq V]

def inClosedDiamond (R : V -> V -> Prop) [DecidableRel R]
    (x y z : V) : Prop :=
  (z = x \/ R x z) /\ (z = y \/ R z y)

def localIntervalCard (R : V -> V -> Prop) [DecidableRel R]
    (x y a b : V) : Nat := by
  classical
  exact (Finset.univ.filter fun z : V =>
    inClosedDiamond R x y z /\ R a z /\ R z b).card

def localIntervalAbundance (R : V -> V -> Prop) [DecidableRel R]
    (x y : V) (k : Nat) : Nat := by
  classical
  exact (Finset.univ.filter fun p : Prod V V =>
    inClosedDiamond R x y p.1 /\
    inClosedDiamond R x y p.2 /\
    localIntervalCard R x y p.1 p.2 = k).card

def localIntervalSignature (R : V -> V -> Prop) [DecidableRel R]
    (x y : V) : Nat -> Nat :=
  fun k => localIntervalAbundance R x y k

theorem localIntervalCard_eq_of_diamond_local_agreement
    (R S : V -> V -> Prop) [DecidableRel R] [DecidableRel S]
    (x y a b : V)
    (hD : forall z, inClosedDiamond R x y z <-> inClosedDiamond S x y z)
    (ha : inClosedDiamond R x y a)
    (hb : inClosedDiamond R x y b)
    (hRel : forall u v,
      inClosedDiamond R x y u ->
      inClosedDiamond R x y v ->
      (R u v <-> S u v)) :
    localIntervalCard R x y a b = localIntervalCard S x y a b := by
  sorry

theorem localIntervalAbundance_eq_of_diamond_local_agreement
    (R S : V -> V -> Prop) [DecidableRel R] [DecidableRel S]
    (x y : V) (k : Nat)
    (hD : forall z, inClosedDiamond R x y z <-> inClosedDiamond S x y z)
    (hRel : forall u v,
      inClosedDiamond R x y u ->
      inClosedDiamond R x y v ->
      (R u v <-> S u v)) :
    localIntervalAbundance R x y k = localIntervalAbundance S x y k := by
  sorry

theorem localIntervalSignature_eq_of_diamond_local_agreement
    (R S : V -> V -> Prop) [DecidableRel R] [DecidableRel S]
    (x y : V)
    (hD : forall z, inClosedDiamond R x y z <-> inClosedDiamond S x y z)
    (hRel : forall u v,
      inClosedDiamond R x y u ->
      inClosedDiamond R x y v ->
      (R u v <-> S u v)) :
    localIntervalSignature R x y = localIntervalSignature S x y := by
  sorry

end NullEdgeP9DiamondLocalityNoiseInvariance

end
