import PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge

/-!
# Selected rank-four carrier probe sectors

`ProbeFrameLorentzGauge.lean` correctly proves finite Gram-congruence and
Lorentz-gauge statements, but its `CarrierProbeFrame A` is a `Fin 4` basis of
the *entire* zero-sum scalar-field space on `ClosedCarrier A`.  This module
makes the resulting cardinality obstruction explicit:

`finrank (zeroSumFieldSubspace U) = |U| - 1`,

so the old frame hypothesis forces `|ClosedCarrier A| = 5`.  In particular,
that interface cannot be the physical four-mode sector on a large refinement
carrier.  The old theorems remain valid conditional finite algebra; this file
records their exact domain of possible application.

The successor interface is `RankFourCarrierProbeSector A`: a supplied
rank-four subspace of the full zero-sum carrier space.  Frames are bases of
that selected subspace.  The corrected pairing restricts to it, obeys the
same exact Gram congruence, and leaves only Lorentz-related normalized frames.
Order isomorphisms transport the selected subspace, its frames, and its Gram
matrix exactly.

This repairs the type-level architecture but does not derive the selected
subspace from a bare causal order.  A physical reconstruction must still give
an intrinsic, overlap-compatible rule selecting four slowly varying probe
modes, prove Lorentzian inertia on them, and establish continuum convergence.
Until that selector theorem lands, downstream modules must take
`RankFourCarrierProbeSector A` as an explicit parameter and must not use choice
on `rankFourCarrierProbeSector_nonempty_of_five_le_card` to manufacture a
derived sector.

Claim grade: `M [orig]` for the finite obstruction, selected-sector linear
algebra, and order-covariance statements.  Provenance: program-internal
semantic audit of `IntrinsicProbeSubspace.lean` and
`ProbeFrameLorentzGauge.lean`, using Mathlib finite-dimensional linear algebra.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.RankFourProbeSector

open AlexandrovAlgebraGerm
open AlexandrovGermInternalOperator
open FiniteCausalOrderOperator
open IntrinsicProbeSubspace
open Matrix
open ProbeFrameLorentzGauge

variable {V W : Type} [Fintype V] [Fintype W]

/-! ## Exact obstruction for the whole zero-sum space -/

/-- On every nonempty finite type, the total-sum functional is onto. -/
theorem fieldSumLinearMap_surjective
    (U : Type*) [Fintype U] [Nonempty U] :
    Function.Surjective (fieldSumLinearMap U) := by
  classical
  intro value
  let u : U := Classical.choice (inferInstance : Nonempty U)
  refine ⟨fun x => if x = u then value else 0, ?_⟩
  simp [fieldSumLinearMap, u]

/-- The zero-sum scalar-field space on a nonempty finite type has exactly
codimension one. -/
theorem finrank_zeroSumFieldSubspace
    (U : Type*) [Fintype U] [Nonempty U] :
    Module.finrank ℝ (zeroSumFieldSubspace U) = Fintype.card U - 1 := by
  have hrange : LinearMap.range (fieldSumLinearMap U) = ⊤ :=
    LinearMap.range_eq_top.2 (fieldSumLinearMap_surjective U)
  have hrank :=
    LinearMap.finrank_range_add_finrank_ker (fieldSumLinearMap U)
  rw [hrange] at hrank
  simp [zeroSumFieldSubspace] at hrank ⊢
  omega

/-- If the full zero-sum carrier space has finrank four, the carrier has
exactly five events. -/
theorem fullCarrierProbe_finrank_four_forces_card_five
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (hrank : Module.finrank ℝ (carrierProbeSubspace A) = 4) :
    Fintype.card (ClosedCarrier A) = 5 := by
  letI : Nonempty (ClosedCarrier A) := ⟨carrierBottom A⟩
  change Module.finrank ℝ
    (zeroSumFieldSubspace (ClosedCarrier A)) = 4 at hrank
  rw [finrank_zeroSumFieldSubspace] at hrank
  have hpos : 0 < Fintype.card (ClosedCarrier A) := Fintype.card_pos
  omega

/-- **Exact semantic boundary of the old frame interface.** A `Fin 4` basis
of the entire zero-sum carrier space can exist only on a five-event carrier. -/
theorem carrierProbeFrame_forces_card_five
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (b : CarrierProbeFrame A) :
    Fintype.card (ClosedCarrier A) = 5 := by
  apply fullCarrierProbe_finrank_four_forces_card_five A
  have hdim := Module.finrank_eq_card_basis b
  simpa using hdim

/-- On every carrier whose cardinality is not five, the old whole-space
four-frame type is empty. -/
theorem no_carrierProbeFrame_of_card_ne_five
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (hcard : Fintype.card (ClosedCarrier A) ≠ 5) :
    ¬ Nonempty (CarrierProbeFrame A) := by
  rintro ⟨b⟩
  exact hcard (carrierProbeFrame_forces_card_five A b)

