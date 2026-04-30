# Task: Furey Ideal J — Linear Independence of Basis

**Agent**: Aristotle
**Status**: Complete — integrated
**Priority**: High
**Job ID**: `72a89d00-f09a-45b1-8e6d-fc151ffb6c7d`

## Goal

Prove that the 8 basis states $\{v_1, v_2, v_3, v_4, v_5, v_6, \omega, \nu\}$ defined in `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean` are linearly independent over ℂ.

## Context

We have already kernel-verified the coordinates of these 8 states. However, to formalize $J$ as an 8-dimensional `Subspace` or `Submodule`, we must prove they are not redundant.

The states are defined as `ComplexOctonion` (which are essentially vectors in $\mathbb{C}^{8}$).

## Strategy

The proof is a finite coordinate computation. Aristotle should:
1. Assume a linear combination $\sum c_i v_i = 0$ where $c_i \in \mathbb{C}$.
2. Use `ComplexOctonion.ext` to break the equation into 8 complex-valued component equations (16 real-valued).
3. Show that this system of equations implies $c_i = 0$ for all $i$.

Note: Because the states are mostly "pure" basis elements (e.g., $v_1$ has only $c_4$ and $c_3$ non-zero), the resulting matrix is sparse.

## File to modify

`PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean`

## Theorems to add

```lean
/-- The eight basis states of the minimal left ideal J are linearly independent over ℂ. -/
theorem basis_linear_independent :
    LinearIndependent ℂ (fun i : Fin 8 =>
      match i with
      | 0 => omega
      | 1 => v1
      | 2 => v2
      | 3 => v3
      | 4 => v4
      | 5 => v5
      | 6 => v6
      | 7 => nu) := sorry
```

## Constraints
- No `sorry`.
- Use component expansion.
- Use `LinearAlgebra.Basis` definitions from Mathlib if possible, otherwise prove it via the $c_i=0$ definition.
## Result
Proved via `grind` in `PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean`.
