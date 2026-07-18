import PhysicsSM.Draft.NullEdge.EquivariantProbeSectorSelector
import PhysicsSM.Draft.NullEdge.OverlapRestrictionTransition

/-!
# Rank-four probe transitions on carrier overlaps

This module instantiates the basis-free overlap-transition theorem on actual
intersections of closed Alexandrov carriers.  A selected rank-four sector on
each carrier restricts to scalar observations on the shared ambient events.
If both restrictions are injective and have the same image, those observations
determine a unique linear equivalence between the local sectors.

For three carriers, the pairwise transitions satisfy the exact Cech cocycle
provided the triple overlap still separates the target rank-four sector.  The
same injectivity condition forces at least four events in the triple overlap.
Thus a sparse or collapsing nerve can now fail the cotangent-gluing gate for a
precise finite reason, before a tetrad, spin lift, or curvature is discussed.

No preferred frame is selected.  The graph still owes the rank-four sectors,
pairwise injectivity and equal-image conditions, sufficient triple overlaps,
Lorentzian inertia, and a refinement-limit bundle reconstruction.

Claim grade: `M [orig/comp]`.  Provenance: program-internal specialization of
`OverlapRestrictionTransition.lean` to the selected carrier sectors in
`RankFourCarrierProbeSector.lean`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition

open AlexandrovAlgebraGerm
open AlexandrovGermInternalOperator
open AlexandrovGermPacking
open FiniteCausalOrderOperator
open IntrinsicProbeSubspace
open OverlapRestrictionTransition
open RankFourProbeSector

variable {V : Type} [Fintype V]

/-! ## Pair overlaps and restriction maps -/

/-- Ambient events contained in both closed carriers. -/
def CarrierOverlap
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C) :=
  {x : V // inClosed A x ∧ inClosed B x}

noncomputable instance carrierOverlapFintype
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C) :
    Fintype (CarrierOverlap A B) := by
  classical
  unfold CarrierOverlap
  exact Subtype.fintype _

/-- Regard an overlap event as an event of the left carrier. -/
def overlapInLeft
    {C : FiniteCausalOrder V} {A B : MarkedDiamond C}
    (x : CarrierOverlap A B) : ClosedCarrier A :=
  ⟨x.1, x.2.1⟩

/-- Regard an overlap event as an event of the right carrier. -/
def overlapInRight
    {C : FiniteCausalOrder V} {A B : MarkedDiamond C}
    (x : CarrierOverlap A B) : ClosedCarrier B :=
  ⟨x.1, x.2.2⟩

/-- Restrict the left selected sector to scalar observations on the carrier
overlap. -/
def leftOverlapRestriction
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A) :
    P.space →ₗ[ℝ] (CarrierOverlap A B → ℝ) where
  toFun phi := fun x => phi.1.1 (overlapInLeft x)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Restrict the right selected sector to scalar observations on the same
carrier overlap. -/
def rightOverlapRestriction
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C)
    (Q : RankFourCarrierProbeSector B) :
    Q.space →ₗ[ℝ] (CarrierOverlap A B → ℝ) where
  toFun phi := fun x => phi.1.1 (overlapInRight x)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Exact finite hypotheses under which one carrier overlap determines a
transition between two selected rank-four sectors. -/
structure PairOverlapCompatible
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (Q : RankFourCarrierProbeSector B) : Prop where
  left_injective : Function.Injective (leftOverlapRestriction A B P)
  right_injective : Function.Injective (rightOverlapRestriction A B Q)
  range_eq : LinearMap.range (leftOverlapRestriction A B P) =
    LinearMap.range (rightOverlapRestriction A B Q)

/-- The unique basis-free transition induced by compatible scalar
observations on a pair overlap. -/
def pairTransition
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (Q : RankFourCarrierProbeSector B)
    (H : PairOverlapCompatible A B P Q) : P.space ≃ₗ[ℝ] Q.space :=
  overlapTransition
    (leftOverlapRestriction A B P) (rightOverlapRestriction A B Q)
    H.left_injective H.right_injective H.range_eq

/-- The derived pair transition preserves every scalar observation on the
shared carrier events. -/
theorem pairTransition_spec
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (Q : RankFourCarrierProbeSector B)
    (H : PairOverlapCompatible A B P Q) (phi : P.space) :
    rightOverlapRestriction A B Q (pairTransition A B P Q H phi) =
      leftOverlapRestriction A B P phi := by
  exact overlapTransition_spec
    (leftOverlapRestriction A B P) (rightOverlapRestriction A B Q)
    H.left_injective H.right_injective H.range_eq phi

