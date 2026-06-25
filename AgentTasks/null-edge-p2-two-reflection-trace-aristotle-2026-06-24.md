# Aristotle task: P2 two-reflection trace invariant

Submitted: 2026-06-24.

## Scientific role

This task advances the `P2-R` finite operator lane.

The determinant-parity guardrail shows that determinant-only products of branch
reflections carry only reflection-count parity. The next finite scalar is the
trace of a two-reflection product. This target proves an explicit real `2 x 2`
trace formula:

```text
trace(R2 R1) = 2 * (h1*h2*p1*p2 + m1*m2) / (E1*E2).
```

This is the first non-parity scalar for products of branch reflections. It is
still finite algebra only: no eigenvalues, phases, arccosines, Lorentz groups,
continuum proper time, or path sums.

## Aristotle instructions

Please work on:

```text
NullEdgeP2TwoReflectionTrace/Core.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeP2TwoReflectionTrace/Core.lean
```

Primary targets:

```lean
trace2_mul_two_branchReflections_formula
trace2_mul_two_branchReflections_symm
trace2_branchReflection_sq_eq_two_on_massShell
```

Guardrails:

- Keep this finite and real: explicit `2 x 2` matrices over `Real`.
- Do not introduce spectral theory, complex eigenvalues, phases, arccosines,
  Lorentz groups, path spaces, proper time, or continuum assumptions.
- Preserve the exact formula if mathematically possible. If denominator
  hypotheses are genuinely needed, explain why and make the smallest statement
  change.
- The intended proof is explicit finite matrix arithmetic.

Please finish with a concise completion report:

- which targets were solved;
- whether any statement/API change was needed;
- any hidden assumptions or theorem-strength concerns;
- suggested next finite theorem, especially whether to proceed toward a
  normalized/bounded trace scalar, a canonical shared P2 API, or a carefully
  specified permutation-shift unitarity theorem.

## Metadata

```yaml
aristotle:
  project_id: d39e4d3a-b19e-4617-bb16-abe41aa5e130
  task_id: 843edce0-7b35-4ad2-9044-5f2268c5b7a2
  target_file: NullEdgeP2TwoReflectionTrace/Core.lean
  expected_module: NullEdgeP2TwoReflectionTrace
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-two-reflection-trace-20260624-project
  output_dir: AgentTasks/aristotle-output/d39e4d3a-b19e-4617-bb16-abe41aa5e130
  status: integrated
```

## Integration result

Integrated 2026-06-24 into:

- `PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace`
- `PhysicsSMDraft.lean`

The module proves the explicit trace formula for a product of two branch
reflections, symmetry of that two-reflection trace scalar, and the on-shell
self-composition trace `2`. This gives a finite non-parity scalar for
branch-reflection products without invoking spectral or continuum language.
