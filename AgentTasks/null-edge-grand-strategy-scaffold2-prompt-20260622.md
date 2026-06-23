# Aristotle prompt: null-edge grand-strategy scaffolding (batch 2)

This is a big-picture roadmap/scaffolding job, not a proof-completion job. Do not
build the whole repo. The deliverable is large-scale Lean proof skeletons for the
program's giant theorem chains: dependency DAGs, precise intermediate statements,
and explicit blockers. Label every unproved node as a handoff; do not claim
kernel proofs.

## Big-picture context

The null-edge causal-graph program derives Standard Model and quantum-gravity
structure from a finite causal graph whose edges carry null momenta. See the
included `Null_Edge_Causal_Graph_Publication_Plan.md` for gates P1..P9 and
conventions. Banked finite results already include celestial-Plucker mass,
rank-one null momenta, visible-fan mass `(E^2-|C|^2)/4`, the non-collinearity
no-go, boundary-exact source invisibility, fluctuation/uniform-suppression
identities, and a path-pair higher-gauge interchange law.

## Assignment

Scaffold Lean proof skeletons for these FOUR chains (this batch is complementary
to the P9 / P2 / P1-P6 batch):

1. P3 higher-gauge chain: from the trusted path-pair interchange law to a
   crossed-module / fake-flatness statement (which finite 2-cell labels and
   surface-transport conditions are forced), ending in a discrete non-abelian
   surface-holonomy invariance theorem;
2. P7 information chain: from finite relative entropy / data-processing
   contraction and the Bloch mass-ratio to a recoverability-gap-controls-source-
   visibility theorem and an approximate-Markov / Petz-recovery statement;
3. Lane E Klein-quadric chain: from the spinor Plucker bracket and
   massless-iff-repeated-principal-spinor through bivector simplicity
   (Pfaffian = 0 on the Klein quadric of Lambda^2 C^4) toward a finite
   spin-foam simplicity/Plebanski-sector statement;
4. spectral-triple / Standard-Model emergence chain: from the finite super-Dirac
   block square through the first-order condition and inner fluctuations to a
   finite spectral-action that yields a gauge + Higgs term, i.e. how the SM
   field content could emerge.

For each chain give the minimal new definitions, a topologically-ordered list of
intermediate lemma signatures (Lean-like) marked
trusted / provable-now / needs-definition / risky, the single highest-leverage
next lemma, and the most likely failure point.

Please end with this exact summary shape:

```text
overall assessment:
chain 1 (P3 higher-gauge) skeleton:
chain 2 (P7 information) skeleton:
chain 3 (Lane E Klein quadric) skeleton:
chain 4 (spectral triple / SM) skeleton:
cross-chain shared definitions:
highest-leverage next lemmas:
likely failure points:
```
