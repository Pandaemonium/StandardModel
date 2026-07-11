# Aristotle proof task: quantitative 3D Sobolev tail rate

Prove every theorem in `SobolevTailRate/Main.lean` without changing statements.
This is Paper D's quantitative successor to the landed qualitative
`ChangingModeEmbedding` theorem.

Requirements:

- preserve the literal `[-N,N]^3` boxes and max-coordinate radius;
- preserve the exact inverse `(N+2)^s` rate and arbitrary natural regularity
  exponent;
- use the displayed weighted summability hypothesis, without compact-support
  substitution;
- retain the exact just-outside-boundary delta control;
- no compiler-trusting shortcut, new assumption, or weakening.

If the exact rate is false, return the smallest explicit counterexample and the
correct sharp constant.  If a later theorem blocks, return the largest
proof-complete prefix.

Boundary: even success is a quantitative `Z^3` coefficient-tail theorem.  It
does not supply Shannon interpolation, a lattice-spacing map, or Dirac PDE
convergence.

```yaml
aristotle:
  project_id: a827ab8e-13c7-48ba-8c4e-c7d2b26a7223
  target_file: SobolevTailRate/Main.lean
  expected_module: SobolevTailRate.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-sobolev-tail-rate-20260710-project
  output_dir: AgentTasks/aristotle-output/a827ab8e-13c7-48ba-8c4e-c7d2b26a7223
  status: snapshot-integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Codex disposition

The in-progress snapshot contained proofs of all six requested statements with
no statement changes and no remaining proof holes. Codex extracted the exact
target through a short path, compared it against the submitted source, and
independently compiled it against the live project. The proofs were integrated
as `PhysicsSM/Draft/NullEdge/SobolevTailRate.lean`, with module-level and
consolidated axiom guards.

Boundary retained: this is an explicit quantitative `Z^3` coefficient-tail
rate. It is not scaled Shannon interpolation, a changing physical lattice, an
operator-conjugacy theorem, or position-space Dirac PDE convergence.
