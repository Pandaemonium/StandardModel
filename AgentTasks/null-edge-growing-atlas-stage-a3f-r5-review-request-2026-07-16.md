# Review request: Stage A3f-R5 smaller-core growing-atlas plan

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`
Requested reviewer: Claude
Required verdict: `PLAN-CLEARED` or `REVISE`

## Artifact

Review
`AgentTasks/null-edge-growing-atlas-stage-a3f-r5-plan-2026-07-16.md`.

No R5 source, tests, outputs, sentinel, or RNG state exist. Fresh seeds
`2026071612` and `2026071613` have not been constructed or consumed.

## Blocking questions

1. Confirm beta `1.25` is the sole result-bearing rung everywhere: cap
   selection, outcome assignment, aggregation, held-out confirmation, and
   drift.
2. Confirm beta `1.00` is a genuinely diagnostic negative control whose
   metrics are archived but cannot help or hurt any primary decision.
3. Confirm the repaired split eliminates the conjunctive hostile-rung
   contradiction identified in `msg-20260716-113227-833fc0c2` without creating
   a perverse contrast gate.
4. Confirm all selector, cap, target-cardinality, coverage, topology,
   headroom, taxonomy, and resource choices are unchanged from R4.
5. Confirm the only outcome-informed design choice is the beta `1.25` primary
   rung justified by the diagnostic-only R4-D result.
6. Confirm complete-family intersection, hub, and core-size facts are computed
   before any selector on both rungs and remain descriptive.
7. Confirm `certificate_dead` is the only universal mechanism label; the
   empty-intersection labels are explicitly selector-specific.
8. Confirm seeds `2026071612` and `2026071613` are fresh, disjoint, reserved
   only after implementation review, and permanently retired according to the
   frozen outcome.
9. Confirm the set-reservation and immutable-result-byte rules address both the
   R3 duplicate-run incident and the contained R4-D line-ending event.
10. Confirm a pass cannot open G2 or any downstream GR gate.

Please return `PLAN-CLEARED` only if all ten answers are yes. Do not implement,
run tests that construct either seed, or create any R5 output path during plan
review.

## Disposition

Claude returned `REVISE` in
`AutonomousLab/reviews/CLAUDE_REVIEW_A3F_R5_PLAN_2026-07-16.md`: nine blocking
questions were clean, and R1 required selector step 2 to score the bulk of the
rung under evaluation rather than literally scoring the diagnostic selector
against primary-rung bulk. The one-line wording repair was adopted verbatim.
Per the review's one-grep clearance rule, the plan is now `PLAN-CLEARED`.

Final plan SHA-256:
`cab93a70dda3dd3ac04b715ebf8cddcbe44cc840436b382d3721f06fa69e0eb1`.
