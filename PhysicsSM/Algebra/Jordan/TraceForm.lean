import Mathlib
import PhysicsSM.Algebra.Jordan.H3O
import PhysicsSM.Algebra.Octonion.ComplexSplitting
import PhysicsSM.Algebra.Octonion.Norm

/-!
# Algebra.Jordan.TraceForm

The trace bilinear form on `h₃(𝕆)` and the coordinate splitting into
`h₃(ℂ)` plus its orthogonal complement.

## Mathematical context

The **trace form** on the Albert algebra is `T(A, B) = tr(A ○ B)`, where
`○` is the Jordan product and `tr` is the sum of diagonal entries. This is
a symmetric, real-valued bilinear form.

Under the chosen complex line `ℂ = span_ℝ{1, e111}`, the Albert algebra
splits as a direct sum of real vector spaces:

  `h₃(𝕆) = h₃(ℂ) ⊕ h₃(ℂ)⊥`

where:
- `h₃(ℂ)` consists of Hermitian 3×3 matrices with off-diagonal entries in `ℂ`
  (the `InStandardB` predicate).
- `h₃(ℂ)⊥` consists of matrices with zero diagonal and off-diagonal entries
  in the complement `ℂ⊥ = span_ℝ{e001, e010, e011, e100, e101, e110}`.

The two summands are orthogonal with respect to the trace form.

## Main declarations

- `H3O.traceForm` — the symmetric bilinear form `T(A,B) = tr(A ○ B)`.
- `traceForm_symm` — symmetry of the trace form.
- `traceForm_add_left`, `traceForm_add_right` — bilinearity.
- `traceForm_smul_left`, `traceForm_smul_right` — scalar compatibility.
- `InComplementOfB` — the complement predicate: zero diagonal plus off-diagonal
  entries in `ℂ⊥`.
- `H3O.toH3CPart` — projection onto the `h₃(ℂ)` summand.
- `H3O.toComplementPart` — projection onto the complement.
- `H3O.decomp_sum` — `a = toH3CPart a + toComplementPart a`.
- `toH3CPart_inStandardB` — the projection lands in `h₃(ℂ)`.
- `toComplementPart_inComplementOfB` — the projection lands in the complement.
- `standardB_inter_complementOfB_eq_zero` — directness of the splitting.
- `octonionInner_complexLine_complement` — orthogonality of `ℂ` and `ℂ⊥` entries.
- `traceForm_orthogonal` — trace-form orthogonality of the two summands.

Source: Dubois-Violette and Todorov, "Exceptional quantum geometry and particle
physics II" (2019); Yokota, "Exceptional Lie Groups" (2009), Chapter 3.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

open PhysicsSM.Algebra.Octonion

local infixl:70 " ○ " => jordanProduct

/-! ## Trace bilinear form -/

/--
The trace bilinear form on `h₃(𝕆)`: `T(A, B) = tr(A ○ B)`.

Expanding the Jordan product formula and taking the trace gives:
```
T(A,B) = α_A α_B + β_A β_B + γ_A γ_B
       + 2 ⟨x_A, x_B⟩ + 2 ⟨y_A, y_B⟩ + 2 ⟨z_A, z_B⟩
```
where `⟨·,·⟩` is the octonion inner product.
-/
noncomputable def traceForm (a b : H3O) : ℝ :=
  trace (a ○ b)

/-- Unfolded formula for the trace form. -/
theorem traceForm_eq (a b : H3O) :
    traceForm a b =
      a.alpha * b.alpha + a.beta * b.beta + a.gamma * b.gamma +
      2 * octonionInner a.x b.x +
      2 * octonionInner a.y b.y +
      2 * octonionInner a.z b.z := by
  simp [traceForm, trace, jordanProduct, octonionInner]
  ring

/-- The trace form is symmetric. -/
theorem traceForm_symm (a b : H3O) :
    traceForm a b = traceForm b a := by
  simp [traceForm_eq, octonionInner]
  ring

/-- The trace form is additive in the first argument. -/
theorem traceForm_add_left (a₁ a₂ b : H3O) :
    traceForm (a₁ + a₂) b = traceForm a₁ b + traceForm a₂ b := by
  simp [traceForm_eq, octonionInner]
  ring

/-- The trace form is additive in the second argument. -/
theorem traceForm_add_right (a b₁ b₂ : H3O) :
    traceForm a (b₁ + b₂) = traceForm a b₁ + traceForm a b₂ := by
  simp [traceForm_eq, octonionInner]
  ring

