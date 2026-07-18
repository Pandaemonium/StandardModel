import PhysicsSM.Draft.NullEdge.RankFourCarrierProbeSector

/-!
# Causal endpoint functional for carrier time orientation

A marked Alexandrov carrier already contains one directed datum that does not
require a tetrad: its causally ordered bottom and top endpoints.  This module
turns that order into the linear functional

```text
tau_A(f) = f(top_A) - f(bottom_A)
```

on the zero-sum carrier probe space and on every selected rank-four sector.
The functional is exactly equivariant under finite causal-order isomorphisms,
is nonzero on the full carrier probe space, and gives an intrinsic sign test
for the zeroth vector of a selected-sector frame.

This does not prove time orientability.  A selected sector can be blind to the
endpoint functional, and independently derived overlap transitions still must
preserve one global future component.  Those are explicit downstream gates.

Claim grade: `M [orig]`, finite order and linear algebra only.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CarrierCausalTimeFunctional

open AlexandrovAlgebraGerm
open AlexandrovGermInternalOperator
open FiniteCausalOrderOperator
open IntrinsicProbeSubspace
open RankFourProbeSector

variable {V W : Type} [Fintype V] [Fintype W]

/-- Distinctness of the marked causal endpoints, inherited from strict-order
irreflexivity. -/
theorem carrierTop_ne_carrierBottom
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) :
    Not (carrierTop A = carrierBottom A) := by
  intro h
  have hval : A.top = A.bottom := congrArg Subtype.val h
  exact C.irrefl A.bottom (hval ▸ A.bottom_before_top)

/-- Difference between the scalar probe values at the future and past
endpoints of a marked carrier. -/
def carrierEndpointContrast
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) :
    LinearMap (RingHom.id Real) (carrierProbeSubspace A) Real where
  toFun := fun f => f.1 (carrierTop A) - f.1 (carrierBottom A)
  map_add' := by
    intro f g
    simp
    ring
  map_smul' := by
    intro c f
    simp
    ring

/-- The endpoint-difference probe is a zero-sum field. -/
def endpointDifferenceProbe
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) :
    carrierProbeSubspace A := by
  classical
  refine ⟨Pi.single (carrierTop A) 1 - Pi.single (carrierBottom A) 1, ?_⟩
  rw [carrierProbeSubspace, zeroSumFieldSubspace, LinearMap.mem_ker]
  simp [fieldSumLinearMap]

/-- The causal endpoint functional is nonzero: the explicit endpoint
difference probe has contrast two. -/
theorem carrierEndpointContrast_endpointDifferenceProbe
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) :
    carrierEndpointContrast A (endpointDifferenceProbe A) = 2 := by
  classical
  simp [carrierEndpointContrast, endpointDifferenceProbe,
    carrierTop_ne_carrierBottom A]
  norm_num

theorem carrierEndpointContrast_ne_zero
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) :
    Not (carrierEndpointContrast A = 0) := by
  intro hzero
  have happ := congrArg
    (fun L => L (endpointDifferenceProbe A)) hzero
  change carrierEndpointContrast A (endpointDifferenceProbe A) = 0 at happ
  rw [carrierEndpointContrast_endpointDifferenceProbe] at happ
  norm_num at happ

/-- Restrict endpoint contrast to a selected rank-four probe sector. -/
def sectorEndpointContrast
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A) :
    LinearMap (RingHom.id Real) P.space Real :=
  (carrierEndpointContrast A).comp P.space.subtype

/-- A local selected-sector frame is future-signed when its zeroth vector has
positive causal endpoint contrast. -/
def IsFutureSignedFrame
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A) (b : SectorFrame P) : Prop :=
  0 < sectorEndpointContrast A P (b 0)

/-- Endpoint contrast is unchanged by every causal-order relabeling. -/
theorem carrierEndpointContrast_mapOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (f : carrierProbeSubspace A) :
    carrierEndpointContrast (A.map e) (carrierProbeLinearEquiv e A f) =
      carrierEndpointContrast A f := by
  have htop :
      (closedCarrierEquiv e A).symm (carrierTop (A.map e)) =
        carrierTop A := by
    apply Subtype.ext
    simp [closedCarrierEquiv, carrierTop, MarkedDiamond.map]
  have hbottom :
      (closedCarrierEquiv e A).symm (carrierBottom (A.map e)) =
        carrierBottom A := by
    apply Subtype.ext
    simp [closedCarrierEquiv, carrierBottom, MarkedDiamond.map]
  change
    (inducedOrderIso e A).relabelField f.1 (carrierTop (A.map e)) -
      (inducedOrderIso e A).relabelField f.1 (carrierBottom (A.map e)) =
    f.1 (carrierTop A) - f.1 (carrierBottom A)
  simp only [OrderIso.relabelField]
  change
    f.1 ((closedCarrierEquiv e A).symm (carrierTop (A.map e))) -
      f.1 ((closedCarrierEquiv e A).symm (carrierBottom (A.map e))) =
    f.1 (carrierTop A) - f.1 (carrierBottom A)
  rw [htop, hbottom]

/-- The restricted endpoint functional is equivariant on a transported
selected rank-four sector. -/
theorem sectorEndpointContrast_mapOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A) (f : P.space) :
    sectorEndpointContrast (A.map e) (P.mapOrderIso e)
        (sectorMapLinearEquiv e A P f) =
      sectorEndpointContrast A P f := by
  exact carrierEndpointContrast_mapOrderIso e A f.1

/-- Future-signing by causal endpoints is independent of event labels. -/
theorem isFutureSignedFrame_mapOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A) (b : SectorFrame P) :
    IsFutureSignedFrame (A.map e) (P.mapOrderIso e)
        (mapSectorFrame e A P b) <->
      IsFutureSignedFrame A P b := by
  unfold IsFutureSignedFrame
  change
    0 < sectorEndpointContrast (A.map e) (P.mapOrderIso e)
        (sectorMapLinearEquiv e A P (b 0)) <->
      0 < sectorEndpointContrast A P (b 0)
  rw [sectorEndpointContrast_mapOrderIso e A P (b 0)]

end PhysicsSM.Draft.NullEdge.CarrierCausalTimeFunctional

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.CarrierCausalTimeFunctional.carrierEndpointContrast_endpointDifferenceProbe' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CarrierCausalTimeFunctional.carrierEndpointContrast_endpointDifferenceProbe

/-- info: 'PhysicsSM.Draft.NullEdge.CarrierCausalTimeFunctional.carrierEndpointContrast_mapOrderIso' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CarrierCausalTimeFunctional.carrierEndpointContrast_mapOrderIso

/-- info: 'PhysicsSM.Draft.NullEdge.CarrierCausalTimeFunctional.isFutureSignedFrame_mapOrderIso' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CarrierCausalTimeFunctional.isFutureSignedFrame_mapOrderIso
