# Level 0: Repository Survival

This is the first tutorial for low-end agents working in the PhysicsSM project.
Read this before editing any file.

The goal of Level 0 is simple: learn how to move around the repository, inspect
files, run checks, preserve text hygiene, and stop before making a mathematical
or convention mistake.

This document does not teach the mathematics yet. It teaches how not to break
the workspace.

## Required Reading

Before doing any task, read:

- `AGENTS.md`
- `Skills/LOW_END_AGENT_TRAINING_PLAN.md`
- the specific `AgentTasks/` file for your task, if one exists
- the target files you are allowed to edit

If these files disagree, follow `AGENTS.md` first. If the user gives a newer
instruction, follow the user's newest instruction, but do not violate safety
rules such as "no new axioms" or "do not revert user changes".

## What This Repository Is

PhysicsSM is a Lean 4 formalization project. It aims to machine-check pieces of
mathematics used in Standard Model physics, octonions, division algebras,
Clifford algebras, spinors, exceptional Lie theory, supersymmetry, and related
representation theory.

The important phrase is "machine-check". A theorem only counts as trusted when
Lean accepts the exact formal statement and proof.

The Lean kernel checks formal correctness. It does not check whether the formal
statement is the intended physics or mathematics. Human and strong-agent review
is still required for semantic alignment.

## The Prime Directive

The Lean kernel is the source of truth.

For low-end agents, this means:

- Do not say a theorem is proved unless Lean checked it.
- Do not say a file builds unless you ran the command and it passed.
- Do not claim a source supports a statement unless the source and convention
  were checked.
- Do not make broad mathematical decisions.
- Do not hide uncertainty.

## Repository Map

Use this map to understand where things live.

```text
PhysicsSM/
  Lean source files. Trusted code usually lives here.

PhysicsSM/Algebra/Octonion/
  Octonion definitions, multiplication, conjugation, norm, Moufang identities.

PhysicsSM/Algebra/Furey/
  Complex octonions, ladder operators, and minimal-left-ideal finite arithmetic.

PhysicsSM/Docs/
  Lean documentation and roadmap files.

AgentTasks/
  Task records for agents and Aristotle. These are instructions and records,
  not trusted proofs.

AgentTasks/aristotle-output/
  Downloaded Aristotle artifacts and extracted outputs.

Sources/
  Source metadata and convention notes.

Scripts/
  External scripts and oracle validators. These can support checks but are not
  trusted Lean proofs.

Index/
  Generated or curated index material.

Skills/
  Training documents for agents.
```

## Trusted Code Vs Draft Code

Trusted Lean code:

- should compile,
- should not contain trusted `sorry`,
- should not contain `admit`,
- should not introduce new `axiom`,
- should not contain fake placeholders,
- should have accurate theorem statements,
- should document conventions and provenance when relevant.

Draft or task files:

- may describe future work,
- may include planned statements,
- may include failed attempts,
- may include `sorry` examples as handoff markers,
- are not trusted mathematical results.

If you are unsure whether a file is trusted, treat it as trusted until a stronger
agent says otherwise.

## Never Do These Things

Never do any of the following in trusted Lean code:

```lean
axiom
opaque
unsafe def
admit
sorry
```

Also never:

- weaken a theorem statement to make a proof pass,
- change signs, basis order, scalar fields, normalization, or parentheses
  silently,
- assume octonion multiplication is associative,
- copy GPL, LGPL, AGPL, or unclear-license code into Lean source,
- edit generated files or binary files unless explicitly asked,
- perform broad reformatting,
- revert user changes,
- use destructive Git commands such as `git reset --hard`,
- claim a command passed without running it.

## Safe First Tasks

These tasks are usually safe for low-end agents:

- summarize a local file,
- list declarations in a file,
- explain a theorem statement in plain English,
- add a docstring or comment after review,
- create a task file from a template,
- add source metadata,
- run a targeted Lean check,
- compare two local files and report differences,
- record an Aristotle job result in a task file,
- find exact theorem names with `rg`.

These tasks require caution but may be safe when tightly scoped:

- add a simple coordinate projection lemma,
- prove a theorem using `rfl`,
- prove a theorem using `ext <;> simp`,
- prove a numeric or polynomial coordinate goal using `norm_num` or `ring`,
- update a markdown plan after a stronger agent has already made the code
  change.

## Tasks To Escalate

Stop and ask for stronger review when asked to:

