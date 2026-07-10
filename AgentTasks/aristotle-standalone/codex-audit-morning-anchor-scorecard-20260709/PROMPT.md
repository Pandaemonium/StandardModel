# codex-audit-morning-anchor-scorecard-20260709

You are Aristotle auditing the morning manuscript/scorecard surface for the
NullEdge all-mass run.

## Context

The package contains:

- Latest Claude/Codex landed Lean surfaces:
  - `Goal3ExactRG.lean`
  - `Goal3ChannelRG.lean`
  - `Goal3ChannelRG4.lean`
  - `Goal1Hadron.lean`
  - `Goal1Rung5Tie.lean`
  - `SuiteAOp2Geom.lean`
- Morning reporting artifacts:
  - `AgentTasks/overnight-allmass-run-2026-07-09/HONEST_SCORECARD.md`
  - `AgentTasks/overnight-allmass-run-2026-07-09/MORNING_REPORT.md`
  - `AgentTasks/overnight-allmass-run-2026-07-09/LEDGER.md`
  - `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`

Codex is audit lead. We need a fast independent check before the 6am hard audit
switch.

## Audit task

Review whether the morning report, honest scorecard, ledger summaries, and
manuscript anchor rows accurately reflect the Lean files. Do not try to prove
new theorems. This is a semantic/claim-scope audit.

Use the four over-claim modes:

1. vacuity,
2. hollow telescoping,
3. docstring outruns kernel,
4. false shape.

## Specific checks

- For `Goal3ExactRG`, does any prose overstate the finite rational RG line as a
  continuum fixed point, or overstate the interpretive `nu=1`/`z=1` readings?
- For `Goal3ChannelRG` and `Goal3ChannelRG4`, do the reports correctly say
  "finite rational channel-coordinate evidence" rather than a continuum
  universality theorem?
- For `Goal1Hadron` plus `Goal1Rung5Tie`, does every summary preserve the
  correction that closure energy is negative but the actual closure share is
  nonnegative?
- For `SuiteAOp2Geom`, does every summary keep the 2-point witness scope and
  avoid claiming full Malament reconstruction?
- Do the scorecard and manuscript rows distinguish landed M anchors from held
  build-cost handoffs?

## Required output

Return:

- PASS/FAIL for each artifact: `HONEST_SCORECARD.md`, `MORNING_REPORT.md`,
  `LEDGER.md`, and the manuscript anchor rows.
- Exact lines or declaration names needing correction.
- Any missing caveat that must be inserted before co-signing the scorecard.
- A short recommended ledger entry.
