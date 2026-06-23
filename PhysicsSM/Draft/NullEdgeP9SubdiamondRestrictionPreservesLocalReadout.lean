import Mathlib.Tactic

/-!
# P9 subdiamond restriction preserves local readout

This draft module proves the first positive T2 coarse-map theorem in the P9
source-visibility ladder.

Scientific role: the banked T1 witness shows that a diamond-local interval
readout can separate two finite relations whose global degree/interval
histograms agree. The banked negative T2 guardrail shows that a critical
collapse can erase that signal. This module proves the positive Class A spine:
a pre-specified Alexandrov/subdiamond restriction preserves the local readout
inside the chosen subdiamond, because closed diamonds are convex under a
transitive causal relation.

This is finite order theory only. It is source-visibility scaffolding, not a
cosmological-constant theorem.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdgeP9SubdiamondRestrictionPreservesLocalReadout

variable {V : Type} [Fintype V] [DecidableEq V]

/-- Closed diamond `[x,y]`, using a strict/transitive relation plus endpoint
equalities. -/
def inClosedDiamond (R : V -> V -> Prop) [DecidableRel R]
    (x y z : V) : Prop :=
  (z = x \/ R x z) /\ (z = y \/ R z y)

/-- Number of strict interval points between `a` and `b`, measured inside the
observer diamond `[x,y]`. -/
def localIntervalCard (R : V -> V -> Prop) [DecidableRel R]
    (x y a b : V) : Nat := by
  classical
  exact (Finset.univ.filter fun z : V =>
    inClosedDiamond R x y z /\ R a z /\ R z b).card

/-- Histogram of local interval cardinalities for pairs whose endpoints both
lie in the observer diamond `[x,y]`. -/
def localIntervalAbundance (R : V -> V -> Prop) [DecidableRel R]
    (x y : V) (k : Nat) : Nat := by
  classical
  exact (Finset.univ.filter fun p : Prod V V =>
    inClosedDiamond R x y p.1 /\
    inClosedDiamond R x y p.2 /\
    localIntervalCard R x y p.1 p.2 = k).card

/-- The local interval-size signature as a function of the interval cardinality
bucket. -/
def localIntervalSignature (R : V -> V -> Prop) [DecidableRel R]
    (x y : V) : Nat -> Nat :=
  fun k => localIntervalAbundance R x y k

/-- The same histogram as `localIntervalAbundance`, but pair endpoints are
restricted to a subdiamond `[u,v]` while interval points are still measured
inside the parent diamond `[x,y]`. -/
def subdiamondLocalIntervalAbundance (R : V -> V -> Prop) [DecidableRel R]
    (x y u v : V) (k : Nat) : Nat := by
  classical
  exact (Finset.univ.filter fun p : Prod V V =>
    inClosedDiamond R u v p.1 /\
    inClosedDiamond R u v p.2 /\
    localIntervalCard R x y p.1 p.2 = k).card

/-- Transitivity predicate for the finite causal relation. -/
def TransitiveRel (R : V -> V -> Prop) : Prop :=
  forall a b c, R a b -> R b c -> R a c

omit [Fintype V] [DecidableEq V] in
/-- Closed subdiamonds are convex inside a parent closed diamond. -/
theorem subdiamond_convex
    (R : V -> V -> Prop) [DecidableRel R]
    (htrans : TransitiveRel R)
    (x y u v z : V)
    (hu : inClosedDiamond R x y u)
    (hv : inClosedDiamond R x y v)
    (hz : inClosedDiamond R u v z) :
    inClosedDiamond R x y z := by
  cases hu with
  | intro hu_left hu_right =>
  cases hv with
  | intro hv_left hv_right =>
  cases hz with
  | intro hz_left hz_right =>
  exact And.intro
    (by
      cases hz_left with
      | inl hz_eq =>
          subst z
          exact hu_left
      | inr huz =>
          cases hu_left with
          | inl hu_eq =>
              subst u
              exact Or.inr huz
          | inr hxu =>
              exact Or.inr (htrans x u z hxu huz))
    (by
      cases hz_right with
      | inl hz_eq =>
          subst z
          exact hv_right
      | inr hzv =>
          cases hv_right with
          | inl hv_eq =>
              subst v
              exact Or.inr hzv
          | inr hvy =>
              exact Or.inr (htrans z v y hzv hvy))

