# Aristotle task: P2 closed four-trace reduction

Date: 2026-06-24.

## Purpose

Prove the closure-reduced ordered four-trace theorem for the P2 branch-reflection
trace ladder.

The previous closure theorem showed that four on-shell branch-coordinate vectors
which close have six-pair trace sum `-4`. The next non-empty theorem is stronger:
closure and unit normalization force opposite-pair trace coincidences, and the
ordered four-reflection trace reduces to a polynomial in two independent
pairwise trace channels.

This is still finite algebra, not a causal-diamond holonomy theorem. The value
is that a future one-diamond substitution map has a nontrivial closure-reduced
trace invariant to preserve.

## Model-call provenance

Context packet:

```text
AgentTasks/model-calls/context-packs/2026-06-24-round-024-context.md
```

Model-call records:

```text
AgentTasks/model-calls/gemini/2026-06-24-round-024-constructive-next-target.md
AgentTasks/model-calls/claude/2026-06-24-round-024-adversarial-next-target.md
```

Gemini suggested proving that the ordered four-trace is a polynomial in
Mandelstam-like channel invariants, but its sketch used undefined complex
objects and overclaimed holonomy. Claude sharpened the target: stay in the real
branch-coordinate API and prove a closure-reduced four-trace theorem that is
not already the general Mandelstam identity. Spark derived the exact finite
algebra: opposite-pair trace coincidences and a two-channel polynomial.

## Target

Standalone file:

```text
AgentTasks/aristotle-standalone/null-edge-p2-closed-four-trace-reduction-20260624/NullEdgeP2ClosedFourTraceReduction/Core.lean
```

Main declarations to prove:

```text
branchPairTrace_eq_coordPairTrace
coordPairTrace_opposite_pairs_eq_of_closed_unit
trace2_mul_four_branchReflections_mandelstam_ordered_closed_unit
trace2_mul_four_branchReflections_mandelstam_ordered_closed_unit_two_channel
```

Expected narrow check:

```text
lake env lean NullEdgeP2ClosedFourTraceReduction/Core.lean
```

Do not weaken theorem statements. Small helper lemmas in the same file are fine.
The intended proof route is finite algebra:

- use the branch-coordinate pair-trace formula to prove
  `branchPairTrace_eq_coordPairTrace`;
- prove opposite-pair equality from closure plus unit normalization;
- combine the general ordered four-trace Mandelstam theorem with opposite-pair
  equality to get the three-channel reduction;
- use the closure sum `s12 + s13 + s14 = -2` to eliminate `s14` and get the
  two-channel polynomial.

## Aristotle metadata

```yaml
aristotle:
  project_id: 5f8c5b00-c088-4a2c-b34b-092a1d4aca1c
  task_id: 70ea26fb-f43c-4db8-aa98-23d4771a097a
  target_file: AgentTasks/aristotle-standalone/null-edge-p2-closed-four-trace-reduction-20260624/NullEdgeP2ClosedFourTraceReduction/Core.lean
  expected_module: NullEdgeP2ClosedFourTraceReduction.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-closed-four-trace-reduction-20260624-project
  output_dir: AgentTasks/aristotle-output/5f8c5b00-c088-4a2c-b34b-092a1d4aca1c
  status: in_progress
```

## Local preflight

```text
lake env lean AgentTasks\aristotle-standalone\null-edge-p2-closed-four-trace-reduction-20260624\NullEdgeP2ClosedFourTraceReduction\Core.lean
```

Result: parses and checks with the four intended proof placeholders.

Submission-project preflight:

```text
lake exe cache get
lake env lean NullEdgeP2ClosedFourTraceReduction\Core.lean
```

Result: cache fetched successfully; target checks in the focused submission
project with the four intended proof placeholders.

## Submission

```text
aristotle submit --project-dir AgentTasks\aristotle-submit\null-edge-p2-closed-four-trace-reduction-20260624-project <prompt>
aristotle tasks 5f8c5b00-c088-4a2c-b34b-092a1d4aca1c --limit 10
```

Project `5f8c5b00-c088-4a2c-b34b-092a1d4aca1c`, task
`70ea26fb-f43c-4db8-aa98-23d4771a097a`, initial status `QUEUED`.

Follow-up status check:

```text
aristotle tasks 5f8c5b00-c088-4a2c-b34b-092a1d4aca1c --limit 10
```

Result: task status `IN_PROGRESS`.

## Requested completion report

Ask Aristotle to report:

- whether every theorem statement was unchanged;
- which helper lemmas, if any, were added;
- whether any proof placeholders or escape hatches remain;
- the exact verification command run;
- whether the two-channel polynomial follows from the stated closure/unit
  assumptions rather than an added hidden constraint;
- recommended next step after this closure-reduced four-trace theorem.
