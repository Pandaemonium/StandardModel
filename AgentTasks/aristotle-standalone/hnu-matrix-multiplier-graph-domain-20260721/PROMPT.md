# Proof job: Hermitian matrix-valued L2 multiplier on its maximal graph domain

Work in Lean 4.28 with Mathlib. Design and prove the strongest reusable theorem
that a finite-dimensional, measurable, pointwise Hermitian matrix-valued
multiplier on vector-valued `L2` is self-adjoint on its maximal graph domain.

The intended application is the `4 x 4` massive Dirac symbol

```text
H(q) = kinetic4(q) + mass4(z),
H(q)^* = H(q),
H(q)^2 = (|q|^2 + |z|^2) I.
```

Required mathematical target:

1. Define a representative-safe `LinearPMap` on
   `Lp (Fin d -> Complex) 2 mu` whose domain is exactly the states for which
   `q |-> H(q) f(q)` is square-integrable.
2. Prove the domain is dense, preferably by measurable norm truncation.
3. Identify the adjoint as multiplication by `H(q)^*`.
4. Conclude self-adjointness when `H(q)` is Hermitian almost everywhere.
5. If the full generic matrix theorem is too large, prove the complete theorem
   for the displayed Dirac-square class using the explicit resolvents
   `(H(q) +/- i I) / (|q|^2 + |z|^2 + 1)`. Do not weaken to bounded support;
   that dense-core derivative is already proved locally.

Useful Mathlib API: `LinearPMap.adjoint`, `LinearPMap.IsFormalAdjoint`,
`LinearPMap.mem_adjoint_domain_of_exists`, `LinearPMap.adjoint_apply_eq`,
`LinearPMap.isSelfAdjoint_def`, and `IsSelfAdjoint.isClosed`.

Clean-room reference only: PhysLean commit
`ea3c9dd60268886f05c07469b74b38321b975a28`, module
`Physlib.QuantumMechanics.DDimensions.Operators.Multiplication`, declarations
`term𝓜`, `mulOperator_hasDenseDomain`, `mulOperator_adjoint_domain_le`,
`mulOperator_adjoint_eq_conj`, and `mulOperator_isSelfAdjoint_ofReal`. It proves
the scalar version by truncation and direct adjoint-domain comparison. Do not
import PhysLean or copy its implementation text.

Return a self-contained Mathlib-only Lean project with all theorem statements
and proofs. If a quotient/API obstruction prevents completion, return the
largest typechecked theorem, the exact remaining goal, and a precise proposed
local API. No new assumptions disguised as declarations, compiler-trusted
finite evaluation, or statement weakening.

Semantic context:
`AgentTasks/context-packs/hnu-matrix-multiplier-graph-domain-20260721-20260721-002759.md`.