/-- The old Lorentz-inertia predicate is likewise impossible away from
five-event carriers, independently of the operator coefficients. -/
theorem no_old_hasLorentzianInertia_of_card_ne_five
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (hcard : Fintype.card (ClosedCarrier A) ≠ 5) :
    ¬ HasLorentzianInertia A ell nonlocalityScale x := by
  rintro ⟨b, _⟩
  exact hcard (carrierProbeFrame_forces_card_five A b)

/-! ## Corrected selected-sector interface -/

/-- A supplied rank-four candidate inside the full zero-sum carrier probe
space.  This structure records the algebraic target; a graph-native
reconstruction must still derive `space` and its overlap compatibility.
Downstream derived objects must receive this sector as an explicit parameter;
they must not choose one from
`rankFourCarrierProbeSector_nonempty_of_five_le_card` until a graph-native
selector theorem lands. -/
structure RankFourCarrierProbeSector
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) where
  space : Submodule ℝ (carrierProbeSubspace A)
  finrank_eq_four : Module.finrank ℝ space = 4

/-- The corrected interface is algebraically nonvacuous on every carrier with
at least five events.  This existence proof chooses an arbitrary independent
four-tuple; it does not provide the intrinsic selector required by physics. -/
theorem rankFourCarrierProbeSector_nonempty_of_five_le_card
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (hcard : 5 ≤ Fintype.card (ClosedCarrier A)) :
    Nonempty (RankFourCarrierProbeSector A) := by
  letI : Nonempty (ClosedCarrier A) := ⟨carrierBottom A⟩
  have hfour : 4 ≤ Module.finrank ℝ (carrierProbeSubspace A) := by
    change 4 ≤ Module.finrank ℝ
      (zeroSumFieldSubspace (ClosedCarrier A))
    rw [finrank_zeroSumFieldSubspace]
    omega
  obtain ⟨f, hf⟩ := exists_linearIndependent_of_le_finrank hfour
  refine ⟨⟨Submodule.span ℝ (Set.range f), ?_⟩⟩
  simpa using finrank_span_eq_card hf

/-- A gauge-relative frame of a selected rank-four probe sector. -/
abbrev SectorFrame
    {C : FiniteCausalOrder V} {A : MarkedDiamond C}
    (P : RankFourCarrierProbeSector A) :=
  Module.Basis (Fin 4) ℝ P.space

/-- Every packaged rank-four sector admits a `Fin 4`-indexed basis.  The basis
chosen by `finBasis` is not asserted to be natural or physically preferred. -/
def someSectorFrame
    {C : FiniteCausalOrder V} {A : MarkedDiamond C}
    (P : RankFourCarrierProbeSector A) : SectorFrame P := by
  letI : Module.Free ℝ P.space :=
    Module.Free.of_divisionRing ℝ P.space
  exact (Module.finBasis ℝ P.space).reindex
    (finCongr P.finrank_eq_four)

/-- A selected rank-four sector has at least one frame, without selecting a
preferred frame as mathematical data. -/
theorem sectorFrame_nonempty
    {C : FiniteCausalOrder V} {A : MarkedDiamond C}
    (P : RankFourCarrierProbeSector A) : Nonempty (SectorFrame P) :=
  ⟨someSectorFrame P⟩

/-- On a carrier larger than five events, every selected rank-four sector is
a proper subspace of the full zero-sum carrier space. -/
theorem space_ne_top_of_five_lt_card
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (hcard : 5 < Fintype.card (ClosedCarrier A)) :
    P.space ≠ ⊤ := by
  intro htop
  have hrank : Module.finrank ℝ (carrierProbeSubspace A) = 4 := by
    have htopRank := congrArg
      (fun S : Submodule ℝ (carrierProbeSubspace A) =>
        Module.finrank ℝ S) htop
    change Module.finrank ℝ P.space =
      Module.finrank ℝ
        (⊤ : Submodule ℝ (carrierProbeSubspace A)) at htopRank
    rw [finrank_top] at htopRank
    exact htopRank.symm.trans P.finrank_eq_four
  have hfive := fullCarrierProbe_finrank_four_forces_card_five A hrank
  omega

/-! ## Restricted pairing, Gram congruence, and Lorentz gauge -/

/-- Restriction of the active corrected carrier pairing to a selected
rank-four sector. -/
def sectorBilinForm
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) :
    LinearMap.BilinForm ℝ P.space :=
  (carrierProbeBilinForm A ell nonlocalityScale x).comp
    P.space.subtype P.space.subtype

/-- The restricted bilinear form evaluates as the original carrier pairing
on the included probe vectors. -/
@[simp] theorem sectorBilinForm_apply
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (f h : P.space) :
    sectorBilinForm A P ell nonlocalityScale x f h =
      carrierProbePairing A ell nonlocalityScale x f.1 h.1 := by
  simp [sectorBilinForm]

/-- Matrix of the selected-sector pairing in one gauge-relative frame. -/
def sectorGram
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : SectorFrame P) : Matrix (Fin 4) (Fin 4) ℝ :=
  LinearMap.BilinForm.toMatrix b
    (sectorBilinForm A P ell nonlocalityScale x)

