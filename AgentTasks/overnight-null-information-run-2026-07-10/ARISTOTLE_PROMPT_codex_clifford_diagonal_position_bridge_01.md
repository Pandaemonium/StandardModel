# Codex proof job: exact Clifford eigenbasis and position-shift bridge

Close every proof in `CliffordDiagonalPositionBridge/Core.lean` without changing
the project Clifford matrices, tetrahedral component sign table, explicit basis
matrices, factor order, or theorem statements.

The flagship is `axisBasis_conjugates_velocity`: for each of the three axes,
prove the displayed matrix is unitary and conjugates the diagonal `+/-1`
velocity table to exactly `alpha1`, `alpha2`, or `alpha3`. Then prove the
conjugated Fourier symbol has entrywise derivative `-i alpha_j`, and prove the
corresponding finite-torus local shift preserves the exact inner product.

This is the missing dictionary between the landed finite position-register walk
and the landed internal `3+1` Clifford tangent. Preserve
`identity_basis_fails_axis_zero` as a negative control: the basis change is
load-bearing. You may add small helper lemmas, but do not replace the explicit
bases by a noncomputable spectral-theorem witness; the manuscript needs a
reviewable constructive dictionary. Run:

`lake env lean CliffordDiagonalPositionBridge/Core.lean`

Literature/API references: Mlodinow-Brun arXiv:1802.03910, especially the
successive complementary-projector shifts; Mathlib
`Matrix.IsHermitian.eigenvectorUnitary` and `spectral_theorem` are reference
shapes only. The exact bases in this target are the clean-room construction.

```yaml
aristotle:
  project_id: 2fffaca7-a48b-4cfb-9d51-ca4c515cee9c
  target_file: CliffordDiagonalPositionBridge/Core.lean
  expected_module: CliffordDiagonalPositionBridge.Core
  submission_project: AgentTasks/aristotle-submit/codex-clifford-diagonal-position-bridge-20260710-project
  output_dir: AgentTasks/aristotle-output/2fffaca7-a48b-4cfb-9d51-ca4c515cee9c
  status: harvested and independently verified at 06:25 PDT
```

The returned standalone file closes every target theorem and passes local Lean
with linter warnings only. Its proof bodies are an independent implementation
of the already-landed live module; the live module remains canonical because it
has clearer helper lemmas and already passes the 8,092-job guard.
