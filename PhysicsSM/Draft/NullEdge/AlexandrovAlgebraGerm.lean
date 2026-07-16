import PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator

/-!
# Alexandrov-localized scalar-field germs

This module supplies the finite localization layer required after the global
causal-operator algebra failed the A39-A40 compact-support controls. A local
germ is indexed by a marked Alexandrov interval, not selected canonically from
one event. The bottom and top endpoints are therefore visible inputs. The bare
order supplies the family of all such intervals.

Inside a marked interval, `boundaryDepth` is the smaller of the two open-
interval counts to its endpoints, with one added so the first interior layer
has positive depth. An arbitrary scalar profile of that depth defines an
intrinsic cutoff. Threshold profiles give nested protected cores on which the
cutoff can be required to equal one.

The constructions commute exactly with every finite-order isomorphism. They
do not select a preferred interval, construct a mesoscopic function algebra,
derive a continuum cutoff, or prove causal-operator convergence. Claim grade:
`M [comp]` for the finite definitions and covariance identities.

Provenance: program-internal response to the A39-A40 global-algebra kill
result. It uses the open-interval-count and order-isomorphism API from
`FiniteCausalOrderOperator`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.AlexandrovAlgebraGerm

open FiniteCausalOrderOperator

variable {V W K : Type*} [Fintype V] [Fintype W]

/-- An Alexandrov interval with its order-related endpoints kept explicit. -/
structure MarkedDiamond (C : FiniteCausalOrder V) where
  bottom : V
  top : V
  bottom_before_top : C.before bottom top

/-- Transport a marked diamond along an isomorphism of finite causal orders. -/
def MarkedDiamond.map
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C) : MarkedDiamond D where
  bottom := e.toEquiv A.bottom
  top := e.toEquiv A.top
  bottom_before_top :=
    (e.map_before_iff A.bottom A.top).2 A.bottom_before_top

/-- Membership in the strict interior of a marked diamond. -/
def MarkedDiamond.inOpen
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) (x : V) : Prop :=
  C.before A.bottom x ∧ C.before x A.top

instance MarkedDiamond.decidableInOpen
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) (x : V) :
    Decidable (A.inOpen x) := by
  unfold MarkedDiamond.inOpen
  infer_instance

/-- Count depth from the nearer timelike endpoint of a marked diamond. -/
def MarkedDiamond.boundaryDepth
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) (x : V) : Nat :=
  min (C.openIntervalCount A.bottom x + 1)
    (C.openIntervalCount x A.top + 1)

/-- The protected core at count threshold `threshold`. -/
def MarkedDiamond.protectedCore
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (threshold : Nat) (x : V) : Prop :=
  A.inOpen x ∧ threshold ≤ A.boundaryDepth x

/-- An intrinsic cutoff obtained from a scalar profile of count depth. -/
def MarkedDiamond.cutoff
    {C : FiniteCausalOrder V} [Zero K]
    (A : MarkedDiamond C) (profile : Nat -> K) : V -> K :=
  fun x => if A.inOpen x then profile (A.boundaryDepth x) else 0

/-- Multiply a scalar field by a marked-diamond cutoff. -/
def MarkedDiamond.localizeField
    {C : FiniteCausalOrder V} [Zero K] [Mul K]
    (A : MarkedDiamond C) (profile : Nat -> K) (field : V -> K) : V -> K :=
  A.cutoff profile * field

/-- The strict interior predicate is intrinsic under order isomorphisms. -/
theorem inOpen_map_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C) (x : V) :
    (A.map e).inOpen (e.toEquiv x) ↔ A.inOpen x := by
  simp [MarkedDiamond.inOpen, MarkedDiamond.map, e.map_before_iff]

/-- Count boundary depth is intrinsic under order isomorphisms. -/
theorem boundaryDepth_map
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C) (x : V) :
    (A.map e).boundaryDepth (e.toEquiv x) = A.boundaryDepth x := by
  simp [MarkedDiamond.boundaryDepth, MarkedDiamond.map,
    e.openIntervalCount_eq]

/-- Protected-core membership is intrinsic under order isomorphisms. -/
theorem protectedCore_map_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (threshold : Nat) (x : V) :
    (A.map e).protectedCore threshold (e.toEquiv x) ↔
      A.protectedCore threshold x := by
  simp [MarkedDiamond.protectedCore, inOpen_map_iff,
    boundaryDepth_map]

/-- Increasing the depth threshold shrinks the protected core. -/
theorem MarkedDiamond.protectedCore_anti
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    {shallow deep : Nat} (hthreshold : shallow ≤ deep) (x : V)
    (hx : A.protectedCore deep x) :
    A.protectedCore shallow x := by
  exact ⟨hx.1, hthreshold.trans hx.2⟩

/-- The cutoff vanishes outside its marked diamond. -/
theorem MarkedDiamond.cutoff_eq_zero_of_not_inOpen
    {C : FiniteCausalOrder V} [Zero K]
    (A : MarkedDiamond C) (profile : Nat -> K) (x : V)
    (hx : ¬ A.inOpen x) :
    A.cutoff profile x = 0 := by
  simp [MarkedDiamond.cutoff, hx]

/-- A profile that is one past a threshold is one on the protected core. -/
theorem MarkedDiamond.cutoff_eq_one_on_protectedCore
    {C : FiniteCausalOrder V} [Zero K] [One K]
    (A : MarkedDiamond C) (profile : Nat -> K) (threshold : Nat)
    (hprofile : forall depth, threshold ≤ depth -> profile depth = 1)
    (x : V) (hx : A.protectedCore threshold x) :
    A.cutoff profile x = 1 := by
  simp [MarkedDiamond.cutoff, hx.1, hprofile _ hx.2]

/-- Marked-diamond cutoffs commute with every order isomorphism. -/
theorem cutoff_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) [Zero K]
    (A : MarkedDiamond C) (profile : Nat -> K) (x : V) :
    (A.map e).cutoff profile (e.toEquiv x) = A.cutoff profile x := by
  by_cases hx : A.inOpen x
  · have hmap : (A.map e).inOpen (e.toEquiv x) :=
      (inOpen_map_iff e A x).2 hx
    simp [MarkedDiamond.cutoff, hx, hmap, boundaryDepth_map]
  · have hmap : ¬ (A.map e).inOpen (e.toEquiv x) :=
      fun h => hx ((inOpen_map_iff e A x).1 h)
    simp [MarkedDiamond.cutoff, hx, hmap]

/-- Localization of scalar fields commutes with order relabeling. -/
theorem localizeField_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) [Zero K] [Mul K]
    (A : MarkedDiamond C) (profile : Nat -> K)
    (field : V -> K) (x : V) :
    (A.map e).localizeField profile (e.relabelField field) (e.toEquiv x) =
      A.localizeField profile field x := by
  simp [MarkedDiamond.localizeField, cutoff_equivariant,
    OrderIso.relabelField_apply]

end PhysicsSM.Draft.NullEdge.AlexandrovAlgebraGerm
