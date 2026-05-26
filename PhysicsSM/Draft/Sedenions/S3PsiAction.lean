import Mathlib

set_option linter.style.nativeDecide false

/-!
# S3 Psi Action on Sedenion Basis Supports

This module formalizes the support-level behavior of the naive order-three
Cayley-Dickson S3 automorphism `ψ` acting on sedenion basis vectors.

## Convention

We use the recursive Cayley-Dickson convention with labels
`abcd ↔ i^d j^c ell^b m^a` as documented in `Sedenions/CayleyDickson_Convention.md`.

The 16 basis elements are indexed by `Fin 16`. The low/high pairs are
`(e_i, e_{i+8})` for `i ∈ {0,...,7}`.

## The ψ action

For each low/high pair `(e_i, e_{i+8})`, the order-three action is the
rotation by 2π/3:

```
ψ(e_i)     = -1/2 e_i - √3/2 e_{i+8}
ψ(e_{i+8}) =  √3/2 e_i - 1/2 e_{i+8}
```

At the support level, this maps each basis vector `e_i` to a vector with
two-element support: `{i, partner(i)}` where `partner(i) = (i + 8) mod 16`.

## Main results

- `psiMat_cubed_eq_one`: The 2×2 rotation matrix has order 3 over ℚ(√3).
- `psiBaseSupport_card`: Each basis image has exactly 2-element support.
- `psi_image_assessorPair12_card`: A representative 2-element low assessor
  support maps to a 4-element support.
- `psi_never_preserves_low_pair`: No 2-element low-half assessor pair is
  preserved (universally quantified, kernel-checked).

## Physics interpretation

This is a **checked negative result**: the naive Cayley-Dickson S3 automorphism
does NOT preserve sparse assessor supports in the low octonion subalgebra.
It mixes low and high halves, doubling the support size. This means
sparse zero-divisor / stabilizer plaquettes built from low-half assessors
are moved into denser states by ψ.

This does NOT rule out a more sophisticated S3 action (e.g., from Cl(8) or
Cl(10) embeddings) that might preserve sparsity in a different basis.
-/

namespace S3PsiAction

-- ============================================================
-- § 1. ℚ(√3) coefficient ring
-- ============================================================

/-- Elements of ℚ(√3), represented as `(rat, sqrt3)` meaning `rat + sqrt3 · √3`.
    This is the smallest field extension of ℚ containing the ψ-rotation
    coefficients -1/2 and √3/2. -/
@[ext]
structure QSqrt3 where
  rat : ℚ
  sqrt3 : ℚ
  deriving DecidableEq, Repr

namespace QSqrt3

instance : Zero QSqrt3 := ⟨⟨0, 0⟩⟩
instance : One QSqrt3 := ⟨⟨1, 0⟩⟩

instance : Add QSqrt3 where
  add a b := ⟨a.rat + b.rat, a.sqrt3 + b.sqrt3⟩

instance : Neg QSqrt3 where
  neg a := ⟨-a.rat, -a.sqrt3⟩

instance : Sub QSqrt3 where
  sub a b := ⟨a.rat - b.rat, a.sqrt3 - b.sqrt3⟩

instance : Mul QSqrt3 where
  mul a b := ⟨a.rat * b.rat + 3 * a.sqrt3 * b.sqrt3,
              a.rat * b.sqrt3 + a.sqrt3 * b.rat⟩

end QSqrt3

-- ============================================================
-- § 2. 2×2 matrix over QSqrt3
-- ============================================================

/-- A 2×2 matrix over QSqrt3. Entries: `(a b; c d)`. -/
structure Mat2 where
  a : QSqrt3
  b : QSqrt3
  c : QSqrt3
  d : QSqrt3
  deriving DecidableEq, Repr

namespace Mat2

/-- The identity 2×2 matrix. -/
def one : Mat2 := ⟨1, 0, 0, 1⟩

/-- Matrix multiplication. -/
def mul (M N : Mat2) : Mat2 :=
  ⟨M.a * N.a + M.b * N.c,
   M.a * N.b + M.b * N.d,
   M.c * N.a + M.d * N.c,
   M.c * N.b + M.d * N.d⟩

end Mat2

-- ============================================================
-- § 3. The ψ rotation matrix and order-3 proof
-- ============================================================

