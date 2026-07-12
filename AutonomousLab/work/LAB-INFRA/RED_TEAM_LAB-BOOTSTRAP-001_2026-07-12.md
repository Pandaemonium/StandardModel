# Red-team report

- Claim/artifact: `LAB-BOOTSTRAP-001` -- "The lab has persistent validated
  state, role separation, executable prompt assembly, and tested operating
  procedures." (the AFPL framework under `AutonomousLab/`)
- Builder: Codex (Lab Manager)
- Skeptic: Claude (Fable, interactive session) -- cross-family review
  (Codex/GPT builder, Claude-family skeptic)
- Date: 2026-07-12
- Promotion requested: VERIFYING -> INTEGRATED

## Precise restatement

The AutonomousLab directory constitutes a persistent, validated,
role-separated operating framework that the repository's agents can actually
run: state files validate, prompts route real agents into real roles, the
review gates are executable rather than aspirational, and the design is
grounded in verifiable external sources.

## Findings ordered by severity

1. **Agent roster mismatch (repair applied).** The framework modeled the
   Claude side only as "opus" (the review wrapper, degraded per BLK-001).
   The lab's actual strongest Claude presence -- interactive Claude Code
   sessions (Fable), which co-executed the prior runs -- had no model entry,
   no role overlays, no entry prompt, and could not appear in
   `owner_model`/`skeptic_model`. As designed, cross-model review was
   deadlocked from day one. Repair: `claude` added as a first-class agent
   (overlays, prompt, labctl/build_role_packet rosters); independence
   redefined and enforced by **model family** (interactive Claude and the
   Opus wrapper are one family and are not independent of each other);
   Aristotle marked as a service that cannot own work items.
2. **Quorum deadlock on the bootstrap itself (this report is the repair
   path).** `LAB-BOOTSTRAP-001` awaited an Opus review that BLK-001 blocks.
   This report is the cross-family review; final integration still requires
   Codex or Research Director confirmation of the repairs, since the skeptic
   co-edited the framework (DQ-002).
3. **No Research Director interface (repair applied).** Human-only decisions
   had no queue. Repair: `state/DIRECTOR_QUEUE.md` seeded with the six
   currently pending decisions (DQ-001..DQ-006).
4. **Concurrent-write hazard undocumented (repair applied).** Prior runs lost
   updates when two agents edited shared files; hand-written ledger
   timestamps drifted from wall clock twice (the bootstrap ledger's own
   11:35/12:10/12:25 entries were stamped ahead of the 11:45 wall clock).
   Repair: single-writer convention and labctl-only ledger appends
   (system-clock stamps, `%z` offset) in `AGENTS.md`/`OPERATING_SYSTEM.md`;
   `labctl log` added.
5. **Cadence had no execution mechanism (repair applied).** `last_reviews`
   was null with nothing computing overdue. Repair: `labctl due`,
   `review-done`, `availability`, `probe`.
6. **Forecasts recorded but never scored (repair applied).** Repair:
   `labctl transition` now auto-appends resolution records to
   `state/FORECASTS.json` on first entry to
   INTEGRATED/RELEASED/KILLED/RETRACTED.
7. **Aristotle fleet and claims had no registries (repair applied).** Repair:
   `state/ARISTOTLE_JOBS.json` (seeded with the six known jobs; fleet cap
   validated) and `state/CLAIMS.json` (canonical claim registry, seeded from
   HONEST_SCORECARD; EVIDENCE_MODEL section 6).
8. **Minor (repairs applied):** work items lacked the template's
   `resource_ceiling` (now schema-required); root `AGENTS.md` had no pointer
   to the lab; five-year "required outcomes" invited grading against
   aspirational lists (renamed "target outcomes" with a binding-exam note);
   pivot quorum was unsatisfiable under degradation (fallback added);
   `M+E -> M` retrofits had no representation (trust-upgrade rule added);
   archivist lacked a source-as-data prompt-injection rule (added);
   fresh-context hostile review underweighted (quarterly requirement added,
   with the T1 empirical basis); process-maintenance burden not measured
   (monthly report question 9).

## Counterexamples and independent commands

- Wall-clock drift: `date` at 11:45 -07:00 vs ledger entries stamped 12:10
  and 12:25 the same morning.
- Independence deadlock: `LAB_STATE.json` availability showed opus degraded
  while every work item's skeptic pairing required opus.
- Independently rerun: `labctl.py validate`, `status`, `queue`, unit tests
  (all passing before and after repairs; see ledger).

## Source and convention audit

All five external design sources in `RESEARCH_BASIS.md` verified as real,
including the two post-2025 items: Co-Scientist (Nature 2026,
s41586-026-10644-y; arXiv 2502.18864) and EvoScientist (arXiv 2603.08127).
No fabricated citations found. Framework conventions consistent with
repository `AGENTS.md`; the lab correctly subordinates itself.

## Controls and nonvacuity

The framework is non-vacuous: state validation rejects malformed input (new
negative tests: same-family pairs, aristotle ownership), the transition graph
is total over statuses (new closure test), and the role-packet assembler
produces packets for all four models (tested).

## Overclaim checklist

- [x] vacuity -- checked; validation and gates are executable, not prose
- [x] hollow telescoping -- checked; the framework claims operations, not science
- [x] docstring/proof mismatch -- checked; README promises match tooling after repairs
- [x] false shape -- the roster mismatch was a false shape of "cross-model review"; repaired
- [x] convention drift -- checked against repository AGENTS.md
- [x] source laundering -- citations verified in primary sources
- [x] finite-to-continuum slippage -- n/a (infrastructure claim)
- [x] fitted-to-predicted relabeling -- n/a
- [x] common-form-to-common-origin inflation -- n/a

## Verdict

Repair required -- repairs applied in-session by the skeptic. Because the
skeptic thereby co-edited the artifact, this report does NOT self-certify
integration: `LAB-BOOTSTRAP-001` stays in RED_TEAM until Codex or the
Research Director confirms the repairs (DQ-002), then REPLICATING via a
clean-checkout `validate` + unit-test run by an agent that did not edit the
framework.

## Minimum repair

Applied (findings 1, 3-8). Remaining to clear: independent confirmation of
the repairs and the replication run described above.
