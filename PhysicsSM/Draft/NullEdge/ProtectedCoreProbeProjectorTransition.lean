import PhysicsSM.Draft.NullEdge.EquivariantProbeSectorSelector
import PhysicsSM.Draft.NullEdge.OverlapRestrictionTransition
import PhysicsSM.Draft.NullEdge.ProtectedCoreAtlasNerve

/-!
# Rank-four projector transitions on protected-core overlaps

The active growing-atlas lane defines chart overlap by literal intersection of
protected cores. Earlier probe-transition results instead used intersections
of whole closed carriers. This module puts the rank-four projector interface on
the overlap used by the active atlas.

Two local rank-four projectors are compared with one supplied projector on the
shared protected-core observation space. If restriction intertwines each local
projector with the shared projector, and every shared projected observation
lifts to both carrier probe spaces, the two selected sectors have equal overlap
images. Restricted injectivity then gives the exact input needed for a unique
basis-free transition.

The equal-image conclusion is derived, not assumed. The module still does not
construct the local or overlap projectors, prove restricted injectivity, derive
Lorentzian inertia, or establish refinement convergence. Those remain explicit
graph-reconstruction gates.

Claim grade: `M [orig/comp]`. Provenance: program-internal composition of the
protected-core atlas, equivariant range-sector selector, and overlap-transition
interfaces.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ProtectedCoreProbeProjectorTransition

open AlexandrovAlgebraGerm
open AlexandrovGermInternalOperator
open AlexandrovGermPacking
open EquivariantProbeSectorSelector
open FiniteCausalOrderOperator
open IntrinsicProbeSubspace
open OverlapRestrictionTransition
open ProtectedCoreAtlasNerve
open RankFourProbeSector

variable {V I : Type} [Fintype V]

/-! ## A general shared-projector range lemma -/

section SharedProjector

variable {M O : Type*}
  [AddCommGroup M] [Module Real M]
  [AddCommGroup O] [Module Real O]

/-- Restrict an observation map to the range selected by an endomorphism. -/
def rangeRestriction (P : M →ₗ[Real] M) (r : M →ₗ[Real] O) :
    LinearMap.range P →ₗ[Real] O :=
  r.domRestrict (LinearMap.range P)

/-- A commuting restriction square and liftability of the shared projected
range identify the selected local observation image with the shared image. -/
theorem range_rangeRestriction_eq_range_shared
    (P : M →ₗ[Real] M) (S : O →ₗ[Real] O) (r : M →ₗ[Real] O)
    (shared_idempotent : forall y, S (S y) = S y)
    (intertwines : forall x, r (P x) = S (r x))
    (shared_range_lifts : LinearMap.range S <= LinearMap.range r) :
    LinearMap.range (rangeRestriction P r) = LinearMap.range S := by
  apply le_antisymm
  · rintro y ⟨z, rfl⟩
    rcases z.2 with ⟨x, hx⟩
    refine ⟨r x, ?_⟩
    change S (r x) = r z.1
    rw [← intertwines x, hx]
  · rintro y ⟨w, rfl⟩
    have hshared : S w ∈ LinearMap.range S := ⟨w, rfl⟩
    rcases shared_range_lifts hshared with ⟨x, hx⟩
    refine ⟨⟨P x, ⟨x, rfl⟩⟩, ?_⟩
    change r (P x) = S w
    rw [intertwines x, hx, shared_idempotent w]

end SharedProjector

/-! ## The actual protected-core overlap -/

