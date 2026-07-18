# Protected-core rank-four projector transition bridge

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`
Status: independently approved and integrated as a conditional finite bridge

## Purpose

The active growing-atlas nerve uses literal protected-core intersections.
`CarrierProbeOverlapTransition.lean` instead restricts probes to intersections
of whole closed carriers. This module places the rank-four projector selector
on the overlap actually tested by the atlas.

## Landed interface

`PhysicsSM/Draft/NullEdge/ProtectedCoreProbeProjectorTransition.lean` defines:

- `ProtectedCorePairOverlap`, the actual shared protected-core event type;
- full and projector-selected restrictions from each local carrier;
- `range_rangeRestriction_eq_range_shared`, the generic shared-projector
  range lemma;
- `projectorSector_pairOverlapCompatible_of_protectedCore_intertwining`, which
  derives equal selected overlap images from two commuting restriction squares
  and shared-range liftability;
- `protectedCorePairTransition`, the resulting unique basis-free transition;
- `four_le_card_of_leftProjectorRestriction_injective`, an overlap nonvacuity
  boundary.

The main theorem does not assume image equality or a compatibility package.
Restricted injectivity remains explicit. If it holds, the actual protected-core
overlap contains at least four events.

## Exact remaining hypotheses

The graph still owes:

1. one rank-four projector on each selected chart carrier;
2. one idempotent projector on each protected-core observation space;
3. intertwining of both local projectors with the shared overlap projector;
4. liftability of the shared projected range into both carrier probe spaces;
5. restricted injectivity;
6. Lorentzian inertia and metric compatibility;
7. triple-overlap compatibility, orientation, spin lifting, and refinement
   convergence.

The derived transition is one linear equivalence per chart pair. It is a
finite nerve local-system object, not yet an event-dependent continuum bundle
transition field.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/ProtectedCoreProbeProjectorTransition.lean`
  passed after the guard block was added.
- `lake build PhysicsSM.Draft.NullEdge.ProtectedCoreProbeProjectorTransition`
  passed (`8041` jobs).
- Four build-enforced axiom guards pin the generic shared-range theorem, the
  protected-core compatibility theorem, the transition specification, and the
  overlap-cardinality boundary to `propext`, `Classical.choice`, and
  `Quot.sound`.
- No proof holes or compiled evaluator are used.
- Independent Claude semantic review approved the source without changes in
  `AutonomousLab/reviews/CLAUDE_REVIEW_PROTECTED_CORE_PROBE_PROJECTOR_TRANSITION_2026-07-16.md`.
  The reviewer confirmed that liftability mentions only the full restrictions,
  contains no local-projector dependence, and therefore does not encode the
  equal selected images that the theorem derives through the shared projector.
  The review also recommends archiving occupied protected-overlap cardinalities
  in the R5 successor: fewer than four events is an exact obstruction to an
  injective rank-four transition.

## Provenance

Program-internal response to the rank-four semantic audit and the mismatch
between the active protected-core nerve and the earlier closed-carrier overlap
transition. The generic range argument is finite linear algebra: an
intertwining square maps the local projector range into the shared range;
idempotence plus liftability gives the reverse inclusion.
