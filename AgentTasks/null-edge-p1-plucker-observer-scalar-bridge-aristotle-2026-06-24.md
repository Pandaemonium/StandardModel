# Aristotle task: P1 Plucker observer scalar bridge

Submitted: 2026-06-24.

## Scientific role

This task advances `P1-F`, the formal origin-of-mass paper. The previous round
proved that a fixed observer/rest Hermitian block leaves residual `SU(2)`
spin-frame freedom. The next finite theorem should exhibit the actual scalar
observer readout:

```text
det rho = ab / (a+b)^2
m^2 = 4ab
2 sqrt(det rho) = m / E
```

This bridges the unnormalized Plucker mass scalar and the observer-conditioned
normalized celestial determinant in a two-null observer-axis model.

## Aristotle instructions

Please work on:

```text
NullEdgeP1PluckerObserverScalarBridge/Core.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeP1PluckerObserverScalarBridge/Core.lean
```

Primary targets:

```lean
two_sqrt_normalizedVisibleDet_eq_pluckerMass_over_energy
four_mul_normalizedVisibleDet_eq_massSq_over_energySq
```

Guardrails:

- Keep the theorem finite and scalar. Do not introduce continuum dynamics.
- Do not weaken the positivity hypotheses unless the theorem becomes stronger.
- If the square-root theorem is awkward, solve the squared theorem first and
  explain the remaining square-root obstruction.

Please finish with a concise next-steps note:

- which targets were solved;
- whether any statement/API change was needed;
- the next finite P1-F theorem you recommend.

## Metadata

```yaml
aristotle:
  project_id: cf262f46-f04b-42fb-92d6-8ffd9cad9da3
  task_id: 5def910c-debf-4d9a-9a4c-0d153d8eeca7
  target_file: NullEdgeP1PluckerObserverScalarBridge/Core.lean
  expected_module: NullEdgeP1PluckerObserverScalarBridge.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p1-plucker-observer-scalar-bridge-20260624-project
  output_dir: AgentTasks/aristotle-output/cf262f46-f04b-42fb-92d6-8ffd9cad9da3
  status: integrated
```

## Integration note

Integrated as:

```text
PhysicsSM.Draft.NullEdgeP1PluckerObserverScalarBridge
```

The standalone source under `AgentTasks/aristotle-standalone/` was also updated
with the completed proofs. Aristotle strengthened
`four_mul_normalizedVisibleDet_eq_massSq_over_energySq` by removing the
unneeded nonzero-energy hypothesis; the identity holds for all real `a b`.
