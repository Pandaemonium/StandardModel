# Autonomous Fundamental Physics Lab

The Autonomous Fundamental Physics Lab (AFPL) is the persistent research
organization for this repository. It replaces isolated overnight runs with a
continuous, stateful, self-correcting laboratory operated by Codex, the
Claude family (interactive Claude Code sessions such as Fable, plus the Opus
review wrapper), Aristotle, and a human Research Director. Review
independence is judged by model family: Codex/GPT, Claude (interactive and
wrapper are one family), and Aristotle.

## North Star

Within five years, produce and subject to hostile testing a complete candidate
description of fundamental physics: a mathematically coherent account of
quantum matter, interactions, spacetime, and gravity that recovers the
established domains of quantum field theory and general relativity, explains
or sharply reframes major open problems, and makes distinctive falsifiable
predictions.

This is an aim, not a promised result. A decisive no-go theorem, failed
continuum gate, or empirical contradiction is a valid and publishable outcome.
The lab must never redefine "complete" to protect its preferred theory.

## What is different from an autonomous run

- Persistent state survives context windows and model sessions.
- A portfolio balances foundational work, risky synthesis, controls,
  replication, simulation, and publications.
- Every project has a builder from one model family and a skeptic from
  another (enforced by `labctl.py validate`).
- Roles are separated: Scientist, Skeptic, Visionary, Phenomenologist,
  Reproducer, Impact Strategist, Educator, Archivist, and Lab Manager cannot
  silently certify their own work.
- Aristotle is used for proofs, theorem design, counterexamples, and formal
  audits, but Lean's kernel and semantic review remain the trust basis.
- Quarterly and annual gates can stop, merge, or redirect programs.
- The lab measures calibration, reproducibility, blocker age, and scientific
  information gained, not paper or theorem volume alone.

## Start here

1. Read [CHARTER.md](CHARTER.md).
2. Read [FIVE_YEAR_PLAN.md](FIVE_YEAR_PLAN.md) and
   [SCIENCE_ROADMAP.md](SCIENCE_ROADMAP.md), then
   [OPEN_MYSTERIES.md](OPEN_MYSTERIES.md).
3. Read [OPERATING_SYSTEM.md](OPERATING_SYSTEM.md) and
   [GOVERNANCE.md](GOVERNANCE.md). Archivists also read
   [LITERATURE_AND_KNOWLEDGE.md](LITERATURE_AND_KNOWLEDGE.md).
4. Inspect `state/LAB_STATE.json`, `state/PORTFOLIO.json`, `state/LEDGER.md`,
   and `state/DIRECTOR_QUEUE.md` (pending human-only decisions).
5. Enter through the appropriate model prompt under `prompts/`
   (`CODEX_LAB_GOAL.md`, `CLAUDE_LAB_GOAL.md` for interactive Claude,
   `OPUS_LAB_GOAL.md` for the review wrapper).

Quick status:

```powershell
python AutonomousLab/scripts/labctl.py validate
python AutonomousLab/scripts/labctl.py status
python AutonomousLab/scripts/labctl.py queue
python AutonomousLab/scripts/labctl.py due
python AutonomousLab/scripts/labctl.py jobs
```

Build a role packet:

```powershell
python AutonomousLab/scripts/build_role_packet.py `
  --model codex --role research_scientist --project NE-CONTINUUM
```

## Directory map

```text
AutonomousLab/
  CHARTER.md                     mission and constitution
  FIVE_YEAR_PLAN.md              annual outcomes and hard exams
  SCIENCE_ROADMAP.md             physics programs and dependency graph
  OPEN_MYSTERIES.md              prioritized fundamental-physics questions
  LITERATURE_AND_KNOWLEDGE.md    Archivist workflow for sources and indexes
  OPERATING_SYSTEM.md            continuous research lifecycle
  GOVERNANCE.md                  authority, quorum, conflict, escalation
  EVIDENCE_MODEL.md              claims, readiness, and promotion rules
  METRICS_AND_META_SCIENCE.md    productivity and procedure experiments
  SAFETY_AND_AUTHORITY.md        autonomy boundaries and human decisions
  RESEARCH_BASIS.md              external design research and sources
  roles/                         shared personalities and model overlays
  prompts/                       persistent entry prompts for each model
  templates/                     project, theorem, experiment, and review forms
  state/                         persistent machine-readable lab memory
  scripts/                       validation and prompt-packet tools
  tests/                         orchestration tests
  work/                          project workspaces created from templates
```

The repository-wide `AGENTS.md` remains superior to this directory. If an AFPL
procedure conflicts with it, `AGENTS.md` wins and the Lab Manager records an
incident and proposes a correction.
