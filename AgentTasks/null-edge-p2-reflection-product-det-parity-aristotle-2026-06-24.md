# Aristotle task: P2 reflection product determinant parity

Submitted: 2026-06-24.

## Scientific role

This task advances the `P2-R` finite operator lane by formalizing an important
guardrail.

The branch-orientation certificate proves that every on-shell branch reflection
has determinant `-1`. Therefore determinant of a product of branch reflections
cannot encode rich proper-time or geometric information by itself: it carries
only reflection-count parity. A two-reflection product has determinant `+1`, and
an arbitrary finite product has determinant `(-1) ^ length`.

This is intentionally a negative/guardrail result. It blocks overstrong
determinant path-sum interpretations and points later work toward trace,
eigenvalue, or Pluecker/observer-channel data if geometric information is
desired.

## Aristotle instructions

Please work on:

```text
NullEdgeP2ReflectionProductDetParity/Core.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeP2ReflectionProductDetParity/Core.lean
```

Primary targets:

```lean
det2_mul
branchReflection_det2_eq_neg_one_on_massShell
det2_mul_two_branchReflections_eq_one_on_massShell
det2_matListProd
det2_matListProd_eq_neg_one_pow_length
```

Guardrails:

- Keep this finite and real: explicit `2 x 2` matrices over `Real`.
- Preserve the on-shell hypotheses for branch reflections.
- Treat this as a determinant-parity guardrail, not a proper-time theorem.
- Do not introduce diamonds, path spaces, Lorentz invariance, continuum
  assumptions, trace/rapidity claims, Pluecker rays, or zitterbewegung.
- Do not weaken the statements unless one is mathematically false; if an extra
  hypothesis is necessary, explain why.

Please finish with a concise completion report:

- which targets were solved;
- whether any statement/API change was needed;
- any hidden assumptions or theorem-strength concerns;
- suggested next finite theorem, especially whether to proceed toward a
  two-reflection trace/composition invariant or an explicit permutation-shift
  theorem with boundary data.

## Metadata

```yaml
aristotle:
  project_id: 9d31abd2-b822-480b-9c16-a987a51b5640
  task_id: f60fc36c-25a1-4fff-aeb6-ea26f763ba93
  target_file: NullEdgeP2ReflectionProductDetParity/Core.lean
  expected_module: NullEdgeP2ReflectionProductDetParity
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-reflection-product-det-parity-20260624-project
  output_dir: AgentTasks/aristotle-output/9d31abd2-b822-480b-9c16-a987a51b5640
  status: integrated
```

## Integration result

Integrated 2026-06-24 into:

- `PhysicsSM.Draft.NullEdgeP2ReflectionProductDetParity`
- `PhysicsSMDraft.lean`

The module proves multiplicativity for the explicit `2 x 2` determinant, the
on-shell determinant `-1` of a branch reflection, determinant `+1` for a product
of two branch reflections, determinant/product compatibility for finite lists,
and the finite-list parity law `(-1) ^ length`. This is a guardrail showing
that determinant-only reflection path products carry only parity data.
