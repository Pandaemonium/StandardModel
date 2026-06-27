You are Aristotle, the top Lean proof assistant available for this project. This is a Lean 4 / Mathlib / PhysicsSM formalization task in the null-edge Standard Model program.

Context pack: `AgentTasks/context-packs/null-edge-wave14-route-b-furey-bridge-20260626-190500.md`.

General rules:
- Work in Lean when possible; produce a kernel-checkable module if the target can be made precise.
- Do not weaken the intended theorem silently. If the intended theorem is false or underspecified, state the obstruction and formalize the sharpest useful counterexample or conditional theorem.
- Avoid hidden assumptions, fake axioms, opaque placeholders, or convention changes.
- Prefer a narrow target check over a full project build at the start. The project is large.
- Include a short `ARISTOTLE_SUMMARY.md` explaining what was proved, what remains conditional, and which conventions were used.
- If the result should remain experimental, put it under `PhysicsSM/Draft/` rather than trusted source.

Task FUR-H7: Concrete Furey `Phi_H` on live `J` and `J*` ideals.

Background:
Wave 13 added `NullEdgeFureyPhiH.lean`, an abstract off-diagonal finite Higgs/Yukawa operator interface, and `Algebra/Furey/ConjugateIdeal.lean`, a coordinate model for the conjugate/right-handed side. The next step is to connect the abstract interface to actual Furey ideal data instead of treating `L` and `R` as abstract vector spaces.

Goal:
Create a new draft module, preferably `PhysicsSM/Draft/NullEdgeFureyConcretePhiH.lean`, that realizes as much of the abstract `Phi_H` interface as possible on the live Furey `J` and conjugate-ideal/`J*` modules.

Ambitious theorem target:
- Define candidate left/right finite spaces using existing Furey modules and the new conjugate-ideal coordinate bridge.
- Construct a concrete or semi-concrete off-diagonal linear map representing `Phi_H`.
- Prove gauge/intertwiner covariance, `chi_E` oddness, and `Gamma_s` evenness when possible.
- Reuse or specialize the almost-commutative square theorem from `NullEdgeFureyAlmostCommutativeProduct.lean`.
- If a concrete construction is blocked, produce a sharply named interface theorem and report exactly which live-tree bridge is missing.

Deliverables:
- Lean module plus `ARISTOTLE_SUMMARY.md`.
- If useful, a report `AgentTasks/null-edge-fur-h7-concrete-phi-h-report.md`.
