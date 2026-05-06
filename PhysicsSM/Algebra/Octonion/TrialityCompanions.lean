import Mathlib.Tactic
import PhysicsSM.Algebra.Octonion.Norm
import PhysicsSM.Algebra.Octonion.Moufang

/-!
# Algebra.Octonion.TrialityCompanions

This module packages the first trusted Lean foothold for the
Conway-Smith/Yokota conjugation criterion for unit octonions.

For a unit octonion `a`, we study the explicitly parenthesized map

`conjBy a x = (a * x) * conj a`.

The ambitious informal theorem says that this map is an algebra automorphism
exactly in the cases where the octonion cube of `a` is `1` or `-1`, and that
the nontrivial automorphism has order three.  This file proves the forward
direction and the order-three consequence:

- `conjBy_mul_of_unit_cube_eq_one`
- `conjBy_mul_of_unit_cube_eq_neg_one`
- `conjBy_iter_three_of_unit_cube_eq_one`
- `conjBy_iter_three_of_unit_cube_eq_neg_one`

The companion-map predicates are also defined for the next round of work, but
the actual companion identities are not proved here.

## Convention warning

Octonions are not associative.  Every theorem in this file keeps parentheses
explicit.  In particular, `cube a` is defined as `(a * a) * a`, and `conjBy`
is defined as `(a * x) * conj a`.  Any reassociation through `conj a` is routed
through named lemmas such as `mul_assoc_with_conj_right`.

Source: Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), Section 4;
Conway and Smith, "On Quaternions and Octonions", Chapter 8; Yokota,
"Exceptional Lie Groups".
Convention: XOR basis and Fano orientation from
`PhysicsSM.Algebra.Octonion.Basic`.
Provenance: Aristotle job `d76adda3-911d-43d2-ac78-6d122fcda89c`, cleaned for
this repository with descriptive public names and expanded review comments.

Status: trusted.  The file contains no proof placeholders; the key theorems
are kernel-checked under the pinned Lean 4.28.0 toolchain.
-/

namespace PhysicsSM.Algebra.Octonion

/-!
## Local arithmetic helpers

The project octonions deliberately do not instantiate the full ring hierarchy:
the product is nonassociative.  The small helper lemmas below expose only the
coordinate facts needed in this module.  They are intentionally named with the
`octonion_` prefix so that downstream users do not confuse them with generic
ring lemmas.
-/

private theorem octonion_mul_one (a : Octonion) : a * 1 = a := by
  ext <;> simp

private theorem octonion_one_mul (a : Octonion) : 1 * a = a := by
  ext <;> simp

private theorem octonion_one_smul (a : Octonion) : (1 : ℝ) • a = a := by
  ext <;> simp [_root_.one_mul]

private theorem octonion_mul_add (a b c : Octonion) :
    a * (b + c) = a * b + a * c := by
  ext <;> simp <;> ring

private theorem octonion_add_mul (a b c : Octonion) :
    (a + b) * c = a * c + b * c := by
  ext <;> simp <;> ring

private theorem octonion_mul_zero (a : Octonion) : a * 0 = 0 := by
  ext <;> simp

private theorem octonion_zero_mul (a : Octonion) : 0 * a = 0 := by
  ext <;> simp

private theorem octonion_smul_mul (r : ℝ) (a b : Octonion) :
    (r • a) * b = r • (a * b) := by
  ext <;> simp <;> ring

private theorem octonion_mul_smul (r : ℝ) (a b : Octonion) :
    a * (r • b) = r • (a * b) := by
  ext <;> simp <;> ring

private theorem octonion_neg_mul (a b : Octonion) : (-a) * b = -(a * b) := by
  ext <;> simp <;> ring

private theorem octonion_mul_neg (a b : Octonion) : a * (-b) = -(a * b) := by
  ext <;> simp <;> ring

private theorem octonion_neg_neg (x : Octonion) : -(-x) = x := by
  ext <;> simp

private theorem octonion_neg_mul_neg (a b : Octonion) :
    (-a) * (-b) = a * b := by
  rw [octonion_neg_mul, octonion_mul_neg, octonion_neg_neg]

