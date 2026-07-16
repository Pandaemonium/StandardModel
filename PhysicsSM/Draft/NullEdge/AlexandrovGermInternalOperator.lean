import PhysicsSM.Draft.NullEdge.AlexandrovGermPairEstimand

/-!
# Retarded causal operators internal to an Alexandrov germ

The separated-germ covariance architecture requires more than visibly compact
support: every interval count, taper input, anchor selector, and operator read
must be determined by the closed outer germ.  This module constructs the
induced finite causal order on one marked diamond's closed carrier and proves
the causal-convexity theorem that makes this possible.

For any two carrier events, the induced open interval is equivalent to the
ambient open interval.  Consequently all Benincasa-Dowker layer labels used by
the induced local or smeared retarded operator agree exactly with the ambient
labels while requiring no ambient events.  Boundary depth and cutoff values
likewise have internal formulas.

The module then averages an induced smeared-operator residual over every
protected anchor, avoiding a symmetry-breaking anchor choice.  Supplied local
fields and targets remain carrier-typed inputs.  A separate cutoff-control
score is constructed entirely from the order, a count-depth profile, and the
two numerical operator scales.  Both scores commute with every finite-order
isomorphism, and the cutoff control plugs into the canonical maximum-packing
mean-square-difference estimand.

These finite identities close an information-flow interface.  They do not
show that the cutoff control reconstructs a metric, derive polynomial probes
or a continuum target, prove stochastic independence under a fixed-total-count
law, or establish operator convergence.

Claim grade: `M [orig]` for the finite causal-convexity, locality, and
equivariance statements.  The convexity proof is a clean-room specialization
of the program's earlier P9 subdiamond-restriction argument to the active
`FiniteCausalOrder` and `MarkedDiamond` APIs.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator

open scoped BigOperators

open AlexandrovAlgebraGerm
open AlexandrovGermPacking
open AlexandrovGermPairEstimand
open FiniteCausalOrderOperator

variable {V W : Type*} [Fintype V] [Fintype W]

/-! ## Closed-carrier induced order -/

/-- The event type visible inside one marked diamond, including endpoints. -/
def ClosedCarrier {C : FiniteCausalOrder V} (A : MarkedDiamond C) :=
  {x : V // inClosed A x}

noncomputable instance closedCarrierFintype
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) :
    Fintype (ClosedCarrier A) := by
  classical
  unfold ClosedCarrier
  exact Subtype.fintype _

/-- Restrict the ambient strict causal order to a closed marked diamond. -/
def inducedOrder {C : FiniteCausalOrder V} (A : MarkedDiamond C) :
    FiniteCausalOrder (ClosedCarrier A) where
  before x y := C.before x.1 y.1
  decidableBefore := fun _ _ => inferInstance
  irrefl x := C.irrefl x.1
  trans hxy hyz := C.trans hxy hyz

/-- Bottom endpoint as an event of the induced carrier. -/
def carrierBottom {C : FiniteCausalOrder V} (A : MarkedDiamond C) :
    ClosedCarrier A :=
  ⟨A.bottom, Or.inl rfl⟩

/-- Top endpoint as an event of the induced carrier. -/
def carrierTop {C : FiniteCausalOrder V} (A : MarkedDiamond C) :
    ClosedCarrier A :=
  ⟨A.top, Or.inr (Or.inl rfl)⟩

/-- Causal convexity of a closed marked diamond: every event causally between
two carrier events belongs to the same carrier. -/
theorem between_mem_closed
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    {x y z : V} (hx : inClosed A x) (hy : inClosed A y)
    (hxz : C.before x z) (hzy : C.before z y) :
    inClosed A z := by
  right
  right
  constructor
  · rcases hx with hbottom | htop | hopen
    · subst x
      exact hxz
    · subst x
      exact C.trans A.bottom_before_top hxz
    · exact C.trans hopen.1 hxz
  · rcases hy with hbottom | htop | hopen
    · subst y
      exact C.trans hzy A.bottom_before_top
    · subst y
      exact hzy
    · exact C.trans hzy hopen.2

/-- The induced and ambient open intervals between carrier events are
equivalent.  Surjectivity is exactly causal convexity. -/
def inducedOpenIntervalEquiv
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (x y : ClosedCarrier A) :
    (inducedOrder A).OpenInterval x y ≃ C.OpenInterval x.1 y.1 where
  toFun z := ⟨z.1.1, z.2.1, z.2.2⟩
  invFun z :=
    ⟨⟨z.1, between_mem_closed A x.2 y.2 z.2.1 z.2.2⟩,
      z.2.1, z.2.2⟩
  left_inv z := by
    apply Subtype.ext
    apply Subtype.ext
    rfl
  right_inv z := by
    apply Subtype.ext
    rfl

