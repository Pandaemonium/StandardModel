# Aristotle task: P2/P9 reflection screen variance bridge

Submitted: 2026-06-24.

## Scientific role

This task advances the `P2-R` / `P4-R` / `P7-R` operator bridge and the `P9-F`
finite source-visibility/noise lane at the same time.

The current P2 branch has a finite reflection operator

```text
R = P+ - P- = H / E
```

for the two-level chiral Hamiltonian. The current P9 branch has a finite
screen-supported second-moment bound. The bridge target says that applying the
P2 reflection pointwise to each two-component screen-cell amplitude preserves
the fiber norm and therefore preserves the P9 screen second moment. The
screen-cardinality variance bound then transfers unchanged to the reflected
source.

This is deliberately smaller than a null-step walk unitarity theorem. It does
not introduce a shift operator, boundary condition, lattice geometry, continuum
limit, or gravitational response law.

## Aristotle instructions

Please work on:

```text
NullEdgeP2P9ReflectionScreenVariance/Core.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeP2P9ReflectionScreenVariance/Core.lean
```

Primary targets:

```lean
branchReflection_preserves_vecNormSq_on_massShell
branchReflection_preserves_screenFiberSecondMoment_on_massShell
reflected_screenFiberSecondMoment_le_card_mul_sigmaSq
```

Guardrails:

- Keep the carrier finite and real: `Fin 2 -> Real` fibers over screen cells.
- Preserve the on-shell hypotheses `h * h = 1`, `E != 0`, and
  `E ^ 2 = p ^ 2 + m ^ 2`.
- Do not add a shift/walk operator, complex Hilbert-space API, boundary
  convention, continuum assumption, or gravitational response law.
- Do not weaken the statements unless one is mathematically false; if a
  statement needs an extra hypothesis, explain exactly why.
- The intended proof is finite matrix/vector arithmetic: the reflection is
  norm-preserving on shell, so finite screen sums are preserved.

Please finish with a concise completion report:

- which targets were solved;
- whether any statement/API change was needed;
- any hidden assumptions or theorem-strength concerns;
- suggested next finite theorem, especially whether the next step should be a
  chiral projector split, a permutation-shift unitarity theorem, or a
  coarse-grained observer-channel theorem.

## Metadata

```yaml
aristotle:
  project_id: d1308930-487a-4cf7-90f6-2598328da23c
  task_id: 79bdfb2b-f740-4dca-82a9-5de5169f0cb2
  target_file: NullEdgeP2P9ReflectionScreenVariance/Core.lean
  expected_module: NullEdgeP2P9ReflectionScreenVariance
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-p9-reflection-screen-variance-20260624-project
  output_dir: AgentTasks/aristotle-output/d1308930-487a-4cf7-90f6-2598328da23c
  status: integrated
```

## Integration result

Integrated 2026-06-24 into:

- `PhysicsSM.Draft.NullEdgeP2P9ReflectionScreenVariance`
- `PhysicsSMDraft.lean`

The module proves that the scalar branch reflection preserves the real
two-component fiber norm on shell, preserves the finite screen second moment
when applied pointwise across a screen, and transfers the screen-cardinality
variance bound to reflected amplitudes. This composes the P2 branch-reflection
operator with the P9 screen-variance observable without introducing a shift
operator or continuum walk.
