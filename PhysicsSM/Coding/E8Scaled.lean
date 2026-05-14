import Mathlib
import PhysicsSM.Coding.HammingE8

/-!
# Scaled Construction A E8 lattice: minimum squared norm 2

This module defines the real-scaled model of the Construction A lattice
`Λ(e₈)` and proves that, after the conventional `1/√2` scaling, the
minimum nonzero squared norm is exactly **2**.

## Conventions

Two squared-norm conventions coexist and are kept visibly separate:

- **Integer norm 4**: the lattice `e8IntLattice ⊆ ℤ⁸` has minimum nonzero
  `sqNorm z = ∑ zᵢ² = 4` (proved in `PhysicsSM.Coding.HammingE8`).
- **Scaled real norm 2**: after mapping `z ↦ z / √2` into `ℝ⁸`, the
  minimum nonzero `scaledSqNorm z = (∑ zᵢ²) / 2 = 2`.

The scaling factor `1/√2` is the standard normalization that turns the
Construction A lattice of a doubly-even self-dual `[8,4,4]` code into the
E8 root lattice with roots of squared length 2.

## Source / provenance

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Ch. 7–8.
- Aristotle job H2 for PhysicsSM, 2026-05-07.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

/-! ## Casting integer vectors to real vectors -/

/-- Cast an integer vector to a real vector, coordinate-wise. -/
def intVectorToReal {n : ℕ} (z : Fin n → ℤ) : Fin n → ℝ :=
  fun i => (z i : ℝ)

@[simp]
theorem intVectorToReal_apply {n : ℕ} (z : Fin n → ℤ) (i : Fin n) :
    intVectorToReal z i = (z i : ℝ) := rfl

/-! ## Scaled E8 vector -/

/-- The scaled E8 vector: maps an integer vector `z` to the real vector
`z / √2`, i.e., each coordinate `zᵢ` is sent to `zᵢ / √2`.

This is the standard normalization for the E8 root lattice via
Construction A. -/
noncomputable def scaledE8Vector (z : Fin 8 → ℤ) : Fin 8 → ℝ :=
  fun i => (z i : ℝ) / Real.sqrt 2

@[simp]
theorem scaledE8Vector_apply (z : Fin 8 → ℤ) (i : Fin 8) :
    scaledE8Vector z i = (z i : ℝ) / Real.sqrt 2 := rfl

/-! ## Scaled squared norm -/

/-- The squared norm of the scaled vector `z / √2` in `ℝ⁸`:
  `scaledSqNorm z = ∑ i, ((z i : ℝ) / √2)²`.

- **Integer norm 4 convention**: `sqNorm z = ∑ zᵢ²` (in `ℤ`).
- **Scaled real norm 2 convention**: `scaledSqNorm z = (∑ zᵢ²) / 2` (in `ℝ`). -/
noncomputable def scaledSqNorm (z : Fin 8 → ℤ) : ℝ :=
  ∑ i, (scaledE8Vector z i) ^ 2

/-- The scaled squared norm equals the integer squared norm divided by 2.

This is the bridge between the two conventions:
- **Integer norm 4**: `sqNorm z = 4` (minimum nonzero, in `ℤ`).
- **Scaled real norm 2**: `scaledSqNorm z = 2` (minimum nonzero, in `ℝ`). -/
theorem scaledSqNorm_eq_sqNorm_div_two (z : Fin 8 → ℤ) :
    scaledSqNorm z = (sqNorm z : ℝ) / 2 := by
  unfold scaledSqNorm sqNorm scaledE8Vector
  norm_num [Finset.sum_div _ _ _, div_pow]

/-- The minimum nonzero squared norm of the scaled E8 lattice is exactly **2**.

Combining:
1. `e8IntLattice_sqNorm_ge_four`: every nonzero `z ∈ e8IntLattice` has
   `sqNorm z ≥ 4` (integer norm 4 convention).
2. `e8IntLattice_achieves_sqNorm_four`: there exists `z` with `sqNorm z = 4`.
3. `scaledSqNorm_eq_sqNorm_div_two`: `scaledSqNorm z = sqNorm z / 2`.

We conclude `scaledSqNorm z ≥ 2` for all nonzero lattice vectors, with
equality attained (scaled real norm 2 convention). -/
theorem scaledE8_minSqNorm_two :
    (∀ z : Fin 8 → ℤ, z ∈ e8IntLattice → z ≠ 0 → 2 ≤ scaledSqNorm z) ∧
    (∃ z : Fin 8 → ℤ, z ∈ e8IntLattice ∧ z ≠ 0 ∧ scaledSqNorm z = 2) := by
  constructor
  · intro z hz hne
    have h_sqNorm : 4 ≤ sqNorm z := e8IntLattice_sqNorm_ge_four z hz hne
    rw [scaledSqNorm_eq_sqNorm_div_two]
    linarith [(by norm_cast : (4 : ℝ) ≤ sqNorm z)]
  · obtain ⟨z, hz₁, hz₂, hz₃⟩ := e8IntLattice_achieves_sqNorm_four
    exact ⟨z, hz₁, hz₂, by rw [scaledSqNorm_eq_sqNorm_div_two]; norm_num [hz₃]⟩

end PhysicsSM.Coding
