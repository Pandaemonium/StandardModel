# Null-edge constrained autonomous integrator loop

Date: 2026-06-24.

Purpose: run a lower-budget autonomous loop that advances publication-worthy
null-edge results while using Codex primarily as the integrator and decision
maker. Each round deliberately uses external/model agents for exploration and
execution, submits exactly one high-value Aristotle job, then sleeps for 20
minutes.

This plan is intentionally smaller than the six-lane overnight plan. It trades
throughput for selectivity, lower Codex-token use, and better scientific
judgment.

## North star

Advance a publication-worthy result in any lane, with priority given to:

1. `P1-F`: finish the formalization/artifact story around Plucker mass and
   observer-conditioned normalization.
2. `P1-R` / `P4-R` / `P7-R`: prove or sharpen the bridge from null-step
   chirality dynamics to observer-channel proper-time/mass readout.
3. `P2-R`: pass the one-diamond super-Dirac gate before broad operator
   synthesis.
4. `P9-F`: make source visibility, noise kernels, coarse-map guardrails, and
   screen/harmonic separation publishable as finite mathematics.
5. `P9-R`: pursue cosmological response only when a source-to-curvature response
   law, harmonic/global residual, or scaling comparison is explicit.

Do not optimize for job count. A good round submits one job that would matter if
it succeeds.

## Per-round cadence

Each round has six steps.

## External LLM model and context policy

Gemini and Claude are not cheap keyword oracles in this loop. Use them as
serious scientific collaborators. Each call should use the strongest available
model and enough context for the model to understand the actual null-edge
program, not just opaque labels like `P1`, `P4`, `P7`, or `source visibility`.

Preferred models:

```text
Gemini: gemini-3.1-pro-preview
Claude: opus
```

If a preferred model name is unavailable, retry with the strongest available
replacement and record the fallback in the standalone model-call file and the
model-delegation log. Do not silently fall back to older or cheaper models such
as Gemini 2.5 or Claude Sonnet for scientific strategy calls. Sonnet or smaller
models are acceptable only for explicitly bounded mechanical tasks, and the log
must say why the cheaper model was chosen.

Each Gemini/Claude prompt should include the relevant gestalt for the query:
enough program context, theorem state, physics motivation, publication pressure,
prior model output, and current uncertainty for the model to reason as if it had
been following the project. Do not force every call into a rigid checklist. The
right context depends on the question.

Useful ingredients to include when relevant:

- what the lane labels mean (`P1-F`, `P2-R`, `P7-R`, `P9-F`, etc.);
- the latest integrated Lean declarations/modules and which are trusted versus
  draft;
- the publication plan or conjecture excerpt that makes the decision important;
- the candidate theorem/job, with the current Lean API or statement shape;
- recent failed or overstrong interpretations to avoid;
- the exact decision Codex needs help making;
- requested output: theorem/counterexample/design target, physics value,
  failure mode, source/literature check, and recommended next step.

The rule is: pass the API calls all context they need to answer the actual
question well. Avoid unexplained shorthand, but also avoid mechanical context
dumping that buries the decision under unrelated prose.

For broad strategy rounds, include larger excerpts from:

```text
Sources/Null_Edge_Causal_Graph_Publication_Plan.md
Sources/Null_Edge_Key_Conjectures.md
AgentTasks/null-edge-constrained-integrator-loop-ledger-2026-06-24.md
```

Prefer a generated context/gestalt packet or carefully selected excerpts over
dumping entire large files. The key requirement is not brevity; it is relevance
and enough context for the model to reason about the actual program.

For each round, write the shared context/gestalt packet to:

```text
AgentTasks/model-calls/context-packs/YYYY-MM-DD-round-NNN-context.md
```

Use the same base gestalt for Gemini and Claude unless the second call needs a
specific addendum responding to the first model. The standalone Gemini and
Claude call files should link to the context file and still include the full
prompt actually sent.

## Model-call logging invariant

