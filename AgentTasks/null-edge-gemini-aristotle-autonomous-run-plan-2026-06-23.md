# Gemini + Aristotle ambitious autonomous research plan

Date: 2026-06-23

Purpose: run Gemini as a serious autonomous research collaborator on the
null-edge causal graph program, using Aristotle as the proof engine and using
the repo's semantic-search, Neo4j, Zotero, and literature tooling as active
research infrastructure.

The goal is not to keep Aristotle busy. The goal is to create publishable
progress: sharper claims, better definitions, new finite theorem targets,
verified proof artifacts, source-backed manuscript sections, and clear
demotion criteria for branches that do not survive scrutiny.

## User-approved launch parameters

Gemini has the following permissions and constraints:

1. Repository edits are allowed.
   - Gemini may edit `AgentTasks/`, `Sources/`, docs, scripts, and draft Lean
     files when the edit directly advances the research program.
   - Gemini may integrate Aristotle results into draft Lean after the documented
     review gates.
   - Gemini must not silently rewrite broad unrelated surfaces.

2. Aristotle concurrency: up to 3 simultaneous jobs.
   - These can be proof, strategy/design, or audit jobs.
   - Gemini should not keep all three slots full for their own sake.
   - A slot is worth filling only when the target could move a publication gate.

3. P9 is the default top priority, not a prison.
   - P9 source visibility / cosmological constant remains the highest-risk,
     highest-upside branch.
   - Gemini should begin by asking whether P9 still has a realistic route to a
     substantial finite result.
   - If semantic search, literature, or theorem triage shows that another lane
     has higher impact or a cleaner near-term breakthrough, Gemini may pivot and
     must explain why.

4. Zotero/Neo4j writes are allowed for important papers.
   - Add papers only when they are real guardrails for a live claim, theorem, or
     manuscript section.
   - Always run duplicate checks by DOI/arXiv before adding.
   - Record what claim the source supports.

5. No commits.
   - Leave clean diffs, ledgers, verification output, and a final report.
   - Do not run `git commit`.

## North star

Every autonomous cycle should answer:

```text
What is the most publication-worthy thing we can make more true, more precise,
or more falsifiable today?
```

The run should prefer a single serious insight over ten mechanical support
lemmas. A good outcome may be a theorem, but it may also be a source-backed
definition, a no-go result, a manuscript-ready argument, a decisive literature
connection, or a clear reason to demote a tempting branch.

## Required reading before action

Gemini should start by reading these files:

- `AGENTS.md`
- `docs/BUILD.md`
- `docs/ARISTOTLE.md`
- `Scripts/MCP_SERVERS.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`
- `AgentTasks/null-edge-claude-autonomous-run-postmortem-2026-06-23.md`
- `AgentTasks/null-edge-autonomous-run-postmortem-2026-06-23.md`
- `AgentTasks/null-edge-goal-50-jobs-2026-06-22.md`

Then immediately run a semantic repo search on the live question it chooses,
rather than relying on memory or keyword grep.

## Tooling Gemini should actively use

### Aristotle

Use `docs/ARISTOTLE.md` as the canonical workflow. The preferred pattern is:

1. Use semantic search and context packs first.
2. Prepare a focused standalone package when possible.
3. Make the theorem statement elaborate locally.
4. Submit to Aristotle only after the target is clear.
5. Ask Aristotle for a completion report: solved targets, statement changes,
   remaining proof holes, and assumptions used.
6. Integrate by helper report and diff, not by reading giant output trees.

Useful commands:

```powershell
aristotle list --limit 30
aristotle tasks <project-id> --limit 10
python Scripts/aristotle/integrate_completed.py <project-id>
python Scripts/aristotle/integrate_completed.py --from-list
```

Focused package helper:

```powershell
& .\Scripts\prepare_aristotle_focused_submission.ps1 `
  -JobName <job-name> `
  -RootModule <RootModule> `
  -SourceRoot <standalone-source-root> `
  -LeanPath <RootModule>/Core.lean `
  -TaskNote AgentTasks/<task-note>.md
