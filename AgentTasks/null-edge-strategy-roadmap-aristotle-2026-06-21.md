# Aristotle task: null-edge strategy roadmap experiment

Date: 2026-06-21

## Objective

Ask Aristotle to do strategy-level research scaffolding for the null-edge
causal graph program rather than proof-hole filling.

This is an explicit experiment in using Aristotle for bigger-picture theorem
planning. The expected output is a hybrid Markdown/Lean roadmap, not a fully
compiling Lean development.

## Context package

Submission project:

```text
AgentTasks/aristotle-submit/null-edge-strategy-roadmap-20260621-project
```

Prompt file included in the package:

```text
AgentTasks/aristotle-strategy-roadmap-prompt-20260621.md
```

Primary research document included in full:

```text
Sources/Null_Edge_Causal_Graph_Strengthened_Program.md
```

Curated context includes `AGENTS.md`, `docs/ARISTOTLE.md`, the research plan,
`PhysicsSMDraft.lean`, the trusted Pluecker and diamond modules, and selected
draft theorem islands around Dirac square roots, Pluecker phases, covariant
differentials, quantum measure, hidden channels, Gram-weighted mass,
super-Dirac blocks, and twistor/Yukawa wrappers.

## Instructions summary

Aristotle should not attempt a full build or one-shot formalization. It should:

- read the program document and curated Lean context;
- identify theorem clusters it thinks are realistically provable;
- propose a final Lean architecture for the finished research program;
- write proof sketches and dependency graphs;
- optionally create Lean scaffold files with documented proof-hole
  placeholders;
- name focused follow-up Aristotle jobs for hard proofs.

## Aristotle metadata

```yaml
aristotle:
  project_id: f5f8699c-4042-4af7-b4cd-2ebdef8de952
  task_id: b5901737-2e86-4424-aa75-b86602cc65e5
  target_file: null-edge-strategy-roadmap-output.md
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/null-edge-strategy-roadmap-20260621-project
  output_dir: AgentTasks/aristotle-output/f5f8699c-4042-4af7-b4cd-2ebdef8de952
  status: analyzed
```

Submitted 2026-06-21. `aristotle submit` created project
`f5f8699c-4042-4af7-b4cd-2ebdef8de952`; `aristotle tasks` reported task
`b5901737-2e86-4424-aa75-b86602cc65e5` as `QUEUED`.

Note: Aristotle emitted expected warnings that the package contains Lean files
without a `lean-toolchain` or `.lake` directory. This was intentional: the prompt
explicitly instructs Aristotle not to build or run Lean, and to treat
`Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` as the full goal
specification.

## Result analysis

Fetched and reviewed 2026-06-21. Main output:

```text
AgentTasks/aristotle-output/f5f8699c-4042-4af7-b4cd-2ebdef8de952/extracted/project-files.tar/null-edge-strategy-roadmap-20260621-project_aristotle/null-edge-strategy-roadmap-output.md
```

Aristotle understood the assignment: it reports that it did not run Lean or
proof search, treated the full strengthened-program document as the goal, and
returned the requested Markdown roadmap plus optional non-compiling scaffold
files under:

```text
PhysicsSM/Draft/NullEdgeRoadmap/
```

Do not copy those scaffold files directly into the live repo. They are useful
planning artifacts, but intentionally contain raw proof-hole placeholders and
some illustrative `True` definitions. Curate individual theorem statements into
focused task files before submission.

High-value takeaways:

- top next job should be definition consolidation into canonical
  `NullEdge/Core` modules;
- prove determinant-is-nonnegative-real before using square-root/mass-ratio
  language;
- pairwise Pluecker phase is not gauge invariant; only closed-loop/triangle
  combinations should be theorem targets;
- diamond source visibility needs definitions before proof attempts;
- cosmology/gravity/CPT claims remain interpretation unless converted into
  finite true-or-false statements.
