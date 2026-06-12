# Aristotle task: Complement Jordan bimodule — the full picture

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-03
**Submitted**: 2026-06-03
**Job ID**: `c4803a55-f9d8-448a-b5d0-fc8b72b02b30`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave7-20260603`
**Output**: `AgentTasks/aristotle-output/complement-jordan-bimodule-20260603`
**Type**: DVT structural result — full Jordan bimodule picture

## Goal

Create a new trusted file:

```text
PhysicsSM/Algebra/Jordan/ComplementJordanBimodule.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.ComplementJordanModule
import PhysicsSM.Algebra.Jordan.ComplementJordanProductCounterexample
import PhysicsSM.Algebra.Jordan.TraceForm
```

and namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.H3O
```

## Mathematical context

The preceding modules established:
- `jordanProduct_standardB_complement` — h₃(ℂ) ○ complement ⊆ complement ✓
- `not_forall_complement_complement_product_standardB` — complement ○ complement ⊄ h₃(ℂ) ✗

This file provides the **complete picture** of the Jordan bimodule structure:
1. The complement is **closed under the h₃(ℂ)-module action** (already proved).
2. Complement × complement **maps to both summands**: `a ○ b = toH3CPart(a ○ b) + toComplementPart(a ○ b)`.
3. The **h₃(ℂ) part of complement × complement** satisfies a specific formula related to the trace form.

## Key new result: h₃(ℂ) part of complement × complement

For a, b ∈ complement, the h₃(ℂ) part of `a ○ b` is:

```lean
/-- For a, b ∈ complement, the h₃(ℂ)-part of a ○ b equals the Jordan product
    of their toH3CPart projections (which is zero for elements with zero diagonal
    and non-complex-line off-diagonals). -/
theorem complement_complement_h3c_part
    {a b : H3O} (ha : InComplementOfB a) (hb : InComplementOfB b) :
    toH3CPart (jordanProduct a b) = jordanProduct (toH3CPart a) (toH3CPart b)
```

Since elements of `InComplementOfB` have `InStandardB.toH3CPart = 0` (their
h₃(ℂ) component is zero), this gives:

```lean
theorem complement_toH3CPart_zero
    {a : H3O} (ha : InComplementOfB a) :
    toH3CPart a = 0
```

Then:
```lean
theorem complement_h3c_part_of_product_via_trace
    {a b : H3O} (ha : InComplementOfB a) (hb : InComplementOfB b) :
    toH3CPart (jordanProduct a b) = ...
```

The correct formula (from the trace form decomposition) is that
`toH3CPart (a ○ b)` is determined by `traceForm a b` applied via the
canonical h₃(ℂ)-projection.

## Achievable targets

If the full formula is too complex, prove the following:

### Part A: toH3CPart of complement elements is zero

```lean
/-- Elements of InComplementOfB have zero h₃(ℂ)-projection. -/
theorem complement_h3cPart_zero
    {a : H3O} (ha : InComplementOfB a) :
    toH3CPart a = 0
```

This should follow from the definition of `InComplementOfB` (zero diagonal +
complement off-diagonals) and the definition of `toH3CPart` (projects to
diagonal entries and complex-line off-diagonals).

### Part B: Decomposition of complement × complement

```lean
/-- The Jordan product of two complement elements decomposes as:
    a ○ b = (h₃(ℂ) part) + (complement part). -/
theorem complement_product_decomposes_explicitly
    {a b : H3O} (ha : InComplementOfB a) (hb : InComplementOfB b) :
    jordanProduct a b =
      toH3CPart (jordanProduct a b) + toComplementPart (jordanProduct a b) :=
  (decomp_sum (jordanProduct a b)).symm
```

This is just the canonical decomposition — trivially true from `decomp_sum`.

### Part C: The h₃(ℂ)-Jordan-module identity (key structural result)

```lean
/-- The Jordan module identity for h₃(ℂ) acting on the complement.
    For a ∈ h₃(ℂ) and X ∈ complement:
    (a ○ a) ○ (a ○ X) = a ○ ((a ○ a) ○ X). -/
theorem complement_jordan_module_identity
    {a : H3O} (ha : InStandardB a)
    {X : H3O} (hX : InComplementOfB X) :
    jordanProduct (jordanProduct a a) (jordanProduct a X) =
    jordanProduct a (jordanProduct (jordanProduct a a) X)
```

**Proof**: This is a special case of the Jordan identity `jordanIdentity_H3O`.
Apply `jordanIdentity_H3O a (jordanProduct a X)` and use the fact that
`a ○ a ∈ InStandardB` and `a ○ X ∈ InComplementOfB` (from `jordanProduct_standardB_complement`).

Actually the Jordan identity says `(a ○ b) ○ (a ○ a) = a ○ (b ○ (a ○ a))`.
Setting b = a gives `(a ○ a) ○ (a ○ a) = a ○ (a ○ (a ○ a))` — not what we want.
Setting b = X: `(a ○ X) ○ (a ○ a) = a ○ (X ○ (a ○ a))`.
By commutativity: `(a ○ a) ○ (a ○ X) = a ○ ((a ○ a) ○ X)`.
This IS the Jordan module identity!

### Bimodule package

```lean
structure ComplementJordanBimodulePackage where
  /-- h₃(ℂ) ○ complement ⊆ complement (already proved). -/
  left_module : ∀ {a X}, InStandardB a → InComplementOfB X →
      InComplementOfB (jordanProduct a X)
  /-- complement ○ complement ⊄ h₃(ℂ) (counterexample). -/
  not_right_subalgebra :
      ¬ ∀ {a b : H3O}, InComplementOfB a → InComplementOfB b →
          InStandardB (jordanProduct a b)
  /-- complement elements have zero h₃(ℂ)-projection. -/
  complement_h3c_zero : ∀ {a}, InComplementOfB a → toH3CPart a = 0
  /-- The Jordan module identity for the complement action. -/
  module_identity : ∀ {a X}, InStandardB a → InComplementOfB X →
      jordanProduct (jordanProduct a a) (jordanProduct a X) =
      jordanProduct a (jordanProduct (jordanProduct a a) X)

noncomputable def complementJordanBimodulePackage :
    ComplementJordanBimodulePackage
```

## Priority

The highest priority results are:
1. `complement_h3cPart_zero` — key coordinate fact
2. `complement_jordan_module_identity` — the module identity from Jordan identity
3. The `ComplementJordanBimodulePackage` bundle

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- For `complement_h3cPart_zero`: use `cases ha` or `simp +decide` on the
  `InComplementOfB` predicate and `toH3CPart` definition.
- For `complement_jordan_module_identity`: use `jordanIdentity_H3O` with
  `jordanProduct_comm` to get the right form.

## Verification

```bash
lake env lean PhysicsSM/Algebra/Jordan/ComplementJordanBimodule.lean
lake build PhysicsSM.Algebra.Jordan.ComplementJordanBimodule
```
