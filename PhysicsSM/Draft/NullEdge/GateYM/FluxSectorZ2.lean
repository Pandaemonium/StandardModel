import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.FluxSectorGeneral
import PhysicsSM.Draft.NullEdge.GateYM.TransferGapDefinition
import PhysicsSM.Draft.NullEdge.GateYM.TorusEvenCover

/-!
# Gate YM T3: Z2 flux-sector skeleton

This draft module starts queue item Q3 of the four-day YM run:
sector-correct D12 transfer-gap bookkeeping on the Z2 torus. The point of
the file is deliberately narrow:

* name the two Z2 winding-flux bits;
* build the trivial-flux clause into the existing `SymmetrySector` API;
* distinguish the global flux gap from the local/glueball gap in Lean names;
* record the abstract preservation lemma needed by later transfer and local
  plaquette-algebra statements;
* expose the diagonal sector projection and prove that any kernel with no
  matrix entries between different winding labels preserves sectors and
  commutes with the projection.

It does not construct the transfer matrix, prove a spectral theorem, or claim
that the local gap is positive. The concrete winding-cycle holonomy
realization starts here at the Bool-array level; the Q2 transfer-matrix
construction is a successor task.

Provenance: `Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md`, section 14,
Q3, and `AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md`,
`design:q3-flux-sector` resolved 1.09:03. The Z2 torus is chosen because it
is the oracle-identified finite test case where global flux sectors can be
mistaken for the local/glueball gap.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite definition / sector bookkeeping**.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace FluxSectorZ2

/-- Z2 winding-flux labels on a two-dimensional torus: one bit for each
fundamental cycle. `false` is the trivial Z2 holonomy bit. -/
structure FluxLabel where
  xFlux : Bool
  yFlux : Bool
deriving DecidableEq, Repr

namespace FluxLabel

/-- The trivial-flux label: no winding flux in either fundamental direction. -/
def trivial : FluxLabel where
  xFlux := false
  yFlux := false

/-- A label is trivial exactly when both winding bits vanish. -/
def IsTrivial (l : FluxLabel) : Prop :=
  l = trivial

theorem isTrivial_trivial : IsTrivial trivial := rfl

theorem isTrivial_iff (l : FluxLabel) :
    l.IsTrivial ↔ l.xFlux = false ∧ l.yFlux = false := by
  cases l
  simp [IsTrivial, trivial]

theorem ext_iff (a b : FluxLabel) :
    a = b ↔ a.xFlux = b.xFlux ∧ a.yFlux = b.yFlux := by
  constructor
  · intro h
    cases h
    exact ⟨rfl, rfl⟩
  · intro h
    cases a
    cases b
    simp at h
    simp [h.1, h.2]

end FluxLabel

/-- The Z2 torus quantum numbers used by the D12 sector convention.

The fields are intentionally separate: Gauss invariance, spatial momentum,
and winding flux are different labels. The Q3 local/glueball gap uses the
trivial-flux sector, not the full Gauss-invariant space. -/
structure QuantumNumbers (State : Type*) where
  gaussInvariant : State -> Prop
  zeroMomentum : State -> Prop
  fluxLabel : State -> FluxLabel

namespace QuantumNumbers

variable {State : Type*} (Q : QuantumNumbers State)

/-- The trivial winding-flux predicate induced by a Z2 flux label. -/
def trivialFlux (psi : State) : Prop :=
  Q.fluxLabel psi = FluxLabel.trivial

/-- The underlying `TransferGapDefinition.SymmetrySector` selected by the
Z2 torus quantum numbers. This is the API bridge to the existing D12
`finiteMassGap` convention. -/
def symmetrySector : TransferGapDefinition.SymmetrySector State where
  gaussInvariant := Q.gaussInvariant
  zeroMomentum := Q.zeroMomentum
  trivialFlux := Q.trivialFlux

/-- Membership in a named Z2 flux sector. -/
def InFluxSector (label : FluxLabel) (psi : State) : Prop :=
  Q.fluxLabel psi = label

theorem inFluxSector_trivial_iff (psi : State) :
    Q.InFluxSector FluxLabel.trivial psi ↔ Q.trivialFlux psi := by
  rfl

