import Mathlib
import PhysicsSM.Algebra.Octonion.ComplexLine

/-!
# Algebra.Octonion.ComplexSplitting

The coordinate splitting `𝕆 = ℂ ⊕ ℂ³` behind the DVT/Yokota route.

## Mathematical context

Choosing the unit imaginary octonion `i = e111` picks out a copy of the
complex numbers `ℂ_i = span_ℝ {1, e111}` inside the octonions. The orthogonal
complement is the 6-dimensional real subspace spanned by
`{e001, e010, e011, e100, e101, e110}`.

Left multiplication by `e111` on the complement squares to `-1`
(`leftMul_e111_sq_neg_on_complement` from `ComplexLine.lean`), giving a
complex structure `J`. Under `J`, the six real coordinates pair into three
complex coordinates:

| Complex coord | Real part | Imag part | Basis pairing      |
|---------------|-----------|-----------|-------------------|
| `w₁`          | `c1`      | `c6`      | `(e001, e110)`    |
| `w₂`          | `c2`      | `c5`      | `(e010, e101)`    |
| `w₃`          | `c4`      | `c3`      | `(e100, e011)`    |

The pairing is determined by `J(eₐ) = e_b` with positive sign:
- `e111 * e001 = +e110`,  so `(e001, e110)` pair with `w₁ = c1 + i·c6`.
- `e111 * e010 = +e101`,  so `(e010, e101)` pair with `w₂ = c2 + i·c5`.
- `e111 * e100 = +e011`,  so `(e100, e011)` pair with `w₃ = c4 + i·c3`.

Note: `w₃` uses `(c4, c3)` rather than `(c3, c4)` because `e111 * e011 = -e100`
has a negative sign, while `e111 * e100 = +e011` is positive.

## Convention choices (project XOR basis)

- **Chosen imaginary unit**: `e111` (basis element 7), as in `ComplexLine.lean`.
- **Complex structure**: `J = L_{e111}` (left multiplication by `e111`).
- **Complex coordinate convention**: `wₖ = Re(wₖ) + i · Im(wₖ)` where `J`
  acts as multiplication by `i`, i.e., `J(Re) = Im` with positive sign.
- **Basis pairing order**: determined by the positive-sign condition above.

## Main declarations

### Line model
- `ChosenComplex`: a structure with `re` and `im` fields for the chosen ℂ.
- `ChosenComplex.toOctonion`, `Octonion.toChosenComplex`: round-trip maps.

### Complement model
- `ComplexTriple`: a structure with three complex coordinates `w₁, w₂, w₃`
  for the 6-dimensional complement.
- `ComplexTriple.toOctonion`, `Octonion.toComplexTriple`: round-trip maps.

### Decomposition
- `octonion_decomp`: every octonion equals its line part plus complement part.
- `octonion_decomp_unique`: the decomposition is unique (direct sum).

### Multiplication tables
- `e111_mul_basis_*`: the six products `e111 * eₖ` on complement basis elements.

### Complex structure
- `J_acts_as_i_on_w₁`, `J_acts_as_i_on_w₂`, `J_acts_as_i_on_w₃`:
  `J` acts as multiplication by `i` on each complex coordinate.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021,
slides 14–16; Dubois-Violette and Todorov (2018).
Convention: project XOR basis from `PhysicsSM.Algebra.Octonion.Basic`.

Status: trusted — no `s o r r y`.
-/

namespace PhysicsSM.Algebra.Octonion

/-! ## The chosen complex line: coordinate model -/

/-- A point in the chosen copy of ℂ inside the octonions.
    `re` is the coefficient of `e000` (the real unit) and
    `im` is the coefficient of `e111` (the chosen imaginary unit). -/
@[ext]
structure ChosenComplex where
  re : ℝ
  im : ℝ
  deriving Inhabited

instance : Zero ChosenComplex := ⟨⟨0, 0⟩⟩
instance : Add ChosenComplex := ⟨fun a b => ⟨a.re + b.re, a.im + b.im⟩⟩
instance : Neg ChosenComplex := ⟨fun a => ⟨-a.re, -a.im⟩⟩
instance : SMul ℝ ChosenComplex := ⟨fun r a => ⟨r * a.re, r * a.im⟩⟩

