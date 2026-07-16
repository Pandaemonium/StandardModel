# Aristotle task: exact L2 time-group capstone

Prove all five open declarations in
`AgentTasks/aristotle-targets/afpl_exact_flow_l2_group_capstone.lean` without
changing their statements.

Run the narrow target first:

```text
lake env lean AgentTasks/aristotle-targets/afpl_exact_flow_l2_group_capstone.lean
```

## Immutable semantics

- `momMult_add_time` must preserve the order `U(s+t) = U(s).comp U(t)`.
- The two `L2` laws are equalities of quotient-safe maps/classes, not selected
  representatives.
- Fourier conjugation must be used in transform, multiplier, inverse-transform
  order.
- The inverse controls must close through the landed zero-time identities.
- No generator-domain, Schwartz, PDE, walk-limit, or Lorentz theorem may be
  added to the result's interpretation.

Use the landed generic theorem
`VariablePointwiseL2Isometry.variablePointwiseL2Isometry_comp`, the exact
matrix theorem `ExactFlowTimeGroup.exactFlow_add_time`, and Fourier equivalence
injectivity. Add small local helper lemmas where necessary. Do not prove an
almost-everywhere representative statement and substitute it for the displayed
`Lp` equality.

Return a placeholder-free file, list every proved declaration, report any
statement change, and report the final axiom footprint.