/-- The vacuum-sector predicate unfolds to Gauss invariance, zero momentum,
and the trivial Z2 winding-flux label. -/
theorem vacuum_iff (psi : State) :
    (Q.symmetrySector).vacuum psi ↔
      Q.gaussInvariant psi ∧ Q.zeroMomentum psi ∧ Q.trivialFlux psi := by
  rfl

theorem vacuum_fluxLabel_eq_trivial {psi : State}
    (hpsi : (Q.symmetrySector).vacuum psi) :
    Q.fluxLabel psi = FluxLabel.trivial :=
  hpsi.2.2

end QuantumNumbers

/-! ## Concrete Z2 torus winding labels -/

/-- XOR product of a finite list of Z2 link bits. `false` is the identity
bit and `true` is the nontrivial Z2 bit. -/
def xorList : List Bool -> Bool
  | [] => false
  | b :: bs => b ^^ xorList bs

theorem xorList_nil : xorList [] = false := rfl

theorem xorList_cons (b : Bool) (bs : List Bool) :
    xorList (b :: bs) = (b ^^ xorList bs) := rfl

/-- XOR distributes over pointwise XOR of finite tuples. This is the Bool/Z2
parity bookkeeping used by the winding-label preservation lemmas below. -/
theorem xorList_ofFn_xor {n : Nat} (a b : Fin n -> Bool) :
    xorList (List.ofFn (fun i => a i ^^ b i)) =
      (xorList (List.ofFn a) ^^ xorList (List.ofFn b)) := by
  induction n with
  | zero =>
      simp [xorList]
  | succ n ih =>
      rw [List.ofFn_succ, List.ofFn_succ, List.ofFn_succ]
      simp [xorList, ih]
      cases a 0 <;> cases b 0 <;>
        cases xorList (List.ofFn fun i : Fin n => a i.succ) <;>
        cases xorList (List.ofFn fun i : Fin n => b i.succ) <;> rfl

/-- XOR of a list is invariant under list permutation. -/
theorem xorList_perm {xs ys : List Bool} (h : List.Perm xs ys) :
    xorList xs = xorList ys := by
  induction h with
  | nil =>
      rfl
  | cons b h ih =>
      simp [xorList, ih]
  | swap b c bs =>
      cases b <;> cases c <;> cases xorList bs <;> simp [xorList]
  | trans _ _ ih1 ih2 =>
      exact ih1.trans ih2

/-- XOR of a finite tuple is invariant under a permutation of its index set. -/
theorem xorList_ofFn_comp_perm {n : Nat} (sigma : Equiv.Perm (Fin n))
    (a : Fin n -> Bool) :
    xorList (List.ofFn (fun i => a (sigma i))) = xorList (List.ofFn a) := by
  exact xorList_perm (Equiv.Perm.ofFn_comp_perm sigma a)

/-- A concrete Z2 link field on an `Lx` by `Ly` periodic torus, represented
by horizontal and vertical link bits. `hLink i j` is the link from
`(i,j)` to `(i+1,j)` and `vLink i j` is the link from `(i,j)` to
`(i,j+1)`, with periodic wrap understood by the torus convention. -/
structure TorusLinkField (Lx Ly : Nat) where
  hLink : Fin Lx -> Fin Ly -> Bool
  vLink : Fin Lx -> Fin Ly -> Bool
deriving Fintype

/-- Multiplicative Z2 link factors for updating a torus link field. A later
file can instantiate these factors as vertex-gauge coboundaries or local
plaquette flips; this module only proves the base-cycle cancellation rule. -/
structure LinkFactor (Lx Ly : Nat) where
  hFactor : Fin Lx -> Fin Ly -> Bool
  vFactor : Fin Lx -> Fin Ly -> Bool

namespace TorusLinkField

variable {Lx Ly : Nat}

/-- The Z2 holonomy bit around a horizontal winding cycle at fixed `j`. -/
def xCycleFlux (U : TorusLinkField Lx Ly) (j : Fin Ly) : Bool :=
  xorList (List.ofFn (fun i : Fin Lx => U.hLink i j))

/-- The Z2 holonomy bit around a vertical winding cycle at fixed `i`. -/
def yCycleFlux (U : TorusLinkField Lx Ly) (i : Fin Lx) : Bool :=
  xorList (List.ofFn (fun j : Fin Ly => U.vLink i j))

/-- The base horizontal cycle uses row `0`. -/
def baseY {Ly : Nat} (hLy : 0 < Ly) : Fin Ly :=
  ⟨0, hLy⟩

