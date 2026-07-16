import PhysicsSM.Draft.NullEdge.AlexandrovAlgebraGerm
import Mathlib.Data.Finset.Max

/-!
# Canonical ensembles of separated Alexandrov germs

The regional causal-operator audit shows that selecting several deepest rows
from one graph does not produce local random variables: the selector and every
row read global count data.  This module supplies a finite, bare-order
alternative.  A marked Alexandrov diamond carries its two endpoints and its
strict interior.  A separated packing consists of eligible diamonds whose
closed carriers are pairwise vertex-disjoint.

A graph automorphism need not fix any single maximum packing.  Accordingly,
the canonical object is the finite ensemble of all maximum packings, not a
chosen representative.  The ensemble is nonempty and is transported exactly
by every finite-order isomorphism.  Its cardinality and uniform averages of
equivariant observables are therefore relabeling invariant.

These are finite combinatorial statements.  They do not prove probabilistic
independence of germ scores, existence of a large packing in a refinement
family, stabilization, covariance decay, or continuum convergence.  Those
claims require a stochastic model and an operator whose complete information
flow is internal to each closed carrier.

Claim grade: `M [orig]` for the finite definitions and equivariance theorems.
Provenance: program-internal response to the A44 regional covariance audit,
built on `AlexandrovAlgebraGerm.lean`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.AlexandrovGermPacking

open FiniteCausalOrderOperator
open AlexandrovAlgebraGerm

variable {V W : Type*} [Fintype V] [Fintype W]

/-! ## Transport of marked diamonds -/

/-- Reverse an isomorphism of finite causal orders. -/
def reverseOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) : OrderIso D C where
  toEquiv := e.toEquiv.symm
  map_before_iff x y := by
    simpa using
      (e.map_before_iff (e.toEquiv.symm x) (e.toEquiv.symm y)).symm

/-- Marked diamonds are equal when their two endpoints are equal; the causal
order proof fields are propositionally irrelevant. -/
theorem markedDiamond_ext
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C)
    (hbottom : A.bottom = B.bottom) (htop : A.top = B.top) : A = B := by
  cases A with
  | mk bottomA topA hA =>
      cases B with
      | mk bottomB topB hB =>
          simp only at hbottom htop
          subst bottomB
          subst topB
          rfl

/-- Marked diamonds on isomorphic finite orders are equivalent. -/
def markedDiamondEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) : MarkedDiamond C ≃ MarkedDiamond D where
  toFun A := A.map e
  invFun A := A.map (reverseOrderIso e)
  left_inv A := by
    apply markedDiamond_ext
    · simp [MarkedDiamond.map, reverseOrderIso]
    · simp [MarkedDiamond.map, reverseOrderIso]
  right_inv A := by
    apply markedDiamond_ext
    · simp [MarkedDiamond.map, reverseOrderIso]
    · simp [MarkedDiamond.map, reverseOrderIso]

/-- Reversing the order isomorphism gives the inverse marked-diamond
equivalence. -/
theorem markedDiamondEquiv_reverse
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) :
    markedDiamondEquiv (reverseOrderIso e) = (markedDiamondEquiv e).symm := by
  apply Equiv.ext
  intro A
  apply markedDiamond_ext
  · rfl
  · rfl

/-! ## Closed carriers and eligibility -/

/-- Marked diamonds form a finite type because their endpoint pairs do. -/
instance markedDiamondFinite {C : FiniteCausalOrder V} :
    Finite (MarkedDiamond C) :=
  Finite.of_injective (fun A => (A.bottom, A.top)) (by
    intro A B h
    apply markedDiamond_ext
    · exact congrArg Prod.fst h
    · exact congrArg Prod.snd h)

noncomputable instance markedDiamondFintype {C : FiniteCausalOrder V} :
    Fintype (MarkedDiamond C) :=
  Fintype.ofFinite _

/-- The closed finite carrier of a marked diamond: both endpoints and every
event in its strict Alexandrov interior. -/
def inClosed
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) (x : V) : Prop :=
  x = A.bottom ∨ x = A.top ∨ A.inOpen x

instance decidableInClosed
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) (x : V) :
    Decidable (inClosed A x) := by
  classical
  unfold inClosed
  infer_instance

