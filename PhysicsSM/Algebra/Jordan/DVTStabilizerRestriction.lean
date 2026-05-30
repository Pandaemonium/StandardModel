import Mathlib
import PhysicsSM.Algebra.Jordan.DVTStabilizerPrelude

/-!
# Algebra.Jordan.DVTStabilizerRestriction

Restriction of common-stabilizer derivations to the intersection `A ∩ B`.

## Mathematical context

In the Dubois-Violette–Todorov (DVT) approach to the Standard Model gauge
group, one studies the exceptional Jordan algebra `h₃(𝕆)` and the pair of
subalgebras:

- `A = h₂(𝕆)` — the upper-left `2×2` Hermitian octonionic block.
- `B = h₃(ℂ)` — the `3×3` Hermitian complex block.

Their intersection is `A ∩ B = h₂(ℂ)`. A derivation of `h₃(𝕆)` that
stabilizes both `A` and `B` automatically stabilizes `A ∩ B`, and thus
restricts to an endomorphism of `A ∩ B`.

This module formalizes that restriction and proves:
- the restriction is well-defined,
- it is compatible with addition and scalar multiplication,
- it is compatible with the commutator bracket.

## Claim boundary

This is a restriction API only. No claims are made about `F₄`, `Spin(9)`,
or the final `S(U(2) × U(3))` identification.

## Sources

- John Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
- Dubois-Violette and Todorov, arXiv:1806.09450.
- Ivan Todorov, arXiv:1911.13124.
-/

namespace PhysicsSM.Algebra.Jordan.DVTStabilizerRestriction

open PhysicsSM.Algebra.Jordan.H3O
open PhysicsSM.Algebra.Jordan.StabilizerDerivation
open PhysicsSM.Algebra.Jordan.DVTStabilizerPrelude

/-! ## The subtype of the intersection -/

/-- Elements of `h₂(ℂ) = A ∩ B` inside `h₃(𝕆)`. -/
abbrev StandardAInterBElement := {x : H3O // InStandardAInterB x}

/-! ## Restriction of common-stabilizer derivations -/

/-- A derivation in the common stabilizer of `A` and `B` restricts to an
    endomorphism of their intersection `A ∩ B = h₂(ℂ)`. -/
def restrictCommonStabilizerToAInterB
    (D : H3ODerivation)
    (hD : D ∈ standardAAndB_derivationStabilizer) :
    StandardAInterBElement → StandardAInterBElement :=
  fun x => ⟨D x.1, standardAAndB_subset_standardAInterB hD x.1 x.2⟩

/-- The coercion of the restricted derivation back to `H3O` is just `D`
    applied to the underlying element. -/
@[simp]
theorem restrictCommonStabilizerToAInterB_apply
    (D : H3ODerivation)
    (hD : D ∈ standardAAndB_derivationStabilizer)
    (x : StandardAInterBElement) :
    (restrictCommonStabilizerToAInterB D hD x : H3O) = D x.1 :=
  rfl

/-! ## Compatibility with addition -/

/-- The restriction is compatible with addition of derivations. -/
theorem restrictCommonStabilizerToAInterB_add
    {D₁ D₂ : H3ODerivation}
    (h₁ : D₁ ∈ standardAAndB_derivationStabilizer)
    (h₂ : D₂ ∈ standardAAndB_derivationStabilizer)
    (x : StandardAInterBElement) :
    (restrictCommonStabilizerToAInterB (D₁ + D₂)
        (add_mem_standardAAndB_derivationStabilizer h₁ h₂) x : H3O) =
    (restrictCommonStabilizerToAInterB D₁ h₁ x : H3O) +
    (restrictCommonStabilizerToAInterB D₂ h₂ x : H3O) := by
  simp [H3ODerivation.add_apply]

/-- The restriction maps addition of elements correctly. -/
theorem restrictCommonStabilizerToAInterB_map_add
    (D : H3ODerivation)
    (hD : D ∈ standardAAndB_derivationStabilizer)
    (x y : StandardAInterBElement) :
    (restrictCommonStabilizerToAInterB D hD
      ⟨x.1 + y.1, ⟨add_mem_standardA x.2.1 y.2.1,
                     add_mem_standardB x.2.2 y.2.2⟩⟩ : H3O) =
    (restrictCommonStabilizerToAInterB D hD x : H3O) +
    (restrictCommonStabilizerToAInterB D hD y : H3O) := by
  simp [D.map_add]

/-! ## Compatibility with scalar multiplication -/

/-- The restriction maps scalar multiplication correctly. -/
theorem restrictCommonStabilizerToAInterB_map_smul
    (D : H3ODerivation)
    (hD : D ∈ standardAAndB_derivationStabilizer)
    (r : ℝ) (x : StandardAInterBElement) :
    (restrictCommonStabilizerToAInterB D hD
      ⟨r • x.1, ⟨smul_mem_standardA r x.2.1,
                  smul_mem_standardB r x.2.2⟩⟩ : H3O) =
    r • (restrictCommonStabilizerToAInterB D hD x : H3O) := by
  simp [D.map_smul]

/-! ## Zero derivation restriction -/

/-- The zero derivation restricts to the zero map. -/
theorem restrictCommonStabilizerToAInterB_zero
    (x : StandardAInterBElement) :
    (restrictCommonStabilizerToAInterB 0
        zero_mem_standardAAndB_derivationStabilizer x : H3O) = 0 := by
  simp [H3ODerivation.zero_apply]

/-! ## Negation compatibility -/

/-- The restriction is compatible with negation. -/
theorem restrictCommonStabilizerToAInterB_neg
    {D : H3ODerivation}
    (hD : D ∈ standardAAndB_derivationStabilizer)
    (x : StandardAInterBElement) :
    (restrictCommonStabilizerToAInterB (-D)
        (neg_mem_standardAAndB_derivationStabilizer hD) x : H3O) =
    -(restrictCommonStabilizerToAInterB D hD x : H3O) := by
  simp [H3ODerivation.neg_apply]

/-! ## Commutator compatibility -/

/-- The restriction is compatible with the commutator bracket: restricting
    `[D₁, D₂]` gives the commutator of the restrictions. -/
theorem restrict_commutator_apply
    {D₁ D₂ : H3ODerivation}
    (h₁ : D₁ ∈ standardAAndB_derivationStabilizer)
    (h₂ : D₂ ∈ standardAAndB_derivationStabilizer)
    (x : StandardAInterBElement) :
    (restrictCommonStabilizerToAInterB (StabilizerDerivation.commutator D₁ D₂)
        (standardAAndB_derivationStabilizer_commutator_mem h₁ h₂) x : H3O) =
    D₁ (D₂ x.1) + -(D₂ (D₁ x.1)) := by
  simp [restrictCommonStabilizerToAInterB, StabilizerDerivation.commutator]

end PhysicsSM.Algebra.Jordan.DVTStabilizerRestriction
