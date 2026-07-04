import Mathlib

/-!
# Gate YM0/T3: D12 finite transfer-gap definition skeleton

This draft module records the finite-volume D12 gap convention from the freeze
document:

* the transfer spectral ratio must be taken in the **vacuum symmetry sector**;
* for this run, that means Gauss-invariant, zero-spatial-momentum, and
  trivial 't Hooft flux;
* omitting the flux qualifier is a known convention error for small tori.

This file is intentionally definition-first. It does **not** construct the C-8
transfer matrix, the Gauss projector, momentum projectors, flux projectors, or
any concrete spectrum. It only gives a typed place for those later
constructions to land, plus the elementary real-valued gap formula
`-log(lambda1 / lambda0)` once the leading two eigenvalues in the selected
sector have been identified.

Provenance: freeze document
`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md`, section 1,
definition D12. The 't Hooft flux-sector literature attribution is tracked in
`AgentTasks/overnight-ym-run-2026-07-03/LIT_LOG.md`; this module does not claim
that source has been semantically imported.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity / definition** (flux-qualified gap convention).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace TransferGapDefinition

/-- Predicates selecting the finite-volume symmetry sector in which the D12
mass gap is to be measured. The three fields are deliberately separate:
Gauss invariance, spatial momentum, and 't Hooft flux are different quantum
numbers and should not be conflated. -/
structure SymmetrySector (State : Type*) where
  gaussInvariant : State → Prop
  zeroMomentum : State → Prop
  trivialFlux : State → Prop

namespace SymmetrySector

variable {State : Type*}

/-- The D12 vacuum sector: Gauss-invariant, zero-momentum, and trivial-flux
states. The trivial-flux clause is load-bearing; dropping it gives the wrong
finite-lattice gap target in the freeze's small-torus oracle finding. -/
def vacuum (S : SymmetrySector State) (ψ : State) : Prop :=
  S.gaussInvariant ψ ∧ S.zeroMomentum ψ ∧ S.trivialFlux ψ

theorem vacuum_gaussInvariant (S : SymmetrySector State) {ψ : State}
    (hψ : S.vacuum ψ) :
    S.gaussInvariant ψ :=
  hψ.1

theorem vacuum_zeroMomentum (S : SymmetrySector State) {ψ : State}
    (hψ : S.vacuum ψ) :
    S.zeroMomentum ψ :=
  hψ.2.1

theorem vacuum_trivialFlux (S : SymmetrySector State) {ψ : State}
    (hψ : S.vacuum ψ) :
    S.trivialFlux ψ :=
  hψ.2.2

end SymmetrySector

/-- Real-valued finite spectral-ratio gap convention:
`Delta = -log(lambda1 / lambda0)`, where `lambda0` is the leading
eigenvalue and `lambda1` is the first excited eigenvalue in the selected
sector.

This total real-valued definition is meant to be used with explicit hypotheses
`0 < lambda1 <= lambda0`. If `lambda1 = 0`, the physically natural gap would be
infinite, which is outside this finite real skeleton. -/
def finiteMassGap (lambda0 lambda1 : ℝ) : ℝ :=
  -Real.log (lambda1 / lambda0)

/-- If the first excited eigenvalue is positive and no larger than the leading
eigenvalue, the finite real gap is nonnegative. -/
theorem finiteMassGap_nonneg {lambda0 lambda1 : ℝ}
    (h0 : 0 < lambda0) (h1 : 0 < lambda1) (hle : lambda1 ≤ lambda0) :
    0 ≤ finiteMassGap lambda0 lambda1 := by
  unfold finiteMassGap
  have hratio_nonneg : 0 ≤ lambda1 / lambda0 := div_nonneg h1.le h0.le
  have hratio_le_one : lambda1 / lambda0 ≤ 1 := by
    rw [div_le_one h0]
    exact hle
  have hlog : Real.log (lambda1 / lambda0) ≤ 0 :=
    Real.log_nonpos hratio_nonneg hratio_le_one
  linarith

/-- If the first excited eigenvalue is strictly below the leading eigenvalue,
the finite real gap is strictly positive. -/
theorem finiteMassGap_pos {lambda0 lambda1 : ℝ}
    (h0 : 0 < lambda0) (h1 : 0 < lambda1) (hlt : lambda1 < lambda0) :
    0 < finiteMassGap lambda0 lambda1 := by
  unfold finiteMassGap
  have hratio_pos : 0 < lambda1 / lambda0 := div_pos h1 h0
  have hratio_lt_one : lambda1 / lambda0 < 1 := by
    rw [div_lt_one h0]
    exact hlt
  have hlog : Real.log (lambda1 / lambda0) < 0 :=
    (Real.log_neg_iff hratio_pos).2 hratio_lt_one
  linarith

end TransferGapDefinition
end GateYM
end NullEdge
end Draft
end PhysicsSM
