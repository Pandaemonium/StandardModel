You are Aristotle, the top Lean proof assistant available for this project. This is a Lean 4 / Mathlib / PhysicsSM formalization task in the null-edge Standard Model program.

Context pack: `AgentTasks/context-packs/null-edge-wave14-route-b-furey-bridge-20260626-190500.md`.

General rules:
- Work in Lean when possible; produce a kernel-checkable module if the target can be made precise.
- Do not weaken the intended theorem silently. If the intended theorem is false or underspecified, state the obstruction and formalize the sharpest useful counterexample or conditional theorem.
- Avoid hidden assumptions, fake axioms, opaque placeholders, or convention changes.
- Prefer a narrow target check over a full project build at the start. The project is large.
- Include a short `ARISTOTLE_SUMMARY.md` explaining what was proved, what remains conditional, and which conventions were used.
- If the result should remain experimental, put it under `PhysicsSM/Draft/` rather than trusted source.

Task C65: Canonical physical species selector or no-go theorem.

Background:
`NullEdgeKreinPositiveReleaseCriterion.lean` uses the modeled physical sector `(0, 2)` as the Krein-positive retained pair. `NullEdgeSymmetryForcedSpeciesSplit.lean` says the 2+2 split remains a modulus under the currently formalized symmetries. The program needs to know whether the retained sector is canonical or conventional.

Goal:
Create a new draft module, preferably `PhysicsSM/Draft/NullEdgeCanonicalSpeciesSelector.lean`, that attempts to derive the physical branch selector from available structures, or proves that no such selector follows from them.

Ambitious theorem target:
- Formalize candidate selector data from branch chirality, Krein sign, orientation/taste, energy sign, and internal grading.
- Prove uniqueness/canonicity of the `(0, 2)` selector if it follows from these structures.
- Otherwise prove a no-go: there are automorphisms/symmetries preserving the currently locked data while moving the selector, so `(0, 2)` remains a choice/modulus.
- Make clear whether this affects Gate C release, Gate F prediction language, or only interpretation.

Deliverables:
- Lean module with either a canonical-selector theorem or a no-go theorem.
- Report `AgentTasks/null-edge-c65-canonical-species-selector-report.md`.
