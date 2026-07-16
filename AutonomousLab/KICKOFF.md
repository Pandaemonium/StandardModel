# Starting the collaborative or solo lab

AFPL is persistent and autonomous at the research-loop level, but it is not a
background daemon. Start one Codex session and one interactive Claude Code
session in the repository root. Each session reads the same durable lab state,
claims a distinct lane, works through bounded cycles, and leaves a handoff when
it yields.

For a bounded one-model run, activate solo mode first and start only the named
interactive executor. The full procedure and evidence boundary are in
[`SOLO_MODE.md`](SOLO_MODE.md). Solo mode keeps Aristotle available and defers,
rather than waives, reviews requiring the paused model family.

Both terminals begin each bounded work unit with:

```powershell
python AutonomousLab/scripts/labctl.py supervise
python AutonomousLab/scripts/labctl.py review-queue
python AutonomousLab/scripts/labctl.py role-status
python AutonomousLab/scripts/labctl.py leases
python AutonomousLab/scripts/labctl.py inbox --model <codex-or-claude>
```

Acquire a path lease before touching a shared artifact. At a context boundary,
the Lab Manager regenerates `state/HANDOFF.md` with `labctl.py handoff`; agents
do not maintain a competing prose status summary by hand.

Cross-agent requests are not considered delivered merely because they appear
in the ledger. Send them through `labctl.py send`; the recipient acknowledges
and claims actionable work through the mailbox before starting it.

## 1. Preflight

Run once before opening the agents:

```powershell
Set-Location C:\Projects\StandardModel
python AutonomousLab\scripts\labctl.py validate
python AutonomousLab\scripts\labctl.py mode
python AutonomousLab\scripts\labctl.py status
python AutonomousLab\scripts\labctl.py role-status
python AutonomousLab\scripts\labctl.py queue
python AutonomousLab\scripts\labctl.py due
python AutonomousLab\scripts\labctl.py jobs
python AutonomousLab\scripts\labctl.py dashboard
```

Do not start if validation fails. Resolve the state inconsistency first.

To start Claude alone overnight, use:

```powershell
python AutonomousLab\scripts\labctl.py mode-set solo `
  --active-model claude --hours 12 --model human `
  --reason "Conserve OpenAI tokens during the overnight Claude run."
python AutonomousLab\scripts\labctl.py handoff
```

Do not start Codex in that mode. Use the Claude command in `SOLO_MODE.md`.

## 2. Start Codex

The current Codex IDE session is already operating the active AFPL cycle. For
a fresh terminal session, use:

```powershell
codex -C C:\Projects\StandardModel -s danger-full-access -a never --search `
  "Read AutonomousLab/prompts/CODEX_LAB_GOAL.md and begin the persistent AFPL loop now. Do not stop at a plan: orient from live state, claim a dependency-ready lane, execute and verify useful work, update the ledger through labctl, and leave a complete handoff before yielding."
```

## 3. Start interactive Claude Code

Open a second terminal in the same repository and run:

```powershell
claude --model opus --effort max --permission-mode bypassPermissions --ide `
  --name AFPL-Claude `
  "Read AutonomousLab/prompts/CLAUDE_LAB_GOAL.md and begin the persistent AFPL loop now. Orient from live state, claim a lane that does not duplicate Codex, prioritize the Claude-owned DYN-MODULAR-001 work and pending cross-family audits, execute rather than merely propose, and leave a complete handoff before yielding."
```

The interactive Claude Code terminal is the lab's only Claude-family channel.
Do not launch Claude API or repository-wrapper review calls; coordinate through
`state/MESSAGES.json` and the shared work registry.

## 4. Concurrency discipline

- Codex is the default Lab Manager and sole direct writer of JSON registries
  unless a ledger entry explicitly transfers that role.
- Claude records claims, reviews, and lane ownership through `labctl.py log`,
  then asks the Lab Manager lane to apply JSON changes when Codex is active.
- Never edit the same manuscript section or Lean file concurrently.
- Builders and skeptics must be from different model families.
- Check `labctl.py jobs` before submitting Aristotle work and harvest completed
  jobs before launching replacements.
- Check `labctl.py role-status` at every bounded work-unit boundary. Claim the
  highest overdue periodic duty through `role-start`; do not merely announce a
  persona switch in chat.
- A model yielding is not the end of the lab. Resume its saved session or start
  a fresh one with the same persistent goal prompt; the files under
  `AutonomousLab/state/` are the institutional memory.

## 5. Current kickoff assignment

At the 2026-07-12 bootstrap, Codex is the Lab Manager and implementation lane.
Claude should first:

1. independently red-team `GAUGE-COV-001` using
   `work/NE-GAUGE-CHIRAL/CODEX_GAUGE_COV_AUDIT_REQUEST.md`;
2. continue the Claude-owned `DYN-MODULAR-001` maximum-entropy uniqueness gate;
3. audit `L0-DIST-001` against the primary-source memo without promoting a
   Poisson-uniqueness statement that the literature does not prove.

After those items, both agents return to `labctl.py queue` and select the next
dependency-ready, nonduplicative lane.
