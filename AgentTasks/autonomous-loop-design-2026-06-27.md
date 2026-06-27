# Null-edge autonomous loop harness design - 2026-06-27

Purpose: create a durable, repo-native harness for long-running autonomous work
on the null-edge / Furey / Standard Model formalization program.

The harness is intentionally boring. The goal is not to make one giant agent
session smart enough to hold the whole project in working memory. The goal is to
make progress survivable across sessions, models, Aristotle runs, literature
searches, Lean edits, and adversarial reviews.

## Operating principle

The repo is the source of truth. Chat history is context, not memory.

Each loop must leave artifacts that a fresh agent can use:

- current objective;
- active blockers;
- Aristotle jobs submitted, running, returned, and integrated;
- local Lean/doc work done while waiting;
- literature searched and ingested;
- Claude adversarial feedback requested and received;
- Pro questions prepared;
- friction encountered;
- questions that require the user.

## Autonomy policy

The user has authorized full autonomy for the loop, including:

- Aristotle submissions and integrations;
- literature searches;
- Zotero and Neo4j ingestion when appropriate;
- local Lean coding while Aristotle runs;
- validation commands when needed for a claimed trusted result;
- Claude API calls once per round of Aristotle jobs;
- creation of Pro hard-question packets;
- friction logging and tooling improvements.

Even with full autonomy, the loop should pause for user judgment when a choice is
strategic rather than operational:

- weakening a theorem statement;
- changing a public claim boundary;
- accepting a new physics assumption;
- deciding whether a negative result should become the main story;
- committing to a publication title, venue, or public framing;
- making destructive filesystem or history edits.

## State machine

The loop cycles through these states:

```text
BOOT
SNAPSHOT
TRIAGE
SELECT_NEXT_OBJECTIVE
PREPARE_CONTEXT
SUBMIT_ARISTOTLE
WAITING_ON_ARISTOTLE
LOCAL_WORK
LITERATURE_SEARCH
CLAUDE_ADVERSARIAL_REVIEW
PRO_QUESTION_PACKAGING
INTEGRATE_RESULTS
META_ANALYSIS
DOC_UPDATE
USER_QUESTION_QUEUE
PAUSE_OR_CONTINUE
```

A state is allowed to be skipped if it is not useful for the current loop.

## Round structure

A round is one coherent batch of work around a current objective.

Recommended round protocol:

1. Load `AgentTasks/autonomous-loop/state.json` and `progress.md`.
2. Check Aristotle status for active jobs.
3. Integrate completed jobs, if any.
4. Triage blockers and pick one thin local slice.
5. Do local Lean/doc/lit work while waiting.
6. Submit new Aristotle jobs only when targets are clean.
7. Call Claude once after the Aristotle round is submitted or after returned
   results materially change the state.
8. Package any hard Pro questions that arise.
9. Run a meta-review before closing the loop.
10. Update state, progress, friction, meta-review, and decision checkpoints.
11. Stop if the next action requires user judgment; otherwise continue to the
    next bounded loop.

## Mandatory meta-review layer

The autonomous loop must improve itself. It should not merely continue because a
setup prompt said to continue.

Every loop must include a short meta-review that asks:

- Did this loop create real progress toward the project goals, or just activity?
- Which gate, theorem, publication claim, or blocker actually moved?
- Did any result weaken, refute, or reframe the current strategy?
- Are we still working on the highest-leverage blocker?
- Did Aristotle, Claude, Pro, or literature feedback expose a better route?
- Did any friction recur enough that the harness should be improved?
- Did the current objective become stale?
- Should the next loop submit proofs, do local Lean, search literature, call
  Claude, package Pro questions, update docs, or pause for user judgment?

Every Aristotle round must include a larger meta-review after the returned jobs
are integrated or after the round is clearly stalled. That review should:

- compare intended theorems against returned theorem statements;
- check whether the project learned something strategically important;
- update the gate ledger if the evidence changed;
- decide whether to continue, pivot, downgrade, or kill a route;
- identify the next smallest decisive theorem or counterexample;
- decide whether Claude or Pro should be asked an adversarial question;
- update templates/scripts if workflow friction slowed progress.

Every several loops, run a breakthrough review:

```text
What would move the project from reconstruction toward prediction?
What is the current hardest blocker?
What negative result should become a theorem or paper claim?
What are we avoiding because it is hard?
What route has become low-value and should stop receiving jobs?
What new artifact would make future agents dramatically more effective?
```

The loop is successful only if at least one of the following improves:

- a Lean theorem is proved or a false target is cleanly refuted;
- a blocker is narrowed to a smaller formal statement;
- a gate status changes with evidence;
- a publication claim becomes safer or sharper;
- a Pro/Claude question is packaged with enough context to matter;
- a literature source changes the strategy;
- repeated friction is reduced by a harness/tooling update.

If none of these happened, the loop should say so plainly and change approach.

## Artifact map

