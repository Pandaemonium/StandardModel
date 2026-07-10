# Codex proof job: successive-axis four-component Dirac walk

Close every proof in `SuccessiveAxisDirac/Core.lean` without changing the
matrices, factor order, signs, normalized coefficients, derivative statement,
or nondegenerate control. Prove exact Hermiticity/Clifford squares, unitarity of
each normalized factor and their four-factor successive product, the exact
relativistic symbol square, and the componentwise complex derivative showing
that the infinitesimal generator of the split product is `-i H`.

This is the literature-supported Route B around the simultaneous `6 != 4`
obstruction: three axis factors act successively on one shared four-component
space, followed by the mass factor. It is a finite internal/split-step theorem,
not yet a spatial shift, error bound, or continuum propagator.

Reference shape: Mlodinow-Brun, arXiv:1802.03910, especially the successive-axis
3D walk, parity/noncorrelation, four-dimensional massive internal space, and
coin-flip mass term. Clean-room mathematics only.

```yaml
aristotle:
  project_id: 293514db-97eb-4541-97a1-8489683bfe86
  target_file: SuccessiveAxisDirac/Core.lean
  expected_module: SuccessiveAxisDirac.Core
  submission_project: AgentTasks/aristotle-submit/codex-successive-axis-dirac-walk-20260710-project
  output_dir: AgentTasks/aristotle-output/293514db-97eb-4541-97a1-8489683bfe86
  status: integrated-from-running-snapshot
```
