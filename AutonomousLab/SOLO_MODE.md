# Solo execution mode

Solo mode lets one interactive model operate AFPL for a bounded interval while
the other interactive model is intentionally paused. It exists for cost,
availability, and scheduling constraints. It is an execution mode, not a weaker
evidence standard.

Aristotle remains available as the formal proof, strategy, and audit service.
The human Research Director retains every decision right. AFPL does not invoke
Claude through an API; Claude solo mode means one user-started interactive
Claude Code session.

## Invariants

Solo mode does not rewrite project leads, work-item owners, skeptic assignments,
claim grades, or release gates. Those records express scientific responsibility
and required independence, so changing them merely to fit temporary model
availability would erase review debt.

During Claude solo mode:

- Claude may execute Claude-owned work, operate every scheduled role, harvest
  and integrate Aristotle results, and independently review Codex-built work
  whose registered skeptic family is Claude.
- Codex-owned execution work is paused unless the Research Director explicitly
  reassigns the item. Its leases and partial artifacts are preserved.
- A Claude role change can provide a useful self-audit but cannot independently
  certify Claude-built work.
- Reviews requiring the Codex/GPT family remain in `RED_TEAM` or `REPLICATING`
  and are displayed as `deferred by solo mode`.
- Aristotle may satisfy a registered proof-service audit, but it does not
  replace broad cross-family semantic review of physics or manuscript claims.
- Existing independently reviewed results retain their grades. New Claude-built
  headline results cannot cross a gate that requires Codex review until that
  review occurs.
- External release remains human-only.

The same rules apply with the interactive families swapped in Codex solo mode.

## Activate Claude solo mode

From the repository root:

```powershell
python AutonomousLab/scripts/labctl.py validate
python AutonomousLab/scripts/labctl.py mode-set solo `
  --active-model claude `
  --hours 12 `
  --model human `
  --reason "Conserve OpenAI tokens during the overnight Claude run."
python AutonomousLab/scripts/labctl.py handoff
python AutonomousLab/scripts/labctl.py mode
python AutonomousLab/scripts/labctl.py supervise
```

Then start one interactive Claude Code session:

```powershell
claude --model opus --effort max --permission-mode bypassPermissions --ide `
  --name AFPL-Claude-Solo `
  "Read AutonomousLab/prompts/CLAUDE_LAB_GOAL.md and begin the persistent AFPL loop in the execution mode recorded by labctl. In solo mode, execute Claude-owned work, keep every role cadence active, use Aristotle fully, review eligible Codex-built work, preserve all deferred Codex review debt, and leave a generated handoff before yielding."
```

`planned_end_at` is an operational deadline, not a background timer. The lab
does not start or stop model processes itself. Claude should surface an expired
solo interval through `labctl.py mode` or `supervise` and leave a handoff; the
Research Director or active Lab Manager explicitly changes the mode.

## Overnight operating loop

At startup and every bounded work-unit boundary, Claude runs:

```powershell
python AutonomousLab/scripts/labctl.py mode
python AutonomousLab/scripts/labctl.py supervise
python AutonomousLab/scripts/labctl.py role-status
python AutonomousLab/scripts/labctl.py review-queue
python AutonomousLab/scripts/labctl.py inbox --model claude
python AutonomousLab/scripts/labctl.py jobs
python AutonomousLab/scripts/labctl.py leases
```

Role cadence is unchanged. Family rotation is suspended only for the duration
of solo mode, allowing Claude to run successive Visionary, Lab Manager,
Archivist, Impact Strategist, Phenomenologist, and Educator activations. Every
generated role contract states that same-family review is not independent.

Claude should prioritize, in order:

1. overdue scheduled roles;
2. independent reviews of Codex-built artifacts routed to Claude;
3. harvest and refill of the Aristotle fleet;
4. dependency-ready Claude-owned execution work;
5. precise handoffs and review packets for work that must wait for Codex.

Claude does not clear Codex's mailbox, take over live Codex leases, or silently
change Codex-owned work. Durable requests to Codex may be sent normally and
will wait in the mailbox until collaborative mode resumes.

## Resume collaborative mode

```powershell
python AutonomousLab/scripts/labctl.py mode-set collaborative `
  --model human `
  --reason "Overnight solo interval complete; resume cross-family operation."
python AutonomousLab/scripts/labctl.py validate
python AutonomousLab/scripts/labctl.py review-queue
python AutonomousLab/scripts/labctl.py handoff
python AutonomousLab/scripts/labctl.py supervise
```

On resumption, the first Codex task is to clear the highest-priority deferred
review of Claude-built work before opening a new lower-priority execution lane.
The second task is to inspect any Codex-directed mailbox messages and expired
leases. No special merge or ownership repair should be necessary.
