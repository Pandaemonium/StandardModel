import Mathlib
import PhysicsSM.Algebra.Octonion.Conjugation
import PhysicsSM.Algebra.Octonion.Norm

/-!
# Algebra.Octonion.ComplexLine

The chosen complex line inside the project octonions and its complement.

## Mathematical context

In Baez's 2021 talk "Can We Understand the Standard Model Using Octonions?",
one chooses a unit imaginary octonion `i` and considers the copy of the complex
numbers `C = span_ℝ {1, i}` inside the octonions. This project uses the XOR
binary-label convention and chooses `i = e111` (basis element 7).

The complex line consists of octonions whose only nonzero coordinates are `c0`
(real part) and `c7` (the `e111` coefficient). The complement consists of
octonions whose `c0` and `c7` coordinates both vanish — these are the "purely
imaginary octonions orthogonal to `e111`".

## Main declarations

- `InChosenComplexLine`: predicate for membership in `span_ℝ {1, e111}`.
- `InChosenComplexComplement`: predicate for the orthogonal complement.
- Closure lemmas: the complex line is closed under addition, negation, scalar
  multiplication, conjugation, and octonion multiplication.
- `leftMul_e111_preserves_complement`: left multiplication by `e111` maps the
  complement to itself.
- `leftMul_e111_sq_neg_on_complement`: left multiplication by `e111` squares
  to `-1` on the complement, giving a complex structure.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021,
slides 14–16.
Convention: `e111` is the project XOR-basis element with index 7.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Algebra.Octonion

/-! ## The chosen imaginary unit -/

/-- The chosen unit imaginary octonion `e111` in the project XOR basis.
    This is basis element 7: all imaginary coordinates are zero except `c7 = 1`. -/
def e111 : Octonion :=
  { c0 := 0, c1 := 0, c2 := 0, c3 := 0,
    c4 := 0, c5 := 0, c6 := 0, c7 := 1 }

@[simp] theorem e111_c0 : e111.c0 = 0 := rfl
@[simp] theorem e111_c1 : e111.c1 = 0 := rfl
@[simp] theorem e111_c2 : e111.c2 = 0 := rfl
@[simp] theorem e111_c3 : e111.c3 = 0 := rfl
@[simp] theorem e111_c4 : e111.c4 = 0 := rfl
@[simp] theorem e111_c5 : e111.c5 = 0 := rfl
@[simp] theorem e111_c6 : e111.c6 = 0 := rfl
@[simp] theorem e111_c7 : e111.c7 = 1 := rfl

/-- `e111` squares to `-1`, as required for a unit imaginary octonion. -/
theorem e111_sq : e111 * e111 = -(1 : Octonion) := by
  ext <;> simp [e111]

/-- `e111` has unit norm. -/
theorem normSq_e111 : normSq e111 = 1 := by
  simp [normSq, e111]

/-! ## Membership in the chosen complex line -/

/--
Membership in the chosen copy of the complex numbers inside the project
octonions: `C = span_ℝ {1, e111}`.

An octonion lies in the chosen complex line when its coordinates `c1` through
`c6` all vanish. Equivalently, it is a real linear combination of the unit
`e000` and the chosen imaginary unit `e111`.
-/
def InChosenComplexLine (o : Octonion) : Prop :=
  o.c1 = 0 ∧ o.c2 = 0 ∧ o.c3 = 0 ∧
    o.c4 = 0 ∧ o.c5 = 0 ∧ o.c6 = 0

/-- Zero lies in the chosen complex line. -/
theorem zero_inChosenComplexLine : InChosenComplexLine 0 := by
  simp [InChosenComplexLine]

/-- One lies in the chosen complex line. -/
theorem one_inChosenComplexLine : InChosenComplexLine 1 := by
  simp [InChosenComplexLine]

/-- The chosen imaginary unit `e111` lies in the chosen complex line. -/
theorem e111_inChosenComplexLine : InChosenComplexLine e111 := by
  simp [InChosenComplexLine, e111]