/-- Conjugation fixes the scalar unit. -/
theorem conj_one : conj (1 : Octonion) = 1 := by
  ext <;> simp [conj]

/-- Conjugation fixes `-1`, since `-1` is still a real scalar octonion. -/
theorem conj_neg_one : conj (-1 : Octonion) = -1 := by
  ext <;> simp [conj]

private theorem octonion_neg_one_mul (x : Octonion) :
    (-1 : Octonion) * x = -x := by
  ext <;> simp

private theorem octonion_mul_neg_one (x : Octonion) :
    x * (-1 : Octonion) = -x := by
  ext <;> simp

/-! ## Cubes and conjugation-by maps -/

/--
The canonical cube parenthesization used in this file.

For octonions, writing `a^3` without comment is risky because the product is
not globally associative.  This definition fixes the convention
`cube a = (a * a) * a`.
-/
def cube (a : Octonion) : Octonion := (a * a) * a

/--
Conjugation by an octonion using the project convention.

This is the concrete map studied in the Conway-Smith/Yokota criterion.  The
right factor is `conj a`, which is the inverse of `a` only after the unit
hypothesis `normSq a = 1` is supplied.
-/
def conjBy (a x : Octonion) : Octonion := (a * x) * conj a

/--
The left-associated and right-associated cubes agree.

This is a special associativity statement coming from right alternativity, not
a general associativity rule for octonions.
-/
theorem cube_assoc (a : Octonion) : a * (a * a) = cube a :=
  (right_alternative a a).symm

/--
A unit octonion multiplied on the right by its conjugate is the scalar unit.

This is the inverse law used throughout the module.  It depends on the
normalization hypothesis `normSq a = 1`.
-/
theorem unit_mul_conj_eq_one {a : Octonion} (ha : normSq a = 1) :
    a * conj a = 1 := by
  have h := (normSq_eq_mul_conj a).symm
  rw [ha, octonion_one_smul] at h
  exact h

/--
The corresponding left inverse law for a unit octonion.

For octonions this is proved explicitly from `conj_mul_self`, rather than from
an associative inverse API.
-/
theorem unit_conj_mul_eq_one {a : Octonion} (ha : normSq a = 1) :
    conj a * a = 1 := by
  have h := conj_mul_self a
  rw [show a.c0 ^ 2 + a.c1 ^ 2 + a.c2 ^ 2 + a.c3 ^ 2 +
      a.c4 ^ 2 + a.c5 ^ 2 + a.c6 ^ 2 + a.c7 ^ 2 = normSq a from rfl] at h
  rw [ha, octonion_one_smul] at h
  exact h

/-- Applying `conjBy a` to the scalar unit leaves the product `a * conj a`. -/
theorem conjBy_one (a : Octonion) : conjBy a 1 = a * conj a := by
  unfold conjBy
  rw [octonion_mul_one]

/-- A unit octonion conjugates the scalar unit to itself. -/
theorem conjBy_one_of_unit {a : Octonion} (ha : normSq a = 1) :
    conjBy a 1 = 1 := by
  rw [conjBy_one, unit_mul_conj_eq_one ha]

/--
`conjBy a` preserves addition.

This is a coordinate linearity fact about the left and right multiplication
maps.  It is not using multiplicativity of `conjBy`, which is much harder and
requires the cube hypotheses below.
-/
theorem conjBy_add (a x y : Octonion) :
    conjBy a (x + y) = conjBy a x + conjBy a y := by
  unfold conjBy
  rw [octonion_mul_add, octonion_add_mul]

/-- `conjBy a` is linear over the real scalar action. -/
theorem conjBy_smul (a : Octonion) (r : ℝ) (x : Octonion) :
    conjBy a (r • x) = r • conjBy a x := by
  unfold conjBy
  rw [octonion_mul_smul, octonion_smul_mul]

/--
Conjugation commutes with the fixed cube parenthesization.

