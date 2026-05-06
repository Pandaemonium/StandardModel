import Mathlib
import PhysicsSM.Algebra.Octonion.Conjugation

/-!
# Algebra.Jordan.H3O

The exceptional Jordan algebra `h_3(O)`: Hermitian 3×3 octonionic matrices.

## Overview

`H₃(O)` consists of 3×3 matrices over the octonions that are Hermitian
(`X† = X`, where conjugation-transpose uses octonion conjugation). The Jordan
product is `X ○ Y = (X Y + Y X) / 2`.

This is the coordinate model of the exceptional simple Jordan algebra, also
called the **Albert algebra**.

Claim boundary: this trusted file proves coordinate identities for `H3O` and
its Jordan product. It does not prove uniqueness of the Albert algebra, any
topological compact Lie group theorem, or the external identification of the
automorphism group with `F4`.

## Representation

We represent elements via six independent coordinates: three real diagonal
entries `alpha, beta, gamma : ℝ` and three off-diagonal octonion entries
`x, y, z : Octonion`. The full matrix is:

```text
[[α,      z,       conj(y)],
 [conj(z), β,       x      ],
 [y,       conj(x), γ      ]]
```

## Convention notes

- The octonion multiplication uses the project XOR-basis convention from
  `PhysicsSM.Algebra.Octonion.Basic`.
- The chosen copy of `C` inside `O` is `span_R {1, e111}` (coordinates
  `c1` through `c6` vanish).
- The Jordan product formula is derived by expanding `(AB + BA)/2` for
  octonionic matrix multiplication. Each binary octonion product is a single
  multiplication; no re-association is performed.

## Main definitions

- `H3O` — the structure type for elements of `h_3(O)`.
- `octonionInner` — the real inner product on octonions (`Re(conj(a) * b)`).
- `jordanProduct` — the Jordan product `(AB + BA)/2` in coordinates.
- `trace` — the trace `α + β + γ`.
- `oneH3O` — the identity element `diag(1, 1, 1)`.
- `InChosenComplexLine` — membership in `C = span_R {1, e111} ⊂ O`.
- `InStandardA` — membership in the upper-left `h_2(O)` block.
- `InStandardB` — membership in the `h_3(C)` subalgebra.
- `InStandardAInterB` — membership in the `h_2(C)` intersection.

## Status

This is a **trusted** module: it contains no `sorry`, `admit`, `axiom`,
`opaque`, or `unsafe`. All proofs are kernel-checked.

Source: Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002), §4.
Additional convention anchors:
Baez and Schwahn, "Projective Geometry and the Exceptional Jordan Algebra",
AMS Special Session on Non-Associative Rings and Algebras, March 28, 2026.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

open PhysicsSM.Algebra.Octonion

/-! ## Concrete coordinate model for `h_3(O)` -/

/--
The six independent coordinates of a Hermitian 3×3 octonionic matrix.

This represents the displayed matrix

```text
[[alpha, z, conj y],
 [conj z, beta, x],
 [y, conj x, gamma]]
```
-/
@[ext]
structure H3O where
  /-- The (1,1) diagonal entry. -/
  alpha : ℝ
  /-- The (2,2) diagonal entry. -/
  beta : ℝ
  /-- The (3,3) diagonal entry. -/
  gamma : ℝ
  /-- The (2,3) off-diagonal entry. -/
  x : Octonion
  /-- The (3,1) off-diagonal entry. -/
  y : Octonion
  /-- The (1,2) off-diagonal entry. -/
  z : Octonion
  deriving Inhabited

/-! ### Algebraic operations -/

/-- The zero element of `h_3(O)`. -/
instance : Zero H3O where
  zero := { alpha := 0, beta := 0, gamma := 0, x := 0, y := 0, z := 0 }

/-- Coordinatewise addition on `h_3(O)`. -/
instance : Add H3O where
  add a b :=
    { alpha := a.alpha + b.alpha
      beta := a.beta + b.beta
      gamma := a.gamma + b.gamma
      x := a.x + b.x
      y := a.y + b.y
      z := a.z + b.z }

/-- Coordinatewise negation on `h_3(O)`. -/
instance : Neg H3O where
  neg a :=
    { alpha := -a.alpha
      beta := -a.beta
      gamma := -a.gamma
      x := -a.x
      y := -a.y
      z := -a.z }

