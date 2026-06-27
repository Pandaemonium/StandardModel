# Aristotle C99b: finite graded-operator chiral-index benchmark

Integration status: returned remotely, not integrated locally.

Project ID: `309944d6-800a-4399-a2fc-3d294883ce28`
Task ID: `35587dfb-4bc1-4ac6-b5f6-83ebbdc1cf2b`
Reviewed: 2026-06-27

Reason:

- Aristotle reported the task complete and summarized a candidate module
  `PhysicsSM/Draft/NullEdgeFiniteGradedOperatorIndexTemplate.lean`.
- The local downloaded output did not contain the project-files archive or the
  candidate Lean file, so there was no faithful artifact to integrate.

Next action:

- Retry artifact download or resubmit as a narrow job if the graded-operator
  benchmark is still needed.

Dependency class: Independent.

Does not depend on:

- C99 return.
- C93 overlap/Ginsparg-Wilson interface.
- C92 ghost-safety API.
- C89 regulator/removal handle.
- C97 Boolean Wilson-release scaffold.

Hard dependencies:

- None. This should be self-contained finite Lean infrastructure.

Decision changed if this returns:

- Provides a benchmark finite graded-operator index substrate against which C99
  can be compared.
- If C99 returns too toy-like, C99b can become the fallback substrate.

## Background

C98 proved a planning guardrail:

```text
interface shape alone does not imply nonzero chiral index.
```

But C98 used a forgeable toy record with arbitrary count fields. C99 is already
running and asks for a finite operator-theoretic substrate. Claude's cycle-12
review recommended launching one small independent benchmark job so C99 can be
graded against a concrete artifact rather than prose alone.

## Requested target

Create:

```text
PhysicsSM/Draft/NullEdgeFiniteGradedOperatorIndexTemplate.lean
```

The module should be self-contained and finite. It should not try to prove C1
release or connect to the actual null-edge operator.

## Desired finite model

Use the simplest Lean-friendly finite model. A branch-table model is acceptable
if it has actual finite states, a grading involution, and an operator relation.
An explicit `Fin n` model is preferred.

Minimum concepts:

```lean
-- finite state space, e.g. Fin n
-- grading/involution Gamma or sign : state -> Bool / Int
-- finite operator relation or graph from states to states
-- kernel predicate derived from the operator relation
-- plus/minus kernel states derived from Gamma and kernel
-- index = #ker_plus - #ker_minus
```

The counts must be derived from finite states and predicates, not arbitrary
input fields.

## Compatibility requirement

The finite operator should be compatible with the grading by a real structural
condition. Accept either:

```text
strict anticommutation / sign flip:
  nonzero operator edges map plus states to minus states and minus states to plus states
```

or a clearly named finite analogue that is strong enough to stop plus/minus
sectors from being arbitrary labels.

Do not use a bare Boolean `hasInterfaceShape`.

## Required examples and theorems

Provide one common finite substrate datatype/framework and two instances:

1. zero-index model:

```text
interface/substrate shape holds
index = 0
not nonzero-index
```

2. nonzero-index model:

```text
interface/substrate shape holds
index != 0
```

The nonzero example should have an operator-theoretic mechanism, not merely a
hand-set grading that forces all kernel states to plus.

Theorems:

```lean
zero_index_blocks_nonzero_index
exists_shape_zero_index
exists_shape_nonzero_index
shape_does_not_imply_nonzero_index
```

Names may vary, but the meanings should be present.

## Explicit non-goals

Do not claim:

- Gate C1 release.
- ghost-zero safety.
- regulator-removal stability.
- overlap/Ginsparg-Wilson release.
- domain-wall release.
- anomaly cancellation.
- physical anti-vectorialization.

Do not import C97's `GaugeData` scaffold.

## Acceptance criteria

- Lean file compiles.
- No new `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, or
  `u n s a f e`.
- No `n a t i v e _ d e c i d e` unless explicitly labelled draft-only and not
  used for trusted index values.
- Module docstring states this is a finite benchmark/template, not C1 release.
- The index is computed from finite substrate data.
- Zero-index and nonzero-index examples share one common substrate
  datatype/framework.
- The grading is not spacetime `Gamma_s`, Furey `chi_E`, or cochain degree.