/-- The trace form is compatible with real scalar multiplication (left). -/
theorem traceForm_smul_left (r : ℝ) (a b : H3O) :
    traceForm (r • a) b = r * traceForm a b := by
  simp [traceForm_eq, octonionInner]
  ring

/-- The trace form is compatible with real scalar multiplication (right). -/
theorem traceForm_smul_right (r : ℝ) (a b : H3O) :
    traceForm a (r • b) = r * traceForm a b := by
  simp [traceForm_eq, octonionInner]
  ring

/-- The trace form of zero (left) is zero. -/
@[simp]
theorem traceForm_zero_left (b : H3O) :
    traceForm 0 b = 0 := by
  simp [traceForm_eq, octonionInner]

/-- The trace form of zero (right) is zero. -/
@[simp]
theorem traceForm_zero_right (a : H3O) :
    traceForm a 0 = 0 := by
  simp [traceForm_eq, octonionInner]

/-- The trace form is compatible with negation (left). -/
theorem traceForm_neg_left (a b : H3O) :
    traceForm (-a) b = -traceForm a b := by
  simp [traceForm_eq, octonionInner]
  ring

/-- The trace form is compatible with negation (right). -/
theorem traceForm_neg_right (a b : H3O) :
    traceForm a (-b) = -traceForm a b := by
  simp [traceForm_eq, octonionInner]
  ring

/-! ## Complement of `h₃(ℂ)` -/

/--
The complement of `h₃(ℂ)` in `h₃(𝕆)` with respect to the trace form.

An element lies in the complement when:
- All three diagonal entries are zero: `α = β = γ = 0`.
- All three off-diagonal octonion entries lie in the complement of the
  chosen complex line, i.e., `c0 = c7 = 0` for each.

Geometrically, this is the 18-dimensional real subspace consisting of
"purely non-complex off-diagonal" matrices.
-/
def InComplementOfB (a : H3O) : Prop :=
  a.alpha = 0 ∧ a.beta = 0 ∧ a.gamma = 0 ∧
  InChosenComplexComplement a.x ∧
  InChosenComplexComplement a.y ∧
  InChosenComplexComplement a.z

theorem zero_inComplementOfB : InComplementOfB (0 : H3O) :=
  ⟨rfl, rfl, rfl,
   zero_inComplement, zero_inComplement, zero_inComplement⟩

theorem add_mem_complementOfB {a b : H3O}
    (ha : InComplementOfB a) (hb : InComplementOfB b) :
    InComplementOfB (a + b) := by
  obtain ⟨ha1, ha2, ha3, ha4, ha5, ha6⟩ := ha
  obtain ⟨hb1, hb2, hb3, hb4, hb5, hb6⟩ := hb
  exact ⟨by simp [ha1, hb1], by simp [ha2, hb2], by simp [ha3, hb3],
    add_inComplement ha4 hb4,
    add_inComplement ha5 hb5,
    add_inComplement ha6 hb6⟩

theorem neg_mem_complementOfB {a : H3O}
    (ha : InComplementOfB a) :
    InComplementOfB (-a) := by
  obtain ⟨ha1, ha2, ha3, ha4, ha5, ha6⟩ := ha
  exact ⟨by simp [ha1], by simp [ha2], by simp [ha3],
    neg_inComplement ha4,
    neg_inComplement ha5,
    neg_inComplement ha6⟩

theorem smul_mem_complementOfB (r : ℝ) {a : H3O}
    (ha : InComplementOfB a) :
    InComplementOfB (r • a) := by
  obtain ⟨ha1, ha2, ha3, ha4, ha5, ha6⟩ := ha
  exact ⟨by simp [ha1], by simp [ha2], by simp [ha3],
    smul_inComplement r ha4,
    smul_inComplement r ha5,
    smul_inComplement r ha6⟩

/-! ## Projection maps -/

/--
Projection onto the `h₃(ℂ)` summand: keep all diagonal entries and project
each off-diagonal octonion onto the chosen complex line (keeping `c0`, `c7`).
-/
def toH3CPart (a : H3O) : H3O where
  alpha := a.alpha
  beta := a.beta
  gamma := a.gamma
  x := a.x.toChosenComplex.toOctonion
  y := a.y.toChosenComplex.toOctonion
  z := a.z.toChosenComplex.toOctonion

/--
Projection onto the complement of `h₃(ℂ)`: zero out diagonal entries and
project each off-diagonal octonion onto the complement (keeping `c1`–`c6`).
-/
def toComplementPart (a : H3O) : H3O where
  alpha := 0
  beta := 0
  gamma := 0
  x := a.x.toComplexTriple.toOctonion
  y := a.y.toComplexTriple.toOctonion
  z := a.z.toComplexTriple.toOctonion