/-- The base vertical cycle uses column `0`. -/
def baseX {Lx : Nat} (hLx : 0 < Lx) : Fin Lx :=
  ⟨0, hLx⟩

/-- The concrete Z2 winding-flux label from the two base cycles. -/
def windingLabel (hLx : 0 < Lx) (hLy : 0 < Ly)
    (U : TorusLinkField Lx Ly) : FluxLabel where
  xFlux := U.xCycleFlux (baseY hLy)
  yFlux := U.yCycleFlux (baseX hLx)

/-- The trivial-winding predicate for a concrete Z2 torus link field. -/
def HasTrivialWinding (hLx : 0 < Lx) (hLy : 0 < Ly)
    (U : TorusLinkField Lx Ly) : Prop :=
  (windingLabel hLx hLy U).IsTrivial

theorem windingLabel_xFlux (hLx : 0 < Lx) (hLy : 0 < Ly)
    (U : TorusLinkField Lx Ly) :
    (windingLabel hLx hLy U).xFlux = U.xCycleFlux (baseY hLy) := rfl

theorem windingLabel_yFlux (hLx : 0 < Lx) (hLy : 0 < Ly)
    (U : TorusLinkField Lx Ly) :
    (windingLabel hLx hLy U).yFlux = U.yCycleFlux (baseX hLx) := rfl

/-- A concrete Z2 torus field has trivial winding exactly when both base
cycle XOR holonomies vanish. -/
theorem hasTrivialWinding_iff (hLx : 0 < Lx) (hLy : 0 < Ly)
    (U : TorusLinkField Lx Ly) :
    HasTrivialWinding hLx hLy U ↔
      U.xCycleFlux (baseY hLy) = false ∧ U.yCycleFlux (baseX hLx) = false := by
  unfold HasTrivialWinding windingLabel
  exact FluxLabel.isTrivial_iff _

/-- If either base winding bit is nontrivial, the concrete field is outside
the D12 local/glueball sector. -/
theorem not_hasTrivialWinding_of_xFlux_true (hLx : 0 < Lx) (hLy : 0 < Ly)
    (U : TorusLinkField Lx Ly)
    (hx : U.xCycleFlux (baseY hLy) = true) :
    ¬ HasTrivialWinding hLx hLy U := by
  intro htriv
  have hxfalse := (hasTrivialWinding_iff hLx hLy U).mp htriv |>.1
  simp [hx] at hxfalse

theorem not_hasTrivialWinding_of_yFlux_true (hLx : 0 < Lx) (hLy : 0 < Ly)
    (U : TorusLinkField Lx Ly)
    (hy : U.yCycleFlux (baseX hLx) = true) :
    ¬ HasTrivialWinding hLx hLy U := by
  intro htriv
  have hyfalse := (hasTrivialWinding_iff hLx hLy U).mp htriv |>.2
  simp [hy] at hyfalse

/-- Update every link by a Z2 link factor, separately for horizontal and
vertical links. -/
def applyLinkFactor (eta : LinkFactor Lx Ly) (U : TorusLinkField Lx Ly) :
    TorusLinkField Lx Ly where
  hLink i j := eta.hFactor i j ^^ U.hLink i j
  vLink i j := eta.vFactor i j ^^ U.vLink i j

/-- The Z2 coboundary link factor generated by a vertex gauge bit
`gamma`. Horizontal factors compare a vertex with its periodic horizontal
successor; vertical factors compare a vertex with its periodic vertical
successor. -/
def vertexGaugeFactor (gamma : Fin Lx -> Fin Ly -> Bool) : LinkFactor Lx Ly where
  hFactor i j := gamma i j ^^ gamma (finRotate Lx i) j
  vFactor i j := gamma i j ^^ gamma i (finRotate Ly j)

/-- Apply a concrete Z2 vertex-gauge update to a torus link field. -/
def applyVertexGauge (gamma : Fin Lx -> Fin Ly -> Bool)
    (U : TorusLinkField Lx Ly) : TorusLinkField Lx Ly :=
  applyLinkFactor (vertexGaugeFactor gamma) U

