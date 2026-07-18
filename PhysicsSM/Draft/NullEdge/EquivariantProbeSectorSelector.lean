import PhysicsSM.Draft.NullEdge.RankFourCarrierProbeSector

/-!
# Equivariant kernel and range selectors for rank-four probe sectors

`RankFourCarrierProbeSector.lean` repairs the local Lorentz-gauge interface by
placing frames inside a supplied rank-four subspace of the full zero-sum probe
space.  The remaining graph-side question is how such a subspace can be
derived without choosing four labeled vectors.

This module gives two basis-free construction patterns:

1. the kernel of an intrinsic constraint map with four-dimensional kernel;
2. the range of an intrinsic endomorphism or spectral projector with
   four-dimensional range.

The central commuting-square lemmas prove that kernels and ranges transport
exactly under linear equivalences.  Specialized to the carrier relabeling
equivalence, an order-equivariant constraint or projector therefore produces
an order-natural rank-four sector.  Degenerate eigenvectors never need to be
ordered: only the whole range subspace is transported.

These are conditional finite construction theorems.  They do not exhibit an
operator whose kernel or range has rank four on physical carriers, prove an
eigengap, show overlap compatibility, or establish a continuum cotangent
bundle.  Those are now explicit selector-gate obligations rather than hidden
inside a frame hypothesis.

Claim grade: `M [orig/comp]`.  Provenance: program-internal composition of the
selected-sector correction with standard Mathlib kernel, range, and submodule
transport.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.EquivariantProbeSectorSelector

open AlexandrovAlgebraGerm
open AlexandrovGermInternalOperator
open FiniteCausalOrderOperator
open IntrinsicProbeSubspace
open RankFourProbeSector

variable {V W : Type} [Fintype V] [Fintype W]

/-! ## General commuting-square transport -/

section General

variable {P Q T U : Type*}
  [AddCommGroup P] [AddCommGroup Q] [AddCommGroup T] [AddCommGroup U]
  [Module ℝ P] [Module ℝ Q] [Module ℝ T] [Module ℝ U]

/-- An intertwining square transports the kernel of the source constraint
exactly to the kernel of the target constraint. -/
theorem map_ker_eq_ker_of_intertwines
    (E : P ≃ₗ[ℝ] Q) (F : T ≃ₗ[ℝ] U)
    (L : P →ₗ[ℝ] T) (K : Q →ₗ[ℝ] U)
    (hintertwines : ∀ x, F (L x) = K (E x)) :
    (LinearMap.ker L).map E.toLinearMap = LinearMap.ker K := by
  ext y
  constructor
  · rintro ⟨x, hx, rfl⟩
    change L x = 0 at hx
    change K (E x) = 0
    have h := hintertwines x
    rw [hx, map_zero] at h
    exact h.symm
  · intro hy
    change K y = 0 at hy
    let x : P := E.symm y
    have htarget : K (E x) = 0 := by
      simpa [x] using hy
    have hsourceImage : F (L x) = 0 := by
      rw [hintertwines]
      exact htarget
    have hsource : L x = 0 := by
      apply F.injective
      simpa using hsourceImage
    exact ⟨x, hsource, by simp [x]⟩

/-- An intertwining equivalence transports the range of a source endomorphism
exactly to the range of the target endomorphism. -/
theorem map_range_eq_range_of_intertwines
    (E : P ≃ₗ[ℝ] Q) (L : P →ₗ[ℝ] P) (K : Q →ₗ[ℝ] Q)
    (hintertwines : ∀ x, E (L x) = K (E x)) :
    (LinearMap.range L).map E.toLinearMap = LinearMap.range K := by
  ext y
  constructor
  · rintro ⟨_, ⟨x, rfl⟩, rfl⟩
    exact ⟨E x, (hintertwines x).symm⟩
  · rintro ⟨q, rfl⟩
    let x : P := E.symm q
    refine ⟨L x, ⟨x, rfl⟩, ?_⟩
    simpa [x] using hintertwines x

end General

/-! ## Carrier kernel selectors -/

/-- Package the four-dimensional kernel of a supplied carrier constraint as a
rank-four probe sector. -/
def kernelSector
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    {T : Type*} [AddCommGroup T] [Module ℝ T]
    (L : carrierProbeSubspace A →ₗ[ℝ] T)
    (hrank : Module.finrank ℝ (LinearMap.ker L) = 4) :
    RankFourCarrierProbeSector A where
  space := LinearMap.ker L
  finrank_eq_four := hrank

