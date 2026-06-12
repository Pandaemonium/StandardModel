# Aristotle task: Derivations are trace-antisymmetric

**Agent**: Aristotle
**Status**: Submitted
**Priority**: High
**Prepared**: 2026-06-02
**Submitted**: 2026-06-02
**Job ID**: `32bc7d75-10b2-4e77-b18a-3e4cb76f1b77`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave6-20260602`
**Output**: `AgentTasks/aristotle-output/derivation-trace-antisymmetry-20260602`

## Result inspection

Status: OUT_OF_BUDGET, inspected 2026-06-04.

Downloaded output archive:
`AgentTasks/aristotle-output/32bc7d75-output`

Extracted output:
`AgentTasks/aristotle-output/32bc7d75-output-extracted/paper-wave6-20260602_aristotle`

No `PhysicsSM/Algebra/Jordan/DerivationTraceAntisymmetry.lean` file was
produced. The output copy of `PhysicsSM/Algebra/Jordan/TraceForm.lean` has no
diff against the live repository, so there was no trusted code to integrate.

Follow-up: split this into smaller jobs, first proving the trace-form Frobenius
identity for the Jordan product, then the inner-derivation antisymmetry target.
**Type**: Structural Jordan algebra result — derivations and the trace form

## Goal

Create a new trusted file:

```text
PhysicsSM/Algebra/Jordan/DerivationTraceAntisymmetry.lean
```

with imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.InnerDerivation
import PhysicsSM.Algebra.Jordan.TraceForm
```

and namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.H3O
```

## Mathematical context

The trace form `T(a,b) = tr(a ○ b)` on `h₃(𝕆)` satisfies a key invariance
property: derivations are **antisymmetric** with respect to it. That is, for
any derivation `D` and any `a, b : H3O`:

```text
T(D(a), b) + T(a, D(b)) = 0
```

This is the infinitesimal version of the statement "automorphisms of h₃(𝕆)
preserve the trace form." It supports the F₄ claim boundary: since F₄ =
Der(h₃(𝕆)) and the trace form is the canonical positive-definite form, the
derivation algebra is exactly the Lie algebra of the isometry group of T.

## Proof strategy

The key ingredients:

1. `D(1) = 0` for any derivation D.
   **Proof**: `D(1 ○ 1) = D(1) ○ 1 + 1 ○ D(1) = 2 · D(1)`.
   But `1 ○ 1 = 1`, so `D(1) = D(1 ○ 1) = 2 D(1)`, hence `D(1) = 0`.

2. `T(D(a), 1) = 0` for any derivation D and any `a`.
   **Proof**: `T(D(a), 1) = T(D(a) ○ 1) = tr(D(a) ○ 1)`. Since `x ○ 1 = x`,
   `T(D(a), 1) = tr(D(a))`. But D(1) = 0 and the trace `tr(x) = T(x, 1)`, so
   we need `T(D(a), 1) = 0`, i.e., `traceForm (D a) 1 = 0`.
   **Alternative**: Use the Leibniz rule on `a ○ 1 = a`:
   `D(a ○ 1) = D(a) ○ 1 + a ○ D(1) = D(a) + a ○ 0 = D(a)`. Consistent.
   **Better**: `T(D(a), b) + T(a, D(b)) = T(D(a ○ b)) - T(D(a) ○ b + a ○ D(b)) + T(D(a)) ○ b + T(a ○ D(b))` ... this is circular.

The cleanest proof uses the **derivation property directly** together with
**symmetry of the trace form**:

```text
traceForm a (D b) + traceForm (D a) b
= traceForm a (D b) + traceForm b (D a)   [by traceForm_symm]
= traceForm (a ○ (D b)) 1 + traceForm (b ○ (D a)) 1  [not right]
```

Better approach — use D(a ○ b) identity + traceForm as inner product:

```text
0 = traceForm 1 (D (a ○ a))         [since D maps to zero on scalars?]
```

Actually, the cleanest path in a coordinate Jordan algebra:

**Direct coordinate calculation**: Since `D : H3ODerivation` maps
`(α, β, γ, x, y, z)` coordinates to an output satisfying the derivation law,
and `traceForm a b = 2*(a.alpha*b.alpha + a.beta*b.beta + a.gamma*b.gamma)
+ 2*(inner(a.x, b.x) + inner(a.y, b.y) + inner(a.z, b.z))`, one can verify
`traceForm (D a) b + traceForm a (D b) = 0` by expanding via the Leibniz
rule on each component.

The simplest Lean approach:
```lean
theorem derivation_traceForm_antisymm (D : H3ODerivation) (a b : H3O) :
    traceForm (D.toFun (a ○ b)) 1 =
    traceForm (D.toFun a ○ b) 1 + traceForm (a ○ D.toFun b) 1 := by
  -- This is just the derivation law applied to traceForm(−, 1)
  simp [D.leibniz', traceForm_add_left]
```

Then derive antisymmetry:
```lean
theorem derivation_traceForm_antisymm (D : H3ODerivation) (a b : H3O) :
    traceForm (D.toFun a) b + traceForm a (D.toFun b) = 0
```

**Key insight**: `traceForm a b = traceForm 1 (a ○ b)` is the key rewriting.
If this holds, then:
```text
traceForm (D a) b + traceForm a (D b)
= traceForm 1 ((D a) ○ b) + traceForm 1 (a ○ (D b))
= traceForm 1 ((D a) ○ b + a ○ (D b))
= traceForm 1 (D (a ○ b))
```
And `traceForm 1 (D x) = traceForm (D x) 1 = ?`. If D(1) = 0 and the trace
form `T(x, 1) = tr(x)` is a derivation-invariant functional (derivations are
traceless), then this = 0.

**Tracelessness of derivations**: `(D x).alpha + (D x).beta + (D x).gamma = 0`
for all x. This follows from D(1) = 0:
```
D(1) = 0 means (D(1)).alpha = (D(1)).beta = (D(1)).gamma = 0.
But 1 = (1, 1, 1, 0, 0, 0), so D(1) = (c, c', c'', ...) with all components.
The trace of D(1) = 0 gives c + c' + c'' = 0.
But D is not just killing 1; we need D(x) to be traceless for ALL x.
```

Actually, tracelessness for derivations comes from the fact that
`D(a ○ b) = D(a) ○ b + a ○ D(b)` implies
`tr(D(a ○ b)) = tr(D(a) ○ b) + tr(a ○ D(b))`
i.e., `T(1, D(a ○ b)) = T(1, D(a) ○ b) + T(1, a ○ D(b))`
Specializing a = b = 1 and using D(1) = 0 and 1 ○ 1 = 1:
`T(1, D(1)) = T(1, D(1) ○ 1) + T(1, 1 ○ D(1)) = 2 T(1, D(1))`
So `T(1, D(1)) = 0`. But D(1) = 0 already.

More generally: take b = 1 in `T(1, D(a ○ b)) = T(1, D(a) ○ b + a ○ D(b))`:
`T(1, D(a)) = T(1, D(a) ○ 1 + a ○ D(1)) = T(1, D(a)) + T(1, a ○ 0) = T(1, D(a))`
This is circular. We need a different approach.

**Correct proof via symmetry**: Use `traceForm_symm` and the Leibniz rule:
```text
T(D(a), b) = T(b, D(a))   [symm]
           = T(1, b ○ D(a))  [if T(x,y) = T(1, x ○ y)]
T(a, D(b)) = T(1, a ○ D(b))

T(D(a), b) + T(a, D(b)) = T(1, b ○ D(a) + a ○ D(b))
```

Now: `b ○ D(a) + a ○ D(b) = ?` vs `D(a ○ b)`. By Leibniz:
`D(a ○ b) = D(a) ○ b + a ○ D(b)`. Note `D(a) ○ b = b ○ D(a)` (Jordan product commutes). So:
`D(a ○ b) = b ○ D(a) + a ○ D(b) = b ○ D(a) + a ○ D(b)`

Therefore: `T(D(a), b) + T(a, D(b)) = T(1, D(a ○ b))`.

So the result reduces to: **T(1, D(x)) = 0 for all D : H3ODerivation, x : H3O**.
This means the trace form against 1 is a D-invariant. Equivalently: `D(x).alpha + D(x).beta + D(x).gamma = 0` for all derivations D and all x H3O.

This IS a coordinate identity that follows from the explicit derivation law.
If Aristotle cannot prove the general case, prove it for **inner derivations** first:

```lean
theorem innerDerivation_traceForm_antisymm (a b c d : H3O) :
    traceForm ((innerDerivation a b).toFun c) d +
    traceForm c ((innerDerivation a b).toFun d) = 0
```

Then extend to all derivations using the Jacobi closure (inner derivations span all derivations... wait, we don't have that).

**Achievable minimum**: Prove it for inner derivations and package as a trusted result.

## Target declarations

```lean
/-- Derivations (at least inner ones) are traceless:
    T(D(a), 1) = 0 for any derivation D and any a. -/
theorem innerDerivation_trace_zero (a b c : H3O) :
    traceForm ((innerDerivation a b).toFun c) 1 = 0

/-- For inner derivations, the trace form is antisymmetric. -/
theorem innerDerivation_traceForm_antisymm (a b x y : H3O) :
    traceForm ((innerDerivation a b).toFun x) y +
    traceForm x ((innerDerivation a b).toFun y) = 0

/-- For all H3ODerivations, T(D(a), b) + T(a, D(b)) = 0.
    If this is too hard, prove it for inner derivations only. -/
theorem derivation_traceForm_antisymm
    (D : H3ODerivation) (a b : H3O) :
    traceForm (D.toFun a) b + traceForm a (D.toFun b) = 0
```

**Package:**

```lean
structure DerivationTraceAntisymmetryPackage where
  /-- Inner derivations are traceless: T(D_{a,b}(c), 1) = 0. -/
  inner_trace_zero :
    ∀ a b c : H3O, traceForm ((innerDerivation a b).toFun c) 1 = 0
  /-- Inner derivations are trace-antisymmetric. -/
  inner_antisymm :
    ∀ a b x y : H3O,
      traceForm ((innerDerivation a b).toFun x) y +
      traceForm x ((innerDerivation a b).toFun y) = 0

noncomputable def derivationTraceAntisymmetryPackage :
    DerivationTraceAntisymmetryPackage
```

## Claim boundary

This file proves trace-antisymmetry for inner derivations. It does **not** prove:
- Tracelessness for all derivations (needs spanning argument).
- The identification `Der(h₃(𝕆)) ≅ f₄`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- If the general `derivation_traceForm_antisymm` requires a difficult calculation,
  prove `innerDerivation_traceForm_antisymm` instead and note the extension
  to all derivations as a handoff.

## Verification

```bash
lake env lean PhysicsSM/Algebra/Jordan/DerivationTraceAntisymmetry.lean
lake build PhysicsSM.Algebra.Jordan.DerivationTraceAntisymmetry
```