/-- Every element decomposes as its `h₃(ℂ)` part plus its complement part. -/
theorem decomp_sum (a : H3O) :
    a = toH3CPart a + toComplementPart a := by
  ext <;> simp [toH3CPart, toComplementPart,
    ChosenComplex.toOctonion, ComplexTriple.toOctonion,
    Octonion.toChosenComplex, Octonion.toComplexTriple]

/-- The `h₃(ℂ)` projection lands in `InStandardB`. -/
theorem toH3CPart_inStandardB (a : H3O) :
    InStandardB (toH3CPart a) := by
  refine ⟨?_, ?_, ?_⟩ <;>
    exact ChosenComplex.toOctonion_inLine _

/-- The complement projection lands in `InComplementOfB`. -/
theorem toComplementPart_inComplementOfB (a : H3O) :
    InComplementOfB (toComplementPart a) := by
  refine ⟨rfl, rfl, rfl, ?_, ?_, ?_⟩ <;>
    exact ComplexTriple.toOctonion_inComplement _

/-- The `h₃(ℂ)` projection is idempotent. -/
theorem toH3CPart_idempotent (a : H3O) :
    toH3CPart (toH3CPart a) = toH3CPart a := by
  ext <;> simp [toH3CPart, ChosenComplex.toOctonion,
    Octonion.toChosenComplex]

/-- The complement projection is idempotent. -/
theorem toComplementPart_idempotent (a : H3O) :
    toComplementPart (toComplementPart a) = toComplementPart a := by
  ext <;> simp [toComplementPart, ComplexTriple.toOctonion,
    Octonion.toComplexTriple]

/-- The `h₃(ℂ)` projection fixes elements already in `h₃(ℂ)`. -/
theorem toH3CPart_of_inStandardB {a : H3O} (ha : InStandardB a) :
    toH3CPart a = a := by
  obtain ⟨⟨hx1, hx2, hx3, hx4, hx5, hx6⟩,
          ⟨hy1, hy2, hy3, hy4, hy5, hy6⟩,
          ⟨hz1, hz2, hz3, hz4, hz5, hz6⟩⟩ := ha
  ext <;> simp [toH3CPart, ChosenComplex.toOctonion,
    Octonion.toChosenComplex, *]

/-- The complement projection fixes elements already in the complement. -/
theorem toComplementPart_of_inComplementOfB {a : H3O}
    (ha : InComplementOfB a) :
    toComplementPart a = a := by
  obtain ⟨hα, hβ, hγ, ⟨hx0, hx7⟩, ⟨hy0, hy7⟩, ⟨hz0, hz7⟩⟩ := ha
  ext <;> simp [toComplementPart, ComplexTriple.toOctonion,
    Octonion.toComplexTriple, *]

/-- The complement projection of an element in `h₃(ℂ)` is zero. -/
theorem toComplementPart_of_inStandardB {a : H3O}
    (ha : InStandardB a) :
    toComplementPart a = 0 := by
  obtain ⟨⟨hx1, hx2, hx3, hx4, hx5, hx6⟩,
          ⟨hy1, hy2, hy3, hy4, hy5, hy6⟩,
          ⟨hz1, hz2, hz3, hz4, hz5, hz6⟩⟩ := ha
  ext <;> simp [toComplementPart, ComplexTriple.toOctonion,
    Octonion.toComplexTriple, *]

/-- The `h₃(ℂ)` projection of an element in the complement is zero. -/
theorem toH3CPart_of_inComplementOfB {a : H3O}
    (ha : InComplementOfB a) :
    toH3CPart a = 0 := by
  obtain ⟨hα, hβ, hγ, ⟨hx0, hx7⟩, ⟨hy0, hy7⟩, ⟨hz0, hz7⟩⟩ := ha
  ext <;> simp [toH3CPart, ChosenComplex.toOctonion,
    Octonion.toChosenComplex, *]

/-! ## Directness of the splitting -/

/--
The intersection of `h₃(ℂ)` and its complement is trivial.

If an element lies in both `InStandardB` (off-diagonal in `ℂ`) and
`InComplementOfB` (zero diagonal, off-diagonal in `ℂ⊥`), then it must be zero.
-/
theorem standardB_inter_complementOfB_eq_zero {a : H3O}
    (hB : InStandardB a) (hC : InComplementOfB a) :
    a = 0 := by
  obtain ⟨hα, hβ, hγ, hxC, hyC, hzC⟩ := hC
  obtain ⟨hxB, hyB, hzB⟩ := hB
  have hx := complexLine_inter_complement_eq_zero hxB hxC
  have hy := complexLine_inter_complement_eq_zero hyB hyC
  have hz := complexLine_inter_complement_eq_zero hzB hzC
  ext <;> simp_all

