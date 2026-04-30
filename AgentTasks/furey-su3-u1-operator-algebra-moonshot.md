# Task: Furey SU(3) x U(1) Operator Algebra Moonshot

**Agent**: Aristotle
**Status**: Submitted
**Priority**: MOONSHOT
**Job ID**: `bb0868bf-5312-4437-bc55-7c65e015ba17`
**Submitted**: 2026-04-29
**Type**: definition / proof / representation theory

## Goal

Build the next layer above
`PhysicsSM/Algebra/Furey/OperatorRepresentations.lean`: prove that the
operator-level color maps and charge map form the expected finite-dimensional
representation on the eight-state space `J`.

This is intentionally ambitious.  The best outcome is a kernel-checked bridge
from the Furey action table to concrete Lie-algebra-style operator identities:
color transitions, matrix-unit commutators, charge conservation, and invariant
subspaces.

## Current Trusted Inputs

Use the declarations in:

- `PhysicsSM.Algebra.Furey.MinimalLeftIdeal`
- `PhysicsSM.Algebra.Furey.OperatorRepresentations`

Important existing declarations include:

- states: `omega`, `v1`, `v2`, `v3`, `v4`, `v5`, `v6`, `nu`
- span and basis: `basisState`, `J`, `J_basis`
- left multiplication: `Lmul`
- Clifford-on-`J` theorems: `clifford_diag_1`, `clifford_diag_2`,
  `clifford_diag_3`, `clifford_off_12`, `clifford_off_21`,
  `clifford_off_13`, `clifford_off_31`, `clifford_off_23`,
  `clifford_off_32`
- color maps: `T12_op`, `T21_op`, `T13_op`, `T31_op`, `T23_op`, `T32_op`
- number and charge maps: `N1_op`, `N2_op`, `N3_op`, `Ntot_op`, `Q_op`

## Critical Convention Warning

Do not use pre-multiplied octonion products to define gauge actions.

Correct:

```lean
(Lmul alpha1).comp (Lmul alpha2_dag)
```

Incorrect:

```lean
Lmul (alpha1 * alpha2_dag)
```

The algebra is non-associative.  The first expression means
`x |-> alpha1 * (alpha2_dag * x)`, while the second means
`x |-> (alpha1 * alpha2_dag) * x`.

## Requested File

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Furey/OperatorAlgebra.lean
```

It should import:

```lean
import PhysicsSM.Algebra.Furey.OperatorRepresentations
```

Use verbose comments.  If a proof becomes too difficult, leave the theorem in a
draft section with a clear handoff note rather than weakening the statement.

## Phase 1: Complete Color Transition Tables

The current file proves a useful subset of transitions.  Complete the action
tables for the six off-diagonal color operators on all eight basis states.

Targets:

- all `Tij_op omega = 0`
- all `Tij_op nu = 0`
- anti-up triplet transitions among `v1`, `v2`, `v3`
- anti-down triplet transitions among `v4`, `v5`, `v6`, with signs checked
  against the existing `act_` table

Use names such as:

```lean
theorem T12_op_v2 : T12_op v2 = v1 := ...
theorem T12_op_v5 : T12_op v5 = ?target := ...
```

If a sign differs from the naive color-label expectation, keep the Lean result
and explain the sign in a comment.  Do not silently adjust conventions.

## Phase 2: Matrix Units on `J`

Define the restriction/equality-on-`J` notion for linear maps:

```lean
def EqOnJ (A B : ComplexOctonion ->L[Complex] ComplexOctonion) : Prop :=
  forall x : ComplexOctonion, x in J -> A x = B x
```

Use the actual Lean notation for linear maps and membership.

Then prove that the color operators behave like matrix units on the two color
triplets and vanish on color singlets.  Useful examples:

- `EqOnJ ((T12_op.comp T21_op) - relevant_diagonal_projection) ...`
- `EqOnJ (T12_op.comp T23_op) T13_op` if the action table confirms the
  composition order and signs.
- `EqOnJ (T21_op.comp T12_op) ...`

Prefer a clean finite-basis proof strategy:

1. prove equality on each `basisState i`;
2. extend by linearity across `J`.

If defining projections is too much, first prove named composition theorems on
each basis vector.

## Phase 3: SU(3)-Style Commutators

Define the commutator of linear endomorphisms:

```lean
def opComm (A B : ComplexOctonion ->L[Complex] ComplexOctonion) :=
  A.comp B - B.comp A
```

Use the actual Lean notation for linear maps.

Define diagonal color operators from number operators:

```lean
def H12_op := N1_op - N2_op
def H23_op := N2_op - N3_op
def H13_op := N1_op - N3_op
```

Prove as many Chevalley/matrix-unit-style identities on `J` as possible:

- `[T12, T21] = H12`
- `[T23, T32] = H23`
- `[T13, T31] = H13`
- `[T12, T23] = T13` or the sign-corrected version
- `[T21, T32] = T31` or the sign-corrected version
- diagonal actions such as `[H12, T12] = c * T12` on `J`

All statements must be explicitly `EqOnJ`, not global operator equalities,
unless the global statement actually checks.

## Phase 4: Charge Conservation

Prove that color operators commute with electric charge on `J`:

```lean
EqOnJ (opComm Q_op T12_op) 0
EqOnJ (opComm Q_op T21_op) 0
...
```

This should be true because color transitions preserve the `Q_op` eigenvalue
within the anti-up and anti-down triplets and annihilate singlets.

## Phase 5: Invariant Subspaces

Define submodules for the visible sectors:

- `J_singlet_low = span {omega}`
- `J_up_color = span {v1, v2, v3}`
- `J_down_color = span {v4, v5, v6}`
- `J_singlet_high = span {nu}`

Prove preservation or annihilation facts for the color operators:

- color maps preserve `J_up_color`
- color maps preserve `J_down_color`
- color maps annihilate the singlet lines, or at least map them to zero
- `Q_op` acts by scalar multiplication on each sector

## Verification Requirements

Run at least:

```bash
lake env lean PhysicsSM/Algebra/Furey/OperatorAlgebra.lean
lake env lean PhysicsSM/Algebra/Furey/OperatorRepresentations.lean
```

If full `lake build` fails on Windows at ProofWidgets, report that explicitly
and include the targeted checks.

No `sorry`, `admit`, `axiom`, or `unsafe def` in trusted code.  If a theorem is
too hard, put it in a clearly marked draft block or leave a handoff note in the
task output rather than inserting it into trusted source.

## Success Criteria

Minimum useful success:

- a new module `OperatorAlgebra.lean` with `EqOnJ`, `opComm`, diagonal
  operators, and several checked commutator/charge-conservation theorems.

Excellent success:

- full color transition tables;
- `Q_op` commutes with all six color maps on `J`;
- the main SU(3)-style commutator identities are proved on `J`;
- invariant triplet/singlet subspaces are defined and proved stable.

Moonshot success:

- package the action of the color operators on `J_basis` as concrete `8 x 8`
  matrices and prove that the nonzero blocks are the expected triplet matrix
  units, with charge diagonalized by `Q_op`.
