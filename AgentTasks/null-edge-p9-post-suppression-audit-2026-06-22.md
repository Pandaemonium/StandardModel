# P9 post-suppression audit

Date: 2026-06-22

Source: Aristotle strategy job `54f2028c-16ad-4fe9-93f4-55075a3813bf`, task
`32029643-a9e9-4229-91ad-edacb7534730`.

## Overall Assessment

The post-suppression P9 branch now has honest finite scaffolding, but it is not
yet a cosmology result. The theorem spine is valuable because it prevents false
claims and gives exact finite scaling laws. It does not yet constrain the
cosmological constant because the amplitudes, cells, sources, and tests are not
geometric yet.

The useful nuclei are:

- `closed_visibleFan_mass_eq_restEnergy`: visible closure is a rest-frame
  condition, not source invisibility.
- `ensembleSecondMoment_eq_card_times_configs`: equal independent residual
  sources have variance `N`.
- `weightedEnsembleSecondMoment_eq_amplitudeSqSum_times_configs` and
  `normalizedWeightedSecondMoment_eq_amplitudeSqSum`: weighted residual sources
  have normalized variance `sum_i amp_i^2`.
- `normalizedUniformSecondMoment_eq_totalSq_div_card`: uniformly spreading a
  fixed scale `A` over `N` independent sign cells gives variance `A^2 / N`.

The current weakness is that `amp_i` is still an abstract real number and the
source pairing still needs a geometric curvature/diamond observable. Without
that, the suppression results are finite random-walk algebra, not physics
leverage.

## Minimal Next Definitions

Build one reviewed `DiamondSourceVisibility` API:

- finite diamond or screen with incidence data;
- geometric cell weights identifying `amp_i` with area, volume, or a chosen
  diamond measure;
- curvature or holonomy-defect cochain replacing `unitTest`;
- observer or coarse-graining projection so invisibility means kernel of the
  observer map, not merely ignored data.

The load-bearing new definitions are the cell weights and curvature-defect
pairing. The observer projection is the bridge to the P7 relative-entropy /
recoverability line.

## Ranked Next Proof Jobs

1. `uniformSuppression_vs_everpresentLambda_tension`: a finite inequality
   comparing `A^2 / N` suppression against the everpresent-Lambda scaling target.
2. `visiblePluckerMass_nonzero_of_noncollinear`: a no-go theorem saying
   non-collinear visible fans carry positive mass/source and cannot be hidden by
   closure.
3. `boundaryExact_iff_invisible_to_curvatureDefects`: a cohomological
   characterization, not just one-way invisibility.
4. `diamondResidualVariance_scales_with_cellArea`: once `amp = area/volume`,
   prove the resulting weighted variance scaling with units.
5. `bfClosed_source_is_exactly_image`: upgrade BF closure into a homology or
   image/coimage statement.
6. `recoverabilityGap_controls_sourceVisibility`: finite relative-entropy /
   recoverability bound shared with P7.
7. `sjDiamondReferenceState_def` plus a second-difference nonnegativity target,
   only after the finite reference-state/truncation convention is fixed.

## Jobs To Avoid

- more fluctuation variants without geometry;
- more duplicated boundary-source adjointness files;
- more one-face or two-ray witnesses;
- generic bilinearity lemmas dressed as physics;
- continuum limits before finite diamond geometry exists;
- any direct numeric theorem for the cosmological constant.

## Pass/Fail Threshold

Promote P9 from aspirational target to a synthesis paper only if the
diamond/screen/curvature/observer layer is fixed and three theorem types land:

- a no-go: visible non-collinearity gives nonzero mass/source;
- a characterization: boundary-exact or BF-closed bookkeeping is exactly what is
  invisible to curvature tests;
- a quantitative suppression or tension inequality compared parametrically with
  everpresent-Lambda scaling.

Keep P9 aspirational or demote it if hidden bookkeeping still sources a bulk
volume term, if the residual reproduces the everpresent-Lambda amplitude tension
without a suppression mechanism, or if the results remain abstract `unitTest`
pairings with no curvature or observer object.

## Integration Notes

Deduplicate the repeated `Cochain`, `dot`, `sourcePairing`, `boundarySource`,
`codiff`, `BulkClosed`, and `BoundaryExact` definitions into one API before
promotion. Keep the closed-visible-fan result and the `sqrt(N)`, weighted, and
uniform-suppression chain as the publishable nuclei.
