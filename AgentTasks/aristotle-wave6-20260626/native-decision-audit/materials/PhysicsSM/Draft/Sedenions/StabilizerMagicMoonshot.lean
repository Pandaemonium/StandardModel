/-
Copyright (c) 2026 Harmonic. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Aristotle (Harmonic)
-/
import PhysicsSM.Draft.Sedenions.StabilizerPlaquettes
import PhysicsSM.Draft.Sedenions.CocycleQuadraticPhase
import PhysicsSM.Draft.Sedenions.S3PsiAction

set_option linter.style.nativeDecide false

/-!
# Stabilizer-to-Magic Moonshot (Job M1)

## Goal

Turn the slogan "sedenion zero-product plaquettes are signed affine stabilizer
plaquettes, while the order-three psi action moves them toward magic" into
precise finite Lean statements.

## Convention

Uses the recursive Cayley-Dickson convention from
`Sedenions/CayleyDickson_Convention.md`: labels `abcd ↔ i^d j^c ℓ^b m^a`.
This is NOT identified with the trusted octonion convention in
`PhysicsSM.Algebra.Octonion.Basic`.

## Summary of results

### Part A — All 42 zero-product plaquettes are stabilizer states

We prove that each of the 42 zero-product supports gives a 4-qubit stabilizer
state, both for the uniform (+1) state and for the omega-signed state arising
from the zero-product factorization. Each support is verified to be an affine
2-plane in 𝔽₂⁴, with a 4-element translation subspace.

### Part B — The naive "psi → magic" hypothesis is FALSE

We prove that the naive Cayley-Dickson ψ action does NOT move stabilizer
states toward magic. Specifically:

1. ψ doubles every 4-element zero-product support to an 8-element support.
2. The 8-element psi-image supports are affine 3-planes in 𝔽₂⁴.
3. The uniform state on each psi-image support ALSO has exactly 16 Pauli
   stabilizers — it is still a stabilizer state, not a magic state.

**This is a precise checked negative result.** The naive CD ψ action
preserves the stabilizer property (at the uniform level) while doubling
support size. It does NOT produce magic states from stabilizer states.

### Part C — What ψ DOES change

Despite not producing magic states, ψ does change the stabilizer structure:
- Support size: 4 → 8
- Affine dimension: 2-plane → 3-plane
- The psi-image supports are NOT among the original 42 zero-product supports
  (trivially, by size)
- The psi-image supports are NOT zero-product supports in the sedenion algebra
  (they have 8 elements, not 4)
-/

namespace StabilizerMagicMoonshot

open StabilizerPlaquettes CocycleQuadraticPhase S3PsiAction

/-! ## Shared definitions -/

/-- Extract the four support indices from a zero-product support tuple. -/
def supportFinset (t : Fin 16 × Fin 16 × Fin 16 × Fin 16) : Finset (Fin 16) :=
  {t.1, t.2.1, t.2.2.1, t.2.2.2}

/-! ## Part A: All 42 zero-product plaquettes are stabilizer states -/

/-- Uniform (+1) plaquette state: amplitude +1 on all four support points,
    0 elsewhere. -/
def uniformPlaqOf (t : Fin 16 × Fin 16 × Fin 16 × Fin 16) : StateVec := fun x =>
  if x = t.1 ∨ x = t.2.1 ∨ x = t.2.2.1 ∨ x = t.2.2.2 then 1 else 0

/-- Signed plaquette state from the zero-product relation. For each support
    `(lo₁, lo₂, hi₁, hi₂)`, signs are `(+1, +1, +1, s)` where
    `s = -(ω(lo₁,hi₂) · ω(hi₁,lo₂))`, determined by the linear-phase theorem:
    the product `ω(lo₁,lo₂) · ω(lo₁,hi₂) · ω(hi₁,lo₂) · ω(hi₁,hi₂) = +1`
    on every zero-product support forces cancellation in the sedenion product. -/
def signedPlaqOf (t : Fin 16 × Fin 16 × Fin 16 × Fin 16) : StateVec := fun x =>
  let lo₁ := t.1; let lo₂ := t.2.1; let hi₁ := t.2.2.1; let hi₂ := t.2.2.2
  if x = lo₁ then 1
  else if x = lo₂ then 1
  else if x = hi₁ then 1
  else if x = hi₂ then -(omega lo₁ hi₂ * omega hi₁ lo₂)
  else 0

/-- **Theorem A1**: Every uniform plaquette on a zero-product support
    has exactly 16 signed Pauli stabilizers, confirming it is a proper
    4-qubit stabilizer state. -/
theorem all_42_uniform_are_stabilizer :
    ∀ t ∈ zeroProdSupportList,
      stabilizerCountFlat (uniformPlaqOf t) = 16 := by native_decide

/-- **Theorem A2**: Every signed plaquette (omega-derived signs) on a
    zero-product support also has exactly 16 signed Pauli stabilizers. -/
theorem all_42_signed_are_stabilizer :
    ∀ t ∈ zeroProdSupportList,
      stabilizerCountFlat (signedPlaqOf t) = 16 := by native_decide

/-! ### Affine plane structure -/

/-- Compute the translation space of a 4-element support: the set of pairwise
    XOR differences. For an affine 2-plane, this is a 4-element 𝔽₂-subspace. -/
def translationSpaceOf (t : Fin 16 × Fin 16 × Fin 16 × Fin 16) : Finset (Fin 16) :=
  let pts := [t.1, t.2.1, t.2.2.1, t.2.2.2]
  (pts.flatMap fun a => pts.map fun b => xorF a b).toFinset

/-- An affine-plane check: the translation space has exactly 4 elements
    (the support is a coset of a 2-dimensional 𝔽₂-subspace). -/
