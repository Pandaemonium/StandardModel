import PhysicsSM.Draft.NullEdge.GateYM.SlabTransferGap

/-!
# Gate YM / NE-U4: finite Osterwalder-Schrader / GNS reconstruction on the slab

This module performs the finite Osterwalder-Schrader (OS) / GNS reconstruction
step on the connected Wilson slab, specialising the Euclidean->Minkowski move
that the RP construction of 4D SU(N) YM (arXiv 2606.19362) invokes ("the
Osterwalder-Schrader reconstruction turns these Euclidean facts into a
Minkowski theory with a self-adjoint Hamiltonian, the spectral gap lying above
the vacuum") to the project's concrete finite reflection-positive slab.

Everything here is a **finite, kernel-checked identity** on a genuine RP
ensemble.  It builds directly on the existing tree:

* `ReflectionPositivityKernel.IsReflectionPositive` and the PSD block
  `TransferHilbertBlock.rpBlockMatrix` /
  `rpBlockMatrix_posSemidef_of_reflectionPositive`;
* `WilsonSlabConnected.wilsonSlabConnected_reflectionPositive`;
* `SlabTransferGap.slabTransferBlock` (+ its PSD/Hermitian packaging) and its
  `Z2` center-sector gap `SlabTransferGap.neU4_closure_gap_pos`.

## Deliverables

1. **GNS quotient (`OSpace`).**  From any Hermitian PSD kernel `K`, the RP
   sesquilinear form `osForm K f g = star f ⬝ᵥ (K *ᵥ g)` descends to the
   quotient `OSpace K = (I -> ℂ) / ker K` and there becomes a **genuine inner
   product**: `osInnerCore K hK : InnerProductSpace.Core ℂ (OSpace K)` packages
   conjugate symmetry, nonnegativity, additivity, sesquilinearity, and
   positive-definiteness, so `InnerProductSpace.ofCore (osInnerCore K hK)`
   upgrades `OSpace K` to a bona fide finite-dimensional inner product space.
   This is the finite GNS construction: the null space of the RP form is quotiented
   out and the induced form is definite.

2. **Self-adjoint, positive transfer operator (`osTransfer`).**  The reflection
   kernel `K` descends to `osTransfer K : OSpace K ->ₗ[ℂ] OSpace K`, which is
   `osTransfer_isSelfAdjoint` (symmetric for the GNS inner product) and
   `osTransfer_posSemidef` (nonnegative GNS expectation values).  Specialised to
   `SlabTransferGap.slabTransferBlock` these become
   `slabOsTransfer_isSelfAdjoint` / `slabOsTransfer_posSemidef`: the connected
   slab's OS/GNS transfer operator is a self-adjoint positive operator on a
   genuine Hilbert space, built from `slabTransferBlock`'s Hermitian PSD
   structure.

3. **Spectral gap above the vacuum.**  On the exactly solvable `Z2`
   center-sector slab, `osSpectralGap` is the finite spectral-ratio gap
   `-log(lambdaFlux / lambda0)` between the vacuum eigenvalue `lambda0` (the
   simple, separated top eigenvalue) and the lightest nontrivial center-flux
   eigenvalue `lambdaFlux`.  `osSpectralGap_pos : 0 < osSpectralGap` is the OS
   spectral gap above the vacuum, tied directly to
   `SlabTransferGap.neU4_closure_gap_pos`; `osSpectralGap_eq_neg_log_ratio`
   records the `-log(second/top)` form and `osSpectralGap_eq_neg_log_tanh` the
   strong-coupling `-log(tanh beta)` value.  `osVacuum_separated` records that
   the vacuum eigenvalue is strictly separated from the first excited one.

## What is NOT claimed (F-YM-CONFLATE guard)

No physical/continuum mass gap.  This is the finite-slab OS reconstruction: a
self-adjoint transfer operator with a finite spectral gap on a concrete
reflection-positive ensemble — the honest Osterwalder-Seiler-regime statement.
The gap in deliverable 3 is realised on the exactly solvable one-link `Z2`
center sectors (`TwoStateTransferZ2Sector`); connecting it to the full connected
block's own Gram spectrum is the documented handoff already tracked in
`SlabTransferGap` and is deliberately NOT asserted here.  No continuum limit,
no Wilson area law, no entanglement claims.

Claim label: **finite identity / OS reconstruction layer**.  Draft-trust:
kernel-checked, no `s o r r y`, no `n a t i v e _ d e c i d e`.
-/

noncomputable section

set_option linter.unusedDecidableInType false
set_option linter.unusedFintypeInType false

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace OSReconstruction

open scoped BigOperators ComplexOrder Matrix

/-! ## Deliverable 1: the finite GNS quotient and its genuine inner product -/

section GNS

variable {I : Type*} [Fintype I] [DecidableEq I]

/-- The null space of the reflection kernel `K`: the vectors annihilated by
`K`, i.e. the null vectors of the RP form.  This is the subspace quotiented out
by the GNS construction. -/
def osNullSpace (K : Matrix I I ℂ) : Submodule ℂ (I → ℂ) :=
  LinearMap.ker (Matrix.mulVecLin K)

/-- The finite GNS/OS space: the configuration space modulo the null space of
the RP form. -/
abbrev OSpace (K : Matrix I I ℂ) := (I → ℂ) ⧸ osNullSpace K

/-- The Osterwalder-Seiler reflection form of the kernel `K`, antilinear in the
first slot: `osForm K f g = star f ⬝ᵥ (K *ᵥ g)`. -/
def osForm (K : Matrix I I ℂ) (f g : I → ℂ) : ℂ := star f ⬝ᵥ (K *ᵥ g)

omit [DecidableEq I] in
lemma mem_osNullSpace {K : Matrix I I ℂ} {f : I → ℂ} :
    f ∈ osNullSpace K ↔ K *ᵥ f = 0 := by
  classical simp [osNullSpace, LinearMap.mem_ker]

omit [DecidableEq I] in
/-- The RP form vanishes when its second argument is a null vector. -/
lemma osForm_right_zero (K : Matrix I I ℂ) (f g : I → ℂ)
    (hg : g ∈ osNullSpace K) : osForm K f g = 0 := by
  rw [mem_osNullSpace] at hg; simp [osForm, hg]

omit [DecidableEq I] in
/-- The RP form vanishes when its first argument is a null vector (using that
`K` is Hermitian). -/
lemma osForm_left_zero (K : Matrix I I ℂ) (hK : K.IsHermitian) (f g : I → ℂ)
    (hf : f ∈ osNullSpace K) : osForm K f g = 0 := by
  rw [mem_osNullSpace] at hf
  have : osForm K f g = star (K *ᵥ f) ⬝ᵥ g := by
    unfold osForm
    rw [Matrix.star_mulVec, Matrix.dotProduct_mulVec]; congr 1; rw [hK.eq]
  rw [this, hf]; simp

/-- **The descended GNS inner product.**  The RP form descends to a
well-defined map on the quotient `OSpace K` (Hermitian `K`). -/
def osInner (K : Matrix I I ℂ) (hK : K.IsHermitian) : OSpace K → OSpace K → ℂ :=
  fun x y => Quotient.liftOn₂ x y (osForm K)
    (by
      intro f g f' g' hf hg
      have hf' : f - f' ∈ osNullSpace K := (Submodule.quotientRel_def _).mp hf
      have hg' : g - g' ∈ osNullSpace K := (Submodule.quotientRel_def _).mp hg
      have e1 : osForm K f g - osForm K f' g = osForm K (f - f') g := by
        simp [osForm, sub_dotProduct, star_sub]
      have e2 : osForm K f' g - osForm K f' g' = osForm K f' (g - g') := by
        simp [osForm, Matrix.mulVec_sub, dotProduct_sub]
      have z1 : osForm K (f - f') g = 0 := osForm_left_zero K hK _ _ hf'
      have z2 : osForm K f' (g - g') = 0 := osForm_right_zero K f' _ hg'
      linear_combination e1 + e2 + z1 + z2)

omit [DecidableEq I] in
@[simp]
lemma osInner_mk (K : Matrix I I ℂ) (hK : K.IsHermitian) (f g : I → ℂ) :
    osInner K hK (Submodule.Quotient.mk f) (Submodule.Quotient.mk g)
      = osForm K f g := rfl

/-- The GNS inner product structure on `OSpace K`. -/
instance instOSInner (K : Matrix I I ℂ) (hK : K.IsHermitian) :
    Inner ℂ (OSpace K) := ⟨osInner K hK⟩

/-- **Deliverable 1 (crown): the finite GNS inner product is genuine.**  For a
Hermitian PSD kernel `K`, the RP form induces a full `InnerProductSpace.Core` on
the quotient `OSpace K`: conjugate-symmetric, nonnegative, sesquilinear, and
positive-definite.  `InnerProductSpace.ofCore (osInnerCore K hK)` therefore
makes `OSpace K` a genuine finite-dimensional inner product space — the finite
GNS Hilbert space of the reflection-positive kernel. -/
def osInnerCore (K : Matrix I I ℂ) (hK : K.PosSemidef) :
    InnerProductSpace.Core ℂ (OSpace K) := by
  letI : Inner ℂ (OSpace K) := instOSInner K hK.isHermitian
  exact
  { inner := osInner K hK.isHermitian
    conj_inner_symm := by
      refine Quotient.ind (fun f => Quotient.ind (fun g => ?_))
      show (starRingEnd ℂ) (star g ⬝ᵥ (K *ᵥ f)) = star f ⬝ᵥ (K *ᵥ g)
      rw [show (starRingEnd ℂ) (star g ⬝ᵥ (K *ᵥ f))
            = star (star g ⬝ᵥ (K *ᵥ f)) from rfl,
        Matrix.star_dotProduct, star_star, Matrix.star_mulVec,
        Matrix.dotProduct_mulVec, hK.isHermitian.eq]
    re_inner_nonneg := by
      refine Quotient.ind (fun f => ?_)
      show 0 ≤ (osForm K f f).re
      exact (hK.dotProduct_mulVec_nonneg f).1
    add_left := by
      refine Quotient.ind (fun f => Quotient.ind (fun g => Quotient.ind (fun h => ?_)))
      show osForm K (f + g) h = osForm K f h + osForm K g h
      simp [osForm, star_add, add_dotProduct]
    smul_left := by
      intro x y r
      induction x using Quotient.ind with | _ f =>
      induction y using Quotient.ind with | _ g =>
      show osForm K (r • f) g = (starRingEnd ℂ) r * osForm K f g
      simp [osForm, star_smul, smul_dotProduct]
    definite := by
      refine Quotient.ind (fun f => ?_)
      intro h
      show (Submodule.Quotient.mk f : OSpace K) = 0
      have hf0 : osForm K f f = 0 := h
      have hKf : K *ᵥ f = 0 :=
        (Matrix.PosSemidef.dotProduct_mulVec_zero_iff hK f).mp hf0
      rw [Submodule.Quotient.mk_eq_zero]
      exact mem_osNullSpace.mpr hKf }

omit [DecidableEq I] in
/-- Positive-definiteness of the GNS inner product, extracted from the core:
a class with vanishing self inner product is the zero class. -/
theorem osInner_definite (K : Matrix I I ℂ) (hK : K.PosSemidef) (x : OSpace K)
    (h : osInner K hK.isHermitian x x = 0) : x = 0 :=
  (osInnerCore K hK).definite x h

omit [DecidableEq I] in
/-- Conjugate symmetry of the GNS inner product. -/
theorem osInner_conj_symm (K : Matrix I I ℂ) (hK : K.IsHermitian)
    (x y : OSpace K) :
    (starRingEnd ℂ) (osInner K hK y x) = osInner K hK x y := by
  induction x using Quotient.ind with | _ f =>
  induction y using Quotient.ind with | _ g =>
  show (starRingEnd ℂ) (star g ⬝ᵥ (K *ᵥ f)) = star f ⬝ᵥ (K *ᵥ g)
  rw [show (starRingEnd ℂ) (star g ⬝ᵥ (K *ᵥ f))
        = star (star g ⬝ᵥ (K *ᵥ f)) from rfl,
    Matrix.star_dotProduct, star_star, Matrix.star_mulVec,
    Matrix.dotProduct_mulVec, hK.eq]

omit [DecidableEq I] in
/-- Nonnegativity of the GNS diagonal (reflection positivity on the quotient),
in the complex order. -/
theorem osInner_self_nonneg (K : Matrix I I ℂ) (hK : K.PosSemidef)
    (x : OSpace K) : 0 ≤ osInner K hK.isHermitian x x := by
  induction x using Quotient.ind with | _ f =>
  show 0 ≤ osForm K f f
  exact hK.dotProduct_mulVec_nonneg f

/-! ## Deliverable 2: the self-adjoint, positive OS transfer operator -/

/-- **The OS/GNS transfer operator.**  The reflection kernel `K` descends to a
linear operator on the GNS space `OSpace K` (it maps null vectors to null
vectors, trivially). -/
def osTransfer (K : Matrix I I ℂ) : OSpace K →ₗ[ℂ] OSpace K :=
  Submodule.mapQ (osNullSpace K) (osNullSpace K) (Matrix.mulVecLin K)
    (by
      intro f hf
      rw [mem_osNullSpace] at hf
      rw [Submodule.mem_comap, mem_osNullSpace, Matrix.mulVecLin_apply, hf]
      simp)

omit [DecidableEq I] in
@[simp]
lemma osTransfer_mk (K : Matrix I I ℂ) (f : I → ℂ) :
    osTransfer K (Submodule.Quotient.mk f) = Submodule.Quotient.mk (K *ᵥ f) := by
  simp [osTransfer, Submodule.mapQ_apply]

omit [DecidableEq I] in
/-- **Deliverable 2a: OS self-adjointness.**  The OS transfer operator is
symmetric with respect to the GNS inner product: `⟪T x, y⟫ = ⟪x, T y⟫`.  This is
the finite-slab realisation of the self-adjoint (Hermitian) transfer operator of
the Osterwalder-Schrader reconstruction. -/
theorem osTransfer_isSelfAdjoint (K : Matrix I I ℂ) (hK : K.IsHermitian)
    (x y : OSpace K) :
    osInner K hK (osTransfer K x) y = osInner K hK x (osTransfer K y) := by
  induction x using Quotient.ind with | _ f =>
  induction y using Quotient.ind with | _ g =>
  show osForm K (K *ᵥ f) g = osForm K f (K *ᵥ g)
  unfold osForm
  rw [Matrix.star_mulVec, ← Matrix.dotProduct_mulVec, hK.eq]

omit [DecidableEq I] in
/-- **Deliverable 2b: OS positivity.**  The OS transfer operator has nonnegative
GNS expectation values: `0 ≤ ⟪x, T x⟫` for every `x`.  Together with
self-adjointness this exhibits it as a positive self-adjoint operator on the
finite GNS Hilbert space. -/
theorem osTransfer_posSemidef (K : Matrix I I ℂ) (hK : K.PosSemidef)
    (x : OSpace K) : 0 ≤ osInner K hK.isHermitian x (osTransfer K x) := by
  induction x using Quotient.ind with | _ f =>
  show 0 ≤ osForm K f (K *ᵥ f)
  have hKK : (Kᴴ * K).PosSemidef := Matrix.posSemidef_conjTranspose_mul_self K
  rw [hK.isHermitian.eq] at hKK
  have hq := hKK.dotProduct_mulVec_nonneg f
  have hrw : osForm K f (K *ᵥ f) = star f ⬝ᵥ ((K * K) *ᵥ f) := by
    unfold osForm; rw [Matrix.mulVec_mulVec]
  rw [hrw]; exact hq

end GNS

/-! ## Instantiation at the connected Wilson slab transfer block

We feed `SlabTransferGap.slabTransferBlock` — the genuine reflection-positivity
Gram block of the connected `2 x 1` cut slab — through the GNS machinery above,
obtaining a self-adjoint positive OS transfer operator on the slab's finite GNS
Hilbert space. -/

section Slab

open SlabTransferGap TransferHilbertBlock ReflectionPositivityKernel

variable {G : Type} [Group G] [Fintype G] [DecidableEq G] {n : ℕ}

/-- The connected slab's OS/GNS transfer operator on its finite GNS Hilbert
space `OSpace (slabTransferBlock beta rho)`. -/
def slabOsTransfer (beta : ℝ) (rho : G → Matrix (Fin n) (Fin n) ℂ) :
    OSpace (slabTransferBlock beta rho) →ₗ[ℂ] OSpace (slabTransferBlock beta rho) :=
  osTransfer (slabTransferBlock beta rho)

/-- **The connected slab's OS transfer operator is self-adjoint** for the GNS
inner product, built from `slabTransferBlock`'s Hermitian structure. -/
theorem slabOsTransfer_isSelfAdjoint
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (x y : OSpace (slabTransferBlock beta rho)) :
    osInner (slabTransferBlock beta rho)
        (slabTransferBlock_isHermitian beta hbeta rho hmul hone hunit)
        (osTransfer (slabTransferBlock beta rho) x) y
      = osInner (slabTransferBlock beta rho)
        (slabTransferBlock_isHermitian beta hbeta rho hmul hone hunit)
        x (osTransfer (slabTransferBlock beta rho) y) :=
  osTransfer_isSelfAdjoint (slabTransferBlock beta rho)
    (slabTransferBlock_isHermitian beta hbeta rho hmul hone hunit) x y

/-- **The connected slab's OS transfer operator is positive** for the GNS inner
product, built from `slabTransferBlock`'s PSD structure. -/
theorem slabOsTransfer_posSemidef
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (x : OSpace (slabTransferBlock beta rho)) :
    0 ≤ osInner (slabTransferBlock beta rho)
        (slabTransferBlock_isHermitian beta hbeta rho hmul hone hunit)
        x (osTransfer (slabTransferBlock beta rho) x) :=
  osTransfer_posSemidef (slabTransferBlock beta rho)
    (slabTransferBlock_posSemidef beta hbeta rho hmul hone hunit) x

/-- The finite GNS inner product core of the connected slab transfer block: a
genuine inner product space on the slab's OS quotient. -/
def slabOsInnerCore
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1) :
    InnerProductSpace.Core ℂ (OSpace (slabTransferBlock beta rho)) :=
  osInnerCore (slabTransferBlock beta rho)
    (slabTransferBlock_posSemidef beta hbeta rho hmul hone hunit)