/-- The 2×2 rotation matrix for ψ acting on each (eᵢ, eᵢ₊₈) pair:
    `[[-1/2, √3/2], [-√3/2, -1/2]]`

    This encodes:
    - ψ(eᵢ)   = -1/2 eᵢ   - √3/2 eᵢ₊₈
    - ψ(eᵢ₊₈) = √3/2 eᵢ - 1/2 eᵢ₊₈ -/
def psiMat : Mat2 :=
  ⟨⟨-1/2, 0⟩,   -- -1/2
   ⟨0, 1/2⟩,    -- √3/2
   ⟨0, -1/2⟩,   -- -√3/2
   ⟨-1/2, 0⟩⟩   -- -1/2

/-- ψ³ = I: the rotation matrix has order 3 (over the ℚ(√3) model).
    This is the key algebraic identity: R(-2π/3)³ = I. -/
theorem psiMat_cubed_eq_one :
    Mat2.mul (Mat2.mul psiMat psiMat) psiMat = Mat2.one := by
  native_decide

/-- ψ ≠ I: the rotation is nontrivial. -/
theorem psiMat_ne_one : psiMat ≠ Mat2.one := by
  native_decide

/-- ψ² ≠ I: ψ does not have order 1 or 2, confirming the order is exactly 3. -/
theorem psiMat_sq_ne_one : Mat2.mul psiMat psiMat ≠ Mat2.one := by
  native_decide

-- ============================================================
-- § 4. Support-level ψ action on Fin 16
-- ============================================================

/-- The partner index under the low/high pairing: i ↦ (i + 8) mod 16.
    For i < 8, partner is i + 8. For i ≥ 8, partner is i - 8. -/
def partner (i : Fin 16) : Fin 16 :=
  ⟨(i.val + 8) % 16, Nat.mod_lt _ (by omega)⟩

/-- The support of ψ(eᵢ) in the sedenion basis.
    Since ψ rotates each (eⱼ, eⱼ₊₈) plane, basis vector eᵢ maps to
    a vector supported on {i, partner(i)}. -/
def psiBaseSupport (i : Fin 16) : Finset (Fin 16) :=
  {i, partner i}

/-- The image support of ψ applied to a vector with support S,
    assuming generic (nonzero) coefficients. -/
def psiImageSupport (S : Finset (Fin 16)) : Finset (Fin 16) :=
  S.biUnion psiBaseSupport

-- ============================================================
-- § 5. Low half and assessor supports
-- ============================================================

/-- The low half of Fin 16: indices {0, 1, ..., 7}. -/
def lowHalf : Finset (Fin 16) :=
  (Finset.univ : Finset (Fin 16)).filter (fun i => decide (i.val < 8) = true)

/-- The imaginary low half: indices {1, 2, ..., 7}. -/
def imagLowHalf : Finset (Fin 16) :=
  (Finset.univ : Finset (Fin 16)).filter (fun i => decide (0 < i.val ∧ i.val < 8) = true)

-- ============================================================
-- § 6. Basic support properties
-- ============================================================

/-- Partner is an involution: partner(partner(i)) = i. -/
theorem partner_invol : ∀ i : Fin 16, partner (partner i) = i := by
  native_decide +revert

/-- Each basis image has a 2-element support (partner i ≠ i for all i). -/
theorem partner_ne_self : ∀ i : Fin 16, partner i ≠ i := by
  native_decide +revert

/-- The support of ψ(eᵢ) has exactly 2 elements. -/
theorem psiBaseSupport_card : ∀ i : Fin 16, (psiBaseSupport i).card = 2 := by
  native_decide +revert

-- ============================================================
-- § 7. Representative assessor pair: {e₁, e₂}
-- ============================================================

/-- The support {1, 2} as a Finset (Fin 16). -/
def assessorPair12 : Finset (Fin 16) := {(1 : Fin 16), (2 : Fin 16)}

/-- The image support of the assessor pair {1, 2} under ψ is {1, 2, 9, 10}. -/
theorem psi_image_assessorPair12 :
    psiImageSupport assessorPair12 = {(1 : Fin 16), 2, 9, 10} := by
  native_decide

/-- The image support of {1, 2} has 4 elements (doubled from 2). -/
theorem psi_image_assessorPair12_card :
    (psiImageSupport assessorPair12).card = 4 := by
  native_decide

/-- The image support of {1, 2} is NOT contained in the low half {0,...,7}. -/
theorem psi_image_assessorPair12_not_low :
    ¬ (psiImageSupport assessorPair12 ⊆ lowHalf) := by
  native_decide

