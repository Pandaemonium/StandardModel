# Codex six-lane Aristotle + multi-model research plan

Date: 2026-06-23. Updated morning 2026-06-23 for Spark/Gemini/Claude access.

Purpose: run Codex autonomously overnight on the null-edge causal graph program,
with up to six simultaneous Aristotle jobs queued when the targets are genuinely
worth the proof budget, and with Spark/Gemini/Claude used as force multipliers
for research, integration, and hard-problem analysis. The run should optimize
for publishable progress, not for activity. A good run produces one or more of:

- a new finite theorem that strengthens a paper claim;
- a sharper definition that unifies several theorem islands;
- a strategy/audit report that changes the priority order;
- a manuscript-ready section backed by theorem and source references;
- a clean no-go or demotion criterion for an overextended branch.

The default scientific north star is P9, the cosmological-constant/source-
visibility branch. P9 remains the highest-upside lane only while it is producing
finite definitions, proofs, or falsifiable guardrails. If it stalls into
vocabulary, pivot to the strongest theorem spine: origin of mass, observer
channels, Dirac square roots, and higher-gauge curvature.

The compact Pro-guided spine for the night is:

```text
Plucker geometry
-> observer-conditioned celestial qubit
-> chirality coherence
-> null-step dynamics
-> calibrated stable/metastable channel sectors.
```

When choosing between otherwise comparable jobs, prefer the one that proves or
clarifies a link in this chain. Broad ontology, gravity, or particle-language
jobs should be allowed only when they specify a finite channel, readout,
operator, source functional, or falsification gate.

## User-approved operating constraints

1. Repository edits are allowed.
   - Edit `AgentTasks/`, `Sources/`, docs, scripts, and draft Lean when the edit
     directly advances the research program.
   - Do not commit.
   - Do not promote draft modules to trusted modules during the autonomous run.

2. Aristotle concurrency is up to six simultaneous jobs.
   - Six is a ceiling, not a target.
   - A slot is worth filling only if success would move a publication claim,
     theorem spine, falsification criterion, or important manuscript section.
   - Avoid six near-duplicate jobs. The queue should cover different failure
     modes.

3. P9 is the default top priority, not a prison.
   - Prioritize P9 while there is a realistic finite route to source visibility,
     residual suppression, or a reference-state/recoverability theorem.
   - Demote P9 for the night if the best available work becomes only metaphor.
   - Keep the Pro critique caveat visible: recoverability is not invisibility.
     Recoverability says fine information can be reconstructed from an observer
     output; invisibility says distinct fine sources become indistinguishable to
     that output. P9 jobs must state which notion they are proving.

4. Literature and Zotero/Neo4j additions are allowed when useful.
   - Search local semantic paper index first when credentials are available.
   - Do at least one deliberate literature-search pass for every five Aristotle
     jobs submitted or integrated. This is a floor, not a ceiling: P9 and any
     claim touching prior art, observational viability, or named physics
     mechanisms should trigger a search before the next proof batch.
   - Add papers only if they become active guardrails for a claim or theorem.
   - Record which claim each source supports.

5. Use low-token integration discipline.
   - Read diffs and helper reports, not whole extracted projects.
   - Verify theorem statement identity mechanically where possible.
   - Run targeted checks before broad builds.

6. Use GPT-5.3-Codex-Spark subagents liberally as an experiment.
   - Prefer Spark for bounded, parallelizable work: literature triage,
     semantic-search summaries, Aristotle completion triage, diff inspection,
     task-note cleanup, source crosswalks, small manuscript sketches, and
     verification/checklist passes.
   - Keep Codex's main thread focused on high-level strategy, physics judgment,
     claim boundaries, final integration decisions, and critical review.
   - Assign Spark tasks with disjoint write scopes when edits are allowed. For
     read-only work, ask for a concise evidence-backed report with file paths,
     source keys, job IDs, and concrete next actions.
   - Do not let Spark promote draft code to trusted code or make commits.
   - Record where Spark performs well or struggles in
     `AgentTasks/null-edge-model-delegation-evaluation-log-2026-06-23.md`.

