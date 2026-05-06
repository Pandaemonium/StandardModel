# Task: G2 Cartan Matrix Basics

**Agent**: Aristotle
**Status**: Submitted
**Priority**: Medium-high
**Job ID**: `1c2f1dcd-efa0-49b1-8bb8-bdcb38f738a6`
**Output**: `AgentTasks/aristotle-output/g2-cartan-basics`

## Goal

Add a small trusted G2 Cartan-matrix foothold to:

```text
PhysicsSM/Lie/Exceptional/G2.lean
```

This should be independent of octonion automorphisms and Construction A work.
The purpose is to give the project a kernel-checked rank-2 exceptional root-data
anchor before attempting `Der(O) = g2` or `G2 = Aut(O)`.

## Mathematical target

Use the standard G2 Cartan matrix in the simple-root order where the long root
is first:

```text
[[ 2, -1],
 [ -3, 2]]
```

This convention has determinant `1` and symmetrizer `diag(3, 1)`, since

```text
diag(3, 1) * [[2, -1], [-3, 2]] = [[6, -3], [-3, 2]]
```

is symmetric.

## Suggested Lean declarations

Add imports only as needed. Prefer small imports over importing all of Mathlib.

```lean
/--
The G2 Cartan matrix in the convention where the first simple root is long
and the second simple root is short.

Convention: rows and columns are ordered `(long, short)`, so the off-diagonal
entries are `a_12 = -1` and `a_21 = -3`.
Source: Bourbaki / Humphreys standard G2 Cartan matrix.
-/
def g2CartanMatrix : Matrix (Fin 2) (Fin 2) Int := ...

theorem g2CartanMatrix_eq_explicit :
    g2CartanMatrix = !![(2 : Int), -1; -3, 2] := by ...

theorem g2CartanMatrix_det_eq_one :
    g2CartanMatrix.det = 1 := by ...

theorem g2CartanMatrix_diagonal_entries :
    (forall i : Fin 2, g2CartanMatrix i i = 2) := by ...

theorem g2CartanMatrix_offDiagonal_entries :
    g2CartanMatrix 0 1 = -1 /\ g2CartanMatrix 1 0 = -3 := by ...

def g2CartanSymmetrizer : Matrix (Fin 2) (Fin 2) Int := ...

theorem g2CartanSymmetrizer_mul_cartan_eq_explicit :
    g2CartanSymmetrizer * g2CartanMatrix =
      !![(6 : Int), -3; -3, 2] := by ...

theorem g2CartanSymmetrizer_mul_cartan_symmetric :
    (g2CartanSymmetrizer * g2CartanMatrix).transpose =
      g2CartanSymmetrizer * g2CartanMatrix := by ...
```

If the exact theorem names need minor adjustment for Lean syntax, use
descriptive names and keep comments verbose.

## Constraints

- Do not modify files outside `PhysicsSM/Lie/Exceptional/G2.lean`.
- Do not introduce `sorry`, `admit`, `axiom`, `opaque`, or `unsafe def`.
- Do not claim a full G2 root system, Weyl group, or automorphism theorem.
- Run:

```bash
lake env lean PhysicsSM/Lie/Exceptional/G2.lean
```

## Expected result

A small trusted G2 file with explicit Cartan data and determinant/symmetrizer
facts, ready for later root-system and octonion-derivation work.
