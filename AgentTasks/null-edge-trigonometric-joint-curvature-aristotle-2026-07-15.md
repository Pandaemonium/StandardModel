# Joint trigonometric holonomy curvature: Aristotle proof task

```yaml
aristotle:
  project_id: 271d988b-0121-4830-9cff-9afc481d48f1
  task_id: 2ba7b0cd-1bc3-44d3-a9ad-f26c25db9a9e
  target_file: AgentTasks/aristotle-targets/null_edge_trigonometric_joint_curvature_limit.lean
  expected_module: AgentTasks.aristotle-targets.null_edge_trigonometric_joint_curvature_limit
  submission_project: AgentTasks/aristotle-submit/null-edge-trigonometric-joint-curvature-20260715-project
  output_dir: AgentTasks/aristotle-output/271d988b-0121-4830-9cff-9afc481d48f1
  status: complete, harvested, and integrated 2026-07-15
```

## Objective

Prove or falsify the unrestricted joint two-parameter successor of the checked
iterated and diagonal curvature limits. The exact trigonometric group
commutator should satisfy

```text
(H(p,q)-I)/(p*q) -> G*A-A*G
```

as `(p,q)->(0,0)` through pairs with `p*q != 0`, for involutive generators.
Preserve the target statement unless an independent exact expansion or
counterexample shows that it is false.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-trigonometric-joint-curvature-20260715-20260715-025614.md
```

## Locked interpretation

1. Regulator order and orientation are fixed by the copied source. The target
   coefficient is `G*A-A*G`.
2. This theorem is strictly stronger than both the iterated theorem and the
   selected path `p=q=h`. Neither may be used as if it implied joint
   convergence.
3. The filter is the product-space neighborhood of `(0,0)` restricted to
   `p*q != 0`; no relation between the rates of `p` and `q` is allowed.
4. Both involution hypotheses should eliminate pure-axis terms exactly. Check
   whether the remaining numerator has an exact factor `sin(p)*sin(q)` or a
   uniform remainder of order `|p*q|*(|p|+|q|)`.
5. Hermiticity and unitarity are not required unless the analytic proof really
   needs them.
6. Even success remains a selected finite matrix family, not a graph-derived
   connection, calibrated area, or Riemann tensor.

## Required work

1. Run the narrow direct target check first.
2. Independently derive an exact two-variable noncommutative expansion or a
   uniform remainder estimate.
3. Complete the target with a kernel-checked proof without weakening its
   topology, domain, sign, coefficient, or hypotheses.
4. Check arbitrary unequal approach rates explicitly; include paths such as
   `q=p^2` and `p=q^2` in the semantic audit.
5. If false, return a concrete matrix/path counterexample and the strongest
   correct replacement statement. Do not silently fall back to diagonal or
   iterated convergence.
6. State the precise additional data required to sample the theorem along a
   graph refinement family and identify the limit with continuum curvature.

## Required report

Return command results, exact expansion or estimate, statement-preservation
verdict, assumptions and axioms, falsification attempts, completed target, and
a concise G4 remaining-obligations ledger. Report every proof hole.

## Submission record

- Submitted project: `271d988b-0121-4830-9cff-9afc481d48f1`.
- Submitted task: `2ba7b0cd-1bc3-44d3-a9ad-f26c25db9a9e`.
- Initial task state: `QUEUED`.
- Focused package contains the exact seven-file Lean dependency closure,
  task note, context pack, and Mathlib metadata; no `.lake` cache was
  submitted.

## Live checkpoint

- 2026-07-15: sent a `continue --mode ask --wait` request for the exact
  factorization or estimate, statement-preservation verdict, and remaining
  Lean goals. The local command timed out after three minutes without a reply;
  the original task remained `IN_PROGRESS`, so no instruction or duplicate
  submission was issued.
- While the submitted task continued, a local proof was completed and promoted
  to `TrigonometricHolonomyCurvatureLimit.lean`. It uses the exact factorization
  `H(p,q)-I=sin(p)*sin(q)*B(p,q)` and the continuous extension
  `sinc(p)*sinc(q)*B(p,q)`. The original filter, hypotheses, sign, coefficient,
  and unrestricted approach rates are preserved. Aristotle's independent
  result was then harvested and compared as recorded below.

## Harvest record

- Aristotle independently proved the unchanged unrestricted product-space
  theorem with the same exact factorization, sign `G*A-A*G`, coefficient one,
  and only the two involution hypotheses. Its analytic route uses direct
  punctured sine-ratio limits; the integrated live proof uses the continuous
  sinc extension. Both cover arbitrary unequal and sign-changing rates.
- No counterexample, hidden comparable-rate hypothesis, Hermiticity assumption,
  or statement weakening was introduced. The guarded axiom footprint is only
  `propext`, `Classical.choice`, and `Quot.sound`.
- The live module additionally records the full pre-involution expansion, a
  generic/live nonzero unitary packet, and sampling along every nonzero-product
  refinement sequence tending jointly to zero.
- Detailed report:
  `AgentTasks/aristotle-output/271d988b-0121-4830-9cff-9afc481d48f1/extracted/project-files.tar/null-edge-trigonometric-joint-curvature-20260715-project_aristotle/AgentTasks/aristotle-targets/null_edge_trigonometric_joint_curvature_limit_REPORT.md`.
- Aristotle summary:
  `AgentTasks/aristotle-output/271d988b-0121-4830-9cff-9afc481d48f1/extracted/project-files.tar/null-edge-trigonometric-joint-curvature-20260715-project_aristotle/ARISTOTLE_SUMMARY.md`.