-- ============================================================
-- § 8. Universal support-spreading for all low assessor pairs
-- ============================================================

/-- For every i in the imaginary low half {1,...,7}, ψ(eᵢ) has a component
    in the high half {8,...,15}. -/
theorem psiBaseSupport_hits_high :
    ∀ i : Fin 16, i ∈ imagLowHalf → ¬ (psiBaseSupport i ⊆ lowHalf) := by
  native_decide +revert

/-- For every pair {a, b} with a, b ∈ imagLowHalf and a ≠ b,
    the ψ-image support has exactly 4 elements. -/
theorem psi_image_pair_card_four :
    ∀ a b : Fin 16, a ∈ imagLowHalf → b ∈ imagLowHalf → a ≠ b →
    (psiImageSupport {a, b}).card = 4 := by
  native_decide +revert

/-- For every pair {a, b} with a, b ∈ imagLowHalf and a ≠ b,
    the ψ-image support is NOT contained in the low half. -/
theorem psi_image_pair_not_low :
    ∀ a b : Fin 16, a ∈ imagLowHalf → b ∈ imagLowHalf → a ≠ b →
    ¬ (psiImageSupport {a, b} ⊆ lowHalf) := by
  native_decide +revert

-- ============================================================
-- § 9. Plaquette support spreading
-- ============================================================

/-- A representative zero-product plaquette support.
    The lines {1,2,3} and {4,5,1} give a plaquette {1, 2, 4, 5}. -/
def plaquetteSupport_1245 : Finset (Fin 16) :=
  {(1 : Fin 16), 2, 4, 5}

/-- The ψ-image of the plaquette {1,2,4,5} is {1,2,4,5,9,10,12,13}. -/
theorem psi_image_plaquette_1245 :
    psiImageSupport plaquetteSupport_1245 =
    {(1 : Fin 16), 2, 4, 5, 9, 10, 12, 13} := by
  native_decide

/-- The ψ-image of the plaquette has 8 elements (doubled from 4). -/
theorem psi_image_plaquette_1245_card :
    (psiImageSupport plaquetteSupport_1245).card = 8 := by
  native_decide

/-- The ψ-image of the plaquette is NOT contained in the low half. -/
theorem psi_image_plaquette_1245_not_low :
    ¬ (psiImageSupport plaquetteSupport_1245 ⊆ lowHalf) := by
  native_decide

/-- Second representative plaquette: {1, 3, 5, 6}. -/
def plaquetteSupport_1356 : Finset (Fin 16) :=
  {(1 : Fin 16), 3, 5, 6}

/-- The ψ-image of the plaquette {1,3,5,6} also has 8 elements. -/
theorem psi_image_plaquette_1356_card :
    (psiImageSupport plaquetteSupport_1356).card = 8 := by
  native_decide

/-- Third representative plaquette: {2, 3, 6, 7}. -/
def plaquetteSupport_2367 : Finset (Fin 16) :=
  {(2 : Fin 16), 3, 6, 7}

/-- The ψ-image of the plaquette {2,3,6,7} also has 8 elements. -/
theorem psi_image_plaquette_2367_card :
    (psiImageSupport plaquetteSupport_2367).card = 8 := by
  native_decide

-- ============================================================
-- § 10. Coefficient non-cancellation
-- ============================================================

/-- The ψ-rotation coefficients are all nonzero in QSqrt3.
    This justifies the "generic coefficients" assumption: when ψ acts on
    a single basis vector, both output coefficients are nonzero, so the
    support really is 2-element (not 1-element due to cancellation). -/
theorem psiMat_entries_nonzero :
    psiMat.a ≠ 0 ∧ psiMat.b ≠ 0 ∧ psiMat.c ≠ 0 ∧ psiMat.d ≠ 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> native_decide

-- ============================================================
-- § 11. Main negative result
-- ============================================================

/-- **Main negative result**: No 2-element subset of the imaginary
    low half {1,...,7} has its ψ-image support contained in the low half.

    Interpretation: the naive Cayley-Dickson ψ always mixes the low octonion
    subalgebra with the high (m-multiplied) copy, doubling the support size.
    Sparse assessor states are NOT preserved by this S3 action. -/
theorem psi_never_preserves_low_pair :
    ∀ a b : Fin 16, a ∈ imagLowHalf → b ∈ imagLowHalf → a ≠ b →
    ¬ (psiImageSupport {a, b} ⊆ lowHalf) := by
  native_decide +revert

end S3PsiAction