The proof uses `conj_mul`, which reverses products, and then the alternative
law to return to the canonical cube convention.
-/
theorem cube_conj (a : Octonion) : cube (conj a) = conj (cube a) := by
  unfold cube
  rw [conj_mul, conj_mul]
  exact right_alternative (conj a) (conj a)

/-- The conjugate of a unit octonion is again unit-norm. -/
theorem normSq_conj_unit {a : Octonion} (ha : normSq a = 1) :
    normSq (conj a) = 1 := by
  rw [normSq_conj, ha]

/-! ## Reassociation and cancellation with conjugates -/

/--
Artin-style reassociation through the pair `a`, `conj a`.

Although octonions are not associative, the subalgebra generated by one
octonion and its conjugate is associative enough for this particular
parenthesis change.  The proof is a direct coordinate verification in the
project XOR convention.
-/
theorem mul_assoc_with_conj_right (a x : Octonion) :
    (a * x) * conj a = a * (x * conj a) := by
  exact Eq.symm (by
    ext <;>
      simp [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
        Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5,
        Octonion.mul_c6, Octonion.mul_c7, Octonion.conj] <;>
      ring)

/-- The same reassociation lemma with `conj a` on the left and `a` on the right. -/
theorem conj_mul_assoc_with_right (a x : Octonion) :
    (conj a * x) * a = conj a * (x * a) := by
  have h := mul_assoc_with_conj_right (conj a) x
  rw [conj_conj] at h
  exact h

/--
Right cancellation by `a` and `conj a`.

No inverse typeclass is involved.  The result says that multiplying by `a` and
then by `conj a` scales the original octonion by `normSq a`.
-/
theorem mul_conj_cancel_right (a x : Octonion) :
    (x * a) * conj a = normSq a • x := by
  ext <;>
    simp [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
      Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5,
      Octonion.mul_c6, Octonion.mul_c7, normSq] <;>
    ring

/--
Left cancellation by `conj a` and `a`.

This is the left-handed companion to `mul_conj_cancel_right`.
-/
theorem conj_mul_cancel_left (a x : Octonion) :
    conj a * (a * x) = normSq a • x := by
  ext <;>
    simp [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
      Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5,
      Octonion.mul_c6, Octonion.mul_c7, normSq] <;>
    ring

/-- The cancellation law with `conj a` followed by `a` on the right. -/
theorem conj_mul_conj_cancel_right (a x : Octonion) :
    (x * conj a) * a = normSq a • x := by
  have h := mul_conj_cancel_right (conj a) x
  rw [conj_conj, normSq_conj] at h
  exact h

/-- The cancellation law with `a` and `conj a` on the left. -/
theorem mul_conj_cancel_left (a x : Octonion) :
    a * (conj a * x) = normSq a • x := by
  have h := conj_mul_cancel_left (conj a) x
  rw [conj_conj, normSq_conj] at h
  exact h

/--
Unit right cancellation: for unit `a`, `(x * a) * conj a = x`.
-/
theorem unit_mul_conj_cancel_right {a : Octonion} (ha : normSq a = 1)
    (x : Octonion) : (x * a) * conj a = x := by
  rw [mul_conj_cancel_right, ha, octonion_one_smul]

/--
Unit left cancellation: for unit `a`, `conj a * (a * x) = x`.
-/
theorem unit_conj_mul_cancel_left {a : Octonion} (ha : normSq a = 1)
    (x : Octonion) : conj a * (a * x) = x := by
  rw [conj_mul_cancel_left, ha, octonion_one_smul]

/--
Unit right cancellation in the reverse conjugate order.
-/
theorem unit_conj_mul_conj_cancel_right {a : Octonion} (ha : normSq a = 1)
    (x : Octonion) : (x * conj a) * a = x := by
  rw [conj_mul_conj_cancel_right, ha, octonion_one_smul]

/--
Unit left cancellation in the reverse conjugate order.
-/
theorem unit_mul_conj_cancel_left {a : Octonion} (ha : normSq a = 1)
    (x : Octonion) : a * (conj a * x) = x := by
  rw [mul_conj_cancel_left, ha, octonion_one_smul]

