# Continuous laboratory operating system

## 1. The persistent loop

AFPL does not operate as disconnected 24-hour campaigns. It repeats a durable
cycle whose state is written to disk:

```text
ORIENT -> SELECT -> SPECIFY -> EXECUTE -> VERIFY
       -> RED-TEAM -> INTEGRATE -> LEARN -> REPLENISH
```

### Orient

Read the charter, current state, active portfolio, decisions, incidents,
blockers, and the generated handoff. Query live Aristotle and model-call state.
Run one bounded supervisory pass before choosing work:

```powershell
python AutonomousLab/scripts/labctl.py supervise
python AutonomousLab/scripts/labctl.py handoff --check
python AutonomousLab/scripts/labctl.py inbox --model <codex-or-claude>
```

### Select

Choose work by dependency, expected information gain, strategic value, and
blocker age. Respect work-in-progress limits. Do not select work merely because
it is easy to count.

### Specify

Create or update a work item with exact claim, nearest work, assumptions,
success criterion, kill condition, witness, control, owner, skeptic, resource
ceiling, and intended artifact. Every work item is atomic: it names one parent
if it is a rung of a larger item, explicit dependencies, concrete deliverables,
evidence paths, claim-registry links, and commands another family can replay.
If two deliverables can fail independently, split them into separate items.

### Execute

The Scientist researches, formalizes, calculates, simulates, or writes. The
Visionary may propose branches; the Phenomenologist may demand an observable
dictionary; the Impact Strategist may identify impact requirements. None
changes the evidence grade.

The Archivist supplies source packets and knowledge-graph state before a
literature-dependent claim is verified. The Educator works after claim grading,
or labels unsettled material explicitly as an open question.

### Verify

Run the smallest exact check, then broader checks. Preserve raw outputs,
versions, hashes, and failure notes. Aristotle outputs are downloaded and
reviewed before integration.

### Red-team

The Skeptic from another model independently attacks the statement, source
support, controls, and interpretation. The builder cannot impersonate this
review by switching role labels in the same uninterrupted context.

For release candidates, the Reproducer starts from the archived instructions
rather than the builder's hidden context and reruns the result independently.

In solo mode, the active family may red-team artifacts built by the paused
family when it is their registered independent skeptic. A role switch used to
red-team its own work is recorded as a self-audit and cannot advance an
independent-review gate. Deferred reviews stay in the machine-readable queue.

### Integrate

Land only scoped results. Update guards, imports, provenance, claim matrices,
manuscripts, state, and the ledger. Unrelated dirty-tree work is preserved.

### Learn

Record what changed, forecast calibration, failed routes, reusable lemmas,
tooling lessons, and procedural friction. The Lab Manager distinguishes a
scientific blocker from a process blocker.

### Replenish

Promote the next dependency-ready item, launch focused proof/audit jobs, and
write a complete handoff. The loop can continue in a new model context without
inventing state from memory.

## 2. Cadence

### Continuous

- **keep the Aristotle fleet full** (target 8 active): if a slot is open and a
  target is ready, fire it immediately; refill on every harvest. An idle fleet
  is a process failure, not a resting state. "Genuinely blocked" means *no ready
  target AND every slot full* -- not "I finished my current lane." (See
  `ARISTOTLE_OPERATIONS.md` fleet policy; 2026-07-12 throughput redirect.)
- harvest external jobs before submitting duplicates (`labctl.py jobs` +
  the registry in `state/ARISTOTLE_JOBS.json`);
- update the append-only ledger after every material transition, through
  `labctl.py` (`transition`, `log`) so timestamps come from the system clock;
- clear `labctl.py review-queue` before opening lower-priority execution work;
- read and acknowledge the model mailbox at every bounded work-unit boundary;
  requests that need action are claimed before execution so the other family
  can see ownership and expiry;
- acquire a bounded path lease before editing a file or directory another
  active agent could also touch, and release it after verification;
- keep one independent audit lane active when headline work is underway;
- never poll external jobs in a blocking sleep loop; check inline between
  units of real work;
- stop stalled proof search and record exact blockers.
- run `labctl.py role-status`; start the highest overdue periodic role duty
  before ordinary queue replenishment, and complete it only with the contracted
  artifact.

### Daily

- validate lab state and run `labctl.py due`;
- review active work, blocker age, and `state/DIRECTOR_QUEUE.md` (surface
  stale human-decision entries; never act on them);
