You are Aristotle, the top Lean proof assistant available for this project. This is a Lean 4 / Mathlib / PhysicsSM formalization task in the null-edge Standard Model program.

Use the current repo files included in the submission package. Relevant recently integrated files include:
- `PhysicsSM/Draft/NullEdgeCanonicalSpeciesSelector.lean`
- `PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean`
- `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean`
- `PhysicsSM/Draft/NullEdgeFureyChiE.lean`
- `PhysicsSM/Draft/NullEdgeFureyPhiH.lean`
- `PhysicsSM/Draft/NullEdgeFureyAlmostCommutativeProduct.lean`
- `PhysicsSM/Algebra/Furey/ConjugateIdeal.lean`
- `PhysicsSM/Algebra/Furey/JbarCoordinateEquiv.lean`

General rules:
- Work in Lean when possible; produce a kernel-checkable module if the target can be made precise.
- Do not weaken the intended theorem silently. If the theorem is false or underspecified, state the obstruction and formalize the sharpest useful counterexample or conditional theorem.
- Do not introduce fake assumptions, fake axioms, opaque placeholders, hidden convention changes, or escape hatches.
- Prefer a narrow target check over a full project build at the start. The project is large.
- Include a short `ARISTOTLE_SUMMARY.md` explaining what was proved, what remains conditional, and which conventions were used.
- If the result should remain experimental, put it under `PhysicsSM/Draft/` rather than trusted source.

Task FUR-H9A: Minimal bridge from `ConjugateIdeal` to live `Jbar` coordinates.

The previous broad FUR-H9 job ran out of budget. Narrow the target to one compatibility bridge.

Goal:
Create `PhysicsSM/Draft/NullEdgeFureyJbarCoordinateBridge.lean` if feasible.

Target theorem shape:
- Use `PhysicsSM/Algebra/Furey/ConjugateIdeal.lean` and `PhysicsSM/Algebra/Furey/JbarCoordinateEquiv.lean`.
- Identify a minimal finite coordinate map/equivalence between the conjugate-ideal coordinate model and the existing `Jbar` coordinate/eigenvalue machinery.
- Prove one useful compatibility theorem: charges, basis labels, or action-table entries agree under the bridge.
- Record conventions explicitly: XOR octonion basis, Fano orientation, Furey/Jbar relabeling, and conjugation convention.
- If the live APIs are not yet compatible, prove a sharply named partial bridge and list exactly which lemma is missing.

Deliverables:
- Lean module plus summary.
- Report `AgentTasks/null-edge-fur-h9a-jbar-coordinate-bridge-report.md` if useful.