omit [DecidableEq V] in
/-- If the endpoints `a,b` lie in the subdiamond `[u,v]`, then the strict
interval count between them is the same whether measured in the parent diamond
`[x,y]` or in the subdiamond `[u,v]`. -/
theorem subdiamond_restriction_preserves_ic
    (R : V -> V -> Prop) [DecidableRel R]
    (htrans : TransitiveRel R)
    (x y u v a b : V)
    (hu : inClosedDiamond R x y u)
    (hv : inClosedDiamond R x y v)
    (ha : inClosedDiamond R u v a)
    (hb : inClosedDiamond R u v b) :
    localIntervalCard R x y a b = localIntervalCard R u v a b := by
  classical
  unfold localIntervalCard
  apply congr_arg Finset.card
  apply Finset.ext
  intro z
  simp only [Finset.mem_filter, Finset.mem_univ, true_and]
  exact Iff.intro
    (by
      intro hz
      cases hz with
      | intro _hz_parent hz_tail =>
      cases hz_tail with
      | intro haz hzb =>
      have hz_left : z = u \/ R u z := by
        cases ha.1 with
        | inl ha_eq =>
            subst a
            exact Or.inr haz
        | inr hua =>
            exact Or.inr (htrans u a z hua haz)
      have hz_right : z = v \/ R z v := by
        cases hb.2 with
        | inl hb_eq =>
            subst b
            exact Or.inr hzb
        | inr hbv =>
            exact Or.inr (htrans z b v hzb hbv)
      exact And.intro (And.intro hz_left hz_right) (And.intro haz hzb))
    (by
      intro hz
      cases hz with
      | intro hz_sub hz_tail =>
      cases hz_tail with
      | intro haz hzb =>
      exact And.intro (subdiamond_convex R htrans x y u v z hu hv hz_sub)
        (And.intro haz hzb))

omit [DecidableEq V] in
/-- Histogram-level version: restricting pair endpoints to `[u,v]` and
measuring in the parent diamond gives the same signature as measuring directly
inside `[u,v]`. -/
theorem subdiamond_restriction_preserves_localIntervalAbundance
    (R : V -> V -> Prop) [DecidableRel R]
    (htrans : TransitiveRel R)
    (x y u v : V)
    (hu : inClosedDiamond R x y u)
    (hv : inClosedDiamond R x y v)
    (k : Nat) :
    subdiamondLocalIntervalAbundance R x y u v k =
      localIntervalAbundance R u v k := by
  classical
  unfold subdiamondLocalIntervalAbundance localIntervalAbundance
  apply congr_arg Finset.card
  apply Finset.ext
  intro p
  simp only [Finset.mem_filter, Finset.mem_univ, true_and]
  exact Iff.intro
    (by
      intro hp
      cases hp with
      | intro hp_left hp_tail =>
      cases hp_tail with
      | intro hp_right hcard =>
      have hEq := subdiamond_restriction_preserves_ic
        R htrans x y u v p.1 p.2 hu hv hp_left hp_right
      exact And.intro hp_left (And.intro hp_right (by simpa [hEq] using hcard)))
    (by
      intro hp
      cases hp with
      | intro hp_left hp_tail =>
      cases hp_tail with
      | intro hp_right hcard =>
      have hEq := subdiamond_restriction_preserves_ic
        R htrans x y u v p.1 p.2 hu hv hp_left hp_right
      exact And.intro hp_left (And.intro hp_right (by simpa [hEq] using hcard)))

omit [DecidableEq V] in
/-- Signature-level version of the Class A positive T2 theorem. -/
theorem subdiamond_restriction_preserves_localIntervalSignature
    (R : V -> V -> Prop) [DecidableRel R]
    (htrans : TransitiveRel R)
    (x y u v : V)
    (hu : inClosedDiamond R x y u)
    (hv : inClosedDiamond R x y v) :
    (fun k => subdiamondLocalIntervalAbundance R x y u v k) =
      localIntervalSignature R u v := by
  funext k
  exact subdiamond_restriction_preserves_localIntervalAbundance R htrans x y u v hu hv k

end PhysicsSM.Draft.NullEdgeP9SubdiamondRestrictionPreservesLocalReadout

end
