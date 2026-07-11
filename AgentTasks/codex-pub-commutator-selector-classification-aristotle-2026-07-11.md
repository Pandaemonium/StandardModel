# Aristotle proof job: classify commutator-blind matrix selectors

Name this project `codex-pub-commutator-selector-classification-20260711`.

Prove all eight theorem holes in `ChannelCommutatorSelector/Main.lean` with
definitions and statements unchanged. Run the narrow file first.

Scientific purpose: replace Paper F's one-at-a-time selector kills with a
structural theorem. On the live rational `4 x 4` represented carrier space,
every rational-linear scalar selector that annihilates all matrix commutators
must be a scalar multiple of trace; the explicit nonzero trace-zero direction
then proves no such selector is injective.

This is deliberately scoped to `CommutatorBlind`, which is an algebraic
conjugation/spectral-linearity condition. Do not silently strengthen the prose
to all nonlinear spectral, locality, positivity, or information selectors.

Suggested proof:

- prove the two matrix-unit commutator identities entrywise;
- use `Matrix.matrix_eq_sum_single` and linearity to expand arbitrary `X`;
- off-diagonal terms vanish and all diagonal unit values coincide;
- compute `f 1 = 4 * f (matrixUnit 0 0)` and identify the trace;
- use the explicit `diag(1,-1,0,0)` kernel witness for noninjectivity.

Prohibited weakenings:

- no specialization of `X` to diagonal matrices;
- no replacement of factorization by the single trace-zero witness;
- no added continuity, positivity, or finite-list hypothesis;
- no coordinate-functional assumption on `f` beyond rational linearity and
  commutator blindness;
- retain the explicit nonzero kernel control.

If the factor `f 1 / 4` or any matrix-unit sign is wrong, return the exact
countervalue rather than changing the theorem silently.

```yaml
aristotle:
  project_id: 6381645c-f0cf-4884-8adb-fa6a491d42e6
  target_file: ChannelCommutatorSelector/Main.lean
  expected_module: ChannelCommutatorSelector.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-commutator-selector-classification-20260711-project
  output_dir: AgentTasks/aristotle-output/6381645c-f0cf-4884-8adb-fa6a491d42e6
  status: complete-reviewed-local-proof-canonical
  run: overnight-publication-run-2026-07-11
  owner: Codex
```
