# Aristotle task: Inner derivation Jacobi identity and Lie algebra instance

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-02
**Submitted**: 2026-06-02
**Job ID**: `4c41ae22-e93c-4906-9e80-6863e52008b7`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave5-20260602`
**Output**: `AgentTasks/aristotle-output/inner-derivation-jacobi-20260602`
**Type**: Step toward f₄ — Lie algebra structure on inner derivations

## Goal

Create a new trusted file:

```text
PhysicsSM/Algebra/Jordan/InnerDerivationJacobiLie.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.InnerDerivationLieAlgebra
```

and namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.H3O
```

## Existing infrastructure

From `InnerDerivationLieAlgebra.lean` (just integrated):

```lean
-- Already proved:
theorem innerDerivation_commutator_formula (a b c d : H3O) :
    commutator (innerDerivation a b) (innerDerivation c d) =
      innerDerivation ((innerDerivation a b).toFun c) d +
      innerDerivation c ((innerDerivation a b).toFun d)

theorem innerDerivation_bracket_closure (a b c d : H3O) :
    ∃ x y : H3O, commutator (innerDerivation a b) (innerDerivation c d) =
      innerDerivation x y

-- From InnerDerivation.lean:
theorem innerDerivation_antisymm (a b : H3O) :
    innerDerivation a b = -(innerDerivation b a)
theorem innerDerivation_add_left, innerDerivation_smul_left -- linearity
theorem innerDerivation_add_right, innerDerivation_smul_right -- bilinearity
```

From `Derivation.lean`:

```lean
def StabilizerDerivation.commutator (D E : H3ODerivation) : H3ODerivation
-- [D, E](x) = D(E(x)) - E(D(x))
```

## Target declarations

### Jacobi identity for inner derivations

The Jacobi identity `[[D₁,D₂],D₃] + [[D₂,D₃],D₁] + [[D₃,D₁],D₂] = 0`
holds for any three inner derivations because:
1. `commutator` is the standard Lie bracket on derivations
2. The Jacobi identity holds for any Lie bracket on a Lie algebra
3. The derivations of any algebra form a Lie algebra

The cleanest path: derive the Jacobi identity from the general fact that
derivations of an algebra form a Lie algebra. In Lean:

```lean
/-- The Jacobi identity for the commutator bracket on H3ODerivation. -/
theorem H3ODerivation_jacobi (D E F : H3ODerivation) :
    commutator (commutator D E) F +
    commutator (commutator E F) D +
    commutator (commutator F D) E = 0
```

**Proof sketch**: By the definition `[D, E](x) = D(E(x)) - E(D(x))`,
expand `[[D,E],F](x) = D(E(F(x))) - E(D(F(x))) - F(D(E(x))) + F(E(D(x)))`
and cyclically sum. All six terms cancel.

This is purely a consequence of how commutators compose, not specific to
Jordan algebras. The proof should work by `ext` + calculation.

### Inner derivation subspace closure under bracket

Formalize the subspace of inner derivations:

```lean
/-- The set of inner derivations: all elements of the form D_{a,b}. -/
def innerDerivationSubspace : Set H3ODerivation :=
  {D | ∃ a b : H3O, D = innerDerivation a b}
```

Prove it is closed under the commutator bracket:

```lean
theorem innerDerivationSubspace_closed_bracket
    {D E : H3ODerivation}
    (hD : D ∈ innerDerivationSubspace)
    (hE : E ∈ innerDerivationSubspace) :
    commutator D E ∈ innerDerivationSubspace
```

### LieAlgebra scaffold (if Mathlib permits)

If Mathlib has suitable Lie algebra typeclass infrastructure, try to
package this as a `LieRing` or `LieAlgebra ℝ` instance on the span of
inner derivations. The key data:
- Carrier: span of `{innerDerivation a b | a b : H3O}`
- Bracket: the commutator
- Axioms: `lieAlgebra_anti` (= antisymmetry ✓ from `innerDerivation_antisymm`)
           and `jacobi` (= Jacobi identity)

If the full instance is too infrastructure-heavy, prove the Jacobi identity
and the closure theorem and leave the instance for future work.

### Bilinearity package

Bundle the existing linearity results into a formal bilinear map:

```lean
/-- The inner derivation map as a bilinear map H₃(O) × H₃(O) → Der(H₃(O)). -/
noncomputable def innerDerivationBilinearMap :
    H3O →ₗ[ℝ] H3O →ₗ[ℝ] H3ODerivation where
  toFun a := {
    toFun b := innerDerivation a b
    map_add' := innerDerivation_add_right a
    map_smul' := innerDerivation_smul_right a }
  map_add' a₁ a₂ := by ext b; simp [innerDerivation_add_left]
  map_smul' r a := by ext b; simp [innerDerivation_smul_left]
```

### Bundled package

```lean
structure InnerDerivationJacobiLiePackage where
  /-- Jacobi identity for H3ODerivation commutators. -/
  jacobi : ∀ D E F : H3ODerivation,
      commutator (commutator D E) F +
      commutator (commutator E F) D +
      commutator (commutator F D) E = 0
  /-- Inner derivations are closed under brackets. -/
  bracket_closure : ∀ D E : H3ODerivation,
      D ∈ innerDerivationSubspace →
      E ∈ innerDerivationSubspace →
      commutator D E ∈ innerDerivationSubspace
  /-- The inner derivation map is bilinear. -/
  bilinear : H3O →ₗ[ℝ] H3O →ₗ[ℝ] H3ODerivation

noncomputable def innerDerivationJacobiLiePackage :
    InnerDerivationJacobiLiePackage
```

## Claim boundary

This file proves the Jacobi identity for the commutator bracket and the Lie
subalgebra structure of inner derivations. It does **not** prove:
- That inner derivations span all of `Der(h₃(𝕆))`.
- The dimension formula `dim InnDer(h₃(𝕆)) = 52 = dim f₄`.
- The isomorphism `InnDer(h₃(𝕆)) ≅ f₄`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- The Jacobi identity proof should be by `ext` + ring/tactic computation.
- Add to `PhysicsSM.lean` if sorry-free.

## Verification

```bash
lake env lean PhysicsSM/Algebra/Jordan/InnerDerivationJacobiLie.lean
lake build PhysicsSM.Algebra.Jordan.InnerDerivationJacobiLie
```
