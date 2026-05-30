import Mathlib
import PhysicsSM.Algebra.Octonion.ChosenComplexRing
import PhysicsSM.Algebra.Octonion.ComplexLineAction

/-!
# Algebra.Octonion.ChosenComplexC3ActionLaws

Algebraic action laws for `ChosenComplex.smulComplexTriple`, showing that the
chosen complex line acts on the complement `ℂ³` as a well-behaved scalar
multiplication: it respects `0`, `+`, `-`, and `sub` in both arguments.

## Mathematical context

The module `ComplexLineAction` defines `ChosenComplex.smulComplexTriple` and
proves the key multiplication compatibility with octonion multiplication,
along with `one_smulComplexTriple` and `mul_smulComplexTriple`.

This module fills in the remaining algebraic laws that make the action
behave like coordinate-wise complex scalar multiplication:

- **Zero laws**: `0 · w = 0` and `z · 0 = 0`.
- **Additivity**: `(z₁ + z₂) · w = z₁ · w + z₂ · w` and
  `z · (u + v) = z · u + z · v`.
- **Negation**: `(-z) · w = -(z · w)`.
- **Subtraction**: `(z₁ - z₂) · w = z₁ · w - z₂ · w`.

A `Sub ComplexTriple` instance is provided locally in this file since
it is not yet available in the upstream modules.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Convention: project XOR basis from `PhysicsSM.Algebra.Octonion.Basic`.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Algebra.Octonion

/-! ## Sub instance for ComplexTriple

`ComplexTriple` already has `Add` and `Neg` but no `Sub`. We define subtraction
coordinate-wise, consistent with the additive group structure. -/

/-- Subtraction on `ComplexTriple`, defined coordinate-wise. -/
instance : Sub ComplexTriple :=
  ⟨fun a b => ⟨a.w1_re - b.w1_re, a.w1_im - b.w1_im,
               a.w2_re - b.w2_re, a.w2_im - b.w2_im,
               a.w3_re - b.w3_re, a.w3_im - b.w3_im⟩⟩

/-! ## Field-access simp lemmas for ComplexTriple operations

These lemmas let `simp` reduce field accesses on `0`, `+`, `-`, and `-`
(subtraction) for `ComplexTriple`. They are essential for the `ext` + `simp`
proof pattern used throughout this file. -/

@[simp] theorem ComplexTriple.zero_w1_re : (0 : ComplexTriple).w1_re = 0 := rfl
@[simp] theorem ComplexTriple.zero_w1_im : (0 : ComplexTriple).w1_im = 0 := rfl
@[simp] theorem ComplexTriple.zero_w2_re : (0 : ComplexTriple).w2_re = 0 := rfl
@[simp] theorem ComplexTriple.zero_w2_im : (0 : ComplexTriple).w2_im = 0 := rfl
@[simp] theorem ComplexTriple.zero_w3_re : (0 : ComplexTriple).w3_re = 0 := rfl
@[simp] theorem ComplexTriple.zero_w3_im : (0 : ComplexTriple).w3_im = 0 := rfl

@[simp] theorem ComplexTriple.add_w1_re (a b : ComplexTriple) :
    (a + b).w1_re = a.w1_re + b.w1_re := rfl
@[simp] theorem ComplexTriple.add_w1_im (a b : ComplexTriple) :
    (a + b).w1_im = a.w1_im + b.w1_im := rfl
@[simp] theorem ComplexTriple.add_w2_re (a b : ComplexTriple) :
    (a + b).w2_re = a.w2_re + b.w2_re := rfl
@[simp] theorem ComplexTriple.add_w2_im (a b : ComplexTriple) :
    (a + b).w2_im = a.w2_im + b.w2_im := rfl
@[simp] theorem ComplexTriple.add_w3_re (a b : ComplexTriple) :
    (a + b).w3_re = a.w3_re + b.w3_re := rfl
@[simp] theorem ComplexTriple.add_w3_im (a b : ComplexTriple) :
    (a + b).w3_im = a.w3_im + b.w3_im := rfl

