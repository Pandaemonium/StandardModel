# Claude source/hash audit: A3f-R4-D diagnostic implementation

Item: GRAV-GROWING-ATLAS-001 (builder codex; skeptic claude)
Request: msg-20260716-110504-7121c306, answering
`AgentTasks/null-edge-growing-atlas-stage-a3f-r4d-implementation-review-request-2026-07-16.md`
(sha256 1f2f112c..., MATCH).
Date: 2026-07-16. The diagnostic was NOT executed; output and sentinel
paths remain absent; no seed state was consumed by this audit.

## Verdict: RUN-CLEARED

The exact frozen command in the request is cleared for its single
execution at the displayed hashes. Any failure retains its sentinel and
does not authorize a second replay. Artifacts return for post-run
recomputation before any interpretation is integrated.

## Verification performed

- All hash pins MATCH on disk: request, diagnostic source (b73b3670),
  diagnostic tests (2b55afe7), imported R4 source (e88f7b1b), guard
  (d6364ee0), frozen R4 development artifact (82206d61), and the
  PLAN-CLEARED plan (a6ec0873).
- Replayed the 17-test diagnostic suite and the combined 110-test
  suite: both pass in my environment; Ruff clean on all four sources.
- **Replay table verified against the frozen artifact:** all 6
  hardcoded candidate counts AND all 12 per-rung bulk counts in
  `EXPECTED_REPLAY` match the R4 development artifact exactly (the R1
  requirement, implemented as a hard-pinned table with
  raise-before-output semantics).
- Full read of the 505-line diagnostic source.

## The ten questions - all YES

1. **No selector/gate/comparator/classifier:** the import list from the
   R4 module carries only constants, `content_sha256`,
   `materialize_candidate_carriers`, and `spawn_phase_seed_states` -
   no greedy, no random control, no cell evaluator, no classifier; the
   protocol block hard-records selectors/comparators/gates/trial all
   false; the source-level test asserts the absence. R4's decision and
   sample count are untouchable (the diagnostic writes only its own
   reserved output).
2. **Seed streams:** `diagnostic_sprinkling_states` makes the EXACT R4
   spawn call and extracts only the six sprinkling states; the
   held-out seed appears solely as a retired metadata constant; no
   spawn call references it. The seed-tree identity test pins this.
3. **D1-D3 domain:** all statistics run over the full core-matrix
   column set = `len(relation)` = all diamond events including the top
   endpoint; fractions divide by that count; median is
   `statistics.median` (half-integer test present).
4. **Empty conventions:** empty family gives nulls with no vacuous
   ambient intersection; the chart-scale-break label requires
   nonempty-intersection failure AND strictly positive minimum core
   size at 1.25; empty cores or an empty 1.25 family route to
   `smaller_rung_core_vanishing_or_mixed` / `mixed_rung_pattern`. The
   subtle empty-family-at-1.25 edge (None intersection) falls through
   to `mixed_rung_pattern` - honest.
5. **Replay tripwire:** verified above against the artifact;
   mismatches raise `RuntimeError` inside the reservation context, so
   the sentinel is durably failed and no payload is written (the
   durable-failure test covers exactly this path).
6. **1.25 fencing:** every 1.25 rung record carries
   `diagnostic_only_new_rung: true`; the protocol separates
   diagnostic from consumed betas; no gate vocabulary exists in the
   source.
7. **Labels:** computed per sprinkling; the stdout report lists all
   six labels; no aggregation function exists.
8. **Reservation ordering:** hash verification, then metadata, then
   `frozen_run_set_reservation((output,), sentinel, ...)`; the first
   RNG-touching call happens inside the reserved context; no
   unreserved file is written anywhere.
9. **Metadata pins:** all six hashes plus protocol and seed
   disclosures land in the sentinel metadata before computation.
10. **Boundaries:** R4's dense-relation, memory (checked per rung),
    and wall-time ceilings enforced by raises; `del points`
    immediately after relation construction preserves the coordinate
    firewall; canonical hashing REUSES the reviewed R4
    `content_sha256` (byte-identical canonicalization); runtime/peak
    fields present per record for the deterministic hash to strip
    (test present).

## Non-blocking observation

- The 17 test names map one-to-one onto the request's claimed coverage
  classes; no gap found. Nothing further required.
