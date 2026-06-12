import Mathlib
import PhysicsSM.Algebra.Jordan.H3O
import PhysicsSM.Algebra.Jordan.TraceForm

/-!
# Algebra.Jordan.TraceFormFrobenius

Frobenius associativity of the trace form on the Albert algebra `h₃(𝕆)`.

## Mathematical context

The trace form `T(A, B) = tr(A ○ B)` on the exceptional Jordan algebra
satisfies Frobenius associativity:

  `T(A ○ B, C) = T(A, B ○ C)`

This is a key structural property that does *not* follow from associativity
of the Jordan product (which fails), but instead from the explicit coordinate
formula for the trace form combined with the symmetry properties of the
octonion inner product.

## Main results

- `traceForm_jordanProduct_left` — Frobenius associativity of the trace form.
- `traceForm_oneH3O_jordanProduct` — the Jordan unit recovers the trace form.
- `traceForm_jordanProduct_oneH3O` — symmetric variant of the unit identity.
- `TraceFormFrobeniusPackage` — bundled package of the above results.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

open PhysicsSM.Algebra.Octonion

local infixl:70 " ○ " => jordanProduct

/-! ## Frobenius associativity -/

/-- Frobenius associativity of the H3O trace form. -/
theorem traceForm_jordanProduct_left (a b c : H3O) :
    traceForm (jordanProduct a b) c =
    traceForm a (jordanProduct b c) := by
  simp [traceForm, jordanProduct, octonionInner]
  unfold trace; ring

/-- The Jordan unit recovers the trace-form definition. -/
theorem traceForm_oneH3O_jordanProduct (a b : H3O) :
    traceForm oneH3O (jordanProduct a b) = traceForm a b := by
  rw [← traceForm_jordanProduct_left, jordanProduct_oneH3O_left]

/-- Symmetric variant of the unit identity. -/
theorem traceForm_jordanProduct_oneH3O (a b : H3O) :
    traceForm (jordanProduct a b) oneH3O = traceForm a b := by
  rw [← traceForm_oneH3O_jordanProduct a b, traceForm_symm]

/-! ## Bundled package -/

/-- Bundled package of trace-form Frobenius identities. -/
structure TraceFormFrobeniusPackage where
  frobenius :
    ∀ a b c : H3O,
      traceForm (jordanProduct a b) c =
      traceForm a (jordanProduct b c)
  one_left :
    ∀ a b : H3O,
      traceForm oneH3O (jordanProduct a b) = traceForm a b
  one_right :
    ∀ a b : H3O,
      traceForm (jordanProduct a b) oneH3O = traceForm a b

noncomputable def traceFormFrobeniusPackage : TraceFormFrobeniusPackage where
  frobenius := traceForm_jordanProduct_left
  one_left := traceForm_oneH3O_jordanProduct
  one_right := traceForm_jordanProduct_oneH3O

end PhysicsSM.Algebra.Jordan.H3O
