You are Aristotle, the top Lean proof assistant available for this project. This is a Lean 4 / Mathlib / PhysicsSM formalization task in the null-edge Standard Model program.

Context pack: `AgentTasks/context-packs/null-edge-wave14-route-b-furey-bridge-20260626-190500.md`.

General rules:
- Work in Lean when possible; produce a kernel-checkable module if the target can be made precise.
- Do not weaken the intended theorem silently. If the intended theorem is false or underspecified, state the obstruction and formalize the sharpest useful counterexample or conditional theorem.
- Avoid hidden assumptions, fake axioms, opaque placeholders, or convention changes.
- Prefer a narrow target check over a full project build at the start. The project is large.
- Include a short `ARISTOTLE_SUMMARY.md` explaining what was proved, what remains conditional, and which conventions were used.
- If the result should remain experimental, put it under `PhysicsSM/Draft/` rather than trusted source.

Task FUR-H9: Bridge coordinate conjugate ideal to the live octonion/Jbar machinery.

Background:
`Algebra/Furey/ConjugateIdeal.lean` gives a coordinate model for the right-handed/conjugate ideal side. Existing trusted Furey files include live `Jbar`/electroweak/action-table structures. The remaining gap is to connect the coordinate model to live octonion/Furey declarations without convention drift.

Goal:
Create a new module, preferably draft first as `PhysicsSM/Draft/NullEdgeFureyConjugateIdealBridge.lean`, that builds an explicit bridge between the coordinate conjugate-ideal model and the existing `Jbar`/octonion Furey machinery.

Ambitious theorem target:
- Identify the exact live structures corresponding to the coordinate conjugate ideal.
- Prove a linear equivalence or coordinate/action-table compatibility theorem.
- Verify charge/electroweak action consistency across the bridge.
- Record convention choices: octonion XOR basis, Fano orientation, Furey relabeling/sign issues, and complex conjugation convention.
- If a full bridge is not currently possible, prove the strongest partial bridge and name the missing convention/API lemmas.

Deliverables:
- Draft Lean module plus summary.
- If a trusted move is possible and convention-clean, say so explicitly, but default to draft until reviewed.