7. Use Gemini and Claude as hard-problem external critics.
   - Query Gemini when a difficult issue would benefit from a broad independent
     synthesis, especially novel physics, P9, ontology-to-theorem translation,
     manuscript framing, or a surprising Aristotle result.
   - Query Claude when a difficult issue would benefit from adversarial
     critique, theorem-statement sharpening, physics guardrails, or source
     skepticism.
   - Nominal cadence: Gemini about once per six Aristotle jobs and Claude about
     once per twelve Aristotle jobs. Treat this as a reminder, not a quota:
     query them when the problem is important enough to justify multiple takes.
   - Do not paste secrets or private credentials into prompts. Use concise
     context packs and ask for actionable theorem targets, failure modes, and
     literature leads.
   - Record where Gemini and Claude do well or struggle in the same evaluation
     log.

## Multi-model delegation protocol

The run should deliberately test what the new model stack is good for.

### Spark subagents

Use GPT-5.3-Codex-Spark subagents as the default delegation layer for bounded
tasks. Good Spark prompts have:

- a fixed input scope, such as one task note, one Aristotle output, one doc
  section, or one small Lean module cluster;
- one concrete objective;
- at most three fallback questions;
- an explicit output format: changed files, candidate diffs, source keys,
  theorem names, risk list, or next-action list;
- a warning not to revert unrelated work and not to promote trusted modules.

Prefer Spark for:

- literature triage and source relevance checks;
- semantic-search result summarization;
- Aristotle job integration triage: candidate files, diff summaries, statement
  drift checks, proof-hole scans, and verification-command proposals;
- small bounded repo edits in disjoint files;
- manuscript section sketches when theorem anchors are already known;
- lint/noise audits on touched files;
- queue/ledger bookkeeping.

Do not use Spark for:

- final physics judgment;
- broad ontology synthesis without a finite target;
- trusted promotion decisions;
- silent theorem-statement changes;
- committing.

### Gemini and Claude escalation

Gemini and Claude are not routine workers. They are external critical lenses for
hard problems. Use the available API/CLI helpers when configured; if no helper is
available in the active shell, record that as a tooling blocker rather than
stalling the run.

Use Gemini when the run needs:

- broad synthesis over many lines of inquiry;
- speculative but disciplined theorem proposals;
- literature-search angles for a difficult physics branch;
- alternative ways to phrase a manuscript argument;
- a fresh attempt to connect P9, P7, P1/P6, or P2/P3.

Use Claude when the run needs:

- adversarial critique;
- convention and physics-claim audits;
- theorem-statement sharpening;
- failure modes and demotion criteria;
- skepticism about whether a claimed result is actually new.

Nominal cadence:

- Gemini once per roughly six Aristotle jobs submitted or integrated.
- Claude once per roughly twelve Aristotle jobs submitted or integrated.

These are prompts to remember escalation, not quotas. If the highest-value
problem is hard, ask earlier. If the current batch is clean Lean plumbing, skip.

Every Spark/Gemini/Claude use must be recorded in
`AgentTasks/null-edge-model-delegation-evaluation-log-2026-06-23.md`.

## Current state snapshot

Recent Gemini/Aristotle work produced meaningful draft artifacts:

- `PhysicsSM.Draft.NullEdgeP9WeightedSuppressionThreshold`
  proves a finite necessary condition: beating everpresent-Lambda-style scaling
  requires sub-extensive total residual scale.
- `PhysicsSM.Draft.NullEdgeP9ResidualVarianceCellArea`
  proves a cell-area style bound on weighted residual second moment.
- `PhysicsSM.Draft.NullEdgeP7PetzRecovery`
  proves classical finite KL data processing and Petz equality/recovery
  scaffolding.
- `PhysicsSM.Draft.NullEdgeP7RecoverabilityGap`
  packages observer loss and recoverability-gap bookkeeping.
- `PhysicsSM.Draft.NullEdgeP6Concurrence`
  now includes the real two-qubit concurrence square equals four times the
  visible reduced determinant.
