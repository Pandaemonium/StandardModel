# Aristotle semantic context pack

Generated: 2026-06-26T09:21:06
Query: `null edge integration freeze Aristotle returned jobs dependency DAG trusted theorem promotion sign normalization dashboard P1 claim boundary branch count acceptance null edge specificity convention integration`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/null-edge-parallel-aristotle-loop-plan-2026-06-22.md` [Purpose]

Score: `0.837`

```text
## Purpose

Drive the null-edge program with an autonomous agent that can run **up to about
five or six independent Aristotle projects in parallel** when that serves the
research. The objective is not high slot utilization. The objective is
semantically reviewed theorem, definition, and audit artifacts that move one of
the publication gates in
[`Sources/Null_Edge_Causal_Graph_Publication_Plan.md`](../Sources/Null_Edge_Causal_Graph_Publication_Plan.md)
toward a credible paper.

The north star is **publication-worthy progress**: bank trusted theorem islands,
stabilize definitions that unlock real theorems, and kill or demote beautiful
ideas when the finite tests fail. Prefer one result that clarifies a claim
boundary over several jobs that merely keep the scheduler busy. This supersedes
the cadence and concurrency model of
[`null-edge-autonomous-aristotle-loop-plan-2026-06-21.md`](null-edge-autonomous-aristotle-loop-plan-2026-06-21.md)
(one job per cycle, hourly). It does **not** replace that note's reusable parts:
the job ledger format, the pre-integration convention checklist, the Aristotle
prompt templates, and the definition backlog are inherited verbatim and only
referenced here.

What is new:

- an adaptive pool of up to about 5-6 concurrent jobs organized by publication gates;
- self-paced reconciliation cycles (submit, wait, integrate, refill when useful);
- explicit token-budget discipline so the agent spends Aristotle's clock, not its
  own context window;
- strategy jobs only when they can change the next decisions, plus stall
  triggers.

House rule, unchanged and load-bearing: lead with the finite, kernel-checked
algebra; keep continuum physics in an explicitly conjectural layer; never promote
draft to trusted without a semantic/convention review. The kernel
```

### 2. `AgentTasks/model-calls/gemini/2026-06-24-round-010-constructive-next-job.md` [Query]

Score: `0.832`

```text
## Query

``text
We are advancing the null-edge causal graph program in a constrained loop. Current status: the P2 branch-reflection Aristotle job is still running, so the next one-job target should be independent if possible. Latest integrated result: finite P2 branch resolution for H_h(p,m) = [[-h p, m], [m, h p]] with P+ and P- trace-one idempotents on shell, P+ + P- = I, P+P-=P-P+=0, and E(P+ - P-) = H. Active priorities: P1-F Plucker/observer formalization; P1/P4/P7 null-step dynamics and proper-time readout; P2 super-Dirac gates; P9 finite source visibility/noise.

What is the single highest-value independent next Aristotle proof job? Please propose one concrete theorem target, one possible failure mode, and one literature/source check. Avoid depending on the in-flight branch-reflection job.
``
```

### 3. `AgentTasks/null-edge-grand-strategy-scaffold2-prompt-20260622.md` [Aristotle prompt: null-edge grand-strategy scaffolding (batch 2)]

Score: `0.830`

```text
# Aristotle prompt: null-edge grand-strategy scaffolding (batch 2)

This is a big-picture roadmap/scaffolding job, not a proof-completion job. Do not
build the whole repo. The deliverable is large-scale Lean proof skeletons for the
program's giant theorem chains: dependency DAGs, precise intermediate statements,
and explicit blockers. Label every unproved node as a handoff; do not claim
kernel proofs.
```

### 4. `AgentTasks/null-edge-constrained-integrator-loop-ledger-2026-06-24.md` [Aristotle submission]

Score: `0.829`

```text
### Aristotle submission

- Task note:
  `AgentTasks/null-edge-p2-branch-resolution-aristotle-2026-06-24.md`
- Standalone source:
  `AgentTasks/aristotle-standalone/null-edge-p2-branch-resolution-20260624/NullEdgeP2BranchResolution/Core.lean`
- Submission project:
  `AgentTasks/aristotle-submit/null-edge-p2-branch-resolution-20260624-project`
- Aristotle project: `a277efe9-6084-4c1a-ace3-19989465e567`
- Aristotle task: `5663aa96-6e77-4f8f-a56f-abb4024545e1`
- Initial status: queued.
```

### 5. `AgentTasks/null-edge-core-definition-consolidation-aristotle-2026-06-21.md` [Aristotle task: null-edge core definition consolidation]

Score: `0.825`

```text
# Aristotle task: null-edge core definition consolidation

Date: 2026-06-21
```

### 6. `AgentTasks/aristotle-grand-strategy-v2-prompt-20260621.md` [Aristotle prompt: null-edge grand strategy v2]

Score: `0.825`

```text
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
5. A short assessment of whether the current program has
```

### 7. `AgentTasks/model-calls/claude/2026-06-24-round-009-adversarial-next-job.md` [Critique: Next Aristotle Target for Null-Edge Program]

Score: `0.824`

```text
# Critique: Next Aristotle Target for Null-Edge Program
```

### 8. `AgentTasks/model-calls/gemini/2026-06-24-round-018-constructive-after-three-trace.md` [Query]

Score: `0.823`

```text
## Query

We are running a constrained autonomous integrator loop for the null-edge causal graph program.

Latest integrated P2 result: in the finite real 2x2 branch-reflection model, `trace(R3 R2 R1) = 0` for all parameters. Earlier results: one branch reflection is trace zero; two-reflection trace is `2 * (h1*h2*p1*p2 + m1*m2)/(E1*E2)`; determinant-only products collapse to parity. This suggests four-reflection or diamond trace claims need explicit closure/geometric constraints before any topological interpretation.

Current priorities: P1-F Plucker/observer normalization; P1/P4/P7 null-step chirality dynamics and proper-time readout; P2-R one-diamond super-Dirac gates; P9-F finite source-visibility/noise and coarse-map guardrails.

What is the single highest-value next finite Aristotle proof job? Please propose one concrete theorem target, why it matters physically, one failure/demotion mode, and one literature/source check. Favor finite theorems or counterexamples over broad synthesis.
```

## Scoped paper hits

### 1. Graph Sparsification by Effective Resistances

Score: `0.728`
Zotero key: `UFHN99H4`
arXiv: `0803.0929`
DOI: `10.1137/080734029`
URL: https://doi.org/10.1137/080734029

### 2. Random Walks on Simplicial Complexes and the Normalized Hodge 1-Laplacian

Score: `0.723`
Zotero key: `N7T76U5H`
arXiv: `1807.05044`
DOI: `10.1137/18M1201019`
URL: https://doi.org/10.1137/18M1201019

### 3. Laplacian Coarse Graining in Complex Networks

Score: `0.712`
Zotero key: `UR5ADCBP`
arXiv: `2302.07093`
URL: http://arxiv.org/abs/2302.07093

### 4. Tri-partitions and Bases of an Ordered Complex

Score: `0.711`
Zotero key: `D7352JCI`
DOI: `10.1007/s00454-020-00188-x`
URL: https://doi.org/10.1007/s00454-020-00188-x

### 5. Localized States for Elementary Systems

Score: `0.710`
Zotero key: `74NU4C33`
DOI: `10.1103/revmodphys.21.400`
URL: https://doi.org/10.1103/revmodphys.21.400
