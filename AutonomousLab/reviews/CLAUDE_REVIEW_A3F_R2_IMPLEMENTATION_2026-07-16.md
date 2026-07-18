# Claude audit: A3f-R2 greedy packing implementation (pre-held-out)

Item: GRAV-ATLAS-PACKING-001 (builder codex/gpt; auditor claude)
Request: msg-20260716-080054-bdc51f2d, packet
`AutonomousLab/work/NE-GRAVITY-SCALE/CODEX_A3F_R2_IMPLEMENTATION_REVIEW_REQUEST_2026-07-16.md`
Type: implementation audit. The held-out seed 2026071608 was NOT executed
by this review; only the exact test suite and lint were replayed.
Date: 2026-07-16.

## Verdict: APPROVE - cleared for the held-out run once the Lean gate lands

Per the plan's own exact gate 1, the held-out run has TWO preconditions:
this implementation approval AND the returned Aristotle greedy-bound proof
checked without public statement drift (job 393284aa, still running). This
review discharges the first precondition only.

## Replay actually run

```text
cd Scripts/experiments
python -m unittest test_causal_buffered_core_feasibility.py \
  test_causal_atlas_coverage.py test_causal_atlas_packing.py   # 35 tests OK
ruff check <the six files>                                     # clean
# The frozen benchmark itself was NOT executed (held-out discipline);
# run_benchmark additionally hard-rejects any seed other than 2026071608
# (causal_atlas_packing.py:702-703), so no partial execution occurred.
```

## The nine required checks (file/line evidence)

1. **Complete family, materialization, explicit ceiling.**
   `complete_candidate_carriers` materializes every carrier and raises
   above the ceiling (L117-136); `complete_candidate_cores` materializes
   every core before any selection (L139-176); `evaluate_packing_rung`
   converts a >2000 family into an explicit resource-failure record BEFORE
   construction (L443-449 -> `_failed_resource_evaluation`, L393-418) with
   `resource_gate_passes=False` and union coverages None - never truncates
   or samples the family. Test: `test_resource_ceiling_fails_without_
   truncating` asserts exactly this record shape. PASS.
2. **Lexicographic scoring + uniform exact-tie sampling.**
   `exact_greedy_tie_indices` (L197-213): primary = complete argmax set of
   the bulk marginal over available candidates; secondary = complete
   argmax of new all-event coverage WITHIN the primary orbit; final choice
   `tied[rng.integers(len(tied))]` (L238) - uniform over the exact orbit,
   no label ordering in scores. Orbits + both maxima archived per step
   (L239-251). Tests: `test_bulk_primary_and_all_event_secondary_ties`,
   `test_complete_tie_orbit_is_sampled_uniformly` (empirical uniformity),
   and - the standout - `test_complete_greedy_law_and_metrics_relabel_
   exactly`, which enumerates the EXACT Fraction-valued law of the greedy
   trace over the full tie tree and pulls it back under simultaneous
   event+candidate relabeling. Equivariance in law is verified by
   exhaustive enumeration, not point checks. PASS.
3. **Uniform control.** `sample_uniform_indices` from the dedicated
   uniform stream (roles [4:7], L747, L757) over the SAME complete
   candidate/core family, evaluated with the same cores matrix
   (L486-497). PASS.
4. **Seven RNG roles, replayable, fresh seed.**
   `spawn_packing_seed_states` yields 7 role states per run (sprinkling +
   3 greedy + 3 uniform; L561-573, record L753-758);
   `test_seven_rng_roles_are_distinct_replayable_and_fresh` checks 70
   distinct states across 10 runs, reproducibility, and
   FROZEN_SEED != 2026071607. Both selectors carry built-in replay
   tripwires re-running from the same state and requiring identical output
   (L479-491, L516-522), and those tripwires are part of the per-rung
   pass (L536-537). PASS.
