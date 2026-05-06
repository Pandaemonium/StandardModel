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
- `octonionAssociator` records the explicit associator parenthesization.
- `octonionAssociator_antisymmetric_first_two` and
  `octonionAssociator_antisymmetric_last_two` prove the finite coordinate
  antisymmetry identities needed for later G2 work.
- `IsOctonionDerivation` and `octonionDerivation_kills_one` start the
  derivation-space infrastructure.

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

/-! ## Associator -/

/--
The explicitly parenthesized octonion associator.

Because octonions are not associative, this definition is intentionally
parenthesized in the only way it should be read:

```text
[a, b, c] = (a * b) * c - a * (b * c)
```

Later G2 work should refer to this named definition rather than restating the
parenthesized expression by hand.
-/
def octonionAssociator (a b c : Octonion) : Octonion :=
  (a * b) * c - a * (b * c)

/--
The octonion associator is antisymmetric in its first two arguments.

This is the coordinate-level linearization of left alternativity for the
project octonion model.  The proof expands all eight coordinates and reduces
the statement to polynomial arithmetic over `Real`.

Provenance: Aristotle job `270e946c-7615-49ff-aded-15f9a2c68c15`, cleaned to
use the descriptive `octonionAssociator` definition.
-/
theorem octonionAssociator_antisymmetric_first_two (a b c : Octonion) :
    octonionAssociator a b c = -octonionAssociator b a c := by
  unfold octonionAssociator
  ext <;> simp <;> ring

/--
The octonion associator is antisymmetric in its last two arguments.

Together with `octonionAssociator_antisymmetric_first_two`, this records the
finite trusted fact that the project octonion associator is alternating.  This
is one algebraic fingerprint behind the later derivation and G2 story.

Provenance: Aristotle job `270e946c-7615-49ff-aded-15f9a2c68c15`.
-/
theorem octonionAssociator_antisymmetric_last_two (a b c : Octonion) :
    octonionAssociator a b c = -octonionAssociator a c b := by
  unfold octonionAssociator
  ext <;> simp <;> ring

/-! ## Octonion derivations -/

/--
Predicate for derivations of the concrete real octonion algebra.

The predicate is deliberately stated directly on functions `Octonion ->
Octonion`.  It requires compatibility with real scalar multiplication,
additivity, and the Leibniz rule for the nonassociative octonion product.  It
does not package derivations as a vector space yet; the missing dimension-14
theorem needs a separate constraint-matrix formalization.
-/
def IsOctonionDerivation (D : Octonion → Octonion) : Prop :=
  (∀ (r : ℝ) (x : Octonion), D (r • x) = r • D x) ∧
  (∀ x y : Octonion, D (x + y) = D x + D y) ∧
  (∀ x y : Octonion, D (x * y) = D x * y + x * D y)

/--
Every octonion derivation sends the scalar unit to zero.

The proof uses only the Leibniz rule at `1 * 1`.  Since `1` is a two-sided unit,
the Leibniz equation becomes `D 1 = D 1 + D 1`, and the coordinate extensionality
lemmas reduce the result to real arithmetic.

Provenance: Aristotle job `270e946c-7615-49ff-aded-15f9a2c68c15`.
-/
theorem octonionDerivation_kills_one {D : Octonion → Octonion}
    (hD : IsOctonionDerivation D) :
    D 1 = 0 := by
  have hD_one : D 1 = D 1 * 1 + 1 * D 1 := by
    have h_leibniz := hD.2.2 1 1
    convert h_leibniz
    ext <;> simp
  simp_all +decide [Octonion.ext_iff]

/-! ## Derivation closure properties -/

/--
The zero function is an octonion derivation.

This is the first closure property needed before the derivations can be
packaged as a vector subspace. The statement is kept at the predicate level
because the project octonion type does not yet expose all of the additive and
module typeclass structure needed for a bundled `Submodule`.

