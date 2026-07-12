# Research Director decision queue

Pending human-only decisions, newest at the bottom of each section. Agents
append entries with context and a stated default; only the Research Director
clears them (move to `DECISIONS.md` or annotate disposition inline). Silence
is never approval; a stale entry is surfaced by `labctl.py due` review
cadences, not acted on.

Entry format: ID, date, requested-by, decision needed, context, default if no
answer (default = safest inaction, never external release).

## Open

### DQ-001 Commit the 2026-07-12 run tree (2026-07-12, codex+claude)

The publication-run edits (Lambda paper + guards, T1 fermionic fork, Paper C
marks, run reports) and the new `AutonomousLab/` tree are uncommitted. Agents
do not auto-commit. Decision: commit (and whether AutonomousLab lands in the
same or a separate commit). Default: tree stays dirty; nothing ships.

### DQ-002 Dispose LAB-BOOTSTRAP-001 cross-family review (2026-07-12, claude)

Claude (Fable, interactive) performed the cross-family red-team of the AFPL
bootstrap and applied repairs (see `work/LAB-INFRA/` report and ledger).
Codex built the framework; Claude reviewed and co-edited it, so final
integration should be confirmed by you or by Codex re-review of the repairs.
Decision: accept the claude review as satisfying the independence gate and
authorize INTEGRATED after Codex confirms the repairs. Default: item stays in
RED_TEAM.

### DQ-003 Lambda paper release decisions (2026-07-12, claude)

T1 (fermionic fork) landed kernel-clean, so the review's condition for a
standalone paper is met. Decisions: named authors; standalone vs P9 section;
venue; completion of the secondary-reference primary-source pass (3
load-bearing citations verified, ~9 secondary remain). Default: internal
draft only.

### DQ-004 Named authors on all manuscripts (2026-07-12, claude)

Every manuscript carries a release-gate placeholder or single-name author
line. Decision: final author lists, affiliations, AI-use disclosure text.
Default: no external circulation.

### DQ-005 Venue selections for frozen papers (2026-07-12, claude)

Prior portfolio analysis recommends: E -> Quantum; A -> focused headline cut
to Quantum with formalization companion (math-phys fallback); FB -> arXiv +
Annals of Formalized Mathematics (AACA alternative); C -> specialist theorem
venue. Decision: confirm or redirect. Default: no submission.

### DQ-006 Opus wrapper restoration (2026-07-12, claude)

BLK-001: the wrapper API path lacks credit and the Pro path is not
authenticated inside the isolated wrapper. The interactive Claude lane now
covers Claude-family review, so this is no longer promotion-blocking.
Decision: restore wrapper billing/auth (for logged batch reviews) or accept
interactive-lane-only Claude review for now. Default: wrapper stays down;
interactive lane carries review.

## Resolved

(none yet)