/-- Every induced interval count equals the corresponding ambient count. -/
theorem induced_openIntervalCount_eq
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (x y : ClosedCarrier A) :
    (inducedOrder A).openIntervalCount x y =
      C.openIntervalCount x.1 y.1 := by
  exact Fintype.card_congr (inducedOpenIntervalEquiv A x y)

/-! ## Compatibility with ambient zero extension -/

/-- Extend a carrier field by zero to the ambient event type. -/
def zeroExtendField
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (field : ClosedCarrier A → ℝ) : V → ℝ :=
  fun x => if hx : inClosed A x then field ⟨x, hx⟩ else 0

/-- Zero extension recovers the original field on every carrier event. -/
@[simp] theorem zeroExtendField_apply
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (field : ClosedCarrier A → ℝ) (x : ClosedCarrier A) :
    zeroExtendField A field x.1 = field x := by
  simp [zeroExtendField, x.2]

/-- The induced layered past sum equals the ambient past sum of the zero
extension.  Interval-count coefficients agree by causal convexity; all
outside-carrier summands vanish. -/
theorem layeredPastSum_induced_eq_zeroExtend
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (coefficient : Nat → ℝ) (field : ClosedCarrier A → ℝ)
    (x : ClosedCarrier A) :
    (inducedOrder A).layeredPastSum coefficient field x =
      C.layeredPastSum coefficient (zeroExtendField A field) x.1 := by
  classical
  let ambientTerm : V → ℝ := fun y =>
    if C.before y x.1 then
      coefficient (C.openIntervalCount y x.1) *
        zeroExtendField A field y
    else 0
  calc
    (inducedOrder A).layeredPastSum coefficient field x =
        ∑ y : ClosedCarrier A, ambientTerm y.1 := by
      unfold FiniteCausalOrder.layeredPastSum
      apply Fintype.sum_congr
      intro y
      by_cases hbefore : C.before y.1 x.1
      · have hinduced : (inducedOrder A).before y x := hbefore
        simp [ambientTerm, hbefore, hinduced,
          induced_openIntervalCount_eq, zeroExtendField_apply]
      · have hinduced : ¬ (inducedOrder A).before y x := hbefore
        simp [ambientTerm, hbefore, hinduced]
    _ = ∑ y ∈ Finset.univ.filter (inClosed A), ambientTerm y := by
      exact (Finset.sum_subtype (Finset.univ.filter (inClosed A))
        (by intro y; simp) ambientTerm).symm
    _ = ∑ y : V, ambientTerm y := by
      rw [Finset.sum_filter]
      apply Finset.sum_congr rfl
      intro y hy
      by_cases hcarrier : inClosed A y
      · simp [hcarrier]
      · have hzero : ambientTerm y = 0 := by
          simp [ambientTerm, zeroExtendField, hcarrier]
        simp [hcarrier, hzero]
    _ = C.layeredPastSum coefficient (zeroExtendField A field) x.1 := by
      rfl

/-- Every induced layered operator equals the ambient layered operator on the
zero extension of the same carrier field. -/
theorem layeredOperator_induced_eq_zeroExtend
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (prefactor diagonal : ℝ) (coefficient : Nat → ℝ)
    (field : ClosedCarrier A → ℝ) (x : ClosedCarrier A) :
    (inducedOrder A).layeredOperator prefactor diagonal coefficient field x =
      C.layeredOperator prefactor diagonal coefficient
        (zeroExtendField A field) x.1 := by
  unfold FiniteCausalOrder.layeredOperator
  rw [layeredPastSum_induced_eq_zeroExtend]
  simp

/-- The induced project-sign local four-dimensional operator agrees exactly
with the ambient operator on zero extension. -/
theorem projectLocal4DOperator_induced_eq_zeroExtend
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) (ell : ℝ)
    (field : ClosedCarrier A → ℝ) (x : ClosedCarrier A) :
    projectLocal4DOperator (inducedOrder A) ell field x =
      projectLocal4DOperator C ell (zeroExtendField A field) x.1 := by
  unfold projectLocal4DOperator sourceLocal4DOperator
  rw [layeredOperator_induced_eq_zeroExtend]