/-! ## Metric compatibility on a pair overlap -/

/-- If both selected-sector forms are pullbacks of one bilinear form on the
common overlap observations, the derived pair transition is an exact
isometry.  This is an additional metric-gluing hypothesis, not a consequence
of equal restriction images alone. -/
theorem pairTransition_isometry_of_common_overlap_form
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (Q : RankFourCarrierProbeSector B)
    (H : PairOverlapCompatible A B P Q)
    (ell nonlocalityScale : ℝ) (xA : ClosedCarrier A)
    (xB : ClosedCarrier B)
    (overlapForm : LinearMap.BilinForm ℝ (CarrierOverlap A B → ℝ))
    (hleft : sectorBilinForm A P ell nonlocalityScale xA =
      pulledForm overlapForm (leftOverlapRestriction A B P))
    (hright : sectorBilinForm B Q ell nonlocalityScale xB =
      pulledForm overlapForm (rightOverlapRestriction A B Q))
    (phi psi : P.space) :
    sectorBilinForm B Q ell nonlocalityScale xB
        (pairTransition A B P Q H phi)
        (pairTransition A B P Q H psi) =
      sectorBilinForm A P ell nonlocalityScale xA phi psi := by
  rw [hright, hleft]
  exact overlapTransition_isometry overlapForm
    (leftOverlapRestriction A B P) (rightOverlapRestriction A B Q)
    H.left_injective H.right_injective H.range_eq phi psi

/-- Under a common overlap form, pushing a frame by the derived transition
leaves its selected-sector Gram matrix exactly unchanged. -/
theorem sectorGram_pairTransition
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (Q : RankFourCarrierProbeSector B)
    (H : PairOverlapCompatible A B P Q)
    (ell nonlocalityScale : ℝ) (xA : ClosedCarrier A)
    (xB : ClosedCarrier B)
    (overlapForm : LinearMap.BilinForm ℝ (CarrierOverlap A B → ℝ))
    (hleft : sectorBilinForm A P ell nonlocalityScale xA =
      pulledForm overlapForm (leftOverlapRestriction A B P))
    (hright : sectorBilinForm B Q ell nonlocalityScale xB =
      pulledForm overlapForm (rightOverlapRestriction A B Q))
    (b : SectorFrame P) :
    sectorGram B Q ell nonlocalityScale xB
        (b.map (pairTransition A B P Q H)) =
      sectorGram A P ell nonlocalityScale xA b := by
  ext i j
  rw [sectorGram_apply, sectorGram_apply]
  simpa only [sectorBilinForm_apply] using
    pairTransition_isometry_of_common_overlap_form A B P Q H
      ell nonlocalityScale xA xB overlapForm hleft hright (b i) (b j)

/-- Lorentzian inertia propagates across a metric-compatible overlap.  This
does not prove that either local form has Lorentzian inertia; it proves that
one verified chart transfers the property to its compatible neighbor. -/
theorem hasSectorLorentzianInertia_of_pairTransition
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (Q : RankFourCarrierProbeSector B)
    (H : PairOverlapCompatible A B P Q)
    (ell nonlocalityScale : ℝ) (xA : ClosedCarrier A)
    (xB : ClosedCarrier B)
    (overlapForm : LinearMap.BilinForm ℝ (CarrierOverlap A B → ℝ))
    (hleft : sectorBilinForm A P ell nonlocalityScale xA =
      pulledForm overlapForm (leftOverlapRestriction A B P))
    (hright : sectorBilinForm B Q ell nonlocalityScale xB =
      pulledForm overlapForm (rightOverlapRestriction A B Q))
    (hLorentz : HasSectorLorentzianInertia A P ell nonlocalityScale xA) :
    HasSectorLorentzianInertia B Q ell nonlocalityScale xB := by
  rcases hLorentz with ⟨b, hb⟩
  refine ⟨b.map (pairTransition A B P Q H), ?_⟩
  unfold IsSectorLorentzNormalized at hb ⊢
  rw [sectorGram_pairTransition A B P Q H ell nonlocalityScale xA xB
    overlapForm hleft hright]
  exact hb

/-- Matrix comparing the transported source frame with a chosen target frame
on the right selected sector. -/
def pairFrameTransitionMatrix
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (Q : RankFourCarrierProbeSector B)
    (H : PairOverlapCompatible A B P Q)
    (b : SectorFrame P) (c : SectorFrame Q) :
    Matrix (Fin 4) (Fin 4) ℝ :=
  (b.map (pairTransition A B P Q H)).toMatrix c

