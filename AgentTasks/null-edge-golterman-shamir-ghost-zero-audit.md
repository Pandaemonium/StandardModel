# C47/C48 Golterman-Shamir ghost-zero safety audit -- returned summary

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run 702fccf8-b210-4077-b8a4-22211bd6aff1
The focused package did not ship the standalone report file; this is the
returned summary, preserved verbatim as the integration record.

---

Completed the Gate C Golterman–Shamir ghost-zero safety audit (C47/C48).

**Deliverable 1 — Report** `AgentTasks/null-edge-golterman-shamir-ghost-zero-audit.md`:
- Converts the Golterman–Shamir propagator-zero hazard (arXiv:2311.12790) into a precise null-edge Gate C checklist (enumerate → classify → dispersion → Krein/residue sign → gauge response → composite-field test → verdict), extending the Working Plan §23.6/§25.3 protocol with the missing residue-sign and ghost-promotion steps.
- Distinguishes the six zero types (physical pole, physical doubler, kinematical zero, composite-removable zero, Krein artifact, fatal ghost zero), including the two crucial boundary distinctions (Krein artifact vs. fatal ghost via physical-sector projection; composite-removable vs. physical doubler via field redefinition).
- States exactly what must be proven after weak gauge coupling (no ghost generation, residue-sign control, projection persistence, joint index+safety survival).
- Gives clear four-valued release/downgrade language: RELEASED / PENDING-SAFETY / DOWNGRADED-GHOST-HAZARD / REDESIGN-REQUIRED, with the binding rule that a computed flavored index never releases Gate C on its own. Current honest status of Route B: PENDING-SAFETY.

**Deliverable 2 — Lean module** `PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean`:
- Self-contained (imports only Mathlib), convention-compatible with the C19 release criterion and C22 Krein-signature modules (`Fin 4` branches, `g5pattern = (+,+,-,-)`, `flavoredIndex = Σ s·g5`).
- Provides the predicate/theorem API: `ZeroKind` (6-way classification), `ZeroDatum`/`IsFatalGhost`/`WellClassified`, `GhostZeroSafe` with operational characterization `ghostZeroSafe_iff`, `KreinPositivePhysicalSector` (C22 interface), `GateCFullRelease`, `GateCVerdict`, and the open post-gauge-coupling contract `PostGaugeGhostSafe` with a proven sufficient condition.
- Proves the central separation theorem `index_nonzero_not_sufficient`: there is a Route B dataset with maximal flavored index 4 that nonetheless fails release because it harbours a fatal ghost zero — formalizing the instruction that a flavored index must not release Gate C unless ghost-zero and Krein-positive safety are separately accounted for. Also proves non-vacuity (`safeRouteB_releases`) and that the contract is both satisfiable and nontrivial.

The module builds cleanly (no errors, no warnings), is `sorry`-free, adds no axioms or `@[implemented_by]`, and the summary theorem `gateC_ghostzero_audit_summary` uses only the standard axioms (propext, Classical.choice, Quot.sound). All physical inputs (actual Clifford symbol, residue signs, weak-coupling deformation) are recorded as stated-but-open obligations rather than trusted assumptions.

Note: the pre-existing sibling files (`NullEdgeGateCReleaseCriterion.lean`, `NullEdgeBranchKreinSignatures.lean`) import upstream files (`NullEdgeFlavoredChirality`, `KreinDoubleAndCounterexamples`) that are absent from this project snapshot, so the default build target does not compile; this is pre-existing and unrelated to the new module, which I deliberately kept self-contained so it builds and verifies on its own.

## Three-line branch audit as a standing proof obligation (2026-06-27)

The 2026-06-27 lateral analysis sharpens the Golterman-Shamir lesson from a
warning into a mandatory check. Golterman-Shamir show that propagator zeros in
lattice chiral gauge theories can behave as coupled ghost states once gauge
fields are turned on, and can contribute anomalies like poles while damaging
unitarity. So no gauge-charged branch may be removed solely by a propagator zero.

Make every proposed Gate C1 release candidate (including the matrix-valued
spinor-line Wilson lift in `AgentTasks/null-edge-gate-c-redesign-roadmap.md`
section 6.3) pass a three-line audit for each unwanted branch before any release
language is used:

```text
unwanted branch =>
  1. true inverse-propagator mass gap (not a propagator zero)?
  2. positive / physical spectral contribution?
  3. correct anomaly accounting without ghost substitution?
```

This is the prose face of the kernel-checked `index_nonzero_not_sufficient`
separation theorem above: a computed flavored index never releases Gate C on its
own. The audit maps onto the existing six-way `ZeroKind` classification (a fatal
ghost zero fails line 1 or 2; a composite-removable zero must be shown removable
by field redefinition, not assumed). It is the cheap, lattice-recognizable safety
gate to apply before spending an Aristotle job on a release attempt.
