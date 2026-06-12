import Mathlib
import PhysicsSM.Algebra.Jordan.InnerDerivation
import PhysicsSM.Algebra.Jordan.DVTStabilizerPrelude

/-!
# Algebra.Jordan.InnerDerivationStandardBStabilizer

Bridge between inner derivations of `h₃(𝕆)` and the DVT stabilizer
infrastructure.

## Overview

The module `InnerDerivation.lean` defines `innerDerivation a b` as the
derivation `D_{a,b}(c) = a ○ (b ○ c) - b ○ (a ○ c)`, returning a value of
type `Derivation.H3ODerivation`.

The module `DVTStabilizerPrelude.lean` defines `standardB_derivationStabilizer`
as the set of derivations (of type `StabilizerDerivation.H3ODerivation`)
stabilizing `h₃(ℂ)`.

This file bridges the two by:
1. Converting between the two `H3ODerivation` types.
2. Proving that `h₃(ℂ)` is closed under the Jordan product (re-exporting
   the existing `jordan_mem_standardB`).
3. Proving that `h₃(ℂ)` is closed under subtraction.
4. Proving that inner derivations from `h₃(ℂ)` stabilize `h₃(ℂ)`.
5. Extending to the intersection `h₂(ℂ) = h₂(𝕆) ∩ h₃(ℂ)`.

## Claim boundary

This file proves that inner derivations from `h₃(ℂ)` stabilize `h₃(ℂ)`.
It does **not** prove:
- That these derivations generate the full stabilizer.
- Any isomorphism with an explicit Lie algebra.
- The full DVT stabilizer theorem.

## Status

Trusted module — no `sorry`.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

open PhysicsSM.Algebra.Jordan.Derivation
open PhysicsSM.Algebra.Jordan.H3OJordan
open PhysicsSM.Algebra.Jordan.StabilizerDerivation
open PhysicsSM.Algebra.Jordan.DVTStabilizerPrelude

local infixl:70 " ○ " => jordanProduct

/-! ## Type bridge between Derivation.H3ODerivation and StabilizerDerivation.H3ODerivation

The project has two isomorphic definitions of `H3ODerivation`:
- `Derivation.H3ODerivation` (used by `innerDerivation`)
- `StabilizerDerivation.H3ODerivation` (used by the stabilizer infrastructure)

We provide conversions between them.
-/

/-- Convert a `Derivation.H3ODerivation` to a `StabilizerDerivation.H3ODerivation`. -/
def toStabDerivation (D : Derivation.H3ODerivation) :
    StabilizerDerivation.H3ODerivation where
  toFun := D.toFun
  map_add := D.map_add'
  map_smul := D.map_smul'
  leibniz := D.leibniz'

/-- Convert a `StabilizerDerivation.H3ODerivation` to a `Derivation.H3ODerivation`. -/
def fromStabDerivation (D : StabilizerDerivation.H3ODerivation) :
    Derivation.H3ODerivation where
  toFun := D.toFun
  map_add' := D.map_add
  map_smul' := D.map_smul
  leibniz' := D.leibniz

@[simp]
theorem toStabDerivation_apply (D : Derivation.H3ODerivation) (a : H3O) :
    (toStabDerivation D) a = D a := rfl

@[simp]
theorem fromStabDerivation_apply (D : StabilizerDerivation.H3ODerivation) (a : H3O) :
    (fromStabDerivation D) a = D a := rfl

/-! ## Jordan subalgebra closure -/

/-- `h₃(ℂ) = InStandardB` is closed under the Jordan product. -/
theorem InStandardB_jordanProduct
    {a b : H3O} (ha : InStandardB a) (hb : InStandardB b) :
    InStandardB (jordanProduct a b) :=
  jordan_mem_standardB ha hb

/-! ## Subtraction closure -/

/-- `h₃(ℂ) = InStandardB` is closed under subtraction. -/
theorem InStandardB_sub
    {a b : H3O} (ha : InStandardB a) (hb : InStandardB b) :
    InStandardB (a - b) :=
  add_mem_standardB ha (neg_mem_standardB hb)

/-- `h₂(𝕆) = InStandardA` is closed under subtraction. -/
theorem InStandardA_sub
    {a b : H3O} (ha : InStandardA a) (hb : InStandardA b) :
    InStandardA (a - b) :=
  add_mem_standardA ha (neg_mem_standardA hb)

/-! ## Inner derivation stabilizes h₃(ℂ) -/

/-- If `a, b ∈ h₃(ℂ)`, then `innerDerivation a b` stabilizes `h₃(ℂ)`.

