# Aristotle clean-room formalization: Gupta-Short stay certificate

## Objective

Connect the exact projector-factorized stay construction of Gupta and Short
(arXiv:2601.15885v3) to the repository's complete range-one Laurent unitarity
classification.

## Target

Audit and extend
`PhysicsSM/Draft/NullEdge/GuptaShortStayCertificate.lean`. The core bridge from
the previously landed factorized walk to the new ten-identity Laurent
classification is now locally proved, so do not re-prove or duplicate it.

First adversarially check that the bridge really allows noncommuting star
projections and that the rational witness is nonzero. Report any semantic
mismatch immediately.

Then add the highest-value missing theorem: derive the exact first derivative
of the factorized symbol along `z(t) = exp(-i t)` at the origin and express its
Hermitian tangent in projector data. Prove the sharp criterion under which that
tangent squares to the identity. The expected scientific conclusion is that a
genuine nonzero stay branch can evade the previous involutory-tangent no-go only
by making the effective speed operator non-involutory; prove or refute that
statement without weakening it.

## Stretch target

Connect the tangent criterion to the explicit rational noncommuting witness and
compute a nontrivial exact matrix entry showing that its tangent square differs
from the identity. Keep every scale and normalization explicit.

## Boundaries and provenance

This is a clean-room mathematical formalization from the equations in Gupta
and Short, not copied implementation code. Their 3+1 product family retains
isolated extra low-energy solutions, so this module must not claim that a
nonzero stay alone removes every 3+1 alias. Use no new assumptions or
compiler-trusted decision procedures.

## Aristotle metadata

```yaml
aristotle:
  project_id: daac1f2a-0bcc-4238-b8b7-74238185d1d2
  target_file: PhysicsSM/Draft/NullEdge/GuptaShortStayCertificate.lean
  expected_module: PhysicsSM.Draft.NullEdge.GuptaShortStayCertificate
  submission_project: AgentTasks/aristotle-submit/codex-gupta-short-stay-tangent-20260719-project
  output_dir: AgentTasks/aristotle-output/daac1f2a-0bcc-4238-b8b7-74238185d1d2
  status: submitted
  owner: Codex
```

Submitted on 2026-07-19 after the certificate bridge itself was proved and
checked locally; Aristotle is assigned the derivative and tangent-resource
extension.
