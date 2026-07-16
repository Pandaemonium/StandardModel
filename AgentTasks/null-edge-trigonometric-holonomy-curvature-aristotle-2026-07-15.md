# Trigonometric holonomy curvature: Aristotle proof and semantic audit

```yaml
aristotle:
  project_id: 2a2b0773-3428-4a29-a11f-e2076212ac15
  task_id: e2b55b5f-f28c-4653-b7a1-cc8b9083dfd6
  target_file: AgentTasks/aristotle-targets/null_edge_trigonometric_diagonal_curvature_limit.lean
  expected_module: AgentTasks.aristotle-targets.null_edge_trigonometric_diagonal_curvature_limit
  submission_project: AgentTasks/aristotle-submit/null-edge-trigonometric-holonomy-curvature-20260715-project
  output_dir: AgentTasks/aristotle-output/2a2b0773-3428-4a29-a11f-e2076212ac15
  status: complete, harvested, and integrated 2026-07-15
```

## Objective

Audit the checked iterated curvature-limit module and prove its synchronized
diagonal successor. The exact trigonometric group commutator should satisfy

```text
(H(h,h) - I) / h^2 -> G*A - A*G
```

for involutive generators. Preserve the target statement unless an independent
calculation shows a sign, coefficient, hypothesis, or topology defect.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-trigonometric-holonomy-curvature-20260715-20260715-013051.md
```

## Locked interpretation

1. `trigRegulator A G (p,q)` is ordered as in the copied source. Its existing
   mixed derivative is `G*A-A*G`, not `[A,G]` under the opposite sign
   convention.
2. The diagonal target is stronger than the checked iterated limit. The latter
   alone does not justify synchronizing `p=q=h`; a real second-order estimate,
   Taylor theorem, or exact trigonometric expansion is required.
3. Check the factor of two carefully: the diagonal second derivative contains
   two mixed terms, while the second-order Taylor coefficient carries `1/2`.
4. Both involution hypotheses are load-bearing because they cancel pure `p^2`
   and `q^2` terms. Produce a counterexample shape or expansion when either is
   dropped.
5. Hermiticity is needed for the existing finite-unitarity theorem but should
   not be added to the diagonal analytic limit unless the proof genuinely
   requires it.
6. The limit uses the punctured real neighborhood of zero and the matrix
   product topology represented by the local finite-dimensional normed
   instances.
7. Even a successful diagonal theorem remains a selected two-parameter matrix
   family, not a graph-derived connection or continuum Riemann tensor.

## Required work

1. Run
   `lake build AgentTasks.aristotle-targets.null_edge_trigonometric_diagonal_curvature_limit`
   or the narrow equivalent supported by the focused package.
2. Independently expand the ordered regulator through second order and confirm
   the sign and coefficient.
3. Replace the proof handoff in the target with a complete kernel-checked proof.
4. Audit every declaration in
   `PhysicsSM/Draft/NullEdge/TrigonometricHolonomyCurvatureLimit.lean`, including
   the distinction between the iterated theorem and the requested diagonal
   theorem.
5. If the target is false, do not weaken it silently. Return the exact corrected
   statement, counterexample or expansion, and minimal additional hypothesis.
6. State the next theorem needed for a genuine two-variable uniform limit and
   for composition with a graph refinement sequence.

## Required report

Return command results, assumption footprints, independent expansion,
statement-preservation verdict, falsification attempts, completed target file,
and a concise G4 ledger. Report any remaining proof holes and every assumption
used.

## Submission record

- Submitted project: `2a2b0773-3428-4a29-a11f-e2076212ac15`.
- Submitted task: `e2b55b5f-f28c-4653-b7a1-cc8b9083dfd6`.
- Initial state: task `QUEUED`.
- The complete live iterated-limit module passed direct Lean and its targeted
  Lake build. The separate diagonal target statement also elaborated under the
  pinned toolchain and contains the documented proof handoff Aristotle is asked
  to close.
- The focused package contains the six-file project dependency closure, the
  target, task note, and semantic context pack. It was submitted without a
  temporary `.lake` cache to avoid archiving a fresh full Mathlib rebuild.

## Harvest record

- A live `--mode ask` status query confirmed that the original diagonal
  statement was proved unchanged, with sign `G*A-A*G`, coefficient one, and
  only the standard three axioms. Aristotle explained that omitting the
  involutions leaves the pure correction `(A*A-1)+(G*G-1)`.
- The returned exact diagonal expansion, involutive cancellation lemma,
  synchronized limit, and live nonzero unitary packet were integrated into
  `PhysicsSM/Draft/NullEdge/TrigonometricHolonomyCurvatureLimit.lean`.
- The existing iterated theorem and generic refinement-sampling lemma were
  retained. Returned edits that removed them or weakened build-enforced axiom
  guards were not applied.
- Full report:
  `AgentTasks/aristotle-output/2a2b0773-3428-4a29-a11f-e2076212ac15/null-edge-trigonometric-holonomy-curvature-report-2026-07-15.md`.
- Aristotle summary:
  `AgentTasks/aristotle-output/2a2b0773-3428-4a29-a11f-e2076212ac15/ARISTOTLE_SUMMARY.md`.
