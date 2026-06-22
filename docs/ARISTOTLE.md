# Aristotle proof-agent workflow (mechanics)

Operational detail for submitting to and integrating results from Aristotle
(the Harmonic proof agent). The constant-awareness policy summary lives in
[`../AGENTS.md`](../AGENTS.md#aristotle-policy-summary): use Aristotle liberally
for hard Lean proofs.

## When to use Aristotle

Call Aristotle early when:

- a theorem statement typechecks but the proof is nontrivial,
- a proof attempt has stalled after a few focused tries,
- the proof requires substantial mathlib search or tactic synthesis,
- there are multiple related `s o r r y`s in a file,
- a theorem looks true but the needed intermediate lemmas are unclear,
- a conjecture may be false and a counterexample would be useful,
- a paper proof or LaTeX argument needs to be formalized,
- a general coding agent is tempted to weaken the theorem just to make progress.

Do not treat Aristotle as a last resort. For hard proofs, use it as a primary
proof engine.

## Good Aristotle inputs

Prefer to provide:

- a minimal Lean file or focused code snippet,
- all necessary imports,
- the exact theorem statement,
- nearby definitions and lemmas,
- relevant namespace context,
- any known convention choices,
- an informal proof sketch if available,
- known failed attempts or current Lean error messages,
- permission to add small helper lemmas if needed.

The theorem statement should already be as semantically correct as possible. Do
not ask Aristotle to prove a statement that is probably malformed,
convention-mismatched, or mathematically false unless the purpose is
counterexample search.

## Semantic context-pack preflight

Before preparing a nontrivial Aristotle submission, query the local semantic
index over this repo's docs and Lean files, plus the scoped null-edge paper
index. This should replace broad manual context dumps whenever possible.

Refresh the indexes after meaningful doc or Lean edits:

```powershell
$py = "C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
& $py Scripts/lit/neo4j_doc_search.py
& $py Scripts/lit/neo4j_paper_search.py
```

Create a focused context pack for the target:

```powershell
$py = "C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
& $py Scripts/aristotle/make_context_pack.py `
  --query "Dirac slash bundle momentum squares to the Pluecker scalar" `
  --slug dirac-pluecker
```

The output lands in `AgentTasks/context-packs/`. Include that Markdown file in
the Aristotle submission and cite it from the task note. The pack is evidence
for context selection, not proof: still review theorem statements, convention
choices, and source claims manually.

Paper search is scoped by default to this project's collections
`9W59V3K9` and `null-edge-lit`. Use `--all-papers` only when you intentionally
want the shared Neo4j graph to return other projects' papers.

If the scripts report missing `NEO4J_URI`, `NEO4J_USERNAME`, or
`NEO4J_PASSWORD`, run them from a shell that inherits the Windows user
environment, or use the MCP/Claude session where Neo4j is already configured.

## Submission tips

- Default to a focused standalone package for proof-only jobs whose target can
  be isolated to Mathlib plus a few copied definitions. Recent long-running
  jobs showed a recurring failure mode: Aristotle spends the budget on a full
  `PhysicsSM` build, then times out before proof search. Use the full-repo
  package only when the target genuinely depends on many project modules.
- Use `Scripts/prepare_aristotle_focused_submission.ps1` for isolated finite
  algebra, matrix, list, finset, or small API-wrapper targets. The helper writes
  a tiny Lake project under `AgentTasks/aristotle-submit/` with only Mathlib and
  the Lean files you explicitly copy in.
- Prefer `Scripts/prepare_aristotle_submission.ps1` to create a clean submission
  copy under `AgentTasks/aristotle-submit/`. The CLI archives the project
  directory, so stale `AgentTasks/aristotle-output/` extracts, `.lake`, old
  external checkouts, or generated state can break packaging.
- For Sphere-Packing-Lean enabled jobs, use a separate Linux/SPL-enabled
  submission copy and refresh only the relevant files from the live tree. Do not
  enable upstream Sphere-Packing-Lean in the native Windows checkout.
- Submit large waves one project at a time, or verify with `aristotle list`
  after a timeout. A timeout can happen after a project was created, so do not
  blindly resubmit.
- Record project IDs, optional task IDs, output directories, target files,
  expected modules, and submission-project paths immediately in the task file.
- Transient upload or SSL errors can happen. Check `aristotle list` before
  retrying so duplicate jobs are not created.

Focused-package pattern:

```powershell
pwsh Scripts/prepare_aristotle_focused_submission.ps1 `
  -JobName null-edge-gram-cauchy-binet-core-20260621 `
  -RootModule NullEdgeGramCore `
  -SourceRoot AgentTasks/aristotle-standalone/null-edge-gram-cauchy-binet-core-20260621 `
  -LeanPath NullEdgeGramCore/WeightedCauchyBinet.lean `
  -TaskNote AgentTasks/null-edge-gram-weighted-cauchy-binet-core-aristotle-2026-06-21.md
```

For this pattern, the standalone source root should already contain a small
Lean file whose imports are limited to `Mathlib` and other files in the same
focused package. Do not point it at a `PhysicsSM/Draft/...` target that still
imports the full project; that recreates the same build-budget problem.

When submitting a focused package, tell Aristotle to run the narrow command
first:

```text
lake env lean NullEdgeGramCore/WeightedCauchyBinet.lean
```

Avoid asking for a full `lake build` until after the proof holes are closed.
If Aristotle starts by building the entire project and hits a long build error,
use `aristotle continue --mode instruct` to ask it to stop waiting and return
the current target file, then resubmit a focused package.

Preferred task-note metadata block:

```yaml
aristotle:
  project_id: 00000000-0000-0000-0000-000000000000
  task_id: 00000000-0000-0000-0000-000000000000
  target_file: PhysicsSM/Draft/ExampleAristotle.lean
  expected_module: PhysicsSM.Draft.ExampleAristotle
  submission_project: AgentTasks/aristotle-submit/example-20260612-project
  output_dir: AgentTasks/aristotle-output/00000000-0000-0000-0000-000000000000
  status: submitted
```

Use the project ID as the canonical output directory name. Friendly names are
fine in prose, but do not make them the only locator; they are easy to mismatch
when several projects complete at once.

## Live status and running-job questions

Aristotle jobs can be queried while they are still running.  The most useful
commands are:

```powershell
aristotle list --limit 10
aristotle tasks 00000000-0000-0000-0000-000000000000 --limit 10
```

`aristotle list` reports project-level states such as `RUNNING` and `IDLE`.
`aristotle tasks <project-id>` reports task-level states such as `IN_PROGRESS`.
Record both in the task note, because a project can remain `RUNNING` while the
interesting work is already blocked on verification or packaging.

To inspect recent progress events, use:

```powershell
$env:PYTHONIOENCODING = 'utf-8'
aristotle show 00000000-0000-0000-0000-000000000000 `
  --task 00000000-0000-0000-0000-000000000000 `
  --limit 20
```

On Windows, set `PYTHONIOENCODING=utf-8` before `show` or `continue`; progress
messages may contain Unicode that otherwise triggers a `UnicodeEncodeError` in
the console.  `show` can stream while the task is still running, so a shell
timeout does not necessarily mean the project failed.

API v3 also supports asking a running task a question:

```powershell
$env:PYTHONIOENCODING = 'utf-8'
aristotle continue --mode ask --wait `
  00000000-0000-0000-0000-000000000000 `
  "Please give a concise progress report. Which targets are solved, which target are you working on, what exact Lean errors or blockers remain, and should we keep waiting or split/cancel/resubmit?"
```

Use `--mode ask` for status questions; it should not redirect the task.  Good
questions ask for solved targets, the current theorem, exact Lean errors,
whether any statements were weakened, and whether to keep waiting.

Use `--mode instruct` only when changing course.  For example, if a task appears
to be stuck in a long verification/build loop after reporting useful proofs,
instruct it to stop waiting on its own build and return the current code so it
can be checked locally:

```powershell
$env:PYTHONIOENCODING = 'utf-8'
aristotle continue --mode instruct --wait `
  00000000-0000-0000-0000-000000000000 `
  "Stop waiting on the long build. Please immediately return the current contents of TARGET.lean, even if not fully verified, or make the project downloadable. We will run Lean verification locally."
```

If a running project has useful work but has not become `IDLE`, try downloading
an in-progress snapshot:

```powershell
aristotle download 00000000-0000-0000-0000-000000000000 `
  --destination AgentTasks/aristotle-output/00000000-0000-0000-0000-000000000000/in-progress-snapshot.zip
```

`--destination` is an archive filename, not a directory.  Extract and inspect
only the target files first, scan for placeholders, and run `lake env lean` on
the extracted target before copying anything into the live tree.

After any live question or instruction, add a dated note to the task file with
the command mode used, Aristotle's answer, and the follow-up action.

## Result integration

Separate fetching from integration. First fetch and inspect the result, then
copy proofs into the live tree only after review.

Conservative helper (default mode is a dry run):

```powershell
python Scripts/aristotle/integrate_completed.py `
  --task-note AgentTasks/example-aristotle-2026-06-12.md `
  00000000-0000-0000-0000-000000000000
```

It stores results under `AgentTasks/aristotle-output/<project-id>/`, extracts
archives with path-traversal checks, reports candidate `*Aristotle.lean` files,
and scans executable Lean code for placeholder and escape-hatch tokens.

When the report matches the task note and the candidate files are clean, copy
and build:

```powershell
python Scripts/aristotle/integrate_completed.py `
  --task-note AgentTasks/example-aristotle-2026-06-12.md `
  --apply --build `
  00000000-0000-0000-0000-000000000000
```

For batches:

```powershell
python Scripts/aristotle/integrate_completed.py --from-list
```

An `IDLE` project still requires review.

After integration:

- Update the task note from `submitted`/`complete` to `integrated`.
- Record the exact project ID, selected extraction, copied files, and
  verification commands.
- Run a placeholder scan on the integrated files.
- Run targeted `lake build <module>` for each integrated module.
- Run `lake build` before claiming trusted work complete.
- Run `pre-commit run --all-files` before handing back.

## Preferred workflow

1. Make the theorem statement typecheck.
2. Replace the missing proof with `s o r r y` only in an appropriate draft/handoff
   context.
3. Add a short handoff note if useful.
4. Run a targeted Lean check to confirm the only intended blocker is the proof.
5. Call Aristotle on the focused theorem, snippet, or file.
6. If Aristotle succeeds, insert the proof and run the targeted check again.
7. Run a broader build before claiming completion.
8. Review for semantic alignment, convention drift, hidden assumptions, and
   proof hygiene.

Example handoff note:

```lean
/-
Aristotle handoff:
Goal: prove multiplicativity of the project octonion squared norm.
Statement should not be weakened.
Conventions: basis order follows `PhysicsSM.Algebra.Octonion.Basis`; multiplication is explicitly parenthesized.
Useful lemmas: `conj_mul`, `mul_conj`, `normSq_def`.
Failed attempts: direct `simp` unfolds too aggressively; likely needs alternativity or component expansion.
-/
```

The Lean kernel verifies the formal proof, not that the formal statement is the
intended mathematical statement. Semantic alignment is the reviewing agent's
responsibility.

## Agent division of labor

General coding agents: prepare clean theorem statements, search mathlib/project
APIs, break large proofs into focused lemmas, call Aristotle on difficult proof
obligations, post-process output, run verification, document remaining gaps.

Aristotle: fill focused proof holes, prove helper lemmas, repair difficult
tactic scripts, formalize informal arguments, test whether a statement is likely
false.

For challenging proofs, prefer the loop:

```text
Codex/Claude/Gemini prepares definitions and theorem statements
-> Aristotle proves or refutes focused goals
-> Codex/Claude/Gemini cleans, organizes, verifies, and documents
-> Aristotle is called again on remaining proof holes
```

Do not let a general-purpose agent burn excessive tokens on proof search when
Aristotle is available.
