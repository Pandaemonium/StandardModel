import Mathlib
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
  plaquette-algebra statements.

It does not construct the transfer matrix, prove a spectral theorem, or claim
that the local gap is positive. The concrete winding-cycle holonomy
realization starts here at the Bool-array level; the transfer-kernel
preservation theorem is a successor task.

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

/-- A concrete Z2 link field on an `Lx` by `Ly` periodic torus, represented
by horizontal and vertical link bits. `hLink i j` is the link from
`(i,j)` to `(i+1,j)` and `vLink i j` is the link from `(i,j)` to
`(i,j+1)`, with periodic wrap understood by the torus convention. -/
structure TorusLinkField (Lx Ly : Nat) where
  hLink : Fin Lx -> Fin Ly -> Bool
  vLink : Fin Lx -> Fin Ly -> Bool

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
