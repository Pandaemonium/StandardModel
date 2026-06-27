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

Task FUR-H7A: Narrow concrete `Phi_H` coordinate bridge.

The previous broad FUR-H7 job ran out of budget. Narrow the target sharply.

Goal:
Create `PhysicsSM/Draft/NullEdgeFureyPhiHCoordinateBridge.lean` if feasible. Bridge the abstract `Phi_H` interface in `NullEdgeFureyPhiH.lean` to the coordinate occupation/internal-spectrum model used by `NullEdgeFureyInternalSpectrum.lean` and `Algebra/Furey/ConjugateIdeal.lean`.

Target theorem shape:
- Define a small coordinate left/right finite-state model sufficient to instantiate the abstract `Phi_H` off-diagonal interface.
- Prove the map is off-diagonal, `chi_E`-odd, and `Gamma_s`-even in the abstract sense already used by `NullEdgeFureyPhiH`.
- If full gauge covariance is too expensive, state a named covariance hypothesis and prove the conditional bridge theorem.
- Do not try to solve the live octonion/Jbar bridge here. This job is coordinate-level only.

Deliverables:
- Lean module plus summary.
- A short report `AgentTasks/null-edge-fur-h7a-phi-h-coordinate-bridge-report.md` if there are caveats.
