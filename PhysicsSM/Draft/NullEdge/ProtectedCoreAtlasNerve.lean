import PhysicsSM.Draft.NullEdge.AtlasCoreBulkContainment

/-!
# Protected-core atlas nerves

This module packages the exact finite topology carried by a labeled family of
protected Alexandrov cores. A chart overlap means literal common core
membership, and a nerve simplex means that all listed charts contain one common
event. The resulting coverage, multiplicity, edge, triangle, and simplex
predicates commute exactly with every isomorphism of finite causal orders.

These definitions are the graph-native input to the growing-atlas gate. They
do not prove that a selected atlas covers the bulk, that its nerve is connected
or bounded in multiplicity, or that transition functions exist. In particular,
no tetrad, spin lift, connection, curvature, or continuum limit is constructed.
Claim grade: `M [orig]` for the finite definitions and covariance identities.

Provenance: program-internal composition of `MarkedDiamond.protectedCore`, its
order-isomorphism covariance, and the independent-bulk containment layer.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ProtectedCoreAtlasNerve

open scoped BigOperators

open AlexandrovAlgebraGerm
open FiniteCausalOrderOperator

variable {V W I : Type*} [Fintype V] [Fintype W]

/-- A finite labeled atlas candidate at one common protected-core threshold. -/
structure ProtectedCoreAtlas (C : FiniteCausalOrder V) (I : Type*) where
  chart : I -> MarkedDiamond C
  threshold : Nat

namespace ProtectedCoreAtlas

/-- Membership in one labeled protected core. -/
def coreAt {C : FiniteCausalOrder V}
    (A : ProtectedCoreAtlas C I) (i : I) (x : V) : Prop :=
  (A.chart i).protectedCore A.threshold x

/-- An event is covered when it belongs to at least one protected core. -/
def Covers {C : FiniteCausalOrder V}
    (A : ProtectedCoreAtlas C I) (x : V) : Prop :=
  exists i, A.coreAt i x

/-- The protected core of one labeled chart as a finite event set. -/
def coreEvents {C : FiniteCausalOrder V}
    (A : ProtectedCoreAtlas C I) (i : I) : Finset V := by
  classical
  exact Finset.univ.filter fun x => A.coreAt i x

/-- Cardinality of one labeled protected core. -/
def coreCard {C : FiniteCausalOrder V}
    (A : ProtectedCoreAtlas C I) (i : I) : Nat :=
  (A.coreEvents i).card

/-- Number of selected protected cores containing one event. -/
def multiplicity {C : FiniteCausalOrder V}
    [Fintype I]
    (A : ProtectedCoreAtlas C I) (x : V) : Nat := by
  classical
  exact (Finset.univ.filter fun i => A.coreAt i x).card

/-- Union of all labeled protected cores. -/
def coveredEvents {C : FiniteCausalOrder V} [Fintype I]
    (A : ProtectedCoreAtlas C I) : Finset V := by
  classical
  exact Finset.univ.biUnion A.coreEvents

/-- Two charts form a nerve edge when their protected cores overlap. -/
def PairOverlap {C : FiniteCausalOrder V}
    (A : ProtectedCoreAtlas C I) (i j : I) : Prop :=
  exists x, A.coreAt i x ∧ A.coreAt j x

/-- Three charts form an occupied nerve triangle when their protected cores
have a genuine common event. -/
def TripleOverlap {C : FiniteCausalOrder V}
    (A : ProtectedCoreAtlas C I) (i j k : I) : Prop :=
  exists x, A.coreAt i x ∧ A.coreAt j x ∧ A.coreAt k x

/-- A finite set of chart labels is a nerve simplex when all of its protected
cores have one common event. -/
def CommonOverlap {C : FiniteCausalOrder V}
    (A : ProtectedCoreAtlas C I) (simplex : Finset I) : Prop :=
  exists x, forall i, i ∈ simplex -> A.coreAt i x

/-- Relabel every chart along an isomorphism of ambient causal orders. -/
def mapOrderIso {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : ProtectedCoreAtlas C I) :
    ProtectedCoreAtlas D I where
  chart i := (A.chart i).map e
  threshold := A.threshold

/-- Coverage is equivalent to positive chart multiplicity. -/
theorem covers_iff_multiplicity_pos {C : FiniteCausalOrder V}
    [Fintype I]
    (A : ProtectedCoreAtlas C I) (x : V) :
    A.Covers x ↔ 0 < A.multiplicity x := by
  classical
  unfold Covers multiplicity
  rw [Finset.card_pos]
  constructor
  · rintro ⟨i, hi⟩
    exact ⟨i, by simp [hi]⟩
  · rintro ⟨i, hi⟩
    exact ⟨i, (Finset.mem_filter.1 hi).2⟩

