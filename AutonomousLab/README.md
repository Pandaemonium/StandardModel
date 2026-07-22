# Autonomous Fundamental Physics Lab

The Autonomous Fundamental Physics Lab (AFPL) is the persistent research
organization for this repository. It replaces isolated overnight runs with a
continuous, stateful, self-correcting laboratory operated by Codex,
interactive Claude Code sessions such as Fable, Aristotle, and a human
Research Director. Review independence is judged by model family: Codex/GPT,
Claude, and Aristotle. AFPL does not use a Claude API or batch review wrapper.
The control plane supports both collaborative operation and a bounded solo mode
that pauses one interactive family without waiving its review obligations.

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
- Atomic work items form an explicit dependency/evidence graph; file leases
  prevent concurrent overwrite, and generated handoffs expose stale state.
- A bounded read-only supervisor recommends one control action per pass rather
  than running an opaque open-ended orchestration loop.

## Start here

For the exact two-terminal Codex + interactive Claude startup procedure, see
[KICKOFF.md](KICKOFF.md). For a one-terminal overnight run, see
[SOLO_MODE.md](SOLO_MODE.md).

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
   (`CODEX_LAB_GOAL.md` or `CLAUDE_LAB_GOAL.md` for the user-started
   interactive Claude Code session).

Quick status:

```powershell
python AutonomousLab/scripts/labctl.py validate
python AutonomousLab/scripts/labctl.py mode
python AutonomousLab/scripts/labctl.py status
python AutonomousLab/scripts/labctl.py role-status
python AutonomousLab/scripts/labctl.py queue
python AutonomousLab/scripts/labctl.py review-queue
python AutonomousLab/scripts/labctl.py inbox --model codex
python AutonomousLab/scripts/labctl.py due
python AutonomousLab/scripts/labctl.py jobs
python AutonomousLab/scripts/labctl.py leases
python AutonomousLab/scripts/labctl.py supervise
python AutonomousLab/scripts/labctl.py handoff --check
```

Live monitoring dashboard:

```powershell
python AutonomousLab/scripts/labctl.py dashboard
```

Then open `http://127.0.0.1:8765`. The dashboard is a read-only view over the
authoritative files in `state/`; it refreshes in the browser, validates the
registries on every API snapshot, and exposes role cadence, project gates,
work-state flow, Aristotle jobs, claims, mailboxes, agent availability, and the
recent ledger. It does not maintain a second copy of lab state. Use `--port`
to choose another local port when 8765 is occupied.

Send and claim an exact review request:

```powershell
$message = python AutonomousLab/scripts/labctl.py send `
  --from codex --to claude --kind review --priority high `
  --item CONT-LIVE-001 --subject "Audit live-walk composition" `
  --message "Check the preregistered normalization and scope gates." `
  --artifact AutonomousLab/work/NE-CONTINUUM/CODEX_CONT_LIVE_AUDIT_REQUEST.md `
  --command "lake build PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk"

python AutonomousLab/scripts/labctl.py ack $message --model claude
python AutonomousLab/scripts/labctl.py claim-message $message --model claude --hours 4
python AutonomousLab/scripts/labctl.py complete-message $message `
  --model claude --note "Verdict recorded in linked red-team report."
```

Register Aristotle jobs through the transaction-safe control surface:

```powershell
python AutonomousLab/scripts/labctl.py job-register 1234abcd `
  --work-item DYN-MODULAR-001 --title "Focused theorem" `
  --notes "Full project id and package path." --model claude
```

Before editing a shared path, acquire a short lease:

```powershell
python AutonomousLab/scripts/labctl.py lease `
  PhysicsSM/Draft/NullEdge/GateC2 `
  --work-item GAUGE-COV-001 --model codex --hours 4
```

Generate a clean-context reproduction packet or refresh the handoff:

```powershell
python AutonomousLab/scripts/labctl.py repro-manifest CONT-PROJ-001
python AutonomousLab/scripts/labctl.py handoff
```

Periodic role duties are tracked in `state/ROLE_SCHEDULE.json`. Start a duty
through `labctl` so the correct packet, deadline, model-family rotation, and
deliverable contract are recorded together:

```powershell
python AutonomousLab/scripts/labctl.py role-start visionary `
  --model claude --hours 1 --project NE-CONTINUUM

python AutonomousLab/scripts/labctl.py role-start impact_strategist `
  --model codex --hours 1.5 --project LAB-INFRA

python AutonomousLab/scripts/labctl.py role-complete <activation-id> `
  --model codex --artifact <contracted-deliverable-path> `
  --summary "Ranked impact gates and queue recommendation delivered."
```

Visionary is due every 3 hours; Impact Strategist every 6 hours. Archivist is
due every 6 hours, Lab Manager every 3 hours, and Educator/Phenomenologist every
12 hours. Scientist work is continuous; Skeptic and Reproducer are triggered by
promotion gates. `labctl.py supervise` puts overdue periodic duties ahead of
ordinary queue replenishment. The legacy role key `superstar` remains accepted,
but operators should use the visible alias `impact_strategist`.

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
  state/                         persistent memory, claim graph, leases, handoff
  dashboard/                     local read-only HTML operations console
  scripts/                       validation and prompt-packet tools
  tests/                         orchestration tests
  work/                          project workspaces created from templates
```

The repository-wide `AGENTS.md` remains superior to this directory. If an AFPL
procedure conflicts with it, `AGENTS.md` wins and the Lab Manager records an
incident and proposes a correction.

## Active campaign overlay

For the Director's 2026-07-21 ten-day absence, both interactive agents also
read
[`prompts/TEN_DAY_GRAND_CHALLENGE_ROADMAP_2026-07-21.md`](prompts/TEN_DAY_GRAND_CHALLENGE_ROADMAP_2026-07-21.md).
The overlay sets temporary scientific priorities, launch gates, resource
envelopes, and return artifacts. It does not replace the charter or convert
AFPL into a background daemon; continuity still requires a tested host-side
supervisor or long-lived sessions with recovery instructions.
