# Null-edge Aristotle Wave 10 common context

Date: 2026-06-26.

Repository: C:\Projects\StandardModel, Lean 4 / Mathlib project. Follow AGENTS.md and docs/ARISTOTLE.md. The Lean kernel is the source of truth. Do not weaken theorem statements to get a proof. If a statement is false, underspecified, or convention-mismatched, return a precise blocker and proposed corrected statement.

Wave 8 and Wave 9 status supplied by Claude/user:
- Gate A bridge exists and has now been used in `PhysicsSM/Draft/NullEdgeFiniteLichnerowiczBridge.lean`.
- The finite super-Dirac square is assembled: `D^2 = -K_null - C_diamond - T_frame + Phi^2 - i Gamma_s sum_a C_a [nabla_a, Phi]`, plus named Gate-A hypothesis and tetrad-postulate specializations.
- Scalar/gauge/Higgs null quadrature is assembled in `PhysicsSM/Draft/NullEdgeScalarGaugeNullQuadrature.lean`, including the guardrail that the naive positive edge-sum appears only in the doubly diagonal Euclidean/orthonormal case.
- Trusted Plucker Spinor files now carry convention/provenance banners and should be treated as promotion-ready, subject to normal integration review.
- `PhysicsSM/Draft/NullEdgeForbiddenCountertermCodim.lean` is useful but its own adversarial verdict says it is consistency/reconstruction, not a prediction.
- `PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean` proves Gate C is PENDING, not RELEASED. It isolates the remaining obligation as `OperatorForcesAlignment`: the actual flat tetrahedral Clifford symbol must assign the aligned chirality sign to each branch zero mode.
- The current branch files contain scalar quadratic-form data, but the actual 4x4 Clifford symbol and per-branch kernel/chirality computation are not yet formalized.
- c20 massive branch lifting is still running. Avoid duplicating c20; use its eventual result as future context.

Gate C rule:
- Do not claim Gate C is released merely from modeled taste signs.
- Release requires the signs to be forced by the actual operator/symbol data, not chosen by hand.
- If the actual symbol gives different signs, higher-dimensional kernels, extended branch loci, complex branches, or Krein-negative physical modes, report the corrected verdict honestly.

General deliverable rule:
- For proof jobs, return a Lean patch or new module plus a semantic-alignment note.
- For audit/strategy jobs, return a concise but deep report with explicit acceptance/failure criteria and next Lean targets.
- Report assumptions and allowed axioms. Avoid hidden assumptions, statement weakening, raw placeholder tokens in prose, and prediction language without a codimension/moduli argument.

---

# C21 actual Clifford symbol and branch chirality

Type: Proof/Audit

Use the common Wave 10 context. This is the central next Gate C job.

Primary files:
- PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean
- PhysicsSM/Draft/NullEdgeFlavoredChirality.lean
- PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean, if present
- PhysicsSM/Draft/TetrahedralNodalStructure.lean, if present
- PhysicsSM/Draft/TetrahedralBranchCount.lean, if present
- docs/CONVENTIONS.md
- Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md Sections 23-26

Goal:
The integrated C19 result proves Gate C is conditionally released if `OperatorForcesAlignment` holds. The missing mathematical data is the actual flat tetrahedral Clifford symbol `c(p(q))`, its kernel at each determinant branch, and the spacetime chirality/Krein sign assigned to that kernel.

Please attempt the strongest honest result you can:
1. Locate the existing branch data and scalar quadratic-form conventions.
2. Define or reuse the actual 4x4 Clifford/gamma symbol for the tetrahedral dual-soldered frame, with conventions documented.
3. For each known high-momentum determinant branch, compute the kernel or branch eigenspace of the symbol.
4. Compute the action of spacetime chirality on that kernel/eigenspace.
5. Prove `OperatorForcesAlignment` if the signs match the C19 `g5` alignment.
6. If kernel dimension, sign, or branch structure differs from the modeled C19 criterion, do not force the result. Return a corrected theorem statement and a blocker report.

Important caution:
Do not assume the branch kernel is one-dimensional unless the actual Lean linear algebra proves it. If the full Dirac symbol has a two-dimensional kernel and the one-dimensional statement only holds after a Weyl/Krein/energy projection, make that projection explicit and prove the corrected result instead.

Expected output:
- Prefer a new module such as `PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean` or `PhysicsSM/Draft/NullEdgeGateCOperatorAlignment.lean`.
- Ideal theorem names: `actualSymbol_forces_alignment`, `operatorForcesAlignment_from_cliffordSymbol`, `branchKernel_chirality_sign`, or corrected equivalents.
- If full proof is blocked by missing gamma conventions, return a precise report with the exact definitions and theorem statements that should be added next.

Do not claim Gate C is released unless the actual operator data forces the signs.
