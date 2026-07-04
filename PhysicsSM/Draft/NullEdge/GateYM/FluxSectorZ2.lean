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
realization and transfer-kernel preservation theorem are successor tasks.

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
