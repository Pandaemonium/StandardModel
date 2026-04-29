import PhysicsSM.Algebra.Octonion.Conjugation
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

/-!
# Algebra.Octonion.Norm

The squared Euclidean norm on the project octonion model.

For an octonion `x = c0 e000 + c1 e001 + ... + c7 e111`, the squared norm is
the sum of the eight coordinate squares. The main result is `normSq_mul`,
which proves that the norm is multiplicative:

`normSq (x * y) = normSq x * normSq y`.

This is the composition-algebra property of the octonions. It is also the
formal foundation for later normed-division-algebra, G2, and exceptional
geometry work in the project.

Source: Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), Section 1.
Convention: positive-definite Euclidean norm in the XOR basis from
`PhysicsSM.Algebra.Octonion.Basic`. This is not a Lorentzian or physics-signature
quadratic form.
Provenance: Aristotle job `fe5f83fd-885e-4f87-936f-9a8a4746ee7c`,
adapted to this repository's `PhysicsSM` module paths and comments.

Status: trusted. The file contains no `sorry`; the multiplicativity theorem is
a kernel-checked polynomial identity after expanding the multiplication table.
-/

namespace PhysicsSM.Algebra.Octonion

/--
The squared norm of an octonion.

The definition is kept as a direct coordinate sum so that later theorem
statements are transparent about the convention. In particular, the basis is
orthonormal and positive-definite: every coordinate contributes `ci ^ 2` with a
positive sign.
-/
def normSq (x : Octonion) : ℝ :=
  x.c0 ^ 2 + x.c1 ^ 2 + x.c2 ^ 2 + x.c3 ^ 2 +
    x.c4 ^ 2 + x.c5 ^ 2 + x.c6 ^ 2 + x.c7 ^ 2

/--
The unfolding lemma for `normSq`.

This is the preferred way to expose the coordinate formula to `simp` without
repeating the definition manually in downstream proofs.
-/
@[simp] theorem normSq_def (x : Octonion) :
    normSq x =
      x.c0 ^ 2 + x.c1 ^ 2 + x.c2 ^ 2 + x.c3 ^ 2 +
        x.c4 ^ 2 + x.c5 ^ 2 + x.c6 ^ 2 + x.c7 ^ 2 := rfl

/--
The squared norm is nonnegative.

Each summand is a square in `ℝ`, so the proof is delegated to mathlib's
`positivity` tactic after unfolding the definition.
-/
theorem normSq_nonneg (x : Octonion) : 0 ≤ normSq x := by
  unfold normSq
  positivity

/--
The squared norm vanishes exactly at the zero octonion.

The forward direction uses the fact that a sum of nonnegative real squares can
be zero only when each square is zero. After that, extensionality turns the
coordinate equalities into the octonion equality `x = 0`.
-/
theorem normSq_eq_zero (x : Octonion) : normSq x = 0 ↔ x = 0 := by
  unfold normSq
  constructor
  · intro h
    have sq0 := sq_nonneg x.c0
    have sq1 := sq_nonneg x.c1
    have sq2 := sq_nonneg x.c2
    have sq3 := sq_nonneg x.c3
    have sq4 := sq_nonneg x.c4
    have sq5 := sq_nonneg x.c5
    have sq6 := sq_nonneg x.c6
    have sq7 := sq_nonneg x.c7
    have h0 : x.c0 = 0 := by nlinarith
    have h1 : x.c1 = 0 := by nlinarith
    have h2 : x.c2 = 0 := by nlinarith
    have h3 : x.c3 = 0 := by nlinarith
    have h4 : x.c4 = 0 := by nlinarith
    have h5 : x.c5 = 0 := by nlinarith
    have h6 : x.c6 = 0 := by nlinarith
    have h7 : x.c7 = 0 := by nlinarith
    ext <;> assumption
  · rintro rfl
    simp [Octonion.zero_c0, Octonion.zero_c1, Octonion.zero_c2,
      Octonion.zero_c3, Octonion.zero_c4, Octonion.zero_c5,
      Octonion.zero_c6, Octonion.zero_c7]

/--
Conjugation preserves the squared norm.

All imaginary coordinates change sign under conjugation, and real squares are
unchanged by sign.
-/
theorem normSq_conj (x : Octonion) : normSq (conj x) = normSq x := by
  simp [normSq, conj]

/--
The norm identity packaged using `normSq`.

This is exactly `mul_conj` from `Conjugation.lean`, with the coordinate sum
replaced by the named definition `normSq`.
-/
theorem normSq_eq_mul_conj (x : Octonion) :
    normSq x • (1 : Octonion) = x * conj x :=
  (mul_conj x).symm

/-- The unit octonion has squared norm one. -/
theorem normSq_one : normSq (1 : Octonion) = 1 := by
  simp [normSq]

/--
The squared norm is multiplicative.

This is the key composition-algebra theorem for the project octonions. The
proof deliberately avoids any associative-algebra API: after `simp only`
expands the eight coordinates of `x * y` from `Basic.lean`, the goal is a
single polynomial identity over the commutative ring `ℝ`. The `ring` tactic
then verifies that polynomial identity.
-/
theorem normSq_mul (x y : Octonion) :
    normSq (x * y) = normSq x * normSq y := by
  simp only [normSq, Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
    Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6,
    Octonion.mul_c7]
  ring

end PhysicsSM.Algebra.Octonion
