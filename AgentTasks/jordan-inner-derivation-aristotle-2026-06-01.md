# Aristotle task: h₃(O) inner derivations

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `1e37d19b-fc93-40f5-bf0e-62aac3b7de4c`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave3-20260601`
**Output**: `AgentTasks/aristotle-output/jordan-inner-derivation-20260601`
**Type**: Jordan algebra inner derivation — step toward F₄

## Goal

Create a new trusted file:

```text
PhysicsSM/Algebra/Jordan/InnerDerivation.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.Derivation
import PhysicsSM.Algebra.Jordan.H3OJordan
import PhysicsSM.Algebra.Jordan.TraceForm
```

and namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.H3O
```

## Mathematical context

The **inner derivations** of the exceptional Jordan algebra h₃(𝕆) are maps
of the form:

```
D_{a,b}(c) = [[L_a, L_b], L_c]  (commutator of left-multiplication operators)
```

or equivalently, using the Jordan product `∘`:

```
D_{a,b}(c) = (a ∘ b) ∘ c - b ∘ (a ∘ c) - a ∘ (b ∘ c)
           = [L_a, L_b](c)
```

where `L_a(c) = a ∘ c`.

These are derivations of h₃(𝕆): they satisfy the Leibniz rule
`D(x ∘ y) = D(x) ∘ y + x ∘ D(y)`.

The inner derivations form the Lie algebra of the compact real form of
`F₄ = Aut(h₃(𝕆))`. This is a key step toward the DVT/Baez stabilizer theorem.

## Existing infrastructure

From `PhysicsSM.Algebra.Jordan.Derivation`:
- `H3ODerivation` — bundled derivation type with `map_add`, `map_smul`, `map_jordanProduct`
- `StabilizerDerivation.commutator` — bracket of derivations

From `PhysicsSM.Algebra.Jordan.H3OJordan`:
- `jordanProduct : H3O → H3O → H3O`
- The Jordan identity `jordanIdentity_H3O`

From `PhysicsSM.Algebra.Jordan.TraceForm`:
- `traceForm : H3O → H3O → ℝ`
- `traceForm_symm`, `traceForm_nonneg`, `traceForm_posDef`

## Target declarations

### Definition

```lean
/-- The inner derivation associated to a pair (a, b) in h₃(𝕆):
    `D_{a,b}(c) = [L_a, L_b](c) = (a ∘ b) ∘ c - b ∘ (a ∘ c) - a ∘ (b ∘ c)`.

    Note: in a general Jordan algebra, this is antisymmetric in (a, b) and
    defines a derivation. -/
noncomputable def innerDerivation (a b : H3O) : H3ODerivation where
  toFun c := jordanProduct (jordanProduct a b) c
            - jordanProduct b (jordanProduct a c)
            - jordanProduct a (jordanProduct b c)
  ...
```

### Basic properties

```lean
/-- D_{a,b} is antisymmetric: D_{a,b} = -D_{b,a}. -/
theorem innerDerivation_antisymm (a b : H3O) :
    innerDerivation a b = -(innerDerivation b a)

/-- D_{a,a} = 0. -/
theorem innerDerivation_self (a : H3O) :
    innerDerivation a a = 0

/-- D_{a,b} is additive in a. -/
theorem innerDerivation_add_left (a₁ a₂ b : H3O) :
    innerDerivation (a₁ + a₂) b =
      innerDerivation a₁ b + innerDerivation a₂ b

/-- D_{a,b} is real-linear in a. -/
theorem innerDerivation_smul_left (r : ℝ) (a b : H3O) :
    innerDerivation (r • a) b = r • innerDerivation a b
```

### Derivation property

```lean
/-- D_{a,b} satisfies the Jordan derivation law:
    D_{a,b}(x ∘ y) = D_{a,b}(x) ∘ y + x ∘ D_{a,b}(y). -/
theorem innerDerivation_jordanProduct (a b x y : H3O) :
    (innerDerivation a b).toFun (jordanProduct x y) =
      jordanProduct ((innerDerivation a b).toFun x) y +
      jordanProduct x ((innerDerivation a b).toFun y)
```

**Proof approach**: Expand `D_{a,b}(x ∘ y)` using the definition, then
use the Jordan identity and bilinearity of the Jordan product to show
the result equals `D(x) ∘ y + x ∘ D(y)`. This involves careful use of
`jordanProduct` associativity-like properties and may be a coordinate
calculation.

### Zero and one special cases

```lean
/-- D_{0,b} = 0. -/
theorem innerDerivation_zero_left (b : H3O) :
    innerDerivation 0 b = 0

/-- D_{a,0} = 0. -/
theorem innerDerivation_zero_right (a : H3O) :
    innerDerivation a 0 = 0
```

### Bundle as H3ODerivation

The key deliverable is proving that `innerDerivation a b`, as defined above,
satisfies the `H3ODerivation` API (in particular `map_jordanProduct`). If the
full derivation law is too hard, the priority is:

1. The definition type-checks as an `H3ODerivation`.
2. `innerDerivation_antisymm` — easy algebraic identity.
3. `innerDerivation_self` — immediate from antisymmetry.
4. The `map_jordanProduct` field — may need Jordan identity.

If `map_jordanProduct` requires sorry, provide a well-documented handoff note
explaining the barrier.

## Claim boundary

This file defines inner derivations of h₃(𝕆) and proves their basic
algebraic properties. It does **not** prove:
- That the inner derivations generate all of `Der(h₃(𝕆))`.
- That the Lie algebra of inner derivations is f₄.
- The isomorphism `Aut(h₃(𝕆)) ≅ F₄`.

## Constraints

- No `sorry` in the definition, `innerDerivation_antisymm`, or `innerDerivation_self`.
- If the full derivation law is blocked, document exactly what is needed.
- Do not weaken the `innerDerivation` definition or change the Jordan
  product convention.

## Verification

```bash
lake env lean PhysicsSM/Algebra/Jordan/InnerDerivation.lean
lake build PhysicsSM.Algebra.Jordan.InnerDerivation
```