/-- The induced project-sign smeared four-dimensional operator agrees exactly
with the ambient operator on zero extension. -/
theorem projectSmeared4DOperator_induced_eq_zeroExtend
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ)
    (field : ClosedCarrier A → ℝ) (x : ClosedCarrier A) :
    projectSmeared4DOperator (inducedOrder A) ell nonlocalityScale field x =
      projectSmeared4DOperator C ell nonlocalityScale
        (zeroExtendField A field) x.1 := by
  unfold projectSmeared4DOperator sourceSmeared4DOperator
  by_cases hepsilon : smearingEpsilon ell nonlocalityScale = 1
  · simp only [hepsilon, if_true]
    unfold sourceLocal4DOperator
    rw [layeredOperator_induced_eq_zeroExtend]
  · simp only [hepsilon, if_false]
    rw [layeredOperator_induced_eq_zeroExtend]

/-! ## Internal boundary depth and cutoff -/

/-- Strict interior membership expressed solely in the induced order. -/
def carrierInOpen
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (x : ClosedCarrier A) : Prop :=
  (inducedOrder A).before (carrierBottom A) x ∧
    (inducedOrder A).before x (carrierTop A)

instance decidableCarrierInOpen
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (x : ClosedCarrier A) : Decidable (carrierInOpen A x) := by
  unfold carrierInOpen
  infer_instance

/-- Internal and ambient strict-interior predicates agree. -/
theorem carrierInOpen_iff
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (x : ClosedCarrier A) :
    carrierInOpen A x ↔ A.inOpen x.1 := by
  rfl

/-- Boundary depth computed entirely in the induced carrier order. -/
def internalBoundaryDepth
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (x : ClosedCarrier A) : Nat :=
  min ((inducedOrder A).openIntervalCount (carrierBottom A) x + 1)
    ((inducedOrder A).openIntervalCount x (carrierTop A) + 1)

/-- Internal boundary depth equals the original marked-diamond depth. -/
theorem internalBoundaryDepth_eq
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (x : ClosedCarrier A) :
    internalBoundaryDepth A x = A.boundaryDepth x.1 := by
  simp [internalBoundaryDepth, MarkedDiamond.boundaryDepth,
    induced_openIntervalCount_eq, carrierBottom, carrierTop]

/-- Count-depth cutoff computed only from the induced carrier order. -/
def internalCutoff
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (profile : Nat → ℝ) : ClosedCarrier A → ℝ :=
  fun x => if carrierInOpen A x then
    profile (internalBoundaryDepth A x) else 0

/-- The internal cutoff is exactly the restriction of the ambient germ cutoff. -/
theorem internalCutoff_eq_restriction
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (profile : Nat → ℝ) (x : ClosedCarrier A) :
    internalCutoff A profile x = A.cutoff profile x.1 := by
  by_cases hx : carrierInOpen A x
  · have hopen : A.inOpen x.1 := (carrierInOpen_iff A x).1 hx
    simp [internalCutoff, MarkedDiamond.cutoff, hx, hopen,
      internalBoundaryDepth_eq]
  · have hopen : ¬ A.inOpen x.1 :=
      fun h => hx ((carrierInOpen_iff A x).2 h)
    simp [internalCutoff, MarkedDiamond.cutoff, hx, hopen]

/-! ## Relabeling of carriers and anchors -/

/-- A finite-order isomorphism restricts to an equivalence of closed
carriers. -/
def closedCarrierEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C) :
    ClosedCarrier A ≃ ClosedCarrier (A.map e) where
  toFun x := ⟨e.toEquiv x.1, (inClosed_map_iff e A x.1).2 x.2⟩
  invFun y :=
    ⟨e.toEquiv.symm y.1,
      (inClosed_map_iff e A (e.toEquiv.symm y.1)).1 (by simpa using y.2)⟩
  left_inv x := by
    apply Subtype.ext
    simp
  right_inv y := by
    apply Subtype.ext
    simp

/-- The induced carrier orders are isomorphic under every ambient order
isomorphism. -/
def inducedOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C) :
    OrderIso (inducedOrder A) (inducedOrder (A.map e)) where
  toEquiv := closedCarrierEquiv e A
  map_before_iff x y := e.map_before_iff x.1 y.1

/-- Internal cutoff fields relabel exactly with the induced order. -/
theorem internalCutoff_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (profile : Nat → ℝ) :
    (inducedOrderIso e A).relabelField (internalCutoff A profile) =
      internalCutoff (A.map e) profile := by
  funext y
  let x : ClosedCarrier A := (closedCarrierEquiv e A).symm y
  have hy : (closedCarrierEquiv e A) x = y := by simp [x]
  rw [← hy]
  unfold OrderIso.relabelField
  change internalCutoff A profile
      ((closedCarrierEquiv e A).symm (closedCarrierEquiv e A x)) =
    internalCutoff (A.map e) profile (closedCarrierEquiv e A x)
  rw [Equiv.symm_apply_apply]
  rw [internalCutoff_eq_restriction,
    internalCutoff_eq_restriction]
  exact (cutoff_equivariant e A profile x.1).symm

