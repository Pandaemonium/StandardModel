import PhysicsSM.Draft.NullEdgeHyperdiamondBridge

/-!
# Hyperdiamond operator scaffold

This module adds the next Lean-facing reconstruction layer after the
hyperdiamond bridge.

The current package has an exact frame/covector/symbol-square bridge, but it
does not yet define a named Borici-Creutz or hyperdiamond finite-difference
operator. This file therefore introduces a conservative first-order stencil API:

* a finite set of four tetrahedral edge coefficients;
* a Fourier symbol and a linear principal symbol;
* an exact crosswalk predicate saying that the principal symbol is the Gate C
  Clifford symbol;
* consequences of such a crosswalk, including the inherited square law and the
  inherited bare-symbol chirality no-go.

The file also separates the algebraic `chiralProj` facts from the still-missing
physical projector audit obligations.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeHyperdiamondOperatorScaffold

open Matrix
open scoped BigOperators

open PhysicsSM.Draft.TetrahedralNullBranch
open PhysicsSM.Draft.NullEdgeActualCliffordSymbol
open PhysicsSM.Draft.NullEdgeFlavoredChirality
open PhysicsSM.Draft.NullEdgeHyperdiamondNoGo
open PhysicsSM.Draft.NullEdgeHyperdiamondBridge

/-! ## First-order tetrahedral stencil -/

/-- A first-order tetrahedral hyperdiamond stencil.

`edgeCoeff a` is the spin matrix attached to the null/tetrahedral edge `a`.
`onsite` is the momentum-independent term. The intended Fourier variables are
abstract complex edge phases, so this structure is finite algebra only. -/
structure HyperdiamondFirstOrderStencil where
  edgeCoeff : Fin 4 -> CMat4
  onsite : CMat4

namespace HyperdiamondFirstOrderStencil

/-- Fourier symbol of a finite first-order stencil in abstract edge variables
`z a`. -/
def fourierSymbol (D : HyperdiamondFirstOrderStencil) (z : Fin 4 -> Complex) :
    CMat4 :=
  D.onsite + Finset.univ.sum (fun a : Fin 4 => z a • D.edgeCoeff a)

/-- Linear/principal symbol extracted from the edge coefficients. -/
def linearSymbol (D : HyperdiamondFirstOrderStencil) (u : Fin 4 -> Complex) :
    CMat4 :=
  Finset.univ.sum (fun a : Fin 4 => u a • D.edgeCoeff a)

/-- The finite coefficient support of a first-order stencil. -/
def coefficientSupport (D : HyperdiamondFirstOrderStencil) : Finset (Fin 4) :=
  Finset.univ.filter (fun a : Fin 4 => D.edgeCoeff a ≠ 0)

/-- The coefficient support is literally the set of nonzero edge coefficients. -/
theorem mem_coefficientSupport (D : HyperdiamondFirstOrderStencil) (a : Fin 4) :
    a ∈ D.coefficientSupport <-> D.edgeCoeff a ≠ 0 := by
  simp [coefficientSupport]

/-- First-order tetrahedral stencils have at most four edge coefficients. This
is only finite-range bookkeeping, not a physical locality theorem on a
position-space lattice. -/
theorem coefficientSupport_card_le_four (D : HyperdiamondFirstOrderStencil) :
    D.coefficientSupport.card <= 4 := by
  calc
    D.coefficientSupport.card <= (Finset.univ : Finset (Fin 4)).card :=
      Finset.card_filter_le _ _
    _ = 4 := by simp

end HyperdiamondFirstOrderStencil

/-! ## Gate C principal-symbol crosswalk -/

/-- Exact principal-symbol crosswalk to the Gate C tetrahedral Clifford symbol.

This is the theorem target a concrete Borici-Creutz/hyperdiamond stencil should
either prove or refute after its coefficients and conventions are fixed. -/
def GateCPrincipalCrosswalk (D : HyperdiamondFirstOrderStencil) : Prop :=
  forall u : Fin 4 -> Complex,
    D.linearSymbol u = cliffordSymbol (pCov u)