- The newest Pro critique says P1/P6 should use an observer-conditioned
  celestial state `rho_{p|u}`, not bare `P / Tr(P)` unless a frame is fixed.
  It also says Higgs/Yukawa coupling first creates chirality coherence; visible
  mixedness appears only after an explicit observer/dephasing/trace channel.
- The same critique promotes the null-step quantum walk
  `U_a(k) = exp(-i k a sigma_z) exp(-i mu a sigma_x)` as the best dynamics
  bridge: its quasienergy relation and chirality coherence limit connect
  luminal conditional shifts, chirality flips, Dirac dispersion, and `m/E`.
- The useful P11 lesson is not "particles are bundles" but "particles are
  stable or metastable sectors of a transfer channel." A P11 job should therefore
  name a calibrated momentum readout, a branch `lambda_a(k)`, and a mass-shell
  target before asking Aristotle for proof work.
- It also sharpens two guardrails: raw Plucker phases are not spin unless
  packaged into rephasing-invariant Bargmann/Pancharatnam or little-group
  observables, and a finite source functional is not gravity until a response
  law, conservation identity, universality statement, and scaling limit are
  specified.
- `AgentTasks/aristotle-p9-sj-reference-state-report.md`
  gives a promising finite Sorkin-Johnston reference-state design, but no Lean
  theorem yet.
- One important P9 design job may still be running:
  `45929669-f4b1-4cbf-9f49-e4f624ef66bc`
  (`null-edge-p9-diamond-source-visibility-api-design`).

Before launching fresh jobs, check whether that running job has completed and
whether any completed jobs are not yet integrated.

## Startup sequence

Run this sequence at the beginning of the overnight loop:

```powershell
git status --short
aristotle list --limit 30
python Scripts/aristotle/integrate_completed.py --from-list
lake env lean PhysicsSMDraft.lean
```

If `integrate_completed.py --from-list` is unavailable or too noisy, use
`aristotle tasks <id>` plus targeted extraction/diff inspection for the relevant
IDs only.

If semantic search credentials are available, refresh and query the repo index:

```powershell
$py = "C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
& $py Scripts/lit/neo4j_doc_search.py
& $py Scripts/lit/neo4j_doc_search.py --query "P9 source visibility boundary exact bookkeeping visible Plucker mass" --format markdown
& $py Scripts/lit/neo4j_doc_search.py --query "relative entropy observer channel recoverability source visibility" --format markdown
& $py Scripts/lit/neo4j_doc_search.py --query "Sorkin Johnston finite causal diamond area law truncation" --format markdown
```

If Neo4j credentials are missing, do not spend the night repairing environment
state unless it directly blocks the next best theorem target. Fall back to local
files, context packs, and explicit literature MCP searches.

Spark startup delegation:

- Spawn one Spark subagent to review `aristotle list --limit 30` output and
  identify completed jobs likely worth integrating.
- Spawn one Spark subagent, if useful, to run/read semantic-search outputs for
  the highest-risk active lane and return only the top source/theorem leads.
- Keep Codex on strategy: choose which jobs matter, decide whether a result is
  publication-moving, and resolve contradictions between model reports.

Do not block the whole startup waiting for Spark unless the next action depends
on its result. Continue with non-overlapping status checks and local builds.

## Six overnight lanes

### Lane A: P9 diamond source visibility API

Purpose: create the finite API that makes the cosmological-constant branch
mathematically testable.

Good Aristotle jobs:

- design a minimal `DiamondSourceVisibility` API separating:
  visible momentum closure, BF/surface closure, observer invisibility,
  boundary-exact bookkeeping, bulk source pairing, and residual fluctuation;
- prove boundary-exact source invisibility against closed/bulk tests;
- prove visible Pluecker fans source a nonzero bulk pairing under explicit
  hypotheses;
- audit whether existing P9 modules duplicate or conflict.

Success criterion:

- one clean theorem or definition set that lets a paper say exactly which
  sources are invisible and which are visible.

Failure criterion:

- the API cannot distinguish boundary bookkeeping from bulk source terms, or the
  definitions make the desired statement tautological.