/-- Horizontal cycle flux after a link-factor update: it is the original
cycle flux XOR the factor's horizontal cycle parity. -/
theorem xCycleFlux_applyLinkFactor (eta : LinkFactor Lx Ly)
    (U : TorusLinkField Lx Ly) (j : Fin Ly) :
    (applyLinkFactor eta U).xCycleFlux j =
      (xorList (List.ofFn (fun i : Fin Lx => eta.hFactor i j)) ^^ U.xCycleFlux j) := by
  unfold xCycleFlux applyLinkFactor
  rw [xorList_ofFn_xor]

/-- Vertical cycle flux after a link-factor update: it is the original
cycle flux XOR the factor's vertical cycle parity. -/
theorem yCycleFlux_applyLinkFactor (eta : LinkFactor Lx Ly)
    (U : TorusLinkField Lx Ly) (i : Fin Lx) :
    (applyLinkFactor eta U).yCycleFlux i =
      (xorList (List.ofFn (fun j : Fin Ly => eta.vFactor i j)) ^^ U.yCycleFlux i) := by
  unfold yCycleFlux applyLinkFactor
  rw [xorList_ofFn_xor]

/-- A link-factor update whose horizontal factors have zero parity around the
base horizontal cycle preserves the horizontal winding bit. -/
theorem xCycleFlux_applyLinkFactor_of_base_zero (hLy : 0 < Ly)
    (eta : LinkFactor Lx Ly) (U : TorusLinkField Lx Ly)
    (heta : xorList (List.ofFn (fun i : Fin Lx => eta.hFactor i (baseY hLy))) = false) :
    (applyLinkFactor eta U).xCycleFlux (baseY hLy) = U.xCycleFlux (baseY hLy) := by
  rw [xCycleFlux_applyLinkFactor, heta]
  cases U.xCycleFlux (baseY hLy) <;> rfl

/-- A link-factor update whose vertical factors have zero parity around the
base vertical cycle preserves the vertical winding bit. -/
theorem yCycleFlux_applyLinkFactor_of_base_zero (hLx : 0 < Lx)
    (eta : LinkFactor Lx Ly) (U : TorusLinkField Lx Ly)
    (heta : xorList (List.ofFn (fun j : Fin Ly => eta.vFactor (baseX hLx) j)) = false) :
    (applyLinkFactor eta U).yCycleFlux (baseX hLx) = U.yCycleFlux (baseX hLx) := by
  rw [yCycleFlux_applyLinkFactor, heta]
  cases U.yCycleFlux (baseX hLx) <;> rfl

/-- Link-factor updates with zero parity along both base cycles preserve the
concrete Z2 winding label. This is the algebraic cancellation core for later
gauge-coboundary and local-plaquette-preservation statements. -/
theorem windingLabel_applyLinkFactor_of_base_zero (hLx : 0 < Lx) (hLy : 0 < Ly)
    (eta : LinkFactor Lx Ly) (U : TorusLinkField Lx Ly)
    (hetaX : xorList (List.ofFn (fun i : Fin Lx => eta.hFactor i (baseY hLy))) = false)
    (hetaY : xorList (List.ofFn (fun j : Fin Ly => eta.vFactor (baseX hLx) j)) = false) :
    windingLabel hLx hLy (applyLinkFactor eta U) = windingLabel hLx hLy U := by
  exact (FluxLabel.ext_iff _ _).2
    ⟨xCycleFlux_applyLinkFactor_of_base_zero hLy eta U hetaX,
      yCycleFlux_applyLinkFactor_of_base_zero hLx eta U hetaY⟩

/-- A vertex-gauge coboundary has zero horizontal parity around the base
horizontal winding cycle. -/
theorem vertexGaugeFactor_xBase_parity (hLy : 0 < Ly)
    (gamma : Fin Lx -> Fin Ly -> Bool) :
    xorList (List.ofFn
      (fun i : Fin Lx => (vertexGaugeFactor gamma).hFactor i (baseY hLy))) =
        false := by
  unfold vertexGaugeFactor
  rw [xorList_ofFn_xor,
    xorList_ofFn_comp_perm (finRotate Lx)
      (fun i : Fin Lx => gamma i (baseY hLy))]
  cases xorList (List.ofFn fun i : Fin Lx => gamma i (baseY hLy)) <;> rfl

