# Aristotle construction-or-no-go: local decoded HNU stay architecture

## Objective

Turn the already landed momentum-space selected-sector construction into an
exact finite real-space local QCA.  The physical rank-two sector should carry
the depth-eight HNU schedule, while the orthogonal internal complement carries
an explicit quasienergy-pi update.  Projector-conditioned substeps may have
onsite stay sectors; no spatial information may move beyond one lattice edge
per primitive substep.

## Supplied modules

- `HNURealSpaceCore.lean` and `HNURealSpaceBridge.lean`: exact local HNU
  conditioned shifts and Fourier symbol;
- `FloquetTransverseComposite.lean`: finite internal selector algebra;
- `HNUSU2FixedVectorCensus.lean` and `HNUTransversePiComposite.lean`: selected
  zero-sector and explicit pi-complement census;
- `HNUExactCore.lean`: immutable endpoint conventions.

## Required deliverable

Create
`PhysicsSM/Draft/NullEdge/HNUDecodedLocalStay.lean` and prove, or sharply
refute, the following ladder:

1. an extended finite real-space state with a three-state transverse internal
   register and the HNU spin/site registers;
2. a finite-depth local update whose selected transverse subspace acts exactly
   as `HNURealSpace.schedule`;
3. the orthogonal complement acts as an explicit local `-1` or finite-depth
   pi-gap update;
4. exact inner-product preservation of the full update;
5. an exact Fourier-symbol intertwiner with `hnuPiComposite`;
6. injectivity of the physical embedding and zero leakage from the selected
   sector;
7. strict one-edge causal support per spatial substep;
8. a nonzero selected origin witness and a nonzero pi-complement witness.

The transverse selector is allowed only as an onsite internal operation.  If
implementing it demands spatially nonlocal access, that is a failure.  If a
fixed finite-depth onsite preparation implements it, prove that fact rather
than assuming it.

## Adversarial exit

If this cannot be done, return a minimal theorem showing which pair among
locality, exact selected-sector invariance, and a uniformly pi-gapped
complement is incompatible.  A finite explicit counterexample is preferred.

## Boundaries

This job may establish a local decoded sector, not anomaly cancellation or a
unique microscopic species.  The pi complement must remain visible in the
statement and report.  Do not modify supplied modules and do not work on the
unrelated proof holes inherited elsewhere in the package.

Verify the new target directly with `lake env lean`; do not run a full build.
Use no new assumptions or compiler-trusted decision procedures.  Finish with a
theorem inventory, counterexamples, residual gates, and axioms.

## Aristotle metadata

```yaml
aristotle:
  project_id: 8ac5c53d-c285-477b-92ed-6866a6413076
  task_id: 39ed67a1-ec52-4943-9184-8dc09d9287e9
  target_file: PhysicsSM/Draft/NullEdge/HNUDecodedLocalStay.lean
  expected_module: PhysicsSM.Draft.NullEdge.HNUDecodedLocalStay
  submission_project: AgentTasks/aristotle-submit/hnu-decoded-local-stay-20260719-project
  output_dir: AgentTasks/aristotle-output/8ac5c53d-c285-477b-92ed-6866a6413076
  status: integrated
```

The first submission attempt on 2026-07-19 was rejected before project creation
because the account already had 15 projects in progress. After an older task
reported `COMPLETE_WITH_ERRORS`, the released slot was used for this project.
Initial task state: `QUEUED`.

## Integration record

Harvested from Aristotle and integrated on 2026-07-19. The returned module
constructs a finite real-space update in which the selected transverse line
carries the exact HNU schedule and the orthogonal complement receives a visible
quasienergy-pi phase. It proves selected-sector invariance, zero leakage,
inner-product preservation, Fourier intertwining, onsite selection, and
nonzero witnesses in both sectors. This is a decoded local architecture, not a
derivation of the physical selector or an anomaly-cancellation theorem.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdge/HNUDecodedLocalStay.lean
```

The direct check passed under the pinned toolchain.