```

### Semantic search over our own work

Use this before creating theorem targets, strategy notes, or manuscript claims:

```powershell
$py = "C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
& $py Scripts/lit/neo4j_doc_search.py --query "<repo-context query>" --format markdown
```

Examples:

```powershell
& $py Scripts/lit/neo4j_doc_search.py --query "P9 source visibility boundary exact bookkeeping visible Plucker mass" --format markdown
& $py Scripts/lit/neo4j_doc_search.py --query "relative entropy observer channel recoverability source visibility" --format markdown
& $py Scripts/lit/neo4j_doc_search.py --query "Dirac square root Plucker mass superconnection block square" --format markdown
```

Refresh after meaningful edits:

```powershell
& $py Scripts/lit/neo4j_doc_search.py
```

### Semantic paper search over our Zotero/Neo4j library

Use this before deciding whether a physics claim is new or well grounded:

```powershell
& $py Scripts/lit/neo4j_paper_search.py --query "<paper/source query>" --format markdown
```

Examples:

```powershell
& $py Scripts/lit/neo4j_paper_search.py --query "causal set cosmological constant everpresent Lambda observational amplitude tension" --format markdown
& $py Scripts/lit/neo4j_paper_search.py --query "relative entropy ANEC recoverability quantum null energy condition" --format markdown
& $py Scripts/lit/neo4j_paper_search.py --query "Sorkin Johnston causal set entropy diamond area law truncation" --format markdown
& $py Scripts/lit/neo4j_paper_search.py --query "spin foam closure simplicity constraint coherent intertwiners source" --format markdown
```

### External literature search

Use MCP scholarly search or the shell helper described in
`Scripts/MCP_SERVERS.md` when the local library is missing a key source. Add
papers to Zotero only if they become active sources for a claim.

Minimum source workflow:

1. Search local Neo4j paper index first.
2. Search arXiv / Semantic Scholar / Crossref if the library is missing a
   needed source.
3. Check DOI/arXiv duplicates before adding to Zotero.
4. Add the paper to Zotero only if it is important.
5. Refresh paper embeddings.
6. Record the claim supported by the source in the run ledger or plan.

### Context packs for Aristotle

Before any nontrivial Aristotle job:

```powershell
& $py Scripts/aristotle/make_context_pack.py --query "<target>" --slug "<slug>"
```

Include the generated context pack in the task note or submission package. Reuse
the same pack during integration as the review cheat-sheet.

## Research agenda and dynamic priorities

Gemini should maintain a live ranked list of the top three active research
opportunities. The initial ranking is:

1. P9: cosmological constant / source visibility from diamond closure.
2. P7: observer channels, relative entropy, recoverability, and source
   invisibility.
3. P1/P2/P6 support: origin of mass, Dirac square root, concurrence, and
   internal Gram overlap.

This ranking is provisional. Gemini should update it when evidence changes.

### P9 decision question

The P9 branch is worth top priority only if Gemini can identify a finite
theorem or definition that does at least one of the following:

- separates visible momentum closure from BF/surface closure and observer
  invisibility;
- proves that a class of boundary-exact or internally coherent bookkeeping is
  invisible to closed bulk tests;
- proves that visible Plucker mass/energy sources a bulk diamond functional;
- gives a finite residual-noise scaling law strong enough to compare with
  everpresent-Lambda tension;
- imports a relative-entropy or recoverability diagnostic that turns "hidden"
  into a quantitative observer statement.

If Gemini cannot identify such a result after honest semantic and literature
search, it should demote P9 for this run and pivot to the next highest-impact
lane.

### P7 as P9's information-theoretic spine

P7 should not be treated as a separate essay unless it helps P9. The key
question is:

```text
Can source invisibility be formulated as information loss under a finite
observer channel, with relative entropy / recoverability measuring the gap?
```

Promising finite targets:

- finite data-processing inequalities for classical distributions or matrices;
- Petz/recoverability toy lemmas;
- observer-channel definitions shared by P7 and P9;
- a finite Sorkin-Johnston-style reference state for a causal diamond;
- a relative-entropy second-difference diagnostic for diamond source visibility.

### P1/P2/P6 as the stable theorem spine

If P9 stalls, Gemini should not flail. It should consolidate the strongest
banked line:

- P1: Plucker mass from null spinor bundles.
- P2: finite Dirac square root of Plucker mass.
- P6: internal Gram overlap / concurrence interpretation.

High-value work here includes:

- manuscript sections that make the Higgs/chirality/null-edge story accessible;
- convention tables and theorem-to-physics audits;
- promotion plans for kernel-clean draft modules;
- new finite theorem targets connecting concurrence, Gram overlap, and the mass
  manuscript.

## High-payoff autonomous behaviors

Gemini should look for work that could pay off big. Examples:

1. Find a missing definition that makes several theorem islands one theorem.
   - Example: a `DiamondSourceVisibility` API that unifies P9 boundary-exact
     invisibility, visible Plucker source, residual noise, and observer
     coarse-graining.

2. Turn a fuzzy physics phrase into a finite pass/fail theorem.
   - Example: replace "vacuum bookkeeping does not gravitate" with "boundary
     exact source cochains vanish against closed bulk tests."

3. Prove or ask Aristotle to prove a small no-go theorem that prevents bad
   interpretation.
   - Example: visible fan closure is a rest-frame massive condition, not source
     invisibility.

4. Use literature to add a guardrail that saves months of wrong framing.
   - Example: everpresent-Lambda observational amplitude tension, SJ entropy
     truncation, spin-foam simplicity-sector caveats, or ANEC recoverability
     hypotheses.

5. Draft a manuscript-ready argument while proofs run.
   - Example: a P9 section titled "Three Closures That Must Not Be Confused" or
     a P1 section explaining how the Higgs permits chirality flips without
     saying that the Higgs is a literal drag force.

6. Ask Aristotle for strategic proof scaffolding when definitions are immature.
   - Example: "Given this full P9 API sketch, identify the strongest finite
     theorem that is likely provable in Mathlib/Lean this week."

7. Demote a branch cleanly.
   - Example: if P9 can only restate causal-set everpresent Lambda without a new
     suppression or visibility theorem, record that and pivot.

8. Collapse duplicated draft surfaces.
   - Example: if three P9 modules prove variants of the same boundary-exact
     lemma, propose one shared API and one theorem naming convention.

9. Use semantic search to discover prior internal work before writing.
   - Example: query the repo for "closed visible fan rest energy" before
     designing a new source-visibility theorem.

10. Keep an evidence ledger.
    - For every claim, record whether it is trusted Lean, kernel-clean draft,
      source-backed prose, heuristic, or speculation.

## Launch phases

### Phase 0: orient and choose the live research question

Timebox: 30-45 minutes.

Actions:

1. Read the required files above.
2. Run:
   - `git status --short`
   - `aristotle list --limit 30`
   - semantic repo search for P9, P7, and P1/P2/P6.
   - semantic paper search for the strongest live physics question.
3. Create or update:
   - `AgentTasks/null-edge-gemini-aristotle-run-ledger-2026-06-23.md`
4. Record:
   - active Aristotle jobs;
   - completed but unintegrated jobs;
   - the top three live research opportunities;
   - whether P9 still appears to have a realistic high-impact route;
   - the first proposed action.

No new Aristotle job is required in Phase 0. Gemini may submit only if it finds
an obvious completed/staged blocker whose value is high and whose target is
already clean.

### Phase 1: research synthesis and target selection

Timebox: first substantive work block.

Gemini must produce a short research memo in the run ledger:

```text
Best current opportunity:
Claim it could support:
Existing Lean/prose anchors:
Key literature guardrails:
What would make it publishable:
What would kill or demote it:
Next theorem / definition / manuscript action:
```

For P9, the memo must explicitly distinguish:

```text
visible momentum closure
BF / surface closure
observer invisibility
boundary-exact bookkeeping
bulk source pairing
residual fluctuation scaling
```

For P7, the memo must explicitly name:

```text
observer algebra or channel
reference state
relative entropy / recoverability quantity
finite theorem target
connection to P9
```

For P1/P2/P6, the memo must explicitly name:

```text
state space
first-order operator or reduced-density object
exact square/determinant/concurrence identity
Higgs/chirality interpretation boundary
manuscript section affected
```

### Phase 2: execute with up to 3 active Aristotle jobs

Gemini may keep up to 3 Aristotle jobs active, chosen from independent lanes.
Good combinations:

- 1 focused proof job + 1 strategy scaffold + 1 audit job;
- 2 focused proof jobs + 1 literature-grounded design job;
- 1 P9 job + 1 P7 job + 1 P1/P2 support job.

Gemini should avoid three simultaneous jobs in the same narrow module unless the
results are obviously independent.

Before each submission:

1. Check `aristotle list --limit 30` to avoid duplicates.
2. Generate or reuse a context pack.
3. Verify the target file elaborates locally, if it is a proof job.
4. Write a task note with project metadata, expected check command, source
   context, and completion-report request.
5. Submit.
6. Record the project ID immediately.

### Phase 3: integrate, consolidate, and write

Whenever a job completes, Gemini should:

1. Run the integration helper in dry-run mode.
2. Read the helper report and diff, not the whole extracted tree.
3. Stop if theorem statements changed unexpectedly.
4. Run placeholder/escape-hatch scans on candidate Lean.
5. Run `lake env lean <file>`, then targeted `lake build <module>`.
6. Update the run ledger.
7. If the result is scientifically important, update the relevant plan or
   manuscript section.

Gemini should use waiting time well:

- perform literature searches;
- add important sources to Zotero/Neo4j;
- write manuscript sketches;
- consolidate APIs;
- prepare next theorem statements;
- produce audit notes.

## Ambitious Aristotle job menu

Gemini should not submit this menu blindly. It should choose after analysis.

### P9 flagship candidates

1. `DiamondSourceVisibility` strategy/audit job
   - Ask Aristotle to read the P9 plan/context pack and propose a minimal finite
     API that separates visible closure, BF closure, observer invisibility, and
     source pairings.
   - Success: a definition dependency graph and three theorem targets.

2. `boundaryExact_invisible_to_closedBulkTests`
   - Proof job if already isolated.
   - Success: a finite cochain/source theorem showing exact bookkeeping is
     invisible to closed bulk observables.

3. `visiblePluckerMass_sources_bulkPairing`
   - Proof or design job.
   - Success: a finite theorem showing non-collinear visible null fans generate
     a nonzero bulk source functional under explicit hypotheses.

4. `weightedResidualSuppression_threshold`
   - Proof/counterexample job.
   - Success: exact finite inequality identifying when weighted residual noise
     beats or fails to beat everpresent-Lambda scaling.

5. `sjReferenceState_for_finiteDiamond`
   - Strategy/design job with literature context.
   - Success: a finite matrix definition that could support relative entropy on
     causal diamonds without overclaiming continuum entropy.

### P7 information candidates

1. `finiteObserverChannel_dataProcessing`
   - Proof job in classical finite distributions or matrices.
   - Success: a reusable finite monotonicity lemma.

2. `recoverabilityGap_controls_visibility_toy`
   - Design/proof hybrid.
   - Success: a toy theorem or definition that makes source visibility a
     recoverability statement.

3. `qubitConcurrence_massRatio_monotonicity_boundary`
   - Proof/audit job.
   - Success: exact finite qubit identities plus a clear statement that
     monotonicity needs local/LOCC hypotheses.

### P1/P2/P6 consolidation candidates

1. `massRatio_eq_concurrence_finiteQubit`
   - Proof job.
   - Success: clean theorem connecting normalized determinant mass to
     concurrence / linear entropy.

2. `higgsChiralityFlip_operator_audit`
   - Audit/design job.
   - Success: score each Higgs/chirality definition against Standard Model
     physics and propose comments for ambiguous code.

3. `originOfMass_accessible_section`
   - Manuscript job for Gemini itself, not Aristotle.
   - Success: a high-school-accessible but honest Higgs/null-edge explanation.

4. `internalGramOverlap_flavor_literature_bridge`
   - Literature + manuscript job.
   - Success: source-backed comparison to Froggatt-Nielsen, split fermions,
     quantum marginals, and Jarlskog constraints, with explicit claim boundary.

## Literature and Zotero/Neo4j rules

Gemini may add papers when important. A paper is important if it is one of:

- a primary source for a theorem target;
- a guardrail that prevents an overclaim;
- a direct prior-art comparison for a manuscript;
- a mathematical source needed to state a Lean theorem correctly.

Do not add broad "maybe related" papers.

For every added paper, record:

```text
title:
doi/arxiv:
Zotero key:
Neo4j status:
claim supported:
where cited or planned:
```

After adding, refresh:

```powershell
& $py Scripts/lit/neo4j_paper_search.py
```

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

## Stop, pivot, and demotion rules

Gemini should stop or pivot when:

- P9 only restates everpresent Lambda without a new finite source-visibility,
  suppression, or recoverability theorem;
- a theorem requires weakening the statement;
- a definition conflates visible momentum closure, BF closure, and observer
  invisibility;
- literature search reveals the claim is already known and the repo adds no
  formalization or new finite wrapper;
- two consecutive jobs produce only low-level support lemmas with no manuscript
  gate;
- broad build or packaging failures recur;
- semantic search or source grounding is unavailable for a source-sensitive
  claim.

Demotion is progress if it keeps the program honest.

## Required checkpoint format

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

Literature / Neo4j state:
- searches run:
- papers added:
- claim support updated:

Verification:
- ...

Next best action:
- ...

Stop/demotion signals:
- ...
```

