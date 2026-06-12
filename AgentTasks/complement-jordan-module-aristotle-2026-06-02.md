# Aristotle task: h₃(ℂ) acts on the complement as Jordan module

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-02
**Submitted**: 2026-06-02
**Job ID**: `0ab50bde-9a16-47cd-b616-8996c9eb2513`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave6-20260602`
**Output**: `AgentTasks/aristotle-output/complement-jordan-module-20260602`
**Type**: DVT structural result — Jordan module decomposition

## Goal

Create a new trusted file:

```text
PhysicsSM/Algebra/Jordan/ComplementJordanModule.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.InnerDerivationStandardBStabilizer
import PhysicsSM.Algebra.Jordan.TraceForm
```

and namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.H3O
```

## Mathematical context

The exceptional Jordan algebra `h₃(𝕆)` decomposes as a real vector space:

```text
h₃(𝕆) = h₃(ℂ)  ⊕  M₃(ℂ)_complement
```

where `h₃(ℂ)` (`InStandardB`) is a Jordan subalgebra and `M₃(ℂ)_complement`
(`InComplementOfB`) is the trace-form orthogonal complement.

The key structural fact needed for the DVT approach: the complement is a
**Jordan module** over `h₃(ℂ)`. This means: for `a ∈ h₃(ℂ)` and `X` in the
complement, the Jordan product `a ○ X` is **again in the complement**.

Combined with `InnerDerivationStandardBStabilizer` (which proves inner
derivations from h₃(ℂ) stabilize h₃(ℂ) and hence act on the complement),
this establishes the full module structure.

## Existing infrastructure

From `InnerDerivationStandardBStabilizer.lean`:
- `InStandardB_jordanProduct` — h₃(ℂ) is closed under ○.
- `InStandardB_sub` — h₃(ℂ) is closed under subtraction.

From `TraceForm.lean`:
- `traceForm_orthogonal` — h₃(ℂ) and complement are trace-form orthogonal.
- `traceForm_symm`, `traceForm_add_left` — bilinearity.
- `decomp_sum` — `a = toH3CPart a + toComplementPart a`.

## Target declarations

### Core module action theorem

```lean
/-- The Jordan product of a standard-B element with a complement element
    lies in the complement: h₃(ℂ) ○ complement ⊆ complement. -/
theorem jordanProduct_standardB_complement
    {a : H3O} (ha : InStandardB a)
    {X : H3O} (hX : InComplementOfB X) :
    InComplementOfB (jordanProduct a X)
```

**Proof approach**: An element `Y : H3O` is in `InComplementOfB` iff
`traceForm Y b = 0` for all `b ∈ InStandardB` (by the orthogonality of the
decomposition and the trace form being non-degenerate).

So we need to show `traceForm (a ○ X) b = 0` for all `b : InStandardB`.

Using symmetry and associativity-like properties of the trace form:
```text
traceForm (a ○ X) b = traceForm X (a ○ b)   [associativity of traceForm w.r.t. ○]
```
Since `a, b ∈ h₃(ℂ)`, `a ○ b ∈ h₃(ℂ)` (by `InStandardB_jordanProduct`).
Since `X ∈ complement` and `a ○ b ∈ h₃(ℂ)`, `traceForm X (a ○ b) = 0`
by `traceForm_orthogonal`.

The key lemma needed is:

```lean
/-- The trace form satisfies a Jordan-associativity identity:
    T((a ○ x), y) = T(x, (a ○ y)) when a is self-adjoint. -/
theorem traceForm_jordan_assoc (a x y : H3O) :
    traceForm (jordanProduct a x) y = traceForm x (jordanProduct a y)
```

This is a fundamental property of the exceptional Jordan algebra:
`tr((a ○ x) ○ y) = tr(x ○ (a ○ y))` follows from the associativity of the
trace with respect to the Jordan product (since `tr` is a "trace form" in the
Jordan sense). In coordinates, `tr(AB) = tr(BA)` for matrices, and the Jordan
product `a ○ x = (ax + xa)/2` makes this:
```text
tr(((ax+xa)/2)y) = tr(xy⁺ + (xay+yax)/2 + ...) ??? 
```

