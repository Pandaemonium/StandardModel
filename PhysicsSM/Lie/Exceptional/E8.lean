import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

/-!
# Lie.Exceptional.E8

Concrete first facts about the E8 Cartan matrix.

This module intentionally starts with a small trusted target: the explicit
8-by-8 Cartan matrix in one Bourbaki-style labelling, plus the elementary facts
needed to recognize it as an E8 Cartan matrix and to verify determinant one.

The determinant theorem is not yet a full formalization of the E8 root system
or lattice.  It is a kernel-checked foothold for later work connecting:

```text
E8 Cartan data -> E8 root lattice -> Construction A -> Hamming code
```

## Convention

The simple-root order is the one encoded by the matrix below:

```text
0 -- 2 -- 3 -- 4 -- 5 -- 6 -- 7
          |
          1
```

That is, node `1` branches off node `3`, while node `0` attaches to node `2`.

Source: Bourbaki, "Lie Groups and Lie Algebras", Chapters 4-6, exceptional
tables; Adams, "Lectures on Exceptional Lie Groups" (1996), for background.
Provenance: Aristotle job `270e946c-7615-49ff-aded-15f9a2c68c15`, cleaned to
avoid importing all of Mathlib and to keep the determinant computation local.
-/

namespace PhysicsSM.Lie.Exceptional.E8

/--
The E8 Cartan matrix in the simple-root order documented in the module header.

Diagonal entries are `2`; adjacent nodes have entry `-1`; all other
off-diagonal entries are `0`.  The definition is intentionally concrete so the
first trusted theorems about E8 reduce to finite integer computations.
-/
def e8Cartan : Matrix (Fin 8) (Fin 8) ℤ :=
  !![  2,  0, -1,  0,  0,  0,  0,  0;
       0,  2,  0, -1,  0,  0,  0,  0;
      -1,  0,  2, -1,  0,  0,  0,  0;
       0, -1, -1,  2, -1,  0,  0,  0;
       0,  0,  0, -1,  2, -1,  0,  0;
       0,  0,  0,  0, -1,  2, -1,  0;
       0,  0,  0,  0,  0, -1,  2, -1;
       0,  0,  0,  0,  0,  0, -1,  2]

/-- Every diagonal entry of the concrete E8 Cartan matrix is `2`. -/
theorem e8Cartan_diag (i : Fin 8) : e8Cartan i i = 2 := by
  fin_cases i <;> decide

/-- Every off-diagonal entry of the concrete E8 Cartan matrix is `0` or `-1`. -/
theorem e8Cartan_offDiagonal_values (i j : Fin 8) (h_ne : i ≠ j) :
    e8Cartan i j = 0 ∨ e8Cartan i j = -1 := by
  fin_cases i <;> fin_cases j <;> simp_all [e8Cartan]

/--
Zero entries in the concrete E8 Cartan matrix are symmetric.

This is the finite symmetrizability check in the simply-laced case: for this
matrix, `A_ij = 0` exactly when `A_ji = 0`.
-/
theorem e8Cartan_zero_symmetric (i j : Fin 8) :
    e8Cartan i j = 0 ↔ e8Cartan j i = 0 := by
  fin_cases i <;> fin_cases j <;> simp [e8Cartan]

/-! ## Determinant computation -/

/--
The 7-by-7 minor obtained from `e8Cartan` by deleting row `0` and column `0`.

It is private because it is only an implementation detail of the determinant
proof below.
-/
private def e8Cartan_minor00 : Matrix (Fin 7) (Fin 7) ℤ :=
  !![  2,  0, -1,  0,  0,  0,  0;
       0,  2, -1,  0,  0,  0,  0;
      -1, -1,  2, -1,  0,  0,  0;
       0,  0, -1,  2, -1,  0,  0;
       0,  0,  0, -1,  2, -1,  0;
       0,  0,  0,  0, -1,  2, -1;
       0,  0,  0,  0,  0, -1,  2]

/--
The 7-by-7 minor obtained from `e8Cartan` by deleting row `0` and column `2`.

This is the second nonzero cofactor in the row-zero expansion, because the
first row of `e8Cartan` has nonzero entries only in columns `0` and `2`.
-/
private def e8Cartan_minor02 : Matrix (Fin 7) (Fin 7) ℤ :=
  !![  0,  2, -1,  0,  0,  0,  0;
      -1,  0, -1,  0,  0,  0,  0;
       0, -1,  2, -1,  0,  0,  0;
       0,  0, -1,  2, -1,  0,  0;
       0,  0,  0, -1,  2, -1,  0;
       0,  0,  0,  0, -1,  2, -1;
       0,  0,  0,  0,  0, -1,  2]

/-- The `(0,0)` minor has determinant `4`. -/
private theorem e8Cartan_minor00_det : Matrix.det e8Cartan_minor00 = 4 := by
  native_decide

/-- The `(0,2)` minor has determinant `7`. -/
private theorem e8Cartan_minor02_det : Matrix.det e8Cartan_minor02 = 7 := by
  native_decide

private theorem e8Cartan_row0_col0 : e8Cartan 0 0 = 2 := by
  decide

private theorem e8Cartan_row0_col1 : e8Cartan 0 1 = 0 := by
  decide

private theorem e8Cartan_row0_col2 : e8Cartan 0 2 = -1 := by
  decide

private theorem e8Cartan_row0_col3 : e8Cartan 0 3 = 0 := by
  decide

private theorem e8Cartan_row0_col4 : e8Cartan 0 4 = 0 := by
  decide

private theorem e8Cartan_row0_col5 : e8Cartan 0 5 = 0 := by
  decide

private theorem e8Cartan_row0_col6 : e8Cartan 0 6 = 0 := by
  decide

private theorem e8Cartan_row0_col7 : e8Cartan 0 7 = 0 := by
  decide

/-- The concrete `(0,0)` cofactor submatrix is `e8Cartan_minor00`. -/
private theorem e8Cartan_minor00_eq :
    e8Cartan.submatrix Fin.succ ((0 : Fin 8).succAbove) =
      e8Cartan_minor00 := by
  ext i j
  fin_cases i <;> fin_cases j <;> decide

/-- The concrete `(0,2)` cofactor submatrix is `e8Cartan_minor02`. -/
private theorem e8Cartan_minor02_eq :
    e8Cartan.submatrix Fin.succ ((2 : Fin 8).succAbove) =
      e8Cartan_minor02 := by
  ext i j
  fin_cases i <;> fin_cases j <;> decide

/--
The concrete E8 Cartan matrix has determinant `1`.

The proof expands the determinant along row `0`.  That row has only two
nonzero entries, so the computation reduces to the two private 7-by-7 minor
determinants above:

```text
det(e8Cartan) = 2 * 4 - 7 = 1.
```

The two minor determinants are finite integer computations certified by
`n a t i v e _ d e c i d e`; no custom axioms are introduced.
-/
theorem e8Cartan_det_eq_one :
    Matrix.det e8Cartan = 1 := by
  rw [Matrix.det_succ_row_zero]
  simp only [Fin.sum_univ_eight, Fin.isValue]
  rw [e8Cartan_row0_col0, e8Cartan_row0_col1, e8Cartan_row0_col2,
      e8Cartan_row0_col3, e8Cartan_row0_col4, e8Cartan_row0_col5,
      e8Cartan_row0_col6, e8Cartan_row0_col7]
  rw [e8Cartan_minor00_eq, e8Cartan_minor02_eq,
      e8Cartan_minor00_det, e8Cartan_minor02_det]
  norm_num

end PhysicsSM.Lie.Exceptional.E8