/-- Events lying in both protected cores of two charts in one atlas. -/
def ProtectedCorePairOverlap
    {C : FiniteCausalOrder V} (A : ProtectedCoreAtlas C I) (i j : I) :=
  {x : V // A.coreAt i x ∧ A.coreAt j x}

noncomputable instance protectedCorePairOverlapFintype
    {C : FiniteCausalOrder V} (A : ProtectedCoreAtlas C I) (i j : I) :
    Fintype (ProtectedCorePairOverlap A i j) := by
  classical
  unfold ProtectedCorePairOverlap
  exact Subtype.fintype _

/-- Regard a protected-overlap event as an event of the left closed carrier. -/
def overlapInLeftCarrier
    {C : FiniteCausalOrder V} {A : ProtectedCoreAtlas C I} {i j : I}
    (x : ProtectedCorePairOverlap A i j) : ClosedCarrier (A.chart i) :=
  ⟨x.1, Or.inr (Or.inr x.2.1.1)⟩

/-- Regard a protected-overlap event as an event of the right closed carrier. -/
def overlapInRightCarrier
    {C : FiniteCausalOrder V} {A : ProtectedCoreAtlas C I} {i j : I}
    (x : ProtectedCorePairOverlap A i j) : ClosedCarrier (A.chart j) :=
  ⟨x.1, Or.inr (Or.inr x.2.2.1)⟩

/-- Restrict every left carrier probe to the actual protected-core overlap. -/
def leftFullRestriction
    {C : FiniteCausalOrder V} (A : ProtectedCoreAtlas C I) (i j : I) :
    carrierProbeSubspace (A.chart i) →ₗ[Real]
      (ProtectedCorePairOverlap A i j -> Real) where
  toFun phi := fun x => phi.1 (overlapInLeftCarrier x)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Restrict every right carrier probe to the same protected-core overlap. -/
def rightFullRestriction
    {C : FiniteCausalOrder V} (A : ProtectedCoreAtlas C I) (i j : I) :
    carrierProbeSubspace (A.chart j) →ₗ[Real]
      (ProtectedCorePairOverlap A i j -> Real) where
  toFun phi := fun x => phi.1 (overlapInRightCarrier x)
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Restriction of the left projector-selected rank-four sector. -/
def leftProjectorRestriction
    {C : FiniteCausalOrder V} (A : ProtectedCoreAtlas C I) (i j : I)
    (P : RankFourProbeProjector (A.chart i)) :
    P.sector.space →ₗ[Real] (ProtectedCorePairOverlap A i j -> Real) :=
  rangeRestriction P.project (leftFullRestriction A i j)

/-- Restriction of the right projector-selected rank-four sector. -/
def rightProjectorRestriction
    {C : FiniteCausalOrder V} (A : ProtectedCoreAtlas C I) (i j : I)
    (Q : RankFourProbeProjector (A.chart j)) :
    Q.sector.space →ₗ[Real] (ProtectedCorePairOverlap A i j -> Real) :=
  rangeRestriction Q.project (rightFullRestriction A i j)

/-- Exact protected-core overlap hypotheses needed for a transition after the
equal-image property has been derived. -/
structure ProtectedCorePairOverlapCompatible
    {C : FiniteCausalOrder V} (A : ProtectedCoreAtlas C I) (i j : I)
    (P : RankFourProbeProjector (A.chart i))
    (Q : RankFourProbeProjector (A.chart j)) : Prop where
  left_injective : Function.Injective (leftProjectorRestriction A i j P)
  right_injective : Function.Injective (rightProjectorRestriction A i j Q)
  range_eq : LinearMap.range (leftProjectorRestriction A i j P) =
    LinearMap.range (rightProjectorRestriction A i j Q)

/-- Shared protected-core projector data derive equal selected-sector images.
Unlike the generic compatibility package, this theorem does not accept image
equality as a hypothesis. -/
theorem projectorSector_pairOverlapCompatible_of_protectedCore_intertwining
    {C : FiniteCausalOrder V} (A : ProtectedCoreAtlas C I) (i j : I)
    (P : RankFourProbeProjector (A.chart i))
    (Q : RankFourProbeProjector (A.chart j))
    (S : (ProtectedCorePairOverlap A i j -> Real) →ₗ[Real]
      (ProtectedCorePairOverlap A i j -> Real))
    (shared_idempotent : forall y, S (S y) = S y)
    (left_intertwines : forall phi,
      leftFullRestriction A i j (P.project phi) =
        S (leftFullRestriction A i j phi))
    (right_intertwines : forall phi,
      rightFullRestriction A i j (Q.project phi) =
        S (rightFullRestriction A i j phi))
    (shared_range_lifts_left :
      LinearMap.range S <= LinearMap.range (leftFullRestriction A i j))
    (shared_range_lifts_right :
      LinearMap.range S <= LinearMap.range (rightFullRestriction A i j))
    (left_injective : Function.Injective (leftProjectorRestriction A i j P))
    (right_injective :
      Function.Injective (rightProjectorRestriction A i j Q)) :
    ProtectedCorePairOverlapCompatible A i j P Q := by
  refine ⟨left_injective, right_injective, ?_⟩
  exact (range_rangeRestriction_eq_range_shared P.project S
    (leftFullRestriction A i j) shared_idempotent left_intertwines
    shared_range_lifts_left).trans
      (range_rangeRestriction_eq_range_shared Q.project S
        (rightFullRestriction A i j) shared_idempotent right_intertwines
        shared_range_lifts_right).symm

/-- The unique basis-free transition obtained from the derived protected-core
compatibility package. -/
def protectedCorePairTransition
    {C : FiniteCausalOrder V} (A : ProtectedCoreAtlas C I) (i j : I)
    (P : RankFourProbeProjector (A.chart i))
    (Q : RankFourProbeProjector (A.chart j))
    (H : ProtectedCorePairOverlapCompatible A i j P Q) :
    P.sector.space ≃ₗ[Real] Q.sector.space :=
  overlapTransition
    (leftProjectorRestriction A i j P) (rightProjectorRestriction A i j Q)
    H.left_injective H.right_injective H.range_eq

/-- The protected-core transition is characterized by equality of actual
overlap observations. -/
theorem protectedCorePairTransition_spec
    {C : FiniteCausalOrder V} (A : ProtectedCoreAtlas C I) (i j : I)
    (P : RankFourProbeProjector (A.chart i))
    (Q : RankFourProbeProjector (A.chart j))
    (H : ProtectedCorePairOverlapCompatible A i j P Q)
    (phi : P.sector.space) :
    rightProjectorRestriction A i j Q
        (protectedCorePairTransition A i j P Q H phi) =
      leftProjectorRestriction A i j P phi := by
  exact overlapTransition_spec
    (leftProjectorRestriction A i j P) (rightProjectorRestriction A i j Q)
    H.left_injective H.right_injective H.range_eq phi

/-- Restricted injectivity forces at least four events in the protected-core
overlap, giving a concrete nonvacuity gate. -/
theorem four_le_card_of_leftProjectorRestriction_injective
    {C : FiniteCausalOrder V} (A : ProtectedCoreAtlas C I) (i j : I)
    (P : RankFourProbeProjector (A.chart i))
    (hinjective : Function.Injective (leftProjectorRestriction A i j P)) :
    4 <= Fintype.card (ProtectedCorePairOverlap A i j) := by
  have hdim :=
    (leftProjectorRestriction A i j P).finrank_le_finrank_of_injective
      hinjective
  rw [P.sector.finrank_eq_four] at hdim
  simpa [Module.finrank_pi] using hdim

end PhysicsSM.Draft.NullEdge.ProtectedCoreProbeProjectorTransition

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ProtectedCoreProbeProjectorTransition.range_rangeRestriction_eq_range_shared' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProtectedCoreProbeProjectorTransition.range_rangeRestriction_eq_range_shared

/-- info: 'PhysicsSM.Draft.NullEdge.ProtectedCoreProbeProjectorTransition.projectorSector_pairOverlapCompatible_of_protectedCore_intertwining' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProtectedCoreProbeProjectorTransition.projectorSector_pairOverlapCompatible_of_protectedCore_intertwining

/-- info: 'PhysicsSM.Draft.NullEdge.ProtectedCoreProbeProjectorTransition.protectedCorePairTransition_spec' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProtectedCoreProbeProjectorTransition.protectedCorePairTransition_spec

/-- info: 'PhysicsSM.Draft.NullEdge.ProtectedCoreProbeProjectorTransition.four_le_card_of_leftProjectorRestriction_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProtectedCoreProbeProjectorTransition.four_le_card_of_leftProjectorRestriction_injective
