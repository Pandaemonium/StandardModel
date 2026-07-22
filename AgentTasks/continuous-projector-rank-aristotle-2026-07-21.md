# Continuous projector rank Aristotle task

## Objective

Prove the generic finite-dimensional bridge needed for the HNU Cayley band
selector: a continuous family of four-by-four complex idempotents has constant
rank.  The target is deliberately independent of the full PhysicsSM import
graph so Aristotle can spend its budget on Mathlib proof search.

## Mathematical route

1. Prove that an idempotent complex matrix has trace equal to its natural-number
   rank cast to `Complex`.
2. Compose matrix trace with the continuous family.
3. Use connectedness of `Real` and discreteness/integrality of the trace to
   prove constancy.
4. Deduce the rank-two specialization from the base point.

Equivalent routes through the characteristic polynomial, direct-sum
decomposition into range and kernel, or local invertible minors are acceptable.
The theorem statements must not be weakened.

## Physics use and boundary

The theorem will support a global rank-two statement for the exact finite HNU
negative-sign Cayley projector after separate proofs of projector continuity and
the rank-two rest value.  It does not prove those HNU-specific premises, select
the occupied physical sector, remove companion sectors, or establish locality.

## Verification request

Semantic context pack:
`AgentTasks/context-packs/continuous-projector-rank-20260721-20260721-144000.md`.

Run the narrow target first:

```text
lake env lean ContinuousProjectorRank/Main.lean
```

Return a short completion report listing solved targets, any statement changes,
remaining proof handoffs, and the declarations used.  Do not add assumptions or
escape hatches.

## Aristotle metadata

```yaml
aristotle:
  project_id: bc2ac81f-4551-4b7e-8fa3-5af08f080d54
  task_id: 9ab5b254-c8b1-47b1-a6ea-a03f54e40eab
  target_file: AgentTasks/aristotle-standalone/continuous-projector-rank-20260721/ContinuousProjectorRank/Main.lean
  expected_module: ContinuousProjectorRank.Main
  submission_project: AgentTasks/aristotle-submit/continuous-projector-rank-20260721-project
  output_dir: AgentTasks/aristotle-output/bc2ac81f-4551-4b7e-8fa3-5af08f080d54
  status: integrated
```

## Harvest and integration - 2026-07-21

Aristotle returned task `9ab5b254-c8b1-47b1-a6ea-a03f54e40eab` as
`COMPLETE_WITH_ERRORS`, but the downloadable artifact was complete and
hole-free.  The reported error was project-level verification state, not a
proof failure.  The returned `ContinuousProjectorRank/Main.lean` passed a local
`lake env lean` check unchanged.

All three requested statements landed in
`PhysicsSM/Draft/NullEdge/ContinuousProjectorRank.lean`, with a dedicated
build-enforced axiom guard.  The result is a generic path theorem only: applying
it to the HNU band still requires a continuous projector-valued selection and a
verified rank-two base point.