/-- Double counting chart-event incidences: summing core cardinalities over
charts equals summing chart multiplicities over events. -/
theorem sum_coreCard_eq_sum_multiplicity {C : FiniteCausalOrder V}
    [Fintype I] (A : ProtectedCoreAtlas C I) :
    (∑ i, A.coreCard i) = ∑ x, A.multiplicity x := by
  classical
  unfold coreCard coreEvents multiplicity
  simp only [Finset.card_eq_sum_ones]
  simp_rw [Finset.sum_filter]
  rw [Finset.sum_comm]

/-- A pointwise multiplicity cap bounds the total chart-event incidence. -/
theorem sum_coreCard_le_card_mul_of_multiplicity_le
    {C : FiniteCausalOrder V} [Fintype I]
    (A : ProtectedCoreAtlas C I) (bound : Nat)
    (hbound : forall x, A.multiplicity x <= bound) :
    (∑ i, A.coreCard i) <= Fintype.card V * bound := by
  rw [sum_coreCard_eq_sum_multiplicity]
  calc
    (∑ x, A.multiplicity x) <= ∑ _x : V, bound := by
      exact Finset.sum_le_sum fun x _hx => hbound x
    _ = Fintype.card V * bound := by simp

/-- If every selected core has at least `lower` events, a fixed multiplicity
cap gives an upper budget on atlas cardinality times core size. -/
theorem card_mul_lower_le_eventCard_mul_multiplicityBound
    {C : FiniteCausalOrder V} [Fintype I]
    (A : ProtectedCoreAtlas C I) (lower bound : Nat)
    (hlower : forall i, lower <= A.coreCard i)
    (hbound : forall x, A.multiplicity x <= bound) :
    Fintype.card I * lower <= Fintype.card V * bound := by
  calc
    Fintype.card I * lower = ∑ _i : I, lower := by simp
    _ <= ∑ i, A.coreCard i := by
      exact Finset.sum_le_sum fun i _hi => hlower i
    _ <= Fintype.card V * bound :=
      sum_coreCard_le_card_mul_of_multiplicity_le A bound hbound

/-- The selected union cannot exceed atlas cardinality times a uniform upper
bound on one protected core. -/
theorem coveredEvents_card_le_card_mul
    {C : FiniteCausalOrder V} [Fintype I]
    (A : ProtectedCoreAtlas C I) (upper : Nat)
    (hupper : forall i, A.coreCard i <= upper) :
    A.coveredEvents.card <= Fintype.card I * upper := by
  classical
  unfold coveredEvents
  simpa [coreCard] using
    Finset.card_biUnion_le_card_mul (Finset.univ : Finset I)
      A.coreEvents upper (fun i _hi => hupper i)

/-- **Finite growing-atlas cardinality sandwich.** A demanded union target and
uniform core upper bound force enough charts, while a uniform core lower bound
and eventwise multiplicity cap prevent too many charts. Under two-sided
`N^(3/4)` core-size control and a target proportional to `N`, these two exact
inequalities pin the admissible cardinality scale to `N^(1/4)`. -/
theorem growingAtlas_cardinality_sandwich
    {C : FiniteCausalOrder V} [Fintype I]
    (A : ProtectedCoreAtlas C I)
    (target lower upper bound : Nat)
    (htarget : target <= A.coveredEvents.card)
    (hlower : forall i, lower <= A.coreCard i)
    (hupper : forall i, A.coreCard i <= upper)
    (hbound : forall x, A.multiplicity x <= bound) :
    target <= Fintype.card I * upper ∧
      Fintype.card I * lower <= Fintype.card V * bound := by
  exact ⟨
    htarget.trans (coveredEvents_card_le_card_mul A upper hupper),
    card_mul_lower_le_eventCard_mul_multiplicityBound
      A lower bound hlower hbound⟩

/-- Multiplicity is bounded by the number of chart labels. -/
theorem multiplicity_le_card {C : FiniteCausalOrder V}
    [Fintype I]
    (A : ProtectedCoreAtlas C I) (x : V) :
    A.multiplicity x <= Fintype.card I := by
  classical
  simpa [multiplicity] using
    (Finset.card_filter_le (s := (Finset.univ : Finset I))
      (p := fun i => A.coreAt i x))

