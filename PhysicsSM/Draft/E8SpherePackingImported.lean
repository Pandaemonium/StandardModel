import Mathlib
import SpherePacking.Dim8.E8.Basic
import SpherePacking.Dim8.E8.Packing
import PhysicsSM.Coding.E8SpherePackingMatrixBridge
import PhysicsSM.Draft.E8SpherePackingIsometryHelper

/-!
# Direct Sphere-Packing-Lean import bridge for the E8 lattice

## Purpose

This file performs the **actual import-level bridge** between the PhysicsSM
Construction A model of the E8 lattice and the model used by
`math-inc/Sphere-Packing-Lean` (SPL). It requires SPL as a Lake dependency
and directly imports `SpherePacking.Dim8.E8.Basic` and
`SpherePacking.Dim8.E8.Packing`.

## Platform note

Upstream SPL contains files named `Aux.lean` (a Windows reserved device name).
This checkout uses the local Windows-safe fork under `AgentTasks/external`,
where those files have been renamed to `Auxiliary.lean`. The bridge is still
kept behind the optional `PhysicsSMSPL` root so that the default `PhysicsSM`
target stays independent of the direct SPL dependency.

## SPL declarations confirmed (with exact types)

From `SpherePacking.Dim8.E8.Basic`:
- `Submodule.E8 : (R : Type*) → [Field R] → [NeZero (2 : R)] → Submodule ℤ (Fin 8 → R)`
- `E8Matrix : (R : Type*) → [Field R] → Matrix (Fin 8) (Fin 8) R`
- `E8Matrix_unimodular : ∀ (R : Type*) [Field R] [NeZero (2 : R)], (E8Matrix R).det = 1`
- `span_E8Matrix : ∀ (R : Type*) [Field R] [CharZero R],
    Submodule.span ℤ (Set.range (E8Matrix R).row) = Submodule.E8 R`
- `E8_integral_self : ∀ {R : Type*} [Field R] [CharZero R],
    ∀ v ∈ Submodule.E8 R, ∃ z, Even z ∧ ↑z = v ⬝ᵥ v`

From `SpherePacking.Dim8.E8.Packing`:
- `E8Lattice : Submodule ℤ (EuclideanSpace ℝ (Fin 8))`
- `E8Packing : PeriodicSpherePacking 8`
- `E8Packing_density : E8Packing.density = ENNReal.ofReal Real.pi ^ 4 / 384`

## Bridge strategy

The central result is `local_splE8BasisQ_eq_imported_E8Matrix_Q`, which proves
that our local ℚ-valued reproduction `splE8BasisQ` from
`E8SpherePackingMatrixBridge` is **identical** to SPL's `E8Matrix ℚ`
(verified by `native_decide` over the finite 8×8 rational matrix).

From this, `span_E8Matrix ℚ` immediately gives the submodule equality:

  `Submodule.span ℤ (Set.range splE8BasisQ.row) = Submodule.E8 ℚ`

Combined with the Gram congruence chain from `E8SpherePackingMatrixBridge`,
this connects the Construction A model to `Submodule.E8` via an explicit
unimodular change-of-basis path.

## Finite-computation trust boundary

Matrix equalities over explicit 8×8 matrices use `native_decide`, introducing
`Lean.trustCompiler` into the axiom set.

## Source / provenance

- `math-inc/Sphere-Packing-Lean`, Apache-2.0 license, commit 1e98fb49.
- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Ch. 7–8.
- Aristotle jobs SPL2 and FB2 for PhysicsSM, 2026-05-07/08.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false
set_option linter.unusedSimpArgs false
set_option linter.unusedVariables false

namespace PhysicsSM.Draft.E8SpherePackingImported

open PhysicsSM.Coding
open PhysicsSM.Lie.Exceptional.E8

/-! ## Section 1: Type confirmations

These declarations confirm the exact types of SPL declarations
as visible from this project. They serve as compile-time type witnesses.
-/

section TypeConfirmations

/-- Confirm: `Submodule.E8` type. -/
noncomputable example : Submodule ℤ (Fin 8 → ℝ) := Submodule.E8 ℝ

/-- Confirm: `E8Matrix` type. -/
noncomputable example : Matrix (Fin 8) (Fin 8) ℝ := E8Matrix ℝ

/-- Confirm: `E8Matrix_unimodular`. -/
noncomputable example : (E8Matrix ℝ).det = 1 := E8Matrix_unimodular ℝ

/-- Confirm: `span_E8Matrix`. -/
noncomputable example :
    Submodule.span ℤ (Set.range (E8Matrix ℝ).row) = Submodule.E8 ℝ :=
  span_E8Matrix ℝ

/-- Confirm: `E8_integral_self`. -/
noncomputable example (v : Fin 8 → ℝ) (hv : v ∈ Submodule.E8 ℝ) :
    ∃ z : ℤ, Even z ∧ (z : ℝ) = v ⬝ᵥ v :=
  E8_integral_self v hv

/-- Confirm: `E8Lattice` type. -/
noncomputable example : Submodule ℤ (EuclideanSpace ℝ (Fin 8)) := E8Lattice

/-- Confirm: `E8Packing` type. -/
noncomputable example : PeriodicSpherePacking 8 := E8Packing

/-- Confirm: `E8Packing_density`. -/
noncomputable example :
    E8Packing.density = ENNReal.ofReal Real.pi ^ 4 / 384 :=
  E8Packing_density

end TypeConfirmations

/-! ## Section 2: Matrix equality — local reproduction = imported SPL

The central bridging fact: our local `splE8BasisQ` (from
`E8SpherePackingMatrixBridge`, defined as an explicit `!![ ... ]` matrix)
is **identical** to SPL's `E8Matrix ℚ` (from `SpherePacking.Dim8.E8.Basic`).

