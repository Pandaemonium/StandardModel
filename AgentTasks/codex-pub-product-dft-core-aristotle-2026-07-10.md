# Aristotle proof task: exact product-character DFT core

Prove every theorem in `ProductDFTCore/Main.lean` without changing a statement.
This is the focused harmonic-analysis split from the stalled full live-walk DFT
job.  Run `lake env lean ProductDFTCore/Main.lean` first and return the largest
proof-complete prefix if a later theorem blocks.

Requirements:

- preserve `Axis = Fin 3`, `Position L = Axis -> ZMod L`, the positive
  `planeWave` convention, and the exact `1 / sqrt(siteCard)` normalization;
- prove both row and column orthogonality for every nonzero `L`;
- retain the equal-column and explicit distinct-column controls;
- do not use compiler-trusting evaluation or add assumptions;
- report any Mathlib character-orthogonality theorem used, including its exact
  sign convention.

This job proves finite product Fourier infrastructure only.  It does not claim
operator conjugacy, a continuum limit, or physical Lorentz invariance.

```yaml
aristotle:
  project_id: 93e993ec-c74c-466b-979d-840ca3f82463
  target_file: ProductDFTCore/Main.lean
  expected_module: ProductDFTCore.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-product-dft-core-20260710-project
  output_dir: AgentTasks/aristotle-output/93e993ec-c74c-466b-979d-840ca3f82463
  status: integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```
