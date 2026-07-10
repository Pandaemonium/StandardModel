# Codex proof job: explicit nontrivial six-channel D4 coin

Close every proof in `SixCoin/Core.lean` without changing definitions, ordering,
coefficients, phases, or controls. Prove that three identical normalized
checkerboard `2x2` blocks give an exact two-sided-unitary `6x6` coin, that the
coin is not the identity, that it mixes opposite x-axis directions with the
imaginary `4/5` turn coefficient, and that it has no cross-axis leakage.

This provides the running finite D4 walk with a concrete nontrivial unitary coin
instead of a universally quantified supplied matrix. It does not yet establish
the four-component Dirac sector, rotational isotropy beyond the displayed block
symmetry, interactions, or a continuum limit.

Run `lake env lean SixCoin/Core.lean`; return the complete file.

Context pack:
`AgentTasks/context-packs/explicit-six-channel-coin-20260710-20260710-025001.md`.

```yaml
aristotle:
  project_id: f3224799-5cd3-4c8e-ac80-f948ab60ec7d
  target_file: SixCoin/Core.lean
  expected_module: SixCoin.Core
  submission_project: AgentTasks/aristotle-submit/codex-explicit-six-channel-coin-20260710-project
  output_dir: AgentTasks/aristotle-output/f3224799-5cd3-4c8e-ac80-f948ab60ec7d
  status: integrated
```