/-- Entries of the selected-sector Gram matrix are the original corrected
pairings of the included probe vectors. -/
theorem sectorGram_apply
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : SectorFrame P) (i j : Fin 4) :
    sectorGram A P ell nonlocalityScale x b i j =
      carrierProbePairing A ell nonlocalityScale x (b i).1 (b j).1 := by
  simp [sectorGram]

/-- Exact Gram congruence for two frames of the same selected sector. -/
theorem sectorGram_change
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b c : SectorFrame P) :
    (b.toMatrix c)ᵀ * sectorGram A P ell nonlocalityScale x b *
        b.toMatrix c =
      sectorGram A P ell nonlocalityScale x c := by
  exact LinearMap.BilinForm.toMatrix_mul_basis_toMatrix (b := b) c
    (sectorBilinForm A P ell nonlocalityScale x)

/-- A selected-sector frame is Lorentz-normalized when its Gram matrix is the
project's mostly-minus Minkowski matrix. -/
def IsSectorLorentzNormalized
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : SectorFrame P) : Prop :=
  sectorGram A P ell nonlocalityScale x b =
    (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ)

/-- Corrected Lorentzian-inertia gate on a selected rank-four sector. -/
def HasSectorLorentzianInertia
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) : Prop :=
  ∃ b : SectorFrame P,
    IsSectorLorentzNormalized A P ell nonlocalityScale x b

/-- Conditional recovery of the Lorentz gauge group on the corrected
selected-sector interface. -/
theorem isSectorLorentzNormalized_change_iff
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b c : SectorFrame P)
    (hb : IsSectorLorentzNormalized A P ell nonlocalityScale x b) :
    IsSectorLorentzNormalized A P ell nonlocalityScale x c ↔
      (b.toMatrix c)ᵀ *
          (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ) *
          b.toMatrix c = MinkowskiConvention.eta := by
  unfold IsSectorLorentzNormalized at hb ⊢
  rw [← sectorGram_change A P ell nonlocalityScale x b c, hb]

/-! ## Exact transport under causal-order isomorphism -/

/-- Transport a selected rank-four sector by the intrinsic carrier
relabeling equivalence. -/
def RankFourCarrierProbeSector.mapOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    {A : MarkedDiamond C} (P : RankFourCarrierProbeSector A)
    (e : OrderIso C D) :
    RankFourCarrierProbeSector (A.map e) where
  space := P.space.map (carrierProbeLinearEquiv e A).toLinearMap
  finrank_eq_four := by
    rw [LinearEquiv.finrank_map_eq]
    exact P.finrank_eq_four

/-- Relabeling restricts to a linear equivalence from a selected sector to
its transported image. -/
def sectorMapLinearEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A) :
    P.space ≃ₗ[ℝ] (P.mapOrderIso e).space :=
  (carrierProbeLinearEquiv e A).submoduleMap P.space

/-- Push a selected-sector frame along an ambient order isomorphism. -/
def mapSectorFrame
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A) (b : SectorFrame P) :
    SectorFrame (P.mapOrderIso e) :=
  b.map (sectorMapLinearEquiv e A P)

/-- The included value of a transported frame vector is the intrinsic
relabeling of the included source vector. -/
@[simp] theorem mapSectorFrame_apply_coe
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A) (b : SectorFrame P) (i : Fin 4) :
    ((mapSectorFrame e A P b i).1 : carrierProbeSubspace (A.map e)) =
      carrierProbeLinearEquiv e A (b i).1 :=
  rfl

/-- Transport of a selected sector and frame leaves the corrected Gram matrix
exactly unchanged. -/
theorem sectorGram_mapOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : SectorFrame P) :
    sectorGram (A.map e) (P.mapOrderIso e) ell nonlocalityScale
        (closedCarrierEquiv e A x) (mapSectorFrame e A P b) =
      sectorGram A P ell nonlocalityScale x b := by
  ext i j
  rw [sectorGram_apply, sectorGram_apply]
  simp only [mapSectorFrame_apply_coe]
  exact carrierProbePairing_equivariant e A ell nonlocalityScale x
    (b i).1 (b j).1

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.RankFourProbeSector.carrierProbeFrame_forces_card_five' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RankFourProbeSector.carrierProbeFrame_forces_card_five

/-- info: 'PhysicsSM.Draft.NullEdge.RankFourProbeSector.sectorGram_change' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RankFourProbeSector.sectorGram_change

/-- info: 'PhysicsSM.Draft.NullEdge.RankFourProbeSector.isSectorLorentzNormalized_change_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RankFourProbeSector.isSectorLorentzNormalized_change_iff

/-- info: 'PhysicsSM.Draft.NullEdge.RankFourProbeSector.sectorGram_mapOrderIso' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RankFourProbeSector.sectorGram_mapOrderIso

end PhysicsSM.Draft.NullEdge.RankFourProbeSector