- design a new mathematical definition,
- choose a basis convention,
- choose a sign convention,
- choose a metric signature,
- choose a hypercharge normalization,
- translate a theorem from a paper into Lean,
- prove a difficult theorem,
- add a new typeclass instance,
- refactor shared algebra code,
- decide whether a source theorem matches the project theorem,
- formalize a physics interpretation,
- work on E8, branching rules, or representation theory without a very narrow
  task file.

## How To Inspect The Repository

Use `rg` first for search. It is fast and avoids noisy output.

List files:

```powershell
rg --files
```

Search for a theorem name:

```powershell
rg "normSq_mul" PhysicsSM AgentTasks Sources
```

Search for risky tokens in trusted code:

```powershell
rg "sorry|admit|axiom|unsafe" PhysicsSM
```

Read a file:

```powershell
Get-Content -Encoding UTF8 PhysicsSM\Algebra\Octonion\Norm.lean
```

Read only the first lines of a file:

```powershell
Get-Content -Encoding UTF8 AGENTS.md -TotalCount 80
```

Show changed files:

```powershell
git status --short
```

Show changes in one file:

```powershell
git diff -- PhysicsSM\Algebra\Octonion\Norm.lean
```

## How To Read A Lean File

Read a Lean file in this order:

1. Imports.
2. Module docstring.
3. Namespace.
4. Definitions.
5. Theorem statements.
6. Proof scripts.
7. End namespace.

Example:

```lean
theorem conj_conj (x : Octonion) : conj (conj x) = x := by
  ext <;> simp [conj]
```

Plain-English reading:

- The theorem is named `conj_conj`.
- It applies to any `x` of type `Octonion`.
- It states that conjugating twice returns the original octonion.
- The proof uses extensionality to reduce octonion equality to coordinate
  equality.
- Then it simplifies using the definition of `conj`.

Do not judge a theorem only by its name. Always read the exact statement after
the colon.

## How To Run Lean Checks

On Windows, use the pinned local toolchain environment:

```powershell
$env:ELAN_HOME='c:\Projects\StandardModel\.elan_sandbox'
$env:PATH="$env:ELAN_HOME\bin;$env:PATH"
lake env lean PhysicsSM\Algebra\Octonion\Norm.lean
```

For a targeted check, prefer:

```powershell
lake env lean PhysicsSM\Path\To\File.lean
```

For a full build, use:

```powershell
lake build
```

The full build may take longer. A targeted check is usually the right first
verification after a narrow edit.

## Windows ProofWidgets Note

This repository has a known Windows issue where some `lake build <module>`
commands may fail at a ProofWidgets `widgetJsAll` step. That failure is not
automatically a failure of the target Lean file.

When working on Windows:

- use `lake env lean <file>` for targeted checks,
- report the exact command and output,
- do not claim a module build passed if it stopped at ProofWidgets,
- ask for stronger review if you are unsure whether a build failure is relevant.

## What A Passing Check Means

If this passes:

```powershell
lake env lean PhysicsSM\Algebra\Octonion\Norm.lean
```

then Lean accepted that file with its imports.

It does not mean:

- every file in the repository builds,
- the theorem statement matches the intended mathematics,
- the source provenance is correct,
- the physics interpretation is correct.

It only means Lean accepted the formal file.

## Text Hygiene Rules

This repository cares about text formatting because multiple agents edit it.

Use:

- UTF-8 without BOM,
- LF line endings,
- exactly one final newline,
- no trailing whitespace,
- ASCII in code, config, scripts, and filenames unless Unicode is necessary,
- small edits only.

Avoid:

- smart quotes,
- nonbreaking spaces,
- Unicode minus signs,
- en dashes,
- em dashes,
- broad reformatting.

Markdown may contain mathematical Unicode in some existing files, but low-end
agents should prefer ASCII unless specifically asked otherwise.

## Editing Rules

Before editing:

1. Read the target file.
2. Run `git status --short`.
3. Check whether the file already has user changes.
4. Make the smallest useful edit.
5. Do not reformat unrelated lines.

After editing:

1. Run a targeted check if a Lean file changed.
2. Run `pre-commit run --all-files` when handing back a change.
3. Run `lake build` when appropriate.
4. Report any command that failed.

Do not use shell redirection or PowerShell `Out-File` to rewrite repo files.
PowerShell 5 can produce bad encodings by default. Use proper editing tools or
ask a stronger agent to edit.

## Git Safety

The worktree may already contain changes from the user or another agent.

Rules:

- Do not revert changes you did not make.
- Do not run `git reset --hard`.
- Do not run `git checkout -- <file>` unless explicitly asked.
- Do not delete files unless explicitly asked.
- If you see unrelated modified files, ignore them.
- If another change affects your task, work with it and report the situation.