Every Gemini or Claude call must leave an auditable standalone markdown record,
even if the call fails, times out, or returns truncated output.

Use these folders:

```text
AgentTasks/model-calls/gemini/
AgentTasks/model-calls/claude/
AgentTasks/model-calls/context-packs/
```

Use one file per call. Each file should include:

- round number and local timestamp;
- model/provider and command metadata;
- model name requested and model name actually used, including any fallback;
- exit status or timeout/truncation note;
- context/gestalt packet path;
- exact prompt sent;
- raw response received, including error text when relevant;
- short summary and later-usefulness rating field.

The delegation log can summarize model advice, but it is not a substitute for
the standalone call file. If a model call must be retried, log the failed
attempt and the retry as separate files.

### 1. Status check

Use the cheapest status surfaces first:

```powershell
aristotle list --limit 10
```

If the previous round's Aristotle job is complete, delegate integration triage
to Spark before doing any deep reading. If no Spark slot is available, use the
low-token integration checklist in `docs/ARISTOTLE.md`.

Do not resubmit a stalled-looking job until `aristotle list` and
`aristotle tasks <project-id>` have both been checked.

### 2. Query Gemini once

Use the best available Gemini model. Prefer:

```powershell
gemini -p $prompt --model gemini-3.1-pro-preview --output-format text
```

If that model is unavailable, try the strongest available `gemini-pro-latest`
style alias and log the fallback. Do not use `gemini-2.5-pro` for scientific
strategy unless no stronger Gemini model is available.

Gemini does not have a fixed role. Use it constructively, adversarially, as a
source-audit partner, or as a comparison judge depending on what the round
needs. Rotate roles across rounds so neither Gemini nor Claude becomes typecast.
The prompt should include the relevant gestalt described above and should not
rely on bare labels such as `P1/P4/P7` without explaining them. Typical
constructive shape:

```text
We are advancing the null-edge causal graph program.

[lane glossary]
[latest integrated theorem state]
[relevant publication priority excerpt]
[candidate theorem/job or open decision]

Constructive task:
What is the single highest-value next scientific move? Propose one concrete
finite Lean theorem/counterexample/design target, why it matters physically,
one failure/demotion mode, one literature/source check, and recommended next
step. Be concrete and use the current Lean API when possible.
```

Typical adversarial shape:

```text
We are advancing the null-edge causal graph program.

[relevant gestalt for this query]

Adversarial task:
Attack the proposed next theorem/job. What is overclaimed, duplicated, false,
under-contextualized, or not publication-worthy? If it is weak, propose exactly
one better finite target.
```

Record the response in the model-delegation log with a provisional score. Also
write one standalone call record under `AgentTasks/model-calls/gemini/`
containing the exact query, response, command/status metadata, and any later
usefulness rating.

Call-log contract: every Gemini call gets exactly one markdown file in that
folder. The file must include the full prompt sent, the raw response received,
the command/status metadata, the round number, and a short later-usefulness
field that can be filled in after proof work tests the suggestion.

### 3. Query Claude once

Use the best available Claude model. Prefer:

```powershell
claude -p --bare --tools "" --model opus --output-format text $prompt
```

If `opus` is unavailable, try the strongest available Claude model and log the
fallback. Do not use `sonnet` for scientific strategy unless Opus or a stronger
Claude model is unavailable, or unless the task is explicitly mechanical.

Claude does not have a fixed role. Use it constructively, adversarially, as a
source-audit partner, or as a comparison judge depending on what the round
needs. Prefer cycling roles with Gemini; for example, if Gemini was
constructive, Claude can be adversarial, and in the next round the roles can be
reversed. Claude should receive the relevant gestalt for the query and should
be able to understand what `P1`, `P4`, `P7`, and `P9` mean from the prompt
itself. Typical adversarial shape:

