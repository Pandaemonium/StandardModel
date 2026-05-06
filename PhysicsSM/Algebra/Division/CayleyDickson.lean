import Mathlib

/-!
# Algebra.Division.CayleyDickson

Generic Cayley–Dickson doubling construction.

Given an algebra `A` with a star (conjugation), the Cayley–Dickson double
`CayleyDickson A` consists of pairs `(a, b) ∈ A × A` with multiplication:

  `(a, b) * (c, d) = (a * c - star d * b, d * a + b * star c)`

This reproduces: `ℝ → ℂ → ℍ → 𝕆`, losing commutativity at `ℍ` and
associativity at `𝕆`.

Source: Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), §2.2.
Conventions: follows the sign convention in Baez (2002).

## Main definitions

* `CayleyDickson A` — the doubling of `A`, an `@[ext]` structure with `fst` and `snd`
* Instances: `Zero`, `Add`, `Neg`, `One`, `Mul`, `Star`, `AddCommGroup`,
  `InvolutiveStar`, `StarMul`
* `CayleyDickson.embed` — embedding `A ↪ CayleyDickson A` as `(a, 0)`
* `CayleyDickson.imagUnit` — the new imaginary unit `(0, 1)`
* `CayleyDickson.normSq` — squared norm (sum of component squared norms)

## Main results

* Conjugation is an involution (`star_star_eq`)
* Conjugation reverses multiplication (`star_mul_eq`)
* Conjugation distributes over addition (`star_add_eq`)
* Identity element: `1 * x = x` and `x * 1 = x`
* Distributivity: `x * (y + z) = x * y + x * z` and `(x + y) * z = x * z + y * z`
* The imaginary unit squares to `-1` over `ℝ` (`imagUnit_sq_real`)
* Squared norm is nonneg and faithful (`normSq_nonneg`, `normSq_eq_zero_iff`)

## Draft connection

The existing project `Octonion` type should eventually be shown equivalent
to `CayleyDickson (CayleyDickson (CayleyDickson ℝ))`. See the draft section
at the end of this file.

Prerequisites:
- `PhysicsSM.Algebra.Division.Basic`

Status: trusted — no `sorry` in any definition or lemma.
-/

namespace PhysicsSM.Algebra.Division

/-! ## The Cayley–Dickson pair type -/

/-- The Cayley–Dickson doubling of an algebra `A`.

An element of `CayleyDickson A` is a pair `(fst, snd)` of elements of `A`.
The algebra structure (multiplication, conjugation) is defined below. -/
@[ext]
structure CayleyDickson (A : Type*) where
  /-- The first component. -/
  fst : A
  /-- The second component. -/
  snd : A

variable {A : Type*}

namespace CayleyDickson

/-! ## Basic algebraic instances -/

instance instZero [Zero A] : Zero (CayleyDickson A) where
  zero := ⟨0, 0⟩

instance instOne [Zero A] [One A] : One (CayleyDickson A) where
  one := ⟨1, 0⟩

instance instAdd [Add A] : Add (CayleyDickson A) where
  add x y := ⟨x.fst + y.fst, x.snd + y.snd⟩

instance instNeg [Neg A] : Neg (CayleyDickson A) where
  neg x := ⟨-x.fst, -x.snd⟩

instance instStar [Star A] [Neg A] : Star (CayleyDickson A) where
  star x := ⟨star x.fst, -x.snd⟩

/-- Cayley–Dickson multiplication.
    `(a, b) * (c, d) = (a * c - star d * b, d * a + b * star c)`.
    Follows the Baez sign convention. -/
instance instMul [Ring A] [StarRing A] : Mul (CayleyDickson A) where
  mul x y := ⟨x.fst * y.fst - star y.snd * x.snd,
              y.snd * x.fst + x.snd * star y.fst⟩

instance instSMul {R : Type*} [SMul R A] : SMul R (CayleyDickson A) where
  smul r x := ⟨r • x.fst, r • x.snd⟩

/-! ## Component simp lemmas

These are deliberately `@[simp]` so that `ext <;> simp` works as a proof
strategy for coordinatewise identities.
-/

variable [Ring A] [StarRing A]

