# Bare-graph absolute-scale identifiability

Date: 2026-07-16  
Work item: `GRAV-GROWING-ATLAS-001`  
Status: hidden-rescaling no-go and transmutation covariance independently approved

## Correction

Automorphism invariance alone does not logically prohibit a convention such as
the constant scalar `1`. What it proves is weaker: every positive invariant
field belongs to a positive rescaling ray, so relabeling symmetry does not
distinguish a member of that ray.

The physically relevant no-go requires an observation map. If two realizations
have the same bare observation while a positive physical length changes by a
nontrivial Weyl factor, an estimator of that length from the observation would
have to return two different values on the same input.

## Integrated theorem

`PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean` now defines
`ExactScalarReconstruction` and proves
`no_exact_scalar_reconstruction_of_hidden_rescaling`.

Displayed hypotheses:

- a realization type `X` and observable type `O`;
- `observe : X -> O` and a real target;
- a positive nonunit factor `lambda` and rescaled realization;
- observational degeneracy under that rescaling;
- Weyl-weight-one transformation of the target;
- positivity of the target at the witness realization.

Conclusion: no estimator `O -> Real` reconstructs the target exactly on every
realization. A constant-observation real-line witness discharges every
hypothesis and prevents vacuity.

## GR interpretation

Take `X` to be continuum or decorated realizations, `O` to be their bare finite
relation, and the target to be a physical length. Uniform metric rescaling is
then invisible to `O` but changes the target, so the remaining absolute unit is
not identifiable from `O` alone.

This does not derive the realization type, the forgetful observation, or its
rescaling degeneracy from a graph. It is the exact conditional gate that an
absolute-scale claim must defeat. The existing count theorems remain valid:
common density cancels in relative four-dimensional Weyl factors, while one
density or anchor-scale calibration is still required for an absolute unit.

## Dimensional-transmutation boundary

`PhysicsSM/Draft/NullEdge/OneLoopDimensionalTransmutation.lean` now proves
`transmutation_simultaneous_scale_package`. A common positive rescaling of the
reference scale `mu` and invariant scale `Lambda` cancels exactly from the
dimensionless running coupling, while the reconstructed `dynScale` acquires
the same linear factor.

Thus dimensional transmutation is a viable mechanism for selecting a scale
relative to a supplied reference and a derived beta function. It does not
evade the absolute-unit no-go: rescaling the reference unit rescales the
generated scale with it. The null-edge program still owes the physical running
coupling, beta coefficient, reference-scale interpretation, and calibration.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean`
  passes with no diagnostics;
- `lake build PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction` passes
  (`8026` jobs);
- `lake env lean PhysicsSM/Draft/NullEdge/OneLoopDimensionalTransmutation.lean`
  and its targeted `lake build` pass (`8026` jobs);
- Lean MCP source scan is clean and the theorem reports only `propext`,
  `Classical.choice`, and `Quot.sound`;
- both capstone theorems have build-enforced axiom guards.

## Remaining debt

- The hidden-rescaling theorem and graph-facing reading were independently
  approved without revision in
  `AutonomousLab/reviews/CLAUDE_REVIEW_BARE_GRAPH_SCALE_NOGO_2026-07-16.md`.
- The transmutation covariance addendum was independently approved in
  `AutonomousLab/reviews/CLAUDE_REVIEW_TRANSMUTATION_SCALE_ADDENDUM_2026-07-16.md`;
  its suggested local supporting-theorem guards were backfilled.
- A successful physical program still needs either a graph-sensitive scale
  observable, a dynamically generated dimensionful constant, or an explicit
  calibration map to laboratory units.
