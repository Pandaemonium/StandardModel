import PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator

/-!
# Intrinsic scalar-probe subspaces without a preferred basis

An individually natural ordered probe list is fixed pointwise by every order
automorphism.  `FiniteCausalOrderOperator.lean` already proves that such probes
are constant on automorphism-transitive orders.  This module implements the
required escape: a probe **subspace** is transported under relabeling, while a
basis inside that subspace is gauge-relative and need not be fixed.

The canonical finite example is the zero-sum scalar-field subspace.  Relabeling
is a linear equivalence of scalar-field spaces and preserves the total sum, so
the zero-sum subspace is exactly natural under every finite-order isomorphism.
On the five-event antichain this subspace has real dimension four.  In contrast,
every individually natural probe that is also zero-sum vanishes there.  This
is an exact positive/negative split: bare-order symmetry permits a rank-four
probe space but forbids a canonical ordered basis of nonzero probes.

For a closed Alexandrov carrier, the same subspace feeds directly into the
induced smeared causal-operator corrected pairing.  The pairing is symmetric
and relabels exactly with the subspace.  No basis, coordinates, tetrad, or
target metric enters this statement.

The five-event antichain is a representation-theoretic control, not a physical
spacetime reconstruction.  Rank four there follows from carrier cardinality,
not causal dimension, and the module proves neither Lorentzian signature nor
slowly varying affine probes on a refinement family.

Claim grade: `M [orig]` for the finite linear-algebra and covariance results.
Provenance: program-internal response to the intrinsic ordered-probe
automorphism obstruction in `FiniteCausalOrderOperator.lean`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace

open scoped BigOperators

open AlexandrovAlgebraGerm
open AlexandrovGermPacking
open AlexandrovGermInternalOperator
open FiniteCausalOrderOperator

variable {V W : Type} [Fintype V] [Fintype W]

/-! ## Linear relabeling and zero-sum fields -/

/-- Relabeling scalar fields along an order isomorphism is a real-linear
equivalence. -/
def fieldRelabelLinearEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) : (V → ℝ) ≃ₗ[ℝ] (W → ℝ) where
  toFun := e.relabelField
  invFun := (reverseOrderIso e).relabelField
  left_inv phi := by
    funext x
    simp [OrderIso.relabelField, reverseOrderIso]
  right_inv psi := by
    funext y
    simp [OrderIso.relabelField, reverseOrderIso]
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Total scalar-field sum as a linear functional. -/
def fieldSumLinearMap (U : Type*) [Fintype U] : (U → ℝ) →ₗ[ℝ] ℝ where
  toFun phi := ∑ x : U, phi x
  map_add' phi psi := by
    simp [Finset.sum_add_distrib]
  map_smul' c phi := by
    simp [Finset.mul_sum]

/-- Canonical codimension-one candidate probe space: scalar fields with zero
total sum. -/
def zeroSumFieldSubspace (U : Type*) [Fintype U] :
    Submodule ℝ (U → ℝ) :=
  LinearMap.ker (fieldSumLinearMap U)

/-- Relabeling preserves the total field sum. -/
theorem fieldSum_relabel
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (phi : V → ℝ) :
    fieldSumLinearMap W (e.relabelField phi) =
      fieldSumLinearMap V phi := by
  unfold fieldSumLinearMap
  symm
  apply Fintype.sum_equiv e.toEquiv
  intro x
  simp only [OrderIso.relabelField_apply]

/-- Membership in the zero-sum subspace is exactly preserved by relabeling. -/
theorem mem_zeroSum_relabel_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (phi : V → ℝ) :
    e.relabelField phi ∈ zeroSumFieldSubspace W ↔
      phi ∈ zeroSumFieldSubspace V := by
  simp [zeroSumFieldSubspace, LinearMap.mem_ker, fieldSum_relabel]

/-! ## Basis-free intrinsic probe sectors -/