/-- Embed a `ChosenComplex` value into the octonions.
    The result has `c0 = re`, `c7 = im`, and all other coordinates zero. -/
def ChosenComplex.toOctonion (z : ChosenComplex) : Octonion :=
  ⟨z.re, 0, 0, 0, 0, 0, 0, z.im⟩

/-- Project an octonion onto the chosen complex line by keeping `c0` and `c7`. -/
def Octonion.toChosenComplex (o : Octonion) : ChosenComplex :=
  ⟨o.c0, o.c7⟩

@[simp] theorem ChosenComplex.toOctonion_c0 (z : ChosenComplex) :
    z.toOctonion.c0 = z.re := rfl
@[simp] theorem ChosenComplex.toOctonion_c1 (z : ChosenComplex) :
    z.toOctonion.c1 = 0 := rfl
@[simp] theorem ChosenComplex.toOctonion_c2 (z : ChosenComplex) :
    z.toOctonion.c2 = 0 := rfl
@[simp] theorem ChosenComplex.toOctonion_c3 (z : ChosenComplex) :
    z.toOctonion.c3 = 0 := rfl
@[simp] theorem ChosenComplex.toOctonion_c4 (z : ChosenComplex) :
    z.toOctonion.c4 = 0 := rfl
@[simp] theorem ChosenComplex.toOctonion_c5 (z : ChosenComplex) :
    z.toOctonion.c5 = 0 := rfl
@[simp] theorem ChosenComplex.toOctonion_c6 (z : ChosenComplex) :
    z.toOctonion.c6 = 0 := rfl
@[simp] theorem ChosenComplex.toOctonion_c7 (z : ChosenComplex) :
    z.toOctonion.c7 = z.im := rfl

@[simp] theorem Octonion.toChosenComplex_re (o : Octonion) :
    o.toChosenComplex.re = o.c0 := rfl
@[simp] theorem Octonion.toChosenComplex_im (o : Octonion) :
    o.toChosenComplex.im = o.c7 := rfl

/-- Round-trip: projecting the embedding recovers the original complex number. -/
theorem ChosenComplex.roundtrip (z : ChosenComplex) :
    z.toOctonion.toChosenComplex = z := by
  ext <;> rfl

/-- The embedding lands in the chosen complex line. -/
theorem ChosenComplex.toOctonion_inLine (z : ChosenComplex) :
    InChosenComplexLine z.toOctonion := by
  exact ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩

/-! ## The complement: three-complex-coordinate model -/

/-- A point in the complement `ℂ_⊥ ≅ ℂ³`, expressed as three complex
    coordinates `(w₁, w₂, w₃)`.

    The convention is determined by the requirement that left multiplication
    by `e111` acts as multiplication by `i` on each coordinate:

    - `w₁ = c1 + i·c6`  (basis pair `e001, e110`)
    - `w₂ = c2 + i·c5`  (basis pair `e010, e101`)
    - `w₃ = c4 + i·c3`  (basis pair `e100, e011`)

    The real and imaginary parts of each `wₖ` are stored separately as
    `wₖ_re` and `wₖ_im`. -/
@[ext]
structure ComplexTriple where
  w1_re : ℝ   -- coefficient of e001 (c1)
  w1_im : ℝ   -- coefficient of e110 (c6)
  w2_re : ℝ   -- coefficient of e010 (c2)
  w2_im : ℝ   -- coefficient of e101 (c5)
  w3_re : ℝ   -- coefficient of e100 (c4)
  w3_im : ℝ   -- coefficient of e011 (c3)
  deriving Inhabited

instance : Zero ComplexTriple := ⟨⟨0, 0, 0, 0, 0, 0⟩⟩
instance : Add ComplexTriple :=
  ⟨fun a b => ⟨a.w1_re + b.w1_re, a.w1_im + b.w1_im,
               a.w2_re + b.w2_re, a.w2_im + b.w2_im,
               a.w3_re + b.w3_re, a.w3_im + b.w3_im⟩⟩
instance : Neg ComplexTriple :=
  ⟨fun a => ⟨-a.w1_re, -a.w1_im, -a.w2_re, -a.w2_im, -a.w3_re, -a.w3_im⟩⟩
instance : SMul ℝ ComplexTriple :=
  ⟨fun r a => ⟨r * a.w1_re, r * a.w1_im, r * a.w2_re, r * a.w2_im,
               r * a.w3_re, r * a.w3_im⟩⟩

