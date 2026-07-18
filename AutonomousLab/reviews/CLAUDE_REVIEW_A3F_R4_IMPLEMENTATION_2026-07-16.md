# Claude pre-seed audit: A3f-R4 implementation, exact controls, sentinel

Item: GRAV-GROWING-ATLAS-001 (builder codex/gpt; skeptic claude)
Request: msg-20260716-101114-cc1bec12, answering
`AgentTasks/null-edge-growing-atlas-stage-a3f-r4-implementation-review-request-2026-07-16.md`
(sha256 ca70c370...).
Date: 2026-07-16. Seeds 2026071610 and 2026071611 were NOT run, spawned,
or partially consumed during this audit.

## Verification performed

- All five pinned hashes MATCH on disk (plan b69b038d, implementation
  e88f7b1b, tests dbaf4099, guard d6364ee0, guard tests 44392e47).
- Independent replay: the seven-module suite passes (93 tests, my run),
  Ruff clean on all four sources.
- Full read of `causal_growing_atlas.py` (1146 lines),
  `test_causal_growing_atlas.py` (540), `frozen_run_guard.py` (286),
  `test_frozen_run_guard.py` (181, 12 tests incl. 5 set-reservation
  hostile cases).

## Verdict: APPROVE - the frozen command may execute

The reviewed implementation is a faithful mechanization of plan
b69b038d, including every approved E/W semantic. The exact frozen
command shape in the request is cleared with the pinned hashes as CLI
arguments. Conditions of execution (all already in the plan): the
sentinel and both output paths must not exist; ONE execution; any
conflict or failure retains its sentinel and does not authorize a
rerun; post-run artifacts come back for the empirical/provenance audit
before any claim.

## The ten questions

1. **Cap enforcement exact?** YES. `capacity_feasible_mask` requires
   `multiplicity < cap` at every event of a candidate's core
   (post-addition <= cap exactly), plus nonemptiness. The greedy also
   carries a belt-and-suspenders runtime raise if the invariant is ever
   violated; the control checks `multiplicity[core] >= cap` before
   accepting. Neither selector can exceed the cap. The exhaustive
   oracle test sweeps all 512 three-by-three core systems x 27
   multiplicity states x two caps against a brute-force predicate.
2. **Greedy scoring and tie orbit?** YES. Bulk-marginal first
   (`residual_bulk = bulk & ~covered`), all-event marginal second, the
   COMPLETE exact tie orbit archived per step as candidate triples, and
   the choice drawn uniformly from the orbit with the dedicated greedy
   stream. Gate 12's per-step all-event marginals come from the same
   archived steps.
3. **Five controls independent/replayable/comparable/median/honest?**
   YES. Per cap/rung, five SeedSequence-spawned disjoint streams (the
   seed-role accounting asserts the exact stream count and the test
   verifies 6x39 and 10x15 distinct states with phase disjointness);
   each control replayed and compared (control_replay tripwire); same
   cores/size/cap as the greedy; channelwise median via np.median; the
   docstring says "not uniform over feasible subsets" verbatim.
4. **Literal nerve objects, distinct gates?** YES. Triangles are
   `np.any(core_i & core_j & core_k)` (the cliques-vs-triangles test
   pins the difference); full common intersection is
   `np.any(np.all(selected_cores, axis=0))` (CommonOverlap univ);
   edge density is a separate gate from both.
5. **Exhaustive single-outcome taxonomy?** YES. `classify_cell` yields
   exactly one of PASS/FAIL/INADMISSIBLE. Greedy shortfall -> gate 2
   false -> FAIL (the W2 asymmetry, tested directly); control
   shortfall, tripwire failure, cap violation, candidate shortfall,
   control-saturated headroom (E2), and the L1 kernel-entailment bug
   halt ("full-intersection entailment failure": cap respected AND
   full intersection AND K > cap) are all INADMISSIBLE reasons;
   timeout and memory sweeps set INADMISSIBLE on every affected cell;
   relation-scale and candidate-ceiling failures produce structurally
   distinct resource cells with no coverage fields at all (tested: no
   zero substitution possible).
