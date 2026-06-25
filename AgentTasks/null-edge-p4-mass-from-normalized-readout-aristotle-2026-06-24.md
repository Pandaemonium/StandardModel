# Aristotle task: P4 mass from normalized observer readout

Submitted: 2026-06-24.

## Scientific role

This task advances the `P1/P4/P7` bridge. P1 has now banked the observer scalar
readout `det rho = ab/(a+b)^2` and `2 sqrt(det rho)=m/E`. P4 needs the inverse
mass-shell form: the unnormalized kinetic/Plucker mass square can be recovered
from the normalized determinant and observer energy:

```text
m^2 = E^2 * 4 det rho.
```

This lets null-step or transfer-operator targets use the invariant kinetic
symbol while still citing the observer-normalized P1 readout.

## Aristotle instructions

Please work on:

```text
NullEdgeP4MassFromNormalizedReadout/Core.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeP4MassFromNormalizedReadout/Core.lean
```

Primary targets:

```lean
kineticMassSq_eq_energySq_mul_four_normalizedVisibleDet
four_normalizedVisibleDet_eq_massSq_div_energySq
```

Guardrails:

- Keep this finite and scalar.
- Do not introduce continuum dynamics.
- Do not weaken `kineticMassSq_eq_energySq_mul_four_normalizedVisibleDet`
  by dropping the nonzero-energy hypothesis unless the theorem is genuinely
  stronger and still true.

Please finish with a concise next-steps note:

- which targets were solved;
- whether any statement/API change was needed;
- the next finite P4/P7 theorem you recommend.

## Metadata

```yaml
aristotle:
  project_id: 2bc30578-fc7c-4b5c-afda-96bbcf3cdcc1
  task_id: dcbe7a5f-5035-483d-839b-257270fe82fe
  target_file: NullEdgeP4MassFromNormalizedReadout/Core.lean
  expected_module: NullEdgeP4MassFromNormalizedReadout.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p4-mass-from-normalized-readout-20260624-project
  output_dir: AgentTasks/aristotle-output/2bc30578-fc7c-4b5c-afda-96bbcf3cdcc1
  status: integrated
```

## Integration note

Integrated as:

```text
PhysicsSM.Draft.NullEdgeP4MassFromNormalizedReadout
```

The standalone source under `AgentTasks/aristotle-standalone/` was also updated
with the completed proofs. The theorem
`kineticMassSq_eq_energySq_mul_four_normalizedVisibleDet` keeps the nonzero
observer-energy hypothesis, while the ratio form is a pure scalar identity.