/-- A relabeling-natural scalar-probe subspace.  Unlike
`IntrinsicProbeSector`, this interface does not require individual basis
vectors to be fixed by automorphisms. -/
structure IntrinsicProbeSubspaceSector where
  space : ∀ {U : Type} [Fintype U],
    FiniteCausalOrder U → Submodule ℝ (U → ℝ)
  equivariant : ∀ {U Z : Type} [Fintype U] [Fintype Z]
    {C : FiniteCausalOrder U} {D : FiniteCausalOrder Z}
    (e : OrderIso C D) (phi : U → ℝ),
    phi ∈ @space U _ C ↔ e.relabelField phi ∈ @space Z _ D

/-- The zero-sum field assignment is an intrinsic probe-subspace sector. -/
def zeroSumProbeSector : IntrinsicProbeSubspaceSector where
  space := fun {U} _ _ => zeroSumFieldSubspace U
  equivariant := fun e phi => (mem_zeroSum_relabel_iff e phi).symm

/-- The subspace-level covariance law can equivalently be stated as exact
equality after `Submodule.map`. -/
theorem IntrinsicProbeSubspaceSector.map_space_eq
    (P : IntrinsicProbeSubspaceSector)
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) :
    (P.space C).map (fieldRelabelLinearEquiv e).toLinearMap =
      P.space D := by
  ext psi
  constructor
  · rintro ⟨phi, hphi, rfl⟩
    exact (P.equivariant e phi).1 hphi
  · intro hpsi
    let phi : V → ℝ := (fieldRelabelLinearEquiv e).symm psi
    have hphi : phi ∈ P.space C := by
      apply (P.equivariant e phi).2
      change fieldRelabelLinearEquiv e
        ((fieldRelabelLinearEquiv e).symm psi) ∈ P.space D
      simpa using hpsi
    exact ⟨phi, hphi, by simp [phi]⟩

/-- Relabeling restricts to a linear equivalence between the two natural
probe subspaces. -/
def IntrinsicProbeSubspaceSector.spaceLinearEquiv
    (P : IntrinsicProbeSubspaceSector)
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) : P.space C ≃ₗ[ℝ] P.space D where
  toFun phi := ⟨e.relabelField phi.1, (P.equivariant e phi.1).1 phi.2⟩
  invFun psi :=
    ⟨(reverseOrderIso e).relabelField psi.1,
      (P.equivariant (reverseOrderIso e) psi.1).1 psi.2⟩
  left_inv phi := by
    apply Subtype.ext
    funext x
    simp [OrderIso.relabelField, reverseOrderIso]
  right_inv psi := by
    apply Subtype.ext
    funext y
    simp [OrderIso.relabelField, reverseOrderIso]
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-! ## Symmetric controls and the rank-four split -/

/-- The antichain on five events, with full permutation symmetry. -/
def fiveEventAntichain : FiniteCausalOrder (Fin 5) where
  before := fun _ _ => False
  decidableBefore := inferInstance
  irrefl := by simp
  trans := by simp

/-- Every event of the five-event antichain lies in one automorphism orbit. -/
theorem fiveEventAntichain_automorphismTransitive :
    fiveEventAntichain.AutomorphismTransitive := by
  intro x y
  let swap : Fin 5 ≃ Fin 5 := Equiv.swap x y
  refine ⟨{
    toEquiv := swap
    map_before_iff := ?_
  }, ?_⟩
  · intro a b
    simp [fiveEventAntichain]
  · simp [swap]

/-- The total-sum functional on five events is onto. -/
theorem finFive_fieldSum_surjective :
    Function.Surjective (fieldSumLinearMap (Fin 5)) := by
  intro value
  refine ⟨fun x => if x = 0 then value else 0, ?_⟩
  simp [fieldSumLinearMap]

/-- The canonical zero-sum probe subspace on five events has dimension four. -/
theorem finrank_fiveEvent_zeroSum :
    Module.finrank ℝ (zeroSumFieldSubspace (Fin 5)) = 4 := by
  have hrange : LinearMap.range (fieldSumLinearMap (Fin 5)) = ⊤ :=
    LinearMap.range_eq_top.2 finFive_fieldSum_surjective
  have hrank :=
    LinearMap.finrank_range_add_finrank_ker (fieldSumLinearMap (Fin 5))
  rw [hrange] at hrank
  simp [zeroSumFieldSubspace] at hrank ⊢
  omega