```text
We are advancing the null-edge causal graph program.

[lane glossary]
[latest integrated theorem state]
[relevant publication priority excerpt]
[candidate theorem/job or open decision]

Adversarial task:
Critique the proposed next theorem/job. Is it actually new, physically
meaningful, and well-scoped? What hidden convention, prior-art, or
false-statement risk should we check before spending Aristotle budget? If the
target is weak, propose exactly one stronger finite target.
```

Typical constructive shape:

```text
We are advancing the null-edge causal graph program.

[relevant gestalt for this query]

Constructive task:
Given the current theorem state and publication priorities, propose one concrete
finite theorem/counterexample/design target and explain why it is the best next
move.
```

If Gemini already raised a strong alternative, ask Claude to compare the two.
Record the response in the model-delegation log with a provisional score. Also
write one standalone call record under `AgentTasks/model-calls/claude/`
containing the exact query, response, command/status metadata, and any later
usefulness rating.

Call-log contract: every Claude call gets exactly one markdown file in that
folder. The file must include the full prompt sent, the raw response received,
the command/status metadata, the round number, and a short later-usefulness
field that can be filled in after proof work tests the suggestion.

### 4. Delegate all bounded support work to Spark

Before the run, close stale completed subagents so Spark capacity is available.
During each round, delegate every bounded task that does not require Codex's
high-level judgment. Good Spark tasks:

- Aristotle completion triage: inspect transcript, diff returned Lean against
  staged Lean, report statement changes and proof bodies.
- Literature triage: search local docs/Zotero/Neo4j for a named claim and list
  only active guardrail papers.
- Prompt pack drafting: prepare a focused Aristotle prompt for one theorem,
  including physics context and next-step request.
- Manuscript patch proposal: suggest a concise doc insertion for a completed
  result, without editing unless explicitly assigned a disjoint file.
- Verification worker: run targeted `lake env lean` or placeholder scans on a
  specified file.

Spark should not choose the scientific priority by itself. Spark supplies
evidence, diffs, searches, and draft surfaces; Codex accepts or rejects.

If Spark is unavailable because the subagent thread limit is full, record:

```text
Spark unavailable: thread limit reached. Close stale agents before next round.
```

Then proceed with the smallest local version of the task.

### 5. Submit exactly one Aristotle job

Submit one and only one Aristotle job per round.

The job may be:

- a focused proof job;
- a focused counterexample/no-go job;
- a design/audit job only if no proof target is mature enough and the answer
  could change the next proof target.

Every Aristotle prompt must include:

```text
1. Physics context: which publication lane this serves and what the finite
   theorem means physically.
2. Exact Lean or design target.
3. Constraints: no weakening, no fake assumptions, minimal imports.
4. Verification command.
5. Completion report request.
6. Suggested-next-steps request.
```

Prefer focused standalone packages for proof-only jobs. Use the helper:

```powershell
& .\Scripts\prepare_aristotle_focused_submission.ps1 ...
```

Only use full-repo submissions when the target genuinely needs the full
`PhysicsSM` import graph.

### 6. Sleep for 20 minutes

After submitting the one Aristotle job and recording the round ledger entry:

```powershell
Start-Sleep -Seconds 1200
```

During the sleep window, do not poll repeatedly. The whole point is to conserve
Codex budget and let Aristotle/Gemini/Claude/Spark carry the round.

## Round ledger template

Append one entry per round, either to this file or to a separate dated ledger if
the run becomes long.

```text
## Round N - YYYY-MM-DD HH:MM local

Aristotle status before round:
- running:
- completed:
- integrated:

Gemini query:
- prompt type: constructive / strategy / comparison
- model requested / model used:
- context/gestalt packet:
- output summary:
- provisional score 0-3:
- accepted actions:

Claude query:
- prompt type: adversarial / comparison / source audit
- model requested / model used:
- context/gestalt packet:
- output summary:
- provisional score 0-3:
- accepted actions:

Spark delegation:
- tasks sent:
- unavailable?:
- returned outputs:
- provisional score 0-3:

Codex decision:
- selected lane:
- selected theorem/job:
- why this is publication-worthy:
- failure/demotion gate:

Aristotle submission:
- project_id:
- task_id:
- target file:
- expected module:
- verification requested:

Sleep:
- started:
- next wake check:
```

