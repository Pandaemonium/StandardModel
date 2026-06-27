import Mathlib
import PhysicsSM.Algebra.Jordan.InnerDerivationStandardBStabilizer
import PhysicsSM.Algebra.Jordan.TraceForm

/-!
# Algebra.Jordan.ComplementJordanModule

The complement of `h₃(ℂ)` in `h₃(𝕆)` is a Jordan module over `h₃(ℂ)`.

## Mathematical context

The exceptional Jordan algebra `h₃(𝕆)` decomposes as a real vector space:

  `h₃(𝕆) = h₃(ℂ)  ⊕  M₃(ℂ)_complement`

where `h₃(ℂ)` (`InStandardB`) is a Jordan subalgebra and
`M₃(ℂ)_complement` (`InComplementOfB`) is the trace-form orthogonal
complement.

The key structural fact: the complement is a **Jordan module** over `h₃(ℂ)`.
For `a ∈ h₃(ℂ)` and `X` in the complement, the Jordan product `a ○ X` is
again in the complement.

## Claim boundary

This file proves that h₃(ℂ) acts on the complement of h₃(ℂ) in h₃(𝕆) as a
Jordan module (the complement is closed under the h₃(ℂ) action). It does
**not** prove:
- The full bimodule structure (complement ○ complement ⊆ h₃(ℂ)).
- Any irreducibility statement.
- Connection to the standard SU(3) representation theory.

## Status

Trusted module — no `s o r r y`.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

open PhysicsSM.Algebra.Octonion
local infixl:70 " ○ " => jordanProduct

/-! ## Octonion helper lemmas: complex line × complement interaction -/

/-- Conjugation preserves `InChosenComplexComplement`. -/
theorem conj_mem_chosenComplexComplement {o : Octonion}
    (ho : InChosenComplexComplement o) :
    InChosenComplexComplement (conj o) := by
  obtain ⟨h0, h7⟩ := ho
  exact ⟨by simp [conj, h0], by simp [conj, h7]⟩

/-- The product of a complex-line element and a complement element
    lies in the complement. -/
theorem mul_complexLine_complement_mem_complement {a b : Octonion}
    (ha : InChosenComplexLine a) (hb : InChosenComplexComplement b) :
    InChosenComplexComplement (a * b) := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := ha
  obtain ⟨h0, h7⟩ := hb
  constructor <;> simp [*, Octonion.mul_c0, Octonion.mul_c7]

/-- The product of a complement element and a complex-line element
    lies in the complement. -/
theorem mul_complement_complexLine_mem_complement {a b : Octonion}
    (ha : InChosenComplexComplement a) (hb : InChosenComplexLine b) :
    InChosenComplexComplement (a * b) := by
  obtain ⟨h0, h7⟩ := ha
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := hb
  constructor <;> simp [*, Octonion.mul_c0, Octonion.mul_c7]

/-! ## Main theorem: h₃(ℂ) acts on the complement -/

/-- The Jordan product of a standard-B element with a complement element
    lies in the complement: h₃(ℂ) ○ complement ⊆ complement. -/
theorem jordanProduct_standardB_complement
    {a : H3O} (ha : InStandardB a)
    {X : H3O} (hX : InComplementOfB X) :
    InComplementOfB (jordanProduct a X) := by
  obtain ⟨ha₁, ha₂, ha₃⟩ := ha
  obtain ⟨hX₁, hX₂, hX₃, hX₄, hX₅, hX₆⟩ := hX
  simp only [InComplementOfB, InChosenComplexLine,
    InChosenComplexComplement] at *
  simp only [jordanProduct, octonionInner, *]
  refine ⟨by ring, by ring, by ring, ?_, ?_, ?_⟩ <;>
    simp_all +decide

/-- The complement is also closed under right action:
    complement ○ h₃(ℂ) ⊆ complement. -/
theorem jordanProduct_complement_standardB
    {X : H3O} (hX : InComplementOfB X)
    {a : H3O} (ha : InStandardB a) :
    InComplementOfB (jordanProduct X a) := by
  rw [jordanProduct_comm]
  exact jordanProduct_standardB_complement ha hX

/-! ## Package -/

/-- Package of the complement Jordan module properties. -/
structure ComplementJordanModulePackage where
  /-- h₃(ℂ) ○ complement ⊆ complement. -/
  standardB_acts_on_complement :
    ∀ {a X : H3O}, InStandardB a → InComplementOfB X →
      InComplementOfB (jordanProduct a X)
  /-- complement ○ h₃(ℂ) ⊆ complement. -/
  complement_acts_by_standardB :
    ∀ {X a : H3O}, InComplementOfB X → InStandardB a →
      InComplementOfB (jordanProduct X a)

/-- The complement Jordan module package, witnessing both
    action directions. -/
noncomputable def complementJordanModulePackage :
    ComplementJordanModulePackage where
  standardB_acts_on_complement ha hX :=
    jordanProduct_standardB_complement ha hX
  complement_acts_by_standardB hX ha :=
    jordanProduct_complement_standardB hX ha

end PhysicsSM.Algebra.Jordan.H3O
