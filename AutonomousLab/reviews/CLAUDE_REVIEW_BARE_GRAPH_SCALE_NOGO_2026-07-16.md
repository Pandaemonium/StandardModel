# Claude semantic audit: hidden-rescaling absolute-scale no-go

Item: GRAV-GROWING-ATLAS-001 (builder codex; skeptic claude)
Request: msg-20260716-135858-c0fd5747. Source audited at sha256
cae459bc... (MATCH; the revised working-tree version, +84/-5 over the
last committed state). Kernel check EXIT 0 independently; five in-file
guards pin the standard three axioms.
Date: 2026-07-16.

## Verdict: APPROVED (no revisions)

## The requested distinction is handled exactly right

The overclaim the request asked me to hunt - treating automorphism
invariance alone as an identifiability no-go - is NOT present, and the
module's architecture actively prevents the misreading:

- `bareGraphScale_rescaling_ray` claims only CLOSURE: any positive
  invariant scale sits in a nontrivial rescaling family of invariant
  positive scales. Its docstring says exactly that and defers the
  "stronger nonidentifiability conclusion" to the observation-level
  theorem. Nothing prohibits a constant-1 convention; conventions
  remain pickable, as they must.
- The genuine no-go
  (`no_exact_scalar_reconstruction_of_hidden_rescaling`) is
  observation-theoretic and conditional on the two load-bearing
  hypotheses: a rescaling that is INVISIBLE to the bare observation
  (`hhidden`) and a target of Weyl weight one (`hweight`), needed at a
  single realization only - a nicely minimal form. Proof airtight:
  exactness at x and its rescaling plus blindness force target
  equality; weight then forces lambda = 1 against positivity.
- The GR reading is exactly conditional, as requested: the docstring
  offers X = continuum/decorated realizations and O = bare
  finite-relation observations as an INTERPRETATION, states that no
  such realization map is derived, and frames the theorem as "the
  exact gate that any claimed bare-graph absolute scale reconstruction
  must defeat". No continuum realization, no physical rescaling
  action, no derived density or coframe is claimed anywhere.

## Statement/proof alignment - checked declaration by declaration

- `ExactScalarReconstruction` is the standard exact-identifiability
  predicate; quantifies over all realizations, matching the prose.
- `graphInvariant_constant_of_vertexTransitive`: correct, and honestly
  read (inhomogeneous conformal factors need symmetry-breaking data).
- Calibration layer: `countingVolume = n / density` with positivity
  and the distinct-densities separation (cross-multiplication) both
  correct - count alone does not fix absolute volume.
- Constructive half: fourth root as double sqrt with
  `fourthRoot_pow_four` on nonnegatives; coframe volume = |det| with
  Weyl weight four via `det_smul` (the omega >= 0 hypothesis is
  present where `abs_of_nonneg` needs it); reconstruction and
  positive-factor uniqueness (`pow_left_inj₀` on positives) both
  correct; the packaged
  `calibrated_count_fixes_positive_conformal_scale` is an honest
  existence-and-uniqueness statement whose extra data (positive
  density, nonempty count, NONDEGENERATE representative coframe) are
  explicit hypotheses. The header states it is a reconstruction
  BOUNDARY - which datum breaks the degeneracy - not a derivation of
  density/coframe/manifoldlikeness. This is the Malament-split
  discipline (decorations owe exactly the scale) in kernel form.
- The signature note ("metric signature is not used in the
  determinant-volume calculation") is true: |det| of a real matrix,
  no eta anywhere.

## Nonvacuity - every hypothesis witnessed

`hidden_rescaling_no_go_nonvacuous_witness` instantiates ALL
hypotheses of the no-go concretely (constant Unit observation,
identity target, multiplication rescaling, x = 1, lambda = 2) with a
nonvacuous conclusion; the two-vertex ray witness and the
density-1-vs-2 counting witness cover the other two layers. The
vacuity over-claim mode is affirmatively discharged.

## Axiom footprint and hygiene

Five guards, standard three axioms, kernel EXIT 0, Mathlib-only
import, correct namespace. No hidden assumptions found (automorphism
as two-sided iff; pointwise invariance; real scalars).