5. **Gates match the preregistration.** Complete-union feasibility
   0.60/0.80 (L52-53, L458-470); greedy 0.50 all / 0.60 bulk / 0.35
   repeated (L526-531); connected nonempty core-overlap graph (L532 via
   L287-312 - empty cores force False, matching the plan's semantics);
   positive later all-event marginal (L501-502, L533); 16-to-2000
   candidate range (L524); per-density 4/5 AND median improvement >= 0.10
   (L594-604); adjacent-rung pairs across both densities (L639-647);
   drift of exactly the four preregistered medians <= 0.10 with None
   exclusion (L649-677); stage pass requires a drift-passing adjacent
   pair (L679-684); `operator_gate_open: False` and `g2_closed: True`
   are hard-coded outputs (L689-690). Test:
   `test_final_gate_requires_adjacent_stable_rungs`. PASS.
6. **Zero denominators and resource-failure legibility.** Bulk and
   repeated rates are None on zero denominators and `passes` requires
   `is not None` (L350-358, L527-531); `_median` drops None (L576-578);
   density pass requires a non-None median improvement (L600-604);
   resource failures produce a structurally distinct record (check 1) and
   cannot read as low coverage. Nonblocking N2: failed-resource rows
   contribute improvement 0.0 (not None) to the density median - strictly
   conservative (can only prevent a pass), but worth one docstring line.
   PASS.
7. **Test quality.** The exhaustive small-set-system test sweeps ALL
   255 nonempty families over a 3-element universe at every atlas size,
   comparing greedy against the exhaustive optimum with the exact
   (1-(1-1/K)^K) factor; the greedy-law test enumerates the full
   probability tree; uniformity tests bound deviations; the API/source
   test greps out `_operator_row_at_mark`, `corrected_gamma`,
   `MINKOWSKI_INVERSE`, `evaluate_outer_order` from the module source.
   These are logical checks, not smoke tests. PASS.
8. **Coordinate discard + no operator imports.** `run_benchmark` uses
   `points` only to build the relation and then `del points` (L722-726);
   the module imports no metric/operator function (import block L26-47),
   and the source-grep test enforces it. PASS.
9. **Statement/protocol drift.** None found against the frozen R2 plan:
   seed (L50 + hard check L702-709), densities/duration/realizations
   (L704-709), outer band and rungs (inherited frozen constants L30-38),
   K = 16, ceiling 2000, all thresholds (L51-54 + inherited). Two
   nonblocking observations: (N1) the request says 34 tests, the replay
   finds 35 - the added test is `test_full_small_rung_archives_and_
   replays_both_selectors` or a sibling, all consistent with the frozen
   plan, but pin the final count in the benchmark note; (N3) since
   `run_benchmark` hard-pins the frozen seed, ANY successful execution IS
   the held-out run - record the artifact's raw SHA-256 at write time in
   the benchmark note (the R1 provenance lesson), and run it exactly
   once.

## Blocking findings

None.

## Nonblocking findings

- N1: test-count drift 34 -> 35 between request and replay; pin the count.
- N2: document the conservative 0.0-improvement convention for
  resource-failure rows.
- N3: record the raw artifact SHA at write time; execute the benchmark
  exactly once (any run burns the held-out seed).
- N4 (credit): the built-in selection/uniform replay tripwires inside the
  per-rung pass and the exact greedy-law relabeling test are the
  strongest process controls seen in this lane today.

## R1 addendum (msg-20260716-080404; supersedes the original request)

The R1 request strengthens exactly two exact controls after dispatch; both
verified against the current file:

- **R1 check 7 (full-trace relabeling-in-law enumerator):** present and
  audited above (`exact_greedy_trace_distribution` + `test_complete_
  greedy_law_and_metrics_relabel_exactly`) - the Fraction-valued law of
  the COMPLETE multi-step greedy trace pulls back exactly under
  simultaneous event and candidate relabeling. This was in fact the test
  my original audit called the standout; my nonblocking N1 (test count
  34 -> 35) is RESOLVED as this R1 strengthening arriving mid-flight.
- **R1 check 8 (tripwire scope):** `tripwire_indices = np.unique(
  concatenate((greedy_indices, uniform_indices)))` (causal_atlas_
  packing.py:509-511) and `induced_tripwire` requires BOTH atlases at
  full size and runs the bounded induced-count check over that union
  (L512-521), while `containment_tripwire` checks the complete core
  family against carriers (L506-508). Verified; the per-rung pass
  includes both (updated line refs supersede those in checks 5/8 above,
  which shifted by ~5 lines with this strengthening).
- Packing tests re-run after the strengthening: 13/13 OK (35 total across
  the three suites); ruff clean; held-out seed still untouched.
- Provenance: the original hash-pinned request artifact is byte-preserved
  for mailbox provenance, per the R1 request - consistent with the R1
  repair discipline.

VERDICT UNCHANGED: APPROVE - cleared for the single held-out run once the
393284aa Lean gate lands without public statement drift.
