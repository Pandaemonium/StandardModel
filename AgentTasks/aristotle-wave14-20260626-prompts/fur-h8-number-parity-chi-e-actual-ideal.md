You are Aristotle, the top Lean proof assistant available for this project. This is a Lean 4 / Mathlib / PhysicsSM formalization task in the null-edge Standard Model program.

Context pack: `AgentTasks/context-packs/null-edge-wave14-route-b-furey-bridge-20260626-190500.md`.

General rules:
- Work in Lean when possible; produce a kernel-checkable module if the target can be made precise.
- Do not weaken the intended theorem silently. If the intended theorem is false or underspecified, state the obstruction and formalize the sharpest useful counterexample or conditional theorem.
- Avoid hidden assumptions, fake axioms, opaque placeholders, or convention changes.
- Prefer a narrow target check over a full project build at the start. The project is large.
- Include a short `ARISTOTLE_SUMMARY.md` explaining what was proved, what remains conditional, and which conventions were used.
- If the result should remain experimental, put it under `PhysicsSM/Draft/` rather than trusted source.

Task FUR-H8: Number-parity `chi_E` on the actual Furey ideal.

Background:
`NullEdgeFureyChiE.lean` shows that the Krasnov/Furey complex structure should not be identified with electroweak chirality. The useful candidate is occupation-number parity. The program now needs this grading on the actual Furey ideal, not just as an abstract warning.

Goal:
Create a new draft module, preferably `PhysicsSM/Draft/NullEdgeFureyNumberParityChiE.lean`, defining and proving the number-parity grading properties on the actual Furey model.

Ambitious theorem target:
- Define the occupation-number parity operator on the available Furey basis/model.
- Prove it is an involution with the expected even/odd eigenspace behavior.
- Compare it to the charge/internal spectrum from `NullEdgeFureyInternalSpectrum.lean`.
- Prove anti-commutation with the concrete or abstract `Phi_H` where available, or state the minimal hypothesis needed.
- Prove it is distinct from the complex structure in the precise sense required by H2.

Deliverables:
- Lean module and summary.
- A short report if the actual Furey model lacks enough occupation-number API and needs a bridge lemma first.
