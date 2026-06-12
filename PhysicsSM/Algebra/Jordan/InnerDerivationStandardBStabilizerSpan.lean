import Mathlib
import PhysicsSM.Algebra.Jordan.InnerDerivationStandardBLieSubalgebra

/-!
# Algebra.Jordan.InnerDerivationStandardBStabilizerSpan

The full linear span of inner derivations from h₃(ℂ) elements stabilizes h₃(ℂ).

## Overview

The module `InnerDerivationStandardBStabilizer` proves that each *generator*
`D_{a,b}` with `a, b ∈ h₃(ℂ)` stabilizes h₃(ℂ). The module
`InnerDerivationStandardBLieSubalgebra` constructs the linear span
`innerDerivationStandardBSubspace` and shows it is closed under brackets.

This file lifts the generator-level stabilizer result to the full span:
every element of `innerDerivationStandardBSubspace` maps h₃(ℂ) into h₃(ℂ).

The proof proceeds by `Submodule.span_induction` on the derivation's
membership in the span, using the facts that `InStandardB` is closed under
addition, scalar multiplication, and contains zero.

## Claim boundary

This file proves that the linear span of inner derivations from h₃(ℂ) elements
stabilizes h₃(ℂ). It does **not** prove equality with the full stabilizer.

## Status

Trusted module — no `sorry`.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

open PhysicsSM.Algebra.Jordan.Derivation
open PhysicsSM.Algebra.Jordan.H3OJordan
open PhysicsSM.Algebra.Jordan.StabilizerDerivation
open PhysicsSM.Algebra.Jordan.DVTStabilizerPrelude

local infixl:70 " ○ " => jordanProduct

/-! ## Pointwise stabilizer for the span -/

/-- Every element of the linear span of inner derivations from h₃(ℂ) maps
    h₃(ℂ) into h₃(ℂ). This is the pointwise form of the stabilizer result. -/
theorem innerDerivationStandardBSubspace_apply_mem_standardB
    {D : Derivation.H3ODerivation}
    (hD : D ∈ innerDerivationStandardBSubspace)
    {x : H3O} (hx : InStandardB x) :
    InStandardB (D x) := by
  induction hD using Submodule.span_induction with
  | mem D' hD' =>
    obtain ⟨a, b, ha, hb, rfl⟩ := hD'
    exact innerDerivation_standardB_apply_mem ha hb hx
  | zero =>
    simp [Derivation.H3ODerivation.zero_apply]
    exact zero_inStandardB
  | add _ _ _ _ ih₁ ih₂ =>
    simp [Derivation.H3ODerivation.add_apply]
    exact add_mem_standardB ih₁ ih₂
  | smul r _ _ ih =>
    simp [Derivation.H3ODerivation.smul_apply]
    exact smul_mem_standardB r ih

/-! ## Stabilizer membership for the span -/

/-- Every element of the linear span of inner derivations from h₃(ℂ) lies
    in the derivation stabilizer of h₃(ℂ) (after converting to the
    stabilizer derivation type). -/
theorem innerDerivationStandardBSubspace_stabilizes_standardB
    {D : Derivation.H3ODerivation}
    (hD : D ∈ innerDerivationStandardBSubspace) :
    toStabDerivation D ∈ standardB_derivationStabilizer := by
  intro x hx
  change InStandardB ((toStabDerivation D) x)
  simp [toStabDerivation_apply]
  exact innerDerivationStandardBSubspace_apply_mem_standardB hD hx

/-! ## Span-level containment as a set inclusion -/

/-- The image of `innerDerivationStandardBSubspace` under `toStabDerivation`
    is contained in `standardB_derivationStabilizer`. -/
theorem innerDerivationStandardBSubspace_image_subset_stabilizer :
    toStabDerivation '' (↑innerDerivationStandardBSubspace : Set Derivation.H3ODerivation) ⊆
      standardB_derivationStabilizer := by
  intro D' ⟨D, hD, hD'⟩
  rw [← hD']
  exact innerDerivationStandardBSubspace_stabilizes_standardB hD

/-! ## Combined package -/

/-- Package combining generator stabilizer, span stabilizer, bracket closure,
    and containment in the full inner-derivation span. -/
structure InnerDerivationStandardBStabilizerSpanPackage where
  /-- Each generator D_{a,b} with a,b ∈ h₃(ℂ) stabilizes h₃(ℂ). -/
  generator_stabilizes :
    ∀ {a b : H3O}, InStandardB a → InStandardB b →
      toStabDerivation (innerDerivation a b) ∈ standardB_derivationStabilizer
  /-- Every element of the span stabilizes h₃(ℂ) (pointwise form). -/
  span_stabilizes_pointwise :
    ∀ {D : Derivation.H3ODerivation},
      D ∈ innerDerivationStandardBSubspace →
      ∀ {x : H3O}, InStandardB x → InStandardB (D x)
  /-- Every element of the span stabilizes h₃(ℂ) (stabilizer membership form). -/
  span_stabilizes :
    ∀ {D : Derivation.H3ODerivation},
      D ∈ innerDerivationStandardBSubspace →
      toStabDerivation D ∈ standardB_derivationStabilizer
  /-- The span is closed under brackets (Lie subalgebra). -/
  bracket_closed :
    ∀ {D E : Derivation.H3ODerivation},
      D ∈ innerDerivationStandardBSubspace →
      E ∈ innerDerivationStandardBSubspace →
      ⁅D, E⁆ ∈ innerDerivationStandardBSubspace
  /-- The standardB span is contained in the full inner derivation span. -/
  span_le_full :
    innerDerivationStandardBSubspace ≤ innerDerivationSubspace

/-- The canonical instance of the stabilizer span package. -/
noncomputable def innerDerivationStandardBStabilizerSpanPackage :
    InnerDerivationStandardBStabilizerSpanPackage where
  generator_stabilizes := innerDerivation_mem_standardB_stabilizer
  span_stabilizes_pointwise := innerDerivationStandardBSubspace_apply_mem_standardB
  span_stabilizes := innerDerivationStandardBSubspace_stabilizes_standardB
  bracket_closed := innerDerivationStandardBSubspace_closed_bracket
  span_le_full := innerDerivationStandardBSubspace_le_innerDerivationSubspace

end PhysicsSM.Algebra.Jordan.H3O
