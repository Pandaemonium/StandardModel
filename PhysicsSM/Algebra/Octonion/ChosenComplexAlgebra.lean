import Mathlib
import PhysicsSM.Algebra.Octonion.ComplexSplitting

/-!
# Algebra.Octonion.ChosenComplexAlgebra

The chosen complex line `ChosenComplex` as an explicit copy of the ordinary
complex numbers, with multiplication compatible with the octonion embedding.

## Mathematical context

Baez (2021) chooses a unit imaginary octonion `i = e111` and considers the
copy of the complex numbers `C = span_ℝ {1, e111}`. The module
`ComplexSplitting` already provides the type `ChosenComplex` with `re` and
`im` fields and its embedding `ChosenComplex.toOctonion`.

This module equips `ChosenComplex` with multiplication following the usual
complex-number formula `(a + ib)(c + id) = (ac - bd) + i(ad + bc)` and proves
that the embedding into the project octonions is a ring homomorphism (for
`+`, `*`, `0`, `1`, `neg`, `sub`, `smul`).

It also defines `ChosenComplex.toComplex` and `ChosenComplex.ofComplex` to
identify `ChosenComplex` with the standard Lean `ℂ`, proving round-trip and
multiplication compatibility.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021;
Baez, "The Octonions", Bull. Amer. Math. Soc. 2002.

Claim boundary: only the chosen complex line; no G₂, SU(3), or Standard
Model representation claims.

Convention: project XOR basis, chosen imaginary unit `e111`.

Status: trusted — no `s o r r y`.
-/

namespace PhysicsSM.Algebra.Octonion

/-! ## Algebra instances for ChosenComplex -/

/-- The multiplicative identity in the chosen complex line: `1 + 0·i`. -/
instance : One ChosenComplex := ⟨⟨1, 0⟩⟩

/-- Subtraction on the chosen complex line, coordinate-wise. -/
instance : Sub ChosenComplex := ⟨fun a b => ⟨a.re - b.re, a.im - b.im⟩⟩

/-- Multiplication on the chosen complex line:
    `(a + ib)(c + id) = (ac - bd) + i(ad + bc)`. -/
instance : Mul ChosenComplex := ⟨fun a b => ⟨a.re * b.re - a.im * b.im,
                                              a.re * b.im + a.im * b.re⟩⟩

/-! ## Simp lemmas for ChosenComplex operations -/

@[simp] theorem ChosenComplex.zero_re : (0 : ChosenComplex).re = 0 := rfl
@[simp] theorem ChosenComplex.zero_im : (0 : ChosenComplex).im = 0 := rfl
@[simp] theorem ChosenComplex.one_re : (1 : ChosenComplex).re = 1 := rfl
@[simp] theorem ChosenComplex.one_im : (1 : ChosenComplex).im = 0 := rfl
@[simp] theorem ChosenComplex.add_re (a b : ChosenComplex) :
    (a + b).re = a.re + b.re := rfl
@[simp] theorem ChosenComplex.add_im (a b : ChosenComplex) :
    (a + b).im = a.im + b.im := rfl
@[simp] theorem ChosenComplex.neg_re (a : ChosenComplex) :
    (-a).re = -a.re := rfl
@[simp] theorem ChosenComplex.neg_im (a : ChosenComplex) :
    (-a).im = -a.im := rfl
@[simp] theorem ChosenComplex.sub_re (a b : ChosenComplex) :
    (a - b).re = a.re - b.re := rfl
@[simp] theorem ChosenComplex.sub_im (a b : ChosenComplex) :
    (a - b).im = a.im - b.im := rfl
@[simp] theorem ChosenComplex.mul_re (a b : ChosenComplex) :
    (a * b).re = a.re * b.re - a.im * b.im := rfl
@[simp] theorem ChosenComplex.mul_im (a b : ChosenComplex) :
    (a * b).im = a.re * b.im + a.im * b.re := rfl
@[simp] theorem ChosenComplex.smul_re (r : ℝ) (a : ChosenComplex) :
    (r • a).re = r * a.re := rfl
@[simp] theorem ChosenComplex.smul_im (r : ℝ) (a : ChosenComplex) :
    (r • a).im = r * a.im := rfl

/-! ## Embedding lemmas: ChosenComplex → Octonion -/

/-- The octonion unit is the image of the ChosenComplex unit. -/
@[simp] theorem ChosenComplex.one_toOctonion :
    (1 : ChosenComplex).toOctonion = (1 : Octonion) := by
  ext <;> simp [ChosenComplex.toOctonion]

/-- Zero maps to zero. -/
@[simp] theorem ChosenComplex.toOctonion_zero :
    (0 : ChosenComplex).toOctonion = (0 : Octonion) := by
  ext <;> simp [ChosenComplex.toOctonion]

/-- The embedding preserves addition. -/
@[simp] theorem ChosenComplex.toOctonion_add (z w : ChosenComplex) :
    (z + w).toOctonion = z.toOctonion + w.toOctonion := by
  ext <;> simp [ChosenComplex.toOctonion]