@[simp] theorem zero_fst : (0 : CayleyDickson A).fst = 0 := rfl
@[simp] theorem zero_snd : (0 : CayleyDickson A).snd = 0 := rfl
@[simp] theorem one_fst : (1 : CayleyDickson A).fst = 1 := rfl
@[simp] theorem one_snd : (1 : CayleyDickson A).snd = 0 := rfl

@[simp] theorem add_fst' (x y : CayleyDickson A) :
    (x + y).fst = x.fst + y.fst := rfl
@[simp] theorem add_snd' (x y : CayleyDickson A) :
    (x + y).snd = x.snd + y.snd := rfl

@[simp] theorem neg_fst' (x : CayleyDickson A) : (-x).fst = -x.fst := rfl
@[simp] theorem neg_snd' (x : CayleyDickson A) : (-x).snd = -x.snd := rfl

@[simp] theorem mul_fst' (x y : CayleyDickson A) :
    (x * y).fst = x.fst * y.fst - star y.snd * x.snd := rfl
@[simp] theorem mul_snd' (x y : CayleyDickson A) :
    (x * y).snd = y.snd * x.fst + x.snd * star y.fst := rfl

@[simp] theorem star_fst' (x : CayleyDickson A) :
    (star x).fst = star x.fst := rfl
@[simp] theorem star_snd' (x : CayleyDickson A) :
    (star x).snd = -x.snd := rfl

@[simp] theorem smul_fst' {R : Type*} [SMul R A] (r : R) (x : CayleyDickson A) :
    (r • x).fst = r • x.fst := rfl
@[simp] theorem smul_snd' {R : Type*} [SMul R A] (r : R) (x : CayleyDickson A) :
    (r • x).snd = r • x.snd := rfl

/-! ## AddCommGroup instance -/

instance instAddCommGroup : AddCommGroup (CayleyDickson A) where
  add_assoc a b c := by ext <;> simp [add_assoc]
  zero_add a := by ext <;> simp
  add_zero a := by ext <;> simp
  add_comm a b := by ext <;> simp [add_comm]
  neg_add_cancel a := by ext <;> simp
  nsmul := nsmulRec
  zsmul := zsmulRec

@[simp] theorem sub_fst' (x y : CayleyDickson A) :
    (x - y).fst = x.fst - y.fst := by
  change (x + -y).fst = _; simp [sub_eq_add_neg]
@[simp] theorem sub_snd' (x y : CayleyDickson A) :
    (x - y).snd = x.snd - y.snd := by
  change (x + -y).snd = _; simp [sub_eq_add_neg]

/-! ## Module instance -/

instance instModule {R : Type*} [CommRing R] [Module R A] :
    Module R (CayleyDickson A) where
  one_smul x := by ext <;> simp [one_smul]
  mul_smul r s x := by ext <;> simp [mul_smul]
  smul_add r x y := by ext <;> simp [smul_add]
  smul_zero r := by ext <;> simp [smul_zero]
  add_smul r s x := by ext <;> simp [add_smul]
  zero_smul x := by ext <;> simp [zero_smul]

/-! ## Embedding and imaginary unit -/

/-- Embed an element of `A` into the Cayley–Dickson double as `(a, 0)`. -/
def embed [Zero A] (a : A) : CayleyDickson A := ⟨a, 0⟩

@[simp] theorem embed_fst [Zero A] (a : A) : (embed a).fst = a := rfl
@[simp] theorem embed_snd [Zero A] (a : A) : (embed a).snd = 0 := rfl

/-- The "imaginary unit" of the doubling: the element `(0, 1)`.
    In the chain `ℝ → ℂ → ℍ → 𝕆`, this is `i`, then `j`, then `ℓ`. -/
def imagUnit [Zero A] [One A] : CayleyDickson A := ⟨0, 1⟩

@[simp] theorem imagUnit_fst [Zero A] [One A] :
    (imagUnit : CayleyDickson A).fst = 0 := rfl
@[simp] theorem imagUnit_snd [Zero A] [One A] :
    (imagUnit : CayleyDickson A).snd = 1 := rfl

/-! ## Conjugation properties -/