/-! ## Order-three consequences -/

/--
If `a` is unit-norm and has `cube a = 1`, then applying `conjBy a` three times
is the identity.

This is one half of the order-three behavior in the Conway-Smith/Yokota
criterion.  The proof is algebraic and relies on the unit cancellation lemmas
above.  The final nonassociative manipulations are discharged by `grind`,
using the explicit lemmas in this file plus the Moufang/alternative identities.
-/
theorem conjBy_iter_three_of_unit_cube_eq_one
    {a : Octonion} (ha_unit : normSq a = 1)
    (ha_cube : cube a = 1) (x : Octonion) :
    conjBy a (conjBy a (conjBy a x)) = x := by
  unfold conjBy
  have h_cube_left : (a * a) * a = 1 := by
    exact ha_cube
  grind +suggestions

/--
If `a` is unit-norm and has `cube a = -1`, then applying `conjBy a` three
times is again the identity.

The proof first derives the useful concrete identity `conj a = -(a * a)`.
After that, the double application of `conjBy a` collapses to
`conj a * (x * a)`, and one more unit-cancellation step finishes the proof.
-/
theorem conjBy_iter_three_of_unit_cube_eq_neg_one
    {a : Octonion} (ha_unit : normSq a = 1)
    (ha_cube : cube a = -1) (x : Octonion) :
    conjBy a (conjBy a (conjBy a x)) = x := by
  have h_conj_eq_neg_square : conj a = -(a * a) := by
    have h_cube_eq_neg_one : (a * a) * a = -1 := by
      exact ha_cube
    apply_fun (fun z => z * conj a) at h_cube_eq_neg_one
    rw [mul_conj_cancel_right] at h_cube_eq_neg_one
    rw [ha_unit] at h_cube_eq_neg_one
    rw [octonion_one_smul] at h_cube_eq_neg_one
    aesop
  have h_double_conjBy : conjBy a (conjBy a x) = conj a * (x * a) := by
    unfold conjBy
    simp only [h_conj_eq_neg_square, octonion_mul_neg, octonion_neg_mul]
    grind +suggestions
  have h_third_conjBy : conjBy a (conj a * (x * a)) = x := by
    unfold conjBy
    have h_left_cancel : a * (conj a * (x * a)) = x * a := by
      convert unit_mul_conj_cancel_left ha_unit (x * a) using 1
    rw [h_left_cancel, unit_mul_conj_cancel_right ha_unit]
  rw [h_double_conjBy, h_third_conjBy]

/-! ## Forward automorphism theorems -/

/--
Forward Conway-Smith/Yokota direction for `cube a = 1`.

If `a` is unit-norm and `(a * a) * a = 1`, then `conjBy a` preserves the
octonion product.  This is an automorphism-direction theorem, not the full
iff criterion: the converse is left for later work.
-/
theorem conjBy_mul_of_unit_cube_eq_one
    {a : Octonion} (ha_unit : normSq a = 1)
    (ha_cube : cube a = 1) (x y : Octonion) :
    conjBy a (x * y) = conjBy a x * conjBy a y := by
  unfold conjBy
  have h_reassociate_right :
      ∀ z : Octonion, a * (z * conj a) = (a * z) * conj a := by
    intro z
    exact (mul_assoc_with_conj_right a z).symm
  have h_unit_left_cancel :
      ∀ z : Octonion, conj a * (a * z) = z := by
    intro z
    exact unit_conj_mul_cancel_left ha_unit z
  grind +suggestions

/-- Negation preserves the squared norm. -/
theorem normSq_neg (a : Octonion) : normSq (-a) = normSq a := by
  simp [normSq]

/--
The cube of `-a` is the negative of the cube of `a`.

The statement uses the fixed cube parenthesization from this file.
-/
theorem cube_neg (a : Octonion) : cube (-a) = -(cube a) := by
  unfold cube
  rw [octonion_neg_mul_neg, octonion_mul_neg]

/--
Changing `a` to `-a` does not change the conjugation-by map.