/-! ## Orthogonality: `ℂ` and `ℂ⊥` entries are orthogonal under octonionInner -/

/--
The octonion inner product of a complex-line element and a complement element
is zero.

When `a` has `c1 = ... = c6 = 0` and `b` has `c0 = c7 = 0`, the eight-term
sum `∑ cᵢ(a) cᵢ(b)` collapses to `a.c0 · 0 + 0 · b.c1 + ... + a.c7 · 0 = 0`.
-/
theorem octonionInner_complexLine_complement {a b : Octonion}
    (ha : InChosenComplexLine a) (hb : InChosenComplexComplement b) :
    octonionInner a b = 0 := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := ha
  obtain ⟨h0, h7⟩ := hb
  simp [octonionInner, h0, h1, h2, h3, h4, h5, h6, h7]

/--
The symmetric version: complement then line.
-/
theorem octonionInner_complement_complexLine {a b : Octonion}
    (ha : InChosenComplexComplement a) (hb : InChosenComplexLine b) :
    octonionInner a b = 0 := by
  rw [octonionInner_comm]
  exact octonionInner_complexLine_complement hb ha

/-! ## Trace-form orthogonality -/

/--
The `h₃(ℂ)` summand and its complement are orthogonal under the trace form.

If `a ∈ h₃(ℂ)` (off-diagonal entries in the complex line) and
`b ∈ h₃(ℂ)⊥` (zero diagonal, off-diagonal entries in the complement),
then `T(a, b) = 0`.

The proof reduces to: diagonal contributions vanish because `b` has zero
diagonal, and inner product contributions vanish because `ℂ` and `ℂ⊥` are
orthogonal.
-/
theorem traceForm_orthogonal {a b : H3O}
    (ha : InStandardB a) (hb : InComplementOfB b) :
    traceForm a b = 0 := by
  obtain ⟨hbα, hbβ, hbγ, hbx, hby, hbz⟩ := hb
  obtain ⟨hax, hay, haz⟩ := ha
  rw [traceForm_eq]
  rw [octonionInner_complexLine_complement hax hbx,
      octonionInner_complexLine_complement hay hby,
      octonionInner_complexLine_complement haz hbz]
  simp [hbα, hbβ, hbγ]

/--
Symmetric version of orthogonality: complement on the left.
-/
theorem traceForm_orthogonal' {a b : H3O}
    (ha : InComplementOfB a) (hb : InStandardB b) :
    traceForm a b = 0 := by
  rw [traceForm_symm]
  exact traceForm_orthogonal hb ha

/-! ## Decomposition interacts well with the trace form -/

/--
The trace form decomposes as the sum of the `h₃(ℂ)` and complement
contributions, with the cross terms vanishing.
-/
theorem traceForm_decomp (a b : H3O) :
    traceForm a b =
      traceForm (toH3CPart a) (toH3CPart b) +
      traceForm (toComplementPart a) (toComplementPart b) := by
  conv_lhs => rw [decomp_sum a, decomp_sum b]
  rw [traceForm_add_left, traceForm_add_right, traceForm_add_right]
  have h1 := traceForm_orthogonal (toH3CPart_inStandardB a)
    (toComplementPart_inComplementOfB b)
  have h2 := traceForm_orthogonal' (toComplementPart_inComplementOfB a)
    (toH3CPart_inStandardB b)
  linarith

/-! ## Additional properties of the projections -/

/-- The projections are additive. -/
theorem toH3CPart_add (a b : H3O) :
    toH3CPart (a + b) = toH3CPart a + toH3CPart b := by
  ext <;> simp [toH3CPart, ChosenComplex.toOctonion,
    Octonion.toChosenComplex]

theorem toComplementPart_add (a b : H3O) :
    toComplementPart (a + b) = toComplementPart a + toComplementPart b := by
  ext <;> simp [toComplementPart, ComplexTriple.toOctonion,
    Octonion.toComplexTriple]

/-- The projections commute with scalar multiplication. -/
theorem toH3CPart_smul (r : ℝ) (a : H3O) :
    toH3CPart (r • a) = r • toH3CPart a := by
  ext <;> simp [toH3CPart, ChosenComplex.toOctonion,
    Octonion.toChosenComplex]

theorem toComplementPart_smul (r : ℝ) (a : H3O) :
    toComplementPart (r • a) = r • toComplementPart a := by
  ext <;> simp [toComplementPart, ComplexTriple.toOctonion,
    Octonion.toComplexTriple]

