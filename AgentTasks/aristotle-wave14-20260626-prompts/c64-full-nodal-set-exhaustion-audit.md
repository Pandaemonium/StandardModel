You are Aristotle, the top Lean proof assistant available for this project. This is a Lean 4 / Mathlib / PhysicsSM formalization task in the null-edge Standard Model program.

Context pack: `AgentTasks/context-packs/null-edge-wave14-route-b-furey-bridge-20260626-190500.md`.

General rules:
- Work in Lean when possible; produce a kernel-checkable module if the target can be made precise.
- Do not weaken the intended theorem silently. If the intended theorem is false or underspecified, state the obstruction and formalize the sharpest useful counterexample or conditional theorem.
- Avoid hidden assumptions, fake axioms, opaque placeholders, or convention changes.
- Prefer a narrow target check over a full project build at the start. The project is large.
- Include a short `ARISTOTLE_SUMMARY.md` explaining what was proved, what remains conditional, and which conventions were used.
- If the result should remain experimental, put it under `PhysicsSM/Draft/` rather than trusted source.

Task C64: Full nodal-set exhaustion audit for the tetrahedral symbol plus species split.

Background:
`NullEdgeSpectralGraphNodalSet.lean` proves exact branch-line components of the determinant-zero locus. `NullEdgeSpeciesSplitNodalLine.lean` proves a split term can lift the high-momentum nodal line away from the origin. The open question is whether the certified components exhaust the zero locus, or whether additional curves/sheets remain.

Goal:
Create a new draft module, preferably `PhysicsSM/Draft/NullEdgeNodalSetExhaustion.lean`, that classifies as much of the full determinant-zero locus as possible for the tetrahedral bare/split symbol.

Ambitious theorem target:
- State a precise finite-dimensional nodal-set classification for the existing q-form/symbol conventions.
- Prove exhaustion if true: every determinant zero lies on the known origin component or one of the certified branch-line components, after the appropriate split assumptions.
- If exhaustion is false or too strong, construct a concrete additional component or a named obstruction theorem showing what remains unclassified.
- Preserve the distinction between scalar q-form zero, full Clifford-symbol determinant zero, and projected physical-sector zero.

Deliverables:
- Lean module with the strongest honest theorem/counterexample.
- Report `AgentTasks/null-edge-c64-nodal-set-exhaustion-report.md` explaining the impact on Gate C release.
