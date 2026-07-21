# Aristotle task: live massive HNU polynomial adaptive cost

Date: 2026-07-21
Owner: Codex
Work item: `QCA-3PLUS1-001`
Status: running; exact-factorization route reinforced

## Objective

Compose the landed skew-Hermitian product-formula bound with the actual doubled
HNU endpoint, Dirac-basis conjugation, and exact Pluecker mass exponential.
Derive a polynomial one-step constant, telescope it, and prove the compact
changing-window schedule for `massiveWend` itself.

## Non-negotiable semantic gate

A theorem for a parallel standalone word is insufficient. The capstone must
mention the live `HNUMassiveContinuumReduction.massiveWend` and
`massiveEflow`. If exact live identification cannot be proved, the job must
return the missing equality or a counterexample rather than claim completion.

Semantic context:
`AgentTasks/context-packs/hnu-massive-polynomial-adaptive-cost-20260721-20260721-052957.md`.

```yaml
aristotle:
  project_id: ffc13bb3-0136-4769-92e7-52680bef9f23
  task_id: 60be3b29-860e-4b50-b925-5932ecadf127
  target_file: PhysicsSM/Draft/NullEdge/HNUMassivePolynomialAdaptiveCost.lean
  expected_module: project-native live massive HNU polynomial-cost composition
  submission_project: AgentTasks/aristotle-submit/hnu-massive-polynomial-adaptive-cost-20260721-project
  output_dir: AgentTasks/aristotle-output/ffc13bb3-0136-4769-92e7-52680bef9f23
  status: submitted
```

## Trust state

The target is draft handoff code with five explicit proof placeholders. It is
not root-imported and no theorem in it is currently landed.

## Live proof-search audit

At approximately 06:20 PDT, Aristotle explored a split into small and large
`eps` and attempted to absorb the universal unitary distance bound `2` into the
quadratic coefficient. The resulting scalar bound is false for small nonzero
mass. This does not refute the target theorem: at `q = 0`, the live mass coin is
the exact mass flow and the actual error is zero, while the coarse `2` bound has
discarded that cancellation.

An `instruct` continuation redirected the task to the only accepted route:
construct an exact four-component ordered exponential word for `massiveWend`,
using `liveWend_eq_hnuEndpoint`, `massCoin4_eq_exp_mass4`, doubled HNU block
generators, and `diracBasis` conjugation. The required generator list must be
skew-Hermitian, sum to the live massive generator, and have norm sum at most
`2 * qAbs q + norm z`. If Mathlib blocks the final assembly, the job must retain
the exact factorization/sum/norm lemmas and report that API blocker. The false
coarse scalar estimate is not an admissible substitute or no-go result.