Both the left factor and the conjugate right factor acquire a minus sign, and
the signs cancel in the bilinear octonion product.
-/
theorem conjBy_neg (a x : Octonion) : conjBy (-a) x = conjBy a x := by
  unfold conjBy
  rw [conj_neg, octonion_neg_mul, octonion_neg_mul_neg]

/--
Forward Conway-Smith/Yokota direction for `cube a = -1`.

The proof reduces to the `cube = 1` theorem by replacing `a` with `-a`.
The lemmas `normSq_neg`, `cube_neg`, and `conjBy_neg` record exactly why that
reduction is legitimate.
-/
theorem conjBy_mul_of_unit_cube_eq_neg_one
    {a : Octonion} (ha_unit : normSq a = 1)
    (ha_cube : cube a = -1) (x y : Octonion) :
    conjBy a (x * y) = conjBy a x * conjBy a y := by
  have h := conjBy_mul_of_unit_cube_eq_one
    (by rw [normSq_neg]; exact ha_unit)
    (by rw [cube_neg, ha_cube, octonion_neg_neg]) x y
  simp only [conjBy_neg] at h
  exact h

/-! ## Bijectivity and structural preservation for `conjBy` -/

/--
Conjugation by a unit octonion preserves the squared norm.

No cube hypothesis is needed.  The proof uses norm multiplicativity twice:
first for `(a * x)`, then for the final multiplication by `conj a`.

Provenance: Aristotle job `270e946c-7615-49ff-aded-15f9a2c68c15`, cleaned and
kept in trusted code because the proof is complete and uses the existing
project norm convention.
-/
theorem conjBy_normSq_of_unit {a : Octonion} (ha_unit : normSq a = 1)
    (x : Octonion) :
    normSq (conjBy a x) = normSq x := by
  unfold conjBy
  rw [normSq_mul, normSq_mul, normSq_conj, ha_unit]
  ring

/--
`conjBy a` commutes with octonion conjugation.

This identity is true without assuming `a` has unit norm.  The only
nonassociative subtlety is the reassociation through `a` and `conj a`, which is
handled by `mul_assoc_with_conj_right`.

Provenance: Aristotle job `270e946c-7615-49ff-aded-15f9a2c68c15`.
-/
theorem conjBy_commutes_conjugation (a x : Octonion) :
    conjBy a (conj x) = conj (conjBy a x) := by
  unfold conjBy
  rw [mul_assoc_with_conj_right, conj_mul, conj_mul]
  rw [conj_conj]

/--
For unit `a`, `conjBy (conj a)` is a left inverse of `conjBy a`.

This is the key cancellation fact behind bijectivity.  It is stated as a
separate lemma so later automorphism and group-action work can reuse the exact
inverse candidate rather than reconstructing it.

Provenance: Aristotle job `270e946c-7615-49ff-aded-15f9a2c68c15`.
-/
theorem conjBy_leftInverse_conj_of_unit {a : Octonion}
    (ha_unit : normSq a = 1) (z : Octonion) :
    conjBy (conj a) (conjBy a z) = z := by
  unfold conjBy
  grind +suggestions

/--
For unit `a`, `conjBy a` is injective.

The proof applies the explicit left inverse `conjBy (conj a)` to both sides.
-/
theorem conjBy_injective_of_unit {a : Octonion} (ha_unit : normSq a = 1) :
    Function.Injective (conjBy a) := by
  intro x y hxy
  have h_congruent := congr_arg (conjBy (conj a)) hxy
  rw [conjBy_leftInverse_conj_of_unit ha_unit x,
      conjBy_leftInverse_conj_of_unit ha_unit y] at h_congruent
  exact h_congruent

/--
For unit `a`, `conjBy a` is surjective.

The inverse candidate is again `conjBy (conj a)`.  To prove it is a right
inverse, we apply the left-inverse lemma to the unit octonion `conj a` and then
simplify `conj (conj a)`.
-/
theorem conjBy_surjective_of_unit {a : Octonion} (ha_unit : normSq a = 1) :
    Function.Surjective (conjBy a) := by
  intro y
  refine ⟨conjBy (conj a) y, ?_⟩
  have h_conj_unit : normSq (conj a) = 1 := normSq_conj_unit ha_unit
  simpa [conj_conj] using
    (conjBy_leftInverse_conj_of_unit (a := conj a) h_conj_unit y)

