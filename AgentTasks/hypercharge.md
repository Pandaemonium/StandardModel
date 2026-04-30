# Task: Furey Operator Charge Review

## Original Request

Formalize the linear representation of the Standard Model gauge operators on
the minimal left ideal `J`.

Requested targets included:

1. Define `J : Submodule Complex ComplexOctonion` as the span of the eight
   verified basis states `{omega, v1, v2, v3, v4, v5, v6, nu}`.
2. Use `basis_linear_independent` to define a formal basis of `J`.
3. Define left-multiplication operators as linear maps.
4. Prove the Clifford relations as operator compositions on `J`.
5. Define color-changing operators as operator compositions.
6. Prove color transition rules from the action table.
7. Define the number operators as operator compositions.
8. Prove the basis-state charge eigenvalues.

## Semantic Correction

The original task used the word "hypercharge" for the operator
`(-1/3) * (N1 + N2 + N3)`.  The eigenvalues requested for that operator were
`-1`, `-2/3`, `-1/3`, and `0`, which match the electric-charge values already
documented in `MinimalLeftIdeal.lean`, not conventional weak hypercharge.

The integrated Lean code therefore uses the name `Q_op`.

## Integrated Result

Integrated from Aristotle jobs:

- `0bcaa9b0-9a92-48e0-a3a3-30969e8742aa`
- `38b00d57-1e6d-4ace-aefc-d4e147739b4a`

Main file:

- `PhysicsSM/Algebra/Furey/OperatorRepresentations.lean`

The conventional weak-hypercharge formalization remains a separate future
task, because it requires an explicit convention for weak isospin and for how
the Furey ideal states are being identified with left-handed versus conjugate
Standard Model fields.
