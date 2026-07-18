# Review request: A3f-R4-D diagnostic implementation and hashes

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`
Required verdict: `RUN-CLEARED` or `REVISE`; execution remains unauthorized

## Frozen inputs

- PLAN-CLEARED diagnostic plan:
  `AgentTasks/null-edge-growing-atlas-stage-a3f-r4d-diagnostic-plan-2026-07-16.md`
  - SHA-256:
    `a6ec0873d838b5140e356b34f3d4a99b522555292ff12e417585fcc34a517ed6`
- Diagnostic source:
  `Scripts/experiments/causal_growing_atlas_diagnostic.py`
  - SHA-256:
    `b73b367073e4dbf38eac16f216e946fb6d3f67a8c1765760779ba9b2983ef553`
- Diagnostic tests:
  `Scripts/experiments/test_causal_growing_atlas_diagnostic.py`
  - SHA-256:
    `2b55afe7151578dd1cca960c2a4ee99a5c5de4f94a891fc2083584bedf5e3505`
- Imported frozen R4 source:
  `Scripts/experiments/causal_growing_atlas.py`
  - SHA-256:
    `e88f7b1bd946ffd78632283203ce4923245a274da1728bc101b232c77ff7be59`
- Imported set-reservation guard:
  `Scripts/experiments/frozen_run_guard.py`
  - SHA-256:
    `d6364ee0443513254e16d0d0077f8d8b4bae360e78614049e8fa9aacd8680f16`
- Independently reviewed frozen R4 development artifact:
  `AgentTasks/causal-growing-atlas-stage-a3f-r4-development-2026-07-16.json`
  - raw SHA-256:
    `82206d616d9a3c289bc6a173f9f5792086f9a848d110d3b8fee6d6e771740335`

The R4-D output and sentinel paths are absent. No diagnostic replay has been
executed.

## Verification already run

From `Scripts/experiments`:

```text
python -m unittest test_causal_growing_atlas_diagnostic.py
```

passes 17 diagnostic tests. The combined diagnostic, guard, R4, R3, R1, R2,
coverage, and packing suite passes 110 tests. Ruff is clean on the diagnostic,
R4, and guard source/test set. Scoped pre-commit passes.

The tests cover null empty-family intersections, top-endpoint multiplicity,
half-integer medians, all interpretation branches, the 1.25 nonvanishing-core
condition, exact candidate/bulk replay tables, seed-tree identity, reservation
before the runner, durable failure sentinels with empty outputs, no selector or
gate calls, diagnostic-only protocol fields, and canonical hash behavior.

## Requested audit

1. Confirm the source calls no selector, comparator, gate, or outcome
   classifier and cannot alter the R4 decision or sample count.
2. Confirm `diagnostic_sprinkling_states` recovers exactly the six consumed R4
   development sprinkling streams and never touches held-out seed
   `2026071611`.
3. Confirm D1-D3 implement the approved definitions over all
   `diamond_event_count` events, including the top endpoint.
4. Confirm empty candidate families use `null` intersections and an empty core
   at beta 1.25 cannot receive the chart-scale-break label.
5. Confirm the hardcoded candidate and per-rung bulk replay table matches the
   frozen R4 artifact exactly and any mismatch raises before writing output.
6. Confirm beta 1.25 is marked diagnostic-only in every record and cannot
   become a gate or R5 result.
7. Confirm the interpretation labels are per-sprinkling descriptive labels and
   no aggregate hides heterogeneity.
8. Confirm the set reservation acquires the output and sentinel before seed
   spawning or RNG construction, retains failures, and leaves no unreserved
   scientific output.
9. Confirm plan/source/test/R4/guard/artifact hashes are verified before
   reservation and pinned in the sentinel metadata.
10. Confirm runtime/peak ceilings, coordinate deletion, and canonical content
    hashes preserve the R4 provenance and resource boundaries.

Please replay the 110-test suite and Ruff. Return `RUN-CLEARED` only if every
blocking question passes at the displayed hashes. Do not execute the frozen
diagnostic during review.

## Exact frozen command after RUN-CLEARED

Run once from `Scripts/experiments` only after rechecking all hashes and
confirming both reserved paths remain absent:

```text
python causal_growing_atlas_diagnostic.py --output ../../AgentTasks/causal-growing-atlas-stage-a3f-r4d-diagnostic-2026-07-16.json --sentinel ../../AgentTasks/causal-growing-atlas-stage-a3f-r4d-run-sentinel-2026-07-16.json --plan ../../AgentTasks/null-edge-growing-atlas-stage-a3f-r4d-diagnostic-plan-2026-07-16.md --tests test_causal_growing_atlas_diagnostic.py --r4-source causal_growing_atlas.py --guard frozen_run_guard.py --r4-artifact ../../AgentTasks/causal-growing-atlas-stage-a3f-r4-development-2026-07-16.json --expected-plan-sha256 a6ec0873d838b5140e356b34f3d4a99b522555292ff12e417585fcc34a517ed6 --expected-implementation-sha256 b73b367073e4dbf38eac16f216e946fb6d3f67a8c1765760779ba9b2983ef553 --expected-tests-sha256 2b55afe7151578dd1cca960c2a4ee99a5c5de4f94a891fc2083584bedf5e3505 --expected-r4-source-sha256 e88f7b1bd946ffd78632283203ce4923245a274da1728bc101b232c77ff7be59 --expected-guard-sha256 d6364ee0443513254e16d0d0077f8d8b4bae360e78614049e8fa9aacd8680f16 --expected-r4-artifact-sha256 82206d616d9a3c289bc6a173f9f5792086f9a848d110d3b8fee6d6e771740335
```

Any failure retains its sentinel and does not authorize a second replay.
