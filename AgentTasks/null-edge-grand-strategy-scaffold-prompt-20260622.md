# Aristotle prompt: null-edge grand-strategy proof-chain scaffolding

This is a big-picture roadmap/scaffolding job, not a proof-completion job. Do not
build the whole repo. The deliverable is large-scale Lean proof skeletons for the
program's giant theorem chains: dependency DAGs, precise intermediate statements,
and explicit blockers. Label every unproved node as a handoff; do not claim
kernel proofs.

## Big-picture context

The null-edge causal-graph program tries to derive Standard Model and quantum-
gravity-adjacent structure from a finite causal graph whose edges carry null
(lightlike) momenta. Mass, gauge structure, and cosmology are meant to emerge
from the finite combinatorics of how null edges fan out, close, and source
curvature. The finite, kernel-checked algebra leads; continuum physics stays in
an explicitly conjectural layer. See the included
`Null_Edge_Causal_Graph_Publication_Plan.md` and
`Null_Edge_Causal_Graph_Strengthened_Program.md` for the publication gates
(referred to as P1..P9) and conventions.

Already-banked finite results include: the celestial-Plucker mass of a null-edge
bundle; rank-one edge momenta are null; visible-fan moment mass
`(E^2 - |C|^2)/4`; closed visible fans are rest frames; non-collinear visible
fans carry positive mass/source (a no-go); boundary-exact sources are invisible
to closed tests; finite fluctuation-scaling and uniform `A^2/N` suppression
identities; a path-pair higher-gauge interchange law.

## Assignment

Pick the THREE highest-value giant theorem chains and scaffold each as a Lean
proof skeleton (definitions, a DAG of named intermediate lemmas with precise
signatures, and the final target theorem), with blockers and convention notes:

1. the P9 cosmological-constant chain: from finite diamond-source visibility and
   suppression to a falsifiable parametric statement (or a clean no-go);
2. the P2 mass/operator chain: from rank-one null momenta and the Pauli/Dirac
   Clifford relations through the super-Dirac block square to a Standard-Model
   Yukawa/mass structure statement;
3. the P1/P6 celestial chain: from spinor bundles and Plucker brackets to the
   celestial-moment mass and its Gram-weighted generalization.

For each chain give:

- the minimal new definitions needed and where they should live;
- a topologically-ordered list of intermediate lemma signatures (Lean-like),
  each marked trusted / provable-now / needs-definition / risky;
- the single highest-leverage lemma to attack next;
- the most likely place the chain is false or underspecified.

Please end with this exact summary shape:

```text
overall assessment:
chain 1 (P9) skeleton:
chain 2 (P2) skeleton:
chain 3 (P1/P6) skeleton:
cross-chain shared definitions:
highest-leverage next lemmas:
likely failure points:
```