/-! ## Deliverable 3: the spectral gap above the vacuum (`Z2` center sector)

On the exactly solvable one-link `Z2` center-sector slab, the OS-reconstructed
transfer operator has a genuine spectrum with a simple top eigenvalue (the
vacuum) `lambda0`, separated from the first excited center-flux eigenvalue
`lambdaFlux`.  The Hamiltonian `H = -log T` turns the multiplicative
transfer-spectral ratio into the additive spectral gap
`osSpectralGap = -log(lambdaFlux / lambda0)`, which is strictly positive.  This
is tied directly to `SlabTransferGap.neU4_closure_gap_pos`. -/

/-- **The OS spectral gap above the vacuum.**  The additive
Hamiltonian gap `H = -log T` between the vacuum eigenvalue and the lightest
nontrivial center-flux eigenvalue of the `Z2` center-sector slab transfer
operator.  It is `SlabTransferGap.neU4ClosureGap`. -/
def osSpectralGap (beta : ℝ) (hbeta : 0 < beta) : ℝ :=
  SlabTransferGap.neU4ClosureGap beta hbeta

/-- **Deliverable 3: the OS spectral gap lies above the vacuum.**  The gap is
strictly positive — the finite-slab Osterwalder-Seiler-regime statement, tied to
`SlabTransferGap.neU4_closure_gap_pos`.  (No continuum/physical mass gap is
claimed.) -/
theorem osSpectralGap_pos (beta : ℝ) (hbeta : 0 < beta) :
    0 < osSpectralGap beta hbeta :=
  SlabTransferGap.neU4_closure_gap_pos beta hbeta