/-- Protected anchors inside one germ.  The subtype can be empty at an
over-aggressive threshold; averages below use totalized division. -/
def ProtectedAnchor
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (threshold : Nat) :=
  {x : ClosedCarrier A // A.protectedCore threshold x.1}

noncomputable instance protectedAnchorFintype
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (threshold : Nat) : Fintype (ProtectedAnchor A threshold) := by
  classical
  unfold ProtectedAnchor
  exact Subtype.fintype _

/-- The middle event of the first concrete three-event chain lies in its
closed carrier. -/
def firstThreeChainMiddleCarrier :
    ClosedCarrier firstThreeChainDiamond :=
  ⟨1, Or.inr (Or.inr (by decide))⟩

/-- The same middle event is a genuine protected anchor at depth one. -/
def firstThreeChainProtectedAnchor :
    ProtectedAnchor firstThreeChainDiamond 1 :=
  ⟨firstThreeChainMiddleCarrier, by
    constructor
    · decide
    · decide⟩

/-- The protected-anchor averaging type is nonempty in the explicit
three-event control germ. -/
theorem firstThreeChainProtectedAnchor_nonempty :
    Nonempty (ProtectedAnchor firstThreeChainDiamond 1) :=
  ⟨firstThreeChainProtectedAnchor⟩

/-- Ambient relabeling gives an equivalence of protected-anchor sets. -/
def protectedAnchorEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C) (threshold : Nat) :
    ProtectedAnchor A threshold ≃
      ProtectedAnchor (A.map e) threshold where
  toFun x :=
    ⟨closedCarrierEquiv e A x.1,
      (protectedCore_map_iff e A threshold x.1.1).2 x.2⟩
  invFun y := by
    let x : ClosedCarrier A := (closedCarrierEquiv e A).symm y.1
    refine ⟨x, (protectedCore_map_iff e A threshold x.1).1 ?_⟩
    have hcarrier : (closedCarrierEquiv e A) x = y.1 := by simp [x]
    have hvalue : e.toEquiv x.1 = y.1.1 := congrArg Subtype.val hcarrier
    rw [hvalue]
    exact y.2
  left_inv x := by
    apply Subtype.ext
    simp
  right_inv y := by
    apply Subtype.ext
    simp

/-- Uniform average over every protected anchor. -/
def protectedAnchorAverage
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (threshold : Nat) (response : ClosedCarrier A → ℝ) : ℝ :=
  (∑ x : ProtectedAnchor A threshold, response x.1) /
    Fintype.card (ProtectedAnchor A threshold)

/-- Protected-anchor averages of relabeled responses are invariant. -/
theorem protectedAnchorAverage_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C) (threshold : Nat)
    (responseC : ClosedCarrier A → ℝ)
    (responseD : ClosedCarrier (A.map e) → ℝ)
    (hresponse : ∀ x,
      responseD (closedCarrierEquiv e A x) = responseC x) :
    protectedAnchorAverage (A.map e) threshold responseD =
      protectedAnchorAverage A threshold responseC := by
  have hsum :
      (∑ x : ProtectedAnchor A threshold, responseC x.1) =
        ∑ y : ProtectedAnchor (A.map e) threshold, responseD y.1 := by
    apply Fintype.sum_equiv (protectedAnchorEquiv e A threshold)
    intro x
    exact (hresponse x.1).symm
  have hcard :
      Fintype.card (ProtectedAnchor (A.map e) threshold) =
        Fintype.card (ProtectedAnchor A threshold) :=
    (Fintype.card_congr (protectedAnchorEquiv e A threshold)).symm
  unfold protectedAnchorAverage
  rw [hcard, ← hsum]

/-! ## Internal retarded scores -/

/-- One induced smeared-operator residual, using only a carrier field and a
carrier target. -/
def internalSmearedResidual
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ)
    (field target : ClosedCarrier A → ℝ)
    (x : ClosedCarrier A) : ℝ :=
  projectSmeared4DOperator (inducedOrder A) ell nonlocalityScale field x -
    target x