/-- Coordinatewise subtraction on `h_3(O)`. -/
instance : Sub H3O where
  sub a b := a + -b

/-- Real scalar multiplication on `h_3(O)`. -/
instance : SMul ℝ H3O where
  smul r a :=
    { alpha := r * a.alpha
      beta := r * a.beta
      gamma := r * a.gamma
      x := r • a.x
      y := r • a.y
      z := r • a.z }

/-! ### Simp lemmas for H3O operations -/

@[simp] theorem H3O.zero_alpha : (0 : H3O).alpha = 0 := rfl
@[simp] theorem H3O.zero_beta : (0 : H3O).beta = 0 := rfl
@[simp] theorem H3O.zero_gamma : (0 : H3O).gamma = 0 := rfl
@[simp] theorem H3O.zero_x : (0 : H3O).x = 0 := rfl
@[simp] theorem H3O.zero_y : (0 : H3O).y = 0 := rfl
@[simp] theorem H3O.zero_z : (0 : H3O).z = 0 := rfl

@[simp] theorem H3O.add_alpha (a b : H3O) :
    (a + b).alpha = a.alpha + b.alpha := rfl
@[simp] theorem H3O.add_beta (a b : H3O) :
    (a + b).beta = a.beta + b.beta := rfl
@[simp] theorem H3O.add_gamma (a b : H3O) :
    (a + b).gamma = a.gamma + b.gamma := rfl
@[simp] theorem H3O.add_x (a b : H3O) :
    (a + b).x = a.x + b.x := rfl
@[simp] theorem H3O.add_y (a b : H3O) :
    (a + b).y = a.y + b.y := rfl
@[simp] theorem H3O.add_z (a b : H3O) :
    (a + b).z = a.z + b.z := rfl

@[simp] theorem H3O.neg_alpha (a : H3O) :
    (-a).alpha = -a.alpha := rfl
@[simp] theorem H3O.neg_beta (a : H3O) :
    (-a).beta = -a.beta := rfl
@[simp] theorem H3O.neg_gamma (a : H3O) :
    (-a).gamma = -a.gamma := rfl
@[simp] theorem H3O.neg_x (a : H3O) :
    (-a).x = -a.x := rfl
@[simp] theorem H3O.neg_y (a : H3O) :
    (-a).y = -a.y := rfl
@[simp] theorem H3O.neg_z (a : H3O) :
    (-a).z = -a.z := rfl

@[simp] theorem H3O.smul_alpha (r : ℝ) (a : H3O) :
    (r • a).alpha = r * a.alpha := rfl
@[simp] theorem H3O.smul_beta (r : ℝ) (a : H3O) :
    (r • a).beta = r * a.beta := rfl
@[simp] theorem H3O.smul_gamma (r : ℝ) (a : H3O) :
    (r • a).gamma = r * a.gamma := rfl
@[simp] theorem H3O.smul_x (r : ℝ) (a : H3O) :
    (r • a).x = r • a.x := rfl
@[simp] theorem H3O.smul_y (r : ℝ) (a : H3O) :
    (r • a).y = r • a.y := rfl
@[simp] theorem H3O.smul_z (r : ℝ) (a : H3O) :
    (r • a).z = r • a.z := rfl

/-! ## Octonion real inner product -/

/--
The real inner product on octonions.

This is the standard Euclidean inner product on the eight real coordinates.
It equals `Re(conj(a) * b) = Re(a * conj(b))`.
-/
def octonionInner (a b : Octonion) : ℝ :=
  a.c0 * b.c0 + a.c1 * b.c1 + a.c2 * b.c2 + a.c3 * b.c3 +
  a.c4 * b.c4 + a.c5 * b.c5 + a.c6 * b.c6 + a.c7 * b.c7

@[simp]
theorem octonionInner_zero_left (b : Octonion) :
    octonionInner 0 b = 0 := by
  simp [octonionInner]

@[simp]
theorem octonionInner_zero_right (a : Octonion) :
    octonionInner a 0 = 0 := by
  simp [octonionInner]

/-- The octonion inner product is symmetric. -/
theorem octonionInner_comm (a b : Octonion) :
    octonionInner a b = octonionInner b a := by
  simp [octonionInner]; ring