Use the existing evaluation log for model quality:

```text
AgentTasks/null-edge-model-delegation-evaluation-log-2026-06-23.md
```

## Job-selection filter

Before submitting the one Aristotle job, answer all four questions:

1. If this succeeds, which manuscript target changes? (`P1-F`, `P1-R`,
   `P2-R`, `P4-R`, `P7-R`, `P9-F`, `P9-R`, etc.)
2. Is the result a finite theorem, counterexample, definition, or audit that a
   referee could inspect?
3. Does it avoid merely re-proving known physics without a formalization or
   integration payoff?
4. Is there a clear next action if it succeeds or fails?

If the answer to any question is unclear, do not spend the Aristotle round on
that target. Use the round for an audit/design job instead.

## Current best one-job candidates

Use these as the initial queue, but let Gemini/Claude/Spark update the order.

1. **P9-F quotient visibility witness.**
   Build on the completed screen-visibility theorem:

   ```text
   closed-test functionals descend to FaceCochain / exactSource
   ```

   Scientific value: packages "visible/harmonic quotient" as the real P9 object.

2. **P9-F screen/harmonic separation.**
   Prove a finite toy separation between a screen-supported source bound and a
   constant/global mode not suppressed by the screen filter.

   Scientific value: prevents overclaiming local filtering as observed Lambda.

3. **P2-R/P3-R one-diamond curvature integration.**
   Connect the scalar one-diamond additive/multiplicative identity to
   `NullEdgeCovariantDifferentialCore` or `CausalDiamondHolonomy`.

   Scientific value: tests whether the super-Dirac curvature block is the same
   object as causal-diamond holonomy.

4. **P1/P4/P7 null-step two-level coherence.**
   Formalize the two-level positive-energy projector identity:

   ```text
   2 |Pi_LR| = m / E
   ```

   plus dephasing determinant readout if the finite statement is ready.

   Scientific value: strongest bridge from Higgs/chirality coherence to
   observer-visible mass ratio.

5. **P1-F observer-conditioned normalization.**
   Add or audit the finite matrix theorem separating invariant determinant from
   observer-normalized `m/E_u`.

   Scientific value: tightens the flagship P1-F paper.

## Stop/demotion rules

Stop the constrained loop, or ask the user before continuing, if:

- three consecutive rounds produce only strategy prose and no proof target,
  manuscript section, or concrete demotion criterion;
- Aristotle jobs repeatedly solve only trivial algebra already below manuscript
  relevance;
- Gemini and Claude both flag the selected lane as low novelty and no stronger
  finite formalization payoff is identified;
- Spark capacity remains unavailable for more than two rounds, defeating the
  low-Codex-token purpose;
- the active worktree becomes too dirty to safely distinguish new results from
  older autonomous-run changes.

## Budget discipline

- One Aristotle job per round, no exceptions.
- One Gemini query and one Claude query per round, using the strongest
  available model and a sufficient context/gestalt packet.
- Spark handles bounded support work whenever capacity allows.
- Codex reads diffs, summaries, and focused source passages; avoid full-file
  rereads unless doing semantic review.
- Prefer integrating completed results over launching speculative follow-ups.
- Sleep 20 minutes after each submission rather than polling.

## First-round recommendation

Start with a P9-F quotient visibility job if no more urgent completed Aristotle
integration is pending. The previous Aristotle batch proved:

```text
exact source pairs zero with closed tests
nonzero closed-test response implies non-exact source
```

The next publication-worthy packaging theorem is that closed-test response is
well-defined on the quotient by exact sources. This directly converts the
physics slogan "visible/harmonic residual" into a finite mathematical object.

If Gemini or Claude gives a stronger near-term P1/P4/P7 dynamics theorem, prefer
that instead, because the current publication plan puts the dynamics bridge
above P9-R.
