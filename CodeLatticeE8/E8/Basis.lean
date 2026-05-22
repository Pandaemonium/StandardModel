import CodeLatticeE8.E8.HammingConstruction

/-!
# An explicit basis-shaped family for the Hamming Construction A lattice

This module introduces the eight standard integer vectors used to study the
Hamming Construction A model.  The first four vectors are `{0,1}`-lifts of the
four message basis words of the extended Hamming code; the last four are even
coordinate vectors.

At this stage we record:

- each vector belongs to the Hamming Construction A lattice;
- their integer Gram matrix;
- diagonal and parity facts about the Gram matrix.

The determinant and spanning/unimodularity package is intentionally left for a
later module.  That keeps this file small and lets the reviewer inspect the
basic concrete data without a dense determinant computation in the way.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.E8

open CodeLatticeE8.Code
open CodeLatticeE8.ConstructionA

/-! ## The eight vectors -/

/-- The standard eight integer vectors used for the Hamming Construction A model.

Rows `0` through `3` are lifts of the four message-basis codewords of
`extendedHamming8`.  Rows `4` through `7` are the even coordinate vectors
`2 e_4`, `2 e_5`, `2 e_6`, and `2 e_7`.
-/
def hammingConstructionBasis : Fin 8 → Fin 8 → ℤ :=
  ![![1, 1, 1, 0, 0, 0, 0, 1],
    ![1, 0, 0, 1, 1, 0, 0, 1],
    ![0, 1, 0, 1, 0, 1, 0, 1],
    ![1, 1, 0, 1, 0, 0, 1, 0],
    ![0, 0, 0, 0, 2, 0, 0, 0],
    ![0, 0, 0, 0, 0, 2, 0, 0],
    ![0, 0, 0, 0, 0, 0, 2, 0],
    ![0, 0, 0, 0, 0, 0, 0, 2]]

private theorem basis_reduce_row0 :
    reduceModTwo (hammingConstructionBasis 0) = codewordOfMsg ![1, 0, 0, 0] := by
  decide

private theorem basis_reduce_row1 :
    reduceModTwo (hammingConstructionBasis 1) = codewordOfMsg ![0, 1, 0, 0] := by
  decide

private theorem basis_reduce_row2 :
    reduceModTwo (hammingConstructionBasis 2) = codewordOfMsg ![0, 0, 1, 0] := by
  decide

private theorem basis_reduce_row3 :
    reduceModTwo (hammingConstructionBasis 3) = codewordOfMsg ![0, 0, 0, 1] := by
  decide

private theorem basis_reduce_row4 :
    reduceModTwo (hammingConstructionBasis 4) = 0 := by
  decide

private theorem basis_reduce_row5 :
    reduceModTwo (hammingConstructionBasis 5) = 0 := by
  decide

private theorem basis_reduce_row6 :
    reduceModTwo (hammingConstructionBasis 6) = 0 := by
  decide

private theorem basis_reduce_row7 :
    reduceModTwo (hammingConstructionBasis 7) = 0 := by
  decide

/-- Every vector in `hammingConstructionBasis` lies in the Hamming Construction A lattice. -/
theorem hammingConstructionBasis_mem (i : Fin 8) :
    hammingConstructionBasis i ∈ hammingConstructionA := by
  rw [mem_hammingConstructionA_iff]
  fin_cases i
  · change reduceModTwo (hammingConstructionBasis 0) ∈ extendedHamming8
    rw [basis_reduce_row0]
    rw [extendedHamming8_mem_iff_mulVec]
    exact codewordOfMsg_mem_code ![1, 0, 0, 0]
  · change reduceModTwo (hammingConstructionBasis 1) ∈ extendedHamming8
    rw [basis_reduce_row1]
    rw [extendedHamming8_mem_iff_mulVec]
    exact codewordOfMsg_mem_code ![0, 1, 0, 0]
  · change reduceModTwo (hammingConstructionBasis 2) ∈ extendedHamming8
    rw [basis_reduce_row2]
    rw [extendedHamming8_mem_iff_mulVec]
    exact codewordOfMsg_mem_code ![0, 0, 1, 0]
  · change reduceModTwo (hammingConstructionBasis 3) ∈ extendedHamming8
    rw [basis_reduce_row3]
    rw [extendedHamming8_mem_iff_mulVec]
    exact codewordOfMsg_mem_code ![0, 0, 0, 1]
  · change reduceModTwo (hammingConstructionBasis 4) ∈ extendedHamming8
    rw [basis_reduce_row4]
    exact extendedHamming8.zero_mem
  · change reduceModTwo (hammingConstructionBasis 5) ∈ extendedHamming8
    rw [basis_reduce_row5]
    exact extendedHamming8.zero_mem
  · change reduceModTwo (hammingConstructionBasis 6) ∈ extendedHamming8
    rw [basis_reduce_row6]
    exact extendedHamming8.zero_mem
  · change reduceModTwo (hammingConstructionBasis 7) ∈ extendedHamming8
    rw [basis_reduce_row7]
    exact extendedHamming8.zero_mem

/-! ## Gram matrix -/

/-- Integer Gram matrix of `hammingConstructionBasis`. -/
def hammingConstructionGram : Matrix (Fin 8) (Fin 8) ℤ :=
  !![4, 2, 2, 2, 0, 0, 0, 2;
     2, 4, 2, 2, 2, 0, 0, 2;
     2, 2, 4, 2, 0, 2, 0, 2;
     2, 2, 2, 4, 0, 0, 2, 0;
     0, 2, 0, 0, 4, 0, 0, 0;
     0, 0, 2, 0, 0, 4, 0, 0;
     0, 0, 0, 2, 0, 0, 4, 0;
     2, 2, 2, 0, 0, 0, 0, 4]

/-- The displayed matrix is the Gram matrix of `hammingConstructionBasis`. -/
theorem hammingConstructionGram_eq :
    ∀ i j : Fin 8,
      hammingConstructionGram i j =
        ∑ k : Fin 8, hammingConstructionBasis i k * hammingConstructionBasis j k := by
  decide

/-- Each displayed basis vector has unscaled squared norm four. -/
theorem hammingConstructionGram_diag (i : Fin 8) :
    hammingConstructionGram i i = 4 := by
  fin_cases i <;> decide

/-- Every entry of the unscaled Gram matrix is even. -/
theorem hammingConstructionGram_even (i j : Fin 8) :
    2 ∣ hammingConstructionGram i j := by
  fin_cases i <;> fin_cases j <;> decide

/-- The Gram matrix is symmetric. -/
theorem hammingConstructionGram_comm (i j : Fin 8) :
    hammingConstructionGram i j = hammingConstructionGram j i := by
  fin_cases i <;> fin_cases j <;> decide

end CodeLatticeE8.E8