/-- The chosen complex line is closed under addition. -/
theorem add_inChosenComplexLine {a b : Octonion}
    (ha : InChosenComplexLine a) (hb : InChosenComplexLine b) :
    InChosenComplexLine (a + b) := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := ha
  obtain ⟨g1, g2, g3, g4, g5, g6⟩ := hb
  exact ⟨by simp [h1, g1], by simp [h2, g2], by simp [h3, g3],
         by simp [h4, g4], by simp [h5, g5], by simp [h6, g6]⟩

/-- The chosen complex line is closed under negation. -/
theorem neg_inChosenComplexLine {a : Octonion}
    (ha : InChosenComplexLine a) :
    InChosenComplexLine (-a) := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := ha
  exact ⟨by simp [h1], by simp [h2], by simp [h3],
         by simp [h4], by simp [h5], by simp [h6]⟩

/-- The chosen complex line is closed under subtraction. -/
theorem sub_inChosenComplexLine {a b : Octonion}
    (ha : InChosenComplexLine a) (hb : InChosenComplexLine b) :
    InChosenComplexLine (a - b) := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := ha
  obtain ⟨g1, g2, g3, g4, g5, g6⟩ := hb
  exact ⟨by simp [h1, g1], by simp [h2, g2], by simp [h3, g3],
         by simp [h4, g4], by simp [h5, g5], by simp [h6, g6]⟩

/-- The chosen complex line is closed under real scalar multiplication. -/
theorem smul_inChosenComplexLine (r : ℝ) {a : Octonion}
    (ha : InChosenComplexLine a) :
    InChosenComplexLine (r • a) := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := ha
  exact ⟨by simp [h1], by simp [h2], by simp [h3],
         by simp [h4], by simp [h5], by simp [h6]⟩

/-- The chosen complex line is closed under octonion conjugation. -/
theorem conj_inChosenComplexLine {a : Octonion}
    (ha : InChosenComplexLine a) :
    InChosenComplexLine (conj a) := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := ha
  simp [InChosenComplexLine, conj, h1, h2, h3, h4, h5, h6]

/--
The chosen complex line is closed under octonion multiplication.

This is a key algebraic fact: `span_ℝ {1, e111}` forms a subalgebra of the
octonions isomorphic to ℂ. The proof expands coordinates and uses the
vanishing of `c1` through `c6` for both factors.
-/
theorem mul_inChosenComplexLine {a b : Octonion}
    (ha : InChosenComplexLine a) (hb : InChosenComplexLine b) :
    InChosenComplexLine (a * b) := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := ha
  obtain ⟨g1, g2, g3, g4, g5, g6⟩ := hb
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> simp <;>
    simp_all

/-! ## The complement of the chosen complex line -/

/--
Membership in the complement of the chosen complex line inside the octonions.

An octonion lies in the complement when its `c0` (real) and `c7` (`e111`)
coordinates both vanish. These are the purely imaginary octonions orthogonal
to the chosen `e111` direction. The complement is a 6-dimensional real
subspace spanned by `{e001, e010, e011, e100, e101, e110}`.
-/
def InChosenComplexComplement (o : Octonion) : Prop :=
  o.c0 = 0 ∧ o.c7 = 0

/-- Zero lies in the complement. -/
theorem zero_inComplement : InChosenComplexComplement 0 := by
  simp [InChosenComplexComplement]

/-- The complement is closed under addition. -/
theorem add_inComplement {a b : Octonion}
    (ha : InChosenComplexComplement a) (hb : InChosenComplexComplement b) :
    InChosenComplexComplement (a + b) := by
  obtain ⟨h0, h7⟩ := ha
  obtain ⟨g0, g7⟩ := hb
  exact ⟨by simp [h0, g0], by simp [h7, g7]⟩

/-- The complement is closed under negation. -/
theorem neg_inComplement {a : Octonion}
    (ha : InChosenComplexComplement a) :
    InChosenComplexComplement (-a) := by
  obtain ⟨h0, h7⟩ := ha
  exact ⟨by simp [h0], by simp [h7]⟩

/-- The complement is closed under real scalar multiplication. -/
theorem smul_inComplement (r : ℝ) {a : Octonion}
    (ha : InChosenComplexComplement a) :
    InChosenComplexComplement (r • a) := by
  obtain ⟨h0, h7⟩ := ha
  exact ⟨by simp [h0], by simp [h7]⟩

