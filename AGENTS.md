# AGENTS.md

This repository is a Lean 4 formalization project for mathematical structures used in Standard Model physics, octonions and division algebras, exceptional Lie theory including E8, spinors, Clifford algebras, supersymmetry, and related representation-theoretic physics.

These instructions are for AI coding agents including Codex, Claude Code, Gemini Code Assist, Aristotle, and similar tools.

## Prime directive

The Lean kernel is the source of truth.

A result is trusted only when:

1. the intended mathematical statement is represented correctly in Lean,
2. the proof is accepted by the Lean kernel,
3. the result builds under the pinned toolchain,
4. source provenance is recorded when relevant,
5. convention choices are documented.

Do not optimize for producing large volumes of code. Optimize for small, thoroughly-commented, reviewable, kernel-checked formalizations with clear provenance.

## Repository organization

Follow the actual repository layout, but preserve these conceptual layers:

- trusted Lean code,
- draft or experimental Lean code,
- source metadata,
- external oracle scripts,
- generated indexes,
- agent task records.

Expected areas may include:

```text
PhysicsSM/
  Algebra/
  Clifford/
  Spinor/
  Lie/
  Gauge/
  StandardModel/
  Supersymmetry/
  Oracle/
  Draft/
Sources/
Scripts/
AgentTasks/
Index/
````

## Trusted vs draft code

Trusted code should compile without `sorry`, `admit`, fake axioms, or hidden assumptions.

Draft code may contain `sorry` when it is clearly marked as draft work, blocked work, or an intentional handoff to another agent.

Use this policy:

* Trusted theorem files should not contain `sorry`.
* Draft files may contain `sorry` if accompanied by a useful proof plan or failure note.
* It is acceptable to stop after inserting a `sorry` when you get stuck - do not churn if you are not making progress.
* A `sorry` should be treated as a handoff marker, not as success.
* Never move a theorem from draft to trusted status until all `sorry`s are eliminated and the statement has been reviewed for semantic alignment.

Good handoff comment:

```lean
/-
Proof handoff:
Current goal: ...
Tried: ...
Likely missing lemma: ...
Potential issue with statement: ...
-/
```

## Forbidden in trusted code

Do not introduce any of the following in trusted code:

```lean
axiom
opaque
unsafe def
admit
sorry
```

Do not add opaque placeholders, fake definitions, or new assumptions merely to make a proof pass.

Do not weaken theorem statements merely to make proofs easier unless explicitly asked and the change is documented.

Do not silently change definitions, signs, indices, scalar fields, parenthesization, basis order, normalization, or convention choices to make downstream proofs easier.

If a theorem appears false, underspecified, or convention-mismatched, stop and report the issue.

## Lean workflow

For each task:

1. Read the issue, task file, nearby Lean files, and relevant source notes.
2. Search existing mathlib and project declarations before creating new ones.
3. Identify the smallest useful target statement.
4. Add or modify definitions only when necessary.
5. State the theorem precisely.
6. Prove it, or leave a documented `sorry` in draft/handoff context.
7. Run the smallest relevant Lean check.
8. Run a broader build before claiming completion.
9. Update provenance, metadata, and task notes when relevant.
10. Summarize what changed, what was proved, what remains draft, and what commands were run.

Do not mix unrelated refactors with a narrow proof task.

## Build and verification

Use targeted checks first:

```bash
lake env lean PhysicsSM/Path/To/File.lean
lake build PhysicsSM.Path.To.Module
```

Before claiming a trusted change is complete, run:

```bash
lake build
```

If configured, also run:

```bash
lake exe index
lake exe oracle-check
lake build PhysicsSM:docs
```

If there is a no-sorry checker, run it before finalizing trusted work. If not, inspect suspicious tokens manually or with grep:

```bash
grep -R "sorry\|admit\|axiom\|unsafe" PhysicsSM
```

A grep hit is not automatically a failure in comments, generated files, or draft files, but it must be inspected.

Do not claim a command passed unless it was actually run.

## Lean style

Prefer mathlib style and mathlib names.

Search before defining new abstractions, especially in:

```text
Mathlib.Algebra.*
Mathlib.LinearAlgebra.*
Mathlib.LinearAlgebra.CliffordAlgebra.*
Mathlib.LinearAlgebra.RootSystem.*
Mathlib.Algebra.Lie.*
Mathlib.RepresentationTheory.*
```

Guidelines:

* Prefer small imports.
* Do not import all of Mathlib without a strong reason.
* Use explicit namespaces such as `PhysicsSM`, `PhysicsSM.Algebra.Octonion`, or `PhysicsSM.Lie.Exceptional`.
* Public definitions and theorems should usually have docstrings.
* Prefer small named lemmas over large fragile proofs.
* Prefer readable tactic proofs over brittle proof golf.
* Use descriptive names.

Good names:

```lean
Octonion.conj_conj
Octonion.normSq_mul
RootSystem.E8.root_card
StandardModel.hypercharge_left_quark
```

Bad names:

```lean
theorem1
mainLemma
foo_aux
final_result
```

## Octonion and nonassociative algebra rules

Octonions are not associative.

Be extremely careful with:

* parenthesization,
* rewriting under multiplication,
* power notation,
* scalar actions,
* ring and algebra typeclasses,
* simp lemmas that assume associativity,
* formulas copied from papers that omit parentheses.

When formalizing octonionic identities, make parenthesization explicit in the theorem statement.

Do not use associative algebra abstractions for octonions unless the relevant associative property is actually available for the substructure being used.

## Physics convention rules

Physics notation is convention-heavy. Always document conventions for:

* metric signature,
* gamma matrix signs,
* chirality and handedness,
* Fano plane orientation,
* octonion basis order,
* root normalization,
* Cartan matrix ordering,
* hypercharge normalization,
* electric charge convention,
* representation duals and conjugates,
* particle/antiparticle naming.

If sources use different conventions, do not silently merge them. Use separate namespaces or explicit conversion lemmas.

## Provenance

Every nontrivial declaration inspired by a paper, book, repository, or CAS output should have provenance.

For major definitions and theorems, include source and convention notes in a docstring or metadata file.

Example:

```lean
/--
The squared norm on octonions.

