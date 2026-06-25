# Aristotle task: P2 branch reflection orientation certificate

Submitted: 2026-06-24.

## Scientific role

This task advances the `P2-R` finite operator lane.

The current branch-reflection modules show that `R = H/E` reconstructs the
two-level chiral Hamiltonian, squares to the identity on shell, and preserves
screen second moments under repeated local application. The next small
certificate is that the operator is an actual real reflection: it has trace
zero, determinant `-1` on shell, and is therefore not the identity.

This matters because it separates the finite branch operator from a generic
norm-preserving map. It is orientation-reversing finite `2 x 2` algebra only,
not a chirality, zitterbewegung, Pluecker-ray, shift, walk, or continuum claim.

## Aristotle instructions

Please work on:

```text
NullEdgeP2BranchOrientation/Core.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeP2BranchOrientation/Core.lean
```

Primary targets:

```lean
branchReflection_trace2_eq_zero
branchReflection_det2_eq_neg_one_on_massShell
det2_one
branchReflection_ne_one_on_massShell
```

Guardrails:

- Keep this finite and real: explicit `2 x 2` matrices over `Real`.
- Preserve the on-shell hypotheses `h * h = 1`, `E != 0`, and
  `E ^ 2 = p ^ 2 + m ^ 2`.
- Do not introduce eigenspaces, chirality semantics, Pluecker rays, shifts,
  walks, complex phases, continuum assumptions, or zitterbewegung claims.
- Do not weaken statements unless one is mathematically false; if an extra
  hypothesis is necessary, explain why.
- The intended proof is explicit finite matrix arithmetic.

Please finish with a concise completion report:

- which targets were solved;
- whether any statement/API change was needed;
- any hidden assumptions or theorem-strength concerns;
- suggested next finite theorem, especially whether to proceed toward an
  explicit eigenspace projector split, a permutation-shift unitarity theorem
  with boundary data, or an observer-channel/coarse-graining theorem.

## Metadata

```yaml
aristotle:
  project_id: 8845e13a-d9f4-4d18-8f40-9a79f2edc96a
  task_id: 389d06a8-e2f0-402e-9d77-4538cdaf3023
  target_file: NullEdgeP2BranchOrientation/Core.lean
  expected_module: NullEdgeP2BranchOrientation
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-branch-orientation-20260624-project
  output_dir: AgentTasks/aristotle-output/8845e13a-d9f4-4d18-8f40-9a79f2edc96a
  status: integrated
```

## Integration result

Integrated 2026-06-24 into:

- `PhysicsSM.Draft.NullEdgeP2BranchOrientation`
- `PhysicsSMDraft.lean`

The module proves that the scalar branch reflection has trace zero, determinant
`-1` on shell, determinant `1` for the identity, and is therefore not the
identity. This is the finite orientation-reversing guardrail for the P2 branch
operator.