## Launch prompt for Gemini

```text
You are running an ambitious autonomous Gemini + Aristotle research sprint in
the StandardModel Lean repo. Your goal is publishable null-edge progress, not job
count.

You may edit repository files, including docs, task notes, manuscript drafts,
and draft Lean, but you must not commit. You may run up to three simultaneous
Aristotle jobs, but only when the targets are independent and publication-
relevant. You may add important papers to Zotero/Neo4j after duplicate checks.

Start by reading AGENTS.md, docs/BUILD.md, docs/ARISTOTLE.md,
Scripts/MCP_SERVERS.md, Sources/Null_Edge_Causal_Graph_Publication_Plan.md,
Sources/Null_Edge_Causal_Graph_Strengthened_Program.md,
Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md,
AgentTasks/null-edge-claude-autonomous-run-postmortem-2026-06-23.md,
AgentTasks/null-edge-autonomous-run-postmortem-2026-06-23.md,
AgentTasks/null-edge-goal-50-jobs-2026-06-22.md, and this plan.

Then run semantic searches over the repo and paper library before choosing your
research direction. P9 source visibility / cosmological constant is the default
top priority, but you may pivot if your analysis shows another lane has higher
impact or a cleaner near-term breakthrough. Explain any pivot.

Create or update
AgentTasks/null-edge-gemini-aristotle-run-ledger-2026-06-23.md. In the ledger,
rank the top three research opportunities, name the finite theorem or
definition each could produce, record the literature guardrails, and choose the
first action.

Use Aristotle as a proof specialist. For proof jobs, prepare focused packages
whose theorem statements elaborate locally. Generate context packs for
nontrivial jobs. Ask Aristotle for completion reports. Integrate with the repo
helper, diff review, placeholder scans, Lean checks, and targeted builds.

Use waiting time for serious research: literature searches, Zotero/Neo4j adds
for important papers, manuscript sketches, API consolidation, theorem design,
and audit notes. Look for high-payoff moves: definitions that unify theorem
islands, no-go results that sharpen claim boundaries, source-backed guardrails,
and manuscript-ready arguments.

End every checkpoint with Scientific progress, Files changed, Aristotle state,
Literature / Neo4j state, Verification, Next best action, and Stop/demotion
signals.
```

## Expected good end state

A successful Gemini run should leave:

- a clear run ledger with ranked research opportunities;
- a real assessment of whether P9 still deserves top priority;
- one or more high-value Aristotle jobs, up to three active at a time;
- integrated completed results only when they pass review gates;
- source-backed P9/P7/P1-P2-P6 research notes;
- important papers added to Zotero/Neo4j with claim support recorded;
- manuscript-ready paragraphs or section outlines where appropriate;
- fewer duplicated theorem surfaces, not more;
- explicit demotion criteria for branches that fail;
- no commits.

The best possible result is that Gemini discovers the next genuinely strong
paper claim and builds the proof/literature/manuscript scaffolding around it.