/-- The inner product equals the `c0` component of `conj a * b`. -/
theorem octonionInner_eq_conj_mul_c0 (a b : Octonion) :
    octonionInner a b = (conj a * b).c0 := by
  simp [octonionInner, conj]

/-! ## Trace -/

/--
The trace of a Hermitian 3×3 octonionic matrix.

Only the three real diagonal entries contribute.
-/
def trace (a : H3O) : ℝ :=
  a.alpha + a.beta + a.gamma

@[simp]
theorem trace_zero : trace (0 : H3O) = 0 := by
  simp [trace]

theorem trace_add (a b : H3O) :
    trace (a + b) = trace a + trace b := by
  simp [trace]; ring

theorem trace_neg (a : H3O) : trace (-a) = -trace a := by
  simp [trace]; ring

theorem trace_smul (r : ℝ) (a : H3O) :
    trace (r • a) = r * trace a := by
  simp [trace]; ring

/-! ## The unit element -/

/--
The unit of `h_3(O)`: the diagonal matrix `diag(1, 1, 1)`.
-/
def oneH3O : H3O :=
  { alpha := 1, beta := 1, gamma := 1, x := 0, y := 0, z := 0 }

theorem trace_oneH3O : trace oneH3O = 3 := by
  norm_num [trace, oneH3O]

/-! ## Jordan product -/

/--
The Jordan product on `h_3(O)`.

Given two Hermitian 3×3 octonionic matrices `A` and `B`, the Jordan product
is `A ○ B = (A B + B A) / 2`, where `A B` denotes octonionic matrix
multiplication.

The explicit coordinate formula is derived from expanding the matrix products
using the Hermitian convention:

```text
M = [[α,      z,       conj(y)],
     [conj(z), β,       x      ],
     [y,       conj(x), γ      ]]
```

**Diagonal entries** reduce to sums of real-real products and octonion inner
products, because `a * conj(b) + b * conj(a) = 2 * octonionInner a b`.

**Off-diagonal entries** are averages of the sum of the two matrix products,
combining real scalar multiples of input entries with non-associative
cross terms.
-/
noncomputable def jordanProduct (a b : H3O) : H3O where
  alpha := a.alpha * b.alpha +
    octonionInner a.z b.z + octonionInner a.y b.y
  beta := octonionInner a.z b.z +
    a.beta * b.beta + octonionInner a.x b.x
  gamma := octonionInner a.y b.y +
    octonionInner a.x b.x + a.gamma * b.gamma
  x := (1/2 : ℝ) • ((b.beta + b.gamma) • a.x +
    (a.beta + a.gamma) • b.x +
    conj a.z * conj b.y + conj b.z * conj a.y)
  y := (1/2 : ℝ) • ((b.alpha + b.gamma) • a.y +
    (a.alpha + a.gamma) • b.y +
    conj a.x * conj b.z + conj b.x * conj a.z)
  z := (1/2 : ℝ) • ((a.alpha + a.beta) • b.z +
    (b.alpha + b.beta) • a.z +
    conj a.y * conj b.x + conj b.y * conj a.x)

local infixl:70 " ○ " => jordanProduct

/-- A Jordan projection: an idempotent `p ○ p = p`. -/
def IsProjection (p : H3O) : Prop :=
  p ○ p = p

/-! ### Basic properties of the Jordan product -/

/-- The Jordan product is commutative. -/
theorem jordanProduct_comm (a b : H3O) : a ○ b = b ○ a := by
  ext <;> simp [jordanProduct, octonionInner] <;> ring

/-- `oneH3O` is a left identity for the Jordan product. -/
theorem jordanProduct_oneH3O_left (a : H3O) :
    oneH3O ○ a = a := by
  ext <;> simp [oneH3O, jordanProduct] <;> ring

/-- `oneH3O` is a right identity for the Jordan product. -/
theorem jordanProduct_oneH3O_right (a : H3O) :
    a ○ oneH3O = a := by
  rw [jordanProduct_comm]; exact jordanProduct_oneH3O_left a

/-! ## The chosen complex line inside the project octonions -/

/--
Membership in the chosen copy of the complex numbers inside the project
octonions: `C = span_R {1, e111}`.

Equivalently, the six imaginary coordinates `c1` through `c6` all vanish.
The coordinate `c7` is the coefficient of `e111`.
-/
def InChosenComplexLine (o : Octonion) : Prop :=
  o.c1 = 0 ∧ o.c2 = 0 ∧ o.c3 = 0 ∧
  o.c4 = 0 ∧ o.c5 = 0 ∧ o.c6 = 0