/-- An element in the complex line with zero real part and zero `e111`
    coefficient is zero in both the line and the complement sense. -/
theorem complexLine_inter_complement_eq_zero {a : Octonion}
    (hL : InChosenComplexLine a) (hC : InChosenComplexComplement a) :
    a = 0 := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := hL
  obtain ⟨h0, h7⟩ := hC
  ext <;> assumption

/--
Every octonion decomposes uniquely as a sum of a complex-line part and a
complement part.

The complex-line part keeps `c0` and `c7`; the complement part keeps
`c1` through `c6`.
-/
theorem complexLine_complement_decomposition (a : Octonion) :
    ∃ (l : Octonion) (c : Octonion),
      InChosenComplexLine l ∧ InChosenComplexComplement c ∧ a = l + c := by
  refine ⟨⟨a.c0, 0, 0, 0, 0, 0, 0, a.c7⟩,
          ⟨0, a.c1, a.c2, a.c3, a.c4, a.c5, a.c6, 0⟩,
          ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩,
          ⟨rfl, rfl⟩,
          ?_⟩
  ext <;> simp

/-! ## Left multiplication by `e111` on the complement -/

/--
Left multiplication by `e111` maps the complement to itself.

This is the key fact that makes `L_{e111}` a linear endomorphism of the
6-dimensional complement. Combined with the squaring-to-minus-one lemma below,
it gives a complex structure on the complement.
-/
theorem leftMul_e111_preserves_complement {a : Octonion}
    (ha : InChosenComplexComplement a) :
    InChosenComplexComplement (e111 * a) := by
  obtain ⟨h0, h7⟩ := ha
  constructor <;> simp [e111] <;> linarith [h0, h7]

/--
Left multiplication by `e111` squares to `-1` on the complement.

For any `a` in the complement (meaning `a.c0 = 0` and `a.c7 = 0`),
we have `e111 * (e111 * a) = -a`. This gives a complex structure
`J : complement → complement` with `J² = -id`, which is the foundation of the
Baez 2021 approach to identifying standard model representations.

The proof is a direct coordinate expansion.
-/
theorem leftMul_e111_sq_neg_on_complement {a : Octonion}
    (ha : InChosenComplexComplement a) :
    e111 * (e111 * a) = -a := by
  obtain ⟨h0, h7⟩ := ha
  ext <;> simp [e111, h0, h7]

/-! ## Right multiplication by `e111` -/

/--
Right multiplication by `e111` maps the complement to itself.

This is needed for the Krasnov octonionic-qubit complex structure, where
right multiplication by the chosen imaginary unit acts on `O²`.
-/
theorem rightMul_e111_preserves_complement {a : Octonion}
    (ha : InChosenComplexComplement a) :
    InChosenComplexComplement (a * e111) := by
  obtain ⟨h0, h7⟩ := ha
  constructor <;> simp [e111] <;> linarith

/--
Right multiplication by `e111` squares to `-1` on the complement.

For any `a` in the complement, `(a * e111) * e111 = -a`. By right
alternativity, this equals `a * (e111 * e111) = a * (-1) = -a`.
-/
theorem rightMul_e111_sq_neg_on_complement {a : Octonion}
    (_ha : InChosenComplexComplement a) :
    (a * e111) * e111 = -a := by
  have h := right_alternative a e111
  rw [h, e111_sq]
  ext <;> simp

/--
Right multiplication by `e111` squares to `-1` on the full octonion algebra
(using right alternativity and `e111² = -1`).
-/
theorem rightMul_e111_sq_neg (a : Octonion) :
    (a * e111) * e111 = -a := by
  ext <;> simp [e111]

/--
Left multiplication by `e111` squares to `-1` on the full octonion algebra
(using left alternativity and `e111² = -1`).
-/
theorem leftMul_e111_sq_neg (a : Octonion) :
    e111 * (e111 * a) = -a := by
  ext <;> simp [e111]

end PhysicsSM.Algebra.Octonion