/--
For unit `a`, `conjBy a` is a bijection of the underlying octonion type.

This is only a bijectivity statement.  Multiplicativity is supplied separately
by the cube hypotheses in `conjBy_mul_of_unit_cube_eq_one` and
`conjBy_mul_of_unit_cube_eq_neg_one`.
-/
theorem conjBy_bijective_of_unit {a : Octonion} (ha_unit : normSq a = 1) :
    Function.Bijective (conjBy a) :=
  ⟨conjBy_injective_of_unit ha_unit, conjBy_surjective_of_unit ha_unit⟩

/-! ## Companion-map predicates for the next stage -/

/--
`HasCompanions gamma p q` records the Conway-Smith style companion identity
for a map `gamma`.

The actual companion theorems are intentionally not claimed in this file.  The
remaining problem is to identify and prove the correct companion pair for the
left, right, and `conjBy` maps without changing parenthesization silently.
-/
def HasCompanions (gamma : Octonion → Octonion) (p q : Octonion) : Prop :=
  ∀ x y : Octonion, gamma (x * y) = (gamma x * p) * (q * gamma y)

/--
Predicate saying that a map preserves the octonion multiplication with the
explicit project parenthesization.

This is useful for stating the still-open converse direction: if `conjBy a`
preserves multiplication and `normSq a = 1`, then one expects `cube a = 1` or
`cube a = -1`.
-/
def PreservesMul (gamma : Octonion → Octonion) : Prop :=
  ∀ x y : Octonion, gamma (x * y) = gamma x * gamma y

/--
For a unit octonion whose fixed cube is `1`, `conjBy a` has the concrete
structure expected of an algebra automorphism.

The project does not yet package this as a bundled `AlgEquiv`, because the
octonion multiplication is nonassociative and the correct bundled abstraction
needs separate design.  This theorem deliberately records the four trusted
pieces instead: preservation of `1`, additivity, multiplicativity, and
bijectivity.

Provenance: Aristotle job `270e946c-7615-49ff-aded-15f9a2c68c15`, with the
statement renamed from the raw output to make clear that it is unbundled
automorphism data.
-/
theorem conjBy_automorphismData_of_unit_cube_eq_one {a : Octonion}
    (ha_unit : normSq a = 1) (ha_cube : cube a = 1) :
    conjBy a 1 = 1 ∧
    (∀ x y, conjBy a (x + y) = conjBy a x + conjBy a y) ∧
    PreservesMul (conjBy a) ∧
    Function.Bijective (conjBy a) :=
  ⟨conjBy_one_of_unit ha_unit,
   fun x y => conjBy_add a x y,
   fun x y => conjBy_mul_of_unit_cube_eq_one ha_unit ha_cube x y,
   conjBy_bijective_of_unit ha_unit⟩

/--
For a unit octonion whose fixed cube is `-1`, `conjBy a` has the same concrete
unbundled automorphism data.

This is the negative-cube companion to
`conjBy_automorphismData_of_unit_cube_eq_one`; it reuses the already trusted
reduction through `conjBy_mul_of_unit_cube_eq_neg_one`.
-/
theorem conjBy_automorphismData_of_unit_cube_eq_neg_one {a : Octonion}
    (ha_unit : normSq a = 1) (ha_cube : cube a = -1) :
    conjBy a 1 = 1 ∧
    (∀ x y, conjBy a (x + y) = conjBy a x + conjBy a y) ∧
    PreservesMul (conjBy a) ∧
    Function.Bijective (conjBy a) :=
  ⟨conjBy_one_of_unit ha_unit,
   fun x y => conjBy_add a x y,
   fun x y => conjBy_mul_of_unit_cube_eq_neg_one ha_unit ha_cube x y,
   conjBy_bijective_of_unit ha_unit⟩

