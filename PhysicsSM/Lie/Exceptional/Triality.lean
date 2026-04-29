import Mathlib.Data.Fin.Basic
import Mathlib.Data.Fintype.Fin
import Mathlib.Tactic.FinCases

/-!
# Lie.Exceptional.Triality

D4 Cartan-matrix triality.

This module records the first small, trusted formal foothold for the exceptional
triality story relating D4, so(8), Spin(8), octonions, G2, and eventually E8.
The point of this file is deliberately modest: it proves a finite symmetry of
the D4 Cartan matrix, not the full group-level Spin(8) triality theorem.

## Node convention

The D4 Dynkin diagram has one central node and three outer nodes. This file uses
the following numbering:

```text
  0 -- 1 -- 2
       |
       3
```

- `1` is the central node.
- `0`, `2`, and `3` are the three outer nodes.

The order-three triality cycle sends:

```text
0 -> 2 -> 3 -> 0
```

and fixes the central node `1`.

## What is proved here

- `d4Cartan` is the D4 Cartan matrix as a concrete function
  `Fin 4 -> Fin 4 -> Int`.
- `d4OuterCycle` is the order-three outer-node cycle.
- `d4OuterCycle_order_three` proves that applying the cycle three times is the
  identity.
- `d4OuterCycle_cartan_preserved` proves that the cycle preserves the D4
  Cartan matrix.
- `d4OuterCycleInv` is the inverse cycle, with inverse and preservation
  theorems.

All proofs are finite case checks over `Fin 4`.

## What is not proved here

This file does **not** prove:

- the full Spin(8) triality theorem,
- the construction of SO(8) or Spin(8),
- the permutation of the vector and two half-spin representations,
- the theorem `G2 = Aut(O)`,
- an E8 decomposition theorem.

The theorem `d4OuterCycle_cartan_preserved` is the finite Dynkin-diagram shadow
of Spin(8) triality. It is useful because it is small, precise, and already
kernel-checkable. The deeper representation-theoretic statements are future
work.

Source: Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), Section 4.
Provenance: Aristotle job `aab25ea4-035f-45e0-8321-3408a1edfaaf`, adapted with
project-local comments and ASCII-safe notation.
-/

namespace PhysicsSM.Lie.Exceptional.Triality

/-! ## D4 Cartan matrix -/

/--
The D4 Cartan matrix as a finite function.

The node ordering is:

- `0`, `2`, and `3`: outer nodes,
- `1`: central node.

With this convention the matrix is:

```text
[  2 -1  0  0 ]
[ -1  2 -1 -1 ]
[  0 -1  2  0 ]
[  0 -1  0  2 ]
```

The diagonal entries are `2`. An off-diagonal entry is `-1` exactly when the
two nodes are connected in the D4 Dynkin diagram, and `0` otherwise.
-/
def d4Cartan (i j : Fin 4) : Int :=
  match i.val, j.val with
  | 0, 0 => 2
  | 0, 1 => -1
  | 0, 2 => 0
  | 0, 3 => 0
  | 1, 0 => -1
  | 1, 1 => 2
  | 1, 2 => -1
  | 1, 3 => -1
  | 2, 0 => 0
  | 2, 1 => -1
  | 2, 2 => 2
  | 2, 3 => 0
  | 3, 0 => 0
  | 3, 1 => -1
  | 3, 2 => 0
  | 3, 3 => 2
  | _, _ => 0

/-! ## Triality cycle -/

/--
The order-three triality cycle on the nodes of the D4 Dynkin diagram.

It cycles the three outer nodes:

```text
0 -> 2 -> 3 -> 0
```

and fixes the central node `1`. This is the finite diagram-level symmetry that
later corresponds to the order-three part of Spin(8) triality.
-/
def d4OuterCycle (i : Fin 4) : Fin 4 :=
  match i.val with
  | 0 => 2
  | 1 => 1
  | 2 => 3
  | 3 => 0
  | _ => i

/-- The triality cycle fixes the central D4 node. -/
theorem d4OuterCycle_fixes_central :
    d4OuterCycle 1 = 1 := by
  decide

/--
The triality cycle has order three.

This is a finite statement about the four Dynkin-diagram nodes: the three outer
nodes return to themselves after three steps, and the central node is fixed at
every step.
-/
theorem d4OuterCycle_order_three (i : Fin 4) :
    d4OuterCycle (d4OuterCycle (d4OuterCycle i)) = i := by
  fin_cases i <;> decide

/--
The triality cycle preserves the D4 Cartan matrix.

This is the central trusted result of the file. It says that if both row and
column indices of the Cartan matrix are moved by the outer-node cycle, the
Cartan entry is unchanged. In other words, the cycle is a symmetry of the D4
Dynkin diagram as recorded by its Cartan matrix.
-/
theorem d4OuterCycle_cartan_preserved (i j : Fin 4) :
    d4Cartan (d4OuterCycle i) (d4OuterCycle j) = d4Cartan i j := by
  fin_cases i <;> fin_cases j <;> decide

/-! ## Inverse cycle -/

/--
The inverse D4 outer-node cycle.

It sends:

```text
0 -> 3 -> 2 -> 0
```

and fixes the central node `1`.
-/
def d4OuterCycleInv (i : Fin 4) : Fin 4 :=
  match i.val with
  | 0 => 3
  | 1 => 1
  | 2 => 0
  | 3 => 2
  | _ => i

/-- The inverse cycle is a left inverse of the triality cycle. -/
theorem d4OuterCycle_left_inv (i : Fin 4) :
    d4OuterCycleInv (d4OuterCycle i) = i := by
  fin_cases i <;> decide

/-- The inverse cycle is a right inverse of the triality cycle. -/
theorem d4OuterCycle_right_inv (i : Fin 4) :
    d4OuterCycle (d4OuterCycleInv i) = i := by
  fin_cases i <;> decide

/-- The inverse cycle also preserves the D4 Cartan matrix. -/
theorem d4OuterCycleInv_cartan_preserved (i j : Fin 4) :
    d4Cartan (d4OuterCycleInv i) (d4OuterCycleInv j) = d4Cartan i j := by
  fin_cases i <;> fin_cases j <;> decide

/-- The inverse cycle also fixes the central D4 node. -/
theorem d4OuterCycleInv_fixes_central :
    d4OuterCycleInv 1 = 1 := by
  decide

/-- The inverse cycle also has order three. -/
theorem d4OuterCycleInv_order_three (i : Fin 4) :
    d4OuterCycleInv (d4OuterCycleInv (d4OuterCycleInv i)) = i := by
  fin_cases i <;> decide

end PhysicsSM.Lie.Exceptional.Triality