/-- Conjugation of zero is zero. -/
@[simp] theorem star_zero_cd : star (0 : CayleyDickson A) = 0 := by
  ext <;> simp [star_zero]

/-- Conjugation is an involution:
    `star (star x) = x` for all `x : CayleyDickson A`. -/
theorem star_star_eq (x : CayleyDickson A) : star (star x) = x := by
  ext <;> simp [star_star]

/-- Conjugation distributes over addition. -/
theorem star_add_eq (x y : CayleyDickson A) :
    star (x + y) = star x + star y := by
  ext
  · exact star_add x.fst y.fst
  · exact neg_add x.snd y.snd

/-- Conjugation distributes over negation. -/
theorem star_neg_eq (x : CayleyDickson A) :
    star (-x) = -star x := by
  ext
  · exact star_neg x.fst
  · simp

/-- Conjugation reverses multiplication:
    `star (x * y) = star y * star x`. -/
theorem star_mul_eq (x y : CayleyDickson A) :
    star (x * y) = star y * star x := by
  ext <;> simp [star_mul, neg_mul, mul_neg] <;> abel

/-- Conjugation of the identity is the identity. -/
@[simp] theorem star_one_cd : star (1 : CayleyDickson A) = 1 := by
  ext <;> simp [star_one]

/-- `CayleyDickson A` has an involutive star. -/
instance instInvolutiveStar : InvolutiveStar (CayleyDickson A) where
  star_involutive := star_star_eq

/-- `CayleyDickson A` has a star that reverses multiplication. -/
instance instStarMul : StarMul (CayleyDickson A) where
  star_mul := star_mul_eq

/-! ## Multiplication properties -/

/-- Left identity: `1 * x = x`. -/
theorem one_mul_eq (x : CayleyDickson A) : 1 * x = x := by
  ext <;> simp

/-- Right identity: `x * 1 = x`. -/
theorem mul_one_eq (x : CayleyDickson A) : x * 1 = x := by
  ext <;> simp

/-- Left absorption: `0 * x = 0`. -/
theorem zero_mul_eq (x : CayleyDickson A) : 0 * x = 0 := by
  ext <;> simp

/-- Right absorption: `x * 0 = 0`. -/
theorem mul_zero_eq (x : CayleyDickson A) : x * 0 = 0 := by
  ext <;> simp

/-- Left distributivity: `x * (y + z) = x * y + x * z`. -/
theorem left_distrib_eq (x y z : CayleyDickson A) :
    x * (y + z) = x * y + x * z := by
  ext <;> simp [star_add, mul_add, add_mul] <;> abel

/-- Right distributivity: `(x + y) * z = x * z + y * z`. -/
theorem right_distrib_eq (x y z : CayleyDickson A) :
    (x + y) * z = x * z + y * z := by
  ext <;> simp [mul_add, add_mul] <;> abel

/-- Negation and left multiplication: `(-x) * y = -(x * y)`. -/
theorem neg_mul_eq (x y : CayleyDickson A) : (-x) * y = -(x * y) := by
  ext <;> simp [neg_mul, mul_neg] <;> abel

/-- Negation and right multiplication: `x * (-y) = -(x * y)`. -/
theorem mul_neg_eq (x y : CayleyDickson A) : x * (-y) = -(x * y) := by
  ext <;> simp [star_neg, neg_mul, mul_neg] <;> abel

/-! ## Squared norm -/

/-- The squared norm on the Cayley–Dickson double, parametrized by a
    squared-norm function `nA` on the base algebra:
    `normSq nA x = nA x.fst + nA x.snd`. -/
noncomputable def normSq (nA : A → ℝ) (x : CayleyDickson A) : ℝ :=
  nA x.fst + nA x.snd

omit [StarRing A] in
theorem normSq_apply (nA : A → ℝ) (x : CayleyDickson A) :
    normSq nA x = nA x.fst + nA x.snd := rfl

omit [StarRing A] in
/-- The squared norm of zero is zero when the base norm sends zero to zero. -/
theorem normSq_zero (nA : A → ℝ) (h0 : nA 0 = 0) :
    normSq nA (0 : CayleyDickson A) = 0 := by
  simp [normSq_apply, h0]