/-- Embed a `ComplexTriple` into the octonions as a complement element.
    The mapping is:
    - `c1 = w₁_re`, `c6 = w₁_im`
    - `c2 = w₂_re`, `c5 = w₂_im`
    - `c3 = w₃_im`, `c4 = w₃_re`   ← note `c3` is the imaginary part of `w₃`
    - `c0 = 0`, `c7 = 0` -/
def ComplexTriple.toOctonion (w : ComplexTriple) : Octonion :=
  ⟨0, w.w1_re, w.w2_re, w.w3_im, w.w3_re, w.w2_im, w.w1_im, 0⟩

/-- Project an octonion onto the complement by extracting the six complement
    coordinates into complex-triple form. -/
def Octonion.toComplexTriple (o : Octonion) : ComplexTriple :=
  ⟨o.c1, o.c6, o.c2, o.c5, o.c4, o.c3⟩

@[simp] theorem ComplexTriple.toOctonion_c0 (w : ComplexTriple) :
    w.toOctonion.c0 = 0 := rfl
@[simp] theorem ComplexTriple.toOctonion_c1 (w : ComplexTriple) :
    w.toOctonion.c1 = w.w1_re := rfl
@[simp] theorem ComplexTriple.toOctonion_c2 (w : ComplexTriple) :
    w.toOctonion.c2 = w.w2_re := rfl
@[simp] theorem ComplexTriple.toOctonion_c3 (w : ComplexTriple) :
    w.toOctonion.c3 = w.w3_im := rfl
@[simp] theorem ComplexTriple.toOctonion_c4 (w : ComplexTriple) :
    w.toOctonion.c4 = w.w3_re := rfl
@[simp] theorem ComplexTriple.toOctonion_c5 (w : ComplexTriple) :
    w.toOctonion.c5 = w.w2_im := rfl
@[simp] theorem ComplexTriple.toOctonion_c6 (w : ComplexTriple) :
    w.toOctonion.c6 = w.w1_im := rfl
@[simp] theorem ComplexTriple.toOctonion_c7 (w : ComplexTriple) :
    w.toOctonion.c7 = 0 := rfl

@[simp] theorem Octonion.toComplexTriple_w1_re (o : Octonion) :
    o.toComplexTriple.w1_re = o.c1 := rfl
@[simp] theorem Octonion.toComplexTriple_w1_im (o : Octonion) :
    o.toComplexTriple.w1_im = o.c6 := rfl
@[simp] theorem Octonion.toComplexTriple_w2_re (o : Octonion) :
    o.toComplexTriple.w2_re = o.c2 := rfl
@[simp] theorem Octonion.toComplexTriple_w2_im (o : Octonion) :
    o.toComplexTriple.w2_im = o.c5 := rfl
@[simp] theorem Octonion.toComplexTriple_w3_re (o : Octonion) :
    o.toComplexTriple.w3_re = o.c4 := rfl
@[simp] theorem Octonion.toComplexTriple_w3_im (o : Octonion) :
    o.toComplexTriple.w3_im = o.c3 := rfl

/-- Round-trip: projecting the complement embedding recovers the triple. -/
theorem ComplexTriple.roundtrip (w : ComplexTriple) :
    w.toOctonion.toComplexTriple = w := by
  ext <;> rfl

/-- The embedding of a `ComplexTriple` lands in the chosen complex complement. -/
theorem ComplexTriple.toOctonion_inComplement (w : ComplexTriple) :
    InChosenComplexComplement w.toOctonion := by
  exact ⟨rfl, rfl⟩

/-! ## Decomposition: 𝕆 = ℂ ⊕ ℂ³ -/

/-- Every octonion decomposes as its complex-line projection plus its
    complement projection. This is the explicit coordinate form of the
    direct sum `𝕆 = ℂ_i ⊕ ℂ_⊥`. -/
theorem octonion_decomp (a : Octonion) :
    a = (a.toChosenComplex.toOctonion) + (a.toComplexTriple.toOctonion) := by
  ext <;> simp [ChosenComplex.toOctonion, ComplexTriple.toOctonion,
    Octonion.toChosenComplex, Octonion.toComplexTriple]