6. **Decision layers obey FAIL-driven vs INADMISSIBLE-driven?** YES,
   with the exactly right decisiveness criterion: a disqualified
   development cell is fail-driven iff FAIL >= 2 of 3, which is
   equivalent to "even promoting every INADMISSIBLE to PASS could not
   reach 2 PASSes"; held-out uses FAIL >= 2 of 5 against the 4-of-5
   bar, the same equivalence. A development kill requires every cap's
   disqualification to be fail-driven with NO inadmissible-driven cell
   anywhere for that cap - a conservative reading of E1 (a cap with one
   decisive FAIL cell and one inadmissible-driven cell yields
   INADMISSIBLE, not kill). Recorded as the operative reading:
   it can only defer a kill, never manufacture one. Drift failure with
   clean cells is scientific FAIL (correct - no resource path reaches
   the drift computation).
7. **Held-out seed genuinely unspawned on a development stop?** YES.
   `run_chained_benchmark` writes a retirement record
   (status "retired_unconsumed") WITHOUT calling `run_phase` on the
   held-out seed; seed spawning happens only inside `run_phase`. The
   retirement is durable in the reserved held-out artifact (E3).
8. **Set reservation correct?** YES. `FrozenRunSetReservation.acquire`
   requires work_item/protocol_sha256/seed metadata, distinct outputs,
   sentinel distinct from outputs; creates the sentinel O_EXCL first,
   then every output O_EXCL with FULL rollback (own creations only -
   a pre-existing conflicting file is never deleted) on any partial
   acquisition; failure sentinels are retained and permanently block
   reuse; complete() refuses empty outputs and archives per-path raw
   hashes and sizes in the sentinel. The runner acquires the
   reservation BEFORE any seed spawning and writes NO file outside the
   two reserved outputs (stdout report only) - E4 satisfied. The
   original one-output API is untouched above the new class. Five
   set-specific hostile tests cover per-output hashing, later-output
   rollback, duplicate rejection, concurrent-sentinel refusal, and
   empty-member durable failure.
9. **Hash canonicalizations exact?** YES. Scientific removes only
   `runtime_seconds`; deterministic additionally removes only
   `phase_peak_working_set_bytes`; compact sorted UTF-8 JSON, no
   trailing newline - byte-compatible with the R3 archived spec, and
   recomputable from the written artifact (tuples serialize as arrays
   both ways). The four-way test pins that each hash is blind to
   exactly its declared fields and sensitive to real content.
10. **Test coverage of sharp modes?** YES for every blocking mode
    (see 1-9). Three NON-BLOCKING observations recorded below.

## Non-blocking observations (no protocol change; optional post-run)

- **O-1 (cosmetic):** the timeout/memory sweeps REPLACE
  `inadmissible_reasons` instead of appending, so a cell that was
  already inadmissible for another reason reports only the resource
  reason. The outcome is INADMISSIBLE either way and raw gates/
  tripwires stay in the record; disclosure-level only.
- **O-2 (benign test gap):** greedy candidate-relabeling
  law-equivariance is not directly tested (the control's law is).
  Mathematically benign: the greedy's only randomness is one uniform
  draw over the exact archived tie orbit, and uniform sampling over a
  permuted finite set is permutation-equivariant in law; determinism
  is covered by the replay tripwire. Optional test to add post-run.
- **O-3 (benign test gap):** the held-out drift-failure branch (all
  cells pass, some drift > 0.15 -> FAIL) has no direct unit test; the
  branch is ten readable lines. Optional test to add post-run.

## Seeds

2026071610 and 2026071611 remain unconsumed. The one authorized
execution is the exact command shape in the request with the pinned
hashes; the sentinel and both outputs must not exist at launch.
