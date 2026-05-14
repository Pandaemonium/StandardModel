import Mathlib
import PhysicsSM.Coding.ConstructionA
import PhysicsSM.Coding.HammingE8
import PhysicsSM.Coding.E8Basis
import PhysicsSM.Coding.E8HalfIntegerBridge
import PhysicsSM.Coding.E8SpherePackingShape

/-!
# Draft: Sphere-Packing-Lean bridge scaffold for the E8 lattice

## Purpose

This file prepares the strongest typechecked bridge scaffold between the
PhysicsSM Construction A model of the E8 lattice and the model used by
`math-inc/Sphere-Packing-Lean` (hereafter "SPL"), without pretending that
the SPL dependency is locally available.

## Our E8 model

In `PhysicsSM.Coding.HammingE8`, the E8 integer lattice is defined as:

```
e8IntLattice : AddSubgroup (Fin 8 → ℤ)
e8IntLattice = constructionA extendedHamming8
```

where membership satisfies `z ∈ e8IntLattice ↔ reduceModTwo z ∈ extendedHamming8`.
The minimum nonzero squared norm (sum of squares of integer coordinates) is 4.

After the standard `1/√2` scaling, this gives the E8 lattice with minimum
squared norm 2.

## Sphere-Packing-Lean's E8 model

Based on the SPL source at `SpherePacking/Dim8/E8/Basic.lean`, the E8 lattice
is defined via the half-integer/integer even-sum coordinate model:

```
-- Paraphrased from SPL (Apache-2.0); not imported.
-- A vector v : Fin 8 → ℝ belongs to the E8 lattice iff:
--   (1) all coordinates are integers, or all are half-integers (integer + 1/2)
--   (2) the sum of all coordinates is even
```

SPL also provides:
- `E8Matrix : Matrix (Fin 8) (Fin 8) ℤ` — the E8 Gram matrix (= Cartan matrix)
- `E8Matrix_unimodular` — proof that det(E8Matrix) = 1

The key declarations for a bridge would be `Submodule.E8` or an equivalent
lattice predicate.

## Bridge strategy

The correct bridge goes through a **change of basis** (via the Hadamard
transform for forward membership, and an explicit integer change-of-basis
matrix for Gram matrix identification), not through a simple `1/√2` coordinate
scaling.

### Dependency-free results (in `E8SpherePackingShape.lean`)

- **`e8IntLatticeSubmodule`**: the lattice as a `Submodule ℤ`, matching SPL's
  type shape.
- **`e8ScaledGramQ`**: the scaled Gram matrix with `det = 1` (unimodularity).
- **`e8BasisChangeMatrix`**: an explicit `8 × 8` integer matrix `P` with
  `det P = -1` satisfying `Pᵀ · e8CodeBasisGram · P = 2 · e8Cartan`
  (the Gram–Cartan bridge).
- **`e8SimpleRootBasis`**: explicit simple roots as lattice vectors, with
  verified inner products matching the E8 Cartan matrix.

### Results in this file

1. The **forward membership bridge** lifts the Hadamard embedding to the
   ℝ-valued half-integer predicate used by SPL.
2. Documentation of the remaining SPL-dependency blockers.

## Current blockers (genuine SPL dependencies)

1. **SPL is not a project dependency.** The `lakefile.toml` documents a Windows
   `Aux.lean` incompatibility (reserved filename). SPL cannot be imported on
   Windows; it could be imported on Linux/macOS by adding a `[[require]]` block.
   Until SPL is added as a dependency, we cannot `import SpherePacking.Dim8.E8.Basic`.

2. **No shared type universe.** Our model uses `Submodule ℤ (Fin 8 → ℤ)`;
   SPL's model may use `Submodule ℤ (Fin 8 → ℝ)` or a custom structure.
   The bridge theorem needs a coercion or embedding map.

3. **Basis identification across models.** Proving that the explicit
   Construction A basis, after change-of-basis, maps onto SPL's E8 basis
   requires SPL's `E8Matrix` definition to be importable.  The
   `e8BasisChange_gram_eq_cartan` theorem in `E8SpherePackingShape.lean`
   is the dependency-free half of this identification.

These three blockers are all downstream of adding SPL as a dependency;
no local `sorry` can resolve them.

