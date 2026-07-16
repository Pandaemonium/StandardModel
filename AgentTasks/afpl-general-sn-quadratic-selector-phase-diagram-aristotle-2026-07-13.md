# Aristotle strategy-to-proof job: general Sn quadratic selector phase diagram

- Work item: `LAB-BOOTSTRAP-001`
- Role: Builder / Oracle / Assassin
- Priority: P94 decomposition-classification theorem
- Date: 2026-07-13

```yaml
aristotle:
  project_id: 80dae4ce-9dde-4dff-850a-c86b703be771
  submission_project: AgentTasks/aristotle-submit/afpl-general-sn-quadratic-selector-phase-diagram-20260713-project
  output_dir: AgentTasks/aristotle-output/80dae4ce-9dde-4dff-850a-c86b703be771
  status: submitted
```

## Mission

Generalize the completed three-channel quadratic-selector classification to an
arbitrary nonempty finite channel type. Prove that a fully permutation-natural
homogeneous quadratic cost has only a diagonal coefficient and an off-diagonal
coefficient, then classify its fixed-total selector by the sign of the
transverse coefficient.

## Required inputs

- `PhysicsSM/Draft/NullEdge/S3QuadraticSelectorClassification.lean`
- `PhysicsSM/Draft/NullEdge/S3SelectorPhaseDiagram.lean`
- relevant Mathlib finite-sum, permutation, and variance identities

## Preferred mathematical form

For a finite nonempty type `n`, define

```text
Q a d x = a * sum_i (x_i)^2 + 2*d * sum_{i<j} x_i*x_j.
```

On the affine fibre `sum_i x_i = s`, prove the identity

```text
Q a d x = (a-d) * sum_i (x_i)^2 + d*s^2.
```

Then prove:

1. if `d < a`, the unique minimizer is the uniform vector `x_i=s/card n`;
2. if `a = d`, the cost is constant on the fibre;
3. if `a < d` and the channel type has at least two elements, the cost is
   unbounded below along an explicit zero-total transverse ray.

If feasible, also prove the coefficient-classification statement from
invariance under every permutation for a general symmetric coefficient matrix.
If that representation-theoretic step is too large, return it as one exact
missing lemma while completing the phase diagram for the explicit two-parameter
family.

## Controls and honesty gates

- Handle `card n = 0` and `card n = 1` explicitly rather than dividing by zero
  or claiming an instability direction that cannot exist.
- The unboundedness result must hold for every real threshold, not merely give
  one lower-cost vector.
- Do not infer that permutation symmetry selects this quadratic family from
  physics or information theory.
- Do not call the uniform selector an observed equal-mass or equal-channel law.
- Use no trust-expanding declarations or evaluator shortcuts.

## Required output

Return a concise strategy memo and a typechecking Lean module. Prefer a completed
general theorem; otherwise prove the strongest nontrivial rung and isolate one
precise remaining API or classification lemma. Report exact imports and replay
commands.
