# P9 source-visibility audit

Date: 2026-06-22

Source: Aristotle strategy/audit project
`b4a64238-2247-4889-935c-9696cf600694`, task
`eda403b1-4cc3-47e9-97bb-13b0cf985870`.

## Overall Assessment

The five new P9 atoms establish a clean finite grammar plus two useful guards:
a non-vacuity witness and a mean-zero lemma. They correctly refuse to conflate
visible closure `C = 0` with vacuum.

However, four of the five atoms are still standard linear or homological algebra
in P9 language: adjoint integration by parts, boundary-of-boundary equals zero,
and antisymmetry implies zero total source. None yet exercises the actual P9
decision threshold, which is about bulk/volume versus boundary scaling of a
source paired against a diamond curvature defect.

Only `NullEdgeP9VisibleClosureSource` directly touches the physics claim, and it
does so as one hardcoded instance. Aggregate Lane-D physics readiness is about
4/10: good vocabulary, no threshold-bearing theorem yet.

## Module Scores

- `NullEdgeP9VisibleClosureSource`: 6/10. This is the only atom encoding the
  gate's core separation and tied to the `(E^2 - |C|^2) / 4` mass formula, but
  it is capped by being one hardcoded instance.
- `NullEdgeP9DiamondVisibility`: 4/10. It gives observer-facing vocabulary and a
  non-vacuity guard, but no diamond geometry and proofs are adjointness-level.
- `NullEdgeP9BoundarySource`: 3/10. It has the right shape for boundary
  bookkeeping invisible to closed tests, but it is exactly the adjoint identity,
  with no scaling or curvature.
- `NullEdgeP9BFClosure`: 3/10. It is a faithful boundary-of-boundary placeholder,
  but still standard homology and not yet the BF closure `sum_f B_f = 0`.
- `NullEdgeP9MeanZeroFluctuation`: 3/10. It is a sensible mean-zero-before-
  variance guardrail, but it is trivial and disconnected from amplitude/scaling.

## Recommended Unified API

Create one `PhysicsSM.Draft.DiamondSourceVisibility` module with one copy of:

- `Cochain`, `dot`, `sourcePairing`, `boundarySource`, `codiff`;
- `BulkClosed`, `BoundaryExact`, `ChainComplex`,
  `InvisibleToClosedBulkTests`;
- `MeanZero`, `secondMoment`;
- a visible-fan layer: `closureVector`, `totalEnergy`, `momentMassSq`,
  `massSource`.

Bank the proven lemmas once: adjoint integration by parts,
boundary-exact invisibility, boundary-of-boundary vanishing, source-pairing
additivity, mean-zero by antisymmetry, and a non-vacuity witness.

What is still missing for physics-bearing P9:

- an observer/coarse-graining channel shared with P7;
- a diamond curvature defect pairing against causal-diamond holonomy;
- a bulk-face versus boundary-cell scaling notion;
- a fixed adjoint convention, because the toy files currently reuse `D j i` in
  both directions.

## Next Proof Jobs

1. `closed_visibleFan_mass_eq_restEnergy` for a general weighted fan.
2. `visiblePluckerMass_nonzero_of_noncollinear`.
3. A bulk-versus-boundary scaling or threshold lemma.
4. `bfClosure_implies_no_bulkDivergence` stated against a diamond curvature
   defect.
5. Finite observer channel plus relative-entropy monotonicity shared with P7.
6. `diamondSource_additive_iff_orthogonal`.
7. `petzRecoverabilityGap_controls_sourceVisibility`, initially as a finite
   definition plus one inequality.
8. A definition-design or consolidation job for the unified API and adjoint
   convention.

Submit 1, 2, and 8 first; jobs 3, 4, and 5 depend on 8.

## Jobs To Avoid

- More adjointness or boundary-of-boundary restatements.
- More hardcoded numeric fan instances.
- `sjDiamondReferenceState_def` and diamond relative-entropy second differences
  before the Pauli-Jordan truncation and reference/channel choices are fixed.
- `relativeEntropyDataProcessing_for_diamondObserver` before the observer
  channel object exists.
- Full Type-III/continuum ANEC or area-law formalization.
- Prose-to-Lean restatements of "vacuum energy should not gravitate".

## Pass/Fail Criteria

P9 should be kept/promoted only if the next batch proves:

- a general closed-visible-fan rest-energy theorem tied to the trusted Pluecker
  mass;
- one finite source functional that separates boundary-exact-to-zero,
  BF/internal-to-boundary-only or mean-zero, and visible non-collinear-to-
  strictly-nonzero cases over a nontrivial index;
- and either a first scaling result, where invisible sectors pair like boundary
  terms and visible mass pairs like a bulk term, or an observer-channel
  recoverability inequality.

Demote or revise the branch if:

- coherent/internal or BF-closed bookkeeping is forced to a bulk volume-scaling
  source;
- invisibility remains only the trivial adjoint/boundary identity with no diamond
  geometry;
- the residual inherits the everpresent-Lambda amplitude problem with no
  suppression mechanism;
- or the only positive theorem is a hardcoded one-face or numeric instance.

## Integration Notes

The highest-ROI next step is API consolidation plus generalizing the
visible-closure instance. Keep everything in `PhysicsSM.Draft` until semantic and
convention review. The branch now has enough low-threshold atoms; the next slot
should be threshold-bearing or consolidation-oriented, not decorative.