/-! ## Converse multiplication criterion -/

/--
Hard converse direction of the Conway-Smith/Yokota-style `conjBy` criterion.

If `a` has unit norm and the explicitly parenthesized map
`conjBy a x = (a * x) * conj a` preserves octonion multiplication, then the
fixed parenthesized cube `(a * a) * a` is forced to be either `1` or `-1`.

The proof is finite and coordinate-based.  It specializes the multiplicativity
hypothesis to seven carefully chosen pairs of imaginary basis elements, expands
those equations in the project XOR/Fano multiplication table, and lets `grind`
combine the resulting polynomial constraints with `normSq a = 1`.  This keeps
all nonassociative parenthesization explicit and avoids introducing any bundled
associative-algebra abstraction for octonions.

Provenance: Aristotle job `6065091b-6f6b-4de4-9590-501d6c3ab742`, reviewed
after the extracted file kernel-checked with no proof placeholders.
-/
theorem conjBy_preservesMul_implies_cube_eq_one_or_neg_one
    {a : Octonion} (ha_unit : normSq a = 1)
    (h_preserves_mul : PreservesMul (conjBy a)) :
    cube a = 1 ∨ cube a = -1 := by
  have h_basis_equations :
      conjBy a (basisElem 2 * basisElem 3) =
          conjBy a (basisElem 2) * conjBy a (basisElem 3) ∧
      conjBy a (basisElem 2 * basisElem 4) =
          conjBy a (basisElem 2) * conjBy a (basisElem 4) ∧
      conjBy a (basisElem 1 * basisElem 5) =
          conjBy a (basisElem 1) * conjBy a (basisElem 5) ∧
      conjBy a (basisElem 1 * basisElem 6) =
          conjBy a (basisElem 1) * conjBy a (basisElem 6) ∧
      conjBy a (basisElem 3 * basisElem 5) =
          conjBy a (basisElem 3) * conjBy a (basisElem 5) ∧
      conjBy a (basisElem 3 * basisElem 7) =
          conjBy a (basisElem 3) * conjBy a (basisElem 7) ∧
      conjBy a (basisElem 1 * basisElem 2) =
          conjBy a (basisElem 1) * conjBy a (basisElem 2) := by
    exact ⟨h_preserves_mul _ _, h_preserves_mul _ _, h_preserves_mul _ _,
      h_preserves_mul _ _, h_preserves_mul _ _, h_preserves_mul _ _,
      h_preserves_mul _ _⟩
  unfold conjBy at h_basis_equations
  unfold basisElem at h_basis_equations
  simp +decide [Octonion.ext_iff] at h_basis_equations ⊢
  unfold cube
  simp +decide [Octonion.mul_c0, Octonion.mul_c1, Octonion.mul_c2,
    Octonion.mul_c3, Octonion.mul_c4, Octonion.mul_c5, Octonion.mul_c6,
    Octonion.mul_c7] at *
  grind

/--
Full Conway-Smith/Yokota-style criterion for the project `conjBy` map.

For a unit octonion `a`, `conjBy a` preserves the octonion product exactly when
the fixed parenthesized cube `cube a = (a * a) * a` is `1` or `-1`.

The forward implication is
`conjBy_preservesMul_implies_cube_eq_one_or_neg_one`.  The reverse implication
uses the two previously trusted forward multiplication theorems for cube `1`
and cube `-1`.
-/
theorem conjBy_preservesMul_iff_cube_eq_one_or_neg_one
    {a : Octonion} (ha_unit : normSq a = 1) :
    PreservesMul (conjBy a) ↔ cube a = 1 ∨ cube a = -1 := by
  constructor
  · exact conjBy_preservesMul_implies_cube_eq_one_or_neg_one ha_unit
  · rintro (ha_cube | ha_cube)
    · exact fun x y => conjBy_mul_of_unit_cube_eq_one ha_unit ha_cube x y
    · exact fun x y => conjBy_mul_of_unit_cube_eq_neg_one ha_unit ha_cube x y

end PhysicsSM.Algebra.Octonion
