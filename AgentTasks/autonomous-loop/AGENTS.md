# AGENTS.md - autonomous loop behavior

This directory is the durable control plane for long-running autonomous work on
the null-edge / Furey / Standard Model project.

The main repo `AGENTS.md` still applies. This file adds local behavior rules for
files under `AgentTasks/autonomous-loop/`.

## Prime directive

Do not run blindly. The loop must continuously ask whether it is making real
progress toward the project's theorem, model-building, and publication goals.

Activity is not progress. Progress means one or more of:

- a Lean theorem is proved or a false target is cleanly refuted;
- a blocker is narrowed to a smaller formal statement;
- a gate status changes with evidence;
- a publication claim becomes safer or sharper;
- a Pro/Claude question is packaged with enough context to matter;
- a literature source changes the strategy;
- repeated friction is reduced by a harness or tooling improvement;
- (Track B) a generalization or qubit/information insight is sharpened into a
  conjecture with a NAMED failure mode, a finite theorem target precise enough
  to hand to Aristotle, or a falsifiable prediction/absence theorem.

A Track B "nice analogy" with no failure mode is NOT progress. It may be recorded
briefly, but it does not satisfy the success standard on its own; the meta-review
should push it toward a failure mode, a finite target, or drop it.

If none of these happened, say so in `meta-review.md` and change approach.

## Two-track objective (2026-06-27)

The loop runs two co-equal tracks; see `current-objective.md` for the live
contents of each.

- Track A - convergent gate work: Gate C0/C1/H/F theorem, audit, and integration
  spine. This is the existing discipline and is unchanged.
- Track B - exploration: the qubit/information angle and broader generalization
  of the program as a finite obstruction calculus (mass as the `d = 2` case).
  Lanes include the mixedness/observer-channel reading, the Plucker hierarchy
  `k > 2`, the obstruction-stiffness unification, and measure-valued P1.5.

Equal weight means: every cycle should make real progress on both tracks, or the
meta-review must state explicitly why one track produced no action this cycle.
Track B is allowed to spawn Aristotle jobs once a target is sharp and
self-contained, classified for dependency like any other job.

Track B does not relax the project's discipline. Lateral thinking is encouraged,
but the success standard for Track B is falsifiability, not beauty: a result
counts only if it yields a named failure mode, a finite theorem target, or a
falsifiable prediction/absence theorem. Keep the `docs/NULLSTRAND.md`
claim-boundary labels; never let mixedness/observer language leak into the
invariant `det P` statement. If a Track B generalization matures into a candidate
change to the program's headline framing, stop and surface it via
`questions-for-user.md` instead of silently reframing (this is also a
`stop_conditions` entry in `state.json`).

## Required start-of-loop behavior

Before choosing work, read or consult:

- `state.json`;
- `current-objective.md`;
- latest `progress.md` entry;
- latest `meta-review.md` entry;
- `aristotle-queue.md`;
- `questions-for-user.md`.

Then run a targeted literature search for the current blocker or objective.
This is mandatory every cycle. Use local Neo4j/Zotero, arXiv/web, or another
appropriate source. Record the query/source and whether it changed the plan.
Prior searches do not satisfy this step. Each autonomous run must refresh the
literature context for the current blocker, even if the result is a recorded
negative result.

Then select one bounded objective. Prefer the next decisive theorem, audit,
integration, or question packet over broad activity.

## Required end-of-loop behavior

Every loop must update:

- `progress.md`;
- `meta-review.md`;
- `state.json` if the state/objective changed.
- a literature-search record, either in `progress.md`, `literature-queue.md`, or
  a dedicated note.

Update these when relevant, but do not omit them silently:

- `friction-log.md`;
- `aristotle-queue.md`;
- `completed-integrations.md`;
- `claude-review-queue.md`;
- `pro-question-queue.md`;
- `literature-queue.md`;
- `decision-checkpoints.md`;
- `questions-for-user.md`.

## Mandatory cycle steps

Every autonomous cycle must execute the whole loop, not just the easiest part:

- analyze goals and blockers;
- check/integrate/submit Aristotle work when there are active or ready jobs;
- perform literature search;
- do local analysis and Lean/doc work on Track A (convergent gates);
- do at least one Track B action (qubit/information or generalization): sharpen a
  conjecture, state a finite target, prepare a context pack or packet, or submit a
  sharp Track B job;
- run meta-review (must check both tracks);
- log friction and improve tooling when repeated friction appears;
- prepare or send Claude adversarial review once per Aristotle round;
- prepare Pro/Gemini packets when a hard question needs external reasoning.

There are no optional steps in this list. If time, budget, tool capacity, or
context limits are tight, shrink the scope of each step rather than omitting a
step. For example, do one targeted literature query, one bounded Aristotle
status check, one local analysis/Lean/doc action, and one concise meta-review.

If a step produces no action, record that fact and why. For example:

```text
Literature search: queried Neo4j for "overlap Wilson null-edge chiral release";
no new source changed the plan.
```

This is different from skipping the step. Skipping literature search or
meta-review invalidates the cycle.

## Meta-review rules

The meta-review is mandatory. It should be skeptical and project-level.

Ask:

- Did the loop move Gate C0, C1, Gate H, Gate D/E/F, or publication readiness?
- Did we learn something that should change strategy?
- Are we still pursuing a stale target?
- Did a negative result deserve promotion to a theorem or paper claim?
- Are we overusing Aristotle where local work is enough, or churning locally
  where Aristotle should be used?
- Should Claude be asked to attack this round?
- Should a standalone Pro packet be prepared?
- Did workflow friction recur enough to justify tooling?

Do not rubber-stamp. A useful meta-review can conclude that the loop was
low-value and should pivot.

The meta-review must explicitly check whether every mandatory cycle step
happened. If not, identify the missing step as friction or process failure and
make the next action repair it.

## Literature-search rules

Literature search is mandatory every cycle.

Minimum acceptable literature record:

- query or search phrase;
- source searched, such as Neo4j, Zotero, arXiv, web, or Semantic Scholar;
- result summary;
- whether the result changed the plan;
- any ingestion action or follow-up queue item.

The literature record must exist even when the search finds nothing useful. A
cycle that relies only on memory, prior searches, or existing citations has not
completed the literature step.

Prefer searches tied to the live blocker, not generic browsing. Examples:

- Gate C0/C1: overlap, Wilson, domain-wall, flavored chirality, propagator
  zeros, ghost safety, minimally doubled fermions.
- Gate D: DEC, Hodge-Dirac convergence, connection Laplacian, Lorentzian
  discretization.
- Gate H: Furey, Baez, DVT, finite spectral triples, anomaly inheritance,
  legal Yukawa blocks.
- Gate F: finite spectral-action moduli, counterterms, prediction/codimension.

If no useful source is found, record the negative result. If a source is useful,
queue ingestion into Zotero/Neo4j and update the relevant plan or task note.

### Full text is available - use it, do not stop at abstracts

The Neo4j graph holds paper **full text**, not just titles/abstracts: each paper
is stored as embedded `:PaperChunk` nodes (section-aware ~600-word chunks). As of
2026-06-27 the entire null-edge collection is chunked (196/196 papers). Two moves,
and the loop should use both rather than reasoning from abstracts or memory:

```powershell
$PY="C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
# semantic search over body text: WHERE a lemma/derivation/convention lives
& $PY Scripts/lit/neo4j_paper_search.py --chunks --query "overlap Wilson null-edge chiral release"
# read a whole paper end to end (de-overlapped, section headings restored)
& $PY Scripts/lit/neo4j_paper_search.py --list-fulltext        # which papers have full text
& $PY Scripts/lit/neo4j_paper_search.py --read 2311.12790      # arXiv id or Zotero paper_key
```

Rules of thumb:

- Use `--query` (abstract index) to find *which* papers matter; use `--chunks` to
  find *where* in them the relevant claim lives; use `--read` to audit a paper in
  full before relying on it for a convention, no-go, or theorem statement.
- Whenever a decision depends on a paper's internal content (a derivation, a
  convention, a no-go's exact hypotheses), read the chunks or the full text - do
  not trust the abstract or chat memory. This is the same standard the root
  `AGENTS.md` sets for `--chunks`.
- `--read` reconstructs from chunks: faithful prose but degraded math symbols. For
  verbatim equations go to the arXiv/PDF.
- If a needed paper is abstract-only (no chunks; `--read` reports none), queue
  `Scripts/lit/lit_fulltext.py --ids <arxiv_id>` to add body text, then proceed.

Full setup and the chunk schema are in `Scripts/MCP_SERVERS.md` and
`Scripts/lit/README.md`.

## Friction logging rules

Log friction when a workflow problem slows progress, even if you work around it.

Examples:

- Aristotle packaging or extraction failures;
- missing imports in returned jobs;
- long builds wasting Aristotle budget;
- brittle context packs;
- literature duplicate-check problems;
- Zotero or Neo4j ingestion failures;
- Pro or Claude packets missing context;
- Windows shell/path/encoding problems;
- validation commands that are too slow or too broad.

Each repeated friction item should become a script, template, runbook update, or
explicit accepted cost.

## Claude and Pro behavior

Claude is an adversarial reviewer, not a co-pilot. Use it once per Aristotle
round to attack assumptions, theorem statements, overclaims, and next-job
choices.

Adversarial Claude calls reviewing Lean must embed the **actual source** of the
declarations under review (and the API they wrap) via
`send_claude_review.py --source-file`, never a prose summary - the reviewer
cannot catch a semantic mismatch it never sees, and that is the review's main
job. State the intended reading of each declaration separately so the reviewer
can check Lean-vs-intent. Budget for the larger packet (`--max-budget-usd 1.50`+,
not the old 0.35), and prefer read-only tools via `--tools` so it verifies cited
results rather than guessing from priors.

Pro questions must be standalone documents with enough context to reason
without chat history. Do not send vague questions. Send hard problems with
success/failure criteria and requested deliverables.

## Claude and Gemini call scripts

Use the repo wrappers for API/CLI calls:

```powershell
python Scripts/autonomous_loop/send_claude_review.py --packet AgentTasks\packet.md --source-file PhysicsSM\Draft\DeclUnderReview.lean --source-file PhysicsSM\Draft\DependencyApi.lean --slug short-name
python Scripts/autonomous_loop/send_gemini_review.py --packet AgentTasks\packet.md --slug short-name
```

Defaults (verified against the installed Claude CLI):

- The Claude wrapper runs `claude -p --bare` with `--model opus`,
  `--max-budget-usd 1.50`, and the reviewer wired for **read/search tools + MCP**:
  `--tools default --permission-mode bypassPermissions` plus a write **denylist**
  (`Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write`) and
  `--mcp-config Scripts/autonomous_loop/review.mcp.json --strict-mcp-config`
  (neo4j forced read-only, scholarly, lean-explore). So the reviewer can read the
  graph, keyword-search code and paper full text, run literature searches, search
  Mathlib/PhysLean, and run the read-only semantic-search scripts via Bash - but
  cannot edit files or write to the graph/Zotero. An allowlist is deliberately
  NOT used: in this CLI build it suppressed every tool but `Read`.
- Pass `--source-file` (repeatable) to embed the actual Lean verbatim. Use
  `--safe` to also block Bash (zero write surface), `--no-mcp` for built-ins
  only, or `--no-tools` for the legacy prose-only call.
- Gemini wrapper calls the Gemini REST API with model
  `gemini-3.1-pro-preview`.

Required logging rule:

- Every real model call must write one Markdown file under
  `AgentTasks/model-calls/claude/` or `AgentTasks/model-calls/gemini/`.
- That file must include the full prompt and full response or error.
- Never log API keys.

Required packet standard:

- Treat every model call as blind one-shot review.
- Include all context needed for a useful answer: project thesis, gate status,
  proved facts, failed routes, exact question, success/failure criteria, and
  requested output format.
- For any review of Lean, embed the verbatim source of the declarations under
  review (and the API they wrap) with `--source-file`; a paraphrase is not
  sufficient context for a formalization review.
- If the packet relies on chat memory, repo familiarity, or hidden context, do
  not send it yet.

## Gate discipline

Keep the current gate distinctions sharp:

- Gate C0: external species health.
- Gate C1: physical chiral release.
- Gate H: internal spectrum, anomaly, and legal finite Dirac structure.
- Gate F: prediction/codimension, not reconstruction.

Do not let a C0 result become C1 language. Do not let Gate H/Furey language
pretend to solve external branch control. Do not call reconstruction prediction.

## Editing style

These harness files are operational documents. Prefer clear, short updates over
large rewrites. Preserve the templates unless a real loop exposes a better
shape.

## Autonomous loop concurrency policy - 2026-06-27

Do not impose a blanket wait while Aristotle jobs are running. The loop is allowed to keep roughly 6-8 jobs in flight when the jobs are independent and well-scoped. Waiting is required only for a hard dependency, such as a returned theorem/API shape/countermodel/convention that the next job must import or instantiate.

Before submitting another job, classify it:

```text
Independent: can run now without any active job returning.
Soft-dependent: can run now if written with explicit assumptions and no release claim.
Hard-dependent: must wait for a specific active result.
```

The loop should favor independent and soft-dependent jobs that improve the C0/C1/Gate-C/Gate-H decision matrix. Hard-dependent jobs should be packetized locally but not launched until the dependency returns.

Mandatory cycle steps remain mandatory even under high concurrency: literature search, meta-review, progress logging, friction logging, and at least one meaningful local work product or integration decision. If a cycle cannot make Lean progress, it should still improve the research state by tightening a theorem target, preparing a prompt, auditing assumptions, or reducing workflow friction.

## Scheduler behavior

Use dependency-aware scheduling, not a global wait rule.

Classify each candidate job before launch:

- `Independent`: no active result is needed.
- `Soft-dependent`: can run with explicit assumptions and no release claim.
- `Hard-dependent`: must wait for a returned theorem, API, counterexample, or convention.

Default queue posture:

- Under about 6 running jobs: actively look for the best independent or soft-dependent submission.
- Around 6-8 running jobs: submit only sharply scoped jobs that are not blocked by active work.
- Above about 8 running jobs: prefer integration, local Lean/docs work, literature, meta-review, and packet preparation.

Hard-dependent jobs should still progress locally:

- draft the prompt;
- state the dependency;
- define acceptance criteria;
- identify the first theorem to request once the dependency returns.

Do not submit a hard-dependent job early just to maintain activity. Do not hold an independent job merely because unrelated Aristotle jobs are still running.
