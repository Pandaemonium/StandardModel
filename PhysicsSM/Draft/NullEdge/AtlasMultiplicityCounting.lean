import Mathlib

/-!
# Atlas multiplicity double counting

This module isolates the finite incidence-counting statements needed to
interpret a bounded-overlap atlas. The chart family is an arbitrary family of
finite subsets. Double counting turns a pointwise multiplicity cap into a
total chart-volume bound and then into a selected-cardinality constraint.

No causal order, continuum limit, or geometric conclusion is assumed. The
protected Alexandrov-core specialization lives in
`ProtectedCoreAtlasNerve.lean`.

Provenance: program-internal finite set-system formalization. Proofs were
returned by Aristotle project `373f6045-f479-454c-9ba8-4ae8a85e8789` and
checked locally without statement changes.
-/

namespace PhysicsSM.Draft.NullEdge.AtlasMultiplicityCounting

variable {Event Chart : Type*}
  [DecidableEq Event] [DecidableEq Chart]

/-- Events covered by at least one selected chart. -/
def covered (core : Chart -> Finset Event) (selected : Finset Chart) :
    Finset Event :=
  selected.biUnion core

/-- Number of selected charts containing an event. -/
def multiplicity (core : Chart -> Finset Event) (selected : Finset Chart)
    (x : Event) : Nat :=
  (selected.filter fun i => x ∈ core i).card

/-- Double-count chart-event incidences by charts or by covered events. -/
theorem sum_chart_card_eq_sum_multiplicity
    (core : Chart -> Finset Event) (selected : Finset Chart) :
    (∑ i ∈ selected, (core i).card) =
      ∑ x ∈ covered core selected, multiplicity core selected x := by
  simp +decide only [covered]
  simp +decide only [Finset.card_eq_sum_ones, multiplicity]
  rw [Finset.sum_sigma', Finset.sum_sigma']
  refine' Finset.sum_bij (fun x _ => ⟨x.2, x.1⟩) _ _ _ _ <;> aesop

/-- A pointwise overlap cap bounds the total selected chart volume by the cap
times the union volume. -/
theorem sum_chart_card_le_bound_mul_covered_card
    (core : Chart -> Finset Event) (selected : Finset Chart) (bound : Nat)
    (hbound : ∀ x ∈ covered core selected,
      multiplicity core selected x <= bound) :
    (∑ i ∈ selected, (core i).card) <=
      bound * (covered core selected).card := by
  rw [sum_chart_card_eq_sum_multiplicity core selected]
  simpa [mul_comm] using Finset.sum_le_sum hbound

/-- If every selected chart contains at least `minimum` events, bounded
multiplicity forces a corresponding lower bound on union capacity. -/
theorem selected_card_mul_minimum_le_bound_mul_covered_card
    (core : Chart -> Finset Event) (selected : Finset Chart)
    (minimum bound : Nat)
    (hminimum : ∀ i ∈ selected, minimum <= (core i).card)
    (hbound : ∀ x ∈ covered core selected,
      multiplicity core selected x <= bound) :
    selected.card * minimum <= bound * (covered core selected).card := by
  refine le_trans ?_
    (sum_chart_card_le_bound_mul_covered_card core selected bound hbound)
  simpa using Finset.sum_le_sum hminimum

/-- Boundary control: pairwise disjoint selected charts have multiplicity at
most one everywhere. -/
theorem multiplicity_le_one_of_pairwise_disjoint
    (core : Chart -> Finset Event) (selected : Finset Chart)
    (hdisjoint : (selected : Set Chart).PairwiseDisjoint core) (x : Event) :
    multiplicity core selected x <= 1 := by
  refine Finset.card_le_one.mpr ?_
  simp +zetaDelta at *
  exact fun a ha hx b hb hx' => Classical.not_not.1 fun hab =>
    Finset.disjoint_left.1 (hdisjoint ha hb hab) hx hx'

end PhysicsSM.Draft.NullEdge.AtlasMultiplicityCounting

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasMultiplicityCounting.sum_chart_card_eq_sum_multiplicity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasMultiplicityCounting.sum_chart_card_eq_sum_multiplicity

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasMultiplicityCounting.sum_chart_card_le_bound_mul_covered_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasMultiplicityCounting.sum_chart_card_le_bound_mul_covered_card

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasMultiplicityCounting.selected_card_mul_minimum_le_bound_mul_covered_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasMultiplicityCounting.selected_card_mul_minimum_le_bound_mul_covered_card

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasMultiplicityCounting.multiplicity_le_one_of_pairwise_disjoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasMultiplicityCounting.multiplicity_le_one_of_pairwise_disjoint
