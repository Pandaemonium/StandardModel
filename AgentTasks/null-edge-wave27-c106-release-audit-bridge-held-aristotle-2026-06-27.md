# Aristotle C106 held packet: bridge finite release-audit toy guardrails into Gate C APIs

Date: 2026-06-27
Status: held_packet_prepared
Dependency class: independent / soft-dependent
Proposed target: `PhysicsSM/Draft/NullEdgeReleaseAuditBridge.lean`

## Repository context

This is a Lean 4 / Mathlib project for Standard Model-adjacent algebra and the null-edge program. Gate C is the current hard external-branch problem. Current discipline:

- C0 means external species health, such as scalar Wilson gapping of non-origin branches.
- C1 means physical chiral release and remains open.
- A C1 release requires explicit physical-sector data: retained Weyl line, mirror inverse-propagator gap, anomaly accounting, ghost-zero safety, Krein/spectral health, and locality or controlled quasi-locality.
- Route labels such as overlap/Ginsparg-Wilson/domain-wall/projection do not themselves prove release.

Relevant local modules now available:

- `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean`: recovered C90 API hardening for `ProjectedWilsonGateCRelease D_phys`, with residue positivity, no ghost-zero safety, BRST/Krein, and regulator-moduli clauses separated.
- `PhysicsSM/Draft/NullEdgeBranchLocusPhysicalSectorAPI.lean`: C100 branch-locus/physical-sector API.
- `PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean`: C104 branch classifier / `T_br` scaffold.
- `PhysicsSM/Draft/NullEdgeReleaseAuditToyGuardrails.lean`: finite toy counterexamples showing route label, projection, and localization do not imply full release audits.
- `PhysicsSM/Draft/NullEdgeLocalityCertificateToy.lean`: finite toy counterexamples showing a formal projector does not imply locality, and quasi-local decay is not finite-range ultralocality.

## Request

Please create or propose a small Lean module `PhysicsSM/Draft/NullEdgeReleaseAuditBridge.lean` that connects the toy guardrails to the real Gate C planning APIs without claiming a physical release.

Preferred shape:

1. Import the C90/C100/C104 APIs plus the two toy guardrail modules if they compile together.
2. Define a compact `ReleaseAuditBridge` or similarly named structure whose fields explicitly mention:
   - a route label or projected/branch-classifier datum,
   - a full release-audit datum,
   - a locality certificate slot distinguishing finite-range from quasi-local decay,
   - a ghost-zero safety slot separated from residue/Krein positivity.
3. Prove theorem-level guardrails, for example:
   - route/projector/classifier data alone does not produce `ProjectedWilsonGateCRelease` without the audit fields;
   - formal projector data alone does not produce the locality slot;
   - residue/Krein positivity alone does not produce the ghost-zero slot, reusing C90 if possible.
4. Keep every result draft/toy/planning-only unless the actual imported APIs already prove the claim cleanly.

## Acceptance criteria

- The target module elaborates with `lake env lean PhysicsSM/Draft/NullEdgeReleaseAuditBridge.lean`.
- No fake assumptions, no new axioms, no proof placeholders.
- No theorem states or implies that C1 is solved.
- The final docstring clearly says this is release-audit plumbing, not a concrete null-edge operator construction.
- If the imports are too tangled, return a precise report explaining the minimal missing bridge API.

## Why this matters

Cycles 20-24 converted several literature warnings into finite guardrails. The next useful step is to make those guardrails cite the real C90/C100/C104 release APIs, so future C1 work cannot silently downgrade audit fields into route vocabulary.