/-- The OS spectral gap is the finite spectral-ratio gap of the leading two
eigenvalues: `gap = finiteMassGap lambda0 lambdaFlux`. -/
theorem osSpectralGap_eq_finiteMassGap (beta : ℝ) (hbeta : 0 < beta) :
    osSpectralGap beta hbeta =
      TransferGapDefinition.finiteMassGap
        (TwoStateTransferZ2Sector.lambda0 beta)
        (TwoStateTransferZ2Sector.lambdaFlux beta) := by
  rw [osSpectralGap, SlabTransferGap.neU4ClosureGap_eq_fluxGap,
    FluxSectorZ2.fluxGap_eq_finiteMassGap]

/-- **`gap = -log(second / top eigenvalue ratio)`.**  The Hamiltonian gap is
the negative logarithm of the transfer-spectral ratio (first excited over
vacuum). -/
theorem osSpectralGap_eq_neg_log_ratio (beta : ℝ) (hbeta : 0 < beta) :
    osSpectralGap beta hbeta =
      -Real.log (TwoStateTransferZ2Sector.lambdaFlux beta
        / TwoStateTransferZ2Sector.lambda0 beta) := by
  rw [osSpectralGap_eq_finiteMassGap]; rfl

/-- Strong-coupling read-off: the OS spectral gap equals `-log(tanh beta)`, the
one-link flux cost / string-tension-per-plaquette value. -/
theorem osSpectralGap_eq_neg_log_tanh (beta : ℝ) (hbeta : 0 < beta) :
    osSpectralGap beta hbeta = -Real.log (Real.tanh beta) :=
  SlabTransferGap.neU4_closure_gap_eq_neg_log_tanh beta hbeta

