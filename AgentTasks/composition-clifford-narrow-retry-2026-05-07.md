# Composition Clifford narrow retry - 2026-05-07

Status: completed and integrated 2026-05-07.

Purpose: replace the stalled broad Aristotle job
`94a4869e-98b9-4ce5-b465-a56efa802baf` with two smaller jobs. The stalled job
was N4 from `hamming-e8-next-wave-after-integration-2026-05-07.md`: it asked
for a new `CompositionClifford.lean` layer above `EuclideanCompAlg`, including
real/imaginary parts and possibly a norm-form identity or Clifford relation.

The narrower split is intentional. The current `EuclideanCompAlg` record
contains norm multiplicativity and positivity, but it does not obviously
contain enough conjugation axioms to derive the norm-form identity
`x * star x = normSq x • 1`. These retries ask Aristotle to make that missing
hypothesis explicit rather than pretending it follows from the weaker record.

Submission project:

```text
AgentTasks/aristotle-submit/composition-clifford-retry-20260507-project
```

## Submitted jobs

| Job | Output directory | Aristotle ID | Status |
|-----|------------------|--------------|--------|
| C1: norm-form mixin and real/imaginary API | `AgentTasks/aristotle-output/composition-clifford-normform-api` | `baf9b756-bf01-4b05-989a-23f0fadaa6cd` | complete; integrated |
| C2: first Clifford relation under norm-form hypotheses | `AgentTasks/aristotle-output/composition-clifford-first-relation` | `fcf70fd4-520c-4484-8d49-d3a68381e949` | complete; integrated |

Integration note:

- Claude merged the best of both jobs into
  `PhysicsSM/Algebra/Division/CompositionClifford.lean`.
- The integrated file defines `NormFormCompAlg`, `rePartOf`, `imPartOf`,
  `IsPureImaginary`, projection/star compatibility lemmas, and the
  pure-imaginary Clifford-type square relation `pureIm_sq`.

## Shared constraints

- Lean toolchain: `leanprover/lean4:v4.28.0`.
- Trusted files must contain no `sorry`, `admit`, `axiom`, `opaque`, or
  `unsafe`.
- Do not prove or claim Hurwitz classification.
- Do not weaken `EuclideanCompAlg`; add a successor mixin if more structure is
  needed.
- Prefer verbose comments explaining exactly which hypotheses are mathematical
  structure rather than consequences of the existing record.
- Run `lake env lean PhysicsSM/Algebra/Division/CompositionClifford.lean`
  before returning.

## C1: norm-form mixin and real/imaginary API

Write scope:

- `PhysicsSM/Algebra/Division/CompositionClifford.lean`.
- Optional import update in `PhysicsSM.lean` only if the new trusted file
  compiles.

Goal:

Create a small trusted successor layer above `EuclideanCompAlg` that exposes
the missing norm-form/conjugation hypotheses needed for Clifford-style
arguments.

Target declarations:

- `NormFormCompAlg`, a successor mixin extending or assuming
  `EuclideanCompAlg A`, with an explicit norm-form axiom stating that
  `x * star x` is the scalar multiple of `1` determined by
  `EuclideanCompAlg.normSq x`.
- `rePartOf`.
- `imPartOf`.
- `IsPureImaginary`.
- Basic simplification lemmas for `rePartOf`, `imPartOf`, `star (rePartOf x)`,
  `star (imPartOf x)`, and the decomposition `rePartOf x + imPartOf x = x`.

Important typing note:

Inspect the available scalar/ring typeclasses before choosing the exact
statement of the norm-form axiom. If `normSq x • 1` is not well typed under the
existing assumptions, add the minimal semantically correct typeclass
assumption, such as `SMul ℝ A`, `Algebra ℝ A`, or a local scalar-to-unit field
inside `NormFormCompAlg`. Document the choice.

Minimum useful result:

- A sorry-free file containing the stronger interface and real/imaginary API,
  with comments explaining why the norm-form axiom is an added hypothesis.

## C2: first Clifford relation under norm-form hypotheses

Write scope:

- `PhysicsSM/Algebra/Division/CompositionClifford.lean`.
- If C1 has not landed, Aristotle may create the C1 declarations first, but
  should keep the proof surface small.

Goal:

Prove the first reusable Clifford-style algebra identity under the
`NormFormCompAlg` hypotheses, without claiming the full Clifford algebra
universal property or Hurwitz classification.

Target declarations:

- A theorem for arbitrary `x` expressing the quadratic relation derived from
  the decomposition into real and imaginary parts, if this is cleanly
  typeable.
- A theorem for pure imaginary `x`, ideally of the form
  `x * x = - EuclideanCompAlg.normSq x • 1` or the closest semantically
  correct statement under the chosen scalar conventions.
- Helper lemmas are welcome if they clarify star behavior or the use of the
  norm-form axiom.

Important mathematical boundary:

This job should not attempt to build a full `CliffordAlgebra` instance unless
that is unexpectedly easy. The target is the first concrete relation that a
future Clifford-algebra construction will use.

Minimum useful result:

- A sorry-free theorem showing that the explicitly strengthened norm-form
  hypotheses imply a Clifford-type square relation for pure imaginary
  elements.
