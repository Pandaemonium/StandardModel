# Aristotle audit: changing-mode embedding and Paper D scope

Act as a hostile functional analyst and mathematical-physics referee. Audit the
new `PhysicsSM/Draft/NullEdge/ChangingModeEmbedding.lean` result against the
Paper D gate and artifact language. Do not edit files.

Questions:

1. Is `interpolate_sample_tendsto` genuinely strong convergence in the natural
   `l2(Z^3;E)` norm, or only convergence of a scalar energy functional? State
   the exact equivalence and any missing completeness/inner-product hypotheses.
2. Is the summability hypothesis exactly sufficient for every `tsum` rewrite?
   Check the subtraction identity and cofinal finite-box limit for hidden sign,
   positivity, or conditional-convergence assumptions.
3. Are `sample_interpolate`, `interpolate_sample`, `interpolate_energy`, and the
   two controls nonvacuous and semantically aligned with restriction and literal
   zero padding?
4. Does any run document falsely identify these integer coefficient boxes with
   finite torus modes, continuum `R^3` momenta, physical lattice spacing, a
   Sobolev rate, position-space interpolation, or Dirac PDE convergence?
5. State the smallest exact scaled sampling/interpolation theorem needed next,
   including normalization, Nyquist/cutoff map, source/target spaces, and the
   hypothesis that yields a quantitative rate.
6. State the smallest channel/state-distance corollary that would confront the
   operational standard of Bisio-D'Ariano-Tosini arXiv:1212.2839 rather than
   merely restating strong convergence.

Output `FATAL`, `MAJOR`, `MINOR`, and `CLEAR` findings with exact declaration or
document phrases. Finish with an acceptability verdict for using this theorem
as one rung in Paper D, and a separate verdict on whether it independently
supports any continuum-physics headline.

```yaml
aristotle:
  project_id: 1daac745-f208-4049-b6ca-5a4fa3a8f513
  target_file: PhysicsSM/Draft/NullEdge/ChangingModeEmbedding.lean
  expected_module: review-only
  submission_project: AgentTasks/aristotle-submit/codex-pub-changing-mode-audit-20260710-project
  output_dir: AgentTasks/aristotle-output/1daac745-f208-4049-b6ca-5a4fa3a8f513
  status: integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Disposition

Harvested 2026-07-10. The audit found no fatal or major issue: the result is
sound, nonvacuous, and acceptable as a Paper D prerequisite. It is exactly
convergence of the squared `l2` coefficient tail, but it does not exhibit an
`l2` Hilbert-space object and does not prove continuum sampling, physical
scaling, a Sobolev rate, PDE convergence, or channel-distance convergence.

Actions taken:

- Renamed the artifact bucket from `Continuum-scope result` to
  `Discrete-to-continuum prerequisite results` and recorded the precise
  squared-energy boundary.
- Added and guarded `outside_mode_killed_nontrivial`, requiring a nonzero input
  coefficient and proving that this nonzero just-outside mode is killed.
- Kept Paper D's position-space Dirac statement explicitly theorem-gated.
- Submitted the quantitative `Z^3` Sobolev-tail successor separately; scaled
  Shannon interpolation and the operational channel-distance corollary remain
  later gates.
