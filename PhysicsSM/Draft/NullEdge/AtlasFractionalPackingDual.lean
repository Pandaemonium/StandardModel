import Mathlib

/-!
# Fractional dual certificates for bounded-multiplicity atlases

A nonnegative event-weight function is a fractional hitting certificate when
every selected chart core has total weight at least one. If every event belongs
to at most `cap` selected cores, double-counting weighted chart-event
incidences bounds the selected atlas cardinality by `cap` times the total
certificate weight.

This is the kernel-checkable dual side of a future capacity-packing oracle.
An external optimizer may search for rational weights, but a concrete
certificate can be imported and checked by the finite theorem below. The
result does not construct an atlas or prove that any particular candidate
family admits a small certificate.

Claim grade: `M [orig/comp]`. Provenance: program-internal finite weighted
double counting. Proofs were returned by Aristotle project
`32ac6170-b264-46ca-9165-717d3757a5c9` and integrated without statement
changes.
-/

namespace PhysicsSM.Draft.NullEdge.AtlasFractionalPackingDual

variable {Chart Event : Type*}
  [Fintype Chart] [Fintype Event]
  [DecidableEq Chart] [DecidableEq Event]

/-- Number of selected chart cores containing one event. -/
def multiplicity (core : Chart -> Finset Event)
    (selected : Finset Chart) (x : Event) : Nat :=
  (selected.filter fun i => x ∈ core i).card

/-- Total certificate weight carried by one chart core. -/
def coreWeight (core : Chart -> Finset Event)
    (weight : Event -> Real) (i : Chart) : Real :=
  ∑ x ∈ core i, weight x

/-- Weighted chart-core incidences can be counted by charts or by events. -/
theorem sum_coreWeight_eq_sum_multiplicityWeight
    (core : Chart -> Finset Event) (selected : Finset Chart)
    (weight : Event -> Real) :
    (∑ i ∈ selected, coreWeight core weight i) =
      ∑ x, (multiplicity core selected x : Real) * weight x := by
  simp +decide only [coreWeight, multiplicity, Finset.card_filter]
  simp +decide only [Nat.cast_sum, Finset.sum_mul]
  rw [Finset.sum_comm, Finset.sum_congr rfl]
  aesop

/-- A nonnegative fractional hitting certificate gives a universal upper bound
on every selected family obeying the eventwise multiplicity cap. -/
theorem selected_card_le_cap_mul_totalWeight
    (core : Chart -> Finset Event) (selected : Finset Chart)
    (weight : Event -> Real) (cap : Nat)
    (weight_nonnegative : ∀ x, 0 <= weight x)
    (core_weight_one : ∀ i ∈ selected, 1 <= coreWeight core weight i)
    (multiplicity_le_cap : ∀ x, multiplicity core selected x <= cap) :
    (selected.card : Real) <= (cap : Real) * ∑ x, weight x := by
  have h_core : (∑ i ∈ selected, coreWeight core weight i) >= selected.card := by
    exact le_trans (by norm_num) (Finset.sum_le_sum core_weight_one)
  have h_mult : (∑ x, (multiplicity core selected x : Real) * weight x) <=
      ∑ x, cap * weight x := by
    exact Finset.sum_le_sum fun x _ =>
      mul_le_mul_of_nonneg_right (mod_cast multiplicity_le_cap x)
        (weight_nonnegative x)
  simpa only [Finset.mul_sum _ _ _] using le_trans h_core
    (by simpa only [sum_coreWeight_eq_sum_multiplicityWeight] using h_mult)

/-- A certificate checked once on the complete candidate family bounds every
capacity-respecting selected subfamily. This is the direct interface for an
external fractional-packing optimizer: only its concrete weights are imported;
the universal selected-family conclusion is checked by Lean. -/
theorem candidate_certificate_bounds_every_capacitySelection
    (core : Chart -> Finset Event) (candidates selected : Finset Chart)
    (weight : Event -> Real) (cap : Nat)
    (weight_nonnegative : ∀ x, 0 <= weight x)
    (candidate_core_weight_one :
      ∀ i ∈ candidates, 1 <= coreWeight core weight i)
    (selected_subset : selected ⊆ candidates)
    (multiplicity_le_cap : ∀ x, multiplicity core selected x <= cap) :
    (selected.card : Real) <= (cap : Real) * ∑ x, weight x := by
  exact selected_card_le_cap_mul_totalWeight core selected weight cap
    weight_nonnegative
    (fun i hi => candidate_core_weight_one i (selected_subset hi))
    multiplicity_le_cap

private lemma pointMass_coreWeight_one
    (core : Chart -> Finset Event) (i : Chart) (x0 : Event)
    (hx0 : x0 ∈ core i) :
    1 <= coreWeight core (fun x => if x = x0 then 1 else 0) i := by
  exact le_trans (by norm_num [hx0])
    (Finset.single_le_sum (fun x _ => by positivity) hx0)

/-- A common event is the unit-weight boundary certificate: under a uniform
multiplicity cap, any selected family sharing that event has at most `cap`
charts. -/
theorem common_event_capacity_bound
    (core : Chart -> Finset Event) (selected : Finset Chart)
    (cap : Nat) (x0 : Event)
    (common : ∀ i ∈ selected, x0 ∈ core i)
    (multiplicity_le_cap : ∀ x, multiplicity core selected x <= cap) :
    (selected.card : Real) <= cap := by
  simpa using selected_card_le_cap_mul_totalWeight core selected
    (fun x => if x = x0 then 1 else 0) cap
    (by intro x; positivity)
    (by intro i hi; exact pointMass_coreWeight_one core i x0 (common i hi))
    multiplicity_le_cap

end PhysicsSM.Draft.NullEdge.AtlasFractionalPackingDual

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasFractionalPackingDual.sum_coreWeight_eq_sum_multiplicityWeight' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasFractionalPackingDual.sum_coreWeight_eq_sum_multiplicityWeight

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasFractionalPackingDual.selected_card_le_cap_mul_totalWeight' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasFractionalPackingDual.selected_card_le_cap_mul_totalWeight

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasFractionalPackingDual.candidate_certificate_bounds_every_capacitySelection' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasFractionalPackingDual.candidate_certificate_bounds_every_capacitySelection

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasFractionalPackingDual.common_event_capacity_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasFractionalPackingDual.common_event_capacity_bound