/-- Closed-carrier membership is intrinsic under order isomorphisms. -/
theorem inClosed_map_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C) (x : V) :
    inClosed (A.map e) (e.toEquiv x) ↔ inClosed A x := by
  constructor
  · intro h
    rcases h with hbottom | htop | hopen
    · left
      exact e.toEquiv.injective hbottom
    · right
      left
      exact e.toEquiv.injective htop
    · right
      right
      exact (inOpen_map_iff e A x).1 hopen
  · intro h
    rcases h with hbottom | htop | hopen
    · left
      exact congrArg e.toEquiv hbottom
    · right
      left
      exact congrArg e.toEquiv htop
    · right
      right
      exact (inOpen_map_iff e A x).2 hopen

/-- A count threshold excluding diamonds whose strict interiors are too
small for the intended local operator. -/
def Eligible
    {C : FiniteCausalOrder V} (minimumInteriorCount : Nat)
    (A : MarkedDiamond C) : Prop :=
  minimumInteriorCount ≤ C.openIntervalCount A.bottom A.top

instance decidableEligible
    {C : FiniteCausalOrder V} (minimumInteriorCount : Nat)
    (A : MarkedDiamond C) : Decidable (Eligible minimumInteriorCount A) := by
  unfold Eligible
  infer_instance

/-- Count eligibility is intrinsic under order isomorphisms. -/
theorem eligible_map_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (minimumInteriorCount : Nat)
    (A : MarkedDiamond C) :
    Eligible minimumInteriorCount (A.map e) ↔
      Eligible minimumInteriorCount A := by
  simp [Eligible, MarkedDiamond.map,
    e.openIntervalCount_eq]

/-- Two outer germs are separated when their complete closed carriers share
no event. -/
def CarrierDisjoint
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C) : Prop :=
  ∀ x, ¬ (inClosed A x ∧ inClosed B x)

instance decidableCarrierDisjoint
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C) :
    Decidable (CarrierDisjoint A B) := by
  unfold CarrierDisjoint
  infer_instance

/-- Closed-carrier disjointness is intrinsic under order isomorphisms. -/
theorem carrierDisjoint_map_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A B : MarkedDiamond C) :
    CarrierDisjoint (A.map e) (B.map e) ↔ CarrierDisjoint A B := by
  constructor
  · intro h x hx
    exact h (e.toEquiv x) ⟨
      (inClosed_map_iff e A x).2 hx.1,
      (inClosed_map_iff e B x).2 hx.2⟩
  · intro h y hy
    let x := e.toEquiv.symm y
    have hyx : e.toEquiv x = y := by simp [x]
    apply h x
    constructor
    · exact (inClosed_map_iff e A x).1 (hyx ▸ hy.1)
    · exact (inClosed_map_iff e B x).1 (hyx ▸ hy.2)

/-! ## Maximum separated-packing ensemble -/

/-- A finite family of eligible marked diamonds with pairwise disjoint closed
carriers. -/
def IsSeparatedGermPacking
    {C : FiniteCausalOrder V} (minimumInteriorCount : Nat)
    (P : Finset (MarkedDiamond C)) : Prop :=
  (∀ A ∈ P, Eligible minimumInteriorCount A) ∧
    ∀ A ∈ P, ∀ B ∈ P, A ≠ B → CarrierDisjoint A B

/-- A separated packing of maximum cardinality among all separated packings. -/
def IsMaximumSeparatedGermPacking
    {C : FiniteCausalOrder V} (minimumInteriorCount : Nat)
  (P : Finset (MarkedDiamond C)) : Prop :=
  IsSeparatedGermPacking minimumInteriorCount P ∧
    ∀ Q : Finset (MarkedDiamond C),
      IsSeparatedGermPacking minimumInteriorCount Q → Q.card ≤ P.card

/-- Transport every germ in a packing along an order isomorphism. -/
def mapPacking
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (P : Finset (MarkedDiamond C)) :
    Finset (MarkedDiamond D) :=
  (markedDiamondEquiv e).finsetCongr P

@[simp] theorem card_mapPacking
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (P : Finset (MarkedDiamond C)) :
    (mapPacking e P).card = P.card := by
  simp [mapPacking]

