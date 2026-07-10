# codex-wep-action-slot-equation-0700-20260709

aristotle:
  project_id: 9ceb0ade-028d-4a7c-a52d-a244c2c150a4
  target_file: PhysicsSM/Draft/NullEdge/WEPActionSlotEquation.lean
  expected_module: PhysicsSM.Draft.NullEdge.WEPActionSlotEquation
  submission_project: AgentTasks/aristotle-submit/codex-next-round-0700-20260709-project
  output_dir: AgentTasks/aristotle-output/9ceb0ade-028d-4a7c-a52d-a244c2c150a4
  status: harvested and ported 2026-07-09 ~07:35

You are Aristotle, proving a small Goal IV bridge theorem in Lean.

Target file to create:

```text
PhysicsSM/Draft/NullEdge/WEPActionSlotEquation.lean
```

Use imports:

```lean
import Mathlib
import PhysicsSM.Draft.NullEdge.WEPTrace
import PhysicsSM.Draft.NullEdge.WEPActionBridge
import PhysicsSM.Draft.NullEdge.WEPActionResourceBridge
```

Context:
- `WEPActionBridge.stationary_iff_fieldEquation` proves that stationarity of the
  trace-level sourced action is equivalent to matrix equality `G = K`.
- `WEPActionBridge.stationary_channelBlind_source` gives the scalar trace shadow
  under a channel-blind coupling: `traceForm G rho = kappa * rho.trace`.
- The 7am audit says the missing honest Goal IV bridge is slot-resolved source
  recovery: prove the full matrix equation first, then trace is only a corollary.

Task:
Create `WEPActionSlotEquation.lean` with a theorem package that says, in the
existing API, stationarity recovers the full matrix source `K`, and in the
channel-blind case the trace result is merely the shadow.

Required theorem shapes, adapted if names in the current API require it:

```lean
namespace WEPActionSlotEquation

open Matrix
open PhysicsSM.Draft.NullEdge

theorem stationary_full_matrix_source
    {n : Nat} {G K : Matrix (Fin n) (Fin n) Complex}
    (hstat : WEPActionBridge.Stationary G K) :
    G = K := ...

theorem full_matrix_source_iff_stationary
    {n : Nat} {G K : Matrix (Fin n) (Fin n) Complex} :
    WEPActionBridge.Stationary G K <-> G = K := ...

theorem channelBlind_trace_shadow_of_full_source
    {n : Nat} {G K : Matrix (Fin n) (Fin n) Complex} {kappa : Complex}
    (hK : WEPTrace.ChannelBlind K kappa)
    (hfull : G = K) :
    forall rho : Matrix (Fin n) (Fin n) Complex,
      WEPActionBridge.traceForm G rho = kappa * rho.trace := ...

end WEPActionSlotEquation
```

If possible, add a single bundled theorem with both the full matrix equation and
the trace shadow. Do not claim an Einstein/E-slot/Clausius-Jacobson equation.

Add build-enforced `#guard_msgs ... #print axioms` pins for headline theorems.
Run first:

```text
lake env lean PhysicsSM/Draft/NullEdge/WEPActionSlotEquation.lean
```

Return a short summary of solved targets, any statement changes, and the
a x i o m
footprints.
