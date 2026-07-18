# Aristotle job: conditional marked-shell inertia

Date: 2026-07-16  
Work item: `GRAV-ORDER-OPERATOR-001`  
Status: integrated

Semantic context pack:
`AgentTasks/context-packs/marked-shell-conditional-inertia-20260716-20260716-212144.md`
(SHA-256 `4EC0F80D66EC3457169905FBA273B843BF3A59D7144C3ADEBCA0844886777DF0`).

## Objective

Prove the exact algebraic `(+---)` split behind the marked-Alexandrov selector.
A nonzero time probe supported on positive weights must have positive corrected
norm. A difference-coordinate independent spatial triple supported on one
constant negative shell must be negative definite. Disjoint supports must make
the time-space cross block exactly zero.

## Exact target

`AgentTasks/aristotle-standalone/marked-shell-conditional-inertia-20260716/MarkedShellConditionalInertia/Core.lean`

Preserve every public definition and theorem statement. Small private helpers
are welcome. The theorem intentionally assumes support, weight signs, and
difference-coordinate independence. Do not replace those hypotheses by a
supplied Gram matrix, weaken strict signs to non-strict signs, or assume the
conclusion. If a target is false, return the minimal counterexample and
corrected statement.

## Proof idea

Expand the weighted difference form. Disjoint support makes every cross-term
summand zero. Positive weights and one nonzero time coordinate make the time
sum strictly positive. On the shell, the spatial quadratic form is minus the
positive scale times a finite sum of squares; difference-coordinate
independence supplies a nonzero square for every nonzero coefficient vector.

## Scope boundary

This job is conditional finite algebra. It does not construct the time probe,
select the shell projector, prove a spectral gap, show availability or
typicality, establish overlap transport, or recover a continuum tetrad,
curvature, Einstein equation, or general relativity.

## Preflight

`lake env lean` accepts the focused source under the pinned toolchain with
exactly five intended proof-hole warnings and no errors. Source SHA-256:
`B6CCFC4A206724D3A0484A80F484D5659F2274694A2F6CBBAACF81FB7A96B68D`.
The changed-document semantic-index refresh exceeded its three-minute bound;
the context pack therefore uses the last complete index plus the verbatim
focused source. No theorem statement was changed because of that timeout.

## Submission metadata

```yaml
aristotle:
  project_id: 868e1d04-83f0-4ffc-8f54-e68dad67d13a
  task_id: ff19ea86-b91c-40b9-b828-6e7a5c41ecef
  target_file: MarkedShellConditionalInertia/Core.lean
  expected_module: MarkedShellConditionalInertia.Core
  source_root: AgentTasks/aristotle-standalone/marked-shell-conditional-inertia-20260716
  submission_project: AgentTasks/aristotle-submit/marked-shell-conditional-inertia-20260716-project
  integration_target: PhysicsSM/Draft/NullEdge/MarkedAlexandrovShellInertia.lean
  output_dir: AgentTasks/aristotle-output/868e1d04-83f0-4ffc-8f54-e68dad67d13a
  status: integrated
```

Submitted as a focused Mathlib package. Aristotle reported the project as
created and the task as `QUEUED`; no wait loop was started.

## Integration

The completed candidate preserved all five public statements and contained no
proof holes. It replayed locally under the pinned toolchain. The proofs were
adapted to the project `weightedDifferenceForm` and combined with the generic
project-local layer-weight identities in
`PhysicsSM/Draft/NullEdge/MarkedAlexandrovShellInertia.lean`. The production
capstone states the conditional split directly for
`correctedPairingAt (projectLocal4DOperator C ell)`.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdge/MarkedAlexandrovShellInertia.lean
lake build PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellInertia
```

Both passed. The production headline guards report only `propext`,
`Classical.choice`, and `Quot.sound`.