/-- The projections send zero to zero. -/
@[simp]
theorem toH3CPart_zero : toH3CPart (0 : H3O) = 0 := by
  ext <;> simp [toH3CPart, ChosenComplex.toOctonion,
    Octonion.toChosenComplex]

@[simp]
theorem toComplementPart_zero : toComplementPart (0 : H3O) = 0 := by
  ext <;> simp [toComplementPart, ComplexTriple.toOctonion,
    Octonion.toComplexTriple]

/-- The projections commute with negation. -/
theorem toH3CPart_neg (a : H3O) :
    toH3CPart (-a) = -toH3CPart a := by
  ext <;> simp [toH3CPart, ChosenComplex.toOctonion,
    Octonion.toChosenComplex]

theorem toComplementPart_neg (a : H3O) :
    toComplementPart (-a) = -toComplementPart a := by
  ext <;> simp [toComplementPart, ComplexTriple.toOctonion,
    Octonion.toComplexTriple]

/-! ## Positive definiteness of the trace form -/

/-- The octonion inner product of an element with itself equals its squared norm. -/
theorem octonionInner_self_eq_normSq (a : Octonion) :
    octonionInner a a = normSq a := by
  simp [octonionInner, normSq]
  ring

/-- The trace form self-pairing expressed as a sum of squares and norms. -/
theorem traceForm_self_eq (a : H3O) :
    traceForm a a =
      a.alpha ^ 2 + a.beta ^ 2 + a.gamma ^ 2 +
      2 * normSq a.x + 2 * normSq a.y + 2 * normSq a.z := by
  rw [traceForm_eq]
  rw [octonionInner_self_eq_normSq, octonionInner_self_eq_normSq,
      octonionInner_self_eq_normSq]
  ring

/-- The trace form self-pairing is non-negative. -/
theorem traceForm_nonneg (a : H3O) :
    0 ≤ traceForm a a := by
  rw [traceForm_self_eq]
  have hx := normSq_nonneg a.x
  have hy := normSq_nonneg a.y
  have hz := normSq_nonneg a.z
  nlinarith [sq_nonneg a.alpha, sq_nonneg a.beta, sq_nonneg a.gamma]

/-- The trace form self-pairing vanishes if and only if the element is zero. -/
theorem traceForm_eq_zero_iff (a : H3O) :
    traceForm a a = 0 ↔ a = 0 := by
  constructor
  · intro h
    rw [traceForm_self_eq] at h
    have hx := normSq_nonneg a.x
    have hy := normSq_nonneg a.y
    have hz := normSq_nonneg a.z
    have hα_sq := sq_nonneg a.alpha
    have hβ_sq := sq_nonneg a.beta
    have hγ_sq := sq_nonneg a.gamma
    have hα_zero : a.alpha ^ 2 = 0 := by nlinarith
    have hβ_zero : a.beta ^ 2 = 0 := by nlinarith
    have hγ_zero : a.gamma ^ 2 = 0 := by nlinarith
    have hx_zero : normSq a.x = 0 := by nlinarith
    have hy_zero : normSq a.y = 0 := by nlinarith
    have hz_zero : normSq a.z = 0 := by nlinarith
    have hx_coord : a.x = 0 := (normSq_eq_zero a.x).mp hx_zero
    have hy_coord : a.y = 0 := (normSq_eq_zero a.y).mp hy_zero
    have hz_coord : a.z = 0 := (normSq_eq_zero a.z).mp hz_zero
    have hα_coord : a.alpha = 0 := by nlinarith [sq_abs a.alpha]
    have hβ_coord : a.beta = 0 := by nlinarith [sq_abs a.beta]
    have hγ_coord : a.gamma = 0 := by nlinarith [sq_abs a.gamma]
    ext <;> simp_all
  · intro h
    rw [h]
    simp

/-- `traceForm a a = 0` implies `a = 0`. -/
theorem traceForm_zero_of_self_zero (a : H3O)
    (h : traceForm a a = 0) : a = 0 :=
  (traceForm_eq_zero_iff a).mp h

/-- The trace form is positive definite: `traceForm a a > 0` for `a ≠ 0`. -/
theorem traceForm_posDef (a : H3O) (ha : a ≠ 0) :
    0 < traceForm a a := by
  rcases lt_or_eq_of_le (traceForm_nonneg a) with h | h
  · exact h
  · exact False.elim (ha ((traceForm_eq_zero_iff a).mp h.symm))

end PhysicsSM.Algebra.Jordan.H3O
