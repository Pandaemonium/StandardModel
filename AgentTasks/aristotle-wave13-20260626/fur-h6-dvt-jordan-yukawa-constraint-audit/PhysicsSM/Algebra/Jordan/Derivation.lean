import Mathlib
import PhysicsSM.Algebra.Jordan.H3O

/-!
# Algebra.Jordan.Derivation

The Lie algebra of derivations of the exceptional Jordan algebra `h₃(𝕆)`.

## Overview

A derivation of `h₃(𝕆)` is a linear map `D : H3O → H3O` satisfying the
Jordan Leibniz rule:

```text
D(a ○ b) = D(a) ○ b + a ○ D(b)
```

The derivations form a Lie algebra under the commutator bracket
`[D₁, D₂] = D₁ ∘ D₂ − D₂ ∘ D₁`. This Lie algebra is the infinitesimal
counterpart of the automorphism group of `h₃(𝕆)`.

Claim boundary: this module defines and proves algebraic facts about the
derivation Lie algebra. It does not prove the identification of this Lie
algebra with `𝔣₄` — that requires dimension counting and simplicity arguments
beyond the current trusted development.

## Main definitions

- `H3ODerivation` — the type of Jordan derivations.
- `H3ODerivation.commutator` — the Lie bracket on derivations.
- Additive group structure (`Zero`, `Add`, `Neg`, `Sub`).
- `LieRing` and `LieAlgebra ℝ` instances.

## Main results

- `commutator_isDerivation` — the commutator of two derivations satisfies the
  Jordan Leibniz rule (i.e., is again a derivation).
- `H3ODerivation.map_zero'` — derivations preserve zero.
- `H3ODerivation.map_oneH3O` — derivations map the Jordan unit to zero.

## Future targets

- `H3ODerivation.map_trace` — derivations annihilate the trace. This requires
  the trace-form associativity `trace((a ○ b) ○ c) = trace(a ○ (b ○ c))` or
  an explicit basis decomposition argument, which is deferred.

## Status