/-- A stencil satisfying the Gate C crosswalk inherits the Gate C kinetic square
law. -/
theorem crosswalk_linearSymbol_sq (D : HyperdiamondFirstOrderStencil)
    (hD : GateCPrincipalCrosswalk D) (u : Fin 4 -> Complex) :
    D.linearSymbol u * D.linearSymbol u = (qform u) • (1 : CMat4) := by
  rw [hD u, gateC_symbol_sq_kinetic]

/-- On each high-momentum branch, a stencil satisfying the Gate C crosswalk has
the same balanced bare kernel as the Gate C Clifford symbol. -/
theorem crosswalk_branch_kernel_balanced (D : HyperdiamondFirstOrderStencil)
    (hD : GateCPrincipalCrosswalk D) (a : Fin 4) :
    ∃ vplus vminus : Spin -> Complex,
      (vplus ≠ 0 ∧ D.linearSymbol (cornerU (tasteCorner a)) *ᵥ vplus = 0 ∧
        gamma5 *ᵥ vplus = vplus) ∧
      (vminus ≠ 0 ∧ D.linearSymbol (cornerU (tasteCorner a)) *ᵥ vminus = 0 ∧
        gamma5 *ᵥ vminus = -vminus) ∧
      LinearIndependent Complex ![vplus, vminus] := by
  obtain ⟨vplus, vminus, hvplus, hvminus, hlin⟩ := branchKernel_chirality_sign a
  refine ⟨vplus, vminus, ?_, ?_, hlin⟩
  · refine ⟨hvplus.1, ?_, hvplus.2.2⟩
    rw [hD (cornerU (tasteCorner a))]
    simpa [branchP] using hvplus.2.1
  · refine ⟨hvminus.1, ?_, hvminus.2.2⟩
    rw [hD (cornerU (tasteCorner a))]
    simpa [branchP] using hvminus.2.1

/-- Stencil-level version of assigning one `gamma5` sign to every bare branch
kernel. -/
def StencilAssignsSingleSign (D : HyperdiamondFirstOrderStencil)
    (eps : Fin 4 -> Complex) : Prop :=
  forall a, forall v : Spin -> Complex,
    v ≠ 0 ->
    D.linearSymbol (cornerU (tasteCorner a)) *ᵥ v = 0 ->
    gamma5 *ᵥ v = (eps a) • v

/-- Any stencil whose principal symbol is exactly the Gate C symbol inherits the
bare-symbol chirality no-go. A physical construction must therefore add data
beyond this bare principal symbol. -/
theorem crosswalk_no_single_chirality (D : HyperdiamondFirstOrderStencil)
    (hD : GateCPrincipalCrosswalk D) :
    Not (exists eps : Fin 4 -> Complex, StencilAssignsSingleSign D eps) := by
  intro h
  apply no_full_symbol_single_chirality
  rcases h with ⟨eps, heps⟩
  refine ⟨eps, ?_⟩
  intro a v hv hker
  apply heps a v hv
  rw [hD (cornerU (tasteCorner a))]
  simpa [branchP] using hker

/-! ## A concrete stencil realizing the Gate C principal symbol -/

/-- The concrete Gate C tetrahedral first-order stencil.

Each edge coefficient is the flat Clifford symbol of the corresponding
tetrahedral dual-frame covector, and the onsite term is zero. This is the Gate C
symbol packaged as a first-order stencil. It is deliberately not claimed to be
the Borici-Creutz operator, whose signs, phases, normalization, basis order, and
typically a fifth vector plus shifted onsite term are a separate convention
question. -/
def gateCStencil : HyperdiamondFirstOrderStencil where
  edgeCoeff := fun a => cliffordSymbol (fun mu => alpha a mu)
  onsite := 0

/-- The concrete Gate C stencil realizes the Gate C principal-symbol crosswalk:
its linear symbol is exactly `cliffordSymbol (pCov u)`. -/
theorem gateCStencil_crosswalk : GateCPrincipalCrosswalk gateCStencil := by
  intro u
  unfold gateCStencil pCov
  simp +decide [HyperdiamondFirstOrderStencil.linearSymbol, Finset.sum_smul,
    Finset.smul_sum, smul_smul, cliffordSymbol_eq_sum]
  exact Finset.sum_comm