## Provenance

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Chapters 7-8.
- `math-inc/Sphere-Packing-Lean`, Apache-2.0 license.
- Aristotle jobs H3, H5, H6, N5, P5 for PhysicsSM, 2026-05-07.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Draft.E8SpherePackingBridge

open PhysicsSM.Coding
open PhysicsSM.Lie.Exceptional.E8

/-! ## Half-integer/integer coordinate model (ℝ-valued)

This is the standard characterization of E8 lattice membership used by
Sphere-Packing-Lean and most lattice theory references. A vector
`v : Fin 8 → ℝ` belongs to the E8 lattice iff:
1. All coordinates are integers, or all coordinates are half-integers.
2. The sum of all eight coordinates is an even integer.
-/

/-- A real number is a half-integer if it equals an integer plus `1/2`. -/
def IsHalfInteger (x : ℝ) : Prop := ∃ n : ℤ, x = n + (1 : ℝ) / 2

/-- A real number is an integer (as an element of ℝ). -/
def IsIntegerReal (x : ℝ) : Prop := ∃ n : ℤ, x = (n : ℝ)

/-- The standard half-integer/integer even-sum E8 membership predicate.

A vector `v : Fin 8 → ℝ` belongs to the E8 lattice iff:
1. All coordinates are integers, or all are half-integers.
2. The sum of all coordinates is an even integer (i.e., `∃ k : ℤ, ∑ v i = 2 * k`).

This is the coordinate model used by Sphere-Packing-Lean and by Conway-Sloane.
-/
def e8HalfIntegerPredicate (v : Fin 8 → ℝ) : Prop :=
  ((∀ i, IsIntegerReal (v i)) ∨ (∀ i, IsHalfInteger (v i))) ∧
  (∃ k : ℤ, ∑ i, v i = 2 * (k : ℝ))

/-! ## Scaling map from integer Construction A to real coordinates -/

/-- Cast an integer vector to a real vector. -/
def intVecToReal (z : Fin 8 → ℤ) : Fin 8 → ℝ :=
  fun i => (z i : ℝ)

/-- Scale an integer vector by `1 / √2` to get the standard E8 normalization.
After this scaling, the Construction A lattice has minimum squared norm 2. -/
noncomputable def e8IntToScaled (z : Fin 8 → ℤ) : Fin 8 → ℝ :=
  fun i => (z i : ℝ) / Real.sqrt 2

/-- The squared Euclidean norm of a real vector. -/
def realSqNorm (v : Fin 8 → ℝ) : ℝ :=
  ∑ i, v i ^ 2

/-- The scaled squared norm equals half the integer squared norm. -/
theorem e8IntToScaled_sqNorm (z : Fin 8 → ℤ) :
    realSqNorm (e8IntToScaled z) = (sqNorm z : ℝ) / 2 := by
  simp only [realSqNorm, e8IntToScaled, sqNorm, div_pow,
    Real.sq_sqrt two_pos.le]
  push_cast
  rw [Finset.sum_div]

/-! ## Integer dot product -/

/-- Integer dot product (bilinear form on `Fin 8 → ℤ`). -/
def intDot (u v : Fin 8 → ℤ) : ℤ :=
  ∑ i, u i * v i

/-! ## Construction A basis ↔ Gram matrix bridge

The explicit Construction A basis from `E8Basis.lean` has Gram matrix
`e8CodeBasisGram` with `det = 256`. After `1/√2` scaling, the Gram matrix
becomes `e8CodeBasisGram / 2` (over ℝ) with determinant `256 / 2⁸ = 1`,
confirming unimodularity.

The **Gram–Cartan basis-change** (proved in `E8SpherePackingShape.lean`)
provides the explicit integer matrix `P = e8BasisChangeMatrix` with
`det P = -1` satisfying:

  `Pᵀ · e8CodeBasisGram · P = 2 · e8Cartan`

This proves that the Construction A lattice and the standard simple-root
lattice are isometric: both are rank-8 even unimodular lattices with the
same Gram structure, connected by the unimodular change-of-basis `P`.
-/

/-- The Gram matrix of the explicit basis equals the declared `e8CodeBasisGram`.
This is a definitional bridge connecting `intDot` (used here) with the
inner product form used in `E8Basis.lean`. -/
theorem e8CodeBasisInt_intDot_eq_gram (i j : Fin 8) :
    intDot (e8CodeBasisInt i) (e8CodeBasisInt j) = e8CodeBasisGram i j := by
  rw [intDot]
  rw [← e8CodeBasisGram_eq i j]

