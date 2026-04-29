import Mathlib.Tactic.Ring
import PhysicsSM.Algebra.Octonion.Basic
import PhysicsSM.Algebra.Octonion.Conjugation
import PhysicsSM.Algebra.Octonion.Norm

/-!
# Lie.Exceptional.OctonionSymmetry

Small octonion-symmetry primitives for the future G2/SO(8) bridge.

This file prepares a few concrete, trusted facts about the project octonion
model. The results are intentionally elementary: they are coordinate facts
about the Euclidean dot product, imaginary octonions, and the octonion
commutator. They are useful later when building the conceptual bridge:

```text
octonions -> imaginary octonions -> cross-product structure -> G2
octonions -> norm/dot product -> norm-preserving maps -> SO(8)
```

## What is proved here

- `octonionDot` is the coordinate Euclidean dot product on the underlying
  eight-dimensional real vector space.
- `octonionDot_self_eq_normSq` relates the dot product to the already trusted
  squared norm.
- `IsImaginary` identifies octonions with scalar coordinate zero.
- `conj_eq_neg_of_imaginary` proves conjugation negates imaginary octonions.
- `octonionCommutator` is the raw commutator `x * y - y * x`.
- `octonionCommutator_anticomm` proves the commutator is antisymmetric.
- `octonionCommutator_imaginary` proves that the commutator of imaginary
  octonions is imaginary.

## What is not proved here

This file does **not** prove:

- `G2 = Aut(O)`,
- `Der(O)` has type G2,
- the Jacobi identity for the raw octonion commutator,
- any group-level SO(8) or Spin(8) statement.

The raw octonion commutator is not a Lie bracket on all octonions; octonion
multiplication is nonassociative, and the Jacobi identity is not available in
that form. Later G2 work must use derivations or a carefully stated
cross-product structure.

Source: Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), Sections 1-4.
Provenance: Aristotle job `aab25ea4-035f-45e0-8321-3408a1edfaaf`, adapted with
project-local comments and explicit no-overclaiming notes.
-/

namespace PhysicsSM.Lie.Exceptional.OctonionSymmetry

open PhysicsSM.Algebra.Octonion

/-! ## Coordinate dot product -/

/--
The Euclidean coordinate dot product on octonions.

This is the standard dot product on the underlying eight-dimensional real
coordinate space. It is not a new octonion multiplication operation. It simply
multiplies matching coordinates and sums the eight real products.
-/
def octonionDot (x y : Octonion) : Real :=
  x.c0 * y.c0 + x.c1 * y.c1 + x.c2 * y.c2 + x.c3 * y.c3 +
    x.c4 * y.c4 + x.c5 * y.c5 + x.c6 * y.c6 + x.c7 * y.c7

/--
The dot product of an octonion with itself is the trusted squared norm.

This theorem connects the Euclidean vector-space viewpoint to the algebraic
`normSq` definition from `PhysicsSM.Algebra.Octonion.Norm`.
-/
theorem octonionDot_self_eq_normSq (x : Octonion) :
    octonionDot x x = normSq x := by
  simp [octonionDot, normSq]
  ring

/-! ## Imaginary octonions -/

/--
Predicate for purely imaginary octonions.

An octonion is imaginary when its scalar coordinate is zero. In the project
coordinate convention, this means `c0 = 0`; the remaining seven coordinates are
the imaginary part.
-/
def IsImaginary (x : Octonion) : Prop :=
  x.c0 = 0

/--
Conjugation negates imaginary octonions.

For an imaginary octonion, the scalar coordinate is already zero. Conjugation
fixes that zero scalar coordinate and negates every imaginary coordinate, so it
agrees with the additive inverse.
-/
theorem conj_eq_neg_of_imaginary {x : Octonion}
    (hx : IsImaginary x) : conj x = -x := by
  unfold IsImaginary at hx
  ext <;> simp [conj, hx]

/-! ## Octonion commutator -/

/--
The raw octonion commutator.

This measures the failure of octonion multiplication to commute:

```text
[x, y] = x * y - y * x
```

Do not treat this as a Lie bracket on all octonions. The raw commutator is
antisymmetric, but the Jacobi identity is not part of this file and should not
be assumed.
-/
def octonionCommutator (x y : Octonion) : Octonion :=
  x * y - y * x

/--
The octonion commutator is antisymmetric.

The proof expands each coordinate of the two products and subtraction. Once the
goal is reduced to real coordinate arithmetic, `ring` closes each polynomial
identity.
-/
theorem octonionCommutator_anticomm (x y : Octonion) :
    octonionCommutator x y = -octonionCommutator y x := by
  unfold octonionCommutator
  ext <;>
    simp only [Octonion.sub_c0, Octonion.sub_c1, Octonion.sub_c2,
      Octonion.sub_c3, Octonion.sub_c4, Octonion.sub_c5, Octonion.sub_c6,
      Octonion.sub_c7, Octonion.neg_c0, Octonion.neg_c1, Octonion.neg_c2,
      Octonion.neg_c3, Octonion.neg_c4, Octonion.neg_c5, Octonion.neg_c6,
      Octonion.neg_c7, Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
      Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6,
      Octonion.mul_c7] <;>
    ring

/--
The commutator of two imaginary octonions is imaginary.

This is one small piece of the later seven-dimensional imaginary-octonion
story. It says that if both inputs have scalar coordinate zero, then the
commutator also has scalar coordinate zero.
-/
theorem octonionCommutator_imaginary {x y : Octonion}
    (hx : IsImaginary x) (hy : IsImaginary y) :
    IsImaginary (octonionCommutator x y) := by
  unfold IsImaginary at *
  unfold octonionCommutator
  simp [hx, hy]
  ring

end PhysicsSM.Lie.Exceptional.OctonionSymmetry