/-- Consequently the concrete Gate C stencil inherits the bare-symbol chirality
no-go: no assignment of a single `gamma5` sign to all four bare branch kernels
exists. Any physical single-chirality release therefore needs data beyond this
bare four-edge stencil. -/
theorem gateCStencil_no_single_chirality :
    Not (exists eps : Fin 4 -> Complex,
      StencilAssignsSingleSign gateCStencil eps) :=
  crosswalk_no_single_chirality gateCStencil gateCStencil_crosswalk

/-- The concrete Gate C stencil inherits the kinetic square law. -/
theorem gateCStencil_linearSymbol_sq (u : Fin 4 -> Complex) :
    gateCStencil.linearSymbol u * gateCStencil.linearSymbol u =
      (qform u) • (1 : CMat4) :=
  crosswalk_linearSymbol_sq gateCStencil gateCStencil_crosswalk u

/-- The concrete Gate C stencil has the same balanced branch kernel as the Gate
C Clifford symbol. -/
theorem gateCStencil_branch_kernel_balanced (a : Fin 4) :
    ∃ vplus vminus : Spin -> Complex,
      (vplus ≠ 0 ∧ gateCStencil.linearSymbol (cornerU (tasteCorner a)) *ᵥ vplus = 0 ∧
        gamma5 *ᵥ vplus = vplus) ∧
      (vminus ≠ 0 ∧ gateCStencil.linearSymbol (cornerU (tasteCorner a)) *ᵥ vminus = 0 ∧
        gamma5 *ᵥ vminus = -vminus) ∧
      LinearIndependent Complex ![vplus, vminus] :=
  crosswalk_branch_kernel_balanced gateCStencil gateCStencil_crosswalk a

/-- The Gate C stencil has at most four nonzero edge coefficients in the
abstract first-order stencil API. This remains finite coefficient bookkeeping,
not a position-space locality theorem. -/
theorem gateCStencil_coefficientSupport_card_le_four :
    gateCStencil.coefficientSupport.card <= 4 :=
  HyperdiamondFirstOrderStencil.coefficientSupport_card_le_four gateCStencil

/-! ## Borici-Creutz convention-data scaffold -/

/-- Convention data that must be fixed before comparing a named Borici-Creutz
or hyperdiamond fermion operator with the Gate C principal symbol.

The fields deliberately separate nearest-neighbor edge coefficients from the
extra fifth-vector/shifted onsite term recorded in the literature. The
`nearestNeighborStencil` below uses only the first-order four-edge part; any
claim about a full named operator must account for the remaining fields
explicitly. -/
structure BoriciCreutzConventionData where
  edgeCoeff : Fin 4 -> CMat4
  edgePhase : Fin 4 -> Complex
  onsite : CMat4
  fifthVectorCoeff : CMat4
  poleLocation : Fin 2 -> Fin 4 -> Complex
  normalization : Complex
  flavoredChirality : CMat4

namespace BoriciCreutzConventionData

/-- The first-order four-edge stencil extracted from Borici-Creutz convention
data. This is intentionally only the nearest-neighbor principal part; it does
not consume the recorded fifth-vector coefficient or flavored-chirality data. -/
def nearestNeighborStencil (data : BoriciCreutzConventionData) :
    HyperdiamondFirstOrderStencil where
  edgeCoeff := fun a => data.edgePhase a • data.edgeCoeff a
  onsite := data.onsite

end BoriciCreutzConventionData

/-- Predicate that the nearest-neighbor Borici-Creutz convention data has the
same principal symbol as Gate C. This is a target/audit predicate, not an
assertion that any literature convention has already been matched. -/
def BoriciCreutzNearestPrincipalCrosswalk
    (data : BoriciCreutzConventionData) : Prop :=
  GateCPrincipalCrosswalk data.nearestNeighborStencil