/--
The scaled Gram matrix: after `1/√2` scaling, the real inner product
of basis vectors equals `e8CodeBasisGram i j / 2`.
-/
theorem e8CodeBasisInt_scaled_gram (i j : Fin 8) :
    (∑ k, e8IntToScaled (e8CodeBasisInt i) k *
          e8IntToScaled (e8CodeBasisInt j) k) =
      (e8CodeBasisGram i j : ℝ) / 2 := by
  unfold e8IntToScaled
  norm_num [div_mul_div_comm, ← sq, e8CodeBasisGram_eq]
  rw [Finset.sum_div _ _ _]

/-! ## Forward membership bridge via Hadamard embedding

The correct bridge from the Construction A integer model to the half-integer
model goes through the **Hadamard transform**, not through a simple `1/√2`
coordinate scaling. The integrated `E8HalfIntegerBridge` module proves:

- `hadamard8_maps_constructionA_to_halfIntE8`: `H₈ z ∈ halfIntE8Doubled`
  for all `z ∈ e8IntLattice`.
- `halfIntE8Doubled_to_predicate`: the halved vector satisfies the
  `halfIntegerE8Predicate` (over ℚ).
- `hadamard8_sqNorm`: `‖H₈ z‖² = 8 · ‖z‖²`.
- `scaledE8_eq_halfIntegerE8`: both models share minimum normalised
  squared norm 2.
-/

/-! ## Documented handoff: what remains for the full bridge

### Step 1: Add SPL as a dependency (Linux/macOS only)

Add to `lakefile.toml`:
```toml
[[require]]
name = "SpherePacking"
git = "https://github.com/math-inc/Sphere-Packing-Lean"
rev = "main"
```

### Step 2: Import SPL's E8 definitions

```lean
import SpherePacking.Dim8.E8.Basic
```

This provides access to `Submodule.E8`, `E8Matrix`, `E8Matrix_unimodular`,
and the lattice structure used in the sphere-packing optimality proof.

### Step 3: Prove the definitional bridge

The strongest bridge theorem would combine:

1. **`e8IntLatticeSubmodule`** (from `E8SpherePackingShape.lean`): our lattice
   as a `Submodule ℤ (Fin 8 → ℤ)`.

2. **`e8BasisChange_gram_eq_cartan`** (from `E8SpherePackingShape.lean`):
   `Pᵀ · e8CodeBasisGram · P = 2 · e8Cartan`, confirming that the change of
   basis maps our lattice isometrically onto the standard E8 root lattice.

3. An **embedding map** `φ : (Fin 8 → ℤ) →ₗ[ℤ] (Fin 8 → ℝ)` composed with
   the basis change, landing in SPL's `Submodule.E8`.

The theorem would then be:

```lean
theorem e8IntLattice_eq_spl_E8 :
    (image of e8IntLattice under embedding ∘ basis change) = Submodule.E8
```

### Step 4: Connect to the sphere-packing optimality theorem

SPL proves that the E8 lattice packing is optimal in dimension 8. The
bridge theorem from Step 3 would then give:

```lean
theorem constructionA_E8_packing_optimal :
    -- The Construction A lattice from the extended Hamming code,
    -- after 1/√2 scaling, achieves the optimal sphere packing
    -- density in dimension 8.
    sorry
```

This final theorem is explicitly NOT claimed here. It depends on the full
analytic machinery of Viazovska's proof, which is formalized in SPL.

### Blocker summary

| Blocker | Impact | Resolution |
|---------|--------|------------|
| SPL not importable (Windows `Aux.lean`) | Cannot state definitional bridge | Use Linux/WSL2 or rename file in SPL fork |
| SPL not in `lakefile.toml` dependencies | Cannot import SPL modules | Add `[[require]]` block |
| No `Submodule` wrapper for `e8IntLattice` | Type mismatch with SPL's `Submodule` | **Resolved**: `e8IntLatticeSubmodule` in `E8SpherePackingShape.lean` |
| Gram matrix identification | Need to match SPL's `E8Matrix` | **Half resolved**: `e8BasisChange_gram_eq_cartan` proves the integer identity; SPL import needed for definitional match |
-/

end PhysicsSM.Draft.E8SpherePackingBridge
