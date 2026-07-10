# codex-audit-suitecd-harvest-20260709

You are Aristotle auditing a Lean formalization harvest for the NullEdge /
all-mass program.

## Context

Codex ported these draft Lean modules after Aristotle returns:

- `PhysicsSM/Draft/NullEdge/KMPhaseCounting.lean`
- `PhysicsSM/Draft/NullEdge/FiniteKMCP.lean`
- `PhysicsSM/Draft/NullEdge/IncidenceCorank.lean`
- `PhysicsSM/Draft/NullEdge/WEPTrace.lean`
- `PhysicsSM/Draft/NullEdge/WEPActionBridge.lean`
- `PhysicsSM/Draft/NullEdge/MassResourceModularAudit.lean`
- `PhysicsSM/Draft/NullEdge/IndexAnomalyInterface.lean`
- `PhysicsSM/Draft/NullEdge/GateI1/MassEntropyMonotone.lean`
- `PhysicsSM/Draft/NullEdge/SuiteCDNextRungs.lean`

Codex locally verified:

```text
lake build PhysicsSM.Draft.NullEdge.MassResourceModularAudit
  PhysicsSM.Draft.NullEdge.IncidenceCorank
  PhysicsSM.Draft.NullEdge.WEPActionBridge
  PhysicsSM.Draft.NullEdge.IndexAnomalyInterface
  PhysicsSM.Draft.NullEdge.GateI1.MassEntropyMonotone
  PhysicsSM.Draft.NullEdge.SuiteCDNextRungs
  PhysicsSM.Draft.NullEdge.FiniteKMCP
```

## Audit task

Review the provided Lean files for semantic alignment, not just compilation.
Use the four over-claim modes:

1. vacuity,
2. hollow telescoping,
3. docstring outruns kernel,
4. false shape.

Also check the run's nondegeneracy rule: every existential or physical witness
should include a nonzero/noncollapsed fixture, and degenerate modes should be
named when relevant.

## Specific questions

- Does `IncidenceCorank.coboundary_corank` genuinely close the general-N
  linearized CP phase-count rung, or does the prose overstate it as a full
  unitary normal form?
- Does `WEPActionBridge.stationary_iff_fieldEquation` honestly remain a
  trace-level multiplier-action bridge, or does any statement/prose imply the
  full E-slot field equation?
- Does `IndexAnomalyInterface` keep the analytic-index claim properly isolated
  as a reduction hypothesis?
- Does `MassEntropyMonotone.massEntropyMonotone` rely on hidden frame,
  future-cone, or entropy-domain assumptions not stated in the theorem surface?
- Does `SuiteCDNextRungs.channel_charges_independent` provide a genuine
  noncollapsed GGE torus gate, or is it only a basis-coordinate tautology whose
  prose should be narrowed?
- Did the audit patches to `FiniteKMCP.physicalPhases_eq` and
  `MassResourceModularAudit.modular_shift_operator_ne` introduce any mismatch?

## Required output

Return:

- PASS/FAIL per module.
- Any exact declaration names that should be renamed, weakened, or documented
  more narrowly.
- Any missing theorem statement or nondegeneracy fixture needed before the
  manuscript may cite the result.
- A short recommended ledger entry.
