# Aristotle prompt: null-edge grand strategy v2

This is a strategy/scaffold job, not a proof-completion job.

Read the complete research goal in:

```text
Sources/Null_Edge_Causal_Graph_Strengthened_Program.md
```

Also read:

```text
Sources/Null_Edge_Causal_Graph_Research_Plan.md
AgentTasks/null-edge-autonomous-aristotle-loop-plan-2026-06-21.md
AgentTasks/null-edge-strategy-roadmap-aristotle-2026-06-21.md
AgentTasks/aristotle-strategy-roadmap-prompt-20260621.md
```

Treat `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` as the full
target program. Your job is not to prove it all. Your job is to scaffold the
next serious Lean development.

Please do not build the whole repository. You may inspect the Lean files in the
package, especially the trusted anchors:

```text
PhysicsSM/Spinor/PluckerMass.lean
PhysicsSM/Gauge/CausalDiamondHolonomy.lean
PhysicsSM/Draft/NullEdgeDiracSlashCore.lean
PhysicsSM/Draft/NullEdgeBundleDiracPluckerCore.lean
PhysicsSM/Draft/NullEdgeSuperDiracBlockCore.lean
PhysicsSM/Draft/NullEdgeSuperconnectionExpansionCore.lean
PhysicsSM/Draft/NullEdgeQubitConcurrence.lean
PhysicsSM/Draft/NullEdgePathPairInterchange.lean
```

Deliverables:

1. A ranked theorem roadmap for the next 10-20 Aristotle proof jobs.
2. For each proposed theorem cluster:
   - target module name;
   - exact or near-exact Lean declaration sketches;
   - required definitions;
   - known dependencies in this repo;
   - likely mathlib dependencies;
   - proof strategy;
   - semantic risk and physics-convention risk;
   - whether it should be a focused standalone job or a full-repo job.
3. A dependency graph showing what should be proved before what.
4. A "do not submit yet" list of attractive but underspecified targets.
5. A short assessment of whether the current program has enough formal spine
   for a publishable finite-math paper, and what theorem cluster would most
   improve it.

You may include Lean-like skeletons. If a skeleton is unfinished, label it as a
handoff. Raw proof-hole tokens are acceptable only inside executable Lean
snippets; in prose, use words like "handoff" or "open proof body".

Do not weaken existing theorem statements. Do not add new assumptions just to
make a theorem easier. If a target appears false, convention-mismatched, or too
ambiguous, say so and give the smallest corrected target.

The most important current research priorities are:

- spinor-network closure / celestial moment-map identity;
- scalar and affine celestial-channel dynamics;
- finite Klein-quadric / pairwise simplicity wrapper;
- crossed-module/fake-flatness layer on top of the newly integrated path-pair
  interchange theorem;
- reduced-density and concurrence wrappers beyond the finite determinant core;
- super-Dirac/order-complex assembly;
- source-visibility definitions with a sharp failure mode;
- a semantic audit of definitions before adding more algebra.