Provenance: Aristotle job `c8b9c03a-b34e-423f-a362-ffe278b99fc8`.
-/
theorem zero_isOctonionDerivation :
    IsOctonionDerivation (fun _ : Octonion => 0) := by
  constructor <;> intros <;> simp +decide
  · ext <;> norm_num
  · exact ⟨by ext <;> norm_num, fun x y => by ext <;> norm_num⟩

/--
The pointwise sum of two octonion derivations is again an octonion derivation.

The proof expands the three fields in `IsOctonionDerivation`. Scalar
compatibility and additivity are pointwise consequences of the hypotheses.
For the Leibniz rule, the only subtlety is bookkeeping: the desired expression
has the four resulting terms grouped in a different order.

Provenance: Aristotle job `c8b9c03a-b34e-423f-a362-ffe278b99fc8`.
-/
theorem add_isOctonionDerivation {D E : Octonion → Octonion}
    (hD : IsOctonionDerivation D) (hE : IsOctonionDerivation E) :
    IsOctonionDerivation (D + E) := by
  constructor
  · intro r x
    have := hD.1 r x
    have := hE.1 r x
    simp_all +decide
    exact Eq.symm (by ext <;> simp +decide [mul_add])
  · constructor
    · intros x y
      simp [Pi.add_apply, hD.2.1, hE.2.1]
      simp +decide [add_left_comm, add_comm, Octonion.ext_iff]
    · intro x y
      have := hD.2.2 x y
      have := hE.2.2 x y
      simp_all +decide
      have : ∀ (a b c d : Octonion),
          (a + b) + (c + d) = (a + c) + (b + d) := by
        intros a b c d
        ext <;> simp [add_comm, add_left_comm]
      have : ∀ (a b c : Octonion),
          a * (b + c) = a * b + a * c ∧
          (b + c) * a = b * a + c * a := by
        intros a b c
        exact ⟨by ext <;> simp +decide [mul_add] <;> ring,
               by ext <;> simp +decide [add_mul] <;> ring⟩
      grind

/--
The pointwise negation of an octonion derivation is again an octonion
derivation.

This is the additive-inverse closure property for the eventual derivation
subspace. It is stated directly for functions, matching the current
predicate-level API.

Provenance: Aristotle job `c8b9c03a-b34e-423f-a362-ffe278b99fc8`.
-/
theorem neg_isOctonionDerivation {D : Octonion → Octonion}
    (hD : IsOctonionDerivation D) :
    IsOctonionDerivation (-D) := by
  have h0 : ∀ (r : ℝ) (x : Octonion),
      (-D) (r • x) = r • (-D) x := by
    exact fun r x => by ext <;> simp +decide [hD.1 r x]
  constructor
  · assumption
  · constructor <;> intros <;> ext <;> simp +decide [*]
    all_goals have := hD.2.1
    all_goals simp_all +decide [IsOctonionDerivation]
    all_goals ring

/--
A real scalar multiple of an octonion derivation is again an octonion
derivation.

Together with `zero_isOctonionDerivation`, `add_isOctonionDerivation`, and
`neg_isOctonionDerivation`, this gives the mathematical closure content for
the future vector space of octonion derivations. Packaging it as a Lean
`Submodule` is intentionally deferred until the octonion type has the needed
full additive and module instances.

Provenance: Aristotle job `c8b9c03a-b34e-423f-a362-ffe278b99fc8`.
-/
theorem smul_isOctonionDerivation (r : ℝ) {D : Octonion → Octonion}
    (hD : IsOctonionDerivation D) :
    IsOctonionDerivation (r • D) := by
  constructor
  · exact fun r' x => by
      ext <;> simp +decide [hD.1] <;> ring
  · have := hD.2.2
    constructor
    · intro x y
      ext <;> simp +decide [hD.2.1] <;> ring
    · intro x y
      ext <;> simp +decide [this, mul_comm r] <;> ring

end PhysicsSM.Lie.Exceptional.OctonionSymmetry
