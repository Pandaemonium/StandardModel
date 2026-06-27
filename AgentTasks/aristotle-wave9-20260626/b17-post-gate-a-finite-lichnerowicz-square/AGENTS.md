# AGENTS.md

Lean 4 formalization project for mathematical structures in Standard Model
physics: octonions and division algebras, exceptional Lie theory including E8,
spinors, Clifford algebras, supersymmetry, and related representation-theoretic
physics.

These instructions are for AI coding agents (Codex, Claude Code, Gemini Code
Assist, Aristotle, and similar). They are the always-on rules; infrequent
operational detail lives in linked docs:

- Build, toolchain pin, Windows fix, verification commands:
  [`docs/BUILD.md`](docs/BUILD.md)
- Aristotle submission/integration mechanics: [`docs/ARISTOTLE.md`](docs/ARISTOTLE.md)
- Project conventions and convention-lock status:
  [`docs/CONVENTIONS.md`](docs/CONVENTIONS.md)
- NullStrand/null-edge orientation and living program guardrails:
  [`docs/NULLSTRAND.md`](docs/NULLSTRAND.md)
- Lean MCP tooling (live LSP goals/diagnostics + Mathlib/PhysLean search):
  [`Scripts/MCP_SERVERS.md`](Scripts/MCP_SERVERS.md)
- Research/MCP tooling (literature search, Zotero, Neo4j, local LLM):
  [`Scripts/MCP_SERVERS.md`](Scripts/MCP_SERVERS.md)

## Prime directive

The Lean kernel is the source of truth. A result is trusted only when:

1. the intended mathematical statement is represented correctly in Lean,
2. the proof is accepted by the Lean kernel,
3. the result builds under the pinned toolchain,
4. source provenance is recorded when relevant,
5. convention choices are documented.

Optimize for small, thoroughly-commented, reviewable, kernel-checked
formalizations with clear provenance, not for volume of code. Always favor
legibility: verbose comments, descriptive names, cross-references between related
pieces, and discoverability via the knowledge graph or index documents.

## Repository organization

Preserve these conceptual layers: trusted Lean code, draft/experimental Lean
code, source metadata, external oracle scripts, generated indexes, agent task
records.

```text
PhysicsSM/
  Algebra/ Clifford/ Spinor/ Lie/ Gauge/ StandardModel/ Supersymmetry/ Oracle/ Draft/
Sources/  Scripts/  AgentTasks/  Index/
```

## Trusted vs draft code

- Trusted theorem files must compile without `s o r r y`, `a d m i t`, fake
  `a x i o m` declarations, or hidden assumptions.
- Draft files may contain `s o r r y` if accompanied by a useful proof plan or
  failure note. A `s o r r y` is a handoff marker, not success.
- It is acceptable to stop after inserting a documented `s o r r y` when stuck - do
  not churn if you are not making progress.
- Draft/experimental files may use `n a t i v e _ d e c i d e` for finite
  computational checks. Unlike `s o r r y` it is a complete proof, but it trusts
  the compiled evaluator rather than only the kernel, so it expands the axiom
  footprint with `Lean.ofReduceBool` and `Lean.trustCompiler`. Document each use
  in the module docstring and treat the result as draft-trust, not kernel-trust.
- Never move a theorem from draft to trusted until all `s o r r y`s are eliminated,
  every `n a t i v e _ d e c i d e` has been replaced by a kernel-checked proof
  (no `Lean.ofReduceBool` / `Lean.trustCompiler` in the axiom audit; the project's
  `NoNative` modules are the pattern), and the statement has been reviewed for
  semantic alignment.

Good handoff comment:

```lean
/-
Proof handoff:
Current goal: ...   Tried: ...
Likely missing lemma: ...   Potential issue with statement: ...
-/
```

## Forbidden in trusted code

