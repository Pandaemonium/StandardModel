import Mathlib
import PhysicsSM.Algebra.Jordan.InnerDerivationJacobiLie
import PhysicsSM.Algebra.Jordan.InnerDerivationStandardBStabilizer

/-!
# Algebra.Jordan.InnerDerivationStandardBLieSubalgebra

The linear span of inner derivations from h₃(ℂ) elements forms a Lie
subalgebra of `Der(h₃(𝕆))`.

## Overview

Combining results from earlier modules:
1. `InStandardB_jordanProduct` — h₃(ℂ) is closed under ○ (Jordan subalgebra)
2. `innerDerivation_mem_standardB_stabilizer` — D_{a,b} stabilizes h₃(ℂ)
   when a,b ∈ h₃(ℂ)
3. `innerDerivation_commutator_formula` — [D_{a,b}, D_{c,d}] =
   D_{D_{a,b}(c), d} + D_{c, D_{a,b}(d)}

If a,b,c,d ∈ h₃(ℂ), then D_{a,b}(c) ∈ h₃(ℂ) and D_{a,b}(d) ∈ h₃(ℂ)
by the stabilizer property, so the right-hand side of the commutator
formula is a sum of two inner derivations from h₃(ℂ) elements. Therefore
the linear span of `{D_{a,b} | a,b ∈ h₃(ℂ)}` is closed under the Lie
bracket.

## Claim boundary

This file proves that the linear span of inner derivations from h₃(ℂ) is a
Lie subalgebra of `Der(h₃(𝕆))`. It does **not** prove:
- Dimension = 8 (which would identify this subalgebra with su(3)).
- That this subalgebra generates all derivations fixing h₃(ℂ).

## Status

Trusted module — no `s o r r y`.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

open PhysicsSM.Algebra.Jordan.Derivation
open PhysicsSM.Algebra.Jordan.H3OJordan
open PhysicsSM.Algebra.Jordan.StabilizerDerivation
open PhysicsSM.Algebra.Jordan.DVTStabilizerPrelude

local infixl:70 " ○ " => jordanProduct

/-! ## Inner derivation set restricted to h₃(ℂ) -/

/-- The inner derivation set from h₃(ℂ) elements:
    {D_{a,b} | a, b ∈ InStandardB}. -/
def innerDerivationStandardBSet : Set Derivation.H3ODerivation :=
  {D | ∃ a b : H3O, InStandardB a ∧ InStandardB b ∧ D = innerDerivation a b}

/-- The linear span of inner derivations from h₃(ℂ) elements. -/
noncomputable def innerDerivationStandardBSubspace : Submodule ℝ Derivation.H3ODerivation :=
  Submodule.span ℝ innerDerivationStandardBSet

/-- An individual inner derivation from h₃(ℂ) elements belongs to the span. -/
theorem innerDerivation_standardB_mem_subspace
    {a b : H3O} (ha : InStandardB a) (hb : InStandardB b) :
    innerDerivation a b ∈ innerDerivationStandardBSubspace :=
  Submodule.subset_span ⟨a, b, ha, hb, rfl⟩

/-! ## Stabilizer helper -/

/-- If a, b ∈ h₃(ℂ) and c ∈ h₃(ℂ), then D_{a,b}(c) ∈ h₃(ℂ). -/
theorem innerDerivation_standardB_apply_mem
    {a b c : H3O} (ha : InStandardB a) (hb : InStandardB b) (hc : InStandardB c) :
    InStandardB ((innerDerivation a b) c) := by
  have h := innerDerivation_mem_standardB_stabilizer ha hb
  exact h c hc

/-! ## Bracket closure for generators -/

/-- The bracket of two inner derivations from h₃(ℂ) elements lies in the
    linear span of inner derivations from h₃(ℂ) elements. -/
theorem innerDerivation_standardB_bracket_in_standardB_span
    {a b c d : H3O}
    (ha : InStandardB a) (hb : InStandardB b)
    (hc : InStandardB c) (hd : InStandardB d) :
    ⁅innerDerivation a b, innerDerivation c d⁆ ∈
      innerDerivationStandardBSubspace := by
  rw [innerDerivation_commutator_formula]
  exact Submodule.add_mem _
    (innerDerivation_standardB_mem_subspace
      (innerDerivation_standardB_apply_mem ha hb hc) hd)
    (innerDerivation_standardB_mem_subspace hc
      (innerDerivation_standardB_apply_mem ha hb hd))