/-- Being a separated eligible packing is exactly preserved by relabeling. -/
theorem isSeparatedGermPacking_map_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (minimumInteriorCount : Nat)
    (P : Finset (MarkedDiamond C)) :
    IsSeparatedGermPacking minimumInteriorCount (mapPacking e P) ↔
      IsSeparatedGermPacking minimumInteriorCount P := by
  constructor
  · rintro ⟨heligible, hdisjoint⟩
    constructor
    · intro A hA
      apply (eligible_map_iff e minimumInteriorCount A).1
      apply heligible (A.map e)
      change (markedDiamondEquiv e A) ∈
        (markedDiamondEquiv e).finsetCongr P
      rw [Equiv.finsetCongr_apply]
      exact Finset.mem_map.2 ⟨A, hA, rfl⟩
    · intro A hA B hB hne
      apply (carrierDisjoint_map_iff e A B).1
      apply hdisjoint (A.map e)
      · change (markedDiamondEquiv e A) ∈
          (markedDiamondEquiv e).finsetCongr P
        rw [Equiv.finsetCongr_apply]
        exact Finset.mem_map.2 ⟨A, hA, rfl⟩
      · change (markedDiamondEquiv e B) ∈
          (markedDiamondEquiv e).finsetCongr P
        rw [Equiv.finsetCongr_apply]
        exact Finset.mem_map.2 ⟨B, hB, rfl⟩
      · exact fun hmap => hne ((markedDiamondEquiv e).injective hmap)
  · rintro ⟨heligible, hdisjoint⟩
    constructor
    · intro A hA
      change A ∈ (markedDiamondEquiv e).finsetCongr P at hA
      rw [Equiv.finsetCongr_apply] at hA
      obtain ⟨A0, hA0, rfl⟩ := Finset.mem_map.1 hA
      exact (eligible_map_iff e minimumInteriorCount A0).2
        (heligible A0 hA0)
    · intro A hA B hB hne
      change A ∈ (markedDiamondEquiv e).finsetCongr P at hA
      change B ∈ (markedDiamondEquiv e).finsetCongr P at hB
      rw [Equiv.finsetCongr_apply] at hA hB
      obtain ⟨A0, hA0, rfl⟩ := Finset.mem_map.1 hA
      obtain ⟨B0, hB0, rfl⟩ := Finset.mem_map.1 hB
      apply (carrierDisjoint_map_iff e A0 B0).2
      apply hdisjoint A0 hA0 B0 hB0
      exact fun h => hne (congrArg (markedDiamondEquiv e) h)

/-- Maximum-cardinality separated packings are exactly preserved by
relabeling. -/
theorem isMaximumSeparatedGermPacking_map_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (minimumInteriorCount : Nat)
    (P : Finset (MarkedDiamond C)) :
    IsMaximumSeparatedGermPacking minimumInteriorCount (mapPacking e P) ↔
      IsMaximumSeparatedGermPacking minimumInteriorCount P := by
  constructor
  · rintro ⟨hpacking, hmaximum⟩
    constructor
    · exact (isSeparatedGermPacking_map_iff
        e minimumInteriorCount P).1 hpacking
    · intro Q hQ
      have hmapQ : IsSeparatedGermPacking minimumInteriorCount
          (mapPacking e Q) :=
        (isSeparatedGermPacking_map_iff
          e minimumInteriorCount Q).2 hQ
      simpa using hmaximum (mapPacking e Q) hmapQ
  · rintro ⟨hpacking, hmaximum⟩
    constructor
    · exact (isSeparatedGermPacking_map_iff
        e minimumInteriorCount P).2 hpacking
    · intro Q hQ
      let Qback := mapPacking (reverseOrderIso e) Q
      have hQback : IsSeparatedGermPacking minimumInteriorCount Qback :=
        (isSeparatedGermPacking_map_iff
          (reverseOrderIso e) minimumInteriorCount Q).2 hQ
      have hbound := hmaximum Qback hQback
      simpa [Qback] using hbound

/-- The canonical finite ensemble of all maximum separated germ packings. -/
def MaximumPacking
    (C : FiniteCausalOrder V) (minimumInteriorCount : Nat) :=
  {P : Finset (MarkedDiamond C) //
    IsMaximumSeparatedGermPacking minimumInteriorCount P}

/-- Every finite causal order has at least one maximum separated packing.  The
empty packing guarantees the optimization domain is nonempty. -/
theorem maximumPacking_nonempty
    (C : FiniteCausalOrder V) (minimumInteriorCount : Nat) :
    Nonempty (MaximumPacking C minimumInteriorCount) := by
  classical
  let candidates : Finset (Finset (MarkedDiamond C)) :=
    Finset.univ.filter
      (IsSeparatedGermPacking (C := C) minimumInteriorCount)
  have hcandidates : candidates.Nonempty := by
    refine ⟨∅, ?_⟩
    simp [candidates, IsSeparatedGermPacking]
  obtain ⟨P, hP, hmaximum⟩ :=
    Finset.exists_max_image candidates Finset.card hcandidates
  refine ⟨⟨P, ?_⟩⟩
  constructor
  · exact (Finset.mem_filter.1 hP).2
  · intro Q hQ
    apply hmaximum Q
    simp [candidates, hQ]