Actually the identity follows from the **associativity of the trace form**:
`T(a ○ x, y) = T(a, x ○ y)` is NOT always true. The correct identity in a
Jordan algebra is: `T(x ○ y, z) = T(x, y ○ z)` ONLY if T is associative,
which it is for special Jordan algebras. For the Albert algebra (exceptional),
the trace form IS associative: `T(x ○ y, z) = T(x, y ○ z)`.

In our setting: `traceForm (a ○ x) y = traceForm a (x ○ y)` would give:
`traceForm (a ○ X) b = traceForm a (X ○ b) = 0` since `X ∈ complement` and
the Jordan product of complement with h₃(ℂ) lands in complement (by the
module property — but that's what we're trying to prove, circular!).

**Alternative proof**: Use the explicit `H3O` coordinate structure. An element
`Y = (α', β', γ', x', y', z')` is in `InComplementOfB Y` iff:
- `α' = 0`, `β' = 0`, `γ' = 0` (zero diagonal)
- `x'`, `y'`, `z'` are in the octonionic complement (not in ℂ·1 + ℂ·e111)

For `a ∈ InStandardB` (off-diagonal entries of a in complex line ℂ) and
`X ∈ InComplementOfB` (off-diagonal entries of X in complement), the product
`a ○ X = (aX + Xa)/2` has:
- Diagonal entries: `(aX)_{ii} = Σ_k a_{ik} X_{ki}`. Since `X_{ki}` are in
  the complement and `a_{ik}` are in the complex line, their product is in the
  complement. But the diagonal entries are: `a_{ii} X_{ii}` (diagonal × diagonal
  = zero since X has zero diagonal) + off-diagonal cross terms whose sum is
  imaginary and hence zero after taking real part. So diagonal = 0. ✓
- Off-diagonal entries: products of complex line entries with complement
  entries, which remain in the complement. ✓

This coordinate argument, while detailed, should be accessible to Aristotle
via `simp` on the `InChosenComplexLine` and `InChosenComplexComplement` predicates.

### Symmetry of complement action

```lean
/-- The complement is also closed under right action: complement ○ h₃(ℂ) ⊆ complement. -/
theorem jordanProduct_complement_standardB
    {X : H3O} (hX : InComplementOfB X)
    {a : H3O} (ha : InStandardB a) :
    InComplementOfB (jordanProduct X a) := by
  rw [jordanProduct_comm]
  exact jordanProduct_standardB_complement ha hX
```

### Module identity

```lean
/-- The Jordan module identity: (a ○ a) ○ (X ○ b) = a ○ (a ○ (X ○ b)) for
    a ∈ h₃(ℂ), X ∈ complement, b ∈ h₃(ℂ). Follows from Jordan identity. -/
theorem complement_module_jordan_identity
    {a b : H3O} (ha : InStandardB a) (hb : InStandardB b)
    {X : H3O} (hX : InComplementOfB X) :
    jordanProduct (jordanProduct a a) (jordanProduct X b) =
    jordanProduct a (jordanProduct a (jordanProduct X b))
```

### Package

```lean
structure ComplementJordanModulePackage where
  /-- h₃(ℂ) ○ complement ⊆ complement. -/
  standardB_acts_on_complement :
    ∀ {a X : H3O}, InStandardB a → InComplementOfB X →
      InComplementOfB (jordanProduct a X)
  /-- complement ○ h₃(ℂ) ⊆ complement. -/
  complement_acts_by_standardB :
    ∀ {X a : H3O}, InComplementOfB X → InStandardB a →
      InComplementOfB (jordanProduct X a)

noncomputable def complementJordanModulePackage :
    ComplementJordanModulePackage
```

## Claim boundary

This file proves that h₃(ℂ) acts on the complement of h₃(ℂ) in h₃(𝕆) as a
Jordan module (the complement is closed under the h₃(ℂ) action). It does
**not** prove:
- The full bimodule structure (complement ○ complement ⊆ h₃(ℂ) — that is
  a separate result, likely true but harder).
- Any irreducibility statement.
- Connection to the standard SU(3) representation theory.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- If `traceForm_jordan_assoc` is needed, prove it as a helper lemma using
  coordinate expansion.
- The coordinate approach (checking `InChosenComplexComplement` of each
  entry) is acceptable if cleaner.

## Verification

```bash
lake env lean PhysicsSM/Algebra/Jordan/ComplementJordanModule.lean
lake build PhysicsSM.Algebra.Jordan.ComplementJordanModule
```
