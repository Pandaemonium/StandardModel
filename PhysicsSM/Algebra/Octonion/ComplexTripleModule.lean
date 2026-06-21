import Mathlib
import PhysicsSM.Algebra.Octonion.ComplexSplitting

/-!
# Algebra.Octonion.ComplexTripleModule

Complex-coordinate API for the complement `ℂ³` in the splitting `𝕆 = ℂ ⊕ ℂ³`.

## Mathematical context

The module `ComplexSplitting` defines a `ComplexTriple` structure with six real
fields `(w1_re, w1_im, w2_re, w2_im, w3_re, w3_im)` and shows that
left multiplication by `e111` acts as `(re, im) ↦ (-im, re)` on each pair —
i.e. as multiplication by `i`.

This module packages those facts into a reusable complex-coordinate API:

- `ComplexTriple.toComplexVec : ComplexTriple → Fin 3 → ℂ` and its inverse
  `ComplexTriple.ofComplexVec : (Fin 3 → ℂ) → ComplexTriple` form a
  bijection between `ComplexTriple` and `Fin 3 → ℂ`.

- `ComplexTriple.complexSmul : ℂ → ComplexTriple → ComplexTriple` defines
  coordinate-wise complex scalar multiplication.

- Key theorems connect the octonionic complex structure `J = L_{e111}` to
  multiplication by `Complex.I` in the `Fin 3 → ℂ` coordinates.

## Convention choices

All conventions follow `ComplexSplitting`:
- `w₁ = w1_re + i · w1_im`  (basis pair `e001, e110`)
- `w₂ = w2_re + i · w2_im`  (basis pair `e010, e101`)
- `w₃ = w3_re + i · w3_im`  (basis pair `e100, e011`)

The coordinate ordering is `Fin 3 = {0 ↦ w₁, 1 ↦ w₂, 2 ↦ w₃}`.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Convention: project XOR basis from `PhysicsSM.Algebra.Octonion.Basic`.

Status: trusted — no `s o r r y`.
-/

namespace PhysicsSM.Algebra.Octonion

/-! ## Complex-vector conversion -/

/-- Convert a `ComplexTriple` to a function `Fin 3 → ℂ`.
    Index 0 = w₁, 1 = w₂, 2 = w₃, using the convention
    `wₖ = wₖ_re + i · wₖ_im`. -/
noncomputable def ComplexTriple.toComplexVec
    (w : ComplexTriple) : Fin 3 → ℂ :=
  fun k => match k with
  | ⟨0, _⟩ => ⟨w.w1_re, w.w1_im⟩
  | ⟨1, _⟩ => ⟨w.w2_re, w.w2_im⟩
  | ⟨2, _⟩ => ⟨w.w3_re, w.w3_im⟩

/-- Convert a function `Fin 3 → ℂ` to a `ComplexTriple`.
    Index 0 = w₁, 1 = w₂, 2 = w₃, extracting real and imaginary parts. -/
noncomputable def ComplexTriple.ofComplexVec
    (v : Fin 3 → ℂ) : ComplexTriple :=
  ⟨(v ⟨0, by omega⟩).re, (v ⟨0, by omega⟩).im,
   (v ⟨1, by omega⟩).re, (v ⟨1, by omega⟩).im,
   (v ⟨2, by omega⟩).re, (v ⟨2, by omega⟩).im⟩

/-! ## Round-trip theorems -/

/-- Round-trip: `ofComplexVec ∘ toComplexVec = id`. -/
theorem ComplexTriple.ofComplexVec_toComplexVec (w : ComplexTriple) :
    ComplexTriple.ofComplexVec w.toComplexVec = w := by
  ext <;> simp [ofComplexVec, toComplexVec]

/-- Round-trip: `toComplexVec ∘ ofComplexVec = id`. -/
theorem ComplexTriple.toComplexVec_ofComplexVec (v : Fin 3 → ℂ) :
    (ComplexTriple.ofComplexVec v).toComplexVec = v := by
  ext k
  fin_cases k <;> simp [ofComplexVec, toComplexVec]

/-! ## Complex scalar multiplication -/

/-- Complex scalar multiplication on `ComplexTriple`, acting coordinate-wise:
    `(z · w)ₖ = z * wₖ` for each `k ∈ Fin 3`.

    Concretely, for `z = a + bi` and `wₖ = xₖ + yₖ i`:
    `(z · w)ₖ = (a·xₖ - b·yₖ) + (a·yₖ + b·xₖ)i`. -/
noncomputable def ComplexTriple.complexSmul
    (z : ℂ) (w : ComplexTriple) : ComplexTriple :=
  ⟨z.re * w.w1_re - z.im * w.w1_im,
   z.re * w.w1_im + z.im * w.w1_re,
   z.re * w.w2_re - z.im * w.w2_im,
   z.re * w.w2_im + z.im * w.w2_re,
   z.re * w.w3_re - z.im * w.w3_im,
   z.re * w.w3_im + z.im * w.w3_re⟩