### Lane B: P9 Sorkin-Johnston reference state

Purpose: give P9 a concrete finite vacuum/reference-state model.

Starting point:

- `AgentTasks/aristotle-p9-sj-reference-state-report.md`.

Good Aristotle jobs:

- prove a real antisymmetric Pauli-Jordan matrix gives Hermitian `iDelta`;
- define the positive spectral projection as an SJ two-point function;
- prove positive semidefinite and Peierls-style structural properties in a
  finite matrix model;
- define finite spectral truncation/window masks;
- produce a small hand-auditable 3-chain or 4-diamond example.

Success criterion:

- a kernel-checked finite SJ scaffold or a design report precise enough to be
  the next proof package.

Failure criterion:

- Mathlib spectral APIs make the theorem too heavy for overnight proof search;
  then keep the design and submit a smaller Hermitian/antisymmetric lemma.

### Lane C: P9 residual suppression and observational threshold

Purpose: convert finite suppression algebra into a falsifiable comparison with
everpresent-Lambda tension.

Good Aristotle jobs:

- strengthen `A^2/N` and weighted residual results into a parameter-threshold
  theorem;
- prove necessary and sufficient conditions for a weight distribution to beat a
  chosen benchmark;
- make the role of cell area and total residual scale explicit;
- write a source-backed note comparing the finite theorem to Sorkin/Das-
  Nasiri-Yazdi amplitude constraints.

Success criterion:

- a statement of the form: under hypotheses H, residual second moment is below
  benchmark B; without sub-extensive scale, it cannot be.

Failure criterion:

- suppression requires assuming the conclusion, or cannot be tied to any
  observer-visible source functional.
- the lane proves only that a mean source vanishes while leaving a nonzero
  noise/source second moment with no diamond response law.

### Lane D: P7 observer-channel recoverability

Purpose: make observer-channel mixedness the information-theoretic spine for
source visibility.

Good Aristotle jobs:

- strengthen classical observer-channel data processing/recoverability lemmas;
- relate source invisibility to zero observer loss in a finite model;
- define a toy source-visibility defect bounded by recoverability gap;
- audit what can and cannot be imported from quantum Petz/Fawzi-Renner without
  proving matrix relative entropy.
- split recoverability and invisibility into separate finite definitions, with
  a theorem only when the chosen observer map supports it.

Success criterion:

- a finite theorem or precise no-go saying whether the selected observer channel
  gives recoverability, indistinguishability, or both; no conflation of the two.

Failure criterion:

- recoverability remains disconnected from diamond source observables.

### Lane E: P1/P6 origin-of-mass frame audit and manuscript spine

Purpose: turn the banked mass/concurrence theorem into publication text and
make the invariant/frame-relative distinction kernel-checkable.

Good Aristotle jobs:

- prove or scaffold observer-conditioned normalization:
  `rho_{p|u} = U^{-1/2} P U^{-1/2} / Tr(U^{-1} P)` and
  `2 sqrt(det rho_{p|u}) = m / (p dot u)` under explicit finite matrix
  hypotheses;
- prove or scaffold the observer-relative two-null decomposition of a timelike
  momentum:
  `k_+^2 = k_-^2 = 0` and `k_+ + k_- = p` for the distinguished pair defined
  by `u`, `p`, and the observed spatial direction;
- prove `det(A * P * A^dagger) = det(P)` for `A in SL(2,C)`;
- prove `det(P / Tr(P)) = det(P) / Tr(P)^2` for `2 x 2` matrices under the
  needed nonzero-trace hypothesis;
- prove or scaffold `restFrame_iff_normalizedMomentum_maximallyMixed`;
- prove normalized mass ratio equals concurrence under explicit trace-one
  hypotheses, with the claim boundary "this is `m/E`, not invariant mass";
- connect real two-qubit concurrence to the visible celestial determinant;
- write a source-backed prior-art note on Chin-Lee `1407.2492` and the
  Peres-Scudo-Terno / Gingrich-Adami frame-dependence guardrails;