The proof uses that `h₃(ℂ)` is a Jordan subalgebra (closed under `○`) and
a subgroup under addition. For any `c ∈ h₃(ℂ)`:
- `b ○ c ∈ h₃(ℂ)` by closure
- `a ○ (b ○ c) ∈ h₃(ℂ)` by closure
- Similarly `b ○ (a ○ c) ∈ h₃(ℂ)`
- The difference is in `h₃(ℂ)` by subtraction closure. -/
theorem innerDerivation_mem_standardB_stabilizer
    {a b : H3O} (ha : InStandardB a) (hb : InStandardB b) :
    toStabDerivation (innerDerivation a b) ∈ standardB_derivationStabilizer := by
  intro c hc
  change InStandardB ((innerDerivation a b) c)
  simp only [innerDerivation_apply]
  exact InStandardB_sub
    (InStandardB_jordanProduct ha (InStandardB_jordanProduct hb hc))
    (InStandardB_jordanProduct hb (InStandardB_jordanProduct ha hc))

/-! ## Inner derivation stabilizes h₂(ℂ) -/

/-- `h₂(𝕆) = InStandardA` is closed under the Jordan product. -/
theorem InStandardA_jordanProduct
    {a b : H3O} (ha : InStandardA a) (hb : InStandardA b) :
    InStandardA (jordanProduct a b) :=
  jordan_mem_standardA ha hb

/-- If `a, b ∈ h₂(𝕆)`, then `innerDerivation a b` stabilizes `h₂(𝕆)`. -/
theorem innerDerivation_stabilizes_standardA
    {a b : H3O} (ha : InStandardA a) (hb : InStandardA b) :
    toStabDerivation (innerDerivation a b) ∈ standardA_derivationStabilizer := by
  intro c hc
  change InStandardA ((innerDerivation a b) c)
  simp only [innerDerivation_apply]
  exact InStandardA_sub
    (InStandardA_jordanProduct ha (InStandardA_jordanProduct hb hc))
    (InStandardA_jordanProduct hb (InStandardA_jordanProduct ha hc))

/-- If `a, b ∈ h₂(ℂ)` (i.e., both `InStandardA` and `InStandardB`), then
    `innerDerivation a b ∈ standardAInterB_derivationStabilizer`. -/
theorem innerDerivation_mem_standardAInterB_stabilizer
    {a b : H3O}
    (ha_A : InStandardA a) (ha_B : InStandardB a)
    (hb_A : InStandardA b) (hb_B : InStandardB b) :
    toStabDerivation (innerDerivation a b) ∈ standardAInterB_derivationStabilizer := by
  intro c hc
  exact ⟨innerDerivation_stabilizes_standardA ha_A hb_A c hc.1,
         innerDerivation_mem_standardB_stabilizer ha_B hb_B c hc.2⟩

/-! ## Subspace connection -/

/-- The set of inner derivations D_{a,b} with a,b ∈ h₃(ℂ) lies in
    the standard-B derivation stabilizer. -/
theorem innerDerivations_of_standardB_subset_stabilizer :
    {D : StabilizerDerivation.H3ODerivation | ∃ a b : H3O,
        InStandardB a ∧ InStandardB b ∧ D = toStabDerivation (innerDerivation a b)} ⊆
      standardB_derivationStabilizer := by
  intro D ⟨a, b, ha, hb, hD⟩
  rw [hD]
  exact innerDerivation_mem_standardB_stabilizer ha hb

/-! ## Package -/

/-- Package bundling the key results: Jordan subalgebra closure and inner
    derivation stabilization. -/
structure InnerDerivationStandardBStabilizerPackage where
  /-- h₃(ℂ) is a Jordan subalgebra. -/
  standardB_jordan_closed :
    ∀ {a b : H3O}, InStandardB a → InStandardB b →
      InStandardB (jordanProduct a b)
  /-- Inner derivations from h₃(ℂ) stabilize h₃(ℂ). -/
  inner_derivation_stabilizes :
    ∀ {a b : H3O}, InStandardB a → InStandardB b →
      toStabDerivation (innerDerivation a b) ∈ standardB_derivationStabilizer

/-- The canonical instance of the package, witnessing the key results. -/
noncomputable def innerDerivationStandardBStabilizerPackage :
    InnerDerivationStandardBStabilizerPackage where
  standardB_jordan_closed := InStandardB_jordanProduct
  inner_derivation_stabilizes := innerDerivation_mem_standardB_stabilizer

end PhysicsSM.Algebra.Jordan.H3O
