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

Task FUR-H8A: Number-parity `chi_E` on the occupation/internal-spectrum API.

The previous broad FUR-H8 job ran out of budget. Narrow the target to the occupation model already present in `NullEdgeFureyInternalSpectrum.lean`.

Goal:
Create `PhysicsSM/Draft/NullEdgeFureyOccupationParityChiE.lean` if feasible.

Target theorem shape:
- Define occupation-number parity on the finite Furey occupation/state API used by the internal-spectrum theorem.
- Prove it is an involution/grading.
- Prove it is distinct from the complex-structure candidate ruled out by `NullEdgeFureyChiE.lean`, or prove the strongest available formal comparison.
- Prove the parity separates the intended electroweak chirality classes in the computed spectrum, if the existing API exposes enough data.
- If anti-commutation with `Phi_H` requires H7A, state that as a clean named hypothesis rather than forcing a big bridge.

Deliverables:
- Lean module plus summary.
- A short report if the occupation API is missing a necessary lemma.
