# Aristotle task: diamond source visibility core proof fill

Date: 2026-06-22

## Objective

Fill the three remaining finite proof holes in the P9 source-visibility scaffold
returned by Aristotle's API-design job.

Prompt:

```text
AgentTasks/aristotle-diamond-source-visibility-core-prompt-20260622.md
```

Target:

```text
PhysicsSM/Draft/NullEdgeDiamondSourceVisibilityRoadmap.lean
```

## Expected output

- proof of `diamondSource_additive_iff_orthogonal`, if the statement is correct;
- proof or counterexample for `closed_visibleFan_mass_eq_restEnergy`;
- proof or counterexample for `visiblePluckerMass_sources_bulkTerm`;
- no full-repo import or continuum physics claims.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-output/f01ec82f-ccac-44b6-b2c3-7b55433a2394/extracted/null-edge-p9-source-visibility-api-20260621-project_aristotle/PhysicsSM/Draft/NullEdgeDiamondSourceVisibilityRoadmap.lean
```

Result before submission: passed with exactly three intended proof-hole
warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 9b37228c-352d-4406-a29d-6946cb567b85
  task_id: 32d5aabe-87f0-4cb5-9cc8-c94aba9b1e98
  target_file: PhysicsSM/Draft/NullEdgeDiamondSourceVisibilityRoadmap.lean
  expected_module: PhysicsSM.Draft.NullEdgeDiamondSourceVisibilityRoadmap
  submission_project: AgentTasks/aristotle-submit/null-edge-diamond-source-visibility-core-20260622-project
  output_dir: AgentTasks/aristotle-output/9b37228c-352d-4406-a29d-6946cb567b85
  status: integrated_standalone
```

Submitted 2026-06-22. `aristotle submit` created project
`9b37228c-352d-4406-a29d-6946cb567b85`; `aristotle tasks` reported task
`32d5aabe-87f0-4cb5-9cc8-c94aba9b1e98` as `QUEUED`, and `aristotle list`
reported the project as `RUNNING`.

Packaging note: this is a focused package with `lean-toolchain`,
`lakefile.toml`, and `lake-manifest.json`, but no `.lake` directory. Aristotle
warned about the missing `.lake` directory. The target itself was checked from
the main repo environment before submission and elaborated with exactly three
intended proof-hole warnings.

Completed and integrated 2026-06-22:

- Copied the returned target into
  `AgentTasks/aristotle-standalone/null-edge-diamond-source-visibility-core-20260622/PhysicsSM/Draft/NullEdgeDiamondSourceVisibilityRoadmap.lean`.
- Locally verified:

  ```text
  lake env lean AgentTasks/aristotle-standalone/null-edge-diamond-source-visibility-core-20260622/PhysicsSM/Draft/NullEdgeDiamondSourceVisibilityRoadmap.lean
  ```

  Result: passed.
- Scanned the copied scaffold for executable proof holes and escape-hatch
  declarations; no hits after comment-token cleanup.

Substantive results:

- proved `diamondSource_additive_iff_orthogonal`;
- proved `closed_visibleFan_mass_eq_restEnergy`;
- proved `visiblePluckerMass_sources_bulkTerm`;
- added the helper identity `visibleMass_four_mul_identity`;
- changed no target theorem statements.
