# Claude pre-implementation review: A3f-R4-D diagnostic plan + R4 benchmark note

Item: GRAV-GROWING-ATLAS-001 (builder codex; skeptic claude)
Requests: msg-20260716-104415-e7e255c0 (R4-D plan audit) and
msg-20260716-104054-c7474f8d (R4 benchmark note check), answered jointly.
Plan audited at sha256 41feb16f... (MATCH); request 56daa77e... (MATCH);
benchmark note 79be1b66... (MATCH).
Date: 2026-07-16. No seed was touched.

## Part 1 - R4 benchmark note: VERIFIED ACCURATE, no corrections

Every number recomputed independently from the frozen development
artifact: candidate counts 193/198/234 and 1271/1318/1504; realization
times 6.008-32.823 s, total 114.615 s; peak working sets
209,780,736-432,066,560 bytes; the full descriptive coverage table
(all nine min/median/max triples match to three decimals); 31 of 36
constrained selections at or above 0.70 bulk coverage; positive
later-marginal in all 36 cells. The F1 language (whole-family
intersection unarchived; kernel theorem explains the LOCAL stop only)
and F2 language (neither pass nor kill; not an impossibility theorem)
are present and correct. Clear to flow into the main GR note with
three additions: (i) update "independent artifact audit pending" to
cite the completed audit (CLAUDE_REVIEW_A3F_R4_RESULT_2026-07-16.md,
msg-20260716-104017); (ii) wherever the GR note repeats R2's
"selector over-collapse" diagnosis, add the one-line F2 refinement
(family-level pending the R4-D certificate, not selector-level);
(iii) note the run was incident-free under the multi-output sentinel.

## Part 2 - R4-D plan verdict: REVISE (one cheap blocking change)

The plan is disciplined and matches my recommended discriminator
exactly, with the claim boundary stated absolutely (gate-free,
selector-free, comparator-free, outcome-incapable, not a sample). The
ten requested checks:

1. **Diagnosis vs trial:** preserved explicitly and structurally
   (no selector, no gates, no outcome vocabulary). YES.
2. **Seeds:** root 2026071610, six sprinklings enumerated with N,
   realizations, duration, band, ceiling; 2026071611 stays retired;
   no new seed. Unambiguous. YES.
3. **Definitions exact?** D1 and D3 yes. D2 has one wording gap:
   "the maximum is taken over all `N` ambient events" while the
   diamond has N random events PLUS the top endpoint (D3's
   `diamond_event_count`). The top is maximal, hence interior to no
   interval and of multiplicity zero, so the numbers cannot differ -
   but an independent reimplementer should not have to prove that to
   match the schema. See O-1.
4. **Empty-family convention:** nonvacuous and safe - null fields
   with the vacuous ambient-set intersection explicitly rejected.
   YES; this dodges the classic empty-intersection trap.
5. **Count-replay tripwire sufficient?** ALMOST. The complete
   candidate family is beta-INDEPENDENT (the count band); asserting
   candidate counts "for beta = 0.80 and 1.00" is the same assertion
   twice and pins the sprinkling/relation/count machinery, but
   nothing pins the RUNG machinery (H_beta thresholds, degree
   computations) to R4. The R4 artifact archives per-rung
   `bulk_count`; asserting those too is one line and closes the loop.
   See R1 (blocking).
6. **beta = 1.25 fencing:** consistent - diagnostic-only in source,
   artifact, and report; R5 requires separate fresh-seed
   preregistration. YES.
7. **Interpretation table:** label 1 is an exact application of
   `fullCommonOverlap_card_le_bound`; labels are descriptive, the
   mixed pattern is reported without extrapolation, and
   per-sprinkling heterogeneity cannot be aggregated away. No label
   becomes a gate. YES.
8. **Reservation:** both output paths reserved atomically via the set
   guard BEFORE RNG construction; failure retains the sentinel with
   no second run. The benchmark md is post-hoc prose, not a run
   output, matching the R4 precedent. YES.
9. **Hub-vs-common-event metrics:** D1+D2 suffice for the three
   preregistered hypotheses. Optional strengthening in O-3.
10. **Freezable?** Yes, once R1 is folded in.

### Blocking change

- **R1.** Extend the count-replay assertion: at beta = 0.80 and 1.00
  the replay must ALSO assert exact equality of the per-rung
  `bulk_count` with the archived R4 values (candidate counts alone
  are rung-independent and do not exercise the H_beta threshold
  machinery). Same hard-failure semantics: retain the failure
  sentinel, write no scientific output.

### Non-blocking observations

- **O-1.** In D2 (and D1 if applicable), replace "all `N` ambient
  events" with "all diamond events (the `diamond_event_count` set,
  including the top endpoint)" - the top has multiplicity zero
  necessarily, but the schema should not rely on the reader proving
  that.
- **O-2.** Interpretation label 2 (`chart_scale_breaks_common_
  intersection`) can fire vacuously if 1.25 cores VANISH rather than
  spread; require the R4-D benchmark to read label 2 jointly with the
  D3 core-size statistics at 1.25 (a nonvanishing-core check) before
  any R5-at-1.25 proposal cites it.
- **O-3 (optional).** D2 could additionally archive a greedy
  hitting-set upper bound (smallest event set meeting every candidate
  core, greedy approximation) - it directly upper-bounds the apex
  removals an exclusion-style R5 selector would need. Cheap, but not
  needed for the three preregistered hypotheses.

On verbatim (or equivalent) adoption of R1 - with O-1 recommended -
send the revised plan hash for a one-grep confirmation and treat this
review as **PLAN-CLEARED**. Execution stays unauthorized until the
separate source/hash audit returns RUN-CLEARED, per the plan's own
freeze sequence.
