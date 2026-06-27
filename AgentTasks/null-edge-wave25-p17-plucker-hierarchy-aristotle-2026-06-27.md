# Aristotle P17: finite Pluecker hierarchy / higher obstruction ladder

aristotle:
  project_id: 3c535234-4b61-414c-b004-f7202be553d6
  task_id: be7cfcbd-843e-4a14-bde8-2470fff7af34
  target_file: PhysicsSM/Draft/NullEdgePluckerHierarchyAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdgePluckerHierarchyAristotle
  submission_project: AgentTasks/aristotle-submit/null-edge-wave25-lateral-analysis-20260627-project
  output_dir: AgentTasks/aristotle-output/3c535234-4b61-414c-b004-f7202be553d6
  status: submitted
  initial_project_status: RUNNING
  initial_task_status: IN_PROGRESS

Dependency class: Independent, but may reuse P1 finite Pluecker definitions.

Context pack:

```text
AgentTasks/context-packs/null-edge-wave25-lateral-analysis-20260627-114614.md
```

## Background

The trusted P1 theorem is the `k = 2` member of a broader Cauchy-Binet story:

```text
e_k(Psi Psi^dagger) = sum_{|S| = k} |wedge_{i in S} psi_i|^2
```

For two-component Weyl spinors only `k <= 2` survives. In enlarged spaces
(twistors, branch spaces, internal spaces, form-degree spaces), higher exterior
obstructions can diagnose failure to reduce to fewer canonical modes.

The goal is not to claim a jet-substructure theorem or collider observable.
The goal is to create a Lean-friendly finite hierarchy API that makes the
program's "canonical obstruction" language more precise.

## Requested target

Create:

```text
PhysicsSM/Draft/NullEdgePluckerHierarchyAristotle.lean
```

Prefer a small, compiling hierarchy substrate over a grand theorem that becomes
fragile.

## Desired API

Choose the smallest Lean-feasible representation:

- A general finite matrix `A : Matrix (Fin d) (Fin n) Complex`.
- A Gram matrix `G = A * A^dagger`.
- A finite `k`-minor energy / obstruction over column subsets.
- Specialization to `d = 2`, `k = 2` recovers the existing P1 Pluecker mass.

If full elementary symmetric polynomial APIs are too heavy, prove a smaller
rank/obstruction ladder:

```text
all k-minors vanish -> columns span dimension < k
nonzero k-minor -> at least k independent modes
```

or give concrete checked cases `k = 1`, `k = 2`, and possibly `k = 3` over
explicit finite dimensions.

## Required claim discipline

Use names like:

```text
FiniteModeObstruction
PluckerKObstruction
modeRankAtLeast
```

Do not use names that imply Standard Model prediction, Gate C release, or
physical particle counting.

## Acceptance criteria

- New Lean file compiles.
- No new `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, or
  `u n s a f e`.
- If the full Cauchy-Binet hierarchy is too expensive, return a smaller
  verified API plus a clear proof plan for the missing general theorem.
- End with a report listing theorem names and exactly which hierarchy level was
  achieved.