/-- The decomposition is direct: if the line part plus complement part is zero,
    then both parts are zero. -/
theorem octonion_decomp_unique_zero
    (z : ChosenComplex) (w : ComplexTriple)
    (h : z.toOctonion + w.toOctonion = 0) :
    z = 0 ∧ w = 0 := by
  have h0 : (z.toOctonion + w.toOctonion).c0 = 0 := by rw [h]; rfl
  have h1 : (z.toOctonion + w.toOctonion).c1 = 0 := by rw [h]; rfl
  have h2 : (z.toOctonion + w.toOctonion).c2 = 0 := by rw [h]; rfl
  have h3 : (z.toOctonion + w.toOctonion).c3 = 0 := by rw [h]; rfl
  have h4 : (z.toOctonion + w.toOctonion).c4 = 0 := by rw [h]; rfl
  have h5 : (z.toOctonion + w.toOctonion).c5 = 0 := by rw [h]; rfl
  have h6 : (z.toOctonion + w.toOctonion).c6 = 0 := by rw [h]; rfl
  have h7 : (z.toOctonion + w.toOctonion).c7 = 0 := by rw [h]; rfl
  simp at h0 h1 h2 h3 h4 h5 h6 h7
  exact ⟨by ext <;> assumption, by ext <;> assumption⟩

/-- The decomposition is unique: if two decompositions of the same octonion
    agree, then the line parts and complement parts agree individually. -/
theorem octonion_decomp_unique
    (z₁ z₂ : ChosenComplex) (w₁ w₂ : ComplexTriple)
    (h : z₁.toOctonion + w₁.toOctonion = z₂.toOctonion + w₂.toOctonion) :
    z₁ = z₂ ∧ w₁ = w₂ := by
  have hc0 := congrArg Octonion.c0 h
  have hc1 := congrArg Octonion.c1 h
  have hc2 := congrArg Octonion.c2 h
  have hc3 := congrArg Octonion.c3 h
  have hc4 := congrArg Octonion.c4 h
  have hc5 := congrArg Octonion.c5 h
  have hc6 := congrArg Octonion.c6 h
  have hc7 := congrArg Octonion.c7 h
  simp only [ChosenComplex.toOctonion, ComplexTriple.toOctonion,
    Octonion.add_c0, Octonion.add_c1, Octonion.add_c2, Octonion.add_c3,
    Octonion.add_c4, Octonion.add_c5, Octonion.add_c6, Octonion.add_c7,
    Octonion.zero_c0, Octonion.zero_c1, Octonion.zero_c2, Octonion.zero_c3,
    Octonion.zero_c4, Octonion.zero_c5, Octonion.zero_c6, Octonion.zero_c7,
    add_zero, zero_add] at *
  exact ⟨by ext <;> linarith, by ext <;> linarith⟩

/-! ## Multiplication tables: `e111 * eₖ` on complement basis elements

The following six lemmas record the action of left multiplication by
`e111` on each complement basis element. The results pair the six
basis elements into three complex pairs.

Convention: all products use the project XOR-basis Fano multiplication
table from `Basic.lean`.
-/

/-- `e111 * e001 = +e110`: basis element 1 maps to basis element 6. -/
theorem e111_mul_e001 :
    e111 * (⟨0, 1, 0, 0, 0, 0, 0, 0⟩ : Octonion) = ⟨0, 0, 0, 0, 0, 0, 1, 0⟩ := by
  ext <;> simp [e111]

/-- `e111 * e010 = +e101`: basis element 2 maps to basis element 5. -/
theorem e111_mul_e010 :
    e111 * (⟨0, 0, 1, 0, 0, 0, 0, 0⟩ : Octonion) = ⟨0, 0, 0, 0, 0, 1, 0, 0⟩ := by
  ext <;> simp [e111]

/-- `e111 * e011 = -e100`: basis element 3 maps to minus basis element 4. -/
theorem e111_mul_e011 :
    e111 * (⟨0, 0, 0, 1, 0, 0, 0, 0⟩ : Octonion) = ⟨0, 0, 0, 0, -1, 0, 0, 0⟩ := by
  ext <;> simp [e111]

