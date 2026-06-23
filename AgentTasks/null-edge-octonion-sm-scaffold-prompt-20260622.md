# Aristotle prompt: octonion / exceptional-Jordan -> Standard Model scaffold

Big-picture roadmap/scaffolding job, not a proof job. Do not build the whole
repo. Deliverable: a Lean proof skeleton (definitions, dependency DAG of
intermediate lemma signatures, blockers) for deriving Standard Model gauge
structure and fermion representations from octonions / the exceptional Jordan
algebra. Label each node trusted / provable-now / needs-definition / risky. Do
not claim kernel proofs.

## Context

This repo (`PhysicsSM`) formalizes octonions (XOR binary-label convention; see
`PhysicsSM.Algebra.Octonion`), division algebras, and exceptional Lie/Jordan
structure. The physics chain to scaffold (literature grounding from the Neo4j
null-edge graph):

- Todorov-Dubois-Violette, "The Standard Model, the Exceptional Jordan Algebra,
  and Triality" (`2006.16265`);
- Dubois-Violette, "Exceptional quantum geometry and particle physics"
  (`1808.08110`); and the automorphism/structure-group route (`1806.09450`).

The target chain: from the octonion multiplication and the exceptional Jordan
algebra `J3(O)`, through its automorphism group `F4` and structure/reduced
structure groups, to the Standard Model gauge group
`SU(3) x SU(2) x U(1) / Z6` and one generation of fermion representations.

## Assignment

Scaffold the Lean proof skeleton:

1. minimal definitions needed beyond what the repo has (Jordan product on `J3(O)`,
   trace form, automorphism group, the relevant subgroup that fixes a 2x2 block);
2. a topologically-ordered list of intermediate lemma signatures (Lean-like),
   each marked trusted / provable-now / needs-definition / risky, leading to:
   the automorphism group of `J3(O)` is `F4`; the subgroup fixing an idempotent
   gives `Spin(9)` / the SM-relevant `SU(3)xSU(2)xU(1)` quotient; one generation
   of fermions sits in the expected representation;
3. the single highest-leverage lemma to attack first;
4. the most likely place the chain is false, convention-dependent, or
   underspecified (note the repo's specific octonion sign/label convention).

Please end with this exact summary shape:

```text
overall assessment:
proposed core definitions:
chain skeleton (topological order):
highest-leverage next lemma:
likely failure / convention points:
integration notes:
```
