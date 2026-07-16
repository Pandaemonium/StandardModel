# Aristotle task: all-moving null dilation of conditioned shifts

```yaml
aristotle:
  project_id: 6f1114f3-e46c-4282-8c51-a81803ec62e1
  task_id: 740737f1-fa4c-4d5b-ba96-5da5f2f1cdbc
  target_file: NullDilationConditionedShift/Core.lean
  expected_module: NullDilationConditionedShift.Core
  submission_project: AgentTasks/aristotle-submit/afpl-null-dilation-conditioned-shift-20260713-project
  output_dir: AgentTasks/aristotle-output/6f1114f3-e46c-4282-8c51-a81803ec62e1
  status: integrated; project reused by antiperiodic successor
```

## Objective

Close the exact stationary-sector obstruction in the HNU real-space bridge by
dilating one coarse conditioned shift into two all-moving fine ticks on an
enlarged register. The selected projector sector moves twice in the physical
direction; the complement moves out and back along one compact auxiliary
direction. Prove that the coarse decoded update is exactly the original
move-plus-hold operation.

## Required theorem ladder

1. Prove microBack_microOut without weakening any projector hypotheses.
2. Prove symbol_dilation: the auxiliary phase cancels exactly while the
   physical phase squares.
3. Prove inner-product preservation of microOut; add and prove the analogous
   theorem for microBack if useful.
4. Add a finite nontrivial witness using cyclic physical and auxiliary
   registers in which both branches change site on each fine tick.
5. Add standard-axiom guards.

## Semantic boundary

This theorem would resolve the stationary branch algebraically by adding a
compact auxiliary direction. It does not prove that the auxiliary direction is
physical, that its edges are soldered with the required null length, that the
full depth-16 HNU schedule has winding one, or that a four-dimensional bulk
decodes to observed 3+1 spacetime. State these boundaries prominently.

No proof placeholders, compiled evaluation, new assumptions, or statement
weakening in the returned file.

Run first: lake env lean NullDilationConditionedShift/Core.lean

## 2026-07-13 harvest

Task `740737f1-fa4c-4d5b-ba96-5da5f2f1cdbc` completed. The immutable return is
stored under
`AgentTasks/aristotle-output/6f1114f3-e46c-4282-8c51-a81803ec62e1/completed-20260713/`.
The returned module proves the exact two-tick composition, symbol identity,
inner-product preservation for both ticks, and a nontrivial finite cyclic
witness with both branches moving. Aristotle also correctly repaired an
under-specified unitarity statement by adding the missing complementary
projector hypothesis `P + Q = 1`; without it, `P = Q = 0` is a counterexample.

Independent replay against the repository's pinned Mathlib passed:

`lake env lean AgentTasks/aristotle-output/6f1114f3-e46c-4282-8c51-a81803ec62e1/completed-20260713/afpl-null-dilation-conditioned-shift-20260713-project_aristotle/NullDilationConditionedShift/Core.lean`

This banks an exact dilation theorem only. The adversarial companion job shows
that the cyclic auxiliary zero-momentum block still has a held branch and that
the decoded two-tick endpoint is identically the original coarse shift, so the
dilation relocates rather than resolves the full 3+1 obstruction.

Interactive Claude/Opus approved both banking the exact theorem and closing the
untwisted out-and-back route as a 3+1 solution in
`AutonomousLab/reviews/CLAUDE_REVIEW_NullDilation_NoGo_ControlledSector_2026-07-13.md`.
The reviewed module is integrated at
`PhysicsSM/Draft/NullEdge/NullDilationConditionedShift.lean`, imported by
`PhysicsSMDraft.lean`, and pinned in the central overnight guard. Targeted build
and the central 8,487-job guard build pass. The Aristotle project is now reused
by successor task `75231ebb-9cc7-475e-940e-942b72b56bea`, which tests an
antiperiodic pi-holonomy escape rather than changing the accepted theorem.
