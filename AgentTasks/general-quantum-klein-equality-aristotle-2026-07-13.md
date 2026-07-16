# Aristotle task: equality in general noncommuting quantum Klein

- Work item: `DYN-MODULAR-001`
- Role: Builder / Assassin
- Target: `AgentTasks/aristotle-targets/afpl_general_quantum_klein_equality.lean`
- Priority: quantum information strictness / uniqueness

## Objective

Fill exactly the three proof holes without changing definitions, theorem
statements, imports, or namespace.  Compose the landed general quantum Klein
inequality with the newly replayed scalar equality core.

The preferred route is:

1. Expand `qRelEntropy` with `entropy_trace_eq_sum` and
   `cross_trace_eq_sum`.
2. Apply `ScalarKleinEqualityCore.scalar_klein_eq` to show every nonzero
   overlap entry connects equal eigenvalues.
3. Package that support statement as
   `diag(lambda) * W = W * diag(mu)`.
4. Combine the intertwining identity with both spectral decompositions and
   unitarity of `W` to prove `rho = sigma`, allowing arbitrary rotations inside
   degenerate eigenspaces.
5. Derive strict positivity for unequal admissible states from nonnegativity
   and the equality iff.

## Semantic constraints

- Do not assume commuting matrices, simple spectrum, or that the overlap is a
  literal permutation.
- Do not replace the entropy-compatible spectral logarithm on singular `rho`
  by an undefined ordinary logarithm.
- Preserve positive definiteness of `sigma`, PSD of `rho`, and both trace-one
  hypotheses.
- Do not add operator convexity, CFC, or external matrix-log assumptions.
- Use no trust-expanding declarations or evaluator shortcuts.

## Verification

Run:

```text
lake env lean AgentTasks/aristotle-targets/afpl_general_quantum_klein_equality.lean
```

Return the completed target and explain how the intertwining identity handles
degenerate eigenspaces without a permutation claim.
