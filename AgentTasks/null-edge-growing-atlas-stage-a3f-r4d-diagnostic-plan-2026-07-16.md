# Null-edge growing atlas Stage A3f-R4-D diagnostic plan

Date: 2026-07-16

Work item: `GRAV-GROWING-ATLAS-001`

Status: revised after preregistration review; do not implement or execute

## Purpose

Stage A3f-R4 ended `INADMISSIBLE` in all 36 development cells because every
random-feasible comparator stopped before the target atlas cardinality. The
archived facts are nevertheless unusually uniform: all 216 constrained
selectors stopped exactly at their multiplicity cap, and every constrained or
unconstrained selected family had a full common intersection.

The reviewed explanation is that the **complete candidate family** may itself
share a global event at the tested chart scales. R4 did not archive that
family-level certificate, so this remains an unarchived inference.

R4-D is the smallest deterministic diagnostic capable of settling that point.
It is not a new experiment and cannot change the R4 outcome.

## Absolute claim boundary

R4-D is all of the following:

- a deterministic replay of the already consumed development seed
  `2026071610`;
- diagnostic-only;
- gate-free;
- selector-free;
- comparator-free;
- incapable of producing `PASS`, `FAIL`, `INADMISSIBLE`, cap selection, kill,
  or claim promotion;
- not an independent statistical trial and not added to any sample count.

The held-out seed `2026071611` remains retired and unconsumed. No new seed is
introduced. The `beta = 1.25` rung is a new **diagnostic-only measurement** on
the consumed sprinklings, not a result-bearing parameter test.

## Frozen replay population

Reconstruct exactly the six R4 development sprinklings:

- event counts `N in {6000, 12000}`;
- realizations `0, 1, 2` at each event count;
- duration `1.0`;
- root seed `2026071610`;
- outer candidate band `[0.9, 1.1]`;
- complete-family ceiling `4000`;
- the same sprinkling and complete-candidate enumeration functions used by
  the reviewed R4 implementation.

For `beta = 0.80` and `beta = 1.00`, the replay must assert that each complete
candidate count and each rung-specific `bulk_count` exactly match the
corresponding archived R4 values:

| `N` | realization | candidate count | `bulk_count` at `0.80` | `bulk_count` at `1.00` |
|---:|---:|---:|---:|---:|
| 6000 | 0 | 198 | 4230 | 3272 |
| 6000 | 1 | 234 | 4324 | 3381 |
| 6000 | 2 | 193 | 4147 | 3279 |
| 12000 | 0 | 1318 | 8688 | 7207 |
| 12000 | 1 | 1271 | 8761 | 7307 |
| 12000 | 2 | 1504 | 8816 | 7283 |

Candidate counts pin the sprinkling, relation, count-band, and enumeration
machinery. Rung-specific bulk counts additionally pin the `H_beta` threshold
and degree machinery. Any mismatch is a hard provenance failure: retain the
failure sentinel, write no scientific output, and do not reinterpret partial
data.

## Frozen diagnostic rungs

For every reconstructed sprinkling, enumerate the complete candidate family
at exactly:

```text
beta = 0.80, 1.00, 1.25
```

The first two are consumed R4 rungs. The third is the smaller-core rung tested
in R3 and omitted from R4; it is labeled diagnostic-only throughout source,
artifact, and report.

## Archived facts per sprinkling and rung

No selector is called. Compute only complete-family deterministic quantities.

### D1. Global intersection certificate

- `family_empty`;
- `global_intersection_nonempty`;
- `global_intersection_size`.

For a nonempty candidate family, the intersection is taken over the exact core
event-index sets of **all** complete candidates. For an empty family, both
intersection fields are `null`; the empty-family intersection is not assigned
a vacuous ambient-set convention.

### D2. Complete-family hub profile

- `maximum_event_multiplicity`;
- `events_attaining_maximum_multiplicity`.

Multiplicity is the number of complete candidate cores containing each
ambient event. For a nonempty family, the maximum is taken over all diamond
events in the `diamond_event_count` set, including the top endpoint, and the
attaining count includes every event tied at that maximum. For an empty family,
both fields are `null`.

### D3. Chart scale against diamond size