/-- With metric-compatible overlap data and Lorentz-normalized local frames,
the induced frame-transition matrix is exactly `eta`-orthogonal.  This proves
membership in `O(1,3)` at the matrix-identity level; orientation and
time-orientation are still separate gates before a proper-orthochronous or
spin-lift claim. -/
theorem pairFrameTransitionMatrix_lorentz
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (Q : RankFourCarrierProbeSector B)
    (H : PairOverlapCompatible A B P Q)
    (ell nonlocalityScale : ℝ) (xA : ClosedCarrier A)
    (xB : ClosedCarrier B)
    (overlapForm : LinearMap.BilinForm ℝ (CarrierOverlap A B → ℝ))
    (hleft : sectorBilinForm A P ell nonlocalityScale xA =
      pulledForm overlapForm (leftOverlapRestriction A B P))
    (hright : sectorBilinForm B Q ell nonlocalityScale xB =
      pulledForm overlapForm (rightOverlapRestriction A B Q))
    (b : SectorFrame P) (c : SectorFrame Q)
    (hb : IsSectorLorentzNormalized A P ell nonlocalityScale xA b)
    (hc : IsSectorLorentzNormalized B Q ell nonlocalityScale xB c) :
    Matrix.transpose (pairFrameTransitionMatrix A B P Q H b c) *
        (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ) *
        pairFrameTransitionMatrix A B P Q H b c =
      MinkowskiConvention.eta := by
  have htransported : IsSectorLorentzNormalized B Q ell nonlocalityScale xB
      (b.map (pairTransition A B P Q H)) := by
    unfold IsSectorLorentzNormalized at hb ⊢
    rw [sectorGram_pairTransition A B P Q H ell nonlocalityScale xA xB
      overlapForm hleft hright]
    exact hb
  exact (isSectorLorentzNormalized_change_iff B Q ell nonlocalityScale xB
    (b.map (pairTransition A B P Q H)) c htransported).1 hc