/-- Uniform protected-anchor average of the internal smeared residual. -/
def internalProtectedResidualScore
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (anchorThreshold : Nat) (ell nonlocalityScale : ℝ)
    (field target : ClosedCarrier A → ℝ) : ℝ :=
  protectedAnchorAverage A anchorThreshold
    (internalSmearedResidual A ell nonlocalityScale field target)

/-- The internal residual score is relabeling invariant when its carrier field
and target are relabeled with the induced order. -/
theorem internalProtectedResidualScore_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (anchorThreshold : Nat) (ell nonlocalityScale : ℝ)
    (field target : ClosedCarrier A → ℝ) :
    internalProtectedResidualScore (A.map e) anchorThreshold
        ell nonlocalityScale
        ((inducedOrderIso e A).relabelField field)
        ((inducedOrderIso e A).relabelField target) =
      internalProtectedResidualScore A anchorThreshold
        ell nonlocalityScale field target := by
  apply protectedAnchorAverage_equivariant e A anchorThreshold
  intro x
  unfold internalSmearedResidual
  change projectSmeared4DOperator (inducedOrder (A.map e))
        ell nonlocalityScale ((inducedOrderIso e A).relabelField field)
        ((inducedOrderIso e A).toEquiv x) -
      (inducedOrderIso e A).relabelField target
        ((inducedOrderIso e A).toEquiv x) =
    projectSmeared4DOperator (inducedOrder A)
        ell nonlocalityScale field x - target x
  rw [(inducedOrderIso e A).projectSmeared4DOperator_equivariant]
  simp only [OrderIso.relabelField_apply]

/-- Fully internal control score obtained by applying the induced smeared
operator to the intrinsic count-depth cutoff and averaging all protected
anchors. -/
def cutoffControlScore
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (anchorThreshold : Nat) (ell nonlocalityScale : ℝ)
    (profile : Nat → ℝ) : ℝ :=
  internalProtectedResidualScore A anchorThreshold ell nonlocalityScale
    (internalCutoff A profile) 0

/-- The cutoff control score is a scalar invariant of the marked finite
causal order at fixed numerical scales and depth profile. -/
theorem cutoffControlScore_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (anchorThreshold : Nat) (ell nonlocalityScale : ℝ)
    (profile : Nat → ℝ) :
    cutoffControlScore (A.map e) anchorThreshold ell nonlocalityScale profile =
      cutoffControlScore A anchorThreshold ell nonlocalityScale profile := by
  unfold cutoffControlScore
  rw [← internalCutoff_equivariant e A profile]
  have hzero :
      ((0 : ClosedCarrier (A.map e) → ℝ)) =
        (inducedOrderIso e A).relabelField
          (0 : ClosedCarrier A → ℝ) := by
    funext x
    simp [OrderIso.relabelField]
  rw [hzero]
  exact internalProtectedResidualScore_equivariant e A
    anchorThreshold ell nonlocalityScale
    (internalCutoff A profile) 0

/-- Canonical maximum-packing selected-pair mean-square difference of the
fully internal cutoff control score. -/
def cutoffControlMeanSquareDifference
    (C : FiniteCausalOrder V) (minimumInteriorCount anchorThreshold : Nat)
    (ell nonlocalityScale : ℝ) (profile : Nat → ℝ) : ℝ :=
  maximumPackingMeanSquareDifference C minimumInteriorCount
    (fun A => cutoffControlScore A anchorThreshold
      ell nonlocalityScale profile)

/-- The complete separated-packing cutoff-control estimand is a bare-order
invariant. -/
theorem cutoffControlMeanSquareDifference_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (minimumInteriorCount anchorThreshold : Nat)
    (ell nonlocalityScale : ℝ) (profile : Nat → ℝ) :
    cutoffControlMeanSquareDifference D minimumInteriorCount anchorThreshold
        ell nonlocalityScale profile =
      cutoffControlMeanSquareDifference C minimumInteriorCount anchorThreshold
        ell nonlocalityScale profile := by
  apply maximumPackingMeanSquareDifference_equivariant e
  intro A
  exact cutoffControlScore_equivariant e A anchorThreshold
    ell nonlocalityScale profile

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator.induced_openIntervalCount_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator.induced_openIntervalCount_eq

/-- info: 'PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator.projectSmeared4DOperator_induced_eq_zeroExtend' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator.projectSmeared4DOperator_induced_eq_zeroExtend

/-- info: 'PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator.internalProtectedResidualScore_equivariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator.internalProtectedResidualScore_equivariant

/-- info: 'PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator.cutoffControlMeanSquareDifference_equivariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator.cutoffControlMeanSquareDifference_equivariant

end PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator
