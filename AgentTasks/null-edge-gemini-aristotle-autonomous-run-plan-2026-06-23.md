# Gemini + Aristotle autonomous run plan

Date: 2026-06-23

Purpose: prepare an autonomous Gemini run that uses Aristotle as the proof
engine, while avoiding the two failure modes exposed by the previous runs:

- activity measured by number of jobs rather than publication value;
- broad uncommitted theorem surface that outruns semantic review.

The goal is top-quality progress toward publishable null-edge results, especially
P9 source visibility and the P7/P6 information-theoretic spine, not maximum
throughput.

## Questions for the user before launch

These are tuning questions, not blockers. The default recommendations are shown
after each question.

1. Should Gemini be allowed to edit repository files, or should it produce only
   task notes, prompts, and review reports?
   Default: allow edits only in `AgentTasks/` plus small draft Lean/doc edits
   needed for focused Aristotle handoffs.

2. What Aristotle concurrency should Gemini use during the first phase?
   Default: at most 2 active proof jobs plus 1 strategy/design job until the
   current Claude batch is triaged; raise to 4-5 only after integration debt is
   under control.

3. Should P9 dominate the run?
   Default: yes. P9 is the flagship high-risk/high-leverage physics branch. P7
   and P6 should support it through observer-channel, relative-entropy, and
   concurrence tools.

4. Should Gemini be allowed to add papers to Zotero/Neo4j?
   Default: yes, but only after a source is verified as a guardrail for a live
   theorem or claim boundary. No broad literature dumps.

5. Should Gemini be allowed to commit?
   Default: no. It should leave a clean ledger, verified diffs, and an explicit
   final report. Commit only after human approval.

## Core division of labor

Gemini's role:

- read the publication plan and post-mortems;
- triage uncommitted results;
- do semantic and literature searches for live gates;
- design definitions and theorem statements;
- prepare focused Aristotle packages;
- integrate only mechanically clean results;
- write clear review notes and manuscript-facing summaries.

Aristotle's role:

- fill focused Lean proof holes;
- prove helper lemmas;
- test whether a proposed theorem is false or underspecified;
- return completion reports with solved targets, statement changes, remaining
  proof holes, and assumptions used.

Gemini should not burn time on hard Lean proof search when Aristotle is
available. Gemini should also not submit vague theorem targets to Aristotle.
Every proof job must have a typechecking statement and a focused package before
submission.

## North star

Every action should answer one question:

```text
Does this make a publication claim more credible, sharper, or more honestly
falsifiable?
```

If the answer is no, Gemini should not do it, even if a slot is idle.

The highest-value immediate publication gates are:

1. P9: finite source visibility for the cosmological-constant branch.
2. P7: observer channels, relative-entropy monotonicity, recoverability.
3. P6: reduced visible concurrence / Gram-overlap support for mass.
4. P1/P2 support: accessible mass manuscript anchors and operator conventions.

## Lessons incorporated from previous runs

### From the 18-cycle Aristotle run

- Focused standalone packages worked. Full-repo Aristotle jobs often waste time
  on broad builds.
- P9 advanced when the loop pursued finite pass/fail theorems, not slot usage.
- Strategy jobs were valuable only when they changed the next queue.
- The final cycle should close and verify, not create new integration debt.
- Ledger boundaries matter. Do not append a new autonomous run to an old run
  without a new section or file.

### From Claude's 50-job run

- Breadth can be productive, but only if followed by review.
- The best new result is the P9 non-collinearity/source-visibility no-go
  cluster.
- The uncommitted surface is already wide: 20 new draft modules plus many
  standalone packages and strategy reports.
- More jobs before triage will convert useful theorem atoms into debt.
- The next useful state is not "50 jobs completed"; it is "P9 and P7/P6 packets
  semantically reviewed, consolidated, verified, and connected to papers."

### From low-token integration feedback

- Read diffs and helper reports, not whole extracted trees.
- Use statement-identity checks before semantic review.
- Use placeholder scans and Lean checks as trust gates.
- Use `lake env lean <file>` first, targeted `lake build <module>` second, one
  full `lake build` per batch.
- Reuse context packs at integration time.
- Ask Aristotle for a completion report in every submission prompt.

## Launch phases

### Phase 0: preflight, no new Aristotle jobs

Budget: first 30-60 minutes.

Gemini must:

1. Read:
   - `AGENTS.md`
   - `docs/ARISTOTLE.md`
   - `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
   - `AgentTasks/null-edge-claude-autonomous-run-postmortem-2026-06-23.md`
   - `AgentTasks/null-edge-autonomous-run-postmortem-2026-06-23.md`
   - `AgentTasks/null-edge-goal-50-jobs-2026-06-22.md`
2. Run:
   - `git status --short`
   - `aristotle list --limit 20`
   - `lake env lean PhysicsSMDraft.lean`
   - the placeholder/escape-hatch token scan on the 20 Claude-integrated draft
     modules.
3. Write a fresh run ledger:
   - `AgentTasks/null-edge-gemini-aristotle-run-ledger-2026-06-23.md`
4. Record:
   - active Aristotle jobs;
   - completed but unintegrated jobs;
   - integrated modules needing semantic review;
   - design/strategy outputs needing extraction;
   - build/token-scan status.

No new proof jobs are allowed in Phase 0.

### Phase 1: triage Claude's uncommitted batch

Budget: first substantive work block.

Classify every uncommitted Claude artifact into one of five buckets:

```text
KEEP-REVIEW      valuable and should be semantically reviewed soon
KEEP-INFRA       useful support lemma / convention anchor, not a paper result
EXTRACT-REPORT   strategy/design output that should become an AgentTasks note
PARK             harmless but low-priority standalone artifact
RETRY/REFUTE     failed, incomplete, or statement likely wrong
```

Minimum first-pass priorities:

1. P9 review packet:
   - `NullEdgeP9NoncollinearMassNogo`
   - `NullEdgeP9MassCombine`
   - `NullEdgeP9EverpresentLambdaScaling`
   - `NullEdgeP9EverpresentLambdaTension`
   - completed visible-fan characterization job, if available
   - diamond-visibility geometric API design report
2. P7/P6 review packet:
   - `NullEdgeP7KLDataProcessing`
   - `NullEdgeP7StochasticContraction`
   - `NullEdgeP7BinaryEntropyBound`
   - `NullEdgeP6Concurrence`
   - `NullEdgeGramDeterminant`
3. P1/P2 support packet:
   - `NullEdgeRankOneNullMomentum`
   - `NullEdgeTwoNullMassive`
   - `NullEdgePauliSlash`
   - `NullEdgeChiralityProjectors`
   - `NullEdgeHiggsPotential`

Phase 1 output:

- a short triage table in the run ledger;
- no more than 3 proposed next Aristotle jobs;
- one recommendation about whether P9 is ready for a focused manuscript
  section.

### Phase 2: consolidate before expanding

Gemini should create or update planning notes before submitting more proof jobs.
The key consolidation targets are:

1. P9 shared API plan:
   - one reviewed `DiamondSourceVisibility` draft API;
   - separation of visible momentum closure, BF/surface closure, and observer
     invisibility;
   - explicit source pairing and observer-channel definitions.
2. P7 shared observer-channel plan:
   - finite distributions or matrices;
   - observer/coarse-graining channel;
   - relative-entropy loss;
   - recoverability gap;
   - exact connection point to P9 source visibility.
3. P6 concurrence/mass-ratio plan:
   - reduced visible density normalization;
   - concurrence or linear-entropy identity;
   - hypotheses under which monotonicity is valid.

Only after these plans are clear should Gemini submit new theorem jobs.

## New Aristotle job policy

### Allowed job types

1. Proof job
   - A standalone Lean file elaborates except for intended proof holes.
   - Imports are limited to Mathlib and copied local definitions unless a
     full-repo import is truly necessary.
   - A semantic context pack exists.
   - The prompt asks Aristotle to report statement changes, assumptions, solved
     targets, and remaining proof holes.

2. Definition-design job
   - No code build is expected.
   - The output must rank definitions by downstream theorem value.
   - The job must identify false starts and demotion criteria.

3. Audit job
   - No code generation required.
   - Aristotle or Gemini scores definitions/theorems against physics alignment.
   - The output is a report, not an integrated Lean file.

4. Counterexample/no-go job
   - Explicitly allowed when a branch is underdefined.
   - A refutation is success if it sharpens the gate.

### Disallowed jobs

- broad "prove this whole program" jobs;
- proof jobs whose statement has not elaborated locally;
- jobs over full `PhysicsSM` imports when a focused package would work;
- jobs submitted to keep concurrency full;
- jobs that duplicate a completed result without checking `aristotle list`;
- jobs that ask Aristotle to invent physics definitions without a claim boundary.

## Recommended first new jobs after triage

Submit none until Phase 1 is complete. Then choose at most two proof jobs and
one strategy/design job from this list.

### Highest-value P9 jobs

1. `DiamondSourceVisibility` API design refinement
   - Type: design/audit.
   - Goal: turn the P9 theorem atoms into one coherent finite API.
   - Output: definition list, theorem dependency graph, demotion criteria.

2. `visibleFan_characterization`
   - Type: proof.
   - Goal: characterize when a positive visible fan has zero moment mass/source.
   - Why: completes the non-collinearity no-go into an iff-style guardrail.

3. `bfClosure_implies_no_bulkDivergence`
   - Type: proof, if the source API is ready.
   - Goal: distinguish BF/surface closure from visible rest-frame closure.

4. `weightedResidual_vs_everpresentLambda_tension`
   - Type: proof or counterexample.
   - Goal: state exactly when weighted suppression beats `1 / sqrt(V)`.

### Highest-value P7/P6 jobs

1. `relativeEntropyDataProcessing_finiteChannel`
   - Type: proof, only if hypotheses are clean.
   - Goal: finite observer-channel monotonicity.

2. `massRatio_eq_concurrence_finiteQubit`
   - Type: proof.
   - Goal: connect normalized determinant mass ratio to concurrence/linear
     entropy in the exact finite convention used by P1/P6.

3. `recoverabilityGap_controls_sourceVisibility_definitional`
   - Type: design.
   - Goal: make P7 usable by P9 without overclaiming ANEC/QNEC.

### Manuscript support jobs

1. `rankOneNullMomentum_source_aligned`
   - Type: review/proof cleanup.
   - Goal: connect "each fine piece is massless" directly to the P1 manuscript.

2. `twoNullMassive_collinearity_iff`
   - Type: proof.
   - Goal: strengthen the accessible origin-of-mass explanation with a clean
     equality criterion.

## Gemini run loop

Each cycle:

1. Reconcile:
   - `git status --short`
   - `aristotle list --limit 20`
   - task notes for active jobs only.
2. Integrate before refill:
   - dry-run `integrate_completed.py`;
   - inspect helper report and diff;
   - check statement identity;
   - scan candidate files;
   - run `lake env lean <file>`;
   - only then copy/apply.
3. Update ledger:
   - status rows;
   - one-sentence scientific value;
   - next action.
4. Refill only if:
   - integration debt is below threshold;
   - the target is publication-relevant;
   - the statement or design prompt is clear.
5. Stop or pause if:
   - a proof requires changing the theorem statement;
   - P9 APIs remain duplicated after another proof;
   - two jobs in a row are support lemmas with no paper gate;
   - broad build problems recur;
   - semantic search or source grounding is unavailable for a source-sensitive
     claim.

## Concurrency rules

Phase 0:

- 0 new Aristotle jobs.

Phase 1:

- 0-1 new Aristotle jobs, only if the job fixes a direct integration blocker.

Phase 2:

- Up to 2 proof jobs plus 1 strategy/design job.

After the P9/P7 review packets are triaged:

- Up to 4-5 total active jobs if there are truly independent high-value targets.

Do not exceed 5 active Aristotle jobs without explicit user approval.

## Semantic search and literature rules

Use semantic search before literature-heavy claims:

```powershell
$py = "C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
& $py Scripts/lit/neo4j_doc_search.py --query "<repo-context query>"
& $py Scripts/lit/neo4j_paper_search.py --query "<paper/source query>"
```

Use context packs before nontrivial Aristotle jobs:

```powershell
$py = "C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
& $py Scripts/aristotle/make_context_pack.py --query "<target>" --slug "<slug>"
```

Add papers to Zotero/Neo4j only when:

- the paper is a primary guardrail or source for a live theorem/claim;
- DOI/arXiv duplicate checks pass;
- the plan records exactly what claim the paper supports.

Do not let literature search become a way to avoid theorem/API work.

## Integration quality gates

A result may be called "integrated draft" only after:

```text
statement identity checked
no placeholder/escape-hatch tokens in executable Lean
lake env lean <file> passed
targeted lake build <module> passed, unless explicitly deferred
ledger updated with project ID and verification
```

A result may be treated as "trusted" only after:

```text
all draft checks passed
semantic alignment reviewed
conventions reviewed
source provenance recorded
full lake build passed
pre-commit passed
```

No batch promotion from draft to trusted.

## Required Gemini output format

Every Gemini checkpoint should end with:

```text
Scientific progress:
- ...

Files changed:
- ...

Aristotle state:
- active:
- completed:
- integrated:
- blocked:

Verification:
- ...

Next best action:
- ...

Stop/demotion signals:
- ...
```

This keeps the run auditable and prevents "activity fog."

## Launch prompt for Gemini

```text
You are running an autonomous Gemini + Aristotle loop in the StandardModel Lean
repo. Your goal is publishable null-edge progress, not job count.

First read AGENTS.md, docs/ARISTOTLE.md,
Sources/Null_Edge_Causal_Graph_Publication_Plan.md,
AgentTasks/null-edge-claude-autonomous-run-postmortem-2026-06-23.md,
AgentTasks/null-edge-autonomous-run-postmortem-2026-06-23.md, and
AgentTasks/null-edge-gemini-aristotle-autonomous-run-plan-2026-06-23.md.

Phase 0 has no new Aristotle submissions. Reconcile the workspace, Aristotle
state, and Claude's uncommitted batch. Create or update
AgentTasks/null-edge-gemini-aristotle-run-ledger-2026-06-23.md. Classify the
uncommitted artifacts into KEEP-REVIEW, KEEP-INFRA, EXTRACT-REPORT, PARK, or
RETRY/REFUTE.

Prioritize P9 source visibility and the P7/P6 information-theoretic support
lane. Do not optimize for number of jobs. Submit new Aristotle jobs only after
triage, only with focused packages or clear strategy/design prompts, and only
when the result would move a publication gate.

Use semantic search and context packs for source-sensitive or nontrivial proof
jobs. Read diffs and integration helper reports, not whole output trees. Never
weaken theorem statements silently. Keep continuum physics claims conjectural
unless the finite theorem actually supports them.

End every checkpoint with Scientific progress, Files changed, Aristotle state,
Verification, Next best action, and Stop/demotion signals.
```

## Expected good end state

A successful Gemini run should leave:

- a clean run ledger;
- a reviewed classification of Claude's batch;
- P9/P7/P6 packets prioritized by publication value;
- no broad new unreviewed theorem sprawl;
- one or two genuinely high-value Aristotle submissions, if warranted;
- extracted strategy/design reports that are actually useful;
- updated publication-plan notes only where the new results justify them;
- clear stop/demotion signals for P9 if the finite source-visibility gate fails.

The best possible outcome is not that Gemini keeps Aristotle busy. The best
outcome is that it converts the current theorem burst into a smaller number of
reviewed, sourced, manuscript-ready claims.
