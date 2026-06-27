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

# F15 genuine prediction candidate ledger

Type: Prediction/Strategy

Use the common Wave 10 context.

Primary files:
- PhysicsSM/Draft/NullEdgeForbiddenCountertermCodim.lean
- PhysicsSM/Draft/NullEdgeInternalSpectrum.lean
- PhysicsSM/Draft/NullEdgeFiniteLichnerowiczBridge.lean
- PhysicsSM/Draft/NullEdgeGateCReleaseCriterion.lean
- Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md Sections 20-26
- AgentTasks/null-edge-aristotle-ambitious-job-backlog-2026-06-26.md

Goal:
f14's adversarial verdict is important: the forbidden diagonal counterterm codimension theorem is consistency/reconstruction, not a prediction, because the codimension is built into the posited internal oddness. Please search for the next genuinely plausible structural prediction/codimension targets.

Tasks:
1. Build a moduli ledger for the finite P2 architecture: graph family, null/tetrad frame, inverse Gram/Hodge star, edge weights, branch counterterms, gauge representations, `Phi_H`, Higgs potential/self-loop terms, spectral function, cutoff, and allowed irrelevant operators.
2. Identify which current theorems are reconstruction, which are consistency, and which could become predictions only with extra hypotheses.
3. Rank plausible first prediction targets: forbidden operator, restricted Yukawa texture/rank, anomaly-selected representation, chirality/flavor count, generation constraint, protected absence of a Pauli term, branch-structure constraint, or spectral-action relation.
4. For the top three candidates, propose exact Lean theorem statements or audit jobs.
5. Be adversarial: if all current targets are full-rank reparametrizations, say so.

Expected output:
- A report `null-edge-f15-genuine-prediction-candidate-ledger.md`.
- No prediction language unless a rank/codimension mechanism is explicitly identified.
