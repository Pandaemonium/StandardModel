You are Aristotle, the top Lean proof assistant available for this project. This is a Lean 4 / Mathlib / PhysicsSM formalization task in the null-edge Standard Model program.

Context pack: `AgentTasks/context-packs/null-edge-wave14-route-b-furey-bridge-20260626-190500.md`.

General rules:
- Work in Lean when possible; produce a kernel-checkable module if the target can be made precise.
- Do not weaken the intended theorem silently. If the intended theorem is false or underspecified, state the obstruction and formalize the sharpest useful counterexample or conditional theorem.
- Avoid hidden assumptions, fake axioms, opaque placeholders, or convention changes.
- Prefer a narrow target check over a full project build at the start. The project is large.
- Include a short `ARISTOTLE_SUMMARY.md` explaining what was proved, what remains conditional, and which conventions were used.
- If the result should remain experimental, put it under `PhysicsSM/Draft/` rather than trusted source.

Task C63: Post-gauge ghost-safety and residue theorem for Route-B Gate C.

Background:
Wave 10/11 split Gate C into precise pieces. The bare symbol cannot release the gate: `NullEdgeActualCliffordSymbol.lean` proves each null branch kernel is chirality-balanced. Route B now uses projection/splitting. The integrated files `NullEdgeProjectedBranchChirality.lean`, `NullEdgeGaugeCovariantBranchProjectors.lean`, `NullEdgeCompositeZeroEscape.lean`, `NullEdgeGateCGhostZeroSafety.lean`, and `NullEdgeKreinPositiveReleaseCriterion.lean` give the ingredients.

Goal:
Create a new draft module, preferably `PhysicsSM/Draft/NullEdgeProjectedGhostSafety.lean`, that tries to instantiate the ghost-safety/residue clause for the projected, link-dressed Route-B physical sector.

Ambitious theorem target:
- Define a projected physical-sector zero datum compatible with the existing branch projector, species split, and gauge-covariant projector API.
- Prove that the retained projected modes are not Golterman-Shamir-style fatal ghost zeros under the strongest assumptions already formalized.
- If an unconditional theorem is too strong, prove the exact conditional theorem and isolate the remaining assumptions as named structures/propositions.
- If the theorem is false, formalize the counterexample showing that projected chirality plus flavored index plus gauge covariance still fails ghost safety.

Deliverables:
- A Lean module with useful definitions/theorems and no hidden assumptions.
- A report `AgentTasks/null-edge-c63-post-gauge-ghost-safety-report.md` explaining whether Gate C is still blocked by residue/ghost safety.