@[simp] theorem ComplexTriple.neg_w1_re (a : ComplexTriple) :
    (-a).w1_re = -a.w1_re := rfl
@[simp] theorem ComplexTriple.neg_w1_im (a : ComplexTriple) :
    (-a).w1_im = -a.w1_im := rfl
@[simp] theorem ComplexTriple.neg_w2_re (a : ComplexTriple) :
    (-a).w2_re = -a.w2_re := rfl
@[simp] theorem ComplexTriple.neg_w2_im (a : ComplexTriple) :
    (-a).w2_im = -a.w2_im := rfl
@[simp] theorem ComplexTriple.neg_w3_re (a : ComplexTriple) :
    (-a).w3_re = -a.w3_re := rfl
@[simp] theorem ComplexTriple.neg_w3_im (a : ComplexTriple) :
    (-a).w3_im = -a.w3_im := rfl

@[simp] theorem ComplexTriple.sub_w1_re (a b : ComplexTriple) :
    (a - b).w1_re = a.w1_re - b.w1_re := rfl
@[simp] theorem ComplexTriple.sub_w1_im (a b : ComplexTriple) :
    (a - b).w1_im = a.w1_im - b.w1_im := rfl
@[simp] theorem ComplexTriple.sub_w2_re (a b : ComplexTriple) :
    (a - b).w2_re = a.w2_re - b.w2_re := rfl
@[simp] theorem ComplexTriple.sub_w2_im (a b : ComplexTriple) :
    (a - b).w2_im = a.w2_im - b.w2_im := rfl
@[simp] theorem ComplexTriple.sub_w3_re (a b : ComplexTriple) :
    (a - b).w3_re = a.w3_re - b.w3_re := rfl
@[simp] theorem ComplexTriple.sub_w3_im (a b : ComplexTriple) :
    (a - b).w3_im = a.w3_im - b.w3_im := rfl

/-! ## Zero action laws -/

/-- The zero element of the chosen complex line acts as zero on any
    complement element: `0 · w = 0`. -/
theorem ChosenComplex.zero_smulComplexTriple (w : ComplexTriple) :
    (0 : ChosenComplex).smulComplexTriple w = 0 := by
  unfold smulComplexTriple
  rw [toComplex_zero]
  exact ComplexTriple.complexSmul_zero w

/-- Any element of the chosen complex line acts as zero on the zero
    complement element: `z · 0 = 0`. -/
theorem ChosenComplex.smulComplexTriple_zero (z : ChosenComplex) :
    z.smulComplexTriple (0 : ComplexTriple) = 0 := by
  unfold smulComplexTriple ComplexTriple.complexSmul
  ext <;> simp

/-! ## Additivity laws -/

/-- The action is additive in the chosen complex line argument:
    `(z₁ + z₂) · w = z₁ · w + z₂ · w`. -/
theorem ChosenComplex.add_smulComplexTriple
    (z1 z2 : ChosenComplex) (w : ComplexTriple) :
    (z1 + z2).smulComplexTriple w =
      z1.smulComplexTriple w + z2.smulComplexTriple w := by
  simp only [smulComplexTriple, toComplex_add]
  unfold ComplexTriple.complexSmul
  ext <;> simp [Complex.add_re, Complex.add_im] <;> ring

/-- The action is additive in the complement argument:
    `z · (u + v) = z · u + z · v`. -/
theorem ChosenComplex.smulComplexTriple_add
    (z : ChosenComplex) (u v : ComplexTriple) :
    z.smulComplexTriple (u + v) =
      z.smulComplexTriple u + z.smulComplexTriple v := by
  unfold smulComplexTriple ComplexTriple.complexSmul
  ext <;> simp <;> ring

/-! ## Negation law -/

/-- The action respects negation in the chosen complex line argument:
    `(-z) · w = -(z · w)`. -/
