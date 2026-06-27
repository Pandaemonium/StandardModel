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

Task K3: Derive the Krein branch lock or prove a no-go.

Background:
C65 proves the physical branch selector is canonical relative to the locked Krein-sign data. It also proves absolute canonicity fails from chirality/taste/energy/grading alone. The next question is whether the Krein-sign assignment itself can be derived from a deeper structure.

Goal:
Create `PhysicsSM/Draft/NullEdgeKreinLockOrigin.lean` if feasible.

Target theorem shape:
- Try to derive the branch Krein sign pattern from one of: retarded/advanced sheet orientation, causal orientation, preferred covector, charge conjugation/reflection structure, or the dual-soldered frame convention.
- If derivable, prove a theorem that feeds C65 by making the retained maximal Krein-positive sector less conventional.
- If not derivable from currently formalized data, prove a no-go: there exists a relabeling or model preserving the available data while flipping/moving the Krein assignment.
- State clearly whether this affects Gate C release, Gate F prediction language, or only convention/provenance.

Deliverables:
- Lean module or precise no-go report.
- Report `AgentTasks/null-edge-k3-krein-lock-origin-report.md`.
