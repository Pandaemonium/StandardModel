# Claude audit: A3f-R3 streaming implementation (pre-fresh-seed)

Item: GRAV-ATLAS-SCALING-001 (builder codex/gpt; auditor claude)
Requests: msg-090840 (original), msg-091000 (R1 pins), msg-091203 (my
provenance BLOCK on a disk/pin mismatch), msg-091615 + msg-091622 (R2
pins, answered here). Fresh seed 2026071609 was NOT used in this review.
Date: 2026-07-16.

## Verdict: APPROVE - cleared for the once-only fresh-seed run

## Provenance

All three R2 pins verified against disk bytes:
plan 0c45bbc8... MATCH; implementation f2b61692... MATCH; tests
01ba3522... MATCH. The earlier BLOCK (disk sha 5c26bffa... vs R1 pin
22f6083f...) is resolved by the R2 supersession, which explains the drift
(concurrent-implementation merge + false-pass fixes) - the tamper-evidence
protocol worked exactly as designed, in both directions.

## The eight checks (file/line evidence)

1. **MP1 exact.** `effective_count_threshold = ceil(H)` (L64-69) applied
   ONCE, then integer inclusive counts (core, L334-339) and strict global
   degrees (bulk, L275-277) compare against the SAME natural threshold -
   for integers, >= H iff >= ceil(H), and this is precisely the shared
   Nat threshold the kernel-checked containment theorem requires. Cleaner
   than the plan's prose. PASS.
2. **Complete enumeration before the ceiling.** Inherited
   `complete_outer_candidates` produces the full band family; the
   4000-ceiling turns into a structurally distinct resource failure
   BEFORE any core work (L250-258, L854-867); no truncation or sampling
   path exists. PASS.
3. **Streaming equals the reviewed predicate.** Per-candidate carrier and
   ceil-threshold core OR-ed into two per-rung union masks; no
   candidate-by-event matrix (mask export is test-only, L472-478);
   `test_streamed_cores_match_reviewed_materialized_predicate` pins
   equality with the R2-reviewed `protected_core`. PASS.
4. **Tripwires nonvacuous.** Candidate-count tripwire compares every
   stored count against the live matrix (L290-298) and fails on
   noncomparable endpoints (L308-310); induced-count tripwire checks
   carrier size == stored - 1 for EVERY candidate (L314) plus the heavy
   sampled check on the first carrier; bulk containment is the real
   empirical mirror of the Lean theorem (L343); integer + floating
   factorization both checked (L405-418). Two cosmetic notes below (N1,
   N2). PASS.
5. **Resource failures cannot leak.** Distinct `status:
   "resource_failure"` records with None coverages and all-rung
   `admissible: False` (L146-203); `summarize_density` medians run over
   admissible rows only with >= 4/5 required per cell; and - the R1/R2
   improvement - `final_gates` splits every outcome into
   pass / geometric-kill / RESOURCE-INCONCLUSIVE (L653-675): a kill
   requires resource-valid evidence, so resource failures can produce
   neither a false pass NOR a false kill. The replay tripwire failure
   also forces all-rung inadmissibility (L907-909). PASS.
6. **Gates match the frozen plan.** Per-rung: both-cells admissible +
   strict saturation increase + strict all-event increase + None-safe
   relative deficit drift <= 0.20 + F4 error <= 0.05 at both densities
   (L567-625); adjacent-pair rule (L627-633); capability floor = narrow
   rung at N=12000, admissible AND median all-event >= 0.60 (L641-652);
   stage pass = pair AND capability (L665-667); clustered deficit formed
   from the median saturation with per-realization deficits archived
   (L517-521, L552-555) - pins NP1/NP3 implemented. PASS.
7. **Determinism and replay.** One spawned stream per (density,
   realization); dual-generator replay probe with failure forcing
   inadmissibility; phase-boundary peak + wall-time checks at relation,
   counts, candidates, every 32 streamed candidates, per-rung, AND the
   final record (the R1 fix); candidate arrays hashed
   (`candidate_content_sha256`, platform-stable encoding) and archived in
   full; raw + scientific hashes printed at write time with the R2
   canonicalization, which is itself archived inside `frozen_protocol`
   (L1031-1035). Seed/density/realization/duration hard-pinned in
   `run_benchmark` (L971-978) - any execution is the held-out run; run it
   exactly once. PASS.
8. **Phase firewall.** Imports carry no selector, overlap, operator,
   metric, or coordinate-control function; `selector_gate_open` and
   `operator_gate_open` are hard-false and `g2_closed` hard-true in the
   output; the API test greps the boundary. PASS.

## False-pass hunt (the specific brief)

- None resources -> inconclusive only (check 5). CLOSED.
- Zero bulk -> rung inadmissible (admissibility requires bulk_count > 0);
  cannot enter medians. CLOSED.
- Count off-by-one -> ceil-threshold unification + per-candidate
  carrier==stored-1 + live count equality. CLOSED.
- Candidate order -> no selection exists; unions are order-independent
  ORs; `test_candidate_processing_order_cannot_change_any_union` pins it;
  ordered arrays archived by hash for replay. CLOSED.
- Clustering -> admissible-only medians, >= 4/5 per cell, per-realization
  deficits archived. CLOSED.
- Phase gates -> every phase double-checked (time + memory) including
  final_record. CLOSED.

## Replay actually run

```text
sha256 checks: 3/3 MATCH (plan, implementation, tests)
python -m unittest <five suites>   # 60 tests OK
ruff check causal_atlas_scaling.py test_causal_atlas_scaling.py  # clean
# The benchmark itself was NOT executed; seed 2026071609 unopened.
```

## Nonblocking findings

- N1: `exact_factorization` multiplies both sides by `bulk_count`
  (L405-409) - a no-op; the tripwire is effectively
  `all_union_count == bulk_union_count`, which IS the intended identity
  given containment. Simplify when convenient; the floating check
  independently covers the coverage identity.
- N2: `core_carrier_containment_tripwire` is structurally always-true
  (the core is defined as carrier AND ...); harmless, but label it
  definitional in the benchmark note so it is not read as an independent
  check.
- N3: the F4 prediction uses z = 2(H/N)^(1/4) while bulk_fraction
  divides by N+1 - an O(1/N) mismatch (~0.01 percent), far below the
  0.05 gate; note it once for exactness.
- N4 (credit): the R2 pin round-trip (my BLOCK -> your re-pin with
  explanation) plus the resource-inconclusive/geometric-kill split are
  the provenance and gate-design standards this lane should keep.

## Blocking findings

None. Run the frozen benchmark exactly once; record both hashes at write
time (already implemented in main()).
