import Mathlib

/-!
# The Mermin-Peres magic square: contextuality as a decoding obstruction

Finite contextuality fixture for the null-information program's measurement
lane (RUN_PLAN C2.4: an explicit global-valuation obstruction that is
nontrivial and NOT a toy dressed as Gleason).  The nine two-qubit Pauli
observables of the magic square are each Hermitian involutions; every row and
every column is a commuting context; the three row products are `+1` and the
column products are `(+1, +1, -1)`.  A classical noncontextual valuation
would assign each observable a definite value in `{+1, -1}` consistent with
all six product constraints — and no such assignment exists, by the parity
argument: multiplying all nine values row-wise gives `+1`, column-wise gives
`-1`.

Program reading (docstring only, not a theorem): contextuality is the
obstruction to one context-independent decoder for all questions — local
valuations exist on each commuting context but cannot be glued globally,
structurally parallel to gauge patching.  This module does NOT derive the
Born rule and is not a Gleason-type theorem.

## Setup

Qubit Paulis `X, Y, Z : Matrix (Fin 2) (Fin 2) ℂ`; two-qubit observables via
the Kronecker product `A ⊗ₖ B`.  The square is

  row 1:  X⊗1   1⊗X   X⊗X
  row 2:  1⊗Y   Y⊗1   Y⊗Y
  row 3:  X⊗Y   Y⊗X   Z⊗Z

## Targets

1. `square_hermitian_involutions` — all nine entries are Hermitian and square
   to the identity.
2. `rows_commute` / `cols_commute` — each row and each column is a commuting
   context (pairwise).
3. `row_products_one` — the three row products (left to right) equal `1`.
4. `col_products` — the first two column products (top to bottom) equal `1`
   and the third equals `-1`.
5. `no_global_valuation` — there is no assignment
   `v : Fin 3 → Fin 3 → ℤ` with values in `{1, -1}` satisfying the six
   product constraints; the parity contradiction is forced.
6. `quantum_realizes` — packaging: the quantum square satisfies exactly the
   constraint pattern that the classical valuation cannot (rows `1,1,1`,
   columns `1,1,-1`), so the obstruction is realized, not hypothetical.

Do not weaken the statements.  Helper lemmas welcome.  Run the narrow check
`lake env lean MerminPeresContextuality/MagicSquare.lean` first; avoid a full
lake build until the holes are closed.
Recovered from Aristotle project `b980d39b-4569-45e7-b7cd-d657ae84f7e0`; statements audited unchanged
against the submitted originals and proof bodies verified locally under the
pinned toolchain before porting.
-/

set_option maxHeartbeats 10000000

namespace PhysicsSM.Draft.NullEdge.MerminPeresContextuality

open Matrix
open Kronecker

/-- Pauli X. -/
def X : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- Pauli Y. -/
def Y : Matrix (Fin 2) (Fin 2) ℂ := !![0, -Complex.I; Complex.I, 0]

/-- Pauli Z. -/
def Z : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- The nine observables of the magic square, indexed row-column. -/
noncomputable def sq : Fin 3 → Fin 3 → Matrix (Fin 2 × Fin 2) (Fin 2 × Fin 2) ℂ
  | 0, 0 => X ⊗ₖ 1
  | 0, 1 => 1 ⊗ₖ X
  | 0, 2 => X ⊗ₖ X
  | 1, 0 => 1 ⊗ₖ Y
  | 1, 1 => Y ⊗ₖ 1
  | 1, 2 => Y ⊗ₖ Y
  | 2, 0 => X ⊗ₖ Y
  | 2, 1 => Y ⊗ₖ X
  | 2, 2 => Z ⊗ₖ Z

/-- Target 1: every entry is a Hermitian involution. -/
theorem square_hermitian_involutions (i j : Fin 3) :
    (sq i j)ᴴ = sq i j ∧ sq i j * sq i j = 1 := by
  fin_cases i <;> fin_cases j <;>
    (simp only [sq]; constructor) <;>
    (ext ⟨a, b⟩ ⟨c, d⟩;
     fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
     simp [X, Y, Z, Matrix.mul_apply, Matrix.conjTranspose_apply, Fintype.sum_prod_type,
       Fin.sum_univ_two, kroneckerMap_apply, Matrix.one_apply])