Source: Baez, "The Octonions", Bull. Amer. Math. Soc. 2002.
Convention: basis order follows `PhysicsSM.Algebra.Octonion.Basis`.
Provenance: clean-room formalization from literature, not copied from external code.
-/
def normSq (x : Octonion) : ℝ := ...
```

Do not claim a source supports a theorem unless the statement and conventions have been checked.

## External code and licensing

Use external repositories carefully.

Permissive code may be consulted subject to attribution and license rules.

GPL, LGPL, AGPL, or unclear-license code must not be copied into trusted Lean source. Such code may be used only as:

* an external reference,
* an oracle for generated test fixtures,
* a comparison target,
* a source of ideas that are then clean-room formalized from mathematical definitions or papers.

Translate mathematics, not implementation text.

## CAS and oracle policy

CAS outputs are useful but not trusted proofs.

Oracle fixtures may help check:

* root counts,
* Cartan matrices,
* branching rules,
* tensor product decompositions,
* gamma matrix identities,
* representation dimensions,
* charge assignments,
* RGE coefficients.

A CAS fixture can justify adding a test. It cannot justify adding an unproved theorem to trusted Lean code.

When adding an oracle fixture, record:

* tool name,
* tool version or commit,
* generation command/script,
* input conventions,
* output format,
* license status,
* whether CI checks it.

## Aristotle proof agent policy

Use Aristotle liberally for challenging Lean proofs.

Aristotle is the preferred proof-specialist agent for this repository. General coding agents should not spend large amounts of time churning on difficult Lean proofs when Aristotle is available. Their job is usually to prepare a clean theorem statement, isolate the relevant context, call Aristotle, and then review the result.

### When to use Aristotle

Call Aristotle early when:

- a theorem statement typechecks but the proof is nontrivial,
- a proof attempt has stalled after a few focused tries,
- the proof requires substantial mathlib search or tactic synthesis,
- there are multiple related `sorry`s in a file,
- a theorem looks true but the needed intermediate lemmas are unclear,
- a conjecture may be false and a counterexample would be useful,
- a paper proof or LaTeX argument needs to be formalized,
- a general coding agent is tempted to weaken the theorem just to make progress.

Do not treat Aristotle as a last resort. For hard proofs, use it as a primary proof engine.

### Good Aristotle inputs

Before calling Aristotle, prepare the problem so the proof search has the best chance of success.

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

The theorem statement should already be as semantically correct as possible. Do not ask Aristotle to prove a statement that is probably malformed, convention-mismatched, or mathematically false unless the purpose is counterexample search.

### Preferred workflow

For a hard proof:

1. Make the theorem statement typecheck.
2. Replace the missing proof with `sorry` only in an appropriate draft or handoff context.
3. Add a short handoff note if useful.
4. Run a targeted Lean check to confirm the only intended blocker is the proof.
5. Call Aristotle on the focused theorem, snippet, or file.
6. If Aristotle succeeds, insert the proof and run the targeted Lean check again.
7. Run a broader build before claiming completion.
8. Review the result for semantic alignment, convention drift, hidden assumptions, and proof hygiene.

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
````

The Lean kernel verifies correctness of the formal proof, but it does not verify that the formal statement is the intended mathematical statement. Semantic alignment remains the responsibility of the reviewing agent.

### Agent division of labor

General coding agents should:

* prepare clean theorem statements,
* search mathlib and project APIs,
* break large proofs into focused lemmas,
* call Aristotle on difficult proof obligations,
* post-process Aristotle output,
* run verification,
* document remaining gaps.

Aristotle should be used for:

* filling focused proof holes,
* proving helper lemmas,
* repairing difficult tactic scripts,
* formalizing informal mathematical arguments,
* testing whether a statement is likely false.

For challenging proofs, prefer the loop:

```text
Codex/Claude/Gemini prepares definitions and theorem statements
→ Aristotle proves or refutes focused goals
→ Codex/Claude/Gemini cleans, organizes, verifies, and documents
→ Aristotle is called again on remaining proof holes
```

Do not let a general-purpose agent burn excessive tokens on proof search when Aristotle is available.

## Translation workflow

When translating from a paper or external codebase:

1. Extract the informal definition or theorem.
2. Record source, notation, assumptions, and conventions.
3. Map the content to existing Lean/mathlib concepts.
4. State the Lean theorem before attempting a proof.
5. Prove it, or isolate the blocker with a documented `sorry`.
6. Review semantic alignment with the source.

Check:

* Are the hypotheses the same?
* Is the scalar field the same?
* Are quotient structures represented correctly?
* Are signs and normalizations the same?
* Is the theorem about groups, Lie algebras, representations, or concrete matrices?
* Are implicit physics assumptions explicit?

## Documentation

Important modules should start with a module docstring explaining:

* what the module defines,
* what source it follows,
* what conventions it uses,
* what is trusted vs draft,
* prerequisite and successor modules.

Example:

```lean
/-!
# Octonion norm

