# Aristotle task: P9 screen variance bound

Submitted: 2026-06-24.

## Scientific role

This task advances the `P9-F` source-visibility and finite noise-suppression
lane.

The current P9 branch has several finite guardrails: exact or boundary-like
bookkeeping is invisible to closed bulk tests, projected tests see only the
projected source, and weighted residual-source sums give exact finite
variance laws. The next useful publication-facing step is a very small screen
support bound:

```text
if every residual source amplitude on a screen has squared size at most sigmaSq,
then the screen second moment is at most screen.card * sigmaSq.
```

This is not a cosmological-constant result by itself. Its value is that it
turns a local per-cell residual bound into a finite screen-cardinality scaling
law. It supports the P9 distinction between volume-supported residuals,
screen-supported residuals, and any later harmonic/global residual mode.

## Aristotle instructions

Please work on:

```text
NullEdgeP9ScreenVarianceBound/Core.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeP9ScreenVarianceBound/Core.lean
```

Primary targets:

```lean
screenSecondMoment_le_card_mul_sigmaSq
normalized_screen_variance_bound
screen_bound_le_volume_bound
```

Guardrails:

- Keep this as finite real algebra over `Finset (Fin n)`.
- Do not introduce physics assumptions, continuum limits, hidden asymptotics,
  or fake hypotheses.
- Do not weaken the statements unless one is mathematically false; if a
  statement needs an extra positivity hypothesis, explain exactly why.
- Prefer short reusable lemmas only if they reduce the proof burden.
- This should stay a focused P9-F theorem package: screen support gives a
  finite variance bound, not a full gravitational response law.

Please finish with a concise completion report:

- which targets were solved;
- whether any statement/API change was needed;
- any hidden assumptions or theorem-strength concerns;
- suggested next finite P9 theorem, especially one connecting screen support to
  a named observer/coarse-graining map, harmonic sector, or response law.

## Metadata

```yaml
aristotle:
  project_id: 443ba768-3578-4725-8fca-d1df1ff566ba
  task_id: f878249e-29a4-43f0-8f21-18f62c979da7
  target_file: NullEdgeP9ScreenVarianceBound/Core.lean
  expected_module: NullEdgeP9ScreenVarianceBound.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-screen-variance-bound-20260624-project
  output_dir: AgentTasks/aristotle-output/443ba768-3578-4725-8fca-d1df1ff566ba
  status: integrated
```

## Integration result

Integrated 2026-06-24 into:

- `PhysicsSM.Draft.NullEdgeP9ScreenVarianceBound`
- `PhysicsSMDraft.lean`

The live draft module proves the screen second-moment bound, the normalized
variance bound after dividing by `volume^2`, and the comparison between
screen-cardinality and volume-cardinality bounds. The result is finite
screen-support arithmetic only; it does not assert a gravitational response law.
