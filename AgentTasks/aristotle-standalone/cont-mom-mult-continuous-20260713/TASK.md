# Aristotle task: live Dirac multiplier continuity

Prove the single immutable hole in `MomMultContinuous.lean` without changing
the theorem statement or definitions.  Run the targeted check first:

```text
lake env lean AgentTasks/aristotle-standalone/cont-mom-mult-continuous-20260713/MomMultContinuous.lean
```

The strongest intended route uses the existing theorem
`ExactFlowMomentumLipschitz.exactFlow_momentum_lipschitz`, together with the
finite-dimensional Euclidean coordinate topology and continuity of
`Matrix.toEuclideanCLM`.  A direct composition proof through `exactFlow` and
the continuous matrix exponential is also acceptable.

Do not weaken the theorem.  Do not introduce assumptions, trust-expanding
evaluation, or placeholders.  Do not claim an `L2` lift, surjectivity, a group
law, Fourier transport, strong time continuity, a generator, or a PDE.

Success means the file compiles under Lean 4.28.0 with no proof placeholders
and the exact theorem statement unchanged.
