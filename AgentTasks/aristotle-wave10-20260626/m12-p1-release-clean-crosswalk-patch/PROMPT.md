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

# M12 P1 release-clean crosswalk patch

Type: Manuscript/Audit

Use the common Wave 10 context.

Primary files:
- Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md
- Sources/Null_Edge_Causal_Graph_Publication_Plan.md
- Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md
- AgentTasks/null-edge-p1-p15-release-crosswalk-after-wave8.md, if present
- AgentTasks/null-edge-plucker-trusted-promotion-audit.md, if present

Goal:
Wave 9 reports recommend manuscript/crosswalk corrections: downgrade absent twistor rows that are over-marked trusted, and upgrade the now-bannered trusted SL(2,C) covariance row. These edits were deliberately not auto-applied because they touch manuscript text. Please prepare a precise release-clean patch plan.

Tasks:
1. Identify every P1/P1.5 row or sentence that overclaims trusted Lean status for absent twistor modules.
2. Identify every row that should be upgraded because Plucker obstruction/covariance now have convention banners.
3. Produce exact replacement text or a unified diff-style patch proposal, but do not require applying it.
4. State whether P1 is release-clean after these corrections or whether any other claim-status mismatch remains.
5. Keep the claim labels strict: trusted, draft, reported, absent, conceptual, or future.

Expected output:
- A report `null-edge-m12-p1-release-clean-crosswalk-patch.md`.
- Optional exact patch text for a human/Codex integration pass.
