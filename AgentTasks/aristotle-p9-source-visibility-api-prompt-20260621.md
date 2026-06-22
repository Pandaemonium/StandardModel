# Aristotle prompt: P9 source-visibility API design

You are working inside a curated context package from the `PhysicsSM` null-edge
research program. This is a strategy/design job, not a proof-completion job.

## Goal

Design the smallest finite Lean-facing API that can make the P9
source-visibility branch precise. The target is not a continuum cosmological
constant theorem. The target is a finite diamond/source interface that cleanly
distinguishes:

1. visible spinor closure or rest-frame closure;
2. BF/surface closure or Gauss-law closure;
3. observer-channel invisibility or recoverability.

The main danger is conflating these. In particular, the recently proved
spinor-network identity says that the visible Pluecker mass can be written as

```text
pairwise angular mass = (E^2 - |C|^2) / 4
```

so `C = 0` is a rest-frame visible-closure condition, not a theorem that the
configuration sources nothing.

## Read first

Use these files in the package as primary context:

- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `Sources/Null_Edge_Causal_Graph_Research_Plan.md`
- `Sources/Null_Edge_Causal_Graph_Bibliography.md`
- `AgentTasks/null-edge-overnight-run-plan-2026-06-21.md`
- `AgentTasks/null-edge-autonomous-aristotle-loop-plan-2026-06-21.md`
- `AgentTasks/null-edge-grand-strategy-v2-output.md`
- `AgentTasks/null-edge-physics-audit-report-aristotle-20260622.md`
- `LeanContext/SpinorNetworkClosure/Finite.lean`
- `LeanContext/Gauge/CausalDiamondHolonomy.lean`

## Desired deliverables

Please create a written design note at:

```text
AgentTasks/null-edge-p9-source-visibility-api-output.md
```

The design note should include:

- a minimal list of finite structures and maps;
- exact intended meanings for "visible closure", "BF closure",
  "boundary-exact", "bulk source", "observer invisible", and "recoverable";
- theorem statements that are mathematically plausible and do not silently
  assume continuum physics;
- a dependency graph from current Lean anchors to future theorem targets;
- at least one toy finite model or counterexample separating visible closure
  from source invisibility;
- physics confidence scores from 1 to 10 for the core definitions;
- failure modes that would demote the P9 branch.

Optionally create a clearly labelled non-imported scaffold file at:

```text
PhysicsSM/Draft/NullEdgeDiamondSourceVisibilityRoadmap.lean
```

If you create Lean-looking declarations, they may be proof skeletons or contain
spaced handoff markers, but do not pretend they compile unless you actually
checked them. This job does not require a full repository build.

## Candidate finite objects

You may rename these if you find better names, but explain the change.

```lean
Diamond
Screen
VisibleFanOnScreen
BFBoundaryData
DiamondSourceFunctional
BoundaryExact
BulkSource
ObserverChannel
```

## Candidate theorem targets

Please refine, split, or reject these:

```lean
boundaryExact_source_eq_zero
bfClosure_implies_no_bulkDivergence
visibleBulkSource_additive_under_diamondGluing
closed_visibleFan_mass_eq_restEnergy
visibleClosure_not_sourceInvisibility_counterexample
```

If a statement is false or too weak, say so plainly and propose the corrected
finite target.

## Physics boundary

Treat Sorkin/everpresent-Lambda, Benincasa-Dowker curvature,
Jacobson/Clausius balance, ANEC/QNEC, and Sorkin-Johnston entropy as
motivation and source constraints only. Do not claim the finite API proves any
of those continuum results. The finite result we need first is a clean
observer/source algebra.

## Output style

Be decisive. Prefer a small coherent API to a broad vocabulary map. The best
answer would tell us exactly which definitions to implement next, which
theorems to send back to Aristotle as proof jobs, and which tempting statements
should be avoided.
