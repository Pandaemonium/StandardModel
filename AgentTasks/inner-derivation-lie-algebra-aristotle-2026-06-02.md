# Aristotle task: Inner derivations form a Lie subalgebra of Der(h₃(O))

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-02
**Submitted**: 2026-06-02
**Job ID**: `76937a15-39e2-45c9-93a0-94c0f2939bc5`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave4-20260602`
**Output**: `AgentTasks/aristotle-output/inner-derivation-lie-algebra-20260602`
**Type**: Step toward f₄ = Der(h₃(O))

## Goal

Create a new trusted file:

```text
PhysicsSM/Algebra/Jordan/InnerDerivationLieAlgebra.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.InnerDerivation
```

and namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.H3O
```

Prove that the inner derivations of `h₃(𝕆)` are closed under the commutator
bracket, establishing that they form a Lie subalgebra of `Der(h₃(𝕆))`.

## Existing infrastructure

From `PhysicsSM.Algebra.Jordan.InnerDerivation`:

```lean
-- Definition (already proved):
noncomputable def innerDerivation (a b : H3O) : H3ODerivation
-- D_{a,b}(c) = a ○ (b ○ c) - b ○ (a ○ c)

-- Key lemmas already proved:
theorem jordanIdentity_linearized (a b c d : H3O) : ...
theorem jordan_expansion (a b x y : H3O) : ...
theorem innerDerivation_leibniz (a b x y : H3O) : ...
theorem innerDerivation_antisymm (a b : H3O) : ...
theorem innerDerivation_add_left (a₁ a₂ b : H3O) : ...
theorem innerDerivation_smul_left (r : ℝ) (a b : H3O) : ...
```

From `PhysicsSM.Algebra.Jordan.Derivation`:

```lean
-- The commutator (bracket) of two derivations:
def StabilizerDerivation.commutator (D E : H3ODerivation) : H3ODerivation
-- [D, E](x) = D(E(x)) - E(D(x))
```

## Target declarations

### Key formula: bracket of inner derivations

In a Jordan algebra, the bracket of two inner derivations satisfies:

```text
[D_{a,b}, D_{c,d}] = D_{a, D_{b,c}(d)} + D_{D_{a,c}(b), d}
                   + D_{a, b ○ (c ○ d)} - D_{a, (b ○ c) ○ d} + ...
```

The exact formula is complex. The key result we need is **closure**:

```lean
/-- The bracket of two inner derivations is again an inner derivation.
    This is the key Lie subalgebra closure property. -/
theorem innerDerivation_bracket_closure (a b c d : H3O) :
    ∃ x y : H3O,
      commutator (innerDerivation a b) (innerDerivation c d) =
        innerDerivation x y
```

If the general closure theorem is too hard, prove it for the special case
where one of the derivations is `D_{e, f}` for specific elements, and prove
the general case by linearity. The following weaker but explicit form is also
acceptable:

```lean
/-- Explicit bracket formula for inner derivations. -/
theorem innerDerivation_commutator_formula (a b c d : H3O) :
    commutator (innerDerivation a b) (innerDerivation c d) =
      innerDerivation
        (a ○ (b ○ c) - b ○ (a ○ c))  -- = D_{a,b}(c)
        d
      + innerDerivation
        c
        (a ○ (b ○ d) - b ○ (a ○ d))  -- = D_{a,b}(d)
```

This formula says `[D_{a,b}, D_{c,d}] = D_{D_{a,b}(c), d} + D_{c, D_{a,b}(d)}`,
which is the standard formula for `[L_a, [L_c, L_d]] = [[L_a, L_c], L_d] + [L_c, [L_a, L_d]]`
from the Jacobi identity.

### Proof approach for the closure theorem

The bracket `[D, E](x) = D(E(x)) - E(D(x))` where D = `D_{a,b}` and E = `D_{c,d}`.

```text
D_{a,b}(D_{c,d}(x)) - D_{c,d}(D_{a,b}(x))
= D_{a,b}(c ○ (d ○ x) - d ○ (c ○ x))
  - D_{c,d}(a ○ (b ○ x) - b ○ (a ○ x))
```

Using linearity of `D_{a,b}` in the argument:
```text
= D_{a,b}(c ○ (d ○ x)) - D_{a,b}(d ○ (c ○ x))
  - D_{c,d}(a ○ (b ○ x)) + D_{c,d}(b ○ (a ○ x))
```

Each of these four terms can be expanded using `jordan_expansion` and
the Leibniz property. The result simplifies (by the fully linearized Jordan
identity) to a sum of inner derivations applied to `x`.

The key Lean ingredients:
1. `innerDerivation_leibniz` — for expanding `D_{a,b}(u ○ v)`
2. `jordan_expansion` — for `a ○ (b ○ (x ○ y))`
3. `jordanIdentity_linearized` — for cancellation of cross terms
4. `innerDerivation_add_left` and `innerDerivation_smul_left` — for linearity

### Bundled package

```lean
/-- Inner derivations form a Lie subalgebra. -/
structure InnerDerivationLieSubalgebra where
  /-- Inner derivations are closed under the commutator bracket. -/
  bracket_closure :
    ∀ a b c d : H3O,
      ∃ x y : H3O,
        commutator (innerDerivation a b) (innerDerivation c d) =
          innerDerivation x y

/-- The Lie subalgebra package for inner derivations. -/
noncomputable def innerDerivationLieSubalgebra :
    InnerDerivationLieSubalgebra
```

## Claim boundary

This file proves that inner derivations are closed under brackets. It does
**not** prove:
- That inner derivations generate ALL derivations `Der(h₃(𝕆))` (that would
  require knowing `dim Der = dim f₄ = 52`).
- The isomorphism `InnDer(h₃(𝕆)) ≅ 𝔣₄`.
- Any compact group or Lie group statements.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- If the full closure is too hard, prove the explicit formula
  `[D_{a,b}, D_{c,d}] = D_{D_{a,b}(c), d} + D_{c, D_{a,b}(d)}` instead —
  this is a cleaner and sufficient result.
- All proofs should be readable; avoid large `decide` or fragile `grind` finishes.
- Add the new file to `PhysicsSM.lean` if sorry-free.

## Verification

```bash
lake env lean PhysicsSM/Algebra/Jordan/InnerDerivationLieAlgebra.lean
lake build PhysicsSM.Algebra.Jordan.InnerDerivationLieAlgebra
```