```text
AgentTasks/autonomous-loop/
  README.md
  state.json
  current-objective.md
  progress.md
  friction-log.md
  questions-for-user.md
  pro-question-queue.md
  claude-review-queue.md
  aristotle-queue.md
  completed-integrations.md
  literature-queue.md
  decision-checkpoints.md
  meta-review.md
  templates/
  runs/
Scripts/autonomous_loop/loop_harness.py
```

## Claude adversarial review cadence

Call Claude once per Aristotle round. The intended role is adversarial feedback,
not project management.

Claude should receive:

- current objective;
- relevant plan excerpt or compact state;
- the **verbatim Lean** of every theorem/definition under review, plus the
  API/predicates they wrap, embedded via `send_claude_review.py --source-file`
  (never a prose paraphrase - a paraphrase cannot expose a semantic mismatch
  between the intended math and the Lean, which is the review's main job);
- the intended reading of each declaration, stated separately so the reviewer
  can check Lean-vs-intent;
- exact assumptions to attack;
- requested output format.

Budget for it: embedded artifacts plus live tools cost more than a prose-only
call, so use `--max-budget-usd 1.50` or higher, not the old 0.35. The wrapper now
gives the reviewer read/search tools and read-only MCP by default
(`--tools default --permission-mode bypassPermissions` + a write denylist +
`review.mcp.json`): it can read the Neo4j graph, keyword-search code and paper
full text, run literature searches, search Mathlib/PhysLean, and run the
read-only semantic-search scripts via Bash, while file/graph/Zotero writes are
blocked. So the reviewer can verify cited results and paper internals itself
rather than asserting from priors. Use `--safe` to also block Bash.

Claude should return:

- missed blockers;
- semantic mismatch risks;
- overclaim risks;
- better theorem splits;
- suggested next Aristotle jobs;
- publication-language warnings.

## Pro hard-question policy

Pro questions should be standalone documents. A good Pro packet includes:

- project thesis;
- compact gate status;
- proved facts;
- failed routes;
- exact hard problem;
- what would count as success;
- what would count as failure;
- requested deliverables.

Do not send Pro a vague question like `what next?`. Send a focused hard problem
with enough context to reason independently.

## Aristotle policy

Use Aristotle early for hard Lean work, but keep jobs small.

Each job packet should state:

- target module path;
- imports allowed;
- exact theorem names;
- semantic acceptance criteria;
- forbidden weakenings;
- known related modules;
- expected verification commands;
- how the result affects the gate ledger.

Returned Aristotle work must be semantically reviewed before being promoted in
the plan. A kernel-checked theorem can still prove the wrong formalization of
the intended physics statement.

## Literature workflow

Use literature search when:

- a blocker resembles known lattice, spectral, Clifford, anomaly, FMS, DEC, or
  NCG literature;
- a term of art is uncertain;
- a public claim needs source support;
- a route may already be ruled out by no-go literature.

Two retrieval granularities exist (see `Scripts/MCP_SERVERS.md`): abstract-level
paper search for triage, and `neo4j_paper_search.py --chunks` full-text search
over paper body text for internal content. Use the full-text path whenever a
blocker depends on a specific lemma, derivation, sign convention, or construction
inside a paper; do not cite a paper for internal content known only from its
abstract. The `neo4j_graph` MCP server is for exact/graph queries only - it
cannot rank by meaning.

For each useful paper:

- check for duplicates before adding to Zotero;
- add Zotero metadata;
- add or update Neo4j nodes/edges;
- record why the source matters in `literature-queue.md` or the plan;
- distinguish source support from theorem proof.

## Friction policy

Friction is a first-class output. Log it when any repeated workflow cost appears:

- Aristotle packaging failures;
- missing imports in submitted jobs;
- long full-repo builds consuming proof budget;
- extraction problems on Windows;
- literature ingestion scripts failing;
- duplicate Zotero entries;
- Neo4j sync mismatch;
- context packs missing critical files;
- Pro/Claude packets lacking enough context;
- local validation being too slow or too broad.

Every repeated friction item should become either a script improvement, a
template improvement, a runbook note, or an explicit accepted cost.

## Current strategic defaults

The loop starts with the current compact project posture:

- The active mass-program language is `canonical quadratic obstruction`, not
  universal spectral gap.
- Gate C is split into C0 external species health and C1 physical chiral
  release.
- RA-Wilson is promising for C0, not C1 by itself.
- Gate H/Furey is internal-spectrum legality and possible codimension, not
  external branch control.
- Bare `D_+` does not release Gate C.
- Taste-only scalar regulators cannot polarize the origin kernel.
- A Weyl/domain-wall/overlap/spinor-line auxiliary layer is the likely next C1
  path.

## Success metric

A successful autonomous loop is not measured by how much text it writes. It is
measured by whether the next human or agent can answer:

```text
What did we learn?
What changed in the repo?
What theorem or claim became more/less plausible?
What is blocked?
What exact action is next?
```