/-- Target 2a: each row is a commuting context. -/
theorem rows_commute (i j k : Fin 3) :
    sq i j * sq i k = sq i k * sq i j := by
  fin_cases i <;> fin_cases j <;> fin_cases k <;>
    simp only [sq] <;>
    first
    | rfl
    | (ext ⟨a, b⟩ ⟨c, d⟩;
       fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
       simp [X, Y, Z, Matrix.mul_apply, Fintype.sum_prod_type,
         Fin.sum_univ_two, kroneckerMap_apply, Matrix.one_apply])

/-- Target 2b: each column is a commuting context. -/
theorem cols_commute (i j k : Fin 3) :
    sq j i * sq k i = sq k i * sq j i := by
  fin_cases i <;> fin_cases j <;> fin_cases k <;>
    simp only [sq] <;>
    first
    | rfl
    | (ext ⟨a, b⟩ ⟨c, d⟩;
       fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
       simp [X, Y, Z, Matrix.mul_apply, Fintype.sum_prod_type,
         Fin.sum_univ_two, kroneckerMap_apply, Matrix.one_apply])

/-- Target 3: the three row products equal the identity. -/
theorem row_products_one (i : Fin 3) :
    sq i 0 * sq i 1 * sq i 2 = 1 := by
  fin_cases i <;>
    (simp only [sq];
     ext ⟨a, b⟩ ⟨c, d⟩;
     fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
     simp [X, Y, Z, Matrix.mul_apply, Fintype.sum_prod_type,
       Fin.sum_univ_two, kroneckerMap_apply, Matrix.one_apply])

/-- Target 4: the column products are `1, 1, -1`. -/
theorem col_products :
    sq 0 0 * sq 1 0 * sq 2 0 = 1 ∧
    sq 0 1 * sq 1 1 * sq 2 1 = 1 ∧
    sq 0 2 * sq 1 2 * sq 2 2 = -1 := by
  refine ⟨?_, ?_, ?_⟩ <;>
    (simp only [sq];
     ext ⟨a, b⟩ ⟨c, d⟩;
     fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
     simp [X, Y, Z, Matrix.mul_apply, Fintype.sum_prod_type,
       Fin.sum_univ_two, kroneckerMap_apply, Matrix.one_apply])

/-- Target 5: no classical noncontextual valuation exists.  Any `{±1}`
assignment satisfying the row constraints `1,1,1` and column constraints
`1,1,-1` is contradictory. -/
theorem no_global_valuation :
    ¬ ∃ v : Fin 3 → Fin 3 → ℤ,
      (∀ i j, v i j = 1 ∨ v i j = -1) ∧
      (∀ i, v i 0 * v i 1 * v i 2 = 1) ∧
      (v 0 0 * v 1 0 * v 2 0 = 1) ∧
      (v 0 1 * v 1 1 * v 2 1 = 1) ∧
      (v 0 2 * v 1 2 * v 2 2 = -1) := by
  rintro ⟨v, -, hrow, hc0, hc1, hc2⟩
  have h0 := hrow 0
  have h1 := hrow 1
  have h2 := hrow 2
  -- The product of all nine values is `+1` computed row-wise, `-1` column-wise.
  have key :
      (v 0 0 * v 0 1 * v 0 2) * (v 1 0 * v 1 1 * v 1 2) * (v 2 0 * v 2 1 * v 2 2)
        = (v 0 0 * v 1 0 * v 2 0) * (v 0 1 * v 1 1 * v 2 1) * (v 0 2 * v 1 2 * v 2 2) := by
    ring
  rw [h0, h1, h2, hc0, hc1, hc2] at key
  norm_num at key

/-- Target 6: the quantum square realizes exactly the constraint pattern the
classical valuation cannot. -/
theorem quantum_realizes :
    (∀ i, sq i 0 * sq i 1 * sq i 2 = 1) ∧
    (sq 0 0 * sq 1 0 * sq 2 0 = 1) ∧
    (sq 0 1 * sq 1 1 * sq 2 1 = 1) ∧
    (sq 0 2 * sq 1 2 * sq 2 2 = -1) :=
  ⟨row_products_one, col_products.1, col_products.2.1, col_products.2.2⟩

end PhysicsSM.Draft.NullEdge.MerminPeresContextuality

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.MerminPeresContextuality.no_global_valuation' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.MerminPeresContextuality.no_global_valuation

/-- info: 'PhysicsSM.Draft.NullEdge.MerminPeresContextuality.quantum_realizes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.MerminPeresContextuality.quantum_realizes

/-- info: 'PhysicsSM.Draft.NullEdge.MerminPeresContextuality.square_hermitian_involutions' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.MerminPeresContextuality.square_hermitian_involutions
