# Aristotle job: strengthen the all-mass manuscript (strategy/audit)

```yaml
aristotle:
  project_id: 4bf9899f-3e31-42f8-82ab-a6cbfa2b5780
  task_id: PENDING
  target_file: AllMassStrengthen/Strengthen.lean
  expected_module: AllMassStrengthen
  submission_project: AgentTasks/aristotle-submit/allmass-manuscript-strengthen-20260708-project
  output_dir: AgentTasks/aristotle-output/4bf9899f-3e31-42f8-82ab-a6cbfa2b5780
  status: submitted
```

## What this is

A whole-manuscript strengthening / audit job (NOT a `s o r r y`-closing
proof job), submitted at the user's request alongside a parallel Fable-5
review (`fable-calls/call-04-packet.md`). The object under review is
`Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`, shipped verbatim
in the submission package. Aristotle is asked to read it and produce a
rigorous strengthening report, with an invitation to state + attempt the
single most valuable next theorem in Lean if it sees a clean one.

## Package

- Standalone source: `AgentTasks/aristotle-standalone/allmass-manuscript-strengthen-20260708/`
  (Mathlib-only, minimal `AllMassStrengthen/Strengthen.lean` whose docstring
  carries the program summary + candidate next theorems).
- Manuscript shipped as an `-ExtraPath` so it travels with the archive.

## Prompt (submitted)

See the submit command below; the full prompt is recorded in this note and
in the ledger after submission.

## Status log

- 2026-07-08: package prepared; submitting.
- 2026-07-08: submitted. Aristotle project_id
  `4bf9899f-3e31-42f8-82ab-a6cbfa2b5780`. Benign warning (no .lake folder in
  the Mathlib-only focused package; Aristotle fetches Mathlib itself). Poll
  with `aristotle list --limit 10` / `aristotle tasks 4bf9899f-...`.