/-- If a Borici-Creutz convention's nearest-neighbor principal symbol is exactly
Gate C, then its bare first-order stencil inherits the Gate C chirality no-go.
A physical release must therefore use additional data such as the fifth-vector
term, shifted onsite term, pole/flavor information, or a modified chirality
operator. -/
theorem boriciCreutzNearest_no_single_chirality
    (data : BoriciCreutzConventionData)
    (hdata : BoriciCreutzNearestPrincipalCrosswalk data) :
    Not (exists eps : Fin 4 -> Complex,
      StencilAssignsSingleSign data.nearestNeighborStencil eps) :=
  crosswalk_no_single_chirality data.nearestNeighborStencil hdata

/-! ## Fifth-vector obstruction to a nearest-neighbor equivalence

The `nearestNeighborStencil` deliberately consumes only the four-edge principal
part of the convention data and drops `fifthVectorCoeff`. The Borici-Creutz and
related minimally-doubled actions in the literature carry a genuine fifth-vector
(Wilson-like) first-order term. The lemmas below make that omission explicit and
provable: whenever the fifth-vector coefficient is nonzero, the honest full
first-order symbol strictly exceeds the nearest-neighbor symbol, so a Gate C
crosswalk on the nearest-neighbor part alone cannot be a full Borici-Creutz
operator equivalence. This is a precise mismatch statement, not a claimed
equivalence. -/

/-- A Borici-Creutz convention "needs the fifth vector" exactly when its
recorded fifth-vector coefficient is nonzero. -/
def BoriciCreutzConventionData.RequiresFifthVector
    (data : BoriciCreutzConventionData) : Prop :=
  data.fifthVectorCoeff ≠ 0

/-- The honest full first-order symbol of a Borici-Creutz convention: the
nearest-neighbor four-edge symbol plus the fifth-vector direction carrying its
own abstract edge variable `w`. -/
def BoriciCreutzConventionData.fullFirstOrderSymbol
    (data : BoriciCreutzConventionData) (u : Fin 4 -> Complex) (w : Complex) :
    CMat4 :=
  data.nearestNeighborStencil.linearSymbol u + w • data.fifthVectorCoeff

/-- A first-order stencil's linear symbol vanishes at zero momentum. -/
theorem HyperdiamondFirstOrderStencil.linearSymbol_zero
    (D : HyperdiamondFirstOrderStencil) :
    D.linearSymbol (fun _ => 0) = 0 := by
  simp [HyperdiamondFirstOrderStencil.linearSymbol]

/-- Precise mismatch: whenever a convention carries a nonzero fifth-vector term,
its full first-order symbol differs from its nearest-neighbor symbol already at
zero four-edge momentum. Hence, even a convention whose nearest-neighbor
principal symbol equals Gate C is not thereby a full Borici-Creutz operator: the
fifth-vector data is unaccounted for. -/
theorem boriciCreutz_fullSymbol_ne_nearest_of_requiresFifthVector
    (data : BoriciCreutzConventionData) (h : data.RequiresFifthVector) :
    ∃ u w, data.fullFirstOrderSymbol u w ≠
      data.nearestNeighborStencil.linearSymbol u := by
  refine ⟨fun _ => 0, 1, ?_⟩
  rw [BoriciCreutzConventionData.fullFirstOrderSymbol,
    HyperdiamondFirstOrderStencil.linearSymbol_zero]
  simpa using h

/-! ## Source-side pole/excitation predicates and the no-four-edge no-go

This section makes the target `hyperdiamond_no_four_edge_pole_structure`
precise. The intended physical picture is that a full first-order lattice Dirac
symbol carries an extra fifth-vector, Wilson-like direction whose variable `w`
shifts the pole/excitation structure and lifts doublers. A four-edge
nearest-neighbor stencil produces a principal symbol depending only on the four
edge variables `u`; it has no `w` dependence.

No source constants are introduced: the fifth-vector coefficient, edge
coefficients, pole locations, and chirality operator remain abstract data. -/

/-- A full first-order symbol: four abstract edge variables `u` and one
fifth-vector variable `w`. -/
abbrev FullFirstOrderSymbol := (Fin 4 -> Complex) -> Complex -> CMat4