omit [StarRing A] in
/-- The squared norm is nonneg when the base norm is nonneg. -/
theorem normSq_nonneg (nA : A → ℝ) (hnn : ∀ a, 0 ≤ nA a)
    (x : CayleyDickson A) : 0 ≤ normSq nA x :=
  add_nonneg (hnn x.fst) (hnn x.snd)

omit [StarRing A] in
/-- The squared norm vanishes iff both components are zero, when the base norm
    vanishes only at zero. -/
theorem normSq_eq_zero_iff (nA : A → ℝ) (hnn : ∀ a, 0 ≤ nA a)
    (h0 : ∀ a, nA a = 0 ↔ a = 0) (x : CayleyDickson A) :
    normSq nA x = 0 ↔ x = 0 := by
  constructor
  · intro h
    have hf := hnn x.fst
    have hs := hnn x.snd
    have hab : nA x.fst + nA x.snd = 0 := h
    have hfa : nA x.fst = 0 := by linarith
    have hsa : nA x.snd = 0 := by linarith
    ext
    · exact (h0 x.fst).mp hfa
    · exact (h0 x.snd).mp hsa
  · rintro rfl
    simp [normSq_apply, (h0 0).mpr rfl]

/-! ## Special case: ℝ (trivial star) -/

/-- Over `ℝ` (with trivial star), the imaginary unit squares to `-1`.
    This is the fundamental property that makes the Cayley–Dickson construction
    produce complex numbers from the reals. -/
theorem imagUnit_sq_real :
    (imagUnit : CayleyDickson ℝ) * imagUnit = -1 := by
  ext <;> simp [imagUnit, star_trivial]

/-- Embedding preserves multiplication over `ℝ`. -/
theorem embed_mul_real (a b : ℝ) :
    embed a * embed b = (embed (a * b) : CayleyDickson ℝ) := by
  ext <;> simp [embed, star_trivial]

omit [StarRing A] in
/-- Embedding preserves addition. -/
theorem embed_add (a b : A) :
    embed a + embed b = (embed (a + b) : CayleyDickson A) := by
  ext <;> simp [embed]

omit [StarRing A] in
/-- Embedding preserves zero. -/
@[simp] theorem embed_zero_eq :
    embed (0 : A) = (0 : CayleyDickson A) := by
  ext <;> rfl

omit [StarRing A] in
/-- Embedding preserves one. -/
@[simp] theorem embed_one_eq :
    embed (1 : A) = (1 : CayleyDickson A) := by
  ext <;> rfl

/-! ## Iterated Cayley–Dickson types -/

/-- The complex numbers as the first Cayley–Dickson doubling of `ℝ`. -/
abbrev CD1 := CayleyDickson ℝ

/-- The quaternions as the second Cayley–Dickson doubling. -/
abbrev CD2 := CayleyDickson CD1

/-- The octonions as the third Cayley–Dickson doubling. -/
abbrev CD3 := CayleyDickson CD2

/-!
## Draft: Connection to project Octonion type

The existing `PhysicsSM.Algebra.Octonion.Octonion` type uses explicit
8-coordinate representation with the XOR Fano plane convention. The iterated
Cayley–Dickson type `CD3 = CayleyDickson (CayleyDickson (CayleyDickson ℝ))`
should be ring-isomorphic to it, but proving this requires:

1. Establishing that the Cayley–Dickson multiplication on `CD3` matches the
   explicit sign table in `PhysicsSM.Algebra.Octonion.Basic.lookupSign`.
2. Defining the coordinate isomorphism `CD3 ≃ Octonion` that maps the eight
   real coordinates in the nested-pair representation to `c0, ..., c7`.
3. Verifying that this isomorphism preserves multiplication on all 64 basis
   products (or equivalently, on the 7 Fano triples plus the unit).

This is a nontrivial verification that belongs in a future milestone. The key
difficulty is that the sign convention depends on the parenthesization order
in the Cayley–Dickson iteration, which must be matched to the project's XOR
Fano triple orientation.

When this bridge is complete, it will provide an alternative construction path
for octonion identities: prove them generically for Cayley–Dickson algebras,
then transfer via the isomorphism.
-/

end CayleyDickson

end PhysicsSM.Algebra.Division