/-- A vertex-gauge coboundary has zero vertical parity around the base
vertical winding cycle. -/
theorem vertexGaugeFactor_yBase_parity (hLx : 0 < Lx)
    (gamma : Fin Lx -> Fin Ly -> Bool) :
    xorList (List.ofFn
      (fun j : Fin Ly => (vertexGaugeFactor gamma).vFactor (baseX hLx) j)) =
        false := by
  unfold vertexGaugeFactor
  rw [xorList_ofFn_xor,
    xorList_ofFn_comp_perm (finRotate Ly)
      (fun j : Fin Ly => gamma (baseX hLx) j)]
  cases xorList (List.ofFn fun j : Fin Ly => gamma (baseX hLx) j) <;> rfl

/-- Concrete Z2 vertex-gauge updates preserve the winding-flux label. -/
theorem windingLabel_applyVertexGauge (hLx : 0 < Lx) (hLy : 0 < Ly)
    (gamma : Fin Lx -> Fin Ly -> Bool) (U : TorusLinkField Lx Ly) :
    windingLabel hLx hLy (applyVertexGauge gamma U) = windingLabel hLx hLy U := by
  exact windingLabel_applyLinkFactor_of_base_zero hLx hLy
    (vertexGaugeFactor gamma) U
    (vertexGaugeFactor_xBase_parity hLy gamma)
    (vertexGaugeFactor_yBase_parity hLx gamma)

/-- Trivial winding is invariant under concrete Z2 vertex-gauge updates. -/
theorem hasTrivialWinding_applyVertexGauge (hLx : 0 < Lx) (hLy : 0 < Ly)
    (gamma : Fin Lx -> Fin Ly -> Bool) (U : TorusLinkField Lx Ly) :
    HasTrivialWinding hLx hLy (applyVertexGauge gamma U) ↔
      HasTrivialWinding hLx hLy U := by
  unfold HasTrivialWinding
  rw [windingLabel_applyVertexGauge hLx hLy gamma U]

/-! ## Sector projections and label-preserving transfer kernels -/

/-- The concrete winding-label sector data for Z2 torus link fields. -/
def windingSectorData (hLx : 0 < Lx) (hLy : 0 < Ly) :
    FluxSectorGeneral.SectorData (TorusLinkField Lx Ly) FluxLabel where
  label := windingLabel hLx hLy

/-- The diagonal projection onto a concrete Z2 winding-flux sector. -/
def windingSectorProjection (hLx : 0 < Lx) (hLy : 0 < Ly)
    (label : FluxLabel) (psi : TorusLinkField Lx Ly -> Complex) :
    TorusLinkField Lx Ly -> Complex :=
  FluxSectorGeneral.SectorData.sectorProjection
    (windingSectorData hLx hLy) label psi

/-- A finite kernel on Z2 torus link fields preserves winding sectors when
it has no matrix entry between fields with different winding labels. -/
def WindingKernelPreservesLabels (hLx : 0 < Lx) (hLy : 0 < Ly)
    (K : TorusLinkField Lx Ly -> TorusLinkField Lx Ly -> Complex) : Prop :=
  FluxSectorGeneral.SectorData.KernelPreservesLabels
    (windingSectorData hLx hLy) K

/-- The finite transfer action of an abstract kernel on Z2 torus
wavefunctions. This is not yet a construction of the Q2 transfer matrix. -/
def applyWindingTransfer
    (K : TorusLinkField Lx Ly -> TorusLinkField Lx Ly -> Complex)
    (psi : TorusLinkField Lx Ly -> Complex) :
    TorusLinkField Lx Ly -> Complex :=
  FluxSectorGeneral.SectorData.applyTransfer K psi

/-! ## Diagonal local-observable support preservation -/

/-- A wavefunction on concrete Z2 torus link fields is supported in a named
winding-flux sector when every configuration with nonzero amplitude has that
label. -/
def SupportedInFlux (hLx : 0 < Lx) (hLy : 0 < Ly) (label : FluxLabel)
    (psi : TorusLinkField Lx Ly -> Complex) : Prop :=
  forall U : TorusLinkField Lx Ly, psi U ≠ 0 -> windingLabel hLx hLy U = label

/-- Support in the D12 trivial winding-flux sector. -/
def SupportedInTrivialWinding (hLx : 0 < Lx) (hLy : 0 < Ly)
    (psi : TorusLinkField Lx Ly -> Complex) : Prop :=
  SupportedInFlux hLx hLy FluxLabel.trivial psi

/-- Multiplication by a diagonal observable on concrete Z2 torus link fields.
Local plaquette-class functions are later instances of this general diagonal
operation. -/
def multiplyObservable (O psi : TorusLinkField Lx Ly -> Complex) :
    TorusLinkField Lx Ly -> Complex :=
  fun U => O U * psi U

