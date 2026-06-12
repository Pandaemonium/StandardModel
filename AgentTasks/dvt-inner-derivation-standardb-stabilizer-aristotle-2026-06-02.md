# Aristotle task: Inner derivations stabilize h₃(ℂ) — DVT bridge

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-02
**Submitted**: 2026-06-02
**Job ID**: `4f7a4794-cfde-40f4-be0c-9035aaf0e612`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave5-20260602`
**Output**: `AgentTasks/aristotle-output/dvt-inner-derivation-standardb-20260602`
**Type**: Bridge between inner derivations and DVT stabilizer infrastructure

## Goal

Create a new trusted file:

```text
PhysicsSM/Algebra/Jordan/InnerDerivationStandardBStabilizer.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.InnerDerivation
import PhysicsSM.Algebra.Jordan.DVTStabilizerPrelude
```

and namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.H3O
```

## Mathematical context

The `DVTStabilizerPrelude.lean` module defines the derivation stabilizer of
`h₃(ℂ)` (the `InStandardB` predicate), called `standardB_derivationStabilizer`.
This is the set of derivations D such that `D(c) ∈ h₃(ℂ)` for all `c ∈ h₃(ℂ)`.

The new `InnerDerivation.lean` module defines `innerDerivation a b` as
`D_{a,b}(c) = a ○ (b ○ c) - b ○ (a ○ c)`.

The key connection: if `a, b ∈ h₃(ℂ)` (i.e., both satisfy `InStandardB`),
then `innerDerivation a b ∈ standardB_derivationStabilizer`. This follows from
the fact that `h₃(ℂ)` is a **Jordan subalgebra** of `h₃(𝕆)`: it is closed under
the Jordan product `○`.

## Target declarations

### Jordan subalgebra closure lemma

The key ingredient: `h₃(ℂ)` is closed under `○`:

```lean
/-- `h₃(ℂ) = InStandardB` is closed under the Jordan product. -/
theorem InStandardB_jordanProduct
    {a b : H3O} (ha : InStandardB a) (hb : InStandardB b) :
    InStandardB (jordanProduct a b)
```

**Proof approach**: `InStandardB a` means all off-diagonal entries of a are
in the chosen complex line. The Jordan product is defined in `H3OJordan.lean`
via the `jordanProduct` def. Expand the product and verify that if the entries
of a and b lie in the complex line, so do the entries of `a ○ b`. This is a
coordinate calculation, but should be manageable via the `InChosenComplexLine`
predicate on each octonion component.

### Inner derivation stabilizer theorem

```lean
/-- If `a, b ∈ h₃(ℂ)`, then `innerDerivation a b` stabilizes `h₃(ℂ)`. -/
theorem innerDerivation_mem_standardB_stabilizer
    {a b : H3O} (ha : InStandardB a) (hb : InStandardB b) :
    innerDerivation a b ∈ standardB_derivationStabilizer
```

**Proof**: For any `c ∈ h₃(ℂ)`:
```
(innerDerivation a b).toFun c = a ○ (b ○ c) - b ○ (a ○ c)
```
- `b ○ c ∈ h₃(ℂ)` by `InStandardB_jordanProduct hb hc`
- `a ○ (b ○ c) ∈ h₃(ℂ)` by `InStandardB_jordanProduct ha` applied to above
- Similarly for `b ○ (a ○ c)`
- Subtraction preserves `InStandardB` (since `h₃(ℂ)` is a subgroup under +)

The key intermediate lemma:

```lean
theorem InStandardB_sub
    {a b : H3O} (ha : InStandardB a) (hb : InStandardB b) :
    InStandardB (a - b)
```

### Inner derivation stabilizer of the intersection `h₂(ℂ) = A ∩ B`

Extend to the intersection `h₂(ℂ) = h₂(O) ∩ h₃(ℂ)` which is the `InStandardAInterB`
predicate:

```lean
/-- If `a, b ∈ h₂(ℂ)` (i.e., both `InStandardA` and `InStandardB`), then
    `innerDerivation a b ∈ standardAInterB_derivationStabilizer`. -/
theorem innerDerivation_mem_standardAInterB_stabilizer
    {a b : H3O}
    (ha_A : InStandardA a) (ha_B : InStandardB a)
    (hb_A : InStandardA b) (hb_B : InStandardB b) :
    innerDerivation a b ∈ standardAInterB_derivationStabilizer
```

### Subspace connection

```lean
/-- The set of inner derivations D_{a,b} with a,b ∈ h₃(ℂ) lies in
    the standard-B derivation stabilizer. -/
theorem innerDerivations_of_standardB_subset_stabilizer :
    {D : H3ODerivation | ∃ a b : H3O,
        InStandardB a ∧ InStandardB b ∧ D = innerDerivation a b} ⊆
      standardB_derivationStabilizer
```

### Package

```lean
structure InnerDerivationStandardBStabilizerPackage where
  /-- h₃(ℂ) is a Jordan subalgebra. -/
  standardB_jordan_closed :
    ∀ {a b : H3O}, InStandardB a → InStandardB b →
      InStandardB (jordanProduct a b)
  /-- Inner derivations from h₃(ℂ) stabilize h₃(ℂ). -/
  inner_derivation_stabilizes :
    ∀ {a b : H3O}, InStandardB a → InStandardB b →
      innerDerivation a b ∈ standardB_derivationStabilizer

noncomputable def innerDerivationStandardBStabilizerPackage :
    InnerDerivationStandardBStabilizerPackage
```

## Claim boundary

This file proves that inner derivations from `h₃(ℂ)` stabilize `h₃(ℂ)`.
It does **not** prove:
- That these derivations generate the full stabilizer `Stab(h₃(ℂ)) = su(3) ⊕ su(3)`.
- Any isomorphism between `InnDer(h₃(ℂ)) ∩ Stab(h₃(ℂ))` and an explicit Lie algebra.
- The full DVT stabilizer theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- The main difficulty is `InStandardB_jordanProduct`: if this requires a large
  coordinate expansion, break it into component lemmas.
- Add to `PhysicsSM.lean` if sorry-free.

## Verification

```bash
lake env lean PhysicsSM/Algebra/Jordan/InnerDerivationStandardBStabilizer.lean
lake build PhysicsSM.Algebra.Jordan.InnerDerivationStandardBStabilizer
```
