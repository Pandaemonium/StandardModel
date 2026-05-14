import Mathlib
import PhysicsSM.Coding.E8RootBridge

/-!
# Inner-product and isometry theorems for the E8 root bridge

This module strengthens the bijection theorem from `E8RootBridge.lean` by
proving that the bridge map `shortVectorToDoubledRoot` (Construction A short
vectors → octonionic doubled-coordinate roots) is compatible with the inner-
product structures on both sides.

## The two inner products

The two E8 models carry naturally normalised inner products:

| Model | Space | Inner product | Min squared norm |
|-------|-------|--------------|-----------------|
| Construction A | `Fin 8 → ℤ` | `intDot z₁ z₂ / 2` (after `1/√2` scaling) | 2 |
| Doubled coordinates | `Fin 8 → ℤ` | `dotD v₁ v₂ / 4` | 2 |

Both normalizations give squared norm 2 for root vectors: the Construction A
short vectors have `sqNorm = 4` (and scaled norm² = `4/2 = 2`), and the
octonionic roots have `normSqD = 8` (and actual norm² = `8/4 = 2`).

## Structure of the bridge map and isometry

The bridge map `shortVectorToDoubledRoot z` has two components:
1. **Linear core**: `h = H₈ z / 2` (Hadamard transform, divide by 2).
2. **Nonlinear parity correction**: adjust `h` so its coordinates all have
   the same parity (needed to satisfy the E8 root predicate `IsE8RootD`).

**The linear core is an isometry** (up to scaling): it scales all pairwise
inner products by 2 — `dotD(H₈z₁/2, H₈z₂/2) = 2 · intDot(z₁, z₂)` —
proved here as `hadamardHalf_isometry`.

**The parity correction preserves norms** but not general pairwise inner
products: each corrected vector still has `normSqD = 8` (root squared norm
2), but the parity correction mixes coordinates in a way that changes some
pairwise inner products. The full bridge map therefore preserves:
- Individual norms: `normSqD(bridge z) = 8 = 2 · sqNorm z` for all short `z`.
- The *set* of valid inner product values: all pairwise `dotD` of bridge images
  lie in `{-8, -4, 0, 4, 8}`, the E8 root inner product set.
But it does **not** necessarily preserve individual pairwise inner products
(only the Hadamard half-step does this, not the full parity-corrected bridge).

## Main results

- **`hadamard8_dot`**: abstract bilinear identity
  `intDot(H₈z₁, H₈z₂) = 8 · intDot(z₁, z₂)`, proved algebraically.

- **`shortVectorToDoubledRoot_normSqD`**: every bridge image has `normSqD = 8`.

- **`shortVectorToDoubledRoot_normSqD_eq_twice_sqNorm`**: the bridge doubles
  the squared norm: `normSqD(bridge z) = 2 · sqNorm z`.

- **`shortVectorToDoubledRoot_isometry_norm`**: the normalised squared norms
  agree: `normSqD(bridge z) / 4 = sqNorm z / 2` (both equal 2 for short vectors).

- **`shortVectorToDoubledRoot_dotD_values`**: pairwise `dotD` of bridge images
  lies in the valid E8 root inner-product set `{-8, -4, 0, 4, 8}`.

- **`hadamardHalf_isometry`**: the Hadamard half-step is a full inner-product
  isometry (up to factor 2): `dotD(H₈z₁/2, H₈z₂/2) / 4 = intDot(z₁, z₂) / 2`.

## Finite-computation trust note

The theorems over the 240-element short vector list use `native_decide`, which
introduces `Lean.trustCompiler`. The abstract `hadamard8_dot` identity is
proved purely algebraically (no `native_decide`).

## Source / provenance

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Ch. 7–8.
- Aristotle job S5 for PhysicsSM, 2026-05-07.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding.E8RootBridgeIsometry

open PhysicsSM.Coding
open PhysicsSM.Coding.E8RootBridge
open PhysicsSM.Algebra.Octonion.E8Root

