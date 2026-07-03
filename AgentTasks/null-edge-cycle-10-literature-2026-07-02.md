# Null-edge cycle 10 literature note

Date: 2026-07-02

## Status at cycle start

The accumulated-Trotter Aristotle job is still running:

```text
Project: 130705c7-9455-41d1-92fc-c7360a411bf0
Task: 025b5006-6120-41c6-8044-a735de39e3ae
Status: IN_PROGRESS
```

## Search focus

With the finite stability wrapper now checked in Lean, the remaining question
is how best to package the final bound:

- finite matrix/operator-norm Trotter estimate;
- pointwise momentum quantum-walk-to-Dirac convergence;
- row-sum or L2 operator norm as the stability norm.

## Sources checked

- Arrighi, Forets, Nesme, "The Dirac equation as a quantum walk", arXiv:1307.3524.
  Link: https://arxiv.org/abs/1307.3524
  Relevance: still the best physics-facing guide for a discrete, homogeneous,
  causal, unitary walk converging to a Dirac equation. It supports the current
  choice to keep the theorem pointwise/observational first.

- Mlodinow and Brun, "Discrete spacetime, quantum walks, and relativistic wave
  equations", Phys. Rev. A 97, 042131.
  Link: https://link.aps.org/doi/10.1103/PhysRevA.97.042131
  Relevance: useful background that equal-norm/unitarity conditions are what
  make the Dirac continuum limit physically meaningful. It supports the L2
  operator-norm lane as the semantic normalization target.

- Di Molfetta and Debbasch, "Dirac equation as a quantum walk over the
  honeycomb and triangular lattices", Phys. Rev. A 97, 062111.
  Link: https://link.aps.org/doi/10.1103/PhysRevA.97.062111
  Relevance: confirms that quantum-walk Dirac limits are sensitive to lattice
  geometry and coin/operator choices. This reinforces keeping the 1+1D
  checkerboard theorem separate from hyperdiamond claims.

- Neidhardt, Stephan, Zagrebnov, "Operator-Norm Convergence of the Trotter
  Product Formula on Hilbert and Banach Spaces: A Short Survey".
  Link: https://hal.science/hal-01971597/document
  Relevance: broad operator-norm Trotter context. Our current theorem is finite
  dimensional and much simpler, but the source reinforces that operator-norm
  convergence rates need explicit stability constants rather than informal
  retardedness/unitarity claims.

- Mathlib matrix/norm documentation index.
  Link: https://leanprover-community.github.io/mathlib4_docs/Mathlib
  Relevance: confirms that the Lean work should keep using scoped matrix norm
  instances rather than introducing a global norm instance for the project-local
  matrix type.

## Takeaways for Lean

1. The final public theorem should probably be staged:
   first a scoped operator-norm finite/asymptotic theorem, then a separate
   statement translating to the project-local `matrixL1Norm` discrepancy if
   needed.
2. The L2 route is physically cleaner for unitary normalization, but the
   L-infinity route already has a checked per-step bridge and finite power
   wrapper. It is the best route for immediate proof completion.
3. Local work during the cycle proved `linftyOpNorm_nullShiftSymbol_le_one`.
   The narrow Aristotle row-sum job then completed and was integrated, adding
   `linftyOpNorm_isotropicStep_le_abs_cos_add_abs_sin`,
   `linftyOpNorm_isotropicStep_le_one_add_abs`, and
   `linftyOpNorm_momentumStepSymbolRaw_le_one_add_abs`.