theorem zero_inChosenComplexLine :
    InChosenComplexLine 0 := by
  simp [InChosenComplexLine]

theorem conj_mem_chosenComplexLine {o : Octonion}
    (ho : InChosenComplexLine o) :
    InChosenComplexLine (conj o) := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := ho
  exact ⟨by simp [conj, h1], by simp [conj, h2],
    by simp [conj, h3], by simp [conj, h4],
    by simp [conj, h5], by simp [conj, h6]⟩

theorem add_mem_chosenComplexLine {a b : Octonion}
    (ha : InChosenComplexLine a) (hb : InChosenComplexLine b) :
    InChosenComplexLine (a + b) := by
  exact ⟨by simp [ha.1, hb.1], by simp [ha.2.1, hb.2.1],
    by simp [ha.2.2.1, hb.2.2.1],
    by simp [ha.2.2.2.1, hb.2.2.2.1],
    by simp [ha.2.2.2.2.1, hb.2.2.2.2.1],
    by simp [ha.2.2.2.2.2, hb.2.2.2.2.2]⟩

theorem neg_mem_chosenComplexLine {a : Octonion}
    (ha : InChosenComplexLine a) :
    InChosenComplexLine (-a) := by
  unfold InChosenComplexLine at *; aesop

theorem smul_mem_chosenComplexLine (r : ℝ) {a : Octonion}
    (ha : InChosenComplexLine a) :
    InChosenComplexLine (r • a) := by
  exact ⟨by simp [ha.1], by simp [ha.2.1],
    by simp [ha.2.2.1], by simp [ha.2.2.2.1],
    by simp [ha.2.2.2.2.1], by simp [ha.2.2.2.2.2]⟩

/--
The chosen complex line is closed under octonion multiplication.

For `C = span_R {1, e111}`, the sub-table is `1*1 = 1`, `1*e111 = e111`,
`e111*1 = e111`, `e111*e111 = -1`. When `c1 = ... = c6 = 0` for both
inputs, each `c1`-`c6` component of the product vanishes by direct
computation from the XOR multiplication table.
-/
theorem mul_mem_chosenComplexLine {a b : Octonion}
    (ha : InChosenComplexLine a) (hb : InChosenComplexLine b) :
    InChosenComplexLine (a * b) := by
  unfold InChosenComplexLine at *
  simp +decide [*, Octonion.mul_c1, Octonion.mul_c2,
    Octonion.mul_c3, Octonion.mul_c4,
    Octonion.mul_c5, Octonion.mul_c6]

/-! ## Standard block subalgebra predicates -/

/--
The standard upper-left `h_2(O)` block inside `h_3(O)`:
matrices with `γ = 0`, `x = 0`, `y = 0`.

```text
[[α, z, 0   ],
 [z̄, β, 0   ],
 [0, 0, 0   ]]
```
-/
def InStandardA (a : H3O) : Prop :=
  a.gamma = 0 ∧ a.x = 0 ∧ a.y = 0

/--
The standard `h_3(C)` subalgebra: the full 3×3 Hermitian form with all
off-diagonal entries restricted to `C = span_R {1, e111}`.
-/
def InStandardB (a : H3O) : Prop :=
  InChosenComplexLine a.x ∧
  InChosenComplexLine a.y ∧
  InChosenComplexLine a.z

/-- The `h_2(C)` intersection: `standardA ∩ standardB`. -/
def InStandardAInterB (a : H3O) : Prop :=
  InStandardA a ∧ InStandardB a

/-! ### Membership at zero -/

theorem zero_inStandardA : InStandardA (0 : H3O) := by
  simp [InStandardA]

theorem zero_inStandardB : InStandardB (0 : H3O) :=
  ⟨zero_inChosenComplexLine, zero_inChosenComplexLine,
   zero_inChosenComplexLine⟩

theorem zero_inStandardAInterB :
    InStandardAInterB (0 : H3O) :=
  ⟨zero_inStandardA, zero_inStandardB⟩

/-! ### Closure under linear operations -/