/-- Every metric-compatible normalized frame transition has determinant
`+1` or `-1`.  Selecting the proper component therefore requires an additional
orientation condition; eta-orthogonality alone does not supply it. -/
theorem pairFrameTransitionMatrix_det_eq_one_or_neg_one
    {C : FiniteCausalOrder V} (A B : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (Q : RankFourCarrierProbeSector B)
    (H : PairOverlapCompatible A B P Q)
    (ell nonlocalityScale : ℝ) (xA : ClosedCarrier A)
    (xB : ClosedCarrier B)
    (overlapForm : LinearMap.BilinForm ℝ (CarrierOverlap A B → ℝ))
    (hleft : sectorBilinForm A P ell nonlocalityScale xA =
      pulledForm overlapForm (leftOverlapRestriction A B P))
    (hright : sectorBilinForm B Q ell nonlocalityScale xB =
      pulledForm overlapForm (rightOverlapRestriction A B Q))
    (b : SectorFrame P) (c : SectorFrame Q)
    (hb : IsSectorLorentzNormalized A P ell nonlocalityScale xA b)
    (hc : IsSectorLorentzNormalized B Q ell nonlocalityScale xB c) :
    (pairFrameTransitionMatrix A B P Q H b c).det = 1 ∨
      (pairFrameTransitionMatrix A B P Q H b c).det = -1 := by
  have hLorentz := pairFrameTransitionMatrix_lorentz A B P Q H
    ell nonlocalityScale xA xB overlapForm hleft hright b c hb hc
  have hdet := congrArg Matrix.det hLorentz
  simp only [Matrix.det_mul, Matrix.det_transpose] at hdet
  rw [MinkowskiConvention.eta_det] at hdet
  let d := (pairFrameTransitionMatrix A B P Q H b c).det
  have hfactor : (d - 1) * (d + 1) = 0 := by
    dsimp [d]
    nlinarith
  rcases mul_eq_zero.mp hfactor with hplus | hminus
  · left
    dsimp [d] at hplus ⊢
    linarith
  · right
    dsimp [d] at hminus ⊢
    linarith

/-! ## Triple overlaps and the exact Cech cocycle -/

/-- Ambient events simultaneously contained in three closed carriers. -/
def CarrierTripleOverlap
    {C : FiniteCausalOrder V} (A B D : MarkedDiamond C) :=
  {x : V // inClosed A x ∧ inClosed B x ∧ inClosed D x}

noncomputable instance carrierTripleOverlapFintype
    {C : FiniteCausalOrder V} (A B D : MarkedDiamond C) :
    Fintype (CarrierTripleOverlap A B D) := by
  classical
  unfold CarrierTripleOverlap
  exact Subtype.fintype _

/-- Forget the third membership witness from a triple-overlap event. -/
def tripleToAB
    {C : FiniteCausalOrder V} {A B D : MarkedDiamond C}
    (x : CarrierTripleOverlap A B D) : CarrierOverlap A B :=
  ⟨x.1, x.2.1, x.2.2.1⟩

/-- Regard a triple-overlap event as an event of the `B-D` pair overlap. -/
def tripleToBD
    {C : FiniteCausalOrder V} {A B D : MarkedDiamond C}
    (x : CarrierTripleOverlap A B D) : CarrierOverlap B D :=
  ⟨x.1, x.2.2.1, x.2.2.2⟩

/-- Regard a triple-overlap event as an event of the `A-D` pair overlap. -/
def tripleToAD
    {C : FiniteCausalOrder V} {A B D : MarkedDiamond C}
    (x : CarrierTripleOverlap A B D) : CarrierOverlap A D :=
  ⟨x.1, x.2.1, x.2.2.2⟩

/-- Restrict the third carrier's selected sector to the common triple
overlap. -/
def thirdTripleRestriction
    {C : FiniteCausalOrder V} (A B D : MarkedDiamond C)
    (R : RankFourCarrierProbeSector D) :
    R.space →ₗ[ℝ] (CarrierTripleOverlap A B D → ℝ) where
  toFun phi := fun x => phi.1.1 ⟨x.1, x.2.2.2⟩
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- **Concrete atlas cocycle gate.** Pairwise overlap transitions obey the
exact Cech cocycle when the common triple overlap separates the target
rank-four sector. -/
theorem pairTransition_cocycle_of_triple_separates
    {C : FiniteCausalOrder V} (A B D : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (Q : RankFourCarrierProbeSector B)
    (R : RankFourCarrierProbeSector D)
    (HAB : PairOverlapCompatible A B P Q)
    (HBD : PairOverlapCompatible B D Q R)
    (HAD : PairOverlapCompatible A D P R)
    (htriple : Function.Injective (thirdTripleRestriction A B D R)) :
    (pairTransition A B P Q HAB).trans
        (pairTransition B D Q R HBD) =
      pairTransition A D P R HAD := by
  apply LinearEquiv.ext
  intro phi
  apply htriple
  funext x
  have hBDx := congrFun
    (pairTransition_spec B D Q R HBD
      (pairTransition A B P Q HAB phi)) (tripleToBD x)
  have hABx := congrFun
    (pairTransition_spec A B P Q HAB phi) (tripleToAB x)
  have hADx := congrFun
    (pairTransition_spec A D P R HAD phi) (tripleToAD x)
  exact hBDx.trans (hABx.trans hADx.symm)

/-- A triple overlap that separates a rank-four target sector must contain at
least four events. -/
theorem four_le_card_of_triple_separates
    {C : FiniteCausalOrder V} (A B D : MarkedDiamond C)
    (R : RankFourCarrierProbeSector D)
    (htriple : Function.Injective (thirdTripleRestriction A B D R)) :
    4 ≤ Fintype.card (CarrierTripleOverlap A B D) := by
  have hdim := (thirdTripleRestriction A B D R).finrank_le_finrank_of_injective
    htriple
  rw [R.finrank_eq_four] at hdim
  simpa [Module.finrank_pi] using hdim

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition.pairTransition_spec' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition.pairTransition_spec

/-- info: 'PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition.hasSectorLorentzianInertia_of_pairTransition' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition.hasSectorLorentzianInertia_of_pairTransition

/-- info: 'PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition.pairFrameTransitionMatrix_lorentz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition.pairFrameTransitionMatrix_lorentz

/-- info: 'PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition.pairFrameTransitionMatrix_det_eq_one_or_neg_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition.pairFrameTransitionMatrix_det_eq_one_or_neg_one

/-- info: 'PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition.pairTransition_cocycle_of_triple_separates' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition.pairTransition_cocycle_of_triple_separates

/-- info: 'PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition.four_le_card_of_triple_separates' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition.four_le_card_of_triple_separates

end PhysicsSM.Draft.NullEdge.CarrierProbeOverlapTransition
