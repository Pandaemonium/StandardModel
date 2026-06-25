# Aristotle task: P2 branch resolution

Submitted: 2026-06-24.

## Scientific role

This task advances the `P2-R` / `P4-R` / `P7-R` bridge.

The current finite P2 chain has proved that the two-level chiral Hamiltonian

```text
H_h(p,m) = [[-h p, m], [m, h p]]
```

squares to the mass-shell scalar, that the positive branch
`P+ = (1/2)(I + H/E)` carries left/right coherence `m/(2E)`, and that `P+` is
trace one and idempotent on shell. This job adds the negative branch
`P- = (1/2)(I - H/E)` and proves the branch-resolution package:

```text
P+ + P- = I,
P+ P- = P- P+ = 0,
P-^2 = P-,
E (P+ - P-) = H.
```

The centerpiece is the finite spectral reconstruction identity. It is the
right precursor to a null-step walk coin/reflection operator and to the
super-Dirac branch interpretation.

This is finite `2 x 2` matrix algebra only. It is not a continuum Dirac limit.

## Aristotle instructions

Please work on:

```text
NullEdgeP2BranchResolution/Core.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeP2BranchResolution/Core.lean
```

Primary targets:

```lean
negativeBranch_trace_eq_one
positive_add_negative_eq_one
negativeBranch_idempotent_on_massShell
positive_mul_negative_eq_zero_on_massShell
negative_mul_positive_eq_zero_on_massShell
spectral_reconstruction
```

Guardrails:

- Keep the field `Real`, and keep `E` as a primitive real with hypotheses
  `E ^ 2 = p ^ 2 + m ^ 2` and `E != 0` for on-shell division claims.
- Preserve the sign convention `H_h(p,m) = [[-h p, m], [m, h p]]`.
- Do not introduce continuum dynamics, hidden Lorentz-boost claims, or fake
  assumptions.
- The generic Dirac two-sheet pattern already exists in the repo, but this
  focused job should give the publication-facing real `2 x 2` P2 API.
- Direct finite matrix entry proofs are fine.

Please finish with a concise next-steps note:

- which targets were solved;
- whether any statement/API change was needed;
- what finite P2/P4/P7 theorem should come next to connect this branch
  resolution to a null-step quantum walk or super-Dirac block.

## Metadata

```yaml
aristotle:
  project_id: a277efe9-6084-4c1a-ace3-19989465e567
  task_id: 5663aa96-6e77-4f8f-a56f-abb4024545e1
  target_file: NullEdgeP2BranchResolution/Core.lean
  expected_module: NullEdgeP2BranchResolution.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-branch-resolution-20260624-project
  output_dir: AgentTasks/aristotle-output/a277efe9-6084-4c1a-ace3-19989465e567
  status: integrated
```

## Integration note

Integrated as:

```text
PhysicsSM.Draft.NullEdgeP2BranchResolution
```

Aristotle preserved all target statements and the sign convention
`H_h(p,m) = [[-h p, m], [m, h p]]`. It proved the negative-branch trace,
completeness, negative idempotence, both orthogonality directions, and the
spectral reconstruction identity `E • (P+ - P-) = H`. The completion report
recommended the next finite step: define the branch reflection/coin
`R = P+ - P-`, prove `R^2 = I` on shell, and record `R = E^-1 • H`.

Verification run after integration:

```text
lake env lean AgentTasks/aristotle-output/a277efe9-6084-4c1a-ace3-19989465e567/extracted/project-files.tar/null-edge-p2-branch-resolution-20260624-project_aristotle/NullEdgeP2BranchResolution/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p2-branch-resolution-20260624/NullEdgeP2BranchResolution/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP2BranchResolution.lean
lake build PhysicsSM.Draft.NullEdgeP2BranchResolution
lake env lean PhysicsSMDraft.lean
```
