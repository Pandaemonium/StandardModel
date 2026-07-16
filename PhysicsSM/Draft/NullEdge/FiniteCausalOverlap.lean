import PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator

/-!
# Finite causal overlap for intrinsic spacelike-distance reconstruction

Boguna and Krioukov define the causal overlap of two unrelated events `a,b`
relative to a common-past event `c` as the common Alexandrov-region volume
divided by the smaller of the two Alexandrov volumes. In a finite causal set,
number-volume correspondence replaces these volumes by event counts.

This module defines that exact finite ratio from a strict causal order. It
proves symmetry in `a,b`, bounds the ratio in `[0,1]`, and proves equivariance
under every finite order isomorphism. The ratio is dimensionless. Converting it
to a spacelike distance still requires a proper-time estimate for `c`, a
dimension-dependent inversion or normalization, and a scale calibration; none
is supplied or derived here.

Provenance: M. Boguna and D. Krioukov, "Measuring spatial distances in causal
sets via causal overlaps," arXiv:2401.17376, equations (16)--(31). Clean-room
formalization in the open-interval convention of
`FiniteCausalOrderOperator.lean`.

Claim grade: `M [comp]` for the finite order/count construction only.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator

variable {V W : Type*} [Fintype V] [Fintype W]

/-- Events lying strictly after `c` and strictly before both `a` and `b`. -/
def FiniteCausalOrder.CommonInterval
    (C : FiniteCausalOrder V) (c a b : V) :=
  {z : V // C.before c z ∧ C.before z a ∧ C.before z b}

instance (C : FiniteCausalOrder V) (c a b : V) :
    Fintype (C.CommonInterval c a b) := by
  unfold FiniteCausalOrder.CommonInterval
  infer_instance

/-- Number of events in the common strict Alexandrov region. -/
def FiniteCausalOrder.commonIntervalCount
    (C : FiniteCausalOrder V) (c a b : V) : Nat :=
  Fintype.card (C.CommonInterval c a b)

/-- Forgetting the right endpoint embeds the common region into the left
Alexandrov interval. -/
def FiniteCausalOrder.commonIntervalToLeft
    (C : FiniteCausalOrder V) (c a b : V) :
    C.CommonInterval c a b ↪ C.OpenInterval c a where
  toFun z := ⟨z.1, z.property.1, z.property.2.1⟩
  inj' x y h := by
    apply Subtype.ext
    exact congrArg (fun z : C.OpenInterval c a => z.1) h

/-- Forgetting the left endpoint embeds the common region into the right
Alexandrov interval. -/
def FiniteCausalOrder.commonIntervalToRight
    (C : FiniteCausalOrder V) (c a b : V) :
    C.CommonInterval c a b ↪ C.OpenInterval c b where
  toFun z := ⟨z.1, z.property.1, z.property.2.2⟩
  inj' x y h := by
    apply Subtype.ext
    exact congrArg (fun z : C.OpenInterval c b => z.1) h

/-- The common-region count does not exceed the left interval count. -/
theorem FiniteCausalOrder.commonIntervalCount_le_left
    (C : FiniteCausalOrder V) (c a b : V) :
    C.commonIntervalCount c a b ≤ C.openIntervalCount c a := by
  exact Fintype.card_le_of_injective
    (C.commonIntervalToLeft c a b)
    (C.commonIntervalToLeft c a b).injective

/-- The common-region count does not exceed the right interval count. -/
theorem FiniteCausalOrder.commonIntervalCount_le_right
    (C : FiniteCausalOrder V) (c a b : V) :
    C.commonIntervalCount c a b ≤ C.openIntervalCount c b := by
  exact Fintype.card_le_of_injective
    (C.commonIntervalToRight c a b)
    (C.commonIntervalToRight c a b).injective

/-- The common-region count is bounded by the smaller interval count. -/
theorem FiniteCausalOrder.commonIntervalCount_le_min
    (C : FiniteCausalOrder V) (c a b : V) :
    C.commonIntervalCount c a b ≤
      min (C.openIntervalCount c a) (C.openIntervalCount c b) := by
  exact le_min (C.commonIntervalCount_le_left c a b)
    (C.commonIntervalCount_le_right c a b)

/-- Exact finite causal-overlap count ratio. A zero denominator gives zero
under Lean's totalized division. -/
def FiniteCausalOrder.causalOverlap
    (C : FiniteCausalOrder V) (c a b : V) : ℝ :=
  (C.commonIntervalCount c a b : ℝ) /
    (min (C.openIntervalCount c a) (C.openIntervalCount c b) : Nat)

/-- Swapping the two target events gives an equivalent common region. -/
def FiniteCausalOrder.commonIntervalSwap
    (C : FiniteCausalOrder V) (c a b : V) :
    C.CommonInterval c a b ≃ C.CommonInterval c b a where
  toFun z := ⟨z.1, z.property.1, z.property.2.2, z.property.2.1⟩
  invFun z := ⟨z.1, z.property.1, z.property.2.2, z.property.2.1⟩
  left_inv z := by rfl
  right_inv z := by rfl

/-- The common-region count is symmetric in the target pair. -/
theorem FiniteCausalOrder.commonIntervalCount_swap
    (C : FiniteCausalOrder V) (c a b : V) :
    C.commonIntervalCount c a b = C.commonIntervalCount c b a := by
  exact Fintype.card_congr (C.commonIntervalSwap c a b)

/-- Finite causal overlap is symmetric in the target pair. -/
theorem FiniteCausalOrder.causalOverlap_swap
    (C : FiniteCausalOrder V) (c a b : V) :
    C.causalOverlap c a b = C.causalOverlap c b a := by
  unfold FiniteCausalOrder.causalOverlap
  rw [C.commonIntervalCount_swap c a b]
  rw [min_comm]

/-- Finite causal overlap is nonnegative. -/
theorem FiniteCausalOrder.causalOverlap_nonneg
    (C : FiniteCausalOrder V) (c a b : V) :
    0 ≤ C.causalOverlap c a b := by
  unfold FiniteCausalOrder.causalOverlap
  positivity

/-- Finite causal overlap is at most one, including the zero-denominator case. -/
theorem FiniteCausalOrder.causalOverlap_le_one
    (C : FiniteCausalOrder V) (c a b : V) :
    C.causalOverlap c a b ≤ 1 := by
  unfold FiniteCausalOrder.causalOverlap
  let denominator := min (C.openIntervalCount c a) (C.openIntervalCount c b)
  have hcount : C.commonIntervalCount c a b ≤ denominator :=
    C.commonIntervalCount_le_min c a b
  by_cases hzero : denominator = 0
  · have hcommon : C.commonIntervalCount c a b = 0 := by omega
    simp [hcommon]
  · have hpositiveNat : 0 < denominator := Nat.pos_of_ne_zero hzero
    have hpositiveReal : (0 : ℝ) < denominator := by exact_mod_cast hpositiveNat
    apply (div_le_one hpositiveReal).2
    exact_mod_cast hcount

/-- An order isomorphism induces an equivalence of common regions. -/
def OrderIso.commonIntervalEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (c a b : V) :
    C.CommonInterval c a b ≃
      D.CommonInterval (e.toEquiv c) (e.toEquiv a) (e.toEquiv b) where
  toFun z := ⟨e.toEquiv z.1,
    (e.map_before_iff c z.1).2 z.property.1,
    (e.map_before_iff z.1 a).2 z.property.2.1,
    (e.map_before_iff z.1 b).2 z.property.2.2⟩
  invFun z := ⟨e.toEquiv.symm z.1,
    (e.map_before_iff c (e.toEquiv.symm z.1)).1 (by simpa using z.property.1),
    (e.map_before_iff (e.toEquiv.symm z.1) a).1 (by simpa using z.property.2.1),
    (e.map_before_iff (e.toEquiv.symm z.1) b).1 (by simpa using z.property.2.2)⟩
  left_inv z := by
    apply Subtype.ext
    simp
  right_inv z := by
    apply Subtype.ext
    simp

/-- Common-region cardinality is intrinsic to the finite order. -/
theorem OrderIso.commonIntervalCount_eq
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (c a b : V) :
    D.commonIntervalCount (e.toEquiv c) (e.toEquiv a) (e.toEquiv b) =
      C.commonIntervalCount c a b := by
  exact (Fintype.card_congr (e.commonIntervalEquiv c a b)).symm

/-- The finite causal-overlap ratio is invariant under event relabeling. -/
theorem OrderIso.causalOverlap_eq
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (c a b : V) :
    D.causalOverlap (e.toEquiv c) (e.toEquiv a) (e.toEquiv b) =
      C.causalOverlap c a b := by
  unfold FiniteCausalOrder.causalOverlap
  rw [e.commonIntervalCount_eq]
  rw [e.openIntervalCount_eq, e.openIntervalCount_eq]

/-! ## Conditional distance conversions -/

/-- Exact `1+1` Minkowski distance conversion from a supplied proper time and
causal overlap. The physical source formula assumes positive overlap. -/
def overlapDistance1p1 (properTime overlap : ℝ) : ℝ :=
  properTime * (1 - overlap) / Real.sqrt overlap

/-- Positive proper time and overlap strictly between zero and one give a
positive `1+1` overlap distance. -/
theorem overlapDistance1p1_pos
    {properTime overlap : ℝ}
    (hproperTime : 0 < properTime) (hoverlapPos : 0 < overlap)
    (hoverlapLt : overlap < 1) :
    0 < overlapDistance1p1 properTime overlap := by
  unfold overlapDistance1p1
  exact div_pos (mul_pos hproperTime (sub_pos.mpr hoverlapLt))
    (Real.sqrt_pos.2 hoverlapPos)

/-- At unit overlap, the conditional `1+1` distance is zero. -/
theorem overlapDistance1p1_one (properTime : ℝ) :
    overlapDistance1p1 properTime 1 = 0 := by
  norm_num [overlapDistance1p1]

/-- Rescaling the supplied proper-time unit rescales the reconstructed
`1+1` distance by the same factor. The dimensionless overlap does not fix an
absolute length normalization. -/
theorem overlapDistance1p1_scale
    (scale properTime overlap : ℝ) :
    overlapDistance1p1 (scale * properTime) overlap =
      scale * overlapDistance1p1 properTime overlap := by
  unfold overlapDistance1p1
  ring

/-- Finite version of the arbitrary-dimensional large-proper-time distance
proxy `2 * tau * (1-O) / c_d`. Its identification with continuum distance
requires the source limit and the supplied positive dimension coefficient. -/
def asymptoticOverlapDistanceProxy
    (dimensionCoefficient properTime overlap : ℝ) : ℝ :=
  2 * properTime * (1 - overlap) / dimensionCoefficient

/-- The arbitrary-dimensional asymptotic proxy is likewise homogeneous in
the supplied proper-time normalization. -/
theorem asymptoticOverlapDistanceProxy_scale
    (scale dimensionCoefficient properTime overlap : ℝ) :
    asymptoticOverlapDistanceProxy dimensionCoefficient
        (scale * properTime) overlap =
      scale * asymptoticOverlapDistanceProxy
        dimensionCoefficient properTime overlap := by
  unfold asymptoticOverlapDistanceProxy
  ring

/-! ## Nonvacuity control -/

/-- Rank function for a four-event fork: event `0`, then event `1`, then the
unrelated target pair `2,3`. -/
def overlapForkRank (x : Fin 4) : Nat :=
  if x = 0 then 0 else if x = 1 then 1 else 2

/-- The strict rank order on the four-event fork. -/
def overlapForkOrder : FiniteCausalOrder (Fin 4) where
  before x y := overlapForkRank x < overlapForkRank y
  decidableBefore := fun _ _ => inferInstance
  irrefl x := Nat.lt_irrefl (overlapForkRank x)
  trans hxy hyz := Nat.lt_trans hxy hyz

/-- The two unrelated fork tips have one common interior event and causal
overlap one relative to event zero. -/
theorem overlapForkOrder_nonvacuous :
    (¬ overlapForkOrder.before 2 3) ∧
    (¬ overlapForkOrder.before 3 2) ∧
    overlapForkOrder.causalOverlap 0 2 3 = 1 := by
  have h23 : ¬ overlapForkOrder.before 2 3 := by decide
  have h32 : ¬ overlapForkOrder.before 3 2 := by decide
  have hcommon : overlapForkOrder.commonIntervalCount 0 2 3 = 1 := by
    decide
  have hleft : overlapForkOrder.openIntervalCount 0 2 = 1 := by
    decide
  have hright : overlapForkOrder.openIntervalCount 0 3 = 1 := by
    decide
  refine ⟨h23, h32, ?_⟩
  simp [FiniteCausalOrder.causalOverlap, hcommon, hleft, hright]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.OrderIso.causalOverlap_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.OrderIso.causalOverlap_eq

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.overlapForkOrder_nonvacuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.overlapForkOrder_nonvacuous

end PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator
