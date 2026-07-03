# Null-edge checkerboard generator-expansion Aristotle job

Date: 2026-07-02
Status: integrated.

## Purpose

Send Aristotle the next checkerboard analytic-scaffold target after Codex
locally closed the finite endpoint-count and closed-form propagator identities.

The main target is:

```lean
HasDerivAt isotropicStep isotropicGenerator 0
```

plus any supporting generator-expansion lemmas in
`PhysicsSM/Draft/CheckerboardContinuumScaffold.lean`.

## Submission packet

- Prompt:
  `AgentTasks/aristotle-prompts/null-edge-checkerboard-generator-expansion-20260702.prompt.md`
- Expected focused package:
  `AgentTasks/aristotle-submit/null-edge-checkerboard-generator-expansion-20260702-project`
- Source root:
  `NullEdgeStandalone`

## Aristotle metadata

```yaml
aristotle:
  project_id: b50db3dd-7395-46fd-924f-c75e62638d21
  task_id: 212e5c96-f926-42a4-a02a-b0e6f16ff340
  target_file: PhysicsSM/Draft/CheckerboardContinuumScaffold.lean
  secondary_target_file: PhysicsSM/Draft/CheckerboardSpacetimeCounts.lean
  expected_module: NullEdgeStandalone
  submission_project: AgentTasks/aristotle-submit/null-edge-checkerboard-generator-expansion-20260702-project
  output_dir: AgentTasks/aristotle-output/b50db3dd-7395-46fd-924f-c75e62638d21
  status: integrated
```

## Preflight

Codex added the finite generator setup locally and verified:

```text
lake env lean PhysicsSM/Draft/CheckerboardContinuumScaffold.lean
lake env lean PhysicsSM/Draft/CheckerboardSpacetimeCounts.lean
```

## Local follow-up while running

While the Aristotle job was still running, Codex locally proved:

- `isotropicStep_hasDerivAt_zero`;
- `isotropicGenerator_commutes_isotropicStep`.

The job is still useful as an independent review and for stronger quantitative
remainder/product lemmas. Returned duplicate proof code should be compared
semantically but does not need to be integrated verbatim.

## Submission result

Submitted on 2026-07-02.

```text
Project created: b50db3dd-7395-46fd-924f-c75e62638d21
Task: 212e5c96-f926-42a4-a02a-b0e6f16ff340
Initial status: QUEUED
```

The Aristotle CLI warned that the project has no `.lake` folder. This is
intentional for the focused package: the upload includes `lakefile.toml`,
`lake-manifest.json`, `lean-toolchain`, and the standalone Lean source, but not
the local dependency cache.

## Integration result

Fetched and reviewed on 2026-07-02.

Integrated into `PhysicsSM/Draft/CheckerboardContinuumScaffold.lean`:

- `hasDerivAt_isotropicStep`, Aristotle's stronger arbitrary-angle derivative
  theorem;
- `hasDerivAt_isotropicStep_zero`, retained as an Aristotle-name alias for the
  local zero-angle theorem.

Codex also retained its local
`isotropicGenerator_commutes_isotropicStep` finite commutation lemma. The result
is finite calculus / analytic scaffold only; no continuum Dirac-limit theorem is
claimed.

Verification after integration:

```text
lake env lean PhysicsSM/Draft/CheckerboardContinuumScaffold.lean
lake env lean PhysicsSM/Draft/CheckerboardSpacetimeCounts.lean
```
