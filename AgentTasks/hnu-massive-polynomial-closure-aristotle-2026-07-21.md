# Aristotle task: close the live massive HNU polynomial-cost ladder

Date: 2026-07-21
Owner: Codex
Work item: `QCA-3PLUS1-001`
Status: locally complete; Aristotle retained for independent comparison

## Local progress after submission

While the task remained in proof search, Codex independently closed the two
purely algebraic composition targets without changing their statements:

- `orderedExpProduct_dirac_map`, using the reindexed block-diagonal ring map
  and cancellation of the fixed unitary basis change;
- `massiveKinetic_product_exact`, by composing the exact two-component HNU
  exponential word, the `q -> -q` generator identity, and the doubled live
  endpoint.

Codex then closed `massiveOrderedGenerators_norm_sum_le` by proving that the
fixed Dirac-basis lift preserves the L2 operator norm, reducing the kinetic
sum to `hnuEightGenerators_norm_sum`, and using the exact `norm_mass4` theorem.
That norm envelope now feeds the generic skew-Hermitian ordered-product theorem
to prove `massive_one_step_polynomial_bound` for the actual `massiveWend` and
`massiveEflow`. The direct Lean check passes with four remaining proof
handoffs, exactly targets 5--8 below. At harvest, compare returned proofs for
targets 1--4 rather than overwriting the locally checked versions mechanically.

Codex subsequently closed targets 5--8 without statement changes. The module
is now hole-free: the exact unitary power telescope and exact-flow group law
give the fixed-time `O(1/n)` estimate; monotonicity gives the compact envelope;
the generic polynomial schedule gives the `1/(N+1)` rate; and the final ceiling
arithmetic gives the displayed cubic changing-window cost. Verification passed:

```text
lake env lean PhysicsSM/Draft/NullEdge/HNUMassivePolynomialAdaptiveCost.lean
lake build PhysicsSM.Draft.NullEdge.HNUMassivePolynomialAdaptiveCost
lake env lean PhysicsSM/Draft/NullEdge/HNUMassivePolynomialAdaptiveCostAxiomGuard.lean
```

The dedicated guard pins the one-step, many-step, schedule, cubic-cost, and
nondegenerate-control theorems to `propext`, `Classical.choice`, and
`Quot.sound`. The aggregate `OvernightTheoryAxiomGuard` build passed all 8,513
jobs after importing that dedicated guard. The root `lake build PhysicsSM`
then passed all 8,571 jobs. Opus has an independent
semantic-audit request in its mailbox. The Aristotle job should now be
harvested as an adversarial proof comparison, not applied mechanically.

## Objective

Eliminate every proof handoff in
`PhysicsSM/Draft/NullEdge/HNUMassivePolynomialAdaptiveCost.lean`.  The target
must remain the actual live four-component walk `massiveWend` and exact flow
`massiveEflow`.

The former matrix-exponential blocker is now solved in
`MC2BlockExponentialLift.lean`.  The target also contains the returned exact
live generator list, its skew-Hermitian proof, its sum identity, and the exact
mass-plus-kinetic product connector conditional only on the remaining kinetic
product lemma.

Semantic context:
`AgentTasks/context-packs/hnu-massive-polynomial-closure-20260721-20260721-102324.md`.

## Exact remaining targets

1. `orderedExpProduct_dirac_map`
2. `massiveKinetic_product_exact`
3. `massiveOrderedGenerators_norm_sum_le`
4. `massive_one_step_polynomial_bound`
5. `massive_many_step_polynomial_bound`
6. `massive_compact_envelope_bound`
7. `massive_schedule_error`
8. `massivePolynomialSteps_changing_window_cubic`

Run this narrow check first:

```text
lake env lean PhysicsSM/Draft/NullEdge/HNUMassivePolynomialAdaptiveCost.lean
```

## Required proof architecture

- Use `MC2Exp.exp_MC2_blockDiag` and
  `MC2Exp.exp_unitary_conjugation`; do not reopen the matrix-exponential proof.
- Telescope the fixed `diracBasis` conjugations in
  `orderedExpProduct_dirac_map` and keep the two chiral ordered words.
- Rewrite the negative generator list with `hnuEightGenerators_neg`, then use
  `liveWend_eq_hnuEndpoint` and `blockDiag_Wend_eq_doubled`.
- Apply `HNUPolynomialAdaptiveCost.skewHermitian_ordered_product_bound` to the
  exact live list.  Rewrite the list sum with
  `massiveOrderedGenerators_sum` and the product with
  `massiveOrdered_product_exact`.
- Use exact unitarity and the landed power telescope for the many-step result.
- Finish the last three declarations by monotonicity and real arithmetic,
  preserving the displayed coefficient and schedule.

## Semantic and honesty gates

- Do not change or weaken any theorem statement.
- Do not prove a parallel standalone product and call the target complete.
- Do not use the coarse universal unitary-distance bound `2`; an earlier run
  showed that route loses the exact `q = 0` cancellation and cannot prove the
  stated small-mass coefficient.
- Do not add assumptions, new escape-hatch declarations, or compiler-trusted
  finite evaluation.
- The result is a fixed-time approximation-cost theorem.  It is not a physical
  clock hierarchy, an interacting-QFT theorem, or a derivation of mass scales.
- If a statement is false, return an exact counterexample rather than altering
  it.

## Completion report

Report solved targets, any statement changes (expected: none), remaining proof
handoffs (expected: none), build command, and the axiom footprint of
`massive_one_step_polynomial_bound`, `massive_schedule_error`, and
`massive_polynomial_control_nonzero`.

```yaml
aristotle:
  project_id: 7f197b23-b63d-48c0-83e7-8d746f0db0a0
  task_id: 8d72fc7d-b853-423e-bff7-1e99ded3b830
  target_file: PhysicsSM/Draft/NullEdge/HNUMassivePolynomialAdaptiveCost.lean
  expected_module: PhysicsSM.Draft.NullEdge.HNUMassivePolynomialAdaptiveCost
  submission_project: AgentTasks/aristotle-submit/hnu-massive-polynomial-closure-20260721-project
  output_dir: AgentTasks/aristotle-output/7f197b23-b63d-48c0-83e7-8d746f0db0a0
  status: submitted
```
