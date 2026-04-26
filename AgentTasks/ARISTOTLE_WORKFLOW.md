# Aristotle Workflow

Reference document for submitting and managing Aristotle proof jobs in the
PhysicsSM project. For any AI agent that needs to delegate a hard Lean proof.

---

## Prerequisites

- `aristotle.exe` is installed at `C:\Users\Owner\.local\bin\aristotle.exe`
- `ARISTOTLE_API_KEY` is set in the environment (stored in `.claude/settings.local.json`)
- The project builds cleanly before submitting: `lake build`

### Known toolchain mismatch

Aristotle v1.0.0 reports best results with `leanprover/lean4:v4.28.0`.
This project is pinned to `v4.30.0-rc2`. Jobs still run but may encounter
version-related issues. If a job fails unexpectedly, this is the first thing
to check.

---

## CLI reference

```
aristotle submit   --project-dir <dir> [--wait] [--destination <dir>] <prompt>
aristotle formalize <input_file>       [--wait] [--destination <dir>]
aristotle list
aristotle result   <job_id>            [--wait] [--destination <dir>]
aristotle cancel   <job_id>
```

All commands accept `--api-key <key>` or read `ARISTOTLE_API_KEY` from env.

---

## Submitting a proof task

Use `submit` when you have a Lean project and a natural-language proof goal.

```bash
cd C:/Projects/StandardModel

aristotle submit \
  --project-dir . \
  --destination AgentTasks/aristotle-output/<task-name> \
  "<prompt>"
```

This sends the entire project directory. Aristotle sees all existing `.lean`
files, `lakefile.toml`, and `lean-toolchain`.

Use `--wait` to block until completion. Without it, the command prints a job ID
and returns immediately — use `aristotle result <id>` to fetch the output later.

### When to use `formalize` instead

Use `aristotle formalize` when the input is a natural-language description or
a paper excerpt, not an existing Lean project:

```bash
aristotle formalize AgentTasks/some-spec.txt \
  --destination AgentTasks/aristotle-output/<task-name>
```

---

## Writing a good prompt

The most important factor is task isolation. A focused, well-scoped prompt
outperforms a vague one regardless of model.

### Required elements

1. **File target** — exactly which `.lean` file to write to or modify.
2. **Namespace** — the Lean namespace all output should stay inside.
3. **Convention statement** — any project-specific conventions (XOR basis,
   metric signature, etc.) that are not obvious from mathlib.
4. **Existing context** — names of definitions already in the file that the
   proof can use.
5. **Proof goals** — each theorem as a precise Lean statement or close
   natural-language equivalent.
6. **Constraints** — no sorry, no new axioms, preferred proof strategy.
7. **Imports allowed** — which mathlib modules may be added.

### Prompt template

```
You are working in the Lean 4 project PhysicsSM.
The file to modify is <path/to/File.lean>.

CONVENTION: <any project-specific conventions>

EXISTING CODE: <names and types of relevant definitions already present>

TASK: In <namespace>:
1. <definition or theorem 1>
2. <definition or theorem 2>
...

CONSTRAINTS:
- No sorry in final output.
- No new axioms.
- <proof strategy hints>
- Imports: prefer <specific modules>; do not import all of Mathlib.
```

### Anti-patterns to avoid

- Submitting a job when the project does not build (`lake build` must pass first).
- Asking Aristotle to prove a theorem whose statement is not yet decided — decide
  the statement first, then submit.
- Using vague goals like "prove the octonion identities" — list each theorem.
- Asking for "cleanup" alongside proof work — separate tasks.

---

## Checking job status

```bash
# List all jobs, most recent first
aristotle list

# Fetch result for a specific job (prints status; downloads if complete)
aristotle result <job_id> --destination AgentTasks/aristotle-output/<task-name>

# Block until the job completes and download
aristotle result <job_id> --wait --destination AgentTasks/aristotle-output/<task-name>
```

Job statuses:
| Status | Meaning |
|--------|---------|
| `QUEUED` | Waiting to start |
| `IN_PROGRESS` | Running |
| `COMPLETE` | Finished successfully — fetch result |
| `COMPLETE_WITH_ERRORS` | Finished but some proofs may be incomplete — inspect output |
| `FAILED` | Did not produce output — check prompt and try again |
| `CANCELLED` | Manually cancelled |

---

## Cancelling a job

```bash
aristotle cancel <job_id>
```

Cancel if the job is taking too long, the prompt was wrong, or the project
state has changed in a way that makes the output stale.

---

## Integrating a result

When `aristotle result` downloads a result, it writes a directory of `.lean`
files (and possibly other artifacts) to `--destination`.

**Do not copy Aristotle output directly into trusted source.** Always:

1. Read the output files in `AgentTasks/aristotle-output/<task-name>/`.
2. Check that the theorem statements match the intended mathematics (not just
   that they typecheck).
3. Check that no new `axiom`, `sorry`, `admit`, or `unsafe def` was introduced.
4. Run `lake build` with the new code in place.
5. Run `pre-commit run --all-files`.
6. Only then copy into the trusted source tree.

If the output is partial (some `sorry` remaining), move it to `PhysicsSM/Draft/`
with a handoff note, and open a new task for the remaining goals.

---

## Updating the task file

Every job must have a corresponding task file in `AgentTasks/`. After submitting:

```markdown
**Status**: In progress
**Job ID**: `<id>`
**Submitted**: <date>
**Output**: `AgentTasks/aristotle-output/<task-name>/`
```

After the result is fetched and reviewed:

```markdown
**Status**: Complete / Partial / Failed
**Result**: Merged to <file> / Moved to Draft / Retrying
**Verified**: lake build passed / failed
**Remaining sorry**: <list or none>
```

---

## Output directory convention

All Aristotle output goes under `AgentTasks/aristotle-output/`:

```
AgentTasks/
  <task-name>.md          ← task description and status
  aristotle-output/
    <task-name>/          ← raw Aristotle output (do not edit)
      *.lean
      ...
```

The output directory is read-only reference material. Reviewed and accepted
code is copied from there into the main source tree manually.

---

## Current and recent jobs

| Job ID | Task | Status | Date |
|--------|------|--------|------|
| `e3959b72-1ae0-410a-82e4-881cb76f5d67` | octonion-basic: Octonion type + alternativity + anticommutativity | In progress | 2026-04-26 |

---

## Checking status from Claude Code

Claude Code can check job status and fetch results directly:

```bash
aristotle list
aristotle result <job_id> --destination AgentTasks/aristotle-output/<task-name>
```

Claude Code will read the downloaded files, review them, and report what was
proved, what remains `sorry`, and whether the output is safe to merge.