Never introduce `a x i o m`, `o p a q u e`, `u n s a f e def`, `a d m i t`, or
`s o r r y` in trusted code. Do not add `o p a q u e` placeholders, fake
definitions, or new assumptions merely to make a proof pass.

`n a t i v e _ d e c i d e` is also forbidden in trusted code (it adds
`Lean.ofReduceBool` / `Lean.trustCompiler` to the trusted base), but - unlike the
tokens above - it is permitted in draft/experimental code; see
[Trusted vs draft code](#trusted-vs-draft-code).

Do not weaken theorem statements to make proofs easier unless explicitly asked
and the change is documented. Do not silently change definitions, signs, indices,
scalar fields, parenthesization, basis order, normalization, or convention
choices to ease downstream proofs.

If a theorem appears false, underspecified, or convention-mismatched, stop and
report the issue.

## Lean workflow

1. Read the issue, task file, nearby Lean files, and relevant source notes.
2. Search existing mathlib and project declarations before creating new ones.
   Prefer the Lean MCP tools over blind grep: `lean-lsp`
   (`lean_leansearch`/`lean_loogle`/`lean_leanfinder`/`lean_state_search`, and
   `lean_local_search` to confirm a name exists) and `lean-explore`
   (offline semantic search over Mathlib **and PhysLean**).
3. Identify the smallest useful target statement.
4. Add or modify definitions only when necessary.
5. State the theorem precisely.
6. Prove it, or leave a documented `s o r r y` in draft/handoff context.
7. Run the smallest relevant Lean check, then a broader build before claiming
   completion (see [`docs/BUILD.md`](docs/BUILD.md)).
8. Update provenance, metadata, and task notes when relevant.
9. Summarize what changed, what was proved, what remains draft, and what
   commands were run.

Do not mix unrelated refactors with a narrow proof task.

## Build and verification (summary)

Use targeted checks first, then a full build before claiming a trusted change
complete:

```bash
lake env lean PhysicsSM/Path/To/File.lean   # no ProofWidgets dependency
lake build PhysicsSM.Path.To.Module          # targeted
lake build                                   # full
```

The toolchain is frozen at `leanprover/lean4:v4.28.0` - do not upgrade. The
one-time Windows ProofWidgets fix, the extra index/oracle/docs commands, and the
placeholder scan are in [`docs/BUILD.md`](docs/BUILD.md). Do not claim a command
passed unless it was actually run.

## Lean style

Prefer mathlib style and names. Search before defining new abstractions
(use the `lean-lsp` / `lean-explore` MCP search tools; see the Lean workflow
above), especially under `Mathlib.Algebra.*`, `Mathlib.LinearAlgebra.*` (incl.
`CliffordAlgebra.*`, `RootSystem.*`), `Mathlib.Algebra.Lie.*`, and
`Mathlib.RepresentationTheory.*`.

- Use explicit namespaces (`PhysicsSM`, `PhysicsSM.Algebra.Octonion`,
  `PhysicsSM.Lie.Exceptional`).
- Public definitions and theorems should usually have docstrings.
- Prefer small named lemmas over large fragile proofs; readable tactic proofs
  over brittle golf; descriptive names.

Good: `Octonion.normSq_mul`, `RootSystem.E8.root_card`,
`StandardModel.hypercharge_left_quark`. Bad: `theorem1`, `mainLemma`, `foo_aux`,
`final_result`.

## Octonions and nonassociative algebra

Octonions are not associative. Be extremely careful with parenthesization,
rewriting under multiplication, power notation, scalar actions, ring/algebra
typeclasses, associativity-assuming simp lemmas, and formulas copied from papers
that omit parentheses. Make parenthesization explicit in theorem statements. Do
not use associative-algebra abstractions for octonions unless the relevant
associative property actually holds for the substructure in use.

### Project octonion convention (XOR binary-label)

- Bases: `e000` (unit), `e001`, `e010`, `e011`, `e100`, `e101`, `e110`, `e111`.
- Product index: bitwise XOR of the two input labels.
- Sign: from the Fano orientation in `PhysicsSM.Algebra.Octonion.Basic`.
- Anchor products: `e011 * e111 = e100`, `e101 * e111 = e010`,
  `e110 * e111 = e001`.

This is NOT Baez (2002) or Furey (2015) verbatim. Any formula from those sources
needs explicit basis relabeling AND sign correction via
`PhysicsSM.Algebra.Octonion.ConventionBridge`. Do not copy Baez/Furey product
formulas, structure constants, or ladder operators without going through that
module - mixing conventions silently corrupts signs. Full table and validator:
`Scripts/oracle/validate_octonion.py`.

## Physics conventions

Physics notation is convention-heavy. Always document: metric signature, gamma
matrix signs, chirality/handedness, Fano plane orientation, octonion basis order,
root normalization, Cartan matrix ordering, hypercharge normalization, electric
charge convention, representation duals/conjugates, and particle/antiparticle
naming. If sources differ, do not silently merge - use separate namespaces or
explicit conversion lemmas.

## NullStrand / null-edge quick conventions

Detailed and evolving guidance for the NullStrand/null-edge program lives in
[`docs/NULLSTRAND.md`](docs/NULLSTRAND.md). Keep AGENTS.md to conventions that
agents will frequently encounter:

- The current finite-core target is a dual-soldered finite null-edge Dirac
  algebra, not a completed physical theory.
- The null-edge difference direction and Clifford soldering direction are
  distinct. The active operator architecture is `sum_a c(alpha^a) nabla_ell_a`,
  with primitive null support in `ell_a` and dual covector soldering in
  `alpha^a`.
- Do not revive the diagonal null operator `sum_a c(ell_a^flat) nabla_ell_a` as
  the continuum Dirac-symbol operator; the trace obstruction is a known program
  convention.
- Keep spacetime chirality `Gamma_s`, internal finite grading `chi_E`, and
  cochain/form degree separate in super-Dirac square work.
- Retardedness alone is not a no-doubling proof. It rules out coefficient-zero
  doublers, but determinant-level tests must inspect `det D(q) = 0` or the
  corresponding mass-shell condition.
- Krein self-adjointness is an algebraic Lorentzian audit. It does not by itself
  prove positivity, stability, real spectrum, chirality, anomaly cancellation, or
  a physical Hilbert-space interpretation.
- Universal null frames should come from decorated tetrad/spin-frame data unless
  a separate theorem derives them from the underlying graph. Do not claim a bare
  graph canonically supplies a tetrad.
- When discussing physics implications, prefer explicit claim labels such as
  finite identity, asymptotic theorem, reconstruction, consistency check, or
  prediction.

## Provenance

Every nontrivial declaration inspired by a paper, book, repository, or CAS output
should record provenance (source + convention) in a docstring or metadata file.
Do not claim a source supports a theorem unless the statement and conventions
have been checked. Example: a `normSq` docstring citing Baez 2002, naming the
basis-order convention, and noting "clean-room formalization from literature, not
copied from external code."

## External code and licensing

Permissive code may be consulted subject to attribution and license rules.
GPL/LGPL/AGPL or unclear-license code must NOT be copied into trusted Lean
source; use it only as an external reference, an oracle for generated test
fixtures, a comparison target, or a source of ideas then clean-room formalized
from mathematical definitions or papers. Translate mathematics, not
implementation text.

## CAS and oracle policy

CAS outputs are useful but not trusted proofs. A CAS fixture can justify adding a
test (root counts, Cartan matrices, branching rules, tensor decompositions, gamma
identities, representation dimensions, charge assignments, RGE coefficients); it
cannot justify adding an unproved theorem to trusted Lean. When adding a fixture,
record tool name, version/commit, generation command, input conventions, output
format, license status, and whether CI checks it.

## Aristotle policy summary

Use Aristotle liberally. Treat Aristotle as the top Lean proof assistant in the
world for this repo's purposes, and push its boundaries with ambitious Lean
proofs, formalization designs, strategy jobs, audit jobs, literature-informed
proof plans, and hard no-go analyses. General coding agents should not churn on
hard Lean proofs when Aristotle is available; their job is to prepare a clean,
typechecking theorem statement, isolate context, call Aristotle, and review the
result for semantic alignment, convention drift, and hidden assumptions.

Call Aristotle early for nontrivial proofs, stalled attempts, heavy mathlib
search, clustered `s o r r y`s, unclear intermediate lemmas, possible
counterexamples, paper-proof formalization, or strategic audits of a speculative
program. Do not weaken a statement just to make progress - hand it to Aristotle
instead.

For proof-only targets that can be isolated to Mathlib plus a few copied
definitions, prefer a focused standalone Aristotle package. Full `PhysicsSM`
submission packages can spend Aristotle's budget on project builds before proof
search begins. Use the full-repo package only when the target truly needs the
project import graph.

Before a nontrivial Aristotle submission, generate a semantic context pack with
`Scripts/aristotle/make_context_pack.py` unless the target is tiny and already
self-contained. Include the pack in the submission instead of broad duplicated
repo context. Refresh `Scripts/lit/neo4j_doc_search.py` after meaningful doc or
Lean edits; paper search is scoped to the null-edge collections by default.

Full mechanics (submission helper, task-note metadata block, integration helper,
post-integration checklist, preferred loop) are in
[`docs/ARISTOTLE.md`](docs/ARISTOTLE.md). The Lean kernel checks the proof, not
that the statement is the intended one - semantic alignment is the reviewing
agent's responsibility.

## Research and Lean tooling (MCP)

Six MCP servers are wired in [`.mcp.json`](.mcp.json); full setup and tool lists
are in [`Scripts/MCP_SERVERS.md`](Scripts/MCP_SERVERS.md). None are part of the
Lean build, and all load at session start - if one is added or changed
mid-session, reconnect with `/mcp` (or drive it out of session via
`Scripts/mcp/mcp_call.py`).

Two help directly with proofs:

- `lean-lsp` - the live Lean language server on this repo: `lean_goal` (proof
  state at a position; the most useful one), `lean_diagnostic_messages`,
  `lean_hover_info`, `lean_completions`, `lean_term_goal`, `lean_build`, plus
  Mathlib search via `lean_local_search` / `lean_leansearch` / `lean_loogle` /
  `lean_leanfinder` / `lean_state_search` / `lean_hammer_premise`. First call
  cold-starts `lake serve`, so goal/diagnostic tools lag until the project is
  built; the search tools are instant. Use it to check goals and find lemmas
  before preparing an Aristotle handoff rather than churning.
- `lean-explore` - offline semantic search over Lean 4 declarations in Mathlib
  **and PhysLean** (the physics library `lean-lsp`'s online search does not
  index; PhysLean is registered under the package label `Physlib`, so scope with
  `packages=["Physlib"]`, not `["PhysLean"]` which matches nothing and errors):
  `search_summary` first, then `get_source_code` / `get_docstring` /
  `get_dependencies` on the hits you want. Runs on the local Intel Arc GPU.

The rest are research/developer tooling: literature search, Zotero, the Neo4j
knowledge graph, and a local LLM; see
[`Scripts/MCP_SERVERS.md`](Scripts/MCP_SERVERS.md) for the search -> triage ->
Zotero -> Neo4j workflow.

When adding papers, avoid duplicates: use the canonical `paper_key` = bare Zotero
item key (no `zotero:` prefix), normalize `arxiv_id`/`doi`, and run the low-cost
pre-add existence check (keyed on arxiv_id/doi, not title) documented in
[`Scripts/MCP_SERVERS.md`](Scripts/MCP_SERVERS.md).

## Translation workflow

When translating from a paper or external codebase: extract the informal
definition/theorem; record source, notation, assumptions, conventions; map to
existing Lean/mathlib concepts; state the Lean theorem before proving; prove it
or isolate the blocker with a documented `s o r r y`; review semantic alignment.
Check: same hypotheses? same scalar field? quotient structures represented
correctly? same signs/normalizations? groups vs Lie algebras vs representations
vs concrete matrices? implicit physics assumptions made explicit?

## Documentation

Important modules start with a docstring explaining what the module defines, what
source it follows, what conventions it uses, what is trusted vs draft, and its
prerequisite/successor modules.

## Failure protocol

A useful failed task beats a misleading successful-looking patch. If a task
cannot be completed, record: the exact theorem/definition attempted, the current
Lean error, what was tried, suspected missing lemmas, whether the problem is
syntax / imports / statement / missing-API / convention-mismatch /
mathematical-falsehood, and the recommended next step. If proof search is
churning, stop and add a documented `s o r r y` in a draft/handoff context.

## Red flags

Stop and request review if you encounter: need for a new `a x i o m`; a theorem
depending on unstated analytic assumptions; ambiguity between group and Lie
algebra representations; convention mismatch between sources; copyleft code that
seems necessary to copy; a proof that works only after weakening the statement;
hidden associativity assumptions for octonions; a result based only on
floating-point evidence; Standard Model normalization ambiguity; an E8 branching
rule without source or oracle confirmation.

## Final response format

When finishing a task, report:

```text
Summary:
- ...
Files changed:
- ...
Verification:
- `lake env lean ...`
- `lake build`
Provenance:
- ...
Remaining issues:
- ...
```

Report any `s o r r y`s explicitly and say whether they are in trusted or
draft/handoff code.

## Project philosophy

This project is allowed to be ambitious. A small theorem with exact provenance
and a kernel-checked proof is progress; a large speculative formalization with
unclear conventions is technical debt. When in doubt, formalize the algebra
first, document the convention, and keep the physics interpretation in a separate
layer until the formal foundation is stable.

## Text encoding and formatting

Preserve repo text hygiene:

- UTF-8 without BOM, LF line endings, exactly one final newline, no trailing
  whitespace (except Markdown's two-space line break).
- ASCII-only in code, config, scripts, and filenames unless Unicode is
  semantically required (no smart quotes, nonbreaking spaces, Unicode minus, en
  or em dashes).
- Do not reformat whole files unless asked: make the smallest semantic edit, then
  run the checker; if it reports unrelated problems elsewhere, stop and report
  them.
- Do not edit binary/generated/lock files, `.olean`/`.ilean`, images, PDFs, or
  archives unless asked.
- Do not rewrite repo files with PowerShell 5 redirection or `Out-File` (UTF-16LE
  default). Use explicit UTF-8: PowerShell 7+ `Set-Content -Encoding utf8NoBOM`,
  or Python `open(path, "w", encoding="utf-8", newline="\n")`.
- In comments, docstrings, Markdown prose, and task notes, avoid spelling raw
  Lean placeholder/escape-hatch tokens. Use spaced forms such as `s o r r y`,
  `a d m i t`, `a x i o m`, `o p a q u e`, `u n s a f e`, and
  `n a t i v e _ d e c i d e`. Use raw tokens only in executable Lean/code,
  regexes, or tool logic where the literal token is required. This keeps grep
  and scan output focused on kernel-relevant code instead of prose.

Before committing or handing back trusted Lean/code changes: run
`pre-commit run --all-files` and the appropriate Lean checks, with `lake build`
required before claiming the trusted codebase builds. For docs-only or task-note
changes, `pre-commit run --all-files` is normally enough; do not claim a Lean
build passed unless it was actually run. If pre-commit is missing:
`pipx install pre-commit && pre-commit install`. Fix only files touched by the
current task unless repo-wide normalization was requested.