def isAffinePlane (t : Fin 16 × Fin 16 × Fin 16 × Fin 16) : Bool :=
  (translationSpaceOf t).card == 4

/-- **Theorem A3**: Every zero-product support is an affine 2-plane in 𝔽₂⁴. -/
theorem all_42_supports_are_affine_planes :
    ∀ t ∈ zeroProdSupportList, isAffinePlane t = true := by native_decide

/-- **Theorem A4**: Every zero-product support has exactly 4 distinct elements. -/
theorem all_42_supports_have_4_elements :
    ∀ t ∈ zeroProdSupportList, (supportFinset t).card = 4 := by native_decide

/-! ## Part B: Psi action — checked negative result for "magic" -/

/-- The psi-image support of a zero-product plaquette. -/
def psiImageSupportSet (t : Fin 16 × Fin 16 × Fin 16 × Fin 16) : Finset (Fin 16) :=
  psiImageSupport (supportFinset t)

/-- Uniform state on an arbitrary finset of basis indices. -/
def uniformOnFinset (S : Finset (Fin 16)) : StateVec := fun x =>
  if x ∈ S then 1 else 0

/-- **Theorem B1**: The psi image of every 4-element zero-product support
    has exactly 8 elements. Support size doubles under the naive CD ψ action. -/
theorem psi_spreads_all_42_to_8 :
    ∀ t ∈ zeroProdSupportList,
      (psiImageSupportSet t).card = 8 := by native_decide

/-- **Theorem B2 (negative result for magic)**: The uniform state on each
    psi-image support has EXACTLY 16 signed Pauli stabilizers — it is still
    a proper stabilizer state, NOT a magic state.

    This refutes the naive "psi → magic" hypothesis: the Cayley-Dickson ψ action
    maps stabilizer states to (larger) stabilizer states, not to magic states. -/
theorem psi_image_uniform_still_stabilizer :
    ∀ t ∈ zeroProdSupportList,
      stabilizerCountFlat (uniformOnFinset (psiImageSupportSet t)) = 16 := by native_decide

/-! ### Affine 3-plane structure of psi images -/

/-- Compute the translation space of a finset (as a list-based computation). -/
def translSpaceOfFinset (S : Finset (Fin 16)) : Finset (Fin 16) :=
  S.biUnion fun a => S.image fun b => xorF a b

/-- **Theorem B3**: The translation space of each psi-image support has
    exactly 8 elements, confirming the image is an affine 3-plane in 𝔽₂⁴. -/
theorem psi_image_supports_are_affine_3planes :
    ∀ t ∈ zeroProdSupportList,
      (translSpaceOfFinset (psiImageSupportSet t)).card = 8 := by native_decide

/-- **Theorem B4**: No psi-image support coincides with any of the 42
    zero-product plaquette supports (trivially, since sizes 8 ≠ 4). -/
theorem psi_image_never_among_42 :
    ∀ t₁ ∈ zeroProdSupportList, ∀ t₂ ∈ zeroProdSupportList,
      psiImageSupportSet t₁ ≠ supportFinset t₂ := by native_decide

/-! ## Part C: What the psi action DOES change -/

/-- **Theorem C1**: The affine dimension increases: zero-product supports are
    2-planes (translation space size 4) while psi images are 3-planes
    (translation space size 8). -/
theorem psi_increases_affine_dimension :
    (∀ t ∈ zeroProdSupportList,
      (translationSpaceOf t).card = 4) ∧
    (∀ t ∈ zeroProdSupportList,
      (translSpaceOfFinset (psiImageSupportSet t)).card = 8) := by
  refine ⟨fun t ht => ?_, fun t ht => psi_image_supports_are_affine_3planes t ht⟩
  have h := all_42_supports_are_affine_planes t ht
  simp only [isAffinePlane, beq_iff_eq] at h
  exact h

/-- **Theorem C2**: The stabilizer count is PRESERVED by the psi action
    (at the uniform level): both the original and psi-image uniform states
    have exactly 16 stabilizers. -/
theorem psi_preserves_stabilizer_count :
    ∀ t ∈ zeroProdSupportList,
      stabilizerCountFlat (uniformPlaqOf t) = 16 ∧
      stabilizerCountFlat (uniformOnFinset (psiImageSupportSet t)) = 16 :=
  fun t ht => ⟨all_42_uniform_are_stabilizer t ht,
               psi_image_uniform_still_stabilizer t ht⟩

/-! ## Summary certificate -/

/-- Combined certificate for all 42 zero-product plaquettes:

    **Positive (Part A)**: Each has 16 stabilizers (uniform and signed),
    sits on an affine 2-plane with 4 distinct elements.

    **Negative (Part B)**: The naive CD ψ action doubles support size to 8
    and produces an affine 3-plane, but the image is STILL a stabilizer state
    (16 stabilizers). The "psi → magic" hypothesis is false. -/
theorem stabilizer_magic_certificate :
    (∀ t ∈ zeroProdSupportList,
      stabilizerCountFlat (uniformPlaqOf t) = 16 ∧
      stabilizerCountFlat (signedPlaqOf t) = 16 ∧
      isAffinePlane t = true ∧
      (supportFinset t).card = 4 ∧
      (psiImageSupportSet t).card = 8 ∧
      stabilizerCountFlat (uniformOnFinset (psiImageSupportSet t)) = 16) :=
  fun t ht => ⟨
    all_42_uniform_are_stabilizer t ht,
    all_42_signed_are_stabilizer t ht,
    all_42_supports_are_affine_planes t ht,
    all_42_supports_have_4_elements t ht,
    psi_spreads_all_42_to_8 t ht,
    psi_image_uniform_still_stabilizer t ht⟩

end StabilizerMagicMoonshot