Both are `Matrix (Fin 8) (Fin 8) ℚ` defined as the same explicit matrix
literal. The proof is a finite decidable computation.
-/

/-- **Matrix equality: local reproduction = imported SPL E8 basis.**

`splE8BasisQ` (our ℚ-valued reproduction of the SPL basis from
`E8SpherePackingMatrixBridge`) is identical to `E8Matrix ℚ` (SPL's
definition imported from `SpherePacking.Dim8.E8.Basic`).

This is verified by `native_decide` over the 64 rational entries. -/
theorem local_splE8BasisQ_eq_imported_E8Matrix_Q :
    splE8BasisQ = E8Matrix ℚ := by
  native_decide

/-! ## Section 3: Span equality — splE8BasisQ row-span = Submodule.E8

The main target theorem: the ℤ-span of the rows of our local `splE8BasisQ`
equals SPL's `Submodule.E8 ℚ`.

Proof: rewrite `splE8BasisQ` to `E8Matrix ℚ` using the matrix equality,
then apply SPL's `span_E8Matrix ℚ`.
-/

/-- **The ℤ-span of our local SPL basis rows equals imported `Submodule.E8 ℚ`.**

This connects the local matrix bridge infrastructure from
`E8SpherePackingMatrixBridge` to SPL's submodule definition. -/
theorem local_splE8BasisQ_span_eq_imported_E8_Q :
    Submodule.span ℤ (Set.range splE8BasisQ.row) =
      Submodule.E8 ℚ := by
  rw [local_splE8BasisQ_eq_imported_E8Matrix_Q]
  exact span_E8Matrix ℚ

/-! ## Section 4: Membership characterization

SPL's `Submodule.mem_E8` is not `public`, but the definition unfolds by `rfl`.
We restate the membership characterization here for use in bridge proofs.
-/

/-- Membership in `Submodule.E8 R` unfolds to the half-integer/integer
even-sum predicate. Restates SPL's non-public `Submodule.mem_E8`. -/
theorem mem_E8_iff {R : Type*} [Field R] [NeZero (2 : R)] (v : Fin 8 → R) :
    v ∈ Submodule.E8 R ↔
      ((∀ i, ∃ n : ℤ, (n : R) = v i) ∨
       (∀ i, ∃ n : ℤ, Odd n ∧ (n : R) = 2 • v i)) ∧
      ∑ i, v i ≡ 0 [PMOD (2 : R)] :=
  Iff.rfl

/-! ## Section 5: Gram matrix bridge with imported SPL

SPL's Gram matrix (`E8Matrix * E8Matrixᵀ`) has determinant 1.
Our `spl_gram_congruent_to_scaled_constructionA` (from
`E8SpherePackingMatrixBridge`) proves:
- `D · splE8GramQ · Dᵀ = e8Cartan` (SPL side)
- `Pᵀ · e8ScaledGramQ · P = e8Cartan` (Construction A side)

Since `splE8BasisQ = E8Matrix ℚ` (Section 2), the SPL side is also
the Gram of `E8Matrix ℚ`. This gives a three-way Gram congruence:

  SPL Gram ←→ e8Cartan ←→ Construction A scaled Gram
-/

/-- SPL's Gram matrix has determinant 1 (follows from det(E8Matrix) = 1). -/
theorem splGramDet : (E8Matrix ℚ * (E8Matrix ℚ).transpose).det = 1 := by
  simp [Matrix.det_mul, Matrix.det_transpose, E8Matrix_unimodular ℚ]

/-- **SPL Gram is our local Gram (confirmed by matrix equality).**

`splE8GramQ = E8Matrix ℚ * (E8Matrix ℚ)ᵀ`, since `splE8BasisQ = E8Matrix ℚ`
and `splE8GramQ = splE8BasisQ * splE8BasisQᵀ`. -/
theorem splE8GramQ_eq_imported :
    splE8GramQ = E8Matrix ℚ * (E8Matrix ℚ).transpose := by
  rw [← local_splE8BasisQ_eq_imported_E8Matrix_Q]
  exact splE8GramQ_eq

/-! ## Section 6: Composition theorem — Construction A bridge to Submodule.E8

This is the strongest available composition connecting the local
Construction A matrix bridge to the imported `Submodule.E8`.

### What is proved:

1. The local SPL basis `splE8BasisQ` is identical to `E8Matrix ℚ`.
2. The ℤ-span of `splE8BasisQ` rows equals `Submodule.E8 ℚ`.
3. The Gram matrix of this basis (`splE8GramQ`) is congruent to
   `e8Cartan` via the transition matrix `splToCartanTransition`.
4. The Construction A scaled Gram (`e8ScaledGramQ`) is also congruent
   to `e8Cartan` via `e8BasisChangeMatrix`.
5. The composite unimodular change of basis `P⁻¹ · D` maps the
   Construction A basis to the SPL basis (and hence into `Submodule.E8`).

### Result shape:

Both Gram matrices are congruent to `e8Cartan`, and the SPL basis
spans `Submodule.E8 ℚ`. This gives an explicit checked bridge path:

  Construction A basis
    →[e8BasisChangeMatrix] e8 simple roots
    →[splToCartanTransition⁻¹] SPL basis (= E8Matrix ℚ rows)
    →[span_E8Matrix] Submodule.E8 ℚ
-/

/-- **Full composition: Construction A Gram congruence + imported span equality.**

Combines the three-way Gram congruence from `E8SpherePackingMatrixBridge`
with the imported `span_E8Matrix` to connect the Construction A model to
`Submodule.E8 ℚ` via an explicit checked path.