/-- Diagonal observable multiplication preserves support in every winding-flux
sector. This is the abstract support-level reason local plaquette
multiplication operators preserve the sector decomposition. -/
theorem supportedInFlux_multiplyObservable (hLx : 0 < Lx) (hLy : 0 < Ly)
    (label : FluxLabel) (O psi : TorusLinkField Lx Ly -> Complex)
    (hpsi : SupportedInFlux hLx hLy label psi) :
    SupportedInFlux hLx hLy label (multiplyObservable O psi) := by
  intro U hU
  apply hpsi U
  intro hzero
  apply hU
  simp [multiplyObservable, hzero]

/-- Diagonal observable multiplication preserves the D12 trivial winding-flux
sector. -/
theorem supportedInTrivialWinding_multiplyObservable
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (O psi : TorusLinkField Lx Ly -> Complex)
    (hpsi : SupportedInTrivialWinding hLx hLy psi) :
    SupportedInTrivialWinding hLx hLy (multiplyObservable O psi) :=
  supportedInFlux_multiplyObservable hLx hLy FluxLabel.trivial O psi hpsi

/-- Projecting onto a winding sector produces a wavefunction supported in
that sector. -/
theorem supportedInFlux_windingSectorProjection
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (label : FluxLabel) (psi : TorusLinkField Lx Ly -> Complex) :
    SupportedInFlux hLx hLy label
      (windingSectorProjection hLx hLy label psi) :=
  FluxSectorGeneral.SectorData.supportedInSector_sectorProjection
    (windingSectorData hLx hLy) label psi

/-- If a wavefunction is already supported in a winding sector, projecting
onto that sector leaves it unchanged. -/
theorem windingSectorProjection_eq_self_of_supportedInFlux
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (label : FluxLabel) (psi : TorusLinkField Lx Ly -> Complex)
    (hpsi : SupportedInFlux hLx hLy label psi) :
    windingSectorProjection hLx hLy label psi = psi :=
  FluxSectorGeneral.SectorData.sectorProjection_eq_self_of_supported
    (windingSectorData hLx hLy) label psi hpsi

/-- A winding-label-preserving finite kernel maps sector-supported
wavefunctions back into the same concrete Z2 winding sector. -/
theorem supportedInFlux_applyWindingTransfer
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (K : TorusLinkField Lx Ly -> TorusLinkField Lx Ly -> Complex)
    (label : FluxLabel) (psi : TorusLinkField Lx Ly -> Complex)
    (hK : WindingKernelPreservesLabels hLx hLy K)
    (hpsi : SupportedInFlux hLx hLy label psi) :
    SupportedInFlux hLx hLy label (applyWindingTransfer K psi) :=
  FluxSectorGeneral.SectorData.supportedInSector_applyTransfer
    (windingSectorData hLx hLy) K label psi hK hpsi

/-- A winding-label-preserving finite kernel commutes with the diagonal
projection onto each concrete Z2 winding sector. -/
theorem windingSectorProjection_applyWindingTransfer_commute
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (K : TorusLinkField Lx Ly -> TorusLinkField Lx Ly -> Complex)
    (label : FluxLabel) (psi : TorusLinkField Lx Ly -> Complex)
    (hK : WindingKernelPreservesLabels hLx hLy K) :
    windingSectorProjection hLx hLy label (applyWindingTransfer K psi) =
      applyWindingTransfer K (windingSectorProjection hLx hLy label psi) :=
  FluxSectorGeneral.SectorData.sectorProjection_applyTransfer_commute
    (windingSectorData hLx hLy) K label psi hK

/-- A winding-label-preserving finite kernel preserves support in the D12
trivial winding-flux sector. -/
theorem supportedInTrivialWinding_applyWindingTransfer
    (hLx : 0 < Lx) (hLy : 0 < Ly)
    (K : TorusLinkField Lx Ly -> TorusLinkField Lx Ly -> Complex)
    (psi : TorusLinkField Lx Ly -> Complex)
    (hK : WindingKernelPreservesLabels hLx hLy K)
    (hpsi : SupportedInTrivialWinding hLx hLy psi) :
    SupportedInTrivialWinding hLx hLy (applyWindingTransfer K psi) :=
  supportedInFlux_applyWindingTransfer hLx hLy K FluxLabel.trivial psi hK hpsi