/-- `e111 * e100 = +e011`: basis element 4 maps to basis element 3. -/
theorem e111_mul_e100 :
    e111 * (⟨0, 0, 0, 0, 1, 0, 0, 0⟩ : Octonion) = ⟨0, 0, 0, 1, 0, 0, 0, 0⟩ := by
  ext <;> simp [e111]

/-- `e111 * e101 = -e010`: basis element 5 maps to minus basis element 2. -/
theorem e111_mul_e101 :
    e111 * (⟨0, 0, 0, 0, 0, 1, 0, 0⟩ : Octonion) = ⟨0, 0, -1, 0, 0, 0, 0, 0⟩ := by
  ext <;> simp [e111]

/-- `e111 * e110 = -e001`: basis element 6 maps to minus basis element 1. -/
theorem e111_mul_e110 :
    e111 * (⟨0, 0, 0, 0, 0, 0, 1, 0⟩ : Octonion) = ⟨0, -1, 0, 0, 0, 0, 0, 0⟩ := by
  ext <;> simp [e111]

/-! ## Complex structure: J acts as multiplication by i

The complex structure `J = L_{e111}` acts on the complement. In the
`ComplexTriple` coordinates `(w₁, w₂, w₃)`, `J` acts as multiplication
by `i` on each coordinate: `J(wₖ) = i · wₖ`, i.e.,
`(Re, Im) ↦ (-Im, Re)`.

This is the key property that identifies the complement as a complex
3-dimensional vector space `ℂ³`.
-/

/-- Apply the complex structure `J = L_{e111}` to a complement element
    and read off the result in `ComplexTriple` coordinates. -/
theorem J_on_complement_coords (w : ComplexTriple) :
    (e111 * w.toOctonion).toComplexTriple =
      ⟨-w.w1_im, w.w1_re, -w.w2_im, w.w2_re, -w.w3_im, w.w3_re⟩ := by
  ext <;> simp [e111, ComplexTriple.toOctonion, Octonion.toComplexTriple]

/-- `J` acts as multiplication by `i` on `w₁`:
    `J` maps `(w₁_re, w₁_im) ↦ (-w₁_im, w₁_re)`. -/
theorem J_acts_as_i_on_w1 (w : ComplexTriple) :
    (e111 * w.toOctonion).toComplexTriple.w1_re = -w.w1_im ∧
    (e111 * w.toOctonion).toComplexTriple.w1_im = w.w1_re := by
  simp [e111, ComplexTriple.toOctonion, Octonion.toComplexTriple]

/-- `J` acts as multiplication by `i` on `w₂`:
    `J` maps `(w₂_re, w₂_im) ↦ (-w₂_im, w₂_re)`. -/
theorem J_acts_as_i_on_w2 (w : ComplexTriple) :
    (e111 * w.toOctonion).toComplexTriple.w2_re = -w.w2_im ∧
    (e111 * w.toOctonion).toComplexTriple.w2_im = w.w2_re := by
  simp [e111, ComplexTriple.toOctonion, Octonion.toComplexTriple]

/-- `J` acts as multiplication by `i` on `w₃`:
    `J` maps `(w₃_re, w₃_im) ↦ (-w₃_im, w₃_re)`. -/
theorem J_acts_as_i_on_w3 (w : ComplexTriple) :
    (e111 * w.toOctonion).toComplexTriple.w3_re = -w.w3_im ∧
    (e111 * w.toOctonion).toComplexTriple.w3_im = w.w3_re := by
  simp [e111, ComplexTriple.toOctonion, Octonion.toComplexTriple]

/-- `J² = -id` on the complement, stated in `ComplexTriple` coordinates.

    For any complement element `w`, applying `J` twice gives `-w`.
    This is the complement-coordinate form of `leftMul_e111_sq_neg_on_complement`. -/
theorem J_sq_neg_on_complement (w : ComplexTriple) :
    (e111 * (e111 * w.toOctonion)).toComplexTriple =
      ⟨-w.w1_re, -w.w1_im, -w.w2_re, -w.w2_im, -w.w3_re, -w.w3_im⟩ := by
  ext <;> simp [e111, ComplexTriple.toOctonion, Octonion.toComplexTriple]

/-- `J` preserves the complement: if `w` is a complement element, so is `J(w)`.
    This follows from `leftMul_e111_preserves_complement`. -/