/-- The bracket of two generators of `innerDerivationStandardBSet` lies
    in `innerDerivationStandardBSubspace`. -/
theorem innerDerivationStandardBSet_bracket_in_span
    {D E : Derivation.H3ODerivation}
    (hD : D ∈ innerDerivationStandardBSet)
    (hE : E ∈ innerDerivationStandardBSet) :
    ⁅D, E⁆ ∈ innerDerivationStandardBSubspace := by
  obtain ⟨a, b, ha, hb, rfl⟩ := hD
  obtain ⟨c, d, hc, hd, rfl⟩ := hE
  exact innerDerivation_standardB_bracket_in_standardB_span ha hb hc hd

/-! ## Lie subalgebra closure -/

/-
The span of inner derivations from h₃(ℂ) is closed under the
    commutator bracket.
-/
theorem innerDerivationStandardBSubspace_closed_bracket
    {D E : Derivation.H3ODerivation}
    (hD : D ∈ innerDerivationStandardBSubspace)
    (hE : E ∈ innerDerivationStandardBSubspace) :
    ⁅D, E⁆ ∈ innerDerivationStandardBSubspace := by
  refine' Submodule.span_induction _ _ _ _ hD;
  · intro x hx
    induction' hE using Submodule.span_induction with y hy y z hy hz hy' hz';
    · exact innerDerivationStandardBSet_bracket_in_span hx hy;
    · simp +decide [ LieRing.of_associative_ring_bracket ];
    · simpa [ LieRing.of_associative_ring_bracket ] using Submodule.add_mem _ hy' hz';
    · simp_all +decide [ Submodule.smul_mem, LieRing.of_associative_ring_bracket ];
  · simp +decide [ LieRing.of_associative_ring_bracket ];
  · intro x y hx hy hx' hy'; simp_all +decide [ Submodule.add_mem_iff_right, Submodule.add_mem_iff_left ] ;
  · simp +contextual [ LieRing.of_associative_ring_bracket ];
    exact fun a x hx hx' => Submodule.smul_mem _ _ hx'

/-! ## The standardB set is a subset of the full inner derivation set -/

/-- Every inner derivation from h₃(ℂ) elements is an inner derivation. -/
theorem innerDerivationStandardBSet_subset_innerDerivationSet :
    innerDerivationStandardBSet ⊆ innerDerivationSet := by
  intro D ⟨a, b, _, _, hD⟩
  exact ⟨a, b, hD⟩

/-- The standardB span is contained in the full inner derivation span. -/
theorem innerDerivationStandardBSubspace_le_innerDerivationSubspace :
    innerDerivationStandardBSubspace ≤ innerDerivationSubspace :=
  Submodule.span_mono innerDerivationStandardBSet_subset_innerDerivationSet

/-! ## Package -/

/-- Package bundling the key results about inner derivations from h₃(ℂ)
    forming a Lie subalgebra. -/
structure InnerDerivationStandardBLieSubalgebraPackage where
  /-- The set of inner derivations from h₃(ℂ) elements. -/
  standardB_set : Set Derivation.H3ODerivation
  /-- The span is closed under brackets. -/
  bracket_closed :
    ∀ D E : Derivation.H3ODerivation,
      D ∈ innerDerivationStandardBSubspace →
      E ∈ innerDerivationStandardBSubspace →
      ⁅D, E⁆ ∈ innerDerivationStandardBSubspace
  /-- Every generator is a D_{a,b} with a,b ∈ h₃(ℂ). -/
  generators :
    ∀ D ∈ innerDerivationStandardBSet,
      ∃ a b, InStandardB a ∧ InStandardB b ∧ D = innerDerivation a b
  /-- The stabilizer property: generators stabilize h₃(ℂ). -/
  stabilizes :
    ∀ {a b}, InStandardB a → InStandardB b →
      toStabDerivation (innerDerivation a b) ∈ standardB_derivationStabilizer

/-- The canonical instance of the Lie subalgebra package. -/
noncomputable def innerDerivationStandardBLieSubalgebraPackage :
    InnerDerivationStandardBLieSubalgebraPackage where
  standardB_set := innerDerivationStandardBSet
  bracket_closed _ _ hD hE := innerDerivationStandardBSubspace_closed_bracket hD hE
  generators _ hD := hD
  stabilizes ha hb := innerDerivation_mem_standardB_stabilizer ha hb

end PhysicsSM.Algebra.Jordan.H3O
