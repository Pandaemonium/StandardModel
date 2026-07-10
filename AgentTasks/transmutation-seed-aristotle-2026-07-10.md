# Aristotle job: exact transmutation invariant (hard problem 6)

Date: 2026-07-10 (hard-problem wave). The exactly solvable one-loop seed: closed form g_k = g0/(1+k b g0); asymptotic freedom; the EXACT flow invariant 1/(b g_k) - k = 1/(b g0) (conserved at every step, not asymptotically); the invariant generated scale exp(-1/(b g0)); and nonperturbative flatness (the scale vanishes faster than every power of the coupling - invisible to perturbation theory). Rational witness b=1, g0=1/3: 1/3 -> 1/4 -> 1/5, invariant 3. Honest scope: the mechanism as theorem, not a physical beta function or a GeV value.

```yaml
aristotle:
  project_id: 8ec5d15e-25b3-47d6-a181-ea250d8ad7b2
  target_file: AgentTasks/aristotle-standalone/transmutation-seed-20260710/TransmutationSeed/ExactFlowInvariant.lean
  expected_module: TransmutationSeed.ExactFlowInvariant
  submission_project: AgentTasks/aristotle-submit/claude-transmutation-seed-20260710-project
  output_dir: AgentTasks/aristotle-output/8ec5d15e-25b3-47d6-a181-ea250d8ad7b2
  status: integrated; remote task complete
```

## Snapshot harvest

The in-progress snapshot already contained complete proofs of all six
unchanged targets and no proof placeholders.  It passed the repository
toolchain locally.  The result was cleaned into
`PhysicsSM/Draft/NullEdge/DiscreteDimensionalTransmutation.lean`, guarded,
and added to the draft root.  The remote task remains active for its own final
verification and package.
