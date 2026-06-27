# Aristotle P15: Pluecker mass as finite density-matrix mixedness

aristotle:
  project_id: 56e5e922-f4bb-43b0-9a3d-6df24099661a
  task_id: b52ad67c-be91-4377-9d85-6d227bffe6a9
  target_file: PhysicsSM/Draft/NullEdgeCelestialMixednessAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdgeCelestialMixednessAristotle
  submission_project: AgentTasks/aristotle-submit/null-edge-wave25-lateral-analysis-20260627-project
  output_dir: AgentTasks/aristotle-output/56e5e922-f4bb-43b0-9a3d-6df24099661a
  status: integrated
  initial_project_status: RUNNING
  initial_task_status: QUEUED
  integrated: 2026-06-27

Dependency class: Independent.

Context pack:

```text
AgentTasks/context-packs/null-edge-wave25-lateral-analysis-20260627-114614.md
```

## Background

The new lateral analysis reframes the finite Pluecker theorem as a
two-state density-matrix statement:

```text
P = sum_i psi_i psi_i^dagger
rho = P / tr(P)
det(P) = m^2
det(rho) = normalized impurity
```

In Bloch language, for trace-one qubit density matrices:

```text
det(rho) = (1 - |r|^2) / 4
```

The physics reading is:

```text
massless = pure/projectively rank-one visible null direction
massive = mixed visible celestial state after hidden labels are forgotten
```

This should become a clean finite theorem layer close to the trusted P1 core,
not a continuum or spectrum claim.

## Requested target

Harden or extend:

```text
PhysicsSM/Draft/NullEdgeCelestialMixednessAristotle.lean
```

Use existing definitions and theorems if they are already sufficient. Add only
small helper lemmas when they materially improve the mixedness interpretation.

## Desired additions

Please aim for the strongest Lean-feasible subset of:

- A theorem packaging `det(P) = Pluecker spread` as finite visible mixedness.
- A normalized trace statement for `rho = P / tr(P)`, with explicit nonzero
  trace hypotheses if needed.
- A purity/masslessness equivalence:

```text
det(P) = 0 iff the visible spinors share one projective direction
```

- A hidden-label reading:

```text
forgetting or relabeling internal/generation labels changes no visible mass
```

- A short module docstring update saying this is a finite density-matrix
  reformulation of P1, not a mass-spectrum prediction.

If the existing file already proves the main statements, return a concise
completion report identifying the exact theorem names and any missing theorem
that should be targeted next.

## Explicit non-goals

Do not claim:

- continuum measure convergence;
- entropy monotonicity beyond the finite determinant/purity proxy;
- a QCD, Higgs, Yukawa, or Standard Model mass prediction;
- Gate C release.

## Acceptance criteria

- The target Lean file compiles.
- No new `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, or
  `u n s a f e`.
- Avoid `n a t i v e _ d e c i d e` for headline mixedness theorems.
- Keep the claim label finite identity / finite reconstruction.
- End with a short report: solved targets, theorem names, statement changes,
  remaining gaps, and any axioms or assumptions used.

## Integration review

Status: integrated 2026-06-27.

Integrated artifact:

```text
PhysicsSM/Draft/NullEdgeCelestialMixednessAristotle.lean
```

Result:

- Added the normalized visible-density trace theorem
  `normalizedVisibleDensity_trace`.
- Updated the module claim boundary to present this as a finite density-matrix
  reformulation of P1, not as a mass-spectrum or continuum prediction.

Review notes:

- The theorem is a finite identity with an explicit nonzero visible-trace
  hypothesis.
- No Gate C release, Standard Model mass prediction, entropy monotonicity, or
  continuum limit claim is introduced by this integration.