Components:
1. `splE8BasisQ = E8Matrix ℚ` (matrix equality)
2. `span(E8Matrix ℚ rows) = Submodule.E8 ℚ` (from SPL)
3. SPL Gram congruent to Cartan (from local bridge)
4. Construction A scaled Gram congruent to Cartan (from local bridge)
5. Both transition matrices are unimodular
-/
theorem constructionA_to_E8_full_bridge :
    -- (1) Matrix equality
    splE8BasisQ = E8Matrix ℚ
    ∧
    -- (2) Span equality
    Submodule.span ℤ (Set.range splE8BasisQ.row) = Submodule.E8 ℚ
    ∧
    -- (3) SPL Gram → Cartan
    (splToCartanTransition.map (Int.castRingHom ℚ)) *
      splE8GramQ *
      (splToCartanTransition.map (Int.castRingHom ℚ)).transpose =
    (e8Cartan.map (Int.castRingHom ℚ))
    ∧
    -- (4) Construction A scaled Gram → Cartan
    (e8BasisChangeMatrix.map (Int.castRingHom ℚ)).transpose *
      e8ScaledGramQ *
      (e8BasisChangeMatrix.map (Int.castRingHom ℚ)) =
    (e8Cartan.map (Int.castRingHom ℚ))
    ∧
    -- (5) Unimodularity
    splToCartanTransition.det = -1 ∧ e8BasisChangeMatrix.det = -1 :=
  ⟨local_splE8BasisQ_eq_imported_E8Matrix_Q,
   local_splE8BasisQ_span_eq_imported_E8_Q,
   splGram_to_cartan,
   constructionA_scaledGram_to_cartan,
   splToCartanTransition_det,
   e8BasisChangeMatrix_det⟩

/-! ## Section 7: Integer and half-integer vectors ∈ Submodule.E8 ℝ

These theorems connect the Construction A membership predicate
to SPL's definition by showing that integer vectors (with even sum)
and half-integer vectors (with even sum) lie in `Submodule.E8 ℝ`.
-/

/-- An integer vector with even coordinate sum lies in `Submodule.E8 ℝ`. -/
theorem intVec_even_sum_mem_E8 (v : Fin 8 → ℤ)
    (hsum : Even (∑ i, v i)) :
    (fun i => (v i : ℝ)) ∈ Submodule.E8 ℝ := by
  rw [mem_E8_iff]
  refine ⟨Or.inl (fun i => ⟨v i, rfl⟩), ?_⟩
  obtain ⟨k, hk⟩ := hsum
  have h1 : (∑ i : Fin 8, (v i : ℝ)) = ((∑ i, v i : ℤ) : ℝ) := by push_cast; rfl
  rw [h1, hk, show ((k + k : ℤ) : ℝ) = k • (2 : ℝ) from by push_cast; ring]
  exact AddCommGroup.zsmul_modEq_zero (p := (2 : ℝ)) k

/-- Half-integer vectors (integer + 1/2 in each coordinate) with even
coordinate sum lie in `Submodule.E8 ℝ`. -/
theorem halfIntVec_even_sum_mem_E8 (v : Fin 8 → ℤ)
    (hsum : Even (∑ i, v i)) :
    (fun i => ((v i : ℝ) + 1/2)) ∈ Submodule.E8 ℝ := by
  rw [mem_E8_iff]
  refine ⟨Or.inr (fun i => ⟨2 * v i + 1, Int.odd_iff.mpr (by omega), ?_⟩), ?_⟩
  · push_cast; ring
  · rw [show ∑ i : Fin 8, ((v i : ℝ) + 1/2) = (∑ i : Fin 8, (v i : ℝ)) + 4 from by
      simp [Finset.sum_add_distrib, Finset.sum_const, Finset.card_univ]; ring]
    obtain ⟨k, hk⟩ := hsum
    have h1 : (∑ i : Fin 8, (v i : ℝ)) = ((∑ i, v i : ℤ) : ℝ) := by push_cast; rfl
    rw [h1, hk, show ((k + k : ℤ) : ℝ) + 4 = (k + 2) • (2 : ℝ) from by push_cast; ring]
    exact AddCommGroup.zsmul_modEq_zero (p := (2 : ℝ)) (k + 2)

/-! ## Section 8: Density transport -/

/-- **Transported density theorem (direct from SPL).**

The E8 lattice packing has density `π⁴ / 384`. This is a direct
re-export of SPL's `E8Packing_density`, confirmed to typecheck
against the actual SPL import. -/
theorem e8_packing_density_from_spl :
    E8Packing.density = ENNReal.ofReal Real.pi ^ 4 / 384 :=
  E8Packing_density

/-- **Density with full provenance chain.**

The density `π⁴/384` is proved for `E8Packing`, which is built from
`E8Lattice`, which is built from `Submodule.E8 ℝ`. By the bridge
theorems above:
- `splE8BasisQ = E8Matrix ℚ` (Section 2)
- `span(splE8BasisQ rows) = Submodule.E8 ℚ` (Section 3)
- `splE8GramQ` congruent to `e8Cartan` congruent to `e8ScaledGramQ` (Section 5)

So the density result applies to the same abstract lattice that our
Construction A model describes, modulo the documented scaling
(Construction A norm² is 2× the standard half-integer norm²).

The remaining kernel-checked gap for full density transfer to
`e8IntLatticeSubmodule` is the explicit `LinearEquiv` or `LinearMap`
from our ℤ⁸ Construction A basis to `(Fin 8 → ℝ)` landing in
`Submodule.E8 ℝ`, which requires composing `e8BasisChangeMatrix` with
`splToCartanTransition⁻¹` over ℝ. -/
theorem e8_density_with_bridge_documentation :
    E8Packing.density = ENNReal.ofReal Real.pi ^ 4 / 384
    ∧ splE8BasisQ = E8Matrix ℚ
    ∧ Submodule.span ℤ (Set.range splE8BasisQ.row) = Submodule.E8 ℚ :=
  ⟨E8Packing_density,
   local_splE8BasisQ_eq_imported_E8Matrix_Q,
   local_splE8BasisQ_span_eq_imported_E8_Q⟩

