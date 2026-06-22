# Aristotle prompt: null-edge grand strategy v3

You are working inside a curated context package from the `PhysicsSM`
null-edge causal graph research program. This is a strategy/scaffold job, not a
full proof-completion job.

## Goal

Read the current complete program context and produce the next best autonomous
proof-and-manuscript roadmap after the overnight P9 and relative-entropy
progress. We want an ambitious but disciplined plan for the next theorem jobs.

The important new state is:

- P9 source visibility now has a finite API report and a checked standalone
  proof scaffold.
- The source-visibility scaffold proves the separation between visible closure
  and BF/source closure, and proves the squared-source additivity condition.
- The relative-entropy observer-channel job produced a checked standalone
  classical finite KL/data-processing scaffold.
- A P1 Pluecker mass manuscript skeleton has been started.

## Read first

Use these files in the package as primary context:

- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `Sources/Null_Edge_Causal_Graph_Research_Plan.md`
- `Sources/Null_Edge_Causal_Graph_Bibliography.md`
- `Sources/Null_Edge_P1_Plucker_Mass_Manuscript_Skeleton.md`
- `AgentTasks/null-edge-autonomous-aristotle-loop-plan-2026-06-21.md`
- `AgentTasks/null-edge-overnight-run-plan-2026-06-21.md`
- `AgentTasks/null-edge-p9-source-visibility-api-output.md`
- `AgentTasks/null-edge-relative-entropy-observer-channel-output.md`
- `AgentTasks/null-edge-grand-strategy-v2-output.md`
- `LeanContext/P9/NullEdgeDiamondSourceVisibilityRoadmap.lean`
- `LeanContext/RelativeEntropy/NullEdgeRelativeEntropyObserverRoadmap.lean`
- `LeanContext/SpinorNetworkClosure/Finite.lean`
- `LeanContext/CelestialScalarChannel/Finite.lean`

## Desired deliverable

Create a written roadmap at:

```text
AgentTasks/null-edge-grand-strategy-v3-output.md
```

Please include:

1. the 10 highest-value next theorem targets, ranked by scientific leverage;
2. which targets are proof-ready now versus definition-risky;
3. which targets should be standalone focused Aristotle packages versus full
   repo packages;
4. which standalone artifacts should be promoted into trusted `PhysicsSM`
   modules first, and in what order;
5. a six-cycle autonomous run plan: one job per cycle, with expected outputs;
6. manuscript work that should accompany those theorem jobs, especially for P1,
   P3, P7, and P9;
7. a list of tempting claims that should still be avoided;
8. a short audit of whether P9 is now stronger, weaker, or just cleaner after
   the source-visibility and relative-entropy scaffolds.

Optionally create clearly labelled non-imported scaffold notes if useful, but
do not claim kernel proof unless you actually verify it. Do not build the whole
repository. Do not edit permanent Lean modules unless the edits are comments
only and clearly justified.

## Output style

Be concrete and selective. We need the plan that lets the next agent run
Aristotle efficiently without flooding the queue or mistaking strategy output
for trusted code.