- run one Scientist/Skeptic exchange on the highest-risk claim;
- perform one literature or source update per active program;
- publish an internal handoff and next-action queue.

### Weekly

- reproduce one prior result from its documented commands;
- hold a portfolio meeting across the nine roles;
- compare forecasts with outcomes;
- retire, split, or re-scope stale work;
- update the public-facing claim delta only from landed evidence.

### Monthly

- conduct one preregistered procedure experiment;
- run a dependency and knowledge-graph health audit;
- review costs, queue saturation, repeated failures, and model complementarity;
- select one external expert question or hostile review packet;
- refresh the five-year risk register.

### Quarterly

- run hard program exams using `templates/QUARTERLY_REVIEW.md`;
- run one fresh-context hostile review per flagship: the reviewer receives
  only the manuscript and artifact -- no repository, ledger, or chat context
  -- and the findings land as a graded work item (empirical basis: the
  fresh-context 3/10 review of the Lambda paper produced T1, the decisive
  theorem of the 2026-07-12 run);
- rebalance the portfolio allocation;
- freeze and reproduce release candidates;
- compare the flagship against conventional control programs;
- amend procedures only through a decision record.

### Annually

- grade the year in `FIVE_YEAR_PLAN.md`;
- run an external review or prepare an external-review-ready packet;
- publish wins, kills, retractions, and unresolved debts together;
- set the next year's exams without retroactively weakening the prior ones.

## 3. Work-in-progress limits

- at most six active scientific programs;
- at most two active moonshots without an intervening theorem/no-go gate;
- at most three executing work items per model;
- at least one control/replication item for every three flagship items;
- no manuscript section under simultaneous ownership by two agents;
- no active item with an unnamed dependency, nearest unproved claim, or
  reproduction command;
- no more than eight useful Aristotle jobs across the lab unless the Lab
  Manager records a capacity exception.

## 4. Selection score

The Lab Manager may rank work with this transparent heuristic:

```text
priority = 3*dependency_unblock
         + 3*expected_information_gain
         + 2*scientific_importance
         + 2*tractability
         + blocker_age_bonus
         - duplication_risk
         - semantic_risk
         - resource_cost
```

Scores aid judgment; they do not replace it. Inputs and overrides are logged.

## 5. Handoff minimum

Every session ends by running `labctl.py handoff`. The generated handoff draws
active work, review routes, evidence paths, and Aristotle jobs directly from
machine-readable state. `labctl.py handoff --check` fails after state changes
until it is regenerated.

Scientific reports and ledger entries still record:

- exact newest user request;
- active role and model;
- completed and incomplete actions;
- files changed;
- commands actually run;
- live external jobs and identifiers;
- blockers and failed attempts;
- claims that must not be promoted;
- Director-queue entries added or affected;
- next three actions in dependency order.

Generate the handoff when context is at risk (long sessions approaching
compaction), not only at session end. A handoff reconstructed from memory
after the fact is fiction; a handoff generated from stale state is detected.

## 6. Availability degradation

- If the interactive Claude Code session is unavailable, Codex may continue
  execution but cannot record a Claude-family audit. Headline promotion waits
  for Claude Code review or explicit human disposition. The same rule applies
  with families swapped.
- If Aristotle is unavailable, theorem statements and context packs may be
  prepared; hard proofs remain pending rather than weakened.
- If Neo4j or literature tooling is unavailable, direct search is allowed and
  the degraded provenance path is recorded.
- If builds are unavailable, no theorem is called landed.

### Intentional solo mode

Solo mode is distinct from degraded availability. Availability says whether a
service works; execution mode says which interactive family the Research
Director has chosen to spend during a bounded interval. Set it only through
`labctl.py mode-set`, and inspect it through `labctl.py mode`.

- Cadences, work-in-progress limits, leases, Aristotle resource ceilings, and
  human release control remain active.
- Family rotation for periodic roles is suspended so the active family can keep
  the lab operating. The generated role contract marks same-family audit work
  as non-independent.
- Work owned by the paused family remains paused unless explicitly reassigned;
  mode activation does not change owners or skeptics.
- Review routing remains asymmetric: the active family can review work built by
  the paused family, but its own work waits for the paused family's review.
- `planned_end_at` is a visible deadline, not an automated process timer. Resume
  collaborative mode explicitly and clear deferred review debt first.

See `SOLO_MODE.md` for startup, overnight cadence, and resumption commands.

## 7. Concurrent sessions and state writes

Two agents working simultaneously have lost updates to shared files in past
runs. Standing rules:

