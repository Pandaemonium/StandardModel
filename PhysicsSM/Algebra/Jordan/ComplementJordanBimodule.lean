import Mathlib
import PhysicsSM.Algebra.Jordan.ComplementJordanModule
import PhysicsSM.Algebra.Jordan.ComplementJordanProductCounterexample
import PhysicsSM.Algebra.Jordan.TraceForm
import PhysicsSM.Algebra.Jordan.H3OJordan

/-!
# Algebra.Jordan.ComplementJordanBimodule

The complete Jordan bimodule picture for the complement of `h₃(ℂ)` in
`h₃(𝕆)`.

## Mathematical context

The preceding modules established:
- `jordanProduct_standardB_complement` — h₃(ℂ) ○ complement ⊆ complement ✓
- `not_forall_complement_complement_product_standardB` —
  complement ○ complement ⊄ h₃(ℂ) ✗

This file provides the **complete picture** of the Jordan bimodule
structure:
1. The complement is **closed under the h₃(ℂ)-module action** (already
   proved).
2. Complement × complement **maps to both summands**:
   `a ○ b = toH3CPart(a ○ b) + toComplementPart(a ○ b)`.
3. Elements of the complement have zero h₃(ℂ)-projection.
4. The **Jordan module identity** holds for the h₃(ℂ) action on the
   complement.

## Main declarations

- `complement_h3cPart_zero` — complement elements have zero
  h₃(ℂ)-projection.
- `complement_product_decomposes_explicitly` — Jordan product of
  complement elements decomposes canonically.
- `complement_jordan_module_identity` — the Jordan module identity
  `(a ○ a) ○ (a ○ X) = a ○ ((a ○ a) ○ X)` for `a ∈ h₃(ℂ)`,
  `X ∈ complement`.
- `ComplementJordanBimodulePackage` — bundle of all bimodule structure
  results.

## Status

Trusted module — no `sorry`.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

open PhysicsSM.Algebra.Octonion

local infixl:70 " ○ " => jordanProduct

/-! ## Part A: toH3CPart of complement elements is zero -/

/-- Elements of `InComplementOfB` have zero h₃(ℂ)-projection.
    This is a restatement of `toH3CPart_of_inComplementOfB` with a
    more discoverable name for the bimodule context. -/
theorem complement_h3cPart_zero
    {a : H3O} (ha : InComplementOfB a) :
    toH3CPart a = 0 :=
  toH3CPart_of_inComplementOfB ha

/-! ## Part B: Decomposition of complement × complement -/

/-- The Jordan product of any two elements decomposes as:
    `a ○ b = (h₃(ℂ) part) + (complement part)`. -/
theorem complement_product_decomposes_explicitly
    (a b : H3O) :
    a ○ b = toH3CPart (a ○ b) + toComplementPart (a ○ b) :=
  decomp_sum (a ○ b)

/-! ## Part C: The Jordan module identity -/

/-- The Jordan module identity for h₃(ℂ) acting on the complement.
    For `a ∈ h₃(ℂ)` and `X ∈ complement`:
    `(a ○ a) ○ (a ○ X) = a ○ ((a ○ a) ○ X)`.

    This is a direct consequence of the Jordan identity
    `jordanIdentity_H3O` applied with `b := X`:
    `(a ○ X) ○ (a ○ a) = a ○ (X ○ (a ○ a))`,
    and commutativity of the Jordan product. -/
theorem complement_jordan_module_identity
    {a : H3O} (_ha : InStandardB a)
    {X : H3O} (_hX : InComplementOfB X) :
    (a ○ a) ○ (a ○ X) =
    a ○ ((a ○ a) ○ X) := by
  rw [jordanProduct_comm (a ○ a) (a ○ X),
      H3OJordan.jordanIdentity_H3O a X,
      jordanProduct_comm X (a ○ a)]

/-! ## Bimodule package -/

/-- Package of the complete Jordan bimodule structure for the
    complement. -/
structure ComplementJordanBimodulePackage where
  /-- h₃(ℂ) ○ complement ⊆ complement (already proved). -/
  left_module :
    ∀ {a X}, InStandardB a → InComplementOfB X →
      InComplementOfB (jordanProduct a X)
  /-- complement ○ complement ⊄ h₃(ℂ) (counterexample). -/
  not_right_subalgebra :
    ¬ ∀ {a b : H3O}, InComplementOfB a →
        InComplementOfB b → InStandardB (jordanProduct a b)
  /-- complement elements have zero h₃(ℂ)-projection. -/
  complement_h3c_zero :
    ∀ {a}, InComplementOfB a → toH3CPart a = 0
  /-- The Jordan module identity for the complement action. -/
  module_identity :
    ∀ {a X}, InStandardB a → InComplementOfB X →
      jordanProduct (jordanProduct a a) (jordanProduct a X) =
      jordanProduct a (jordanProduct (jordanProduct a a) X)

/-- The complement Jordan bimodule package, witnessing the complete
    bimodule structure. -/
noncomputable def complementJordanBimodulePackage :
    ComplementJordanBimodulePackage where
  left_module ha hX :=
    jordanProduct_standardB_complement ha hX
  not_right_subalgebra h :=
    complementCounterexample_product_not_standardB
      (h complementCounterexampleX_mem
        complementCounterexampleY_mem)
  complement_h3c_zero ha :=
    complement_h3cPart_zero ha
  module_identity ha hX :=
    complement_jordan_module_identity ha hX

end PhysicsSM.Algebra.Jordan.H3O