/-! ## Integer dot product on ℤ⁸

We define the standard integer dot product `intDot z₁ z₂ = ∑ᵢ z₁ᵢ z₂ᵢ`
on the Construction A space `Fin 8 → ℤ`. Under the `1/√2` scaling, the
actual inner product of lattice vectors is `intDot z₁ z₂ / 2`.

Note: this is the same bilinear form as `intDotSPL` from
`E8SpherePackingShape.lean` (reintroduced here for namespace cleanliness
within this module's computations).
-/

/-- The integer dot product on `Fin 8 → ℤ`: `intDot z₁ z₂ = ∑ᵢ z₁ᵢ · z₂ᵢ`.

After the `1/√2` scaling that converts the Construction A lattice (min
`sqNorm = 4`) to the standard E8 root lattice (min squared norm 2), the
actual Euclidean inner product of vectors `z₁/√2` and `z₂/√2` is
`intDot z₁ z₂ / 2`. -/
def intDot (z w : Fin 8 → ℤ) : ℤ := ∑ i : Fin 8, z i * w i

/-- The dot product of a vector with itself equals the squared norm:
`intDot z z = sqNorm z`. -/
theorem intDot_self_eq_sqNorm (z : Fin 8 → ℤ) : intDot z z = sqNorm z := by
  simp [intDot, sqNorm, sq]

/-- `intDot` is symmetric: `intDot z₁ z₂ = intDot z₂ z₁`. -/
theorem intDot_comm (z w : Fin 8 → ℤ) : intDot z w = intDot w z := by
  simp [intDot, mul_comm]

/-! ## Abstract Hadamard bilinear identity

The 8×8 Sylvester-Hadamard matrix `H₈` satisfies `H₈ᵀ · H₈ = 8 · I₈`
(i.e., it is `√8` times an orthogonal matrix). This gives the fundamental
scaling identity for the inner product:

  `intDot(H₈z₁, H₈z₂) = 8 · intDot(z₁, z₂)`

The self-inner-product version `intDot(H₈z, H₈z) = 8 · sqNorm z` was already
proved in `E8HalfIntegerBridge.lean` as `hadamard8_sqNorm`. The present
theorem is the polarised bilinear version.

The proof is purely algebraic: expand `H₈` coordinatewise and use `ring!`
to verify the identity. No `native_decide` is needed.
-/

/-- **Hadamard bilinear identity**: the Hadamard transform scales the integer
dot product by 8.

  `intDot(H₈z₁, H₈z₂) = 8 · intDot(z₁, z₂)`

This follows from the orthogonality of `H₈/√8`, or equivalently from
`H₈ᵀ · H₈ = 8 · I₈`. The proof expands both sides using the explicit 8×8
definition of `H₈` (all entries ±1) and verifies the identity by `ring!`.

**No `native_decide`**: this is a purely algebraic identity, proved at the
level of formal polynomials. -/
theorem hadamard8_dot (z₁ z₂ : Fin 8 → ℤ) :
    intDot (Matrix.mulVec hadamard8 z₁) (Matrix.mulVec hadamard8 z₂) =
      8 * intDot z₁ z₂ := by
  unfold intDot
  unfold hadamard8; norm_num [Fin.sum_univ_succ, Matrix.mulVec]; ring!

/-! ## Norm-squared of mapped short vectors

The bridge map `shortVectorToDoubledRoot` sends each short Construction A
vector `z` (with `sqNorm z = 4`) to a vector in `E8Root.rootList` with
`normSqD = 8`. This is consistent with the E8 root predicate `IsE8RootD`
(which requires `normSqD = 8`).

Moreover, the bridge exactly doubles the squared norm: `normSqD(bridge z) = 2 · sqNorm z`.
Since `sqNorm z = 4`, this gives `normSqD = 8`.

**Normalisation check**:
- Construction A model: root squared norm = `sqNorm / 2 = 4/2 = 2`.
- Doubled-coordinate model: root squared norm = `normSqD / 4 = 8/4 = 2`.
Both give 2, the standard E8 root squared norm.
-/

/-- Every bridge-mapped short vector has doubled norm-squared equal to 8.

`normSqD = 8` is the E8 root condition in doubled coordinates. Combined with
`shortVectorToDoubledRoot_mem_rootList` (which also guarantees this via
`rootList_all_isE8RootD`), this gives two independent verifications.

Verified by `native_decide` over the 240-element short vector list. -/
theorem shortVectorToDoubledRoot_normSqD_forall :
    shortHammingE8VectorList.Forall
      (fun z => normSqD (shortVectorToDoubledRoot z) = 8) := by
  native_decide

/-- Pointwise version: for any short vector `z`, `normSqD(bridge z) = 8`. -/
theorem shortVectorToDoubledRoot_normSqD (z : Fin 8 → ℤ)
    (hz : z ∈ shortHammingE8VectorList) :
    normSqD (shortVectorToDoubledRoot z) = 8 :=
  List.forall_iff_forall_mem.mp shortVectorToDoubledRoot_normSqD_forall z hz

/-- The bridge map **doubles the squared norm**: `normSqD(bridge z) = 2 · sqNorm z`.

Since every short vector `z` satisfies `sqNorm z = 4`, this gives
`normSqD(bridge z) = 8`. The relationship `normSqD = 2 · sqNorm` captures
the coordinate scaling between the two models:
- A Construction A vector `z` has squared norm `sqNorm z = ∑ zᵢ²`.
- Its bridge image has doubled norm `normSqD = 2 · sqNorm z`.
This is consistent with the Hadamard scaling: `H₈ · z` has squared norm
`8 · sqNorm z`, and dividing by 2 gives `(H₈z/2)` with norm `2 · sqNorm z`.

Verified by `native_decide` over 240 short vectors. -/
theorem shortVectorToDoubledRoot_normSqD_eq_twice_sqNorm_forall :
    shortHammingE8VectorList.Forall
      (fun z => normSqD (shortVectorToDoubledRoot z) = 2 * sqNorm z) := by
  native_decide

/-- Pointwise version: `normSqD(bridge z) = 2 · sqNorm z`. -/
theorem shortVectorToDoubledRoot_normSqD_eq_twice_sqNorm (z : Fin 8 → ℤ)
    (hz : z ∈ shortHammingE8VectorList) :
    normSqD (shortVectorToDoubledRoot z) = 2 * sqNorm z :=
  List.forall_iff_forall_mem.mp
    shortVectorToDoubledRoot_normSqD_eq_twice_sqNorm_forall z hz

/-! ## Norm isometry (self-inner-product preservation)

The bridge map preserves the **normalised** self-inner-product (squared norm)
across the two coordinate conventions. Stated over ℚ to make the divisions
exact:

  `normSqD(bridge z) / 4 = sqNorm z / 2`

Both sides equal 2, the standard E8 root squared norm.
-/

/-- **Norm isometry theorem**: the bridge map preserves the normalised
squared norm across the two E8 models.

For every short vector `z`:
- LHS: `normSqD(bridge z) / 4` = actual octonionic squared norm
  (doubled-coordinate convention: divide by 4).
- RHS: `sqNorm z / 2` = actual Construction A squared norm
  (1/√2 scaling convention: divide by 2).

Both equal 2, the standard E8 root squared norm.

Stated over `ℚ` to make the division exact; follows from
`shortVectorToDoubledRoot_normSqD_eq_twice_sqNorm` by rational arithmetic. -/
theorem shortVectorToDoubledRoot_isometry_norm (z : Fin 8 → ℤ)
    (hz : z ∈ shortHammingE8VectorList) :
    (normSqD (shortVectorToDoubledRoot z) : ℚ) / 4 =
      (sqNorm z : ℚ) / 2 := by
  have h := shortVectorToDoubledRoot_normSqD_eq_twice_sqNorm z hz
  have : (normSqD (shortVectorToDoubledRoot z) : ℚ) = (2 * sqNorm z : ℤ) := by
    exact_mod_cast h
  rw [this]; push_cast; ring

/-! ## Pairwise inner products of bridge images

While the bridge map is not a linear map (the parity correction is nonlinear),
the pairwise `dotD` values of bridge images lie in the correct E8 root inner
product set `{-8, -4, 0, 4, 8}` (in doubled coordinates, corresponding to
actual values `{-2, -1, 0, 1, 2}`).

This is a 240 × 240 = 57,600-pair verification by `native_decide`, confirming
that the bridge images form a valid E8 root configuration: all Gram matrix
entries lie in the permitted set.

Note: this does NOT prove that the bridge preserves individual pairwise inner
products — only that the values lie in the right set. The Hadamard half-step
(without parity correction) is the map that actually preserves pairwise inner
products; see `hadamardHalf_isometry` below.
-/

/-- The pairwise `dotD` of bridge images takes values in `{-8, -4, 0, 4, 8}`.

In doubled coordinates, valid E8 root inner products are `{-8, -4, 0, 4, 8}`,
corresponding to actual inner products `{-2, -1, 0, 1, 2}`. The value 8
(= normSqD) occurs only for self-inner-products.

This proves that the 240 bridge images satisfy all pairwise E8 root system
constraints, even though the parity-correction step is nonlinear.

Verified by `native_decide` over all 57,600 pairs. -/
theorem shortVectorToDoubledRoot_dotD_values_forall :
    shortHammingE8VectorList.Forall (fun z₁ =>
      shortHammingE8VectorList.Forall (fun z₂ =>
        let d := dotD (shortVectorToDoubledRoot z₁) (shortVectorToDoubledRoot z₂)
        d = -8 ∨ d = -4 ∨ d = 0 ∨ d = 4 ∨ d = 8)) := by
  native_decide

/-- Pointwise version: for any `z₁, z₂ ∈ shortHammingE8VectorList`,
`dotD(bridge z₁, bridge z₂) ∈ {-8, -4, 0, 4, 8}`. -/
theorem shortVectorToDoubledRoot_dotD_values (z₁ z₂ : Fin 8 → ℤ)
    (h₁ : z₁ ∈ shortHammingE8VectorList)
    (h₂ : z₂ ∈ shortHammingE8VectorList) :
    let d := dotD (shortVectorToDoubledRoot z₁) (shortVectorToDoubledRoot z₂)
    d = -8 ∨ d = -4 ∨ d = 0 ∨ d = 4 ∨ d = 8 := by
  have := List.forall_iff_forall_mem.mp
    shortVectorToDoubledRoot_dotD_values_forall z₁ h₁
  exact List.forall_iff_forall_mem.mp this z₂ h₂

/-! ## Hadamard half-step isometry

The **Hadamard half-step** `h = H₈ z / 2` is the linear core of the bridge
map. Unlike the full bridge (which includes a nonlinear parity correction),
the Hadamard half-step is a genuine linear map that preserves all pairwise
inner products up to a factor of 2:

  `dotD(H₈z₁/2, H₈z₂/2) = 2 · intDot(z₁, z₂)`

This is the "inner-product isometry" property in the precise sense:
after the respective normalizations, `dotD(·,·)/4 = intDot(·,·)/2`.

The key step is the divisibility lemma (proved in `E8RootBridge.lean`): for
short Construction A vectors, every coordinate of `H₈z` is even, making
the division by 2 exact. Without this, `H₈z / 2` would not be well-defined
as an integer vector.

**Why the full bridge is not a linear isometry**: the parity correction
changes some coordinates to ensure they all have the same parity (even/odd).
This is needed for the image to satisfy `IsE8RootD` (the E8 root predicate),
but it is not a linear operation. For the 128 short vectors requiring the
parity correction, the full bridge image has the same norm as the Hadamard
half-step but different pairwise inner products.
-/

/-- The Hadamard half-step: `hadamardHalf z i = (H₈ z)ᵢ / 2` (integer division).

For short Construction A vectors, the divisibility `2 ∣ (H₈z)ᵢ` is guaranteed
by `hadamard_mulVec_even` from `E8RootBridge.lean`, making this exact. -/
def hadamardHalf (z : Fin 8 → ℤ) : Fin 8 → ℤ :=
  fun i => Matrix.mulVec hadamard8 z i / 2

/-- **Hadamard half-step inner-product scaling**: `dotD(H₈z₁/2, H₈z₂/2) = 2 · intDot(z₁, z₂)`
for all short Construction A vector pairs.

This follows from `hadamard8_dot` (`intDot(H₈z₁, H₈z₂) = 8 · intDot(z₁, z₂)`)
together with the divisibility `2 ∣ (H₈z)ᵢ` for short vectors:
  `dotD(H₈z₁/2, H₈z₂/2) = ∑ᵢ (H₈z₁)ᵢ/2 · (H₈z₂)ᵢ/2`
                         `= (1/4) · intDot(H₈z₁, H₈z₂)`
                         `= (1/4) · 8 · intDot(z₁, z₂)`
                         `= 2 · intDot(z₁, z₂)`.

Here verified by `native_decide` over all 57,600 pairs of short vectors
(the algebraic argument above works in principle but requires careful
handling of integer division). -/
theorem hadamardHalf_dotD_forall :
    shortHammingE8VectorList.Forall (fun z₁ =>
      shortHammingE8VectorList.Forall (fun z₂ =>
        dotD (hadamardHalf z₁) (hadamardHalf z₂) = 2 * intDot z₁ z₂)) := by
  native_decide

/-- Pointwise version: for short vectors `z₁, z₂`,
`dotD(H₈z₁/2, H₈z₂/2) = 2 · intDot(z₁, z₂)`. -/
theorem hadamardHalf_dotD (z₁ z₂ : Fin 8 → ℤ)
    (h₁ : z₁ ∈ shortHammingE8VectorList)
    (h₂ : z₂ ∈ shortHammingE8VectorList) :
    dotD (hadamardHalf z₁) (hadamardHalf z₂) = 2 * intDot z₁ z₂ := by
  have := List.forall_iff_forall_mem.mp hadamardHalf_dotD_forall z₁ h₁
  exact List.forall_iff_forall_mem.mp this z₂ h₂

/-- **Hadamard half-step isometry (ℚ form)**: the normalised inner products match.

  `dotD(H₈z₁/2, H₈z₂/2) / 4 = intDot(z₁, z₂) / 2`

Where:
- LHS: the actual inner product in the doubled-coordinate octonionic model
  (doubled coordinates divided by 4).
- RHS: the actual inner product in the Construction A model after `1/√2` scaling
  (integer coordinates divided by 2).

This is the formal statement that the Hadamard half-step is an isometry
between the two E8 inner-product spaces (up to the coordinate scalings of
each model). Stated over ℚ to make the divisions exact.

**Significance**: This confirms that the Construction A inner product structure
and the octonionic root inner product structure are compatible via the Hadamard
transform, strengthening the bridge theorem in `E8RootBridge.lean` from a
bijection of root sets to an isometry of inner-product structures (for the
linear part of the bridge map). -/
theorem hadamardHalf_isometry (z₁ z₂ : Fin 8 → ℤ)
    (h₁ : z₁ ∈ shortHammingE8VectorList)
    (h₂ : z₂ ∈ shortHammingE8VectorList) :
    (dotD (hadamardHalf z₁) (hadamardHalf z₂) : ℚ) / 4 =
      (intDot z₁ z₂ : ℚ) / 2 := by
  have h := hadamardHalf_dotD z₁ z₂ h₁ h₂
  have : (dotD (hadamardHalf z₁) (hadamardHalf z₂) : ℚ) =
      (2 * intDot z₁ z₂ : ℤ) := by exact_mod_cast h
  rw [this]; push_cast; ring

end PhysicsSM.Coding.E8RootBridgeIsometry
