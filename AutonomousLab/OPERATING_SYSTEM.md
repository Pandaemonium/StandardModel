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
blockers, and the last handoff. Query live Aristotle and model-call state.

### Select

Choose work by dependency, expected information gain, strategic value, and
blocker age. Respect work-in-progress limits. Do not select work merely because
it is easy to count.

### Specify

Create or update a work item with exact claim, nearest work, assumptions,
success criterion, kill condition, witness, control, owner, skeptic, resource
ceiling, and intended artifact.

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

- harvest external jobs before submitting duplicates (`labctl.py jobs` +
  the registry in `state/ARISTOTLE_JOBS.json`);
- update the append-only ledger after every material transition, through
  `labctl.py` (`transition`, `log`) so timestamps come from the system clock;
- keep one independent audit lane active when headline work is underway;
- never poll external jobs in a blocking sleep loop; check inline between
  units of real work;
- stop stalled proof search and record exact blockers.

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

Every session ends with:

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

Write the handoff when context is at risk (long sessions approaching
compaction), not only at session end. A handoff reconstructed from memory
after the fact is fiction.

## 6. Availability degradation

- If the entire Claude family is unavailable (no interactive session and no
  authenticated wrapper), Codex may continue execution but cannot record a
  Claude-family audit. Headline promotion waits for cross-family review or
  explicit human disposition. The same rule applies with families swapped.
- If only the Opus wrapper is down, the interactive Claude session carries
  the family's review lane (and vice versa); note the channel in the audit
  record.
- If Aristotle is unavailable, theorem statements and context packs may be
  prepared; hard proofs remain pending rather than weakened.
- If Neo4j or literature tooling is unavailable, direct search is allowed and
  the degraded provenance path is recorded.
- If builds are unavailable, no theorem is called landed.

## 7. Concurrent sessions and state writes

Two agents working simultaneously have lost updates to shared files in past
runs. Standing rules:

- JSON state files have a single writer at a time: the agent currently acting
  as Lab Manager. Other agents request changes via a ledger entry or hand the
  edit to the manager lane.
- All ledger appends go through `labctl.py` (`transition`, `log`,
  `review-done`, `availability`), which stamps from the system clock;
  hand-written timestamps have drifted from wall time twice in recorded runs.
- Run `labctl.py validate` before and after any state mutation.
- On an edit conflict ("file modified since read"), re-read and re-apply;
  never overwrite the other agent's entry.
- Narrative run documents (reports, scorecards) name one owning agent per
  section; co-edited sections get separate subsections per agent.
