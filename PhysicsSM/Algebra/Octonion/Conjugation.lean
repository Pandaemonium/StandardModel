import PhysicsSM.Algebra.Octonion.Basic

/-!
# Algebra.Octonion.Conjugation

Conjugation on the project octonion model.

The conjugate fixes the scalar coordinate and negates the seven imaginary
coordinates. In basis notation, if
`x = c0 e000 + c1 e001 + ... + c7 e111`, then
`conj x = c0 e000 - c1 e001 - ... - c7 e111`.

This file proves the first algebraic facts needed before the norm layer:

- `conj_conj`: conjugation is an involution.
- `conj_add`, `conj_neg`, `conj_smul`, `conj_zero`: conjugation is real-linear.
- `conj_mul`: conjugation reverses multiplication.
- `mul_conj`, `conj_mul_self`: the product with the conjugate is a real scalar.

Source: Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), Section 1.
Convention: the XOR basis and Fano orientation from
`PhysicsSM.Algebra.Octonion.Basic`; `c0` is the scalar coordinate and
`c1` through `c7` are imaginary coordinates.
Provenance: Aristotle job `fe5f83fd-885e-4f87-936f-9a8a4746ee7c`,
adapted to this repository's `PhysicsSM` module paths and comments.

Status: trusted. The file contains no `sorry`; each theorem reduces to explicit
coordinate arithmetic accepted by the Lean kernel.
-/

namespace PhysicsSM.Algebra.Octonion

/--
Octonion conjugation.

The project represents octonions as eight real coordinates rather than as a
quotient or a generated algebra. This makes the definition completely explicit:
the scalar coordinate is unchanged, while every imaginary coordinate has its
sign flipped. The definition intentionally does not mention multiplication, so
it is independent of the nonassociative product table.
-/
def conj (x : Octonion) : Octonion :=
  { c0 := x.c0
    c1 := -x.c1
    c2 := -x.c2
    c3 := -x.c3
    c4 := -x.c4
    c5 := -x.c5
    c6 := -x.c6
    c7 := -x.c7 }

/-!
The coordinate projection lemmas below are deliberately marked `[simp]`.
Most later proofs use `ext` to reduce an octonion equality to eight real
coordinate goals, and these lemmas tell `simp` exactly what conjugation does
on each coordinate.
-/

@[simp] theorem conj_c0 (x : Octonion) : (conj x).c0 = x.c0 := rfl
@[simp] theorem conj_c1 (x : Octonion) : (conj x).c1 = -x.c1 := rfl
@[simp] theorem conj_c2 (x : Octonion) : (conj x).c2 = -x.c2 := rfl
@[simp] theorem conj_c3 (x : Octonion) : (conj x).c3 = -x.c3 := rfl
@[simp] theorem conj_c4 (x : Octonion) : (conj x).c4 = -x.c4 := rfl
@[simp] theorem conj_c5 (x : Octonion) : (conj x).c5 = -x.c5 := rfl
@[simp] theorem conj_c6 (x : Octonion) : (conj x).c6 = -x.c6 := rfl
@[simp] theorem conj_c7 (x : Octonion) : (conj x).c7 = -x.c7 := rfl

/--
Conjugation is an involution.

After `ext`, the scalar coordinate is immediate and each imaginary coordinate
is the real identity `-(-a) = a`.
-/
theorem conj_conj (x : Octonion) : conj (conj x) = x := by
  ext <;> simp [conj]

/--
Conjugation preserves addition.

This is coordinatewise real arithmetic. The `ring` step closes the imaginary
coordinate goals where both sides contain a negated sum.
-/
theorem conj_add (x y : Octonion) : conj (x + y) = conj x + conj y := by
  ext <;> simp [conj] <;> ring

/-- Conjugation commutes with additive inverse, again coordinate by coordinate. -/
theorem conj_neg (x : Octonion) : conj (-x) = -conj x := by
  ext <;> simp [conj]

/--
Conjugation is linear over the real scalar action used by the project octonion
model.
-/
theorem conj_smul (r : ℝ) (x : Octonion) : conj (r • x) = r • conj x := by
  ext <;> simp [conj]

/-- Conjugation fixes zero. -/
theorem conj_zero : conj (0 : Octonion) = 0 := by
  ext <;> simp [conj]

/--
Conjugation reverses multiplication.

Octonions are nonassociative, so this theorem is not proved by appealing to an
associative-algebra abstraction. Instead, `simp` unfolds the multiplication
table from `Basic.lean` into eight real polynomial coordinate identities, and
`ring` checks those real identities. This is a direct verification for the
project's XOR/Fano convention.
-/
theorem conj_mul (x y : Octonion) : conj (x * y) = conj y * conj x := by
  ext <;> simp [conj, Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
    Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6,
    Octonion.mul_c7] <;> ring

/--
The product of an octonion with its conjugate is the squared coordinate norm,
embedded as a scalar multiple of the unit octonion.

The statement is intentionally written without importing `Norm.lean`, which
keeps the dependency direction clean: the norm module can later package this
coordinate sum as `normSq`.
-/
theorem mul_conj (x : Octonion) :
    x * conj x =
      (x.c0 ^ 2 + x.c1 ^ 2 + x.c2 ^ 2 + x.c3 ^ 2 +
        x.c4 ^ 2 + x.c5 ^ 2 + x.c6 ^ 2 + x.c7 ^ 2) • (1 : Octonion) := by
  ext <;> simp [conj, Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
    Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6,
    Octonion.mul_c7] <;> ring

/--
The conjugate-on-the-left version of `mul_conj`.

For octonions, the equality is still a component calculation rather than a
consequence of commutativity of multiplication. The result says both natural
products with `conj x` collapse to the same scalar octonion.
-/
theorem conj_mul_self (x : Octonion) :
    conj x * x =
      (x.c0 ^ 2 + x.c1 ^ 2 + x.c2 ^ 2 + x.c3 ^ 2 +
        x.c4 ^ 2 + x.c5 ^ 2 + x.c6 ^ 2 + x.c7 ^ 2) • (1 : Octonion) := by
  ext <;> simp [conj, Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
    Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6,
    Octonion.mul_c7] <;> ring

end PhysicsSM.Algebra.Octonion
