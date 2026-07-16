# Clean-context replication: LAB-BOOTSTRAP-001

- Work item: `LAB-BOOTSTRAP-001`
- Builder: Codex / Lab Manager
- Cross-family skeptic: interactive Claude (Fable)
- Clean reproducer: ephemeral Codex context with no conversation history
- Date: 2026-07-12
- Verdict: PASS for the preregistered technical success criterion

## Criterion

The authoritative work-item criterion is:

> All required documents exist; labctl validate and unit tests pass;
> repository document map points to AFPL.

The reproduction also exercised role-packet assembly because executable role
separation is part of the work item's exact claim.

## Harness history

Two initial ephemeral contexts were deliberately started with a read-only
sandbox. Both correctly refused to claim success when policy rejected Python
before process launch. They independently confirmed the static document-map and
path checks, changed no files, and returned `INCONCLUSIVE`. These attempts are
preserved in the ledger because a blocked command is not a passing test.

A third fresh ephemeral context used the CLI sandbox bypass solely to permit
the local Python checks. Its prompt prohibited edits, Lean, network access,
state writes, and fixes. Before and after `git status --short` output was
identical.

## Independent results

| Check | Result |
| --- | --- |
| `python AutonomousLab/scripts/labctl.py validate` | exit 0; state validation passed |
| `python -m unittest discover -s AutonomousLab/tests -p test_lab_framework.py -v` | exit 0; 9/9 tests passed |
| `python AutonomousLab/scripts/build_role_packet.py --model codex --role skeptic --project NE-GAUGE-CHIRAL --work-item GAUGE-COV-001` | exit 0 |
| Role packet content | shared Skeptic role, Codex Skeptic overlay, selected project, and selected work item all present |
| `docs/DOCUMENT_MAP.md` AFPL links | exit 0; README and five-year-plan links present |
| README `Start here` paths | all 16 checked paths exist |
| before/after repository status | identical; no reproducer edits detected |

No Lean command or network request was used. One initial status call and one
README search timed out in the fresh context; both were rerun successfully and
are not counted as passes until their successful reruns.

## Cross-family gate

The separate Claude-family report
`RED_TEAM_LAB-BOOTSTRAP-001_2026-07-12.md` identified and repaired the model
roster, review-family, Director-interface, concurrent-write, cadence, forecast,
Aristotle-registry, claim-registry, and resource-ceiling defects. Codex reviewed
the repaired framework in live operation, confirmed the fixes through the
validator and tests, and then obtained this clean-context reproduction.

The bootstrap claim is therefore eligible for `INTEGRATED`. This does not
certify any scientific claim, release candidate, or long-term maintenance-cost
benefit. Those remain governed by their own work items and cadence reviews.

## Residual risks

- The reproduction ran against the current dirty research worktree rather than
  a clean Git revision. Identical before/after status establishes that the
  reproducer introduced no visible changes, but release-grade reproduction
  still requires a frozen revision.
- The first weekly and monthly maintenance reviews have not yet measured
  whether AFPL coordination benefit exceeds process cost.
- Interactive sessions remain persistent workers, not background daemons;
  `KICKOFF.md` documents resume behavior.
