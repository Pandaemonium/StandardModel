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

# E12 FMS finite composite theorem target

Type: Proof/Audit

Use the common Wave 10 context.

Primary files:
- PhysicsSM/Draft/NullEdgeScalarGaugeNullQuadrature.lean
- PhysicsSM/Draft/NullEdgeElectroweakStabilizer.lean, if present
- PhysicsSM/Draft/NullEdgeAbelianHiggsLink.lean, if present
- Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md Sections 25-26

Goal:
The documents now require electroweak/W/Z language to be FMS-compatible at theorem level, not just in prose. Please identify or build the cleanest finite gauge-invariant link composite and the first expansion theorem.

Tasks:
1. Formalize or specify a finite gauge-invariant Higgs-link functional
   `S_H = sum_e |U_e H_t(e) - H_s(e)|^2`.
2. Prove or state the orbit-stiffness theorem: stabilizer holonomies have zero quadratic cost and non-stabilizer directions acquire positive quadratic cost.
3. Identify a corrected finite FMS composite observable, for example a variant of
   `O_e^a = H_s(e)^dagger tau^a U_e H_t(e)`.
4. Prove, if feasible, a toy finite theorem that its vacuum/trivialization expansion has the usual W/Z field component as leading term.
5. Separate coefficient normalization theorems (`m_W`, `m_Z`) from structural rank/orbit-stiffness theorems.

Expected output:
- Prefer a Lean module if a finite algebra theorem is feasible, such as `PhysicsSM/Draft/NullEdgeFMSFiniteComposite.lean`.
- Otherwise return a precise report with theorem statements and blocked dependencies.
- Do not use literal local gauge-symmetry breaking language. Use gauge-invariant composite/stabilizer/orbit-stiffness language.
