# Aristotle task: P2 positive branch projector

Submitted: 2026-06-24.

## Scientific role

This task advances the `P2-R` / `P4-R` / `P7-R` bridge.

The immediately preceding P2 job proved that the finite two-level chiral
Hamiltonian

```text
H_h(p,m) = [[-h p, m], [m, h p]]
```

squares to `(p^2 + m^2) I` when `h^2 = 1`, and that the positive branch
`(1/2)(I + H/E)` has left/right coherence `m/(2E)`. This job certifies that
the same matrix is not merely an algebraic convenience: on the mass shell it is
a genuine trace-one idempotent branch projector. That is the finite
operator-level bridge needed before reading the coherence scalar as a
Born-weight/proper-time observable in P4/P7.

This is finite `2 x 2` matrix algebra only. It is not a continuum Dirac limit.

## Aristotle instructions

Please work on:

```text
NullEdgeP2PositiveBranchProjector/Core.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeP2PositiveBranchProjector/Core.lean
```

Primary targets:

```lean
positiveBranch_trace_eq_one
positiveBranch_idempotent_on_massShell
```

Guardrails:

- Keep the field `Real`, and keep `E` as a primitive real with hypotheses
  `E ^ 2 = p ^ 2 + m ^ 2` and `E != 0`.
- Preserve the sign convention `H_h(p,m) = [[-h p, m], [m, h p]]`.
- Do not introduce continuum dynamics, hidden Lorentz-boost claims, or fake
  assumptions.
- It is fine to reuse the already staged theorem
  `chiralHamiltonian_sq_eq_massShell`, but do not change its statement.
- Prefer direct finite matrix entry proofs if they are simpler than importing
  the generic Dirac two-sheet projector machinery.

Please finish with a concise next-steps note:

- which targets were solved;
- whether any statement/API change was needed;
- what finite P2/P4/P7 theorem should come next to connect this projector to a
  null-step quantum walk or super-Dirac block.

## Metadata

```yaml
aristotle:
  project_id: 00617722-d4db-43d2-934d-6b6812751fb6
  task_id: 43d1567a-56c4-4afe-bb87-1ac5776c5431
  target_file: NullEdgeP2PositiveBranchProjector/Core.lean
  expected_module: NullEdgeP2PositiveBranchProjector.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-positive-branch-projector-20260624-project
  output_dir: AgentTasks/aristotle-output/00617722-d4db-43d2-934d-6b6812751fb6
  status: integrated
```

## Integration note

Integrated as:

```text
PhysicsSM.Draft.NullEdgeP2PositiveBranchProjector
```

Aristotle preserved all target theorem statements and the sign convention
`H_h(p,m) = [[-h p, m], [m, h p]]`. It proved that the positive branch is
trace one without energy hypotheses, and that it is idempotent under
`E != 0`, `E^2 = p^2 + m^2`, and `h * h = 1`. The completion report
recommended the next finite step: add the negative branch, prove complementary
orthogonal resolution of identity, and then use that as the precursor to a
finite reflection/coin operator.

Verification run after integration:

```text
lake env lean AgentTasks/aristotle-output/00617722-d4db-43d2-934d-6b6812751fb6/extracted/project-files.tar/null-edge-p2-positive-branch-projector-20260624-project_aristotle/NullEdgeP2PositiveBranchProjector/Core.lean
lake env lean AgentTasks/aristotle-standalone/null-edge-p2-positive-branch-projector-20260624/NullEdgeP2PositiveBranchProjector/Core.lean
lake env lean PhysicsSM/Draft/NullEdgeP2PositiveBranchProjector.lean
lake build PhysicsSM.Draft.NullEdgeP2PositiveBranchProjector
lake env lean PhysicsSMDraft.lean
```