theorem ChosenComplex.neg_smulComplexTriple
    (z : ChosenComplex) (w : ComplexTriple) :
    (-z).smulComplexTriple w = -(z.smulComplexTriple w) := by
  simp only [smulComplexTriple, toComplex_neg]
  unfold ComplexTriple.complexSmul
  ext <;> simp [Complex.neg_re, Complex.neg_im] <;> ring

/-! ## Subtraction law -/

/-- The action respects subtraction in the chosen complex line argument:
    `(z₁ - z₂) · w = z₁ · w - z₂ · w`. -/
theorem ChosenComplex.sub_smulComplexTriple
    (z1 z2 : ChosenComplex) (w : ComplexTriple) :
    (z1 - z2).smulComplexTriple w =
      z1.smulComplexTriple w - z2.smulComplexTriple w := by
  simp only [smulComplexTriple, toComplex_sub]
  unfold ComplexTriple.complexSmul
  ext <;> simp [Complex.sub_re, Complex.sub_im] <;> ring

/-! ## toComplexVec versions -/

/-- Coordinate version of `zero_smulComplexTriple`:
    the coordinates of `0 · w` are all zero. -/
theorem ChosenComplex.toComplexVec_zero_smulComplexTriple
    (w : ComplexTriple) :
    ((0 : ChosenComplex).smulComplexTriple w).toComplexVec = 0 := by
  rw [zero_smulComplexTriple]
  exact ComplexTriple.toComplexVec_zero

/-- Coordinate version of `smulComplexTriple_zero`:
    the coordinates of `z · 0` are all zero. -/
theorem ChosenComplex.toComplexVec_smulComplexTriple_zero
    (z : ChosenComplex) :
    (z.smulComplexTriple (0 : ComplexTriple)).toComplexVec = 0 := by
  rw [smulComplexTriple_zero]
  exact ComplexTriple.toComplexVec_zero

/-- Coordinate version of `add_smulComplexTriple`:
    `((z₁ + z₂) · w)ₖ = (z₁ · w)ₖ + (z₂ · w)ₖ`. -/
theorem ChosenComplex.toComplexVec_add_smulComplexTriple
    (z1 z2 : ChosenComplex) (w : ComplexTriple) :
    ((z1 + z2).smulComplexTriple w).toComplexVec =
      fun k => (z1.smulComplexTriple w).toComplexVec k +
               (z2.smulComplexTriple w).toComplexVec k := by
  rw [add_smulComplexTriple]
  unfold smulComplexTriple ComplexTriple.complexSmul
    ComplexTriple.toComplexVec
  ext k
  fin_cases k <;> simp [Complex.ext_iff]

/-- Coordinate version of `smulComplexTriple_add`:
    `(z · (u + v))ₖ = (z · u)ₖ + (z · v)ₖ`. -/
theorem ChosenComplex.toComplexVec_smulComplexTriple_add
    (z : ChosenComplex) (u v : ComplexTriple) :
    (z.smulComplexTriple (u + v)).toComplexVec =
      fun k => (z.smulComplexTriple u).toComplexVec k +
               (z.smulComplexTriple v).toComplexVec k := by
  rw [smulComplexTriple_add]
  unfold smulComplexTriple ComplexTriple.complexSmul
    ComplexTriple.toComplexVec
  ext k
  fin_cases k <;> simp [Complex.ext_iff]

/-- Coordinate version of `neg_smulComplexTriple`:
    `((-z) · w)ₖ = -(z · w)ₖ`. -/
theorem ChosenComplex.toComplexVec_neg_smulComplexTriple
    (z : ChosenComplex) (w : ComplexTriple) :
    ((-z).smulComplexTriple w).toComplexVec =
      fun k => -((z.smulComplexTriple w).toComplexVec k) := by
  rw [neg_smulComplexTriple]
  unfold smulComplexTriple ComplexTriple.complexSmul
    ComplexTriple.toComplexVec
  ext k
  fin_cases k <;> simp [Complex.ext_iff]

end PhysicsSM.Algebra.Octonion