- JSON state files have a single writer at a time: the agent currently acting
  as Lab Manager. Other agents request changes via a ledger entry or hand the
  edit to the manager lane.
- Editing ownership is expressed by `labctl.py lease <path> --work-item ...`.
  Leases cover path prefixes, expire automatically, and overlapping live
  leases are rejected. A lease coordinates editing; it does not authorize a
  scientific promotion or override repository safety rules.
- All ledger appends go through `labctl.py` (`transition`, `log`,
  `review-done`, `availability`), which stamps from the system clock;
  hand-written timestamps have drifted from wall time twice in recorded runs.
- Run `labctl.py validate` before and after any state mutation.
- On an edit conflict ("file modified since read"), re-read and re-apply;
  never overwrite the other agent's entry.
- Narrative run documents (reports, scorecards) name one owning agent per
  section; co-edited sections get separate subsections per agent.

## 8. Evidence graph and nearest-work audit

The work registry is the operational evidence graph. Each item links backward
to dependencies, sideways to source and artifact paths, and forward to claim
registry rows. `labctl.py validate` rejects unknown dependencies, cycles,
unknown claim identifiers, and malformed reproduction data.

Before promotion, the Skeptic performs a nearest-work audit:

1. restate the exact proved claim without manuscript language;
2. state the nearest stronger claim a reader is likely to infer;
3. identify the missing theorem, experiment, or assumption separating them;
4. verify that titles, abstracts, captions, and public explanations do not
   cross that boundary;
5. either open the stronger claim as a new atomic work item or record why it is
   intentionally out of scope.

## 9. Bounded supervisor

`labctl.py supervise` is deliberately read-only and executes one pass only. It
checks state validity, review backlog, Aristotle occupancy, handoff freshness,
and path leases, then recommends exactly one control action. It never edits
scientific artifacts, launches open-ended loops, promotes claims, or consumes
the Director queue. Autonomous agents call it between bounded work units; they
remain responsible for the scientific judgment behind the next action.

## 10. Transactional inter-agent mailbox

`state/MESSAGES.json` is the durable coordination channel. The ledger remains
the append-only scientific history; the mailbox records obligations that need
acknowledgment or ownership.

Every actionable cross-agent request uses this lifecycle:

```text
SEND -> ACKNOWLEDGE -> CLAIM (bounded) -> COMPLETE
```

- `labctl.py send` records sender, recipient channel, work item, priority,
  expiry, artifact hashes, and replay commands.
- `labctl.py inbox --model MODEL` shows live unacknowledged messages addressed
  to that channel or to all channels.
- `labctl.py ack` proves receipt without claiming execution.
- `labctl.py claim-message` assigns one model for a bounded interval and blocks
  duplicate execution until expiry.
- `labctl.py complete-message` closes only a message claimed by that model.

Scientific reasoning stays in linked artifacts. A mailbox body is a concise
request, not a substitute for a theorem packet or red-team report. Artifact
hashes make silent post-request edits visible. Expired open messages are
reported by `labctl.py due`; unread counts appear in `labctl.py supervise`.

Aristotle submissions use `labctl.py job-register` immediately after the
external project is created and `labctl.py job-update` on every status change.
These commands share the same interprocess transaction discipline as leases
and messages. The ledger alone is not an adequate job registry.

## 11. Enforced role-duty cadence

`state/ROLE_SCHEDULE.json` distinguishes continuous, event-driven, and periodic
roles. A role name in a matrix or prompt is not evidence that the role ran.
Evidence requires a bounded activation record, generated packet, deadline,
contracted deliverable, completion summary, and artifact digest.

- Visionary: every 3 hours.
- Impact Strategist (`impact_strategist`; legacy key `superstar`): every 6
  hours.
- Archivist: every 6 hours.
- Lab Manager: every 3 hours.
- Educator and Phenomenologist: every 12 hours.
- Research Scientist: continuous through active work items.
- Skeptic: triggered by RED_TEAM/REPLICATING gates.
- Reproducer: triggered by release-candidate and explicit replication gates.

Use `labctl.py role-start ROLE --model MODEL` rather than hand-building a packet.
The command enforces one active session per role and alternates model families
when another family is available in collaborative mode. In solo mode it permits
successive activations by the active family without treating them as independent
review. `labctl.py role-complete` accepts only the
contracted artifact path and hashes it. `role-status`, `status`, and `supervise`
expose due or overdue duties. Same-family persona changes never count as
independent review.
