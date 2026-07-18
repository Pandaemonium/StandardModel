# Claude source/hash audit: A3f-R5 implementation

Item: GRAV-GROWING-ATLAS-001 (builder codex; skeptic claude)
Request: msg-20260716-123741-1a742906, answering
`AgentTasks/null-edge-growing-atlas-stage-a3f-r5-implementation-review-request-2026-07-16.md`
(sha256 6e244c72..., MATCH).
Date: 2026-07-16. No sprinkling was constructed and no R5 output path
exists; fresh seeds 2026071612/13 remain unconsumed.

## Verdict: RUN-CLEARED

The exact frozen command in the request is cleared for its single
execution at the displayed hashes. Any subsequent edit to any pinned
file invalidates this clearance; any failed run retains its sentinel
with no second run; artifacts return for the post-run audit before any
interpretation.

## Verification performed

- All SEVEN pins MATCH on disk (plan cab93a70, source 5a209af3, tests
  fbc3b25e, R4 source e88f7b1b, R4-D source b73b3670, guard d6364ee0,
  theorem module a71bc4a0).
- Replayed the full 129-test nine-module suite: OK in my environment;
  Ruff clean on both new files. The pinned Lean module was
  independently kernel-checked EXIT 0 earlier today at the same hash
  and sits in the import graph of every green build since.
- Full read of the 720-line implementation and the 19 R5 test names
  (each maps onto a blocking question, including the sharp ones:
  diagnostic-poison immunity, per-rung bulk scoring, unreviewed-rung
  rejection, resource overwrite never classifying diagnostics,
  reservation-before-runner, R4 canonicalization).

## The ten questions - all YES

1. **Frozen R4 machinery unchanged:** the module imports
   `causal_growing_atlas as r4` and calls `r4.evaluate_capacity_cell`,
   `r4.extended_atlas_metrics`, `r4.summarize_cell`,
   `r4.resource_failure_cells`, `r4.materialize_candidate_carriers`,
   `r4.atlas_size`, `r4.content_sha256`; every threshold and ceiling is
   an `r4.*` alias. Selector, controls, metrics, and cell taxonomy
   execute inside the hash-pinned R4 code; no reimplementation exists
   to drift.
2. **beta 1.25 the only decision-visible rung:** `_cell_rows` filters
   on `PRIMARY_BETA` and RAISES if the matched rung's decision role is
   not result-bearing; development, held-out, drift, and stage outcome
   all consume `_cell_rows` only.
3. **Diagnostic cells decision-free:** `diagnostic_capacity_cell`
   strips exactly `outcome`/`inadmissible_reasons`/`gates` (data
   preserved under renamed archival keys), adds the descriptive
   reach/hostility flags and mechanism label; nothing from the 1.00
   rung reaches any decision path, and the resource-overwrite sweep
   assigns outcomes only to primary cells.
4. **Per-rung bulk:** `evaluate_rung` computes `bulk` from ITS beta
   and passes it into the R4 cell evaluator - the PLAN-CLEARED R1
   wording implemented structurally; a dedicated test pins it.
5. **Family facts first, one-directional labels:**
   `summarize_complete_family` runs before the unconstrained greedy
   and all cells; `certificate_dead` fires only on a nonempty
   intersection; the two empty-intersection labels are named as
   selector-specific; empty family yields no label.
6. **Shared sprinkling, disjoint streams:** one sprinkling per record
   shared by both rungs; per-rung/per-cap greedy and five control
   streams spawned with exact cursor accounting; development and
   held-out roots differ by seed; disjointness and replay are tested.
7. **R4 semantics preserved:** W2 asymmetry and E1/E2 taxonomy live
   inside the pinned `r4.evaluate_capacity_cell`; development FAIL>=2
   decisiveness and held-out four-of-five plus FAIL>=2 are copied
   verbatim (single-rung form per the plan); timeout/memory sweeps,
   structurally distinct resource cells, min-qualifying-cap selection,
   and the held-out retirement record all match R4.
8. **Reservation and immutable bytes:** the set reservation wraps the
   runner - acquired before `run_phase`, hence before any
   seed/RNG/sprinkling work; the guard's rollback and retained-failure
   semantics were audited this morning; and the immutable-byte rule is
   now OPERATIONALIZED: `.pre-commit-config.yaml` excludes
   `^AgentTasks/.*\.json$` from every mutating hook (end-of-file, BOM,
   mixed-line-ending, trailing-whitespace) - the R4-D line-ending
   event cannot recur on frozen artifacts.
9. **Hashes before reservation, into the sentinel:** all seven
   verified in `main` before `execute_reserved_benchmark`; metadata
   carries them plus protocol and seeds.
10. **Claim boundary:** the development payload embeds the
    finite-atlas/nerve-only boundary; the protocol block records the
    primary/diagnostic split, gate-inert hostility flag, and immutable
    byte policy; G2 and downstream stay closed per the PLAN-CLEARED
    plan.

## Non-blocking observation

- `diagnostic_resource_failure_cells` sets
  `unexpected_nonhostile_control: false` for resource-failed
  diagnostic cells; semantically "not observed" rather than "false"
  might deserve `null` - but `mechanism_label: None` and the runtime
  note already record non-observation, so no change is required.
