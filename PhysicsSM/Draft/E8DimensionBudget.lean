import Mathlib

/-!
# E8 → SM dimension budget (finite bookkeeping)

This file proves the *exact integer dimension identities* underlying the
`E8` grand-unification branching chains, as kernel-checked `Nat` arithmetic.

This is **honest finite dimension bookkeeping** for the standard maximal-subgroup
branchings of the Lie algebra `E8`.  It is emphatically **not** a
representation-theoretic construction of the Standard Model, nor a proof that these
integers are the dimensions of the relevant Lie algebras / representations.
The dimensions are recorded here as definitions and the content of the theorems is
purely that the additive decompositions balance to `248`.

## Facts proved

* `E8` has dimension `248 = 8 (Cartan) + 240 (roots)`.
* The `E6 × SU(3)` maximal-subgroup branching:
  `248 = 78 + 8 + 81 + 81`, where `(27,3)` and `(27bar,3bar)` each have dimension
  `27 · 3 = 81`.
* The `SO(10) × SU(4)` maximal-subgroup branching.
* The `SU(5) × SU(5)` maximal-subgroup branching.
-/

namespace PhysicsSM.Draft.E8DimensionBudget

/-! ## Basic dimensions of the classical/exceptional pieces -/

/-- Dimension of the Cartan subalgebra (rank) of `E8`. -/
def dimCartanE8 : ℕ := 8

/-- Number of roots of `E8`. -/
def numRootsE8 : ℕ := 240

/-- Dimension of the Lie algebra `E8`. -/
def dimE8 : ℕ := 248

/-- Dimension of the Lie algebra `E6`. -/
def dimE6 : ℕ := 78

/-- Dimension of the Lie algebra `SU(3)` (i.e. `𝔰𝔲(3)`), `3² − 1 = 8`. -/
def dimSU3 : ℕ := 8

/-- Dimension of the Lie algebra `SO(10)` (i.e. `𝔰𝔬(10)`), `10·9/2 = 45`. -/
def dimSO10 : ℕ := 45

/-- Dimension of the Lie algebra `SU(4)` (i.e. `𝔰𝔲(4)`), `4² − 1 = 15`. -/
def dimSU4 : ℕ := 15

/-- Dimension of the Lie algebra `SU(5)` (i.e. `𝔰𝔲(5)`), `5² − 1 = 24`. -/
def dimSU5 : ℕ := 24

/-! ## The Cartan + roots decomposition of `E8` -/

/-- `dim E8 = rank + #roots`, i.e. `248 = 8 + 240`. -/
theorem dimE8_eq_cartan_add_roots : dimE8 = dimCartanE8 + numRootsE8 := by
  decide

/-- Sanity check that the recorded value is `248`. -/
theorem dimE8_value : dimE8 = 248 := by decide

theorem dimCartanE8_value : dimCartanE8 = 8 := by decide

theorem numRootsE8_value : numRootsE8 = 240 := by decide

/-! ## The `E6 × SU(3)` maximal-subgroup branching

Under `E8 ⊃ E6 × SU(3)`:
`248 = (78,1) + (1,8) + (27,3) + (27bar,3bar)`.
The subalgebra `E6 × SU(3)` has dimension `78 + 8 = 86`, and the two off-diagonal
representations `(27,3)` and `(27bar,3bar)` each contribute `27 · 3 = 81`. -/

/-- Dimension of the fundamental `27` of `E6`. -/
def dim27 : ℕ := 27

/-- Dimension of the fundamental `3` of `SU(3)`. -/
def dim3 : ℕ := 3

/-- Dimension of the representation `(27,3)` (equivalently `(27bar,3bar)`),
`27 · 3 = 81`. -/
def dim27x3 : ℕ := dim27 * dim3

theorem dim27x3_value : dim27x3 = 81 := by decide

/-- The `E6 × SU(3)` subalgebra dimension: `78 + 8 = 86`. -/
def dimE6xSU3 : ℕ := dimE6 + dimSU3

theorem dimE6xSU3_value : dimE6xSU3 = 86 := by decide