Useful commands:

```powershell
git status --short
git diff -- <path>
git diff --stat
```

## How To Report Work

A good final report is short and factual.

Use this shape:

```text
Summary:
- What changed.

Files changed:
- path/to/file

Verification:
- command that passed
- command that failed, with reason

Remaining issues:
- anything not done
```

Do not hide failures. A useful failed attempt is better than a misleading
success report.

## How To Stop Safely

Stop and write a handoff note when:

- you do not understand the theorem statement,
- a proof requires mathematical insight,
- Lean errors are no longer simple syntax/import issues,
- a convention decision is needed,
- a theorem seems false,
- a proof only works after weakening the statement,
- you are tempted to add an axiom or trusted `sorry`.

Handoff note:

```text
Handoff:
- Target file:
- Target declaration:
- Intended statement:
- Current Lean error:
- What I tried:
- Why I stopped:
- Suspected missing lemma or import:
- Convention concerns:
- Recommended next step:
```

## Common File Types

Lean source:

```text
*.lean
```

These files are checked by Lean. Be careful.

Markdown documentation:

```text
*.md
```

These files guide humans and agents. They are not proofs.

Python scripts:

```text
*.py
```

These may validate or generate data. They are not Lean proofs.

Aristotle artifacts:

```text
AgentTasks/aristotle-output/
```

These are downloaded outputs. Review before integrating.

## Common Directories For First Tasks

`Skills/`

- Good for training docs like this one.
- Safe place for tutorials.

`AgentTasks/`

- Good for task plans and proof handoffs.
- Do not treat task files as trusted proofs.

`Sources/`

- Good for source metadata and convention notes.
- Do not overclaim what a source proves.

`PhysicsSM/Algebra/Octonion/`

- Good for learning coordinate proofs.
- Trusted Lean files live here, so edit carefully.

## Basic Lean Command Cheat Sheet

Check one file:

```powershell
lake env lean PhysicsSM\Algebra\Octonion\Conjugation.lean
```

Build everything:

```powershell
lake build
```

Run formatting and hygiene hooks:

```powershell
pre-commit run --all-files
```

Find a theorem:

```powershell
rg "theorem normSq_mul" PhysicsSM
```

Find imports:

```powershell
rg "^import " PhysicsSM\Algebra\Octonion
```

Find forbidden trusted-code tokens:

```powershell
rg "^\s*(axiom|opaque|unsafe def|admit|sorry)\b" PhysicsSM
```

## Practice Exercise 1: Find The Octonion Files

Task:

1. Run `rg --files PhysicsSM\Algebra\Octonion`.
2. List the files you see.
3. Identify which file defines the octonion multiplication table.
4. Identify which file defines `normSq`.

Expected answer shape:

```text
Files found:
- ...

Multiplication table:
- ...

normSq:
- ...
```

## Practice Exercise 2: Explain A Theorem

Task:

1. Open `PhysicsSM/Algebra/Octonion/Conjugation.lean`.
2. Find `conj_mul`.
3. Translate the theorem statement into one plain-English sentence.
4. Explain why the order of multiplication is reversed.

Do not edit any files.

## Practice Exercise 3: Run A Targeted Check

Task:

1. Run:

```powershell
lake env lean PhysicsSM\Algebra\Octonion\Moufang.lean
```

2. Report whether it passed.
3. If it failed, quote the exact first error.

Do not fix the error unless the task explicitly asks you to.

## Practice Exercise 4: Inspect Worktree State

Task:

1. Run `git status --short`.
2. Report modified and untracked files.
3. Do not revert anything.

This exercise trains you to notice user changes before editing.

## Practice Exercise 5: Write A Safe Handoff

Task:

Pretend the theorem `some_hard_theorem` failed with a type mismatch. Write a
handoff note using the template above. Include:

- target file,
- current error category,
- what you tried,
- why you stopped.

Do not invent a proof.

## Final Checklist Before Any Low-End Agent Starts

Before starting:

- I read `AGENTS.md`.
- I read this file.
- I know which files I may edit.
- I ran or inspected `git status --short`.
- I understand whether the target file is trusted Lean, draft Lean, markdown, or
  source metadata.
- I know the smallest verification command for the task.

Before finishing:

- I changed only allowed files.
- I did not introduce forbidden trusted-code tokens.
- I did not change conventions.
- I did not revert user changes.
- I ran the required checks, or I explain why I could not.
- I report failures honestly.
- I leave a handoff note if the task is incomplete.

## One-Sentence Rule

When in doubt, do less, write down exactly what happened, and ask for review.