end TorusLinkField

/-- A state map preserves the Z2 winding-flux label. Later Q3 files will
instantiate this for the transfer kernel/projection and for local plaquette
operators. -/
def PreservesFluxLabel {State : Type*} (Q : QuantumNumbers State)
    (F : State -> State) : Prop :=
  forall psi : State, Q.fluxLabel (F psi) = Q.fluxLabel psi

/-- A state map preserves all three D12 quantum-number predicates. This is
kept separate from `PreservesFluxLabel` so later theorems can prove only the
flux part for local plaquette operators when Gauss/momentum preservation is
handled elsewhere. -/
def PreservesQuantumNumbers {State : Type*} (Q : QuantumNumbers State)
    (F : State -> State) : Prop :=
  (forall psi : State, Q.gaussInvariant psi -> Q.gaussInvariant (F psi)) ∧
    (forall psi : State, Q.zeroMomentum psi -> Q.zeroMomentum (F psi)) ∧
    PreservesFluxLabel Q F

theorem preserves_trivialFlux_of_preservesFluxLabel {State : Type*}
    (Q : QuantumNumbers State) (F : State -> State)
    (hF : PreservesFluxLabel Q F) {psi : State}
    (hpsi : Q.trivialFlux psi) :
    Q.trivialFlux (F psi) := by
  unfold QuantumNumbers.trivialFlux at hpsi ⊢
  rw [hF psi]
  exact hpsi

theorem preserves_vacuum_of_preservesQuantumNumbers {State : Type*}
    (Q : QuantumNumbers State) (F : State -> State)
    (hF : PreservesQuantumNumbers Q F) {psi : State}
    (hpsi : (Q.symmetrySector).vacuum psi) :
    (Q.symmetrySector).vacuum (F psi) := by
  exact ⟨hF.1 psi hpsi.1, hF.2.1 psi hpsi.2.1,
    preserves_trivialFlux_of_preservesFluxLabel Q F hF.2.2 hpsi.2.2⟩

/-- Global winding-flux gap. This name is reserved for the energy separation
between the trivial sector and nontrivial winding-flux sectors. It is not the
D12 local/glueball mass gap. -/
def fluxGap (lambda0 lambdaFlux : Real) : Real :=
  TransferGapDefinition.finiteMassGap lambda0 lambdaFlux

/-- Local/glueball gap inside the trivial-flux sector. This is the quantity
named by `TransferGapDefinition.finiteMassGap` in the D12 convention. -/
def localGlueballGap (lambda0 lambdaLocal : Real) : Real :=
  TransferGapDefinition.finiteMassGap lambda0 lambdaLocal

theorem fluxGap_eq_finiteMassGap (lambda0 lambdaFlux : Real) :
    fluxGap lambda0 lambdaFlux =
      TransferGapDefinition.finiteMassGap lambda0 lambdaFlux := rfl

theorem localGlueballGap_eq_finiteMassGap (lambda0 lambdaLocal : Real) :
    localGlueballGap lambda0 lambdaLocal =
      TransferGapDefinition.finiteMassGap lambda0 lambdaLocal := rfl

theorem fluxGap_nonneg {lambda0 lambdaFlux : Real}
    (h0 : 0 < lambda0) (h1 : 0 < lambdaFlux) (hle : lambdaFlux <= lambda0) :
    0 <= fluxGap lambda0 lambdaFlux :=
  TransferGapDefinition.finiteMassGap_nonneg h0 h1 hle

theorem localGlueballGap_nonneg {lambda0 lambdaLocal : Real}
    (h0 : 0 < lambda0) (h1 : 0 < lambdaLocal) (hle : lambdaLocal <= lambda0) :
    0 <= localGlueballGap lambda0 lambdaLocal :=
  TransferGapDefinition.finiteMassGap_nonneg h0 h1 hle

theorem localGlueballGap_pos {lambda0 lambdaLocal : Real}
    (h0 : 0 < lambda0) (h1 : 0 < lambdaLocal) (hlt : lambdaLocal < lambda0) :
    0 < localGlueballGap lambda0 lambdaLocal :=
  TransferGapDefinition.finiteMassGap_pos h0 h1 hlt

end FluxSectorZ2
end GateYM
end NullEdge
end Draft
end PhysicsSM
