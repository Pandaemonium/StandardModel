# Aristotle job C267: abstract branch Wilson symbol Lean target

This is a non-blocking Lean/proof-design job for the PhysicsSM null-edge Gate C1 program. Codex is continuing local finite/free scalar `Kfree/Hfree` assembly, so do not work on that path.

Context:
- C262 showed scalar Wilson gives the uniform inverse-symbol gap but cannot give target spectral island or nonzero origin chiral index.
- C264 identified the algebraic cross-term obstruction for matrix-valued `W_branch`: `(-iQ + W)(iQ + W) = Q^2 + W^2 + i(WQ - QW)`.
- We need an abstract `TetraBranchWilsonSymbol.lean` layer that generalizes `TetraScalarWilsonSymbol.K_star_mul` without pretending the result is scalar-valued.

Please produce a report named `GateC1_BranchWilsonSymbol_LeanReport.md`.

If feasible, also produce a Lean draft `PhysicsSM/Draft/NullEdge/GateC1/TetraBranchWilsonSymbol.lean` with no open placeholders. Keep it finite-dimensional and abstract.

Requested target:
1. Define an abstract branch mass interface `BranchMassData` or similar, with `W : (Fin 4 -> Real) -> Matrix Branch Branch Complex` or a tensor-factor-friendly equivalent.
2. State/prove the matrix square identity under explicit Hermitian plus commutation hypotheses.
3. State/prove a quadratic-form/l2 norm decomposition replacing scalar `K_star_mul`.
4. State a form-gap theorem parameterized by a lower-bound certificate on `qExact I + W^2`.
5. Keep the claim boundary explicit: this is not branch retention until a spectral island and nonzero index are supplied.

Avoid raw placeholder tokens in prose. If a proof is too hard, give exact theorem statements and a proof plan instead of weakening the statement.