/-- Source-side excitation/pole predicate: at momentum data `(u, w)` the symbol
`S` has a nonzero kernel vector, i.e. a propagating mode or pole. This is data on
an abstract symbol, not a physical claim about any named operator. -/
def IsExcitation (S : FullFirstOrderSymbol) (u : Fin 4 -> Complex) (w : Complex) :
    Prop :=
  ∃ v : Spin -> Complex, v ≠ 0 ∧ S u w *ᵥ v = 0

/-- A full symbol `S` is realized by a four-edge nearest-neighbor stencil when
there is a first-order tetrahedral stencil `D` whose linear symbol reproduces `S`
for all momenta. Because `D.linearSymbol` never sees `w`, this forces `S` to be
independent of the fifth-vector variable. -/
def RealizedByFourEdgeStencil (S : FullFirstOrderSymbol) : Prop :=
  ∃ D : HyperdiamondFirstOrderStencil, ∀ u w, S u w = D.linearSymbol u

/-- Genuine fifth-vector dependence: some momentum `u` gives two distinct symbol
values under two fifth-vector variables. This is the weakest source-side
requirement that already blocks a four-edge realization. -/
def GenuineFifthVectorDependence (S : FullFirstOrderSymbol) : Prop :=
  ∃ u w1 w2, S u w1 ≠ S u w2

/-- Source-side pole-structure requirement: at some edge momentum `u`, switching
the fifth-vector variable from `w1` to `w2` changes whether the point is an
excitation/pole. This is exactly the statement that the required pole structure
needs the fifth vector. It is a data predicate on `S`, not a physical claim. -/
def PoleStructureNeedsFifthVector (S : FullFirstOrderSymbol) : Prop :=
  ∃ u w1 w2, IsExcitation S u w1 ∧ ¬ IsExcitation S u w2

/-- A four-edge realization is constant in the fifth-vector variable. -/
theorem RealizedByFourEdgeStencil.const_in_fifth
    {S : FullFirstOrderSymbol} (hS : RealizedByFourEdgeStencil S)
    (u : Fin 4 -> Complex) (w1 w2 : Complex) : S u w1 = S u w2 := by
  obtain ⟨D, hD⟩ := hS
  rw [hD u w1, hD u w2]

/-- If a full symbol is realized by a four-edge stencil, its excitation/pole set
cannot depend on the fifth-vector variable. -/
theorem RealizedByFourEdgeStencil.isExcitation_w_indep
    {S : FullFirstOrderSymbol} (hS : RealizedByFourEdgeStencil S)
    (u : Fin 4 -> Complex) (w1 w2 : Complex) :
    IsExcitation S u w1 ↔ IsExcitation S u w2 := by
  unfold IsExcitation
  rw [hS.const_in_fifth u w1 w2]

/-- No-go, genuine fifth-vector form: a symbol with genuine fifth-vector
dependence is not realized by any four-edge nearest-neighbor stencil. -/
theorem not_realizedByFourEdgeStencil_of_genuineFifthVectorDependence
    {S : FullFirstOrderSymbol} (h : GenuineFifthVectorDependence S) :
    ¬ RealizedByFourEdgeStencil S := by
  intro hS
  obtain ⟨u, w1, w2, hne⟩ := h
  exact hne (hS.const_in_fifth u w1 w2)

/-- No-go, pole-structure form: if the required pole/excitation structure needs
the fifth vector, then no four-edge nearest-neighbor stencil realizes the full
symbol. This is the source-independent core of
`hyperdiamond_no_four_edge_pole_structure`. -/
theorem not_realizedByFourEdgeStencil_of_poleStructureNeedsFifthVector
    {S : FullFirstOrderSymbol} (h : PoleStructureNeedsFifthVector S) :
    ¬ RealizedByFourEdgeStencil S := by
  intro hS
  obtain ⟨u, w1, w2, hexc, hnexc⟩ := h
  exact hnexc ((hS.isExcitation_w_indep u w1 w2).mp hexc)

/-- The full first-order symbol of a convention, packaged as a
`FullFirstOrderSymbol`. -/
def BoriciCreutzConventionData.fullSymbol (data : BoriciCreutzConventionData) :
    FullFirstOrderSymbol :=
  fun u w => data.fullFirstOrderSymbol u w