noncomputable instance maximumPackingFintype
    (C : FiniteCausalOrder V) (minimumInteriorCount : Nat) :
    Fintype (MaximumPacking C minimumInteriorCount) := by
  classical
  unfold MaximumPacking
  exact Subtype.fintype _

noncomputable instance maximumPackingNonempty
    (C : FiniteCausalOrder V) (minimumInteriorCount : Nat) :
    Nonempty (MaximumPacking C minimumInteriorCount) :=
  maximumPacking_nonempty C minimumInteriorCount

/-- Relabeling gives an equivalence of the complete maximum-packing
ensembles. -/
def maximumPackingEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (minimumInteriorCount : Nat) :
    MaximumPacking C minimumInteriorCount ≃
      MaximumPacking D minimumInteriorCount where
  toFun P := ⟨mapPacking e P.1,
    (isMaximumSeparatedGermPacking_map_iff e minimumInteriorCount P.1).2 P.2⟩
  invFun P := ⟨mapPacking (reverseOrderIso e) P.1,
    (isMaximumSeparatedGermPacking_map_iff
      (reverseOrderIso e) minimumInteriorCount P.1).2 P.2⟩
  left_inv P := by
    apply Subtype.ext
    change (markedDiamondEquiv (reverseOrderIso e)).finsetCongr
      ((markedDiamondEquiv e).finsetCongr P.1) = P.1
    rw [markedDiamondEquiv_reverse]
    exact (markedDiamondEquiv e).finsetCongr.left_inv P.1
  right_inv P := by
    apply Subtype.ext
    change (markedDiamondEquiv e).finsetCongr
      ((markedDiamondEquiv (reverseOrderIso e)).finsetCongr P.1) = P.1
    rw [markedDiamondEquiv_reverse]
    exact (markedDiamondEquiv e).finsetCongr.right_inv P.1

/-- The number of maximum separated packings is a bare-order invariant. -/
theorem maximumPacking_card_eq
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (minimumInteriorCount : Nat) :
    Fintype.card (MaximumPacking D minimumInteriorCount) =
      Fintype.card (MaximumPacking C minimumInteriorCount) := by
  exact (Fintype.card_congr (maximumPackingEquiv e minimumInteriorCount)).symm

/-- Uniform average of an observable over the complete maximum-packing
ensemble.  Nonemptiness makes the denominator positive. -/
def maximumPackingAverage
    (C : FiniteCausalOrder V) (minimumInteriorCount : Nat)
    (observable : Finset (MarkedDiamond C) → ℝ) : ℝ :=
  (∑ P : MaximumPacking C minimumInteriorCount, observable P.1) /
    Fintype.card (MaximumPacking C minimumInteriorCount)

/-- Uniform ensemble averages of equivariant packing observables are exactly
invariant under finite-order relabeling. -/
theorem maximumPackingAverage_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (minimumInteriorCount : Nat)
    (observableC : Finset (MarkedDiamond C) → ℝ)
    (observableD : Finset (MarkedDiamond D) → ℝ)
    (hobservable : ∀ P,
      observableD (mapPacking e P) = observableC P) :
    maximumPackingAverage D minimumInteriorCount observableD =
      maximumPackingAverage C minimumInteriorCount observableC := by
  have hsum :
      (∑ P : MaximumPacking C minimumInteriorCount, observableC P.1) =
        ∑ P : MaximumPacking D minimumInteriorCount, observableD P.1 := by
    apply Fintype.sum_equiv (maximumPackingEquiv e minimumInteriorCount)
    intro P
    exact (hobservable P.1).symm
  unfold maximumPackingAverage
  rw [maximumPacking_card_eq e minimumInteriorCount]
  rw [← hsum]

/-! ## Nonvacuity controls -/

/-- Every maximum packing dominates the cardinality of every supplied
separated packing. -/
theorem packing_card_le_maximum
    {C : FiniteCausalOrder V} {minimumInteriorCount : Nat}
    (P : MaximumPacking C minimumInteriorCount)
    (Q : Finset (MarkedDiamond C))
    (hQ : IsSeparatedGermPacking minimumInteriorCount Q) :
    Q.card ≤ P.1.card :=
  P.2.2 Q hQ

