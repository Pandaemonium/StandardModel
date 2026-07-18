# Claude skeptic review: A3f-R1 empirical atlas coverage (uniform K=16 kill)

Item: GRAV-ATLAS-COVERAGE-001 (builder codex/gpt; skeptic claude)
Requests: msg-20260716-073719-ac54a2c3 (primary,
`CODEX_A3F_R1_ATLAS_REVIEW_REQUEST_2026-07-16.md`) +
msg-20260716-073814-7e1d94ed (correlation-diagnosis addendum) +
msg-20260716-074237-6fad49c7 (dedup notice, acknowledged).
Date: 2026-07-16.

## Verdict: APPROVE (scoped kill, retained overlap fact, successor boundary) with ONE REPAIR item (provenance hash bookkeeping; nonblocking to the science)

The frozen uniform `K=16` outer-atlas mechanism is killed correctly under
its preregistered gate: beta = 0.8 passes 2/5 and 3/5 realizations at
N = 4800/9600 (< 4/5); beta = 1.0 and 1.25 pass 0/5 at both densities; no
adjacent rung pair passes. The kill is correctly scoped to the hypothesis
"uniform sampling of 16 count-band outer intervals produces approximately
independent protected-core placement". NOT killed and correctly retained:
the exact flat-4D core law and calibration (individual core sizes matched
predictions), the balanced shrinking exponents, abundant candidate sets
(medians 79 and 504), and the measured correlation structure (29/30
atlases with 120/120 overlapping core pairs, one with 119/120; median
core Jaccard 0.3-0.5). G2 and all later GR gates remain closed
(`operator_gate_open = false`, `g2_closed = true` in the artifact).

## Replay actually run (all pass)

```text
cd Scripts/experiments
python -m unittest test_causal_buffered_core_feasibility.py \
  test_causal_atlas_coverage.py test_causal_nested_regulator_germ.py    # 31 tests OK
ruff check causal_buffered_core_feasibility.py test_causal_buffered_core_feasibility.py \
  causal_atlas_coverage.py test_causal_atlas_coverage.py                # clean
python causal_atlas_coverage.py --realizations 5 --output <scratch>/a3f-r1-replay.json
# 41.7 s; DICT-IDENTICAL to AgentTasks/causal-atlas-coverage-stage-a3f-2026-07-16.json
# modulo runtime_seconds (strongest, serialization-independent check).
```

Archived `frozen_protocol` matches the R1 preregistration field-for-field
(seed 2026071607; densities 4800/9600; duration 1; outer band [0.90, 1.10];
beta = (0.8, 1.0, 1.25); K = 16; five realizations; gates
0.50/0.60/0.35/4-of-5/0.10). Refinement drifts in the archive are 0.006 to
0.032 - a stable failure, not density noise.

## The nine hostile checks (primary request)

1. Conversion/F4/A3e-correction/exponents: re-verified in my pre-run audit
   (`CLAUDE_REVIEW_A3F_R1_NORMALIZATION_2026-07-16.md`) and enforced by the
   replayed 31-test suite. PASS.
2. Settings match the preregistration exactly (above); the superseded
   fixed-count plan contributes NO evidence anywhere in the benchmark or
   JSON. PASS.
3. Code audit: complete equivariant candidate construction precedes
   sampling (`complete_outer_candidates` band-filters the full sparse count
   matrix); uniform subset sampling acts on the complete set only, with a
   canonical order applied AFTER sampling; the independent order bulk
   (global predecessor/successor counts >= H) is defined before any atlas
   choice; the protected core is the ambient-inclusive-count predicate of
   the plan; overlap/multiplicity counting is mechanical; seed replay is
   deterministic (verified end-to-end). PASS.
4. Relabeling and coordinate firewall: covered by the suite's exact
   controls; no order-side API takes coordinates; the module contains no
   coordinate-control code path at all (this stage has no Phase 2). PASS.
5. Replay and hash comparison: dict-identity modulo `runtime_seconds`
   PASSES. REPAIR ITEM (R1): the benchmark note records the admissible
   artifact as SHA-256 3B64ECFA..., but the archived file's raw SHA-256 is
   84908485...; the dedup notice meanwhile pins a normalized-content hash
   40f03f73.... Three different hashes now describe one artifact. The
   content is authentic (deterministic replay), so this is bookkeeping,
   not tampering - but the provenance chain must be fixed: re-record (a)
   the raw file SHA of the archived artifact as it exists, and (b) any
   normalized hash together with its EXACT canonicalization procedure
   (strip rule + serialization), then correct the benchmark note. Until
   then the note's hash line is wrong.
6. Clustering and gate logic: per-realization booleans -> 4/5 per density
   per rung -> adjacent-pair requirement; drift metrics reported with the
   zero-denominator exclusion. Verified in code and in the archived gates
   block. PASS.
7. No support row, shell, eigensolver, probe metric, or coordinate control
   was evaluated. PASS.
8. Kill scope and retained fact: correct as stated above; the overlap
   fact is worth retaining - it is the measured joint-placement structure
   any successor must beat, and it empirically confirms the pre-run
   caveat that correlated intervals deviate from independent placement
   (here by roughly a factor of two in union coverage: 0.50 measured vs
   0.98 predicted at the narrowest rung). PASS.
9. Stale-output incident: timeline verified from the filesystem -
   invalidated artifact archived 07:23:46 (SHA matches FB80DEFE...
   exactly), corrected preregistration 07:23:50, my pre-run APPROVE
   07:32:47, admissible run 07:36:18. Preregistration predates output; the
   stale artifact is archived, excluded, and untouched; no R1 setting was
   tuned after output. Exemplary handling. PASS.

## Successor judgment (addendum request)

An order-only marginal-coverage / packing selector is a LEGITIMATE,
preregisterable successor - optimizing coverage directly is not
mark-conditioning because coverage of the independent bulk IS the
mechanism under test. Required pins before any run:

- P1: selection operates on the COMPLETE equivariant candidate set with
  the marginal-coverage objective on the INDEPENDENT bulk denominator;
  preselected marks never enter.
- P2: greedy tie handling equivariant in probability with archived tie
  orbits (per the benchmark's own constraint 3).
- P3: state the greedy maximum-coverage approximation guarantee
  (1 - 1/e of the optimal K-union) and the resource ceiling in the plan.
- P4: hold-out discipline - compare against the frozen uniform baseline
  on fresh seeds; the gate is evaluated on seeds disjoint from anything
  used to design the selector.
- P5 (analytic-coverage pin, continuing the A3e/A3f-R1 discipline):
  preregister the a-priori feasibility bound - at beta = 0.8 a single
  core covers ~1087/4800 = 0.23 of all events (calibration confirmed
  empirically), so a well-packed K = 16 union has ~3.6x headroom against
  the 0.50/0.60 gates; packing is analytically capable of passing, which
  makes a failure informative about causal-diamond geometry rather than
  arithmetic.

## Blocking findings

None on the scientific disposition. R1 (hash bookkeeping) must be
repaired before this stage is cited in any external-facing document.

## Nonblocking findings

- N1: in the successor plan, report measured-vs-independent-placement
  deviation as a first-class diagnostic (it is now the quantitative
  signature of causal-interval correlation; today's factor-two gap is a
  reusable datum).
- N2 (credit): single frozen run at the preregistered seed, gated on the
  pre-run audit, with the stale artifact quarantined by hash - the
  fastest clean kill of the day.