/-! ## Section 9: Integer linear combinations of E8Matrix rows ∈ E8 -/

/-- Any integer linear combination of E8Matrix rows is in `Submodule.E8 ℝ`. -/
theorem intLinComb_E8Matrix_mem_E8 (c : Fin 8 → ℤ) :
    ∑ i : Fin 8, (c i) • (E8Matrix ℝ).row i ∈ Submodule.E8 ℝ := by
  rw [← span_E8Matrix ℝ]
  exact Submodule.sum_mem _ fun i _ =>
    Submodule.smul_mem _ _ (Submodule.subset_span ⟨i, rfl⟩)

/-! ## Section 10: Composite transition: Construction A → SPL coordinates

The transition matrix `T = Dᵀ · P⁻¹` where:
- `D = splToCartanTransition` (SPL basis → Cartan simple-root basis)
- `P = e8BasisChangeMatrix` (Construction A basis → Cartan simple-root basis)

maps Construction A basis coefficients to SPL basis coefficients.

Since both `D` and `P` are unimodular integer matrices (`det = ±1`),
their composition `T` is also unimodular integer (`det = 1`).

Key properties (all verified by `native_decide`):
1. `T · P = Dᵀ` (factorization identity, equivalent to `T = Dᵀ · P⁻¹`)
2. `det T = 1` (unimodularity)
3. `Tᵀ · G_spl · T = G_CA_scaled` (Gram congruence: inner products match)
-/

/-- The composite transition matrix from Construction A coordinates to SPL
coordinates.

Given a coefficient vector `c : Fin 8 → ℤ` in the Construction A basis
(`e8CodeBasisInt`), the vector `constructionAToSPLTransition.mulVec c` gives
the coefficients in the SPL basis (`E8Matrix ℝ` rows) for the same abstract
lattice point.

Computed as `Dᵀ · P⁻¹` where `D = splToCartanTransition` and
`P = e8BasisChangeMatrix`. -/
def constructionAToSPLTransition : Matrix (Fin 8) (Fin 8) ℤ := !![
  -4, -2, -1, -2,  0, -1, -2, -2;
  -7, -3, -1, -3,  0, -1, -3, -3;
  -6, -3, -1, -2, -1, -1, -2, -3;
  -5, -3, -1, -2, -1,  0, -2, -3;
  -4, -2, -1, -1,  0,  0, -1, -3;
  -3, -1, -1, -1,  0,  0, -1, -2;
  -2, -1, -1, -1,  0,  0,  0, -1;
   2,  1,  0,  1,  0,  0,  1,  1]

