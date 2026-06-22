# Aristotle prompt: P9 post-suppression strategy/audit

This is a strategy/audit job, not a proof-filling job.

Please do **not** try to compile the whole `PhysicsSM` repo. You may inspect the
included Lean files and notes, but the requested output is a research/proof
roadmap, not new code.

## Context

The P9 cosmological-constant/source-visibility branch now has these finite
draft theorem atoms:

```text
PhysicsSM/Draft/NullEdgeP9BoundarySource.lean
PhysicsSM/Draft/NullEdgeP9BFClosure.lean
PhysicsSM/Draft/NullEdgeP9DiamondVisibility.lean
PhysicsSM/Draft/NullEdgeP9MeanZeroFluctuation.lean
PhysicsSM/Draft/NullEdgeP9VisibleClosureSource.lean
PhysicsSM/Draft/NullEdgeP9DiamondSourceVisibilityCore.lean
PhysicsSM/Draft/NullEdgeP9FluctuationScaling.lean
PhysicsSM/Draft/NullEdgeP9WeightedFluctuation.lean
PhysicsSM/Draft/NullEdgeP9UniformSuppression.lean
```

The most important new results are:

```text
closed_visibleFan_mass_eq_restEnergy
closed_visibleFan_massSource_pairing_eq_restEnergy
ensembleSecondMoment_eq_card_times_configs
weightedEnsembleSecondMoment_eq_amplitudeSqSum_times_configs
normalizedWeightedSecondMoment_eq_amplitudeSqSum
normalizedUniformSecondMoment_eq_totalSq_div_card
```

The publication plan section P9 has also been updated:

```text
Sources/Null_Edge_Causal_Graph_Publication_Plan.md
```

## Assignment

Evaluate the post-suppression P9 branch as a potential publishable research
line. Be candid and strategic.

1. Does the current theorem spine now provide a genuinely useful finite handle
   on the cosmological-constant/source-visibility problem, or is it still mostly
   simple algebra without physics leverage?
2. What is the smallest next definition layer needed to connect the finite
   suppression theorem to diamond geometry? For example: diamond cells, screen
   weights, observer algebra, BF closure, boundary source, curvature pairing.
3. Rank the next 5-8 Aristotle proof jobs by publication value. Prefer targets
   that force a constraint, no-go, scaling law, or falsifiable pilot.
4. Identify which tempting jobs should be avoided as filler.
5. Give a concrete pass/fail threshold for whether P9 deserves promotion from
   aspirational target to a real synthesis paper.

Please end with this exact summary shape:

```text
overall assessment:
current theorem value:
minimal next definitions:
ranked next proof jobs:
jobs to avoid:
pass/fail threshold:
integration notes:
```