This module defines conjugation and the squared norm for the project octonion model.
It follows the basis and multiplication conventions in
`PhysicsSM.Algebra.Octonion.Basic`.

Main declarations:
- `Octonion.conj`
- `Octonion.normSq`
- `Octonion.conj_conj`
- `Octonion.normSq_mul`

Theorems in this module are intended to be trusted and should not contain `sorry`.
-/
```

## Failure protocol

A useful failed task is better than a misleading successful-looking patch.

If a task cannot be completed, record:

* exact theorem or definition attempted,
* current Lean error,
* what was tried,
* suspected missing lemmas,
* whether the problem is syntax, imports, theorem statement, missing API, convention mismatch, or mathematical falsehood,
* recommended next step.

If proof search is churning, stop, add a documented `sorry` only in an appropriate draft/handoff context, and return the task for another agent.

## Red flags

Stop and request review if you encounter:

* need for a new axiom,
* theorem depending on unstated analytic assumptions,
* ambiguity between group and Lie algebra representations,
* convention mismatch between sources,
* GPL/LGPL/AGPL code that seems necessary to copy,
* proof that works only after weakening the statement,
* hidden associativity assumptions for octonions,
* result based only on floating-point evidence,
* Standard Model normalization ambiguity,
* E8 branching rule without source or oracle confirmation.

## Final response format for agents

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

If there are `sorry`s, report them explicitly and say whether they are in trusted code or draft/handoff code.

## Project philosophy

This project is allowed to be ambitious.

A small theorem with exact provenance and a kernel-checked proof is progress.
A large speculative formalization with unclear conventions is technical debt.

When in doubt, formalize the algebra first, document the convention, and keep the physics interpretation in a separate layer until the formal foundation is stable.

## Text encoding and formatting rules

All agents must preserve repo text hygiene. Formatting drift between agents is
expensive to fix and can corrupt files silently.

Required conventions:

- Text files must be UTF-8 **without BOM**.
- Text files must use **LF line endings**, not CRLF.
- Text files must end with **exactly one final newline**.
- No trailing whitespace except where Markdown explicitly needs it (two spaces
  for a line break).
- Code, config, scripts, and filenames should be **ASCII-only** unless Unicode
  is semantically required. In particular, do not introduce smart quotes,
  nonbreaking spaces, Unicode minus signs, en dashes, or em dashes into Lean
  source, config, or shell scripts.
- **Do not reformat whole files** unless explicitly asked. Make the smallest
  semantic edit, then run the repo's checker. If the checker reports unrelated
  formatting problems elsewhere, stop and report them instead of doing a broad
  cleanup.
- Do not edit binary files, generated files, lock files, `.olean`/`.ilean`
  files, images, PDFs, or archives unless explicitly asked.
- Do not use shell redirection (`>`, `>>`) or `Out-File` from Windows
  PowerShell 5 to rewrite repo files — these produce UTF-16LE by default. Use
  explicit UTF-8 writes:
  - PowerShell 7+: `Set-Content -Encoding utf8NoBOM`
  - Python: `open(path, "w", encoding="utf-8", newline="\n")`

Before committing or handing back changes, run:

```bash
pre-commit run --all-files
lake build
```

If pre-commit is not installed: `pipx install pre-commit && pre-commit install`.

If formatting checks fail, fix only the files touched by the current task
unless the user asks for repo-wide normalization.