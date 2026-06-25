# Aristotle task: P2 branch reflection

Submitted: 2026-06-24.

## Scientific role

This task advances the `P2-R` / `P4-R` / `P7-R` bridge.

The current P2 chain has a full two-branch resolution for the finite chiral
Hamiltonian

```text
H_h(p,m) = [[-h p, m], [m, h p]].
```

The positive and negative branches are trace-one idempotents on shell, resolve
the identity, are mutually orthogonal, and reconstruct the Hamiltonian by
`E • (P+ - P-) = H`.

This job packages the branch difference as the finite reflection/coin operator

```text
R = P+ - P-.
```

The important content is not just `R^2 = I`, but that `R` reconstructs `H`,
commutes with `H`, acts as `+1` on `P+` and `-1` on `P-`, and is uniquely
determined by `E • R = H` when `E != 0`. This gives the finite branch operator
needed before defining a null-step walk coin or super-Dirac reflection.

This is finite `2 x 2` matrix algebra only. It is not a continuum Dirac limit
or a Lorentz-boost theorem.

## Aristotle instructions

Please work on:

```text
NullEdgeP2BranchReflection/Core.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeP2BranchReflection/Core.lean
```

Primary targets:

```lean
branchReflection_reconstructs_hamiltonian
branchReflection_trace_eq_zero
branchReflection_sq_eq_one_on_massShell
branchReflection_commutes_hamiltonian
branchReflection_mul_positive_eq_positive_on_massShell
branchReflection_mul_negative_eq_neg_negative_on_massShell
branchReflection_unique_of_reconstructs
```

Guardrails:

- Keep the field `Real`, and keep `E` as a primitive real.
- Use `E != 0`, `E ^ 2 = p ^ 2 + m ^ 2`, and `h * h = 1` exactly where needed.
- Preserve the sign convention `H_h(p,m) = [[-h p, m], [m, h p]]`.
- Do not introduce continuum dynamics, hidden Lorentz-boost claims, matrix
  exponentials, or fake assumptions.
- This should be a publication-facing real `2 x 2` P2 API, even though generic
  two-sheet projector patterns exist elsewhere in the repo.

Please finish with a concise next-steps note:

- which targets were solved;
- whether any statement/API change was needed;
- what finite P2/P4/P7 theorem should come next to connect this reflection to a
  null-step quantum walk or super-Dirac block.

## Metadata

```yaml
aristotle:
  project_id: 48a60fa1-cd8e-40f1-a918-aa64fd77543a
  task_id: 4e02b69b-30d0-4518-a9f2-e46ba81a5bd3
  target_file: NullEdgeP2BranchReflection/Core.lean
  expected_module: NullEdgeP2BranchReflection.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-branch-reflection-20260624-project
  output_dir: AgentTasks/aristotle-output/48a60fa1-cd8e-40f1-a918-aa64fd77543a
  status: integrated
```

## Integration result

Integrated 2026-06-24 into:

- `PhysicsSM.Draft.NullEdgeP2BranchReflection`
- `PhysicsSMDraft.lean`

The live draft module uses the existing `NullEdgeP2BranchResolution` API rather
than duplicating the full branch definitions from the standalone package. It
adds the reflection operator `R = P+ - P-`, reconstruction, tracelessness,
on-shell involution, commutation with the Hamiltonian, branch action, and
uniqueness from the reconstruction equation. It also records the useful scalar
form `R = E^-1 H`.
