import Mathlib.Tactic

/-!
# P9 intrinsic order-observable invariance

This module integrates Aristotle project
`e71998cf-0c45-4dba-8677-639cf47576af`.

Scientific role: after the P9 block-aliasing and offset-window guardrails, the
program needs observables that are intrinsic to the finite causal order rather
than artifacts of a grid offset or vertex labeling. This module proves that two
basic causal-set graph observables, interval abundance and out-degree
histograms, are invariant under finite relabeling.
-/

noncomputable section

open scoped BigOperators

set_option linter.unusedSectionVars false
set_option linter.unusedDecidableInType false

namespace PhysicsSM.Draft.NullEdgeP9IntrinsicOrderObservables

variable {A B : Type} [Fintype A] [Fintype B] [DecidableEq A] [DecidableEq B]

/-- Relabel a relation along an equivalence of finite vertex sets. -/
def transportRel (e : Equiv A B) (R : A -> A -> Prop) : B -> B -> Prop :=
  fun x y => R (e.symm x) (e.symm y)

/-- Number of elements in the causal interval from `a` to `b`. -/
def intervalCard (R : A -> A -> Prop) [DecidableRel R] (a b : A) : Nat :=
  (Finset.univ.filter (fun x : A => R a x /\ R x b)).card

/-- Number of ordered pairs whose interval has cardinality `k`. -/
def intervalAbundance (R : A -> A -> Prop) [DecidableRel R] (k : Nat) : Nat :=
  (Finset.univ.filter (fun p : Prod A A => intervalCard R p.1 p.2 = k)).card

/-- Out-degree of a point in the directed relation. -/
def outDegree (R : A -> A -> Prop) [DecidableRel R] (a : A) : Nat :=
  (Finset.univ.filter (fun x : A => R a x)).card

/-- Histogram of out-degrees. -/
def outDegreeHistogram (R : A -> A -> Prop) [DecidableRel R] (k : Nat) : Nat :=
  (Finset.univ.filter (fun a : A => outDegree R a = k)).card

/-- Interval cardinality is invariant under finite relabeling. -/
theorem intervalCard_transportRel
    (e : Equiv A B) (R : A -> A -> Prop)
    [DecidableRel R] [DecidableRel (transportRel e R)] (a b : A) :
    intervalCard (transportRel e R) (e a) (e b) = intervalCard R a b := by
  simp +decide [intervalCard, transportRel]
  rw [Finset.card_filter, Finset.card_filter]
  conv_rhs => rw [<- Equiv.sum_comp e.symm]

/-- Interval abundance is invariant under finite relabeling. -/
theorem intervalAbundance_transportRel
    (e : Equiv A B) (R : A -> A -> Prop)
    [DecidableRel R] [DecidableRel (transportRel e R)] (k : Nat) :
    intervalAbundance (transportRel e R) k = intervalAbundance R k := by
  refine' Finset.card_bij (fun p _hp => (e.symm p.1, e.symm p.2)) _ _ _
  next =>
    intro p hp
    have := intervalCard_transportRel e R (e.symm p.1) (e.symm p.2)
    aesop
  next =>
    aesop
  next =>
    simp +zetaDelta at *
    exact fun a b h =>
      ⟨e a, e b, by simpa [intervalCard_transportRel] using h, by simp +decide,
        by simp +decide⟩

/-- Out-degree is invariant under finite relabeling. -/
theorem outDegree_transportRel
    (e : Equiv A B) (R : A -> A -> Prop)
    [DecidableRel R] [DecidableRel (transportRel e R)] (a : A) :
    outDegree (transportRel e R) (e a) = outDegree R a := by
  convert Finset.card_image_iff.mpr _
  convert rfl
  convert Finset.card_image_of_injective _ e.injective
  next =>
    refine' Finset.card_bij (fun x _hx => e.symm x) _ _ _ <;>
      simp +decide [transportRel]
    exact fun b hb => ⟨e b, by simpa using hb, by simp +decide⟩
  next =>
    exact e.injective.injOn

/-- The out-degree histogram is invariant under finite relabeling. -/
theorem outDegreeHistogram_transportRel
    (e : Equiv A B) (R : A -> A -> Prop)
    [DecidableRel R] [DecidableRel (transportRel e R)] (k : Nat) :
    outDegreeHistogram (transportRel e R) k = outDegreeHistogram R k := by
  refine' Finset.card_bij (fun x _hx => e.symm x) _ _ _ <;>
    simp +decide [Finset.mem_filter, outDegree]
  next =>
    intro b hb
    convert hb using 1
    rw [Finset.card_filter]
    rw [Finset.card_filter]
    rw [<- Finset.sum_bij (fun x _ => e.symm x)]
    next =>
      aesop
    next =>
      aesop
    next =>
      exact fun x _ => ⟨e x, Finset.mem_univ _, e.symm_apply_apply x⟩
    next =>
      unfold transportRel
      aesop
  next =>
    refine' fun b hb => ⟨e b, _, _⟩ <;> simp_all +decide [transportRel]
    convert hb using 1
    rw [Finset.card_filter, Finset.card_filter]
    conv_rhs => rw [<- Equiv.sum_comp e.symm]

end PhysicsSM.Draft.NullEdgeP9IntrinsicOrderObservables

end
