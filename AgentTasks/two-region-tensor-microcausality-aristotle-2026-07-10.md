# Aristotle target: two-region tensor microcausality

Prove every theorem in `FiniteLocalNet/Core.lean` without changing definitions
or statements. Run:

```text
lake env lean FiniteLocalNet/Core.lean
```

Use Mathlib's algebraic tensor product. Prove that the ranges of `includeLeft`
and `includeRight` commute elementwise, are isotone into the joint algebra, and
jointly generate the full tensor-product algebra. Close the two-qubit witness:
the left regional algebra remains genuinely noncommutative because its embedded
Pauli `X` and `Z` do not commute, even though every left observable commutes
with every separated right observable.

This is the first exact finite AQFT-style locality rung. It is a two-region
tensor-factor model, not a spacetime-indexed Haag-Kastler net, continuum QFT, or
proof that graph separation implies tensor factorization.

Context pack:
`AgentTasks/context-packs/two-region-tensor-microcausality-20260710-20260709-221508.md`.

```yaml
aristotle:
  project_id: 13b40077-16df-4e15-b662-37a84ac51edb
  target_file: FiniteLocalNet/Core.lean
  expected_module: PhysicsSM.Draft.NullEdge.TwoRegionTensorMicrocausality
  submission_project: AgentTasks/aristotle-submit/codex-two-region-tensor-microcausality-20260710-project
  output_dir: AgentTasks/aristotle-output/13b40077-16df-4e15-b662-37a84ac51edb
  status: submitted
```
