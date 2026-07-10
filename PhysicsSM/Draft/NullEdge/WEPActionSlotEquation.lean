import Mathlib
import PhysicsSM.Draft.NullEdge.WEPTrace
import PhysicsSM.Draft.NullEdge.WEPActionBridge
import PhysicsSM.Draft.NullEdge.WEPActionResourceBridge

/-!
# Goal IV: WEP slot-resolved source recovery

This draft module records the honest Goal IV bridge flagged by the 7am audit:
**slot-resolved source recovery**. The lesson is ordering — stationarity of the
sourced finite action recovers the *full matrix* source `K` first, and the
channel-blind trace identity is only a *shadow* (a corollary) of that full
matrix equation.

## What is proved here, and only this

* `stationary_full_matrix_source` / `full_matrix_source_iff_stationary`:
  stationarity of the sourced action against every variation recovers the full
  finite operator source `G = K`. This is `WEPActionBridge`'s field equation
  re-exported in slot-resolved form: the matrix equation is primary.

* `channelBlind_trace_shadow_of_full_source`: *given* the full matrix equation
  `G = K` and a channel-blind coupling, the scalar trace form `Tr(G rho)`
  collapses to `kappa * Tr rho`. The trace result is derived from the matrix
  equation, not proved independently.

* `slot_resolved_source_recovery`: the bundled statement — stationarity yields
  the full matrix source and, when the coupling is channel-blind, the trace
  shadow.

## Claim discipline

This module claims only the finite trace-level multiplier-action bridge already
established in `WEPActionBridge`, re-packaged to make the slot ordering explicit
(full matrix source first, trace as shadow). It does **not** claim the E-slot /
Einstein field equation, stationarity of the geometric soldering action, or any
Clausius/Jacobson entropy-to-Einstein result. The missing API to promote the
trace-level bridge to an operator-level E-slot variation is exactly that
recorded in the `NextTargets` block of `WEPActionBridge`.
-/

namespace WEPActionSlotEquation

open Matrix
open PhysicsSM.Draft.NullEdge

variable {n : ℕ}

/-- **Slot-resolved source recovery (full matrix).** Stationarity of the sourced
action against every variation recovers the full finite operator source
`G = K`. This is the primary slot-resolved result: the matrix equation, not the
trace. -/
theorem stationary_full_matrix_source
    {n : ℕ} {G K : Matrix (Fin n) (Fin n) ℂ}
    (hstat : WEPActionBridge.Stationary G K) :
    G = K :=
  (WEPActionBridge.stationary_iff_fieldEquation G K).mp hstat

/-- **Slot-resolved source recovery, iff form.** Stationarity of the sourced
action is equivalent to the full finite operator field equation `G = K`. -/
theorem full_matrix_source_iff_stationary
    {n : ℕ} {G K : Matrix (Fin n) (Fin n) ℂ} :
    WEPActionBridge.Stationary G K ↔ G = K :=
  WEPActionBridge.stationary_iff_fieldEquation G K

/-- **Channel-blind trace shadow of the full matrix source.** Given the full
matrix equation `G = K` and a channel-blind coupling `K = kappa • 1`, the scalar
trace form `Tr(G rho)` collapses to `kappa * Tr rho` for every budget `rho`. The
trace identity is a *shadow* (corollary) of the full matrix equation, not an
independent result. -/
theorem channelBlind_trace_shadow_of_full_source
    {n : ℕ} {G K : Matrix (Fin n) (Fin n) ℂ} {kappa : ℂ}
    (hK : WEPTrace.ChannelBlind K kappa)
    (hfull : G = K) :
    ∀ rho : Matrix (Fin n) (Fin n) ℂ,
      WEPActionBridge.traceForm G rho = kappa * rho.trace := by
  intro rho
  rw [WEPActionBridge.traceForm, hfull]
  exact WEPTrace.wep_trace_identity hK

/-- **Bundled slot-resolved source recovery.** Stationarity of the sourced
action recovers the full matrix source `G = K`, and — when the coupling is
channel-blind — the scalar trace form collapses to the total-budget shadow
`kappa * Tr rho`. The full matrix equation is primary; the trace result is its
shadow. -/
theorem slot_resolved_source_recovery
    {n : ℕ} {G K : Matrix (Fin n) (Fin n) ℂ} {kappa : ℂ}
    (hK : WEPTrace.ChannelBlind K kappa)
    (hstat : WEPActionBridge.Stationary G K) :
    G = K ∧
      ∀ rho : Matrix (Fin n) (Fin n) ℂ,
        WEPActionBridge.traceForm G rho = kappa * rho.trace := by
  have hfull : G = K := stationary_full_matrix_source hstat
  exact ⟨hfull, channelBlind_trace_shadow_of_full_source hK hfull⟩

end WEPActionSlotEquation

/-! ## Kernel-footprint guard pins -/

/-- info: 'WEPActionSlotEquation.stationary_full_matrix_source' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms WEPActionSlotEquation.stationary_full_matrix_source

/-- info: 'WEPActionSlotEquation.full_matrix_source_iff_stationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms WEPActionSlotEquation.full_matrix_source_iff_stationary

/-- info: 'WEPActionSlotEquation.channelBlind_trace_shadow_of_full_source' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms WEPActionSlotEquation.channelBlind_trace_shadow_of_full_source

/-- info: 'WEPActionSlotEquation.slot_resolved_source_recovery' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms WEPActionSlotEquation.slot_resolved_source_recovery