/-- On the same symmetric order, an individually natural probe that is also
zero-sum must vanish pointwise. -/
theorem intrinsicProbe_zero_of_fiveEvent_meanZero
    {r : Nat} (P : IntrinsicProbeSector r) (a : Fin r)
    (hzeroSum : P.probe fiveEventAntichain a ∈
      zeroSumFieldSubspace (Fin 5)) (x : Fin 5) :
    P.probe fiveEventAntichain a x = 0 := by
  have hconstant : ∀ y : Fin 5,
      P.probe fiveEventAntichain a y =
        P.probe fiveEventAntichain a 0 := by
    intro y
    exact P.probe_constant_of_automorphismTransitive fiveEventAntichain
      fiveEventAntichain_automorphismTransitive a y 0
  have hsum :
      (∑ y : Fin 5, P.probe fiveEventAntichain a y) = 0 := by
    exact hzeroSum
  simp_rw [hconstant] at hsum
  have hbase : P.probe fiveEventAntichain a 0 = 0 := by
    norm_num at hsum ⊢
    exact hsum
  rw [hconstant x, hbase]

/-- The positive/negative split on the five-event symmetric control: the
natural zero-sum subspace has rank four, while every individually natural
zero-sum probe vanishes. -/
theorem fiveEvent_rankFour_subspace_but_no_natural_vectors
    {r : Nat} (P : IntrinsicProbeSector r)
    (hzeroSum : ∀ a, P.probe fiveEventAntichain a ∈
      zeroSumFieldSubspace (Fin 5)) :
    Module.finrank ℝ (zeroSumProbeSector.space fiveEventAntichain) = 4 ∧
      ∀ a x, P.probe fiveEventAntichain a x = 0 := by
  constructor
  · exact finrank_fiveEvent_zeroSum
  · intro a x
    exact intrinsicProbe_zero_of_fiveEvent_meanZero P a (hzeroSum a) x

/-! ## Basis-free carrier pairing -/

/-- Zero-sum probe subspace on one closed Alexandrov carrier. -/
def carrierProbeSubspace
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) :
    Submodule ℝ (ClosedCarrier A → ℝ) :=
  zeroSumFieldSubspace (ClosedCarrier A)

/-- Corrected causal-operator pairing restricted to the basis-free carrier
probe subspace. -/
def carrierProbePairing
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (f h : carrierProbeSubspace A) : ℝ :=
  correctedPairingAt
    (projectSmeared4DOperator (inducedOrder A) ell nonlocalityScale)
    x f.1 h.1

/-- The restricted pairing remains symmetric without a chosen probe basis. -/
theorem carrierProbePairing_comm
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (f h : carrierProbeSubspace A) :
    carrierProbePairing A ell nonlocalityScale x f h =
      carrierProbePairing A ell nonlocalityScale x h f := by
  exact correctedPairingAt_comm _ _ _ _

/-- Relabeling equivalence between zero-sum probe subspaces of isomorphic
closed carriers. -/
def carrierProbeLinearEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C) :
    carrierProbeSubspace A ≃ₗ[ℝ] carrierProbeSubspace (A.map e) :=
  zeroSumProbeSector.spaceLinearEquiv (inducedOrderIso e A)

/-- The basis-free carrier pairing is exactly covariant under ambient order
isomorphisms. -/
theorem carrierProbePairing_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (f h : carrierProbeSubspace A) :
    carrierProbePairing (A.map e) ell nonlocalityScale
        (closedCarrierEquiv e A x)
        (carrierProbeLinearEquiv e A f)
        (carrierProbeLinearEquiv e A h) =
      carrierProbePairing A ell nonlocalityScale x f h := by
  exact OrderIso.correctedPairingAt_projectSmeared4D_equivariant
    (inducedOrderIso e A) ell nonlocalityScale x f.1 h.1

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.IntrinsicProbeSubspaceSector.map_space_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.IntrinsicProbeSubspaceSector.map_space_eq

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.fiveEvent_rankFour_subspace_but_no_natural_vectors' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.fiveEvent_rankFour_subspace_but_no_natural_vectors

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.carrierProbePairing_equivariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.carrierProbePairing_equivariant

end PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace
