# Aristotle C102: direct-overlap shifted-kernel singular-crossing theorem

aristotle:
  project_id: 1af1a6a5-d795-4321-9153-e16b88a2ff69
  task_id: f6d9c1f1-a160-4545-a551-706a5b18855a
  target_file: PhysicsSM/Draft/NullEdgeDirectOverlapSingularCrossing.lean
  expected_module: PhysicsSM.Draft.NullEdgeDirectOverlapSingularCrossing
  submission_project: AgentTasks/aristotle-submit/null-edge-wave26-gate-c-branch-release-20260627-project
  output_dir: AgentTasks/aristotle-output/1af1a6a5-d795-4321-9153-e16b88a2ff69
  status: integrated
  initial_project_status: RUNNING
  initial_task_status: QUEUED
  integrated: 2026-06-27

Dependency class: Independent C1 hazard theorem.

Context pack:

```text
AgentTasks/context-packs/null-edge-wave26-gate-c-branch-release-20260627-121710.md
AgentTasks/null-edge-gate-c-neo4j-lit-lateral-analysis-2026-06-27.md
```

## Background

Raw overlap on the full bare `D_+` is unsafe unless a mass-window theorem rules
out shifted-kernel singularities. If an unwanted branch germ reaches the origin
and crosses the Wilson mass shell, the overlap sign kernel becomes singular:

```text
X_rho(q) = D_+(q) + r W(q) I - rho I.
```

If `D_+(q(t)) v(t) = 0` and `r W(q(t)) = rho`, then `X_rho(q(t)) v(t) = 0`.

## Requested target

Create:

```text
PhysicsSM/Draft/NullEdgeDirectOverlapSingularCrossing.lean
```

Use a finite/predicate-level model if analytic paths are too heavy.

## Desired API

Suggested structures:

```lean
structure ShiftedKernelData where
  Q : Type
  V : Type
  D : Q -> V -> V
  W : Q -> Real
  r rho : Real
  q : Q
  v : V
```

The main theorem can be purely algebraic:

```text
D q v = 0 -> r * W q = rho ->
  (fun x => D q x + (r * W q - rho) • x) v = 0
```

Then package the Gate C interpretation:

```text
exist_zero_branch_crossing -> shifted kernel is singular
```

If feasible, add a finite intermediate-value-style version over a discrete
ordered list of sample points:

```text
if W values straddle rho/r along a certified zero branch, then some listed
point is a shifted-kernel zero
```

## Explicit non-goals

Do not prove or disprove overlap fermions generally. This is a conditional
hazard theorem for direct unprojected overlap on the full bare null-edge branch
locus.

## Acceptance criteria

- Lean file compiles, or a precise report explains why a report-only theorem is
  better.
- No new proof placeholders or escape-hatch declarations.
- The module/report explicitly says raw overlap requires a mass-window
  assumption before it can be used as a C1 route.

## Integration review

Status: integrated 2026-06-27.

Integrated artifact:

```text
PhysicsSM/Draft/NullEdgeDirectOverlapSingularCrossing.lean
```

Result:

- Added a finite conditional hazard theorem for raw direct overlap on the full
  bare branch locus.
- The core theorem packages the fact that a bare zero branch crossing the
  Wilson mass shell makes the shifted overlap kernel singular.
- Added `direct_overlap_requires_mass_window`, the contrapositive guardrail:
  raw overlap requires a mass-window assumption excluding such crossings.
- After Claude review, added the fixed-symbol equivalence
  `directOverlap_requires_per_symbol_mass_window`, which is the usable
  non-vacuous mass-window guardrail.

Review notes:

- This does not prove overlap failure in general and does not prove a C1 release.
- It justifies prioritizing projected-overlap / branch-classifier routes unless
  a concrete mass-window theorem is later proved.
- Claude flagged the original `direct_overlap_requires_mass_window` as too
  globally quantified over arbitrary packaged data to serve as the headline
  guardrail. Use `directOverlap_requires_per_symbol_mass_window` downstream.