- audit the Higgs/chirality-flip language for Standard Model correctness;
- prove the two-level chirality-coherence identity for
  `H_h = [[-h |p|, m], [m, h |p|]]`, namely that the positive-energy projector
  has `2 |Pi_LR| = m/E`;
- scaffold the null-step quantum-walk identity
  `cos(omega a) = cos(k a) cos(mu a)` and its continuum chirality-coherence
  limit `mu / sqrt(k^2 + mu^2)`;
- prepare a manuscript section explaining mass as observer-channel mixedness
  while preserving the accessible high-school-level introduction.

Success criterion:

- a manuscript-ready origin-of-mass explanation whose exact theorem anchors are
  named, whose prior art is cited, and whose normalized mixedness language is
  explicitly frame-relative.

Failure criterion:

- the text claims Higgs dynamics or mass-generation universality beyond the
  finite determinant/channel theorem, or treats normalized `rho_vis` mixedness
  as a Lorentz scalar.
- a proof target only shows a possible null decomposition but does not identify
  a first-order transfer operator or observer-conditioned readout.

### Lane F: P2/P3 operator and higher-gauge integration

Purpose: keep the program first-order/operator-driven rather than a collection
of scalar invariants.

Good Aristotle jobs:

- connect the simplified crossed-module/fake-flatness module to the trusted
  causal-diamond holonomy API;
- prove a genuine interchange law over existing path-pair composition, or
  isolate the obstruction;
- advance the finite super-Dirac square:
  `d_U + delta_U + Phi + Phi^dagger`;
- produce an audit explaining which existing scalar invariants are squares of
  explicit first-order operators.
- if the operator lane needs a nonblocking strategy job, define the minimal
  finite channel-sector scaffold for particles: a transfer channel, calibrated
  momentum readout `P = M(rho)`, peripheral/metastable eigenmodes, and the
  branch form
  `lambda_a(k) ~= exp(-((Gamma_a(k)/2) + i E_a(k)) Delta t)`. Treat this as a
  design target unless it yields a small matrix theorem.

Success criterion:

- one bridge from a banked square-level theorem to a first-order operator or
  higher-gauge composition law.

Failure criterion:

- the lane adds formal algebra that does not touch the actual null-edge theorem
  spine.

## Queue construction rules

When starting the overnight run, aim for this first queue if the targets are
ready:

1. Lane A proof/design: P9 diamond source visibility API.
2. Lane B proof: finite SJ Hermitian/positive-part scaffold.
3. Lane C proof: residual suppression threshold or benchmark comparison.
4. Lane D proof: observer loss / recoverability gap controls a toy visibility
   defect.
5. Lane E proof or manuscript: frame-invariance audit for unnormalized `det(P)`,
   normalized `m/E` wrapper, Higgs/chirality audit, or the null-step
   quantum-walk coherence bridge.
6. Lane F proof/design: existing diamond interchange/crossed-module bridge.

If a fresh strategy pass says the channel-sector direction is currently the
highest-impact route, let it displace the weakest active lane for one job. Do
not run it as broad ontology: require a concrete channel, readout, spectral
branch, and mass-shell target.

At least three active jobs should be proof jobs. At most one active job should
be manuscript/literature-only unless a source discovery clearly unlocks a
theorem.

Model cadence and escalation:

- Keep a running job counter in the ledger for Aristotle jobs submitted or
  integrated.
- Around every sixth Aristotle job, run one Gemini escalation on the highest-risk
  unresolved lane unless current lanes are purely mechanical.
- Around every twelfth Aristotle job, run one Claude escalation for independent
  critique of the current risk profile.
- If Spark flags low confidence, repeated convention risk, or possible
  novelty/prior-art conflict, use Gemini or Claude before adding more jobs in
  that lane.
- If Gemini/Claude returns a new constraint or contradiction risk, re-baseline
  the active queue before submitting additional jobs.

Track the literature cadence in the run ledger. After every fifth Aristotle job
submitted or integrated, pause long enough to run one focused literature pass
against the highest-risk active claim. The search can be quick, but it must end
with a concrete decision: add a source to Zotero/Neo4j, update a claim boundary,
change a theorem statement, or record that no useful source was found.

