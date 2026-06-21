import PhysicsSM.Algebra.Octonion.Basic

/-!
# Algebra.Octonion.Moufang

The Moufang identities for the project octonion model.

Octonions are not associative, but they satisfy the three Moufang identities.
These identities are a central replacement for associativity in octonionic
algebra and are used throughout the theory of Moufang loops, composition
algebras, and exceptional structures.

The formal statements keep every parenthesis explicit:

- `moufang_left`: `(x * y) * (z * x) = x * ((y * z) * x)`.
- `moufang_right`: `(x * (y * x)) * z = x * (y * (x * z))`.
- `moufang_middle`: `x * (y * (x * z)) = ((x * y) * x) * z`.
- `flexible`: `x * (y * x) = (x * y) * x`.

Source: Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), Section 1;
Springer and Veldkamp, "Octonions, Jordan Algebras and Exceptional Groups",
Section 1.4.
Convention: XOR basis and Fano orientation from
`PhysicsSM.Algebra.Octonion.Basic`.
Provenance: Aristotle job `fe5f83fd-885e-4f87-936f-9a8a4746ee7c`,
adapted to this repository's `PhysicsSM` module paths and comments.

Status: trusted. The file contains no `s o r r y`; each identity is checked by
coordinate expansion and real polynomial normalization.
-/

namespace PhysicsSM.Algebra.Octonion

/--
Left Moufang identity.

Because the octonion product is nonassociative, this statement is not a
rewriting convenience: it records a genuine identity with fixed parentheses.
The proof expands both sides to their eight real coordinates using the
project's multiplication table, then asks `ring` to verify each coordinate
polynomial.
-/
theorem moufang_left (x y z : Octonion) :
    (x * y) * (z * x) = x * ((y * z) * x) := by
  ext <;>
    simp only [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
      Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6,
      Octonion.mul_c7] <;>
    ring

/--
Right Moufang identity.

The `x` occurs twice in the characteristic Moufang pattern. The explicit
parentheses are part of the mathematical content and should not be changed
without rechecking the convention.
-/
theorem moufang_right (x y z : Octonion) :
    (x * (y * x)) * z = x * (y * (x * z)) := by
  ext <;>
    simp only [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
      Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6,
      Octonion.mul_c7] <;>
    ring

/--
Middle Moufang identity.

This is another equivalent Moufang law for octonions. It is stated separately
instead of derived from the preceding identities so that downstream modules can
rewrite using exactly the parenthesization they need.
-/
theorem moufang_middle (x y z : Octonion) :
    x * (y * (x * z)) = ((x * y) * x) * z := by
  ext <;>
    simp only [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
      Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6,
      Octonion.mul_c7] <;>
    ring

/--
Flexible identity.

Flexibility is a lower-arity shadow of the Moufang laws. It is useful when one
needs to reassociate a product with matching outer factors while still avoiding
any blanket associativity assumption for octonions.
-/
theorem flexible (x y : Octonion) : x * (y * x) = (x * y) * x := by
  ext <;>
    simp only [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
      Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6,
      Octonion.mul_c7] <;>
    ring

end PhysicsSM.Algebra.Octonion