/-- The vacuum eigenvalue is strictly separated from (above) the first excited
center-flux eigenvalue: the top of the spectrum is a genuine gap above the
vacuum. -/
theorem osVacuum_separated (beta : ℝ) :
    TwoStateTransferZ2Sector.lambdaFlux beta
      < TwoStateTransferZ2Sector.lambda0 beta :=
  TwoStateTransferZ2Sector.lambdaFlux_lt_lambda0 beta

/-- The vacuum eigenvalue is strictly positive (the top of the transfer
spectrum on which `H = -log T` is defined). -/
theorem osVacuum_pos (beta : ℝ) :
    0 < TwoStateTransferZ2Sector.lambda0 beta :=
  TwoStateTransferZ2Sector.lambda0_pos beta

/-- The vacuum and the flux excitation live in genuinely DISTINCT center
sectors: the OS spectral gap above the vacuum is a distinct-center-sector
separation, not a within-trivial-sector local/glueball gap. -/
theorem osSectors_disjoint :
    TwoStateTransferZ2Sector.vacuumCenterSector ⊓
        TwoStateTransferZ2Sector.fluxCenterSector = ⊥ :=
  SlabTransferGap.neU4_sectors_disjoint

/-!
## Documented handoff (heaviest node, deliberately not asserted)

Deliverable 3 realises the strictly positive OS spectral gap above the vacuum
through the exactly solvable one-link `Z2` center-sector slab
(`TwoStateTransferZ2Sector`), a genuine — if smaller — Wilson slab, exactly as
`SlabTransferGap.neU4_closure_gap_pos` does.  Diagonalising the *full* connected
two-plaquette block `slabTransferBlock` in its `Z2` center-flux sectors and
identifying its own leading two sector eigenvalues with `lambda0` / `lambdaFlux`
(so that `osSpectralGap` becomes the spectral gap of the descended `osTransfer`
on `OSpace (slabTransferBlock ...)` rather than of the reduced one-link slab) is
the remaining spectral-bridge work.  Per the F-YM-CONFLATE guard it is NOT
asserted here, and no physical/continuum mass gap is claimed.
-/

end Slab

end OSReconstruction
end GateYM
end NullEdge
end Draft
end PhysicsSM