Spark should usually run the first-pass literature triage. Codex should review
the source quality and decide whether to add papers, update claims, or change
the theorem target.

Do not submit a new job if:

- a nearly identical job is already running or idle but not integrated;
- the theorem statement does not elaborate locally;
- the target can be solved locally in under roughly 20 minutes;
- the job would mostly ask Aristotle to read broad repo context instead of a
  focused package or compact task note.

## Aristotle submission template

Every proof job should ask Aristotle to end with a compact completion report:

```text
Completion report:
- solved targets:
- unchanged theorem statements? yes/no, list changes:
- remaining proof holes:
- assumptions or escape hatches used:
- suggested next theorem:
```

Every job note should include:

- target file and module;
- exact theorem statements;
- allowed imports;
- local check command;
- context pack path, when available;
- claim boundary: what the theorem does and does not prove physically.

For nontrivial targets, make a context pack:

```powershell
$py = "C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
& $py Scripts/aristotle/make_context_pack.py --query "<target>" --slug "<slug>"
```

Prefer focused standalone packages for proof-only targets:

```powershell
& .\Scripts\prepare_aristotle_focused_submission.ps1 `
  -JobName <job-name> `
  -RootModule <RootModule> `
  -SourceRoot <standalone-source-root> `
  -LeanPath <RootModule>/Core.lean `
  -TaskNote AgentTasks/<task-note>.md
```

## Integration loop

Every time a job completes:

1. Use `aristotle tasks <id>` to inspect final status.
2. Use helper reports or extracted diffs rather than reading entire projects.
3. Verify theorem statements did not silently weaken.
4. Scan for raw Lean placeholder/escape-hatch tokens in integrated files.
5. Run the smallest relevant check:

```powershell
lake env lean PhysicsSM/Draft/<File>.lean
lake env lean PhysicsSMDraft.lean
```

6. Update the run ledger with:
   - job ID;
   - model/subagent used, if any: Spark, Gemini, Claude, Aristotle, Codex;
   - task type: proof, integration, literature, verification, manuscript,
     strategy, critique;
   - what was proved or returned;
   - whether integrated;
   - verification commands;
   - scientific significance;
   - model outcome: success, partial, failed, blocked, or noisy;
   - quality score `0-3` and one-sentence reason;
   - whether escalation was used or skipped, and why;
   - next target.

7. Add or update the model evaluation log:

```text
[timestamp] [lane] [job/model] [task-type] [status] [quality 0-3]
what worked:
what worried:
follow-up:
```

8. Only after a stable batch, run broader checks:

```powershell
git diff --check
pre-commit run --files <touched-files>
```

Run full `lake build` only when the integrated batch is stable or before a
final handoff if time permits.

## Literature loop

Use literature search to sharpen theorem statements, not to decorate prose.
The default cadence is at least one focused literature pass per five Aristotle
jobs. Count both submitted and integrated jobs; if the run submits five jobs
before any have completed, search before submitting the sixth unless an urgent
repair job is needed to save a running lane.

Default pattern:

1. Give Spark a bounded literature triage task: one claim, one lane, or one
   theorem target.
2. Use local Neo4j semantic search and provider-specific scholarly searches.
3. Ask Gemini/Claude only if the source landscape changes a high-risk claim or
   if the literature conflicts with our current framing.
4. Codex decides whether to add sources to Zotero/Neo4j or update the docs.

Priority questions:

1. P9: What does everpresent-Lambda actually require for amplitude suppression
   or observational viability?
2. P9: What finite SJ truncation facts are known for causal diamonds and area
   laws?
3. P7: Which recoverability facts are safe in classical finite channels, and
   what requires full quantum matrix relative entropy?
4. P1/P6: Which concurrence/mixedness statements are standard, and which are
   our finite null-edge packaging?
5. P3/P2: Which crossed-module/fake-flatness or superconnection facts are
   standard enough to cite rather than rediscover?

When adding a paper to Zotero/Neo4j, record:

- DOI/arXiv duplicate check result;
- Zotero key;
- claim supported;
- whether it is a guardrail, prior art, or theorem source.

### Semantic Scholar fallback ladder

Semantic Scholar is useful for citation-rich discovery, but it is often the
first service to rate-limit. When that happens, do not stall the run. Use this
fallback ladder:

1. **Local Neo4j semantic index first.** Query the project docs, Lean files, and
   already-added literature before spending external API budget.
2. **OpenAlex for broad discovery.** It is a large open scholarly catalog with
   work/author/source/topic metadata and is the best general replacement for a
   first-pass Semantic Scholar query.
3. **arXiv for physics/math preprints.** Use it for current high-energy,
   quantum-information, gravity, and math-ph literature, especially when a
   theorem target has an arXiv-shaped title or author trail.
4. **INSPIRE-HEP for high-energy physics and quantum gravity.** Prefer it for
   spin foams, amplitudes, twistor physics, causal sets, Standard Model, and
   graviweak searches.
5. **Crossref for DOI-backed metadata and exact bibliographic checks.** It is
   better for DOI resolution and journal metadata than for exploratory ranking.
6. **Europe PMC for biomedical or quantum-biology-adjacent sources.** Usually
   not first-line for null-edge physics, but useful when a claim touches
   measurement, information theory, or biological analogies.
7. **NASA ADS for cosmology/astrophysics.** Use it when P9 needs observational
   cosmology, CMB, dark-energy, or astrophysical constraints; expect API-key
   requirements.
8. **Unpaywall/DataCite as metadata helpers.** Use Unpaywall to locate legal
   open-access PDFs after a DOI is known, and DataCite for dataset/preprint DOI
   metadata when Crossref is thin.

In MCP terms, prefer `search_openalex`, `search_arxiv`,
`search_inspirehep`, `search_crossref`, `search_europe_pmc`, and
`resolve_open_access` when `search_semantic_scholar` is rate-limited. The
combined `search_papers` meta-search is convenient, but if it fails because one
provider is rate-limited, retry the relevant provider-specific searches instead
of abandoning the literature pass.

## Publication-value scoreboard

Score each result from 0 to 3 before deciding whether to integrate, document, or
queue a follow-up.

```text
3 = publication-moving result:
    proves a theorem, fixes a claim boundary, or creates a definition needed by
    a paper.

