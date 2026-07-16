# Aristotle strategy/proof: transported HNU projector frames and central holonomy

```yaml
aristotle:
  project_id: e9a3645d-b658-46fe-b761-5b260df7ddad
  task_id: c538c705-e7e8-4bba-b80d-f8e9dcdee58d
  target_file: TransportedProjectorHolonomy.lean
  expected_module: PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification
  status: integrated-global-subset
```

## Purpose

The fixed-selector and uniform antiperiodic routes are now sharply delimited.
The depth-eight HNU schedule changes Pauli projectors by axis; their inserted
reflections have ordered product `-1`, so the origin is moved from zero to pi.
This job tests the next architecture: a selector frame transported between
substeps rather than held fixed.

## Requested result

Read the exact HNU schedule and the completed `AntiperiodicHNU.lean`. Design the
smallest finite matrix API for:

1. a sequence of orthogonal projectors `P_j`;
2. inter-step unitary frame transports `G_j` satisfying an explicit relation
   such as `P_(j+1) = G_j P_j G_j^*`;
3. selected and complement substep updates in their co-moving frames;
4. an exact telescoping theorem for the selected endpoint;
5. an exact formula for the complement holonomy, including the accumulated
   center element.

Then instantiate as much as possible on the HNU axis schedule. Determine
whether the central `-1` found by the antiperiodic audit is invariant under
schedule-local frame changes, removable only by adding a mirror/bulk sector,
or removable by a concrete nontrivial transported frame.

Return a theorem, a finite counterexample, or a sharpened missing hypothesis.
Do not claim a universal no-go from one phase assignment. Preserve full
zero/pi sectors; projection is not cancellation.

## Acceptance and controls

- Every existential frame has an explicit nonidentity rational/Pauli witness.
- Include a fixed-frame control reproducing the known noncommuting-projector
  obstruction.
- Separate gauge/basis conjugation from a physically different holonomy.
- No primitive-null, locality, anomaly-inflow, or bulk-edge claim unless the
  relevant operator and theorem are actually present.
- Kernel-check any finite theorem and add standard-three guards.

## Review and integration disposition

Interactive Claude/Opus approved the result as a **global-frame central
holonomy no-go and classification**, while confirming that it does not prove a
varying-frame telescope. Review artifact:
`AutonomousLab/reviews/CLAUDE_REVIEW_TransportedProjectorHolonomy_2026-07-13.md`.

The approved subset is integrated as
`PhysicsSM/Draft/NullEdge/HNUGlobalHolonomyClassification.lean`. The live name
and module documentation remove the misleading schedule-local reading. It
contains:

- single-step projector/reflection/coarse conjugation laws;
- the uniform-`G` product law;
- the HNU central `-1` holonomy and global-gauge invariance;
- the different alternating schedule with `+1` holonomy;
- determinant blindness, trace/center separation, and the no-global-gauge map
  theorem.

Verification passed:
`lake env lean PhysicsSM/Draft/NullEdge/HNUGlobalHolonomyClassification.lean`
and
`lake build PhysicsSM.Draft.NullEdge.HNUGlobalHolonomyClassification`.

Successor task `7076b7f1-5c2c-4a6b-be1c-b3f24152cf1c` is active in the same
Aristotle project and targets the genuine schedule-indexed varying-frame law,
including the surviving link cocycle.
