# Aristotle task: Inner derivations from h₃(ℂ) form a Lie subalgebra

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-03
**Submitted**: 2026-06-03
**Job ID**: `620b2e9a-8824-46c5-a5a9-c79870810d5a`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave7-20260603`
**Output**: `AgentTasks/aristotle-output/inner-deriv-standardb-lie-subalgebra-20260603`
**Type**: DVT structural result — inner derivations from h₃(ℂ) as a Lie subalgebra

## Goal

Create a new trusted file:

```text
PhysicsSM/Algebra/Jordan/InnerDerivationStandardBLieSubalgebra.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.InnerDerivationLieAlgebra
import PhysicsSM.Algebra.Jordan.InnerDerivationStandardBStabilizer
```

and namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.H3O
```

## Mathematical context

The preceding modules established:
1. `InStandardB_jordanProduct` — h₃(ℂ) is closed under ○ (Jordan subalgebra)
2. `innerDerivation_mem_standardB_stabilizer` — D_{a,b} stabilizes h₃(ℂ) when a,b ∈ h₃(ℂ)
3. `innerDerivation_commutator_formula` — [D_{a,b}, D_{c,d}] = D_{D_{a,b}(c), d} + D_{c, D_{a,b}(d)}

Combining these: if a,b,c,d ∈ h₃(ℂ), then:
- `D_{a,b}(c) ∈ h₃(ℂ)` — by `innerDerivation_mem_standardB_stabilizer`
- `D_{a,b}(d) ∈ h₃(ℂ)` — same
- `[D_{a,b}, D_{c,d}] = D_{D_{a,b}(c), d} + D_{c, D_{a,b}(d)}`

The right-hand side is a **sum of two inner derivations from h₃(ℂ) elements**
(since D_{a,b}(c), d ∈ h₃(ℂ) and c, D_{a,b}(d) ∈ h₃(ℂ)).

Therefore, the **linear span** of `{D_{a,b} | a,b ∈ h₃(ℂ)}` is closed under
the Lie bracket. This is the inner derivation Lie subalgebra of h₃(ℂ).

## Target declarations

### Main closure theorem

```lean
/-- The bracket of two inner derivations from h₃(ℂ) elements lies in the
    linear span of inner derivations from h₃(ℂ) elements. -/
theorem innerDerivation_standardB_bracket_in_standardB_span
    {a b c d : H3O}
    (ha : InStandardB a) (hb : InStandardB b)
    (hc : InStandardB c) (hd : InStandardB d) :
    commutator (innerDerivation a b) (innerDerivation c d) ∈
      innerDerivationSubspace
```

**Proof**: By `innerDerivation_commutator_formula`:
```
commutator (D_{a,b}) (D_{c,d})
  = D_{D_{a,b}(c), d} + D_{c, D_{a,b}(d)}
```
Both `D_{D_{a,b}(c), d}` and `D_{c, D_{a,b}(d)}` are inner derivations.
Since `D_{a,b}(c) ∈ h₃(ℂ)` (by stabilizer theorem) and `d ∈ h₃(ℂ)`,
`D_{D_{a,b}(c), d} ∈ innerDerivationSet`. Similarly for the second term.
Their sum is in `innerDerivationSubspace` (the Lie span) since it's the sum
of two elements in `innerDerivationSet ⊆ innerDerivationSubspace`.

```lean
/-- The inner derivation set from h₃(ℂ) elements:
    {D_{a,b} | a, b ∈ InStandardB}. -/
def innerDerivationStandardBSet : Set H3ODerivation :=
  {D | ∃ a b : H3O, InStandardB a ∧ InStandardB b ∧ D = innerDerivation a b}

/-- The linear span of inner derivations from h₃(ℂ) elements. -/
noncomputable def innerDerivationStandardBSubspace : Submodule ℝ H3ODerivation :=
  Submodule.span ℝ innerDerivationStandardBSet
```

### Lie subalgebra closure

```lean
/-- The span of inner derivations from h₃(ℂ) is closed under the
    commutator bracket. -/
theorem innerDerivationStandardBSubspace_closed_bracket
    {D E : H3ODerivation}
    (hD : D ∈ innerDerivationStandardBSubspace)
    (hE : E ∈ innerDerivationStandardBSubspace) :
    commutator D E ∈ innerDerivationStandardBSubspace
```

**Proof sketch**: By double `Submodule.span_induction` (same pattern as in
`InnerDerivationJacobiLie.lean`). For generators: use the bracket closure
theorem above. For the additive/scalar closures: use bilinearity of the Lie
bracket.

### Package

```lean
structure InnerDerivationStandardBLieSubalgebraPackage where
  /-- The set of inner derivations from h₃(ℂ) elements. -/
  standardB_set : Set H3ODerivation
  /-- The span is closed under brackets. -/
  bracket_closed :
    ∀ D E : H3ODerivation,
      D ∈ innerDerivationStandardBSubspace →
      E ∈ innerDerivationStandardBSubspace →
      commutator D E ∈ innerDerivationStandardBSubspace
  /-- Every generator is a D_{a,b} with a,b ∈ h₃(ℂ). -/
  generators :
    ∀ D ∈ innerDerivationStandardBSet,
      ∃ a b, InStandardB a ∧ InStandardB b ∧ D = innerDerivation a b
  /-- The stabilizer property: generators stabilize h₃(ℂ). -/
  stabilizes :
    ∀ {a b}, InStandardB a → InStandardB b →
      innerDerivation a b ∈ standardB_derivationStabilizer

noncomputable def innerDerivationStandardBLieSubalgebraPackage :
    InnerDerivationStandardBLieSubalgebraPackage
```

## Claim boundary

This file proves that the linear span of inner derivations from h₃(ℂ) is a
Lie subalgebra of `Der(h₃(𝕆))`. It does **not** prove:
- Dimension = 8 (which would identify this subalgebra with su(3)).
- That this subalgebra generates all derivations fixing h₃(ℂ).

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Use `Submodule.span_induction` and `lie_add`, `add_lie`, `smul_lie`,
  `lie_smul` for the bracket-closure proof (same pattern as in
  `InnerDerivationJacobiLie.lean`).
- The `toStabDerivation` bridge from `InnerDerivationStandardBStabilizer`
  may be needed for the stabilizer field.

## Verification

```bash
lake env lean PhysicsSM/Algebra/Jordan/InnerDerivationStandardBLieSubalgebra.lean
lake build PhysicsSM.Algebra.Jordan.InnerDerivationStandardBLieSubalgebra
```
