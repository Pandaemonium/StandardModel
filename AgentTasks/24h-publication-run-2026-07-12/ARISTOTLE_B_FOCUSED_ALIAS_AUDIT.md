# Aristotle focused audit: failed `3+1` successor routes

Conduct a hostile semantic audit of only the following live modules and the
manuscript passages that cite them:

- `PhysicsSM/Draft/NullEdge/StationaryAmplitudeProjectorWalk.lean`
- `PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylTangent.lean`
- `PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylAlias.lean`
- `PhysicsSM/Draft/NullEdge/PairedDeterminantReality.lean`
- `PhysicsSM/Draft/NullEdge/ReciprocalCoinFamily.lean`
- `PhysicsSM/Draft/NullEdge/CoupledReciprocalSliceNoGo.lean`
- lines 1640-1740 of
  `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`.

This is review-only.  Do not edit files and do not run a broad build.  Return
`B_FOCUSED_ALIAS_AUDIT_REPORT.md`.

## Required checks

1. Check vacuity, hollow telescoping, prose outrunning the kernel, and false
   mathematical shape theorem by theorem.
2. Verify that the stationary-amplitude tangent is genuinely isotropic and has
   nonzero onsite coefficients, and that the exact alias is distinct from the
   origin in the same phase convention.
3. Verify that the coupled reciprocal root existentials are physical
   unit-circle roots with nonzero momentum and do not rely on sampled data.
4. Check that determinant-one, register order, factor order, and zero/pi sign
   conventions are consistent across source and prose.
5. Identify every place where an architecture-level no-go could be mistaken
   for a universal reciprocal or stationary-amplitude no-go.
6. State whether each manuscript sentence in the cited range is supported,
   needs narrowing, or can be strengthened.
7. Propose the smallest exact negative control missing from either route.

The expected verdict is allowed to be negative.  Do not reward a theorem for
being kernel-checked if its statement is not the intended physics.

```yaml
aristotle:
  project_id: 3ac9a0c9-c6f5-45e4-97df-57ebc3f27148
  task_id: cd4a927a-4189-4300-83eb-5a2548829fa7
  target_file: review-only
  expected_module: B_FOCUSED_ALIAS_AUDIT_REPORT.md
  expected_report: AgentTasks/24h-publication-run-2026-07-12/B_FOCUSED_ALIAS_AUDIT_REPORT.md
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-focused-alias-audit-20260711-project
  output_dir: AgentTasks/aristotle-output/3ac9a0c9-c6f5-45e4-97df-57ebc3f27148
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

## Verdict and response

The audit found all six modules mathematically sound and convention-consistent,
with architecture/slice scope preserved.  It identified three narrowings:

- product-level isotropic first derivative was inferred from per-axis moments;
- `additional` in the coupled slice was not backed by an intended-node theorem;
- the stationary alias lacked a direct nonconstancy control.

Response: the manuscript now says per-axis moments and marks the product rule as
an unpackaged inference; the coupled sentence now says nonzero-momentum
crossing; and `StationaryAmplitudeWeylAlias.nonconstant_control_entry` plus
`nonconstant_control` prove the symbol is not identically one.  The full report
is `B_FOCUSED_ALIAS_AUDIT_REPORT.md`.
