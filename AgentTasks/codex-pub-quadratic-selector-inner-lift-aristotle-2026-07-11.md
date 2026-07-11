# Aristotle proof job: inner-product quadratic selector lift

Name this project `codex-pub-quadratic-selector-inner-lift-20260711`.

Prove all seven theorem holes in `ChannelQuadraticInnerLift/Main.lean` with every
definition, hypothesis, quantifier, and conclusion unchanged. Run
`lake env lean ChannelQuadraticInnerLift/Main.lean` first.

Scientific purpose: lift Paper F's exact scalar quadratic-selector
classification to arbitrary real inner-product channel spaces, including finite
matrix/operator spaces with Frobenius inner product. The result must retain the
negative control that distinct positive metrics select distinct decompositions
of every nonzero total. This is selection after a metric is supplied, not a
derivation of the physical metric.

Preferred route: rewrite norm squares as real self-inner-products, expand with
`inner_add_left`, `inner_add_right`, `real_inner_smul_left`,
`real_inner_smul_right`, and `real_inner_comm`, then use ring normalization.
For equality/uniqueness, use positivity plus `norm_eq_zero`; do not add finite
dimensionality or differentiability.

Prohibited weakenings:

- no specialization to `V = Real`;
- no orthogonality assumptions on `x,y,z`;
- no replacement of global uniqueness by stationarity;
- no deletion of the nonzero metric-disagreement control;
- no new assumptions beyond the displayed real inner-product API.

If any statement is false, return an explicit counterexample rather than
changing it.

```yaml
aristotle:
  project_id: c6b52d4a-41ab-470b-b4a9-7965dad75daa
  target_file: ChannelQuadraticInnerLift/Main.lean
  expected_module: ChannelQuadraticInnerLift.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-quadratic-selector-inner-lift-20260711-project
  output_dir: AgentTasks/aristotle-output/c6b52d4a-41ab-470b-b4a9-7965dad75daa
  status: integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```