/-- If at least one eligible germ exists, no maximum packing is empty. -/
theorem maximumPacking_member_nonempty_of_exists_eligible
    {C : FiniteCausalOrder V} {minimumInteriorCount : Nat}
    (P : MaximumPacking C minimumInteriorCount)
    (hexists : ∃ A : MarkedDiamond C,
      Eligible minimumInteriorCount A) :
    P.1.Nonempty := by
  classical
  obtain ⟨A, hA⟩ := hexists
  have hsingleton : IsSeparatedGermPacking minimumInteriorCount {A} := by
    constructor
    · intro B hB
      have hBA : B = A := by simpa using hB
      simpa [hBA] using hA
    · intro B hB D hD hne
      simp only [Finset.mem_singleton] at hB hD
      subst B
      subst D
      exact (hne rfl).elim
  have hcard := packing_card_le_maximum P {A} hsingleton
  exact Finset.card_pos.mp (by simpa using hcard)

/-- Branch index for two disjoint three-event causal chains. -/
def twoThreeChainBranch (x : Fin 6) : Nat := x.val / 3

/-- Level inside one of the two disjoint three-event causal chains. -/
def twoThreeChainLevel (x : Fin 6) : Nat := x.val % 3

/-- A concrete bare order with two disconnected chains of length three. -/
def twoThreeChainOrder : FiniteCausalOrder (Fin 6) where
  before x y :=
    twoThreeChainBranch x = twoThreeChainBranch y ∧
      twoThreeChainLevel x < twoThreeChainLevel y
  decidableBefore := fun _ _ => inferInstance
  irrefl _ h := Nat.lt_irrefl _ h.2
  trans hxy hyz := ⟨hxy.1.trans hyz.1, hxy.2.trans hyz.2⟩

/-- The marked diamond spanning the first three-event chain. -/
def firstThreeChainDiamond : MarkedDiamond twoThreeChainOrder where
  bottom := 0
  top := 2
  bottom_before_top := by decide

/-- The marked diamond spanning the second three-event chain. -/
def secondThreeChainDiamond : MarkedDiamond twoThreeChainOrder where
  bottom := 3
  top := 5
  bottom_before_top := by decide

/-- Two eligible outer germs with disjoint closed carriers occur in an
explicit finite causal order. -/
theorem twoThreeChainPacking_nonvacuous :
    ∃ P : Finset (MarkedDiamond twoThreeChainOrder),
      IsSeparatedGermPacking 1 P ∧ P.card = 2 := by
  classical
  let P : Finset (MarkedDiamond twoThreeChainOrder) :=
    {firstThreeChainDiamond, secondThreeChainDiamond}
  have hfirstEligible : Eligible 1 firstThreeChainDiamond := by decide
  have hsecondEligible : Eligible 1 secondThreeChainDiamond := by decide
  have hforward :
      CarrierDisjoint firstThreeChainDiamond secondThreeChainDiamond := by
    intro x
    fin_cases x <;>
      norm_num [inClosed, firstThreeChainDiamond,
        secondThreeChainDiamond, MarkedDiamond.inOpen,
        twoThreeChainOrder, twoThreeChainBranch, twoThreeChainLevel] <;>
      decide
  have hreverse :
      CarrierDisjoint secondThreeChainDiamond firstThreeChainDiamond := by
    intro x
    fin_cases x <;>
      norm_num [inClosed, firstThreeChainDiamond,
        secondThreeChainDiamond, MarkedDiamond.inOpen,
        twoThreeChainOrder, twoThreeChainBranch, twoThreeChainLevel] <;>
      decide
  refine ⟨P, ?_, ?_⟩
  · constructor
    · intro A hA
      simp only [P, Finset.mem_insert, Finset.mem_singleton] at hA
      rcases hA with rfl | rfl
      · exact hfirstEligible
      · exact hsecondEligible
    · intro A hA B hB hne
      simp only [P, Finset.mem_insert, Finset.mem_singleton] at hA hB
      rcases hA with rfl | rfl <;> rcases hB with rfl | rfl
      · exact (hne rfl).elim
      · exact hforward
      · exact hreverse
      · exact (hne rfl).elim
  · have hne : firstThreeChainDiamond ≠ secondThreeChainDiamond := by
      intro h
      have hbottom := congrArg MarkedDiamond.bottom h
      have hval := congrArg Fin.val hbottom
      norm_num [firstThreeChainDiamond, secondThreeChainDiamond] at hval
    simp [P, hne]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.AlexandrovGermPacking.maximumPackingAverage_equivariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AlexandrovGermPacking.maximumPackingAverage_equivariant

/-- info: 'PhysicsSM.Draft.NullEdge.AlexandrovGermPacking.twoThreeChainPacking_nonvacuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AlexandrovGermPacking.twoThreeChainPacking_nonvacuous

end PhysicsSM.Draft.NullEdge.AlexandrovGermPacking