/-- A convention requiring the fifth vector has genuine fifth-vector dependence
in its full symbol: fixing any edge momentum and comparing `w = 0` with `w = 1`
already gives distinct symbol values. -/
theorem boriciCreutz_fullSymbol_genuineFifthVectorDependence
    (data : BoriciCreutzConventionData) (h : data.RequiresFifthVector) :
    GenuineFifthVectorDependence data.fullSymbol := by
  refine ⟨fun _ => 0, 0, 1, ?_⟩
  simp only [BoriciCreutzConventionData.fullSymbol,
    BoriciCreutzConventionData.fullFirstOrderSymbol]
  simpa using h

/-- No four-edge pole structure. The full first-order symbol of a Borici-Creutz
convention that genuinely requires a nonzero fifth-vector term is not realized
by any four-edge nearest-neighbor stencil. Equivalently, no four-edge
nearest-neighbor stencil can reproduce a full first-order symbol whose
pole/excitation structure depends on the fifth vector. This is a
source-independent no-go: it fixes no signs, phases, normalization, pole
locations, or chirality convention. -/
theorem hyperdiamond_no_four_edge_pole_structure
    (data : BoriciCreutzConventionData) (h : data.RequiresFifthVector) :
    ¬ RealizedByFourEdgeStencil data.fullSymbol :=
  not_realizedByFourEdgeStencil_of_genuineFifthVectorDependence
    (boriciCreutz_fullSymbol_genuineFifthVectorDependence data h)

/-! ## Projector audit separation -/

/-- Algebraic projector facts that the current `chiralProj` really supplies. -/
structure ProjectorAlgebraicAudit
    (P : Fin 4 -> (Spin -> Complex) -> (Spin -> Complex)) : Prop where
  idempotent : forall a v, P a (P a v) = P a v
  forcesAlignment : OperatorForcesAlignmentAfterProjection P

/-- The current `chiralProj` passes the algebraic sufficiency audit: it is
idempotent and forces the selected chirality after projection. -/
theorem chiralProj_algebraicAudit : ProjectorAlgebraicAudit chiralProj := by
  refine ⟨?_, chiralProj_forces_alignment⟩
  intro a v
  exact chiralProj_idempotent a v

/-- Names for the physical obligations still missing from a projector-based
release argument. Future modules should replace these free proposition fields
with concrete definitions attached to a position-space operator. -/
structure ProjectorPhysicalPredicates
    (D : HyperdiamondFirstOrderStencil)
    (P : Fin 4 -> (Spin -> Complex) -> (Spin -> Complex)) where
  localFiniteRange : Prop
  gaugeCovariant : Prop
  kreinCompatible : Prop
  branchDataOperatorDerived : Prop

/-- A complete physical projector audit requires the algebraic facts plus the
four physical certificates. This is deliberately a schema, not an instantiated
theorem for `chiralProj`. -/
structure ProjectorPhysicalAudit
    (D : HyperdiamondFirstOrderStencil)
    (P : Fin 4 -> (Spin -> Complex) -> (Spin -> Complex))
    (pred : ProjectorPhysicalPredicates D P) : Prop where
  algebraic : ProjectorAlgebraicAudit P
  localFiniteRange : pred.localFiniteRange
  gaugeCovariant : pred.gaugeCovariant
  kreinCompatible : pred.kreinCompatible
  branchDataOperatorDerived : pred.branchDataOperatorDerived

/-- Any complete physical audit includes the algebraic audit, but the converse
is intentionally not stated. -/
theorem physicalAudit_implies_algebraic
    (D : HyperdiamondFirstOrderStencil)
    (P : Fin 4 -> (Spin -> Complex) -> (Spin -> Complex))
    (pred : ProjectorPhysicalPredicates D P)
    (h : ProjectorPhysicalAudit D P pred) :
    ProjectorAlgebraicAudit P :=
  h.algebraic

end PhysicsSM.Draft.NullEdgeHyperdiamondOperatorScaffold