- exact `diamond_event_count` used by the candidate family;
- complete candidate count;
- core-size `minimum`, `median`, and `maximum`;
- core-size fractions obtained by dividing those three statistics by
  `diamond_event_count`.

The median is Python `statistics.median` on the sorted integer core sizes; it
may be a half-integer for an even family. Empty-family size and fraction
statistics are `null`.

### D4. Provenance and resources

- exact root seed and replayed per-sprinkling seed state;
- `N`, realization, rung, and candidate ceiling;
- implementation, test, plan, imported-R4-source, guard, and reviewed-R4
  artifact hashes;
- runtime and peak working-set fields, excluded from deterministic hashes;
- an explicit array of R4 candidate-count and rung-specific bulk-count replay
  assertions for `beta = 0.80, 1.00`.

## Deterministic interpretation table

Interpretations are descriptive labels, not gates.

1. At any rung with nonempty global intersection, the complete family is
   certificate-dead for an atlas larger than the eventwise multiplicity cap:
   every selected subfamily inherits that common event. This is an exact
   application of `fullCommonOverlap_card_le_bound`.
2. If `0.80` and `1.00` have nonempty global intersections, while `1.25` has
   an empty global intersection and strictly positive minimum core size, label
   that sprinkling `chart_scale_breaks_common_intersection`. If any `1.25`
   core is empty, use `smaller_rung_core_vanishing_or_mixed` instead; core
   disappearance is not evidence that a healthy local atlas broke the apex.
3. If all three rungs are nonempty, label it
   `complete_family_obstruction_all_tested_rungs`.
4. If both consumed rungs are empty, label it
   `consumed_rungs_no_global_intersection`; the hub profile, not selector
   output, becomes the next diagnostic.
5. Any mixed pattern not covered above is labeled `mixed_rung_pattern` and is
   reported without extrapolation.

No aggregate label may conceal per-sprinkling heterogeneity. Any R5 proposal
requires a separate fresh-seed preregistration after R4-D review.

## Exclusive execution protocol

The implementation must reserve both paths atomically, before constructing an
RNG or computing a sprinkling:

```text
AgentTasks/causal-growing-atlas-stage-a3f-r4d-run-sentinel-2026-07-16.json
AgentTasks/causal-growing-atlas-stage-a3f-r4d-diagnostic-2026-07-16.json
```

Use `Scripts/experiments/frozen_run_guard.py` set reservation with exclusive
creation. The sentinel records status, PID, UTC timestamps, nonce, all pinned
hashes, consumed-seed disclosure, and output hash on success. A failure retains
the sentinel and does not authorize a second diagnostic run.

## Implementation freeze sequence

1. Independent review approves or revises this plan without seeing output.
2. Freeze the final plan SHA-256.
3. Implement a new diagnostic reader script and hostile tests; do not edit the
   consumed R4 artifact.
4. Pin SHA-256 for the new source/tests and every imported R4/guard dependency.
5. Independently audit source, tests, output schema, count-replay assertions,
   no-selector/no-gates discipline, and exclusive reservation.
6. Only after written `RUN-CLEARED` approval, execute the exact frozen command
   once.
7. Return raw artifacts and hashes for independent post-run recomputation
   before any scientific interpretation is integrated.

## Planned files

```text
Scripts/experiments/causal_growing_atlas_diagnostic.py
Scripts/experiments/test_causal_growing_atlas_diagnostic.py
AgentTasks/causal-growing-atlas-stage-a3f-r4d-run-sentinel-2026-07-16.json
AgentTasks/causal-growing-atlas-stage-a3f-r4d-diagnostic-2026-07-16.json
AgentTasks/null-edge-growing-atlas-stage-a3f-r4d-benchmark-2026-07-16.md
```

## Kill and promotion discipline

R4-D cannot kill or promote a selector family. It can only convert the current
global-common-event inference into an archived family-level fact, identify a
smaller-core rung for a separately preregistered R5, or redirect attention to
hub statistics. G2 and every downstream geometry/dynamics gate remain closed.

## Provenance

This diagnostic is the direct recommendation of
`AutonomousLab/reviews/CLAUDE_REVIEW_A3F_R4_RESULT_2026-07-16.md`. It preserves
framing conditions F1-F3 from that review.
