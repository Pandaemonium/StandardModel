import Mathlib
import PhysicsSM.Algebra.Octonion.ChosenComplexAlgebra

/-!
# Algebra.Octonion.ChosenComplexRing

Algebraic typeclass infrastructure for `ChosenComplex` and a ring
equivalence with the standard Lean `ℂ`.

## Mathematical context

The chosen complex line `ChosenComplex = span_ℝ {1, e111}` carries a
commutative ring structure isomorphic to `ℂ`. This module promotes the
ad-hoc arithmetic operations already defined in `ChosenComplexAlgebra`
(add, neg, sub, mul, zero, one, smul) to proper mathlib typeclasses:

- `AddCommGroup ChosenComplex`
- `CommRing ChosenComplex`

It then packages the identification with `ℂ` as a `RingEquiv`:

- `ChosenComplex.ringEquivComplex : ChosenComplex ≃+* ℂ`

with simp-normal-form apply/symm lemmas and re-exports of the
`toComplex` compatibility lemmas for `+`, `*`, `0`, `1`.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021;
Baez, "The Octonions", Bull. Amer. Math. Soc. 2002.

Claim boundary: only the chosen complex line `span_ℝ {1, e111}`.
No G₂, SU(3), or Standard Model claims.

Convention: project XOR basis, chosen imaginary unit `e111`.

Status: trusted — no `s o r r y`.
-/

namespace PhysicsSM.Algebra.Octonion

/-! ## Nat and Int scalar actions -/

/-- Natural number cast into `ChosenComplex`: `n ↦ (n, 0)`. -/
instance : NatCast ChosenComplex := ⟨fun n => ⟨↑n, 0⟩⟩

/-- Integer cast into `ChosenComplex`: `n ↦ (n, 0)`. -/
instance : IntCast ChosenComplex := ⟨fun n => ⟨↑n, 0⟩⟩

@[simp] theorem ChosenComplex.natCast_re (n : ℕ) : (n : ChosenComplex).re = ↑n := rfl
@[simp] theorem ChosenComplex.natCast_im (n : ℕ) : (n : ChosenComplex).im = 0 := rfl
@[simp] theorem ChosenComplex.intCast_re (n : ℤ) : (n : ChosenComplex).re = ↑n := rfl
@[simp] theorem ChosenComplex.intCast_im (n : ℤ) : (n : ChosenComplex).im = 0 := rfl

/-! ## AddCommGroup instance -/

/-- `ChosenComplex` forms an additive commutative group under coordinate-wise
    addition and negation. -/
instance : AddCommGroup ChosenComplex where
  add_assoc a b c := by ext <;> simp <;> ring
  zero_add a := by ext <;> simp
  add_zero a := by ext <;> simp
  add_comm a b := by ext <;> simp <;> ring
  nsmul := fun n a => ⟨n * a.re, n * a.im⟩
  zsmul := fun n a => ⟨n * a.re, n * a.im⟩
  neg_add_cancel a := by ext <;> simp
  nsmul_zero a := by ext <;> simp
  nsmul_succ n a := by ext <;> simp <;> ring
  zsmul_zero' a := by ext <;> simp
  zsmul_succ' n a := by ext <;> simp <;> ring
  zsmul_neg' n a := by ext <;> simp <;> ring

/-! ## CommRing instance -/

/-- `ChosenComplex` forms a commutative ring with coordinate-wise addition
    and complex multiplication `(a+bi)(c+di) = (ac-bd) + (ad+bc)i`.

    This is the standard complex-number ring structure on the chosen
    complex line inside the octonions. -/
noncomputable instance : CommRing ChosenComplex where
  mul_assoc a b c := by ext <;> simp <;> ring
  one_mul a := by ext <;> simp
  mul_one a := by ext <;> simp
  left_distrib a b c := by ext <;> simp <;> ring
  right_distrib a b c := by ext <;> simp <;> ring
  zero_mul a := by ext <;> simp
  mul_zero a := by ext <;> simp
  mul_comm a b := by ext <;> simp <;> ring
  natCast_zero := by ext <;> simp
  natCast_succ n := by ext <;> simp
  intCast_negSucc n := by ext <;> simp [Int.negSucc_eq, add_comm]

/-! ## Ring equivalence with ℂ -/

/-- The ring equivalence between `ChosenComplex` and the standard Lean `ℂ`.
    This packages `toComplex` and `ofComplex` as a `RingEquiv`, witnessing
    that the chosen complex line is isomorphic to `ℂ` as a commutative ring. -/
noncomputable def ChosenComplex.ringEquivComplex : ChosenComplex ≃+* ℂ where
  toFun := ChosenComplex.toComplex
  invFun := ChosenComplex.ofComplex
  left_inv z := ChosenComplex.ofComplex_toComplex z
  right_inv z := ChosenComplex.toComplex_ofComplex z
  map_mul' z w := ChosenComplex.toComplex_mul z w
  map_add' z w := ChosenComplex.toComplex_add z w

/-! ## Simp lemmas for the ring equivalence -/

/-- Applying `ringEquivComplex` is the same as `toComplex`. -/
@[simp] theorem ChosenComplex.ringEquivComplex_apply (z : ChosenComplex) :
    ChosenComplex.ringEquivComplex z = z.toComplex := rfl

/-- The inverse of `ringEquivComplex` is `ofComplex`. -/
@[simp] theorem ChosenComplex.ringEquivComplex_symm_apply (z : ℂ) :
    ChosenComplex.ringEquivComplex.symm z = ChosenComplex.ofComplex z := rfl

end PhysicsSM.Algebra.Octonion