/-- `complexSmul` acts as coordinate-wise complex multiplication in
    the `toComplexVec` coordinates. -/
theorem ComplexTriple.toComplexVec_complexSmul
    (z : ℂ) (w : ComplexTriple) :
    (ComplexTriple.complexSmul z w).toComplexVec =
      fun k => z * w.toComplexVec k := by
  ext k
  fin_cases k <;> simp [complexSmul, toComplexVec, Complex.ext_iff, Complex.mul_re, Complex.mul_im]

/-! ## J = L_{e111} acts as multiplication by i -/

/-- The octonionic complex structure `J = L_{e111}` acts as multiplication
    by `Complex.I` in the `toComplexVec` coordinates.

    That is, for any complement element `w`, applying `J` and reading off
    the complex coordinates gives `i * wₖ` for each `k`. -/
theorem ComplexTriple.toComplexVec_J
    (w : ComplexTriple) :
    ((e111 * w.toOctonion).toComplexTriple).toComplexVec =
      fun k => Complex.I * w.toComplexVec k := by
  ext k
  fin_cases k <;>
    simp [toComplexVec, toOctonion, Octonion.toComplexTriple,
          e111, Complex.ext_iff, Complex.I, Complex.mul_re, Complex.mul_im]

/-- `complexSmul` by `Complex.I` agrees with the octonionic complex structure
    `J = L_{e111}`, stated at the octonion level. -/
theorem ComplexTriple.complexSmul_I_eq_J
    (w : ComplexTriple) :
    (ComplexTriple.complexSmul Complex.I w).toOctonion =
      e111 * w.toOctonion := by
  ext <;> simp [complexSmul, Complex.I, toOctonion, e111]

/-! ## Structural lemmas for `toComplexVec` -/

/-- `toComplexVec` sends the zero triple to the zero function. -/
theorem ComplexTriple.toComplexVec_zero :
    (0 : ComplexTriple).toComplexVec = 0 := by
  ext k
  fin_cases k <;> simp [toComplexVec, Complex.ext_iff] <;> constructor <;> rfl

/-- `toComplexVec` is additive. -/
theorem ComplexTriple.toComplexVec_add (a b : ComplexTriple) :
    (⟨a.w1_re + b.w1_re, a.w1_im + b.w1_im,
      a.w2_re + b.w2_re, a.w2_im + b.w2_im,
      a.w3_re + b.w3_re, a.w3_im + b.w3_im⟩ : ComplexTriple).toComplexVec =
    fun k => a.toComplexVec k + b.toComplexVec k := by
  ext k
  fin_cases k <;> simp [toComplexVec, Complex.ext_iff, Complex.add_re, Complex.add_im]

/-- `toComplexVec` respects negation. -/
theorem ComplexTriple.toComplexVec_neg (w : ComplexTriple) :
    (⟨-w.w1_re, -w.w1_im, -w.w2_re, -w.w2_im,
      -w.w3_re, -w.w3_im⟩ : ComplexTriple).toComplexVec =
    fun k => -(w.toComplexVec k) := by
  ext k
  fin_cases k <;> simp [toComplexVec, Complex.ext_iff, Complex.neg_re, Complex.neg_im]

/-- `toComplexVec` respects real scalar multiplication:
    scaling by `r : ℝ` is the same as `complexSmul (r : ℂ)`. -/
theorem ComplexTriple.toComplexVec_realSmul (r : ℝ) (w : ComplexTriple) :
    (⟨r * w.w1_re, r * w.w1_im, r * w.w2_re, r * w.w2_im,
      r * w.w3_re, r * w.w3_im⟩ : ComplexTriple).toComplexVec =
    fun k => (r : ℂ) * w.toComplexVec k := by
  ext k
  fin_cases k <;> simp [toComplexVec, Complex.ext_iff, Complex.mul_re,
    Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im]

/-- `complexSmul` by `1` is the identity. -/
theorem ComplexTriple.complexSmul_one (w : ComplexTriple) :
    ComplexTriple.complexSmul 1 w = w := by
  ext <;> simp [complexSmul]

/-- `complexSmul` by `0` gives the zero triple. -/
theorem ComplexTriple.complexSmul_zero (w : ComplexTriple) :
    ComplexTriple.complexSmul 0 w = 0 := by
  simp only [complexSmul, Complex.zero_re, Complex.zero_im,
    zero_mul, sub_self, add_zero]
  rfl

/-- `complexSmul` is compatible with complex multiplication:
    `z₁ · (z₂ · w) = (z₁ * z₂) · w`. -/
theorem ComplexTriple.complexSmul_complexSmul
    (z₁ z₂ : ℂ) (w : ComplexTriple) :
    ComplexTriple.complexSmul z₁ (ComplexTriple.complexSmul z₂ w) =
      ComplexTriple.complexSmul (z₁ * z₂) w := by
  ext <;> simp [complexSmul, Complex.mul_re, Complex.mul_im] <;> ring

end PhysicsSM.Algebra.Octonion
