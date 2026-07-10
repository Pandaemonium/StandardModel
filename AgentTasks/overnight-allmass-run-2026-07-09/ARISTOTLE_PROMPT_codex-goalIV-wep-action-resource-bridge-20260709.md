# codex-goalIV-wep-action-resource-bridge-20260709

You are Aristotle working in the `PhysicsSM` Lean project.

## Goal

Create and prove a new module:

```text
PhysicsSM/Draft/NullEdge/WEPActionResourceBridge.lean
```

Compose the Goal IV WEP trace/action pieces with the mass-entropy resource
monotone:

- `PhysicsSM.Draft.NullEdge.WEPTrace`
- `PhysicsSM.Draft.NullEdge.WEPActionBridge`
- `PhysicsSM.Draft.NullEdge.GateI1.MassEntropyDictionary`
- `PhysicsSM.Draft.NullEdge.GateI1.MassEntropyMonotone`

Run the narrow check first:

```text
lake env lean PhysicsSM/Draft/NullEdge/WEPActionResourceBridge.lean
```

## Intended theorem pieces

Prove a small finite bridge that is useful for Goal IV but does not duplicate
Claude's `Goal4FieldEquation` job.

Suggested targets:

1. A theorem packaging WEP stationarity with the total-budget source:

```lean
theorem stationary_channelBlind_total_budget
    {n : Nat} {G K : Matrix (Fin n) (Fin n) Complex} {kappa : Complex}
    (hK : WEPTrace.ChannelBlind K kappa)
    (hstat : WEPActionBridge.Stationary G K) :
    forall rho : Matrix (Fin n) (Fin n) Complex,
      WEPActionBridge.traceForm G rho = kappa * rho.trace
```

2. A theorem combining the nonzero WEP source witness with resource
nonvacuity if the existing API makes this cheap. For example, prove a bundled
statement that there exists a future-cone momentum whose mass-entropy resource
value is zero, and one whose value is positive, using existing dictionary
lemmas; or return the exact missing fixture if no such witness is easy.

3. A theorem saying the mass-entropy resource monotone is faithful on free
states, unfolded from `massEntropyMonotone`:

```lean
theorem massEntropyMonotone_free_iff
    (P : GateI1.MassEntropyMonotone.FutureConeMomentum) :
    GateI1.MassEntropyMonotone.massEntropyMonotone.free P <->
      GateI1.MassEntropyMonotone.massEntropyMonotone.value P = 0
```

Use the exact namespace/API from the repo.

## Claim discipline

This is a finite source/resource bridge. Do not claim Clausius/Jacobson or the
full E-slot field equation. Name any missing hypotheses needed for that next
step, especially Frobenius inner-product or quadratic-action API gaps.

Add guard pins for headline theorem(s). Do not introduce new global assumptions.