/-- Every witnessed simplex has cardinality at most the multiplicity at its
witness event. -/
theorem commonOverlap_card_le_multiplicity {C : FiniteCausalOrder V}
    [Fintype I]
    (A : ProtectedCoreAtlas C I) (simplex : Finset I)
    (hcommon : A.CommonOverlap simplex) :
    exists x, simplex.card <= A.multiplicity x := by
  classical
  rcases hcommon with ⟨x, hx⟩
  refine ⟨x, Finset.card_le_card ?_⟩
  intro i hi
  simp [hx i hi]

/-- If every selected core has one common event, then the multiplicity at that
event is exactly the atlas cardinality. A complete nerve is therefore maximally
overlapping rather than merely connected. -/
theorem fullCommonOverlap_multiplicity_eq_card
    {C : FiniteCausalOrder V} [Fintype I]
    (A : ProtectedCoreAtlas C I)
    (hfull : A.CommonOverlap (Finset.univ : Finset I)) :
    exists x, A.multiplicity x = Fintype.card I := by
  obtain ⟨x, hcard⟩ :=
    commonOverlap_card_le_multiplicity A Finset.univ hfull
  refine ⟨x, le_antisymm (multiplicity_le_card A x) ?_⟩
  simpa using hcard

/-- **Full-nerve bounded-multiplicity obstruction.** If all selected cores
share an event and multiplicity is bounded everywhere by `bound`, then the
atlas itself has at most `bound` charts. Thus a growing atlas with a fixed
multiplicity cap must eventually stop having a full common intersection. -/
theorem fullCommonOverlap_card_le_bound
    {C : FiniteCausalOrder V} [Fintype I]
    (A : ProtectedCoreAtlas C I) (bound : Nat)
    (hfull : A.CommonOverlap (Finset.univ : Finset I))
    (hbound : forall x, A.multiplicity x <= bound) :
    Fintype.card I <= bound := by
  obtain ⟨x, hx⟩ := fullCommonOverlap_multiplicity_eq_card A hfull
  rw [← hx]
  exact hbound x

/-- The nerve is downward closed under taking faces. -/
theorem commonOverlap_anti {C : FiniteCausalOrder V}
    (A : ProtectedCoreAtlas C I) {face simplex : Finset I}
    (hface : face ⊆ simplex) (hcommon : A.CommonOverlap simplex) :
    A.CommonOverlap face := by
  rcases hcommon with ⟨x, hx⟩
  exact ⟨x, fun i hi => hx i (hface hi)⟩

/-- Pair overlap is symmetric. -/
theorem pairOverlap_comm {C : FiniteCausalOrder V}
    (A : ProtectedCoreAtlas C I) (i j : I) :
    A.PairOverlap i j ↔ A.PairOverlap j i := by
  constructor <;> rintro ⟨x, hi, hj⟩ <;> exact ⟨x, hj, hi⟩

/-- Every occupied triangle supplies its first edge. -/
theorem tripleOverlap_pair_left {C : FiniteCausalOrder V}
    (A : ProtectedCoreAtlas C I) {i j k : I}
    (htriangle : A.TripleOverlap i j k) :
    A.PairOverlap i j := by
  rcases htriangle with ⟨x, hi, hj, _hk⟩
  exact ⟨x, hi, hj⟩

/-- Every occupied triangle supplies its diagonal edge. -/
theorem tripleOverlap_pair_diagonal {C : FiniteCausalOrder V}
    (A : ProtectedCoreAtlas C I) {i j k : I}
    (htriangle : A.TripleOverlap i j k) :
    A.PairOverlap i k := by
  rcases htriangle with ⟨x, hi, _hj, hk⟩
  exact ⟨x, hi, hk⟩

/-- Protected-core membership is intrinsic under ambient order relabeling. -/
theorem coreAt_mapOrderIso_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : ProtectedCoreAtlas C I)
    (i : I) (x : V) :
    (A.mapOrderIso e).coreAt i (e.toEquiv x) ↔ A.coreAt i x := by
  exact protectedCore_map_iff e (A.chart i) A.threshold x

/-- Atlas coverage commutes with every ambient order isomorphism. -/
theorem covers_mapOrderIso_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : ProtectedCoreAtlas C I) (x : V) :
    (A.mapOrderIso e).Covers (e.toEquiv x) ↔ A.Covers x := by
  simp only [Covers, coreAt_mapOrderIso_iff]