/-- If source and target carrier constraints intertwine under order
relabeling, their selected kernel sectors agree exactly after transport. -/
theorem kernelSector_mapOrderIso_space_eq
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    {T U : Type*} [AddCommGroup T] [AddCommGroup U]
    [Module ℝ T] [Module ℝ U]
    (F : T ≃ₗ[ℝ] U)
    (L : carrierProbeSubspace A →ₗ[ℝ] T)
    (K : carrierProbeSubspace (A.map e) →ₗ[ℝ] U)
    (hrankL : Module.finrank ℝ (LinearMap.ker L) = 4)
    (hrankK : Module.finrank ℝ (LinearMap.ker K) = 4)
    (hintertwines : ∀ x,
      F (L x) = K (carrierProbeLinearEquiv e A x)) :
    ((kernelSector A L hrankL).mapOrderIso e).space =
      (kernelSector (A.map e) K hrankK).space := by
  exact map_ker_eq_ker_of_intertwines
    (carrierProbeLinearEquiv e A) F L K hintertwines

/-! ## Carrier range and projector selectors -/

/-- Package the four-dimensional range of a supplied carrier endomorphism as
a rank-four probe sector. -/
def rangeSector
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (L : carrierProbeSubspace A →ₗ[ℝ] carrierProbeSubspace A)
    (hrank : Module.finrank ℝ (LinearMap.range L) = 4) :
    RankFourCarrierProbeSector A where
  space := LinearMap.range L
  finrank_eq_four := hrank

/-- If source and target carrier endomorphisms intertwine under order
relabeling, their selected range sectors agree exactly after transport. -/
theorem rangeSector_mapOrderIso_space_eq
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (L : carrierProbeSubspace A →ₗ[ℝ] carrierProbeSubspace A)
    (K : carrierProbeSubspace (A.map e) →ₗ[ℝ]
      carrierProbeSubspace (A.map e))
    (hrankL : Module.finrank ℝ (LinearMap.range L) = 4)
    (hrankK : Module.finrank ℝ (LinearMap.range K) = 4)
    (hintertwines : ∀ x,
      carrierProbeLinearEquiv e A (L x) =
        K (carrierProbeLinearEquiv e A x)) :
    ((rangeSector A L hrankL).mapOrderIso e).space =
      (rangeSector (A.map e) K hrankK).space := by
  exact map_range_eq_range_of_intertwines
    (carrierProbeLinearEquiv e A) L K hintertwines

/-- A basis-free rank-four projector candidate on one carrier.  Idempotence
records that the endomorphism really projects onto its selected range. -/
structure RankFourProbeProjector
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) where
  project : carrierProbeSubspace A →ₗ[ℝ] carrierProbeSubspace A
  idempotent : project.comp project = project
  range_finrank_eq_four : Module.finrank ℝ (LinearMap.range project) = 4

/-- The range of a rank-four projector is a corrected carrier probe sector. -/
def RankFourProbeProjector.sector
    {C : FiniteCausalOrder V} {A : MarkedDiamond C}
    (P : RankFourProbeProjector A) : RankFourCarrierProbeSector A :=
  rangeSector A P.project P.range_finrank_eq_four

/-- Intertwining rank-four projectors select the same sector after order
transport.  This is the finite naturality target for a spectral projector
constructed from order-native operator data. -/
theorem projectorSector_mapOrderIso_space_eq
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (P : RankFourProbeProjector A)
    (Q : RankFourProbeProjector (A.map e))
    (hintertwines : ∀ x,
      carrierProbeLinearEquiv e A (P.project x) =
        Q.project (carrierProbeLinearEquiv e A x)) :
    (P.sector.mapOrderIso e).space = Q.sector.space := by
  exact rangeSector_mapOrderIso_space_eq e A P.project Q.project
    P.range_finrank_eq_four Q.range_finrank_eq_four hintertwines

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.EquivariantProbeSectorSelector.map_ker_eq_ker_of_intertwines' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.EquivariantProbeSectorSelector.map_ker_eq_ker_of_intertwines

/-- info: 'PhysicsSM.Draft.NullEdge.EquivariantProbeSectorSelector.kernelSector_mapOrderIso_space_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.EquivariantProbeSectorSelector.kernelSector_mapOrderIso_space_eq

/-- info: 'PhysicsSM.Draft.NullEdge.EquivariantProbeSectorSelector.projectorSector_mapOrderIso_space_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.EquivariantProbeSectorSelector.projectorSector_mapOrderIso_space_eq

end PhysicsSM.Draft.NullEdge.EquivariantProbeSectorSelector