theorem add_mem_standardA {a b : H3O}
    (ha : InStandardA a) (hb : InStandardA b) :
    InStandardA (a + b) := by
  cases ha; cases hb
  exact ⟨by erw [H3O.add_gamma]; aesop,
    by erw [H3O.add_x]; aesop,
    by erw [H3O.add_y]; aesop⟩

theorem neg_mem_standardA {a : H3O}
    (ha : InStandardA a) :
    InStandardA (-a) := by
  constructor
  · exact neg_eq_zero.mpr ha.1
  · cases ha; aesop

theorem smul_mem_standardA (r : ℝ) {a : H3O}
    (ha : InStandardA a) :
    InStandardA (r • a) := by
  unfold InStandardA; simp_all +decide
  cases ha; aesop

theorem add_mem_standardB {a b : H3O}
    (ha : InStandardB a) (hb : InStandardB b) :
    InStandardB (a + b) :=
  ⟨add_mem_chosenComplexLine ha.1 hb.1,
   add_mem_chosenComplexLine ha.2.1 hb.2.1,
   add_mem_chosenComplexLine ha.2.2 hb.2.2⟩

theorem neg_mem_standardB {a : H3O}
    (ha : InStandardB a) :
    InStandardB (-a) :=
  ⟨neg_mem_chosenComplexLine ha.1,
   neg_mem_chosenComplexLine ha.2.1,
   neg_mem_chosenComplexLine ha.2.2⟩

theorem smul_mem_standardB (r : ℝ) {a : H3O}
    (ha : InStandardB a) :
    InStandardB (r • a) :=
  ⟨by simpa using smul_mem_chosenComplexLine r ha.1,
   by simpa using smul_mem_chosenComplexLine r ha.2.1,
   by simpa using smul_mem_chosenComplexLine r ha.2.2⟩

/-! ### The standard octonionic line projection -/

/--
The identity element of the standard `h_2(O)` block: `diag(1, 1, 0)`.

Projectively, this is the octonionic line in `OP^2` corresponding to
the `h_2(O)` subalgebra.
-/
def standardOctonionicLineProjection : H3O :=
  { alpha := 1, beta := 1, gamma := 0,
    x := 0, y := 0, z := 0 }

theorem trace_standardOctonionicLineProjection :
    trace standardOctonionicLineProjection = 2 := by
  norm_num [trace, standardOctonionicLineProjection]

/-- `diag(1,1,0)` is a Jordan projection. -/
theorem standardOctonionicLineProjection_isProjection :
    IsProjection standardOctonionicLineProjection := by
  unfold IsProjection
  ext
  all_goals norm_num [jordanProduct,
    standardOctonionicLineProjection]

theorem standardOctonionicLineProjection_inStandardA :
    InStandardA standardOctonionicLineProjection := by
  simp [InStandardA, standardOctonionicLineProjection]

theorem standardOctonionicLineProjection_inStandardB :
    InStandardB standardOctonionicLineProjection :=
  ⟨zero_inChosenComplexLine, zero_inChosenComplexLine,
   zero_inChosenComplexLine⟩

/-! ### Jordan product closure for standard blocks -/

/--
The `h_2(O)` block is closed under the Jordan product.

When `γ = 0, x = 0, y = 0` for both inputs, the Jordan product formulas
for `gamma`, `x`, and `y` all reduce to zero because the inner products
and cross terms vanish.
-/
theorem jordan_mem_standardA {a b : H3O}
    (ha : InStandardA a) (hb : InStandardA b) :
    InStandardA (a ○ b) := by
  obtain ⟨ha₁, ha₂, ha₃⟩ := ha
  obtain ⟨hb₁, hb₂, hb₃⟩ := hb
  exact ⟨by unfold jordanProduct; simp +decide [*],
    by unfold jordanProduct; aesop,
    by unfold jordanProduct; aesop⟩

/--
The `h_3(C)` block is closed under the Jordan product.

All off-diagonal entries of `a ○ b` are sums of real scalar multiples and
products-of-conjugates of complex-line elements. Closure of `C` under
addition, scalar multiplication, conjugation, and multiplication ensures the
result stays in `C`.
-/
theorem jordan_mem_standardB {a b : H3O}
    (ha : InStandardB a) (hb : InStandardB b) :
    InStandardB (a ○ b) := by
  unfold InStandardB at *
  simp_all +decide [InChosenComplexLine]
  unfold jordanProduct
  simp_all +decide

end PhysicsSM.Algebra.Jordan.H3O
