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

# D18 Gate D0 positive DEC/Hodge-Dirac proxy plan

Type: Strategy/Proof-scoping

Use the common Wave 10 context.

Primary files:
- PhysicsSM/Draft/NullEdgeFiniteLichnerowiczBridge.lean
- PhysicsSM/Draft/NullEdgeScalarGaugeNullQuadrature.lean
- Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md Sections 24-26
- Sources/NullStrand_Lean_Roadmap_Improved.md Gate D addenda

Goal:
Gate D should not jump directly to a Lorentzian retarded/Krein continuum theorem. It now has an explicit preliminary gate: D0, a positive DEC/Hodge-Dirac proxy.

Please produce a concrete theorem roadmap and, if feasible, small Lean scaffold declarations for D0.

Questions to answer:
1. What is the cleanest positive-metric proxy operator corresponding to the finite null-edge square already proved?
2. Which parts of the b17 finite square and d17 null quadrature can be reused without Lorentzian/Krein assumptions?
3. What minimal Hilbert/inner-product/Hodge-star hypotheses are needed for a DEC/Hodge-Dirac convergence statement?
4. What should the first formal theorem be: local commutator `[D_h,M_f] = c(df)+O(h)`, scalar inverse-Gram quadrature, a connection-Laplacian proxy, or an abstract finite-to-continuum API?
5. Which hypotheses are strictly positive-proxy assumptions and must not be smuggled into the Lorentzian theorem?

Expected output:
- A report `null-edge-d18-d0-positive-dec-proxy-plan.md`.
- Optional Lean scaffold module `PhysicsSM/Draft/NullEdgeD0PositiveProxy.lean` with definitions/theorem statements only if useful.
- A dependency list for the eventual Gate D theorem sequence.

Do not claim a full continuum result. The target is a precise D0 proof contract.