/-- Chart multiplicity is exactly invariant under ambient order relabeling. -/
theorem multiplicity_mapOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    [Fintype I]
    (e : OrderIso C D) (A : ProtectedCoreAtlas C I) (x : V) :
    (A.mapOrderIso e).multiplicity (e.toEquiv x) = A.multiplicity x := by
  classical
  simp only [multiplicity, coreAt_mapOrderIso_iff]

/-- Nerve edges are exactly invariant under ambient order relabeling. -/
theorem pairOverlap_mapOrderIso_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : ProtectedCoreAtlas C I) (i j : I) :
    (A.mapOrderIso e).PairOverlap i j ↔ A.PairOverlap i j := by
  constructor
  · rintro ⟨y, hi, hj⟩
    let x : V := e.toEquiv.symm y
    refine ⟨x, ?_, ?_⟩
    · exact (coreAt_mapOrderIso_iff e A i x).1 (by simpa [x] using hi)
    · exact (coreAt_mapOrderIso_iff e A j x).1 (by simpa [x] using hj)
  · rintro ⟨x, hi, hj⟩
    exact ⟨e.toEquiv x,
      (coreAt_mapOrderIso_iff e A i x).2 hi,
      (coreAt_mapOrderIso_iff e A j x).2 hj⟩

/-- Occupied nerve triangles are exactly invariant under ambient order
relabeling. -/
theorem tripleOverlap_mapOrderIso_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : ProtectedCoreAtlas C I) (i j k : I) :
    (A.mapOrderIso e).TripleOverlap i j k ↔ A.TripleOverlap i j k := by
  constructor
  · rintro ⟨y, hi, hj, hk⟩
    let x : V := e.toEquiv.symm y
    refine ⟨x, ?_, ?_, ?_⟩
    · exact (coreAt_mapOrderIso_iff e A i x).1 (by simpa [x] using hi)
    · exact (coreAt_mapOrderIso_iff e A j x).1 (by simpa [x] using hj)
    · exact (coreAt_mapOrderIso_iff e A k x).1 (by simpa [x] using hk)
  · rintro ⟨x, hi, hj, hk⟩
    exact ⟨e.toEquiv x,
      (coreAt_mapOrderIso_iff e A i x).2 hi,
      (coreAt_mapOrderIso_iff e A j x).2 hj,
      (coreAt_mapOrderIso_iff e A k x).2 hk⟩

/-- Every finite nerve simplex is exactly invariant under ambient order
relabeling. -/
theorem commonOverlap_mapOrderIso_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : ProtectedCoreAtlas C I)
    (simplex : Finset I) :
    (A.mapOrderIso e).CommonOverlap simplex ↔ A.CommonOverlap simplex := by
  constructor
  · rintro ⟨y, hy⟩
    let x : V := e.toEquiv.symm y
    refine ⟨x, fun i hi => ?_⟩
    exact (coreAt_mapOrderIso_iff e A i x).1 (by
      simpa [x] using hy i hi)
  · rintro ⟨x, hx⟩
    exact ⟨e.toEquiv x, fun i hi =>
      (coreAt_mapOrderIso_iff e A i x).2 (hx i hi)⟩

end ProtectedCoreAtlas

end PhysicsSM.Draft.NullEdge.ProtectedCoreAtlasNerve

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ProtectedCoreAtlasNerve.ProtectedCoreAtlas.commonOverlap_anti' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProtectedCoreAtlasNerve.ProtectedCoreAtlas.commonOverlap_anti

/-- info: 'PhysicsSM.Draft.NullEdge.ProtectedCoreAtlasNerve.ProtectedCoreAtlas.fullCommonOverlap_card_le_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProtectedCoreAtlasNerve.ProtectedCoreAtlas.fullCommonOverlap_card_le_bound

/-- info: 'PhysicsSM.Draft.NullEdge.ProtectedCoreAtlasNerve.ProtectedCoreAtlas.growingAtlas_cardinality_sandwich' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProtectedCoreAtlasNerve.ProtectedCoreAtlas.growingAtlas_cardinality_sandwich

/-- info: 'PhysicsSM.Draft.NullEdge.ProtectedCoreAtlasNerve.ProtectedCoreAtlas.multiplicity_mapOrderIso' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProtectedCoreAtlasNerve.ProtectedCoreAtlas.multiplicity_mapOrderIso

/-- info: 'PhysicsSM.Draft.NullEdge.ProtectedCoreAtlasNerve.ProtectedCoreAtlas.commonOverlap_mapOrderIso_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProtectedCoreAtlasNerve.ProtectedCoreAtlas.commonOverlap_mapOrderIso_iff
