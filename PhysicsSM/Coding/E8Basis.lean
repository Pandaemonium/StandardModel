import Mathlib
import PhysicsSM.Coding.HammingE8

/-!
# Explicit basis and Gram matrix for the E8 Construction A lattice

This module defines an explicit ℤ-basis for the Construction A lattice
`e8IntLattice` (the integer lattice obtained from the extended `[8,4,4]`
Hamming code), proves that every basis vector is a lattice member, computes
the 8 × 8 Gram matrix, and verifies its determinant is 256.

## Basis choice

The basis consists of:
- Four lifts of generators of the extended Hamming code (weight-4 codewords
  lifted to `{0,1}` integer vectors).
- Four even vectors `2 eᵢ` for `i ∈ {4,5,6,7}`.

The Gram matrix `G[i,j] = ∑ k, b_i[k] * b_j[k]` has the form

```text
⎡ 4  2  2  2  0  0  0  2 ⎤
⎢ 2  4  2  2  2  0  0  2 ⎥
⎢ 2  2  4  2  0  2  0  2 ⎥
⎢ 2  2  2  4  0  0  2  0 ⎥
⎢ 0  2  0  0  4  0  0  0 ⎥
⎢ 0  0  2  0  0  4  0  0 ⎥
⎢ 0  0  0  2  0  0  4  0 ⎥
⎣ 2  2  2  0  0  0  0  4 ⎦
```

with determinant 256. After the conventional `1/√2` scaling the Gram matrix
becomes `G/2`, which has determinant `256 / 2⁸ = 1`, confirming unimodularity.

## Source / provenance

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Ch. 7–8.
- Aristotle job H3 for PhysicsSM, 2026-05-07.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

/-! ## Explicit basis -/

/-- An explicit integer basis for the E8 Construction A lattice.

Rows 0–3 are lifts of generators of the extended `[8,4,4]` Hamming code;
rows 4–7 are the even vectors `2 eᵢ` for `i = 4,5,6,7`. -/
def e8CodeBasisInt : Fin 8 → Fin 8 → ℤ :=
  ![![1, 1, 1, 0, 0, 0, 0, 1],
    ![1, 0, 0, 1, 1, 0, 0, 1],
    ![0, 1, 0, 1, 0, 1, 0, 1],
    ![1, 1, 0, 1, 0, 0, 1, 0],
    ![0, 0, 0, 0, 2, 0, 0, 0],
    ![0, 0, 0, 0, 0, 2, 0, 0],
    ![0, 0, 0, 0, 0, 0, 2, 0],
    ![0, 0, 0, 0, 0, 0, 0, 2]]

/-! ## Membership -/

/-- Every basis vector belongs to `e8IntLattice`. -/
theorem e8CodeBasisInt_mem (i : Fin 8) : e8CodeBasisInt i ∈ e8IntLattice := by
  fin_cases i <;> {
    change reduceModTwo _ ∈ extendedHamming8
    rw [extendedHamming8_mem_iff_mulVec]
    native_decide
  }

/-! ## Gram matrix -/

/-- The Gram matrix of the explicit E8 basis: `G[i,j] = ∑ k, b_i[k] * b_j[k]`. -/
def e8CodeBasisGram : Matrix (Fin 8) (Fin 8) ℤ :=
  !![4, 2, 2, 2, 0, 0, 0, 2;
     2, 4, 2, 2, 2, 0, 0, 2;
     2, 2, 4, 2, 0, 2, 0, 2;
     2, 2, 2, 4, 0, 0, 2, 0;
     0, 2, 0, 0, 4, 0, 0, 0;
     0, 0, 2, 0, 0, 4, 0, 0;
     0, 0, 0, 2, 0, 0, 4, 0;
     2, 2, 2, 0, 0, 0, 0, 4]

/-- The Gram matrix equals the matrix of inner products of the basis
vectors. -/
theorem e8CodeBasisGram_eq :
    ∀ i j : Fin 8,
      e8CodeBasisGram i j = ∑ k : Fin 8, e8CodeBasisInt i k * e8CodeBasisInt j k := by
  decide

/-
The determinant of the Gram matrix is 256.
-/
theorem e8CodeBasisGram_det : e8CodeBasisGram.det = 256 := by
  norm_num [Matrix.det_apply'] at *
  native_decide +revert

/-- The determinant is positive, confirming the basis vectors are
linearly independent over `ℤ`. -/
theorem e8CodeBasisGram_det_pos : 0 < e8CodeBasisGram.det := by
  rw [e8CodeBasisGram_det]; norm_num

/-- All diagonal entries of the Gram matrix are 4, confirming each
basis vector has squared norm 4. -/
theorem e8CodeBasisGram_diag (i : Fin 8) : e8CodeBasisGram i i = 4 := by
  fin_cases i <;> decide

/-- All off-diagonal entries of the Gram matrix are even. -/
theorem e8CodeBasisGram_even (i j : Fin 8) : 2 ∣ e8CodeBasisGram i j := by
  fin_cases i <;> fin_cases j <;> decide

end PhysicsSM.Coding