/-- **Main identity (E6 × SU(3) branching).**
`248 = 78 + 8 + 81 + 81`. -/
theorem branching_E6_SU3 :
    dimE8 = dimE6 + dimSU3 + dim27x3 + dim27x3 := by
  decide

/-- The same identity grouped as `subalgebra + off-diagonal reps`:
`248 = (78 + 8) + (81 + 81) = 86 + 162`. -/
theorem branching_E6_SU3_grouped :
    dimE8 = dimE6xSU3 + (dim27x3 + dim27x3) := by
  decide

/-! ## The `SO(10) × SU(4)` maximal-subgroup branching

Under `E8 ⊃ SO(10) × SU(4)`:
`248 = (45,1) + (1,15) + (10,6) + (16,4) + (16bar,4bar)`.
Here `dim SO(10) = 45`, `dim SU(4) = 15`, and the off-diagonal pieces are
`(10,6) = 60`, `(16,4) = 64`, `(16bar,4bar) = 64`. -/

/-- Dimension of the vector `10` of `SO(10)`. -/
def dim10 : ℕ := 10

/-- Dimension of the antisymmetric `6` of `SU(4)`. -/
def dim6 : ℕ := 6

/-- Dimension of the spinor `16` of `SO(10)`. -/
def dim16 : ℕ := 16

/-- Dimension of the fundamental `4` of `SU(4)`. -/
def dim4 : ℕ := 4

/-- The `SO(10) × SU(4)` subalgebra dimension: `45 + 15 = 60`. -/
def dimSO10xSU4 : ℕ := dimSO10 + dimSU4

theorem dimSO10xSU4_value : dimSO10xSU4 = 60 := by decide

theorem dim10x6_value : dim10 * dim6 = 60 := by decide

theorem dim16x4_value : dim16 * dim4 = 64 := by decide

/-- **Main identity (SO(10) × SU(4) branching).**
`248 = 45 + 15 + (10·6) + (16·4) + (16·4)`
`    = 45 + 15 + 60 + 64 + 64`. -/
theorem branching_SO10_SU4 :
    dimE8 = dimSO10 + dimSU4 + dim10 * dim6 + dim16 * dim4 + dim16 * dim4 := by
  decide

/-! ## The `SU(5) × SU(5)` maximal-subgroup branching

Under `E8 ⊃ SU(5) × SU(5)`:
`248 = (24,1) + (1,24) + (5,10) + (5bar,10bar) + (10,5bar) + (10bar,5)`.
Here each `SU(5)` factor contributes `24`, and the four off-diagonal pieces are
`(5,10) = 50`, `(10,5) = 50` (and their conjugates), each `50`. -/

/-- Dimension of the fundamental `5` of `SU(5)`. -/
def dim5 : ℕ := 5

/-- Dimension of the antisymmetric `10` of `SU(5)`. -/
def dim10SU5 : ℕ := 10

/-- The `SU(5) × SU(5)` subalgebra dimension: `24 + 24 = 48`. -/
def dimSU5xSU5 : ℕ := dimSU5 + dimSU5

theorem dimSU5xSU5_value : dimSU5xSU5 = 48 := by decide

theorem dim5x10_value : dim5 * dim10SU5 = 50 := by decide

/-- **Main identity (SU(5) × SU(5) branching).**
`248 = 24 + 24 + 4·(5·10)`
`    = 24 + 24 + 50 + 50 + 50 + 50`. -/
theorem branching_SU5_SU5 :
    dimE8 = dimSU5 + dimSU5
              + dim5 * dim10SU5 + dim5 * dim10SU5
              + dim5 * dim10SU5 + dim5 * dim10SU5 := by
  decide

/-! ## Cross-checks: all branchings agree on the total `248` -/

theorem all_branchings_agree :
    (dimCartanE8 + numRootsE8 = 248) ∧
    (dimE6 + dimSU3 + dim27x3 + dim27x3 = 248) ∧
    (dimSO10 + dimSU4 + dim10 * dim6 + dim16 * dim4 + dim16 * dim4 = 248) ∧
    (dimSU5 + dimSU5 + dim5 * dim10SU5 + dim5 * dim10SU5
        + dim5 * dim10SU5 + dim5 * dim10SU5 = 248) := by
  decide

end PhysicsSM.Draft.E8DimensionBudget
