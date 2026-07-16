# Aristotle task: package the position Dirac operator on Schwartz spinors

- Work item: `CONT-FOURIER-001`
- Role: Builder
- Target: `AgentTasks/aristotle-targets/afpl_position_dirac_schwartz_operator.lean`
- Priority: P95 continuum reconstruction, rung T2-A

## Objective

Fill exactly the three proof holes without changing definitions, theorem
statements, imports, or namespace.

1. Prove the continuous Schwartz operator evaluates pointwise to the raw
   `FourierDiracSchwartzCapstone.positionDirac` expression.
2. Upgrade the landed raw Fourier symbol theorem to the packaged Schwartz
   operator, preserving the exact `-I/(2*pi)` normalization.
3. Prove the zero-spinor control.

Use the existing `SchwartzMap.bilinLeftCLM` constant-matrix action and
`lineDerivOpCLM` directional derivatives; do not rebuild Schwartz topology by
hand unless an API gap requires it.

## Semantic constraints

- Do not change Mathlib's Fourier convention or absorb `2*pi` into momentum.
- Do not call this a time-evolution PDE theorem: it packages the generator and
  proves its exact Fourier symbol, but does not yet differentiate the flow.
- Do not claim a closed `L2` generator, Stone theorem, changing-lattice limit,
  or Lorentz restoration.
- Use no trust-expanding declarations or evaluator shortcuts.

## Verification

Run:

```text
lake env lean AgentTasks/aristotle-targets/afpl_position_dirac_schwartz_operator.lean
```

Return the completed target and explicitly confirm the coordinate derivative
direction and `-I/(2*pi)` sign.