set_option maxHeartbeats 800000 in
-- 8×8 integer determinant requires expanded Leibniz formula
/-- The transition matrix has determinant 1 (unimodular, orientation-preserving). -/
theorem constructionAToSPLTransition_det :
    constructionAToSPLTransition.det = 1 := by
  norm_num [Matrix.det_apply'] at *
  native_decide +revert

/-- **Factorization identity: `T · P = Dᵀ`.**

This is equivalent to `T = Dᵀ · P⁻¹` (since `P` is invertible over ℤ),
confirming that `T` is the correct composite transition matrix.
Verified as a finite identity over 64 integer entries. -/
theorem constructionAToSPLTransition_factorization :
    constructionAToSPLTransition * e8BasisChangeMatrix =
    splToCartanTransition.transpose := by
  native_decide

/-- **Gram congruence: `Tᵀ · G_spl · T = G_CA_scaled`.**

The transition matrix preserves the Gram structure: the scaled Construction A
Gram matrix (`e8ScaledGramQ = e8CodeBasisGram / 2`) equals the SPL Gram
matrix (`splE8GramQ`) conjugated by `T`.

This means: for CA basis coefficient vectors `c₁, c₂`,
`⟨φ(c₁), φ(c₂)⟩_euclidean = c₁ᵀ · G_CA_scaled · c₂`
where `φ` is the composite embedding. -/
theorem constructionAToSPLTransition_gram :
    (constructionAToSPLTransition.map (Int.castRingHom ℚ)).transpose *
    splE8GramQ *
    (constructionAToSPLTransition.map (Int.castRingHom ℚ)) = e8ScaledGramQ := by
  native_decide

/-! ## Section 11: ℤ-linear embedding into Submodule.E8 ℝ

Using the transition matrix `T`, we define a ℤ-linear map

  `φ : (Fin 8 → ℤ) →ₗ[ℤ] (Fin 8 → ℝ)`

that sends CA basis coefficient vectors to elements of `Submodule.E8 ℝ`
(the imported SPL E8 lattice).

The map is:
  `φ(c) = ∑ i, (T.mulVec c)ᵢ • (E8Matrix ℝ).row i`

i.e., first convert CA coefficients to SPL coefficients via `T`, then take
the corresponding integer linear combination of SPL basis rows.
-/

/-- The ℤ-linear embedding from Construction A coefficient space into ℝ⁸,
landing in `Submodule.E8 ℝ`.

Maps a coefficient vector `c` (in the Construction A basis `e8CodeBasisInt`)
to the ℝ⁸ vector obtained by:
1. Converting to SPL basis coefficients via `constructionAToSPLTransition`.
2. Taking the integer linear combination of `(E8Matrix ℝ)` rows with those
   coefficients. -/
noncomputable def constructionAToE8 : (Fin 8 → ℤ) →ₗ[ℤ] (Fin 8 → ℝ) where
  toFun c := ∑ i : Fin 8,
    (constructionAToSPLTransition.mulVec c i) • (E8Matrix ℝ).row i
  map_add' x y := by
    simp only [Matrix.mulVec_add, Pi.add_apply, ← Finset.sum_add_distrib, add_smul]
  map_smul' r x := by
    simp only [Matrix.mulVec_smul, RingHom.id_apply, Pi.smul_apply, smul_eq_mul,
      mul_smul, ← Finset.smul_sum]

/-- **Every image of `constructionAToE8` lies in `Submodule.E8 ℝ`.**

This is the central bridge theorem: the Construction A coefficient space
maps into the imported SPL E8 lattice submodule. The proof follows because
`constructionAToSPLTransition.mulVec c` gives integer coefficients, and
`intLinComb_E8Matrix_mem_E8` shows that any integer linear combination of
`E8Matrix ℝ` rows belongs to `Submodule.E8 ℝ`. -/
theorem constructionAToE8_mem_E8 (c : Fin 8 → ℤ) :
    constructionAToE8 c ∈ Submodule.E8 ℝ :=
  intLinComb_E8Matrix_mem_E8 (constructionAToSPLTransition.mulVec c)

/-- The map `constructionAToE8` is injective (since `T` has determinant 1,
hence is invertible over ℤ). -/
theorem constructionAToE8_injective :
    Function.Injective constructionAToE8 := by
  intro a b hab
  have h0 : constructionAToE8 (a - b) = 0 := by rw [map_sub, sub_eq_zero]; exact hab
  -- T is invertible over ℤ (det = 1)
  have hunitT : IsUnit constructionAToSPLTransition := by
    rw [Matrix.isUnit_iff_isUnit_det, constructionAToSPLTransition_det]; exact isUnit_one
  -- E8Matrixᵀ is invertible over ℝ (det = 1)
  have hunitST : IsUnit (E8Matrix ℝ).transpose := by
    rw [Matrix.isUnit_iff_isUnit_det, Matrix.det_transpose, E8Matrix_unimodular]; exact isUnit_one
  -- Set d = cast of T.mulVec (a-b)
  set c := a - b with hc
  set d : Fin 8 → ℝ := fun i => (constructionAToSPLTransition.mulVec c i : ℝ) with hd_def
  -- h0 gives: ∑ i, d_i • (E8Matrix ℝ).row i = 0
  -- This means (E8Matrix ℝ).mulVec d = 0
  have h1 : (E8Matrix ℝ).transpose.mulVec d = 0 := by
    ext k
    simp only [Matrix.mulVec, dotProduct, Pi.zero_apply, hd_def,
      Matrix.transpose_apply]
    have := congr_fun h0 k
    simp only [constructionAToE8, LinearMap.coe_mk, AddHom.coe_mk, Finset.sum_apply,
      Pi.smul_apply, zsmul_eq_mul, Pi.zero_apply, Matrix.row_apply] at this
    convert this using 1
    congr 1; ext i; simp [Matrix.mulVec, dotProduct, Matrix.row_apply]; ring
  -- E8Matrixᵀ.mulVec is injective → d = 0
  have h2 : d = 0 :=
    (Matrix.mulVec_injective_of_isUnit hunitST) (by rw [h1, Matrix.mulVec_zero])
  -- So the integer vector T.mulVec c = 0
  have h3 : constructionAToSPLTransition.mulVec c = 0 := by
    ext i
    have := congr_fun h2 i
    simp only [Pi.zero_apply, hd_def] at this
    exact_mod_cast this
  -- T.mulVec is injective → c = 0, i.e. a = b
  have h4 : c = 0 :=
    (Matrix.mulVec_injective_of_isUnit hunitT) (by rw [h3, Matrix.mulVec_zero])
  exact sub_eq_zero.mp h4

/-! ## Section 12: Inverse of the transition matrix

Since `constructionAToSPLTransition` has `det = 1`, its adjugate is a
two-sided inverse over ℤ (by `adjugate_mul` and `mul_adjugate`).
We define it explicitly for computational convenience.
-/

/-- The ℤ-valued inverse of the transition matrix `T`.
Since `det T = 1`, the adjugate is the inverse: `T_inv * T = I` and
`T * T_inv = I`. -/
def constructionAToSPLTransition_inv : Matrix (Fin 8) (Fin 8) ℤ :=
  constructionAToSPLTransition.adjugate

theorem constructionAToSPLTransition_inv_mul :
    constructionAToSPLTransition_inv * constructionAToSPLTransition = 1 := by
  unfold constructionAToSPLTransition_inv
  rw [Matrix.adjugate_mul, constructionAToSPLTransition_det, one_smul]

theorem constructionAToSPLTransition_mul_inv :
    constructionAToSPLTransition * constructionAToSPLTransition_inv = 1 := by
  unfold constructionAToSPLTransition_inv
  rw [Matrix.mul_adjugate, constructionAToSPLTransition_det, one_smul]

/-! ## Section 13: Surjectivity of constructionAToE8

Every element of `Submodule.E8 ℝ` is in the image of `constructionAToE8`.

Proof sketch:
- By `span_E8Matrix ℝ`, every `v ∈ Submodule.E8 ℝ` is an integer linear
  combination of E8Matrix rows: `v = ∑ i, d_i • row_i`.
- Set `c = T⁻¹ · d`. Then `T · c = d`, so
  `constructionAToE8 c = ∑ i, (T · c)_i • row_i = ∑ i, d_i • row_i = v`.
-/

/-- `T⁻¹ · (T · c) = c`: the inverse recovers the original coefficient vector. -/
theorem constructionAToSPLTransition_inv_mulVec_mulVec (c : Fin 8 → ℤ) :
    constructionAToSPLTransition_inv.mulVec
      (constructionAToSPLTransition.mulVec c) = c := by
  simp [Matrix.mulVec_mulVec, constructionAToSPLTransition_inv_mul]

/-- `T · (T⁻¹ · d) = d`: the transition recovers SPL coefficients. -/
theorem constructionAToSPLTransition_mulVec_inv_mulVec (d : Fin 8 → ℤ) :
    constructionAToSPLTransition.mulVec
      (constructionAToSPLTransition_inv.mulVec d) = d := by
  simp [Matrix.mulVec_mulVec, constructionAToSPLTransition_mul_inv]

/-- **Surjectivity of `constructionAToE8` onto `Submodule.E8 ℝ`.**

Every element of SPL's `Submodule.E8 ℝ` is in the range of
`constructionAToE8`. Combined with `constructionAToE8_injective`,
this establishes a bijection between `ℤ⁸` and `Submodule.E8 ℝ`. -/
theorem constructionAToE8_surj_E8 (v : Fin 8 → ℝ) (hv : v ∈ Submodule.E8 ℝ) :
    ∃ c : Fin 8 → ℤ, constructionAToE8 c = v := by
  -- v is in the ℤ-span of E8Matrix rows
  rw [← span_E8Matrix ℝ] at hv
  rw [Submodule.mem_span_range_iff_exists_fun] at hv
  obtain ⟨d, hd⟩ := hv
  -- Use T⁻¹ · d as the coefficient vector
  refine ⟨constructionAToSPLTransition_inv.mulVec d, ?_⟩
  -- constructionAToE8 (T⁻¹ · d) = ∑ i, (T · T⁻¹ · d)_i • row_i = ∑ i, d_i • row_i = v
  change ∑ i : Fin 8,
    (constructionAToSPLTransition.mulVec
      (constructionAToSPLTransition_inv.mulVec d) i) •
    (E8Matrix ℝ).row i = v
  rw [constructionAToSPLTransition_mulVec_inv_mulVec]
  exact hd

/-- The range of `constructionAToE8` is exactly `Submodule.E8 ℝ` (as a set). -/
theorem constructionAToE8_range_eq_E8 :
    Set.range constructionAToE8 = (Submodule.E8 ℝ : Set (Fin 8 → ℝ)) := by
  ext v
  constructor
  · rintro ⟨c, rfl⟩
    exact constructionAToE8_mem_E8 c
  · intro hv
    exact constructionAToE8_surj_E8 v hv

/-! ## Section 14: LinearEquiv from ℤ⁸ to Submodule.E8 ℝ

Package the injective + surjective ℤ-linear map as a `LinearEquiv`
between `(Fin 8 → ℤ)` and `↥(Submodule.E8 ℝ)` (the subtype). -/

/-- The ℤ-linear map `constructionAToE8` restricted to `Submodule.E8 ℝ`
as a codomain, yielding a `LinearMap` into the submodule subtype. -/
noncomputable def constructionAToE8Sub : (Fin 8 → ℤ) →ₗ[ℤ] ↥(Submodule.E8 ℝ) where
  toFun c := ⟨constructionAToE8 c, constructionAToE8_mem_E8 c⟩
  map_add' x y := by
    ext; simp [map_add]
  map_smul' r x := by
    simp only [RingHom.id_apply]
    exact Subtype.ext (constructionAToE8.map_smul r x)

/-- `constructionAToE8Sub` is injective. -/
theorem constructionAToE8Sub_injective :
    Function.Injective constructionAToE8Sub := by
  intro a b h
  have := congr_arg Subtype.val h
  exact constructionAToE8_injective this

/-- `constructionAToE8Sub` is surjective. -/
theorem constructionAToE8Sub_surjective :
    Function.Surjective constructionAToE8Sub := by
  intro ⟨v, hv⟩
  obtain ⟨c, hc⟩ := constructionAToE8_surj_E8 v hv
  exact ⟨c, Subtype.ext hc⟩

/-- `constructionAToE8Sub` is bijective. -/
theorem constructionAToE8Sub_bijective :
    Function.Bijective constructionAToE8Sub :=
  ⟨constructionAToE8Sub_injective, constructionAToE8Sub_surjective⟩

/-- **ℤ-linear equivalence: `(Fin 8 → ℤ) ≃ₗ[ℤ] ↥(Submodule.E8 ℝ)`.**

The Construction A coefficient space is ℤ-linearly isomorphic to SPL's
`Submodule.E8 ℝ`. This is the strongest algebraic packaging of the bridge:
it witnesses that both models describe the same abstract ℤ-module (the E8 lattice). -/
noncomputable def constructionAToE8Equiv : (Fin 8 → ℤ) ≃ₗ[ℤ] ↥(Submodule.E8 ℝ) :=
  LinearEquiv.ofBijective constructionAToE8Sub constructionAToE8Sub_bijective

/-- The `LinearEquiv` agrees with the original map on elements. -/
theorem constructionAToE8Equiv_apply (c : Fin 8 → ℤ) :
    (constructionAToE8Equiv c : Fin 8 → ℝ) = constructionAToE8 c := rfl

/-! ## Section 15: Isometry / norm-preservation theorem

The Euclidean squared norm of `constructionAToE8 c` equals `cᵀ · G_scaled · c`
where `G_scaled = e8ScaledGramQ` is the scaled Construction A Gram matrix.

This follows from the Gram congruence `Tᵀ · G_spl · T = G_scaled` and the
fact that `constructionAToE8 c ⬝ᵥ constructionAToE8 c` computes via the SPL
Gram matrix.
-/

set_option maxHeartbeats 400000 in
-- 64 entry-by-entry comparisons between E8Matrix ℝ and splE8BasisQ.map cast
/-- `E8Matrix ℝ = splE8BasisQ.map (algebraMap ℚ ℝ)`: the ℝ-valued SPL basis
is the image of the ℚ basis under the canonical embedding. -/
theorem E8Matrix_R_eq_splE8BasisQ_map :
    E8Matrix ℝ = splE8BasisQ.map (algebraMap ℚ ℝ) := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [E8Matrix, splE8BasisQ, Matrix.map_apply]

/-- The Gram matrix of `E8Matrix ℝ` equals `splE8GramQ` cast to ℝ. -/
theorem E8Matrix_gram_R_eq_splE8GramQ_cast :
    (E8Matrix ℝ) * (E8Matrix ℝ).transpose =
    splE8GramQ.map (algebraMap ℚ ℝ) := by
  rw [E8Matrix_R_eq_splE8BasisQ_map, ← Matrix.transpose_map, ← Matrix.map_mul, splE8GramQ_eq]

/-- **ℝ-valued Gram congruence**: the change-of-basis formula holds over ℝ. -/
theorem constructionAToSPLTransition_gram_R :
    (constructionAToSPLTransition.map (Int.castRingHom ℝ)).transpose *
    (splE8GramQ.map (algebraMap ℚ ℝ)) *
    (constructionAToSPLTransition.map (Int.castRingHom ℝ)) =
    e8ScaledGramQ.map (algebraMap ℚ ℝ) :=
  E8SpherePackingIsometryHelper.gram_congruence_Q_to_R
    constructionAToSPLTransition splE8GramQ e8ScaledGramQ
    constructionAToSPLTransition_gram

/-- The inner product of two images under `constructionAToE8` is given by
the scaled Gram form. This is the bilinear version of the norm theorem.

The Euclidean inner product `⟨φ(c₁), φ(c₂)⟩ = ∑ᵢⱼ c₁ᵢ · G_scaled[i,j] · c₂ⱼ`
where `G_scaled = e8ScaledGramQ = e8CodeBasisGram / 2`. -/
theorem constructionAToE8_inner (c₁ c₂ : Fin 8 → ℤ) :
    constructionAToE8 c₁ ⬝ᵥ constructionAToE8 c₂ =
    ∑ i : Fin 8, ∑ j : Fin 8,
      (c₁ i : ℝ) * (e8ScaledGramQ i j : ℝ) * (c₂ j : ℝ) := by
  -- Step 1: Apply the combined helper to get the form Tᵀ * (M * Mᵀ) * T
  have h1 := E8SpherePackingIsometryHelper.inner_intLinComb_eq_gram_form
    (E8Matrix ℝ) constructionAToSPLTransition c₁ c₂
  -- Step 2: Rewrite M * Mᵀ to splE8GramQ cast to ℝ
  rw [E8Matrix_gram_R_eq_splE8GramQ_cast] at h1
  -- Step 3: Apply the ℝ Gram congruence
  rw [constructionAToSPLTransition_gram_R] at h1
  -- Step 4: Convert e8ScaledGramQ.map (algebraMap ℚ ℝ) entries to (e8ScaledGramQ i j : ℝ)
  simp only [Matrix.map_apply] at h1
  exact h1

/-- The dot product of `constructionAToE8 c` with itself equals the
quadratic form `cᵀ · e8ScaledGramQ · c`, where `e8ScaledGramQ` is the
scaled Construction A Gram matrix (`e8CodeBasisGram / 2`).

Concretely, if `w = constructionAToE8 c`, then:
- `w ⬝ᵥ w = ∑ᵢⱼ cᵢ · e8ScaledGramQ[i,j] · cⱼ`
- Construction A norm²(c) = `cᵀ · e8CodeBasisGram · c = 2 · (w ⬝ᵥ w)` -/
theorem constructionAToE8_norm_sq (c : Fin 8 → ℤ) :
    constructionAToE8 c ⬝ᵥ constructionAToE8 c =
    ∑ i : Fin 8, ∑ j : Fin 8,
      (c i : ℝ) * (e8ScaledGramQ i j : ℝ) * (c j : ℝ) :=
  constructionAToE8_inner c c

/-- E8 is even: for any `v ∈ Submodule.E8 ℝ`, the squared norm `v ⬝ᵥ v`
is an even integer. This follows from SPL's `E8_integral_self`. -/
theorem constructionAToE8_norm_sq_even (c : Fin 8 → ℤ) :
    ∃ z : ℤ, Even z ∧ (z : ℝ) = constructionAToE8 c ⬝ᵥ constructionAToE8 c :=
  E8_integral_self (constructionAToE8 c) (constructionAToE8_mem_E8 c)

/-! ## Section 16: Manuscript-facing bridge package theorems -/

/-- **Bridge package theorem**: bundles the five core bridge results into a single
manuscript-facing statement.

Components:
1. **Matrix equality**: `splE8BasisQ = E8Matrix ℚ`
2. **Span equality**: `Submodule.span ℤ (Set.range splE8BasisQ.row) = Submodule.E8 ℚ`
3. **ℤ-linear equivalence**: `(Fin 8 → ℤ) ≃ₗ[ℤ] ↥(Submodule.E8 ℝ)` (witness exists)
4. **Range characterization**: `Set.range constructionAToE8 = ↑(Submodule.E8 ℝ)`
5. **Inner product**: Euclidean inner product of images = scaled Gram form -/
theorem constructionA_to_imported_E8_bridge_package :
    -- (1) Matrix equality
    splE8BasisQ = E8Matrix ℚ
    ∧
    -- (2) Span equality
    Submodule.span ℤ (Set.range splE8BasisQ.row) = Submodule.E8 ℚ
    ∧
    -- (3) ℤ-linear equivalence exists (constructionAToE8Equiv)
    Nonempty ((Fin 8 → ℤ) ≃ₗ[ℤ] ↥(Submodule.E8 ℝ))
    ∧
    -- (4) Range = Submodule.E8 ℝ
    Set.range constructionAToE8 = (Submodule.E8 ℝ : Set (Fin 8 → ℝ))
    ∧
    -- (5) Inner product formula
    (∀ c₁ c₂ : Fin 8 → ℤ,
      constructionAToE8 c₁ ⬝ᵥ constructionAToE8 c₂ =
      ∑ i : Fin 8, ∑ j : Fin 8,
        (c₁ i : ℝ) * (e8ScaledGramQ i j : ℝ) * (c₂ j : ℝ)) :=
  ⟨local_splE8BasisQ_eq_imported_E8Matrix_Q,
   local_splE8BasisQ_span_eq_imported_E8_Q,
   ⟨constructionAToE8Equiv⟩,
   constructionAToE8_range_eq_E8,
   constructionAToE8_inner⟩

/-- **Density theorem with full Construction A bridge.**

Bundles SPL's `E8Packing_density` (the density of `E8Packing` is `π⁴/384`)
with the ℤ-module equivalence `constructionAToE8Equiv` and the inner-product
formula. This connects the density result to the Construction A model:

- The lattice underlying `E8Packing` is `E8Lattice`, built from `Submodule.E8 ℝ`.
- `constructionAToE8Equiv` proves `(Fin 8 → ℤ) ≃ₗ[ℤ] ↥(Submodule.E8 ℝ)`.
- `constructionAToE8_inner` shows the Euclidean geometry is determined by
  the scaled Construction A Gram matrix.

Together these establish that the Construction A model describes the same
abstract lattice as `E8Packing.lattice`, with matching inner-product
structure, and that lattice achieves density `π⁴/384`.

The remaining kernel-checked gap for *constructing* a new `PeriodicSpherePacking`
from the Construction A model is the definition of center sets and verification
of the packing separation bound. This gap is isolated by
`constructionA_E8_density_conditional` below. -/
theorem constructionA_E8_density_from_spl :
    -- E8Packing has the claimed density
    E8Packing.density = ENNReal.ofReal Real.pi ^ 4 / 384
    ∧
    -- The Construction A model is ℤ-linearly equivalent to SPL's E8 lattice
    Nonempty ((Fin 8 → ℤ) ≃ₗ[ℤ] ↥(Submodule.E8 ℝ))
    ∧
    -- Inner products match the scaled Gram form
    (∀ c₁ c₂ : Fin 8 → ℤ,
      constructionAToE8 c₁ ⬝ᵥ constructionAToE8 c₂ =
      ∑ i : Fin 8, ∑ j : Fin 8,
        (c₁ i : ℝ) * (e8ScaledGramQ i j : ℝ) * (c₂ j : ℝ))
    ∧
    -- Squared norms are even integers (lattice is even)
    (∀ c : Fin 8 → ℤ,
      ∃ z : ℤ, Even z ∧ (z : ℝ) = constructionAToE8 c ⬝ᵥ constructionAToE8 c) :=
  ⟨E8Packing_density,
   ⟨constructionAToE8Equiv⟩,
   constructionAToE8_inner,
   constructionAToE8_norm_sq_even⟩

/-- **Conditional density transfer theorem.**

If a `PeriodicSpherePacking` `P` has the same underlying `SpherePacking`
as `E8Packing` (i.e., same centers and separation), then
`P.density = π⁴/384`.

This isolates the exact API gap for full packing transport: to apply this
theorem, one must construct a `PeriodicSpherePacking` from the Construction A
model and show its underlying `SpherePacking` matches `E8Packing`'s. The
lattice matching is morally established by `constructionAToE8_range_eq_E8`,
but the centers and separation bound require additional SPL packing API
(constructing the `SpherePacking` structure with verified separation). -/
theorem constructionA_E8_density_conditional
    (P : PeriodicSpherePacking 8)
    (hsp : P.toSpherePacking = E8Packing.toSpherePacking) :
    P.density = ENNReal.ofReal Real.pi ^ 4 / 384 := by
  rw [show P.density = E8Packing.density from congrArg SpherePacking.density hsp]
  exact E8Packing_density

/-! ## Section 17: Summary of bridge status

### What is proved (kernel-checked, sorry-free):

1–15 from original list, plus:

16. **Surjectivity**: `constructionAToE8_surj_E8` — every element of
    `Submodule.E8 ℝ` is in the image of `constructionAToE8`.
17. **Range characterization**: `constructionAToE8_range_eq_E8` — the
    range is exactly `Submodule.E8 ℝ` as a set.
18. **LinearEquiv**: `constructionAToE8Equiv : (Fin 8 → ℤ) ≃ₗ[ℤ] ↥(Submodule.E8 ℝ)`
    — full ℤ-module isomorphism between the coefficient lattice and the
    imported SPL E8 lattice.
19. **Norm evenness**: `constructionAToE8_norm_sq_even` — squared norms
    in the image are even integers (from SPL's `E8_integral_self`).
20. **Norm/inner product theorem**: `constructionAToE8_inner` and
    `constructionAToE8_norm_sq` prove that the Euclidean inner product
    of images equals the scaled Gram quadratic form.
21. **Bridge package**: `constructionA_to_imported_E8_bridge_package` —
    bundles matrix equality, span equality, `LinearEquiv`, range equality,
    and inner-product formula.
22. **Density from SPL**: `constructionA_E8_density_from_spl` — bundles
    `E8Packing_density` with `constructionAToE8Equiv`, inner product, and
    norm evenness.
23. **Conditional density transfer**: `constructionA_E8_density_conditional` —
    any `PeriodicSpherePacking` matching `E8Packing`'s lattice and centers
    has density `π⁴/384`. Isolates the SPL packing API gap.

### Windows limitation

SPL contains `Aux.lean` files (Windows reserved device name). This file
compiles only on Linux/macOS or WSL2. The main repo should keep the SPL
`[[require]]` block commented out when building on native Windows.
-/

end PhysicsSM.Draft.E8SpherePackingImported
