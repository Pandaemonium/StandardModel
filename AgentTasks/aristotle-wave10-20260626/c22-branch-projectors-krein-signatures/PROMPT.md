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

# C22 branch projectors and Krein signatures

Type: Proof/Audit

Use the common Wave 10 context. This job supports C21 and should not duplicate c20 massive branch lifting.

Primary files:
- PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean
- PhysicsSM/Draft/NullEdgeFlavoredChirality.lean
- PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean, if C21-like content is present in this package or the live tree
- PhysicsSM/Draft/*Krein*.lean, if present
- docs/CONVENTIONS.md

Goal:
Gate C needs more than a scalar branch count. It needs branch projectors, chirality signs, and Krein signatures for the determinant branches. Please build the strongest finite algebra package possible around the current data.

Tasks:
1. If actual branch eigenspaces are available, define branch projectors `P_rho` and prove their basic orthogonality/idempotence/completeness properties over the branch sector.
2. Define the projector-based flavored chirality expression
   `Gamma_f = sum_rho epsilon_rho P_rho Gamma_s P_rho`, or a corrected finite analogue.
3. Connect this projector formulation to the C19 `GammaFlavOp`/index criterion.
4. Compute or axiomatize explicitly the Krein signature of each branch eigenspace, with a clear statement of what is proved versus assumed.
5. Prove any finite facts that prevent overclaiming, especially that J-self-adjointness alone does not imply spectral stability if that theorem is not already available.

Expected output:
- Prefer a new module such as `PhysicsSM/Draft/NullEdgeBranchProjectors.lean` or `PhysicsSM/Draft/NullEdgeBranchKreinSignatures.lean`.
- If the actual eigenspaces are not yet formalized, return a conditional Lean API plus a report explaining exactly what C21 must provide.
- Verdict language should be one of: RELEASED, CONDITIONAL, PENDING, or REDESIGN-REQUIRED.