/-- The embedding preserves negation. -/
@[simp] theorem ChosenComplex.toOctonion_neg (z : ChosenComplex) :
    (-z).toOctonion = -z.toOctonion := by
  ext <;> simp [ChosenComplex.toOctonion]

/-- The embedding preserves subtraction. -/
@[simp] theorem ChosenComplex.toOctonion_sub (z w : ChosenComplex) :
    (z - w).toOctonion = z.toOctonion - w.toOctonion := by
  ext <;> simp [ChosenComplex.toOctonion]

/-- The embedding preserves scalar multiplication. -/
@[simp] theorem ChosenComplex.toOctonion_smul (r : ℝ) (z : ChosenComplex) :
    (r • z).toOctonion = r • z.toOctonion := by
  ext <;> simp [ChosenComplex.toOctonion]

/-- The embedding preserves multiplication.
    This is the key compatibility lemma: complex multiplication in
    `ChosenComplex` agrees with octonionic multiplication restricted to
    the chosen complex line. -/
@[simp] theorem ChosenComplex.toOctonion_mul (z w : ChosenComplex) :
    (z * w).toOctonion = z.toOctonion * w.toOctonion := by
  ext <;> simp [ChosenComplex.toOctonion]

/-! ## Line-coordinate characterization -/

/-- If an octonion lies in the chosen complex line, projecting it to
    `ChosenComplex` and re-embedding recovers the original octonion. -/
theorem toChosenComplex_toOctonion_of_inLine
    {x : Octonion} (hx : InChosenComplexLine x) :
    x.toChosenComplex.toOctonion = x := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := hx
  ext <;> simp [ChosenComplex.toOctonion, Octonion.toChosenComplex, h1, h2, h3, h4, h5, h6]

/-! ## Maps to and from ℂ -/

/-- Convert a `ChosenComplex` value to the standard Lean `ℂ`. -/
noncomputable def ChosenComplex.toComplex (z : ChosenComplex) : ℂ :=
  ⟨z.re, z.im⟩

/-- Convert a standard Lean `ℂ` value to `ChosenComplex`. -/
noncomputable def ChosenComplex.ofComplex (z : ℂ) : ChosenComplex :=
  ⟨z.re, z.im⟩

@[simp] theorem ChosenComplex.toComplex_re (z : ChosenComplex) :
    z.toComplex.re = z.re := rfl
@[simp] theorem ChosenComplex.toComplex_im (z : ChosenComplex) :
    z.toComplex.im = z.im := rfl
@[simp] theorem ChosenComplex.ofComplex_re (z : ℂ) :
    (ChosenComplex.ofComplex z).re = z.re := rfl
@[simp] theorem ChosenComplex.ofComplex_im (z : ℂ) :
    (ChosenComplex.ofComplex z).im = z.im := rfl

/-- Round-trip: `ofComplex` then `toComplex` is the identity on `ℂ`. -/
theorem ChosenComplex.toComplex_ofComplex (z : ℂ) :
    (ChosenComplex.ofComplex z).toComplex = z := by
  apply Complex.ext <;> rfl

/-- Round-trip: `toComplex` then `ofComplex` is the identity on `ChosenComplex`. -/
theorem ChosenComplex.ofComplex_toComplex (z : ChosenComplex) :
    ChosenComplex.ofComplex z.toComplex = z := by
  ext <;> rfl

/-- `toComplex` preserves multiplication:
    `ChosenComplex` multiplication agrees with `ℂ` multiplication. -/
theorem ChosenComplex.toComplex_mul (z w : ChosenComplex) :
    (z * w).toComplex = z.toComplex * w.toComplex := by
  apply Complex.ext <;> simp [Complex.mul_re, Complex.mul_im]

/-! ## Optional: additional toComplex compatibility lemmas -/

/-- `toComplex` preserves zero. -/
@[simp] theorem ChosenComplex.toComplex_zero :
    (0 : ChosenComplex).toComplex = 0 := by
  apply Complex.ext <;> rfl

/-- `toComplex` preserves one. -/
@[simp] theorem ChosenComplex.toComplex_one :
    (1 : ChosenComplex).toComplex = 1 := by
  apply Complex.ext <;> simp [ChosenComplex.toComplex]

/-- `toComplex` preserves addition. -/
theorem ChosenComplex.toComplex_add (z w : ChosenComplex) :
    (z + w).toComplex = z.toComplex + w.toComplex := by
  apply Complex.ext <;> simp [Complex.add_re, Complex.add_im]

/-- `toComplex` preserves negation. -/
theorem ChosenComplex.toComplex_neg (z : ChosenComplex) :
    (-z).toComplex = -z.toComplex := by
  apply Complex.ext <;> simp [ChosenComplex.toComplex]

/-- `toComplex` preserves subtraction. -/
theorem ChosenComplex.toComplex_sub (z w : ChosenComplex) :
    (z - w).toComplex = z.toComplex - w.toComplex := by
  apply Complex.ext <;> simp [ChosenComplex.toComplex, Complex.sub_re, Complex.sub_im]

end PhysicsSM.Algebra.Octonion
