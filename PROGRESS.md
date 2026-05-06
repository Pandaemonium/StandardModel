# Progress

Last updated: 2026-04-30

This file records the project's highest-value achievements. It is intentionally
small: detailed task history belongs in `EXECUTION_PLAN.md`, `OPEN_QUESTIONS.md`,
and `AgentTasks/`.

## 1. Trusted Octonion Algebra Core

The project now has a kernel-checked real octonion model in the project XOR
basis. The trusted core includes explicit multiplication, conjugation, the
squared norm `normSq`, norm multiplicativity, left and right alternativity,
all three Moufang identities, and flexibility.

This is the foundation for later work on composition algebras, G2, Spin(8)
triality, exceptional Lie theory, and division-algebraic Standard Model
constructions.

## 2. Triality-Conjugation Criterion

`PhysicsSM.Algebra.Octonion.TrialityCompanions` proves a Conway-Smith/Yokota-
style criterion: for a unit octonion `a`, the explicitly parenthesized map
`conjBy a x = (a * x) * conj a` preserves multiplication if and only if the
fixed parenthesized cube `cube a = (a * a) * a` is `1` or `-1`. The same module
also proves the corresponding order-three iteration theorem and records
unbundled automorphism data for the cube `1` and cube `-1` cases.

The companion-map identities remain open, but the main multiplication criterion
is now a trusted foothold for the Baez/Yokota/Conway-Smith triality question.

## 3. Furey-Style Minimal Left Ideal Computations

The complexified-octonion and Furey layers now include trusted ladder
operators, their daggers, nilpotency statements, and all 27 Cl(6)
anticommutation relations. The primitive idempotent `omega`, the 8-state
minimal left ideal basis, the full action table, number-operator eigenvalues,
electric-charge arithmetic, nonzero witnesses, and linear independence of the
8-state basis are kernel-checked.

This gives the project a concrete, verified algebraic representation space for
future Standard Model convention work.

## 4. Operator Representation on the Minimal Ideal

The J-restricted operator layer is kernel-checked: left-multiplication
operators act on the 8-state minimal left ideal, the operator-level Cl(6)
anticommutation behavior is formalized on J, and the corrected electric-charge
operator `Q_op` is available.

This also clarified an important convention point: the current number-operator
charge is electric charge, not weak hypercharge. Hypercharge work must pass
through an explicit weak-isospin convention.

## 5. Exceptional-Structure Scaffolding

The project has initial trusted scaffolding for exceptional structures:
D4 Cartan data, an order-three outer cycle preserving the D4 Cartan matrix,
an explicit E8 Cartan matrix with determinant one, and octonion symmetry
primitives such as the dot product, imaginary subspace, commutator, named
associator, and derivation predicate.

The project also has finite Fano-plane/Hamming-code skeleton lemmas in the
octonion XOR basis. These results are smaller than the octonion and Furey
cores, but they are the right hooks for later G2, Spin(8), SO(8), E8, and
Construction A work.

## 6. Conventions and Verification Infrastructure

The Lean toolchain is pinned to `v4.28.0`, text hygiene is enforced by
pre-commit, and the project keeps convention choices explicit. The octonion
XOR basis and Fano orientation are locked, with source notes and oracle
validation used as guardrails rather than trusted proofs.

The repository is set up to prefer small, provenance-rich, kernel-checked
formalizations over broad speculative code.