2 = useful support:
    cleans a theorem wrapper, improves a manuscript section, or clarifies
    provenance.

1 = bookkeeping:
    correct but not scientifically meaningful by itself.

0 = distraction:
    broad, redundant, misleading, or too disconnected from theorem spine.
```

Only score-2 or score-3 outcomes should get follow-up Aristotle jobs overnight.

## Stop, pivot, and demotion rules

Stop a lane for the night if:

- two consecutive jobs return only strategy without a theorem or precise next
  statement;
- a proof target depends on changing definitions in a way that weakens the
  physics claim;
- a source search shows the claim is already standard and our finite wrapper
  adds no new content;
- P9 cannot connect suppression to observer-visible source functionals.

Pivot order:

1. P9 source visibility and reference state.
2. P7 observer-channel/recoverability theorem spine.
3. P1/P6 origin-of-mass and concurrence manuscript theorem wrappers.
4. P2/P3 operator and higher-gauge bridges.
5. Literature/manuscript consolidation.

## Final overnight handoff

End with a concise report:

```text
Summary:
- jobs submitted:
- jobs completed:
- jobs integrated:
- most significant scientific result:
- most important negative result or demotion:
- model/subagent experiment summary:
  - Spark:
  - Gemini:
  - Claude:

Files changed:
- ...

Verification:
- ...

Provenance:
- papers/sources added or used:
- Aristotle job IDs:

Remaining issues:
- ...
```

Also leave or update a run ledger in `AgentTasks/` with job IDs, statuses, and
next actions. Also update
`AgentTasks/null-edge-model-delegation-evaluation-log-2026-06-23.md` with
specific observations about Spark/Gemini/Claude performance. Do not commit.
