# Claude call: round 024 adversarial next target

Date: 2026-06-24.

## Metadata

```text
provider: Claude
model_requested: opus
model_used: opus
role: adversarial review of next target
exit_status: 0
context_pack: AgentTasks/model-calls/context-packs/2026-06-24-round-024-context.md
```

## Prompt

The prompt sent was the full contents of
`AgentTasks/model-calls/context-packs/2026-06-24-round-024-context.md`,
followed by a summary of Gemini's recommendation and:

```text
Adversarial task:
Attack Gemini's proposed holonomy/Mandelstam-polynomial job. Is it stageable now, duplicated by existing theorems, or overclaiming geometry? Recommend exactly one next Aristotle job. If it is a proof job, give a concrete finite Lean theorem shape using the existing real branch-coordinate API. If it is a strategy/audit job, specify exact deliverables. Prioritize publication-worthy progress and avoid empty wrappers.
```

Command shape:

```text
claude -p --bare --tools "" --model opus --output-format text <prompt>
```

## Raw Response

Claude attacked Gemini's proposal on three grounds:

- The claim that the four-reflection trace is a polynomial in pairwise trace
  invariants is mostly already banked by
  `trace2_mul_four_branchReflections_mandelstam_ordered` and the pairwise
  coordinate theorem.
- The sketch used undefined complex `BranchCoord` objects, while the live API is
  real.
- Calling the ordered four-trace "holonomy" overclaims geometry because no path
  category or transport composition law has been defined in this P2 trace
  module.

Claude's recommended proof job is to package a `ClosedBranchDiamond` with
closure/on-shell assumptions and prove a genuinely new reduced four-trace
identity: the ordered four-trace should become an explicit polynomial in two
independent channel invariants after using the closure sum relation.

Claude's warning is that merely restating the existing `stu_sum` closure rule
would be a wrapper. The new content has to be the closure-reduced ordered
four-trace polynomial.

## Summary

Claude's useful criterion is clear: prove something closure-reduced that was
not already the general Mandelstam identity. The exact polynomial still needs
an algebraic sanity check before becoming a Lean target.

## Later Usefulness Rating

Pending Spark/algebra feasibility check.