theorem J_preserves_complement (w : ComplexTriple) :
    InChosenComplexComplement (e111 * w.toOctonion) := by
  exact leftMul_e111_preserves_complement w.toOctonion_inComplement

/-! ## Compatibility with InChosenComplexLine and InChosenComplexComplement -/

/-- The `ChosenComplex.toOctonion` embedding is compatible with the
    `InChosenComplexLine` predicate from `ComplexLine.lean`. -/
theorem ChosenComplex.toOctonion_line (z : ChosenComplex) :
    InChosenComplexLine z.toOctonion :=
  z.toOctonion_inLine

/-- The `ComplexTriple.toOctonion` embedding is compatible with the
    `InChosenComplexComplement` predicate from `ComplexLine.lean`. -/
theorem ComplexTriple.toOctonion_complement (w : ComplexTriple) :
    InChosenComplexComplement w.toOctonion :=
  w.toOctonion_inComplement

/-- Recovering an octonion from its two projections gives back the original. -/
theorem octonion_from_projections (a : Octonion) :
    a.toChosenComplex.toOctonion + a.toComplexTriple.toOctonion = a := by
  ext <;> simp [ChosenComplex.toOctonion, ComplexTriple.toOctonion,
    Octonion.toChosenComplex, Octonion.toComplexTriple]

/-! ## Right multiplication by e111 on complement basis elements -/

/-- `e001 * e111 = -e110`. -/
theorem e001_mul_e111 :
    (⟨0, 1, 0, 0, 0, 0, 0, 0⟩ : Octonion) * e111 = ⟨0, 0, 0, 0, 0, 0, -1, 0⟩ := by
  ext <;> simp [e111]

/-- `e010 * e111 = -e101`. -/
theorem e010_mul_e111 :
    (⟨0, 0, 1, 0, 0, 0, 0, 0⟩ : Octonion) * e111 = ⟨0, 0, 0, 0, 0, -1, 0, 0⟩ := by
  ext <;> simp [e111]

/-- `e011 * e111 = +e100`. -/
theorem e011_mul_e111 :
    (⟨0, 0, 0, 1, 0, 0, 0, 0⟩ : Octonion) * e111 = ⟨0, 0, 0, 0, 1, 0, 0, 0⟩ := by
  ext <;> simp [e111]

/-- `e100 * e111 = -e011`. -/
theorem e100_mul_e111 :
    (⟨0, 0, 0, 0, 1, 0, 0, 0⟩ : Octonion) * e111 = ⟨0, 0, 0, -1, 0, 0, 0, 0⟩ := by
  ext <;> simp [e111]

/-- `e101 * e111 = +e010`. -/
theorem e101_mul_e111 :
    (⟨0, 0, 0, 0, 0, 1, 0, 0⟩ : Octonion) * e111 = ⟨0, 0, 1, 0, 0, 0, 0, 0⟩ := by
  ext <;> simp [e111]

/-- `e110 * e111 = +e001`. -/
theorem e110_mul_e111 :
    (⟨0, 0, 0, 0, 0, 0, 1, 0⟩ : Octonion) * e111 = ⟨0, 1, 0, 0, 0, 0, 0, 0⟩ := by
  ext <;> simp [e111]

/-! ## Summary of basis pairings

The multiplication tables above show the following pairing structure:

**Left multiplication by `e111`** (`J = L_{e111}`):
- `e001 ↦ +e110`,   `e110 ↦ -e001`   → complex pair `w₁ = c1 + i·c6`
- `e010 ↦ +e101`,   `e101 ↦ -e010`   → complex pair `w₂ = c2 + i·c5`
- `e100 ↦ +e011`,   `e011 ↦ -e100`   → complex pair `w₃ = c4 + i·c3`

**Right multiplication by `e111`** (`R_{e111}`):
- `e001 ↦ -e110`,   `e110 ↦ +e001`   → opposite sign to left mult
- `e010 ↦ -e101`,   `e101 ↦ +e010`   → opposite sign to left mult
- `e100 ↦ -e011`,   `e011 ↦ +e100`   → opposite sign to left mult

This sign difference between `L_{e111}` and `R_{e111}` on the complement
reflects the non-commutativity of octonion multiplication. In particular,
`R_{e111}` defines the *conjugate* complex structure `J' = -J` on the
complement.
-/

end PhysicsSM.Algebra.Octonion