This is a **trusted** module: all definitions and theorems are fully proved.
No `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, or `u n s a f e`.
-/

namespace PhysicsSM.Algebra.Jordan.Derivation

open PhysicsSM.Algebra.Jordan.H3O

local infixl:70 " ○ " => jordanProduct

/-! ## AddCommGroup and Module ℝ instances for H3O

The H3O type has componentwise `Add`, `Neg`, `Zero`, `Sub`, `SMul ℝ` and
simp lemmas for coordinate access. We build the full algebraic hierarchy
needed for abstract derivation proofs.
-/

instance : AddCommGroup H3O where
  add_assoc := by intro a b c; ext <;> simp <;> ring
  zero_add := by intro a; ext <;> simp
  add_zero := by intro a; ext <;> simp
  nsmul := nsmulRec
  zsmul := zsmulRec
  neg_add_cancel := by intro a; ext <;> simp
  add_comm := by intro a b; ext <;> simp <;> ring
  sub_eq_add_neg := by intro _ _; rfl

instance : Module ℝ H3O where
  one_smul := by intro a; ext <;> simp
  mul_smul := by intro r s a; ext <;> simp <;> ring
  smul_zero := by intro r; ext <;> simp
  smul_add := by intro r a b; ext <;> simp <;> ring
  add_smul := by intro r s a; ext <;> simp <;> ring
  zero_smul := by intro a; ext <;> simp

/-! ### Jordan product linearity

These lemmas establish that the Jordan product is bilinear. The proofs
expand all 27 H3O coordinates and call `ring`, requiring extra heartbeats.
-/

set_option maxHeartbeats 400000 in
-- 27-coordinate polynomial verification needs extra heartbeats
theorem jordanProduct_zero_left (b : H3O) : (0 : H3O) ○ b = 0 := by
  ext <;> simp [jordanProduct, octonionInner]

theorem jordanProduct_zero_right (a : H3O) : a ○ (0 : H3O) = 0 := by
  rw [jordanProduct_comm]; exact jordanProduct_zero_left a

set_option maxHeartbeats 400000 in
-- 27-coordinate polynomial verification needs extra heartbeats
theorem jordanProduct_add_left (a₁ a₂ b : H3O) :
    (a₁ + a₂) ○ b = a₁ ○ b + a₂ ○ b := by
  ext <;> simp [jordanProduct, octonionInner] <;> ring

theorem jordanProduct_add_right (a b₁ b₂ : H3O) :
    a ○ (b₁ + b₂) = a ○ b₁ + a ○ b₂ := by
  rw [jordanProduct_comm, jordanProduct_add_left,
      jordanProduct_comm b₁, jordanProduct_comm b₂]

set_option maxHeartbeats 400000 in
-- 27-coordinate polynomial verification needs extra heartbeats
theorem jordanProduct_neg_left (a b : H3O) : (-a) ○ b = -(a ○ b) := by
  ext <;> simp [jordanProduct, octonionInner] <;> ring

theorem jordanProduct_neg_right (a b : H3O) : a ○ (-b) = -(a ○ b) := by
  rw [jordanProduct_comm, jordanProduct_neg_left, jordanProduct_comm]

theorem jordanProduct_sub_left (a₁ a₂ b : H3O) :
    (a₁ - a₂) ○ b = a₁ ○ b - a₂ ○ b := by
  simp only [sub_eq_add_neg]
  rw [jordanProduct_add_left, jordanProduct_neg_left]

theorem jordanProduct_sub_right (a b₁ b₂ : H3O) :
    a ○ (b₁ - b₂) = a ○ b₁ - a ○ b₂ := by
  simp only [sub_eq_add_neg]
  rw [jordanProduct_add_right, jordanProduct_neg_right]

set_option maxHeartbeats 400000 in
-- 27-coordinate polynomial verification needs extra heartbeats
theorem jordanProduct_smul_left (r : ℝ) (a b : H3O) :
    (r • a) ○ b = r • (a ○ b) := by
  ext <;> simp [jordanProduct, octonionInner] <;> ring

theorem jordanProduct_smul_right (r : ℝ) (a b : H3O) :
    a ○ (r • b) = r • (a ○ b) := by
  rw [jordanProduct_comm, jordanProduct_smul_left, jordanProduct_comm]

/-! ## The derivation structure -/

/--
A Jordan derivation of `h₃(𝕆)`.

A derivation is a real-linear map satisfying the Leibniz rule with respect
to the Jordan product. This is the infinitesimal analogue of a Jordan
automorphism.
-/
structure H3ODerivation where
  /-- The underlying function. -/
  toFun : H3O → H3O
  /-- Additivity. -/
  map_add' : ∀ a b, toFun (a + b) = toFun a + toFun b
  /-- Real-scalar homogeneity. -/
  map_smul' : ∀ (r : ℝ) (a : H3O), toFun (r • a) = r • toFun a
  /-- The Jordan Leibniz rule: `D(a ○ b) = D(a) ○ b + a ○ D(b)`. -/
  leibniz' : ∀ a b, toFun (a ○ b) = toFun a ○ b + a ○ toFun b

instance : CoeFun H3ODerivation (fun _ => H3O → H3O) where
  coe D := D.toFun

@[simp]
theorem H3ODerivation.coe_toFun (D : H3ODerivation) : D.toFun = ⇑D := rfl

@[ext]
theorem H3ODerivation.ext {D₁ D₂ : H3ODerivation}
    (h : ∀ a, D₁ a = D₂ a) : D₁ = D₂ := by
  cases D₁; cases D₂; simp only [mk.injEq]; exact funext h

theorem H3ODerivation.map_add (D : H3ODerivation) (a b : H3O) :
    D (a + b) = D a + D b := D.map_add' a b

theorem H3ODerivation.map_smul (D : H3ODerivation) (r : ℝ) (a : H3O) :
    D (r • a) = r • D a := D.map_smul' r a

theorem H3ODerivation.leibniz (D : H3ODerivation) (a b : H3O) :
    D (a ○ b) = D a ○ b + a ○ D b := D.leibniz' a b

theorem H3ODerivation.map_neg (D : H3ODerivation) (a : H3O) :
    D (-a) = -(D a) := by
  have h := D.map_smul (-1) a
  simp only [neg_one_smul] at h; exact h

theorem H3ODerivation.map_sub (D : H3ODerivation) (a b : H3O) :
    D (a - b) = D a - D b := by
  simp only [sub_eq_add_neg]; rw [D.map_add, D.map_neg]

/-! ## Derivations preserve zero -/

/-- A derivation maps zero to zero. -/
theorem H3ODerivation.map_zero' (D : H3ODerivation) : D (0 : H3O) = 0 := by
  have h := D.map_smul 0 (0 : H3O)
  simp only [zero_smul] at h; exact h

/-! ## Derivations annihilate the Jordan unit -/

/-- A derivation maps the Jordan unit `1` to zero.

From `D(1 ○ 1) = D(1) ○ 1 + 1 ○ D(1)` and `1 ○ 1 = 1`,
we get `D(1) = D(1) + D(1)`, hence `D(1) = 0`. -/
theorem H3ODerivation.map_oneH3O (D : H3ODerivation) : D oneH3O = 0 := by
  have h := D.leibniz oneH3O oneH3O
  rw [jordanProduct_oneH3O_left] at h
  rw [jordanProduct_oneH3O_left, jordanProduct_oneH3O_right] at h
  -- h : D oneH3O = D oneH3O + D oneH3O, i.e. x = x + x
  have h2 : D oneH3O + (0 : H3O) = D oneH3O + D oneH3O := by
    rw [add_zero]; exact h
  exact (add_left_cancel h2).symm

/-! ## Additive group structure -/

/-- The zero derivation. -/
instance : Zero H3ODerivation where
  zero :=
    { toFun := fun _ => 0
      map_add' := fun _ _ => by simp
      map_smul' := fun _ _ => by simp
      leibniz' := fun _ _ => by
        simp only [jordanProduct_zero_left, jordanProduct_zero_right, add_zero] }

@[simp] theorem H3ODerivation.zero_apply (a : H3O) :
    (0 : H3ODerivation) a = 0 := rfl

/-- Addition of derivations. -/
instance : Add H3ODerivation where
  add D₁ D₂ :=
    { toFun := fun a => D₁ a + D₂ a
      map_add' := fun a b => by
        rw [D₁.map_add, D₂.map_add]; abel
      map_smul' := fun r a => by
        rw [D₁.map_smul, D₂.map_smul, smul_add]
      leibniz' := fun a b => by
        rw [D₁.leibniz, D₂.leibniz,
            jordanProduct_add_left, jordanProduct_add_right]; abel }

@[simp] theorem H3ODerivation.add_apply (D₁ D₂ : H3ODerivation) (a : H3O) :
    (D₁ + D₂) a = D₁ a + D₂ a := rfl

/-- Negation of derivations. -/
instance : Neg H3ODerivation where
  neg D :=
    { toFun := fun a => -(D a)
      map_add' := fun a b => by rw [D.map_add]; abel
      map_smul' := fun r a => by rw [D.map_smul, smul_neg]
      leibniz' := fun a b => by
        rw [D.leibniz, jordanProduct_neg_left, jordanProduct_neg_right]; abel }

@[simp] theorem H3ODerivation.neg_apply (D : H3ODerivation) (a : H3O) :
    (-D) a = -(D a) := rfl

/-- Subtraction of derivations. -/
instance : Sub H3ODerivation where
  sub D₁ D₂ := D₁ + (-D₂)

@[simp] theorem H3ODerivation.sub_apply (D₁ D₂ : H3ODerivation) (a : H3O) :
    (D₁ - D₂) a = D₁ a - D₂ a := by
  simp only [sub_eq_add_neg]; rfl

/-- Scalar multiplication of derivations. -/
instance : SMul ℝ H3ODerivation where
  smul r D :=
    { toFun := fun a => r • D a
      map_add' := fun a b => by
        rw [D.map_add, smul_add]
      map_smul' := fun s a => by
        rw [D.map_smul]; ext <;> simp <;> ring
      leibniz' := fun a b => by
        rw [D.leibniz, smul_add,
            jordanProduct_smul_left, jordanProduct_smul_right] }

@[simp] theorem H3ODerivation.smul_apply (r : ℝ) (D : H3ODerivation) (a : H3O) :
    (r • D) a = r • D a := rfl

/-! ## The commutator bracket -/

/-- The commutator of two Jordan derivations satisfies the Leibniz rule.

The proof expands using the Leibniz rule of `D₁` and `D₂` and additivity.
The cross terms `D₂(a) ○ D₁(b)` and `D₁(a) ○ D₂(b)` cancel. -/
theorem commutator_isDerivation (D₁ D₂ : H3ODerivation) (a b : H3O) :
    D₁ (D₂ (a ○ b)) - D₂ (D₁ (a ○ b)) =
      (D₁ (D₂ a) - D₂ (D₁ a)) ○ b + a ○ (D₁ (D₂ b) - D₂ (D₁ b)) := by
  rw [D₂.leibniz, D₁.leibniz, D₁.map_add, D₂.map_add]
  rw [D₁.leibniz, D₁.leibniz, D₂.leibniz, D₂.leibniz]
  rw [jordanProduct_sub_left, jordanProduct_sub_right]
  abel

/-- The commutator bracket of two derivations: `[D₁, D₂](a) = D₁(D₂(a)) - D₂(D₁(a))`. -/
def H3ODerivation.commutator (D₁ D₂ : H3ODerivation) : H3ODerivation where
  toFun := fun a => D₁ (D₂ a) - D₂ (D₁ a)
  map_add' := fun a b => by
    rw [D₂.map_add, D₁.map_add, D₁.map_add, D₂.map_add]; abel
  map_smul' := fun r a => by
    rw [D₂.map_smul, D₁.map_smul, D₁.map_smul, D₂.map_smul, smul_sub]
  leibniz' := commutator_isDerivation D₁ D₂

/-! ## LieRing and LieAlgebra instances -/

instance : Bracket H3ODerivation H3ODerivation where
  bracket D₁ D₂ := D₁.commutator D₂

@[simp] theorem H3ODerivation.bracket_apply (D₁ D₂ : H3ODerivation) (a : H3O) :
    ⁅D₁, D₂⁆ a = D₁ (D₂ a) - D₂ (D₁ a) := rfl

/-- The `AddCommGroup` instance on `H3ODerivation`. -/
instance : AddCommGroup H3ODerivation where
  add_assoc D₁ D₂ D₃ := H3ODerivation.ext fun a => by simp [add_assoc]
  zero_add D := H3ODerivation.ext fun a => by simp
  add_zero D := H3ODerivation.ext fun a => by simp
  nsmul := nsmulRec
  zsmul := zsmulRec
  neg_add_cancel D := H3ODerivation.ext fun a => by simp
  add_comm D₁ D₂ := H3ODerivation.ext fun a => by simp [add_comm]
  sub_eq_add_neg D₁ D₂ := H3ODerivation.ext fun a => by
    simp only [H3ODerivation.sub_apply, H3ODerivation.add_apply,
               H3ODerivation.neg_apply, sub_eq_add_neg]

/-- The `Module ℝ` instance on `H3ODerivation`. -/
instance : Module ℝ H3ODerivation where
  one_smul D := H3ODerivation.ext fun a => by simp
  mul_smul r s D := H3ODerivation.ext fun a => by simp [mul_smul]
  smul_zero r := H3ODerivation.ext fun a => by
    simp only [H3ODerivation.smul_apply, H3ODerivation.zero_apply, smul_zero]
  smul_add r D₁ D₂ := H3ODerivation.ext fun a => by simp [smul_add]
  add_smul r s D := H3ODerivation.ext fun a => by simp [add_smul]
  zero_smul D := H3ODerivation.ext fun a => by
    simp only [H3ODerivation.smul_apply, zero_smul, H3ODerivation.zero_apply]

/-- The `LieRing` instance on `H3ODerivation`.

The Jacobi identity `⁅D₁, ⁅D₂, D₃⁆⁆ = ⁅⁅D₁, D₂⁆, D₃⁆ + ⁅D₂, ⁅D₁, D₃⁆⁆`
holds because the commutator bracket on endomorphisms satisfies it. -/
instance : LieRing H3ODerivation where
  add_lie D₁ D₂ D₃ := H3ODerivation.ext fun a => by
    simp only [H3ODerivation.bracket_apply, H3ODerivation.add_apply]
    rw [D₃.map_add]; abel
  lie_add D₁ D₂ D₃ := H3ODerivation.ext fun a => by
    simp only [H3ODerivation.bracket_apply, H3ODerivation.add_apply]
    rw [D₁.map_add]; abel
  lie_self D := H3ODerivation.ext fun a => by
    simp only [H3ODerivation.bracket_apply, H3ODerivation.zero_apply, sub_self]
  leibniz_lie D₁ D₂ D₃ := H3ODerivation.ext fun a => by
    simp only [H3ODerivation.bracket_apply, H3ODerivation.add_apply]
    rw [D₁.map_sub, D₂.map_sub, D₃.map_sub]
    abel

/-- The `LieAlgebra ℝ` instance on `H3ODerivation`. -/
instance : LieAlgebra ℝ H3ODerivation where
  lie_smul r D₁ D₂ := H3ODerivation.ext fun a => by
    simp only [H3ODerivation.bracket_apply, H3ODerivation.smul_apply]
    rw [D₁.map_smul, smul_sub]

end PhysicsSM.Algebra.Jordan.Derivation
