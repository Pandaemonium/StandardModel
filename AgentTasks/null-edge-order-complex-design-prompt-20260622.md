# Aristotle prompt: finite order-complex / graph Kahler-Dirac API (design)

Roadmap/scaffold job, not a proof job. Do not build the whole repo. Deliverable:
a minimal Lean module API (definitions, theorem signatures, proof sketches,
dependencies, blockers). Label unproved nodes as handoffs; no kernel-proof claims.

## Context

The null-edge program wants a finite order complex (poset of a finite causal
graph) carrying a discrete exterior calculus: cochain spaces by degree,
coboundary `d`, adjoint codifferential `delta`, grading/chirality, and the
Hodge-Dirac operator `D = d + delta`. The kernel-checked anchor already proved is
`laplacian_psd` (the graph Laplacian quadratic form is a sum of squares). The
successor target is the finite topological-Dirac square
`topological_dirac_sq_eq_laplacian` and a chiral mass term.

## Assignment

Propose the minimal API:

1. finite graded cochain spaces `C^k` from a finite poset / simplicial set;
2. `d : C^k -> C^{k+1}`, `delta` as its adjoint under a chosen inner product,
   with `d . d = 0`;
3. grading operator and the odd Hodge-Dirac `D = d + delta`;
4. the precise statement of `D^2 = Laplacian` (Hodge decomposition shape) and the
   anticommutation hypotheses it needs;
5. a chiral mass term and how it modifies `D^2`.

Then give a topologically-ordered list of intermediate lemma signatures marked
trusted / provable-now / needs-definition / risky, the highest-leverage next
lemma, and likely failure points.

Please end with this exact summary shape:

```text
overall assessment:
proposed core definitions:
D-squared statement:
ranked next theorem signatures:
likely blockers:
integration notes:
```
