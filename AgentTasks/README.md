# AgentTasks

Structured task records for AI coding agents (Codex, Claude, Gemini, Aristotle).

Each task file contains the information an agent needs to work on a specific
formalization goal without additional context.

## Task file format

```markdown
# Task: <short description>

**Type**: definition / proof / repair / review / oracle-check
**Target file**: PhysicsSM/Path/To/File.lean
**Status**: open / in-progress / blocked / done

## Goal

<What needs to be done>

## Context

<Relevant definitions, nearby lemmas, source references>

## Allowed imports

<List of imports the agent may add>

## Constraints

- No sorry in output (or: sorry allowed in draft context)
- No new axioms
- No weakening of theorem statements
- <other constraints>

## Source

<Paper or repo reference for the mathematics>

## Oracle fixtures

<Any CAS-generated expected values to check against>

## Known blockers / failed attempts

<What has been tried and why it failed>

## Handoff notes

<For Aristotle: proof sketch, likely needed lemmas, etc.>
```

## Current tasks

(No tasks yet — add task files here as work begins.)
