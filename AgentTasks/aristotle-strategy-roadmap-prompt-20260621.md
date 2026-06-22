# Prompt for Aristotle: null-edge causal graph strategy roadmap

You are being asked to do theorem-planning and research-scaffolding, not to
finish a Lean development in one pass.

## Hard instruction: do not build

Do not run `lake build`, `lake env lean`, or any other Lean compile command for
this task. The purpose is to test whether you can read a research program plus
curated Lean context and produce a strategic roadmap. We are not asking for
verified Lean in this run.

You may return Lean-like scaffold files or snippets, and proof-hole
placeholders are allowed in those scaffold files. If you include placeholders,
label them as handoff points with precise proof sketches and dependencies. Do
not claim a theorem is proved unless you have actually supplied a proof.

## Context to read first

Primary document:

```text
Sources/Null_Edge_Causal_Graph_Strengthened_Program.md
```

This file is included in its entirety and should be treated as the goal
specification for the experiment. Your job is to ask: "If this strengthened
program were eventually formalized well, what would the final Lean architecture
and proof roadmap look like, and which pieces could I realistically help prove
next?" The curated Lean files are context for what already exists; the
Strengthened Program document is the research target.

Also read:

```text
Sources/Null_Edge_Causal_Graph_Research_Plan.md
AGENTS.md
docs/ARISTOTLE.md
PhysicsSMDraft.lean
```

Then inspect the curated Lean theorem islands under `PhysicsSM/` included in
this package. You do not need to inspect every line equally; prioritize the
modules that support the operator spine, Pluecker mass, diamond curvature,
hidden-channel/Gram mass, quantum measure, twistor/Yukawa wrappers, and
Kähler-Dirac/order-complex route.

## What we want back

Please produce a hybrid Markdown/Lean strategy artifact named something like:

```text
null-edge-strategy-roadmap-output.md
```

Optional scaffold files are welcome, for example under:

```text
PhysicsSM/Draft/NullEdgeRoadmap/
```

but they are allowed to be non-compiling sketches if clearly labeled as such.

## Questions to answer

1. What are the highest-value theorem clusters you think are realistically
   provable from the current Lean context?
2. Which claims in the program are mostly already proved, which are one or two
   focused proof jobs away, and which need new definitions first?
3. What final Lean module architecture would you recommend if the whole
   null-edge causal graph program were eventually formalized?
4. For each major branch, what are the key definitions, theorem statements,
   proof sketches, dependencies, and likely blockers?
5. Which theorem targets should be split into standalone Aristotle jobs, and
   what should those focused jobs contain?
6. Where do you see possible statement mistakes, convention mismatches,
   hidden assumptions, or mathematical falsehoods?
7. Which parts of the program are most likely to be publishable theorem
   islands, and which are currently only speculative physics interpretation?

## Branches to prioritize

Prioritize these, in roughly this order:

1. Diamond source visibility and the cosmological-constant branch.
2. The finite causal super-Dirac/operator spine:
   `D_{U,Phi}=d_U+delta_U+Phi+Phi^dagger`.
3. Pluecker mass, Dirac square roots, and branch projectors.
4. Pluecker/Bargmann phase and graph holonomy matching.
5. Bivector/BF simplicity-defect wrapper.
6. Generation blindness and internal Gram/Yukawa flavor geometry.
7. Kähler-Dirac order-complex fermions and two-sheet/CPT structure.
8. Quantum-measure/decoherence-functional finite algebra.

## Output schema

Please structure the main output as:

```text
# Null-edge strategy roadmap from Aristotle

## Executive assessment
Short, blunt assessment of the program's theorem leverage.

## Current theorem inventory
Map current Lean modules to mathematical content.

## Proposed final Lean architecture
Module tree with trusted/draft layers.

## Theorem clusters
For each cluster:
- purpose
- definitions needed
- theorem statements
- proof sketch
- dependencies
- likely blockers
- focused Aristotle follow-up jobs
- whether proof-hole scaffold should be accepted now

## Falsification and risk notes
Statement risks, convention risks, and physics-overclaim risks.

## Concrete next 10 jobs
Ranked list of focused jobs, each small enough to submit separately.

## Optional Lean scaffold
Lean-like skeletons are welcome, with documented proof-hole handoffs.
```

## Style and constraints

- Be ambitious but honest.
- Do not weaken mathematical statements just to make them look provable.
- Prefer finite algebra/combinatorics before analytic or continuum claims.
- Separate kernel-checkable theorem content from physics interpretation.
- Keep convention issues explicit: signature, Pauli/gamma conventions,
  Pluecker normalization, gauge orientation, and internal/visible split.
- Do not copy external code or assert source support without checking the
  supplied context.
