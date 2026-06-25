# Aristotle task: P2/P9 iterated reflection screen variance

Submitted: 2026-06-24.

## Scientific role

This task advances the `P2-R` / `P4-R` / `P7-R` operator bridge and the `P9-F`
finite source-visibility/noise lane.

The previous integrated bridge proves that one on-shell branch reflection
`R = H / E` preserves the real two-component fiber norm, the P9 screen second
moment, and the screen-cardinality variance bound when applied pointwise across
screen cells. This task upgrades that one-step theorem to finite repeated local
reflection steps:

```text
one reflection preserves the screen observable
-> any finite iterate preserves the screen observable
-> the screen variance bound is stable under any finite iterate.
```

This is a discrete stability theorem for the already-defined reflection
observable. It is not a null-step walk, shift operator, boundary condition,
continuum limit, or gravitational response law.

## Aristotle instructions

Please work on:

```text
NullEdgeP2P9ReflectionIterationVariance/Core.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeP2P9ReflectionIterationVariance/Core.lean
```

Primary targets:

```lean
branchReflection_preserves_vecNormSq_on_massShell
reflectAmp_preserves_screenFiberSecondMoment_on_massShell
iterated_reflectAmp_preserves_screenFiberSecondMoment_on_massShell
iterated_reflectAmp_screenFiberSecondMoment_le_card_mul_sigmaSq
```

Guardrails:

- Keep the carrier finite and real: `Fin 2 -> Real` fibers over screen cells.
- Preserve the on-shell hypotheses `h * h = 1`, `E != 0`, and
  `E ^ 2 = p ^ 2 + m ^ 2`.
- Use finite iteration only. Do not add shifts, walks, boundary conventions,
  complex phases, continuum assumptions, or gravitational response laws.
- Do not weaken the statements unless one is mathematically false; if a
  statement needs an extra hypothesis, explain exactly why.
- The intended proof is finite matrix/vector arithmetic plus induction on
  `k : Nat`.

Please finish with a concise completion report:

- which targets were solved;
- whether any statement/API change was needed;
- any hidden assumptions or theorem-strength concerns;
- suggested next finite theorem, especially whether to proceed toward a chiral
  projector split, a permutation-shift unitarity theorem with explicit
  boundary data, or a coarse-grained observer-channel theorem.

## Metadata

```yaml
aristotle:
  project_id: f309207c-299b-4093-a6fd-d32fc898a620
  task_id: 8386a631-b69a-4d33-afad-e1af4fe03eb2
  target_file: NullEdgeP2P9ReflectionIterationVariance/Core.lean
  expected_module: NullEdgeP2P9ReflectionIterationVariance
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-p9-reflection-iteration-variance-20260624-project
  output_dir: AgentTasks/aristotle-output/f309207c-299b-4093-a6fd-d32fc898a620
  status: integrated
```

## Integration result

Integrated 2026-06-24 into:

- `PhysicsSM.Draft.NullEdgeP2P9ReflectionIterationVariance`
- `PhysicsSMDraft.lean`

The module imports the one-step P2/P9 reflection-screen bridge and proves that
any finite iterate of the pointwise branch reflection preserves the screen
second moment. The screen-cardinality variance bound therefore remains stable
under any finite number of repeated local reflection steps.
